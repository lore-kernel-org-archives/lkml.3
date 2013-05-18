Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3ERCS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:18:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab3ERCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:59 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3bC4PlcwEf0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3Wp929HF2voA:10 a=VwQbUJbxAAAA:8 a=xrzxy3i7KhNRffTyM_AA:9 a=0kPLrQdw3YYA:10 a=7t4jVOfIR2gA:10 a=jeBq3FmKZ4MA:10 a=nZeU1PyzKR3bVYbG:21 a=L4t5MuhOV8vExaZY:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021649.476363388@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 048/136 ] ALSA: usb-audio: Fix missing autopm for MIDI input
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0048-ALSA-usb-audio-Fix-missing-autopm-for-MIDI-input.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f5f165418cabf2218eb466c0e94693b8b1aee88b ]

The commit [88a8516a: ALSA: usbaudio: implement USB autosuspend] added
the support of autopm for USB MIDI output, but it didn't take the MIDI
input into account.

This patch adds the following for fixing the autopm:
- Manage the URB start at the first MIDI input stream open, instead of
  the time of instance creation
- Move autopm code to the common substream_open()
- Make snd_usbmidi_input_start/_stop() more robust and add the running
  state check

Reviewd-by: Clemens Ladisch <clemens@ladisch.de>
Tested-by: Clemens Ladisch <clemens@ladisch.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/midi.c |   78 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 33 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index eeefbce..084d1ba 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -125,8 +125,10 @@ struct snd_usb_midi {
 		struct snd_usb_midi_in_endpoint *in;
 	} endpoints[MIDI_MAX_ENDPOINTS];
 	unsigned long input_triggered;
-	unsigned int opened;
+	bool autopm_reference;
+	unsigned int opened[2];
 	unsigned char disconnected;
+	unsigned char input_running;
 
 	struct snd_kcontrol *roland_load_ctl;
 };
@@ -148,7 +150,6 @@ struct snd_usb_midi_out_endpoint {
 		struct snd_usb_midi_out_endpoint* ep;
 		struct snd_rawmidi_substream *substream;
 		int active;
-		bool autopm_reference;
 		uint8_t cable;		/* cable number << 4 */
 		uint8_t state;
 #define STATE_UNKNOWN	0
@@ -1033,29 +1034,51 @@ static void update_roland_altsetting(struct snd_usb_midi* umidi)
 	snd_usbmidi_input_start(&umidi->list);
 }
 
-static void substream_open(struct snd_rawmidi_substream *substream, int open)
+static int substream_open(struct snd_rawmidi_substream *substream, int dir,
+			  int open)
 {
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
+	int err;
 
 	mutex_lock(&umidi->mutex);
 	if (open) {
-		if (umidi->opened++ == 0 && umidi->roland_load_ctl) {
-			ctl = umidi->roland_load_ctl;
-			ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-			snd_ctl_notify(umidi->card,
+		if (!umidi->opened[0] && !umidi->opened[1]) {
+			err = usb_autopm_get_interface(umidi->iface);
+			umidi->autopm_reference = err >= 0;
+			if (err < 0 && err != -EACCES) {
+				mutex_unlock(&umidi->mutex);
+				up_read(&umidi->disc_rwsem);
+				return -EIO;
+			}
+			if (umidi->roland_load_ctl) {
+				ctl = umidi->roland_load_ctl;
+				ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
-			update_roland_altsetting(umidi);
+				update_roland_altsetting(umidi);
+			}
 		}
+		umidi->opened[dir]++;
+		if (umidi->opened[1])
+			snd_usbmidi_input_start(&umidi->list);
 	} else {
-		if (--umidi->opened == 0 && umidi->roland_load_ctl) {
-			ctl = umidi->roland_load_ctl;
-			ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
-			snd_ctl_notify(umidi->card,
+		umidi->opened[dir]--;
+		if (!umidi->opened[1])
+			snd_usbmidi_input_stop(&umidi->list);
+		if (!umidi->opened[0] && !umidi->opened[1]) {
+			if (umidi->roland_load_ctl) {
+				ctl = umidi->roland_load_ctl;
+				ctl->vd[0].access &= ~SNDRV_CTL_ELEM_ACCESS_INACTIVE;
+				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
+			}
+			if (umidi->autopm_reference)
+				usb_autopm_put_interface(umidi->iface);
 		}
 	}
 	mutex_unlock(&umidi->mutex);
+	return 0;
 }
 
 static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
@@ -1063,7 +1086,6 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct usbmidi_out_port* port = NULL;
 	int i, j;
-	int err;
 
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		if (umidi->endpoints[i].out)
@@ -1076,25 +1098,14 @@ static int snd_usbmidi_output_open(struct snd_rawmidi_substream *substream)
 		snd_BUG();
 		return -ENXIO;
 	}
-	err = usb_autopm_get_interface(umidi->iface);
-	port->autopm_reference = err >= 0;
-	if (err < 0 && err != -EACCES)
-		return -EIO;
 	substream->runtime->private_data = port;
 	port->state = STATE_UNKNOWN;
-	substream_open(substream, 1);
-	return 0;
+	return substream_open(substream, 0, 1);
 }
 
 static int snd_usbmidi_output_close(struct snd_rawmidi_substream *substream)
 {
-	struct snd_usb_midi* umidi = substream->rmidi->private_data;
-	struct usbmidi_out_port *port = substream->runtime->private_data;
-
-	substream_open(substream, 0);
-	if (port->autopm_reference)
-		usb_autopm_put_interface(umidi->iface);
-	return 0;
+	return substream_open(substream, 0, 0);
 }
 
 static void snd_usbmidi_output_trigger(struct snd_rawmidi_substream *substream, int up)
@@ -1147,14 +1158,12 @@ static void snd_usbmidi_output_drain(struct snd_rawmidi_substream *substream)
 
 static int snd_usbmidi_input_open(struct snd_rawmidi_substream *substream)
 {
-	substream_open(substream, 1);
-	return 0;
+	return substream_open(substream, 1, 1);
 }
 
 static int snd_usbmidi_input_close(struct snd_rawmidi_substream *substream)
 {
-	substream_open(substream, 0);
-	return 0;
+	return substream_open(substream, 1, 0);
 }
 
 static void snd_usbmidi_input_trigger(struct snd_rawmidi_substream *substream, int up)
@@ -2060,12 +2069,15 @@ void snd_usbmidi_input_stop(struct list_head* p)
 	unsigned int i, j;
 
 	umidi = list_entry(p, struct snd_usb_midi, list);
+	if (!umidi->input_running)
+		return;
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i) {
 		struct snd_usb_midi_endpoint* ep = &umidi->endpoints[i];
 		if (ep->in)
 			for (j = 0; j < INPUT_URBS; ++j)
 				usb_kill_urb(ep->in->urbs[j]);
 	}
+	umidi->input_running = 0;
 }
 
 static void snd_usbmidi_input_start_ep(struct snd_usb_midi_in_endpoint* ep)
@@ -2090,8 +2102,11 @@ void snd_usbmidi_input_start(struct list_head* p)
 	int i;
 
 	umidi = list_entry(p, struct snd_usb_midi, list);
+	if (umidi->input_running || !umidi->opened[1])
+		return;
 	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
 		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
+	umidi->input_running = 1;
 }
 
 /*
@@ -2229,9 +2244,6 @@ int snd_usbmidi_create(struct snd_card *card,
 	}
 
 	list_add_tail(&umidi->list, midi_list);
-
-	for (i = 0; i < MIDI_MAX_ENDPOINTS; ++i)
-		snd_usbmidi_input_start_ep(umidi->endpoints[i].in);
 	return 0;
 }
 
-- 
1.7.10.4


