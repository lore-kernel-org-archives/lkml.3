Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3ERCW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:22:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30194 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab3ERCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:52 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=PCqYXf4xbkIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kjF_Nbhz2RMA:10 a=VwQbUJbxAAAA:8 a=f4bCHIJfGUkHEin19-cA:9 a=7t4jVOfIR2gA:10 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021649.659124953@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>
Subject: [ 049/136 ] ALSA: usb-audio: disable autopm for MIDI devices
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0049-ALSA-usb-audio-disable-autopm-for-MIDI-devices.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

[ Upstream commit cbc200bca4b51a8e2406d4b654d978f8503d430b ]

Commit 88a8516a2128 (ALSA: usbaudio: implement USB autosuspend)
introduced autopm for all USB audio/MIDI devices.  However, many MIDI
devices, such as synthesizers, do not merely transmit MIDI messages but
use their MIDI inputs to control other functions.  With autopm, these
devices would get powered down as soon as the last MIDI port device is
closed on the host.

Even some plain MIDI interfaces could get broken: they automatically
send Active Sensing messages while powered up, but as soon as these
messages cease, the receiving device would interpret this as an
accidental disconnection.

Commit f5f165418cab (ALSA: usb-audio: Fix missing autopm for MIDI input)
introduced another regression: some devices (e.g. the Roland GAIA SH-01)
are self-powered but do a reset whenever the USB interface's power state
changes.

To work around all this, just disable autopm for all USB MIDI devices.

Reported-by: Laurens Holst
Cc: <stable@vger.kernel.org>
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 sound/usb/midi.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/sound/usb/midi.c b/sound/usb/midi.c
index 084d1ba..d561e8c 100644
--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -125,7 +125,6 @@ struct snd_usb_midi {
 		struct snd_usb_midi_in_endpoint *in;
 	} endpoints[MIDI_MAX_ENDPOINTS];
 	unsigned long input_triggered;
-	bool autopm_reference;
 	unsigned int opened[2];
 	unsigned char disconnected;
 	unsigned char input_running;
@@ -1039,18 +1038,10 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 {
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
-	int err;
 
 	mutex_lock(&umidi->mutex);
 	if (open) {
 		if (!umidi->opened[0] && !umidi->opened[1]) {
-			err = usb_autopm_get_interface(umidi->iface);
-			umidi->autopm_reference = err >= 0;
-			if (err < 0 && err != -EACCES) {
-				mutex_unlock(&umidi->mutex);
-				up_read(&umidi->disc_rwsem);
-				return -EIO;
-			}
 			if (umidi->roland_load_ctl) {
 				ctl = umidi->roland_load_ctl;
 				ctl->vd[0].access |= SNDRV_CTL_ELEM_ACCESS_INACTIVE;
@@ -1073,8 +1064,6 @@ static int substream_open(struct snd_rawmidi_substream *substream, int dir,
 				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
 			}
-			if (umidi->autopm_reference)
-				usb_autopm_put_interface(umidi->iface);
 		}
 	}
 	mutex_unlock(&umidi->mutex);
@@ -2243,6 +2232,8 @@ int snd_usbmidi_create(struct snd_card *card,
 		return err;
 	}
 
+	usb_autopm_get_interface_no_resume(umidi->iface);
+
 	list_add_tail(&umidi->list, midi_list);
 	return 0;
 }
-- 
1.7.10.4


