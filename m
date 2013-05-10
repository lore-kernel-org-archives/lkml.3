Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3EJO0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:26:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57379 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756149Ab3EJO0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:26:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Clemens Ladisch" <clemens@ladisch.de>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.107561278@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [029/118] ALSA: usb-audio: disable autopm for MIDI devices
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re-sending without the address-less name in Cc.]

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit cbc200bca4b51a8e2406d4b654d978f8503d430b upstream.

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
Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/midi.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -126,7 +126,6 @@ struct snd_usb_midi {
 		struct snd_usb_midi_in_endpoint *in;
 	} endpoints[MIDI_MAX_ENDPOINTS];
 	unsigned long input_triggered;
-	bool autopm_reference;
 	unsigned int opened[2];
 	unsigned char disconnected;
 	unsigned char input_running;
@@ -1040,7 +1039,6 @@ static int substream_open(struct snd_raw
 {
 	struct snd_usb_midi* umidi = substream->rmidi->private_data;
 	struct snd_kcontrol *ctl;
-	int err;
 
 	down_read(&umidi->disc_rwsem);
 	if (umidi->disconnected) {
@@ -1051,13 +1049,6 @@ static int substream_open(struct snd_raw
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
@@ -1080,8 +1071,6 @@ static int substream_open(struct snd_raw
 				snd_ctl_notify(umidi->card,
 				       SNDRV_CTL_EVENT_MASK_INFO, &ctl->id);
 			}
-			if (umidi->autopm_reference)
-				usb_autopm_put_interface(umidi->iface);
 		}
 	}
 	mutex_unlock(&umidi->mutex);
@@ -2256,6 +2245,8 @@ int snd_usbmidi_create(struct snd_card *
 		return err;
 	}
 
+	usb_autopm_get_interface_no_resume(umidi->iface);
+
 	list_add_tail(&umidi->list, midi_list);
 	return 0;
 }

