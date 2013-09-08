Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899Ab3IHDkh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:40:37 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717Ab3IHDTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:17 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Torsten Schenk" <torsten.schenk@zoho.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.811279630@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [066/121] ALSA: 6fire: make buffers DMA-able (midi)
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Schenk <torsten.schenk@zoho.com>

commit 4c2aee0032b70083dafebd733ed9c774633b2fa3 upstream.

Patch makes midi output buffer DMA-able by allocating it separately.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/6fire/midi.c | 16 +++++++++++++++-
 sound/usb/6fire/midi.h |  6 +-----
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/sound/usb/6fire/midi.c
+++ b/sound/usb/6fire/midi.c
@@ -20,6 +20,10 @@
 #include "chip.h"
 #include "comm.h"
 
+enum {
+	MIDI_BUFSIZE = 64
+};
+
 static void usb6fire_midi_out_handler(struct urb *urb)
 {
 	struct midi_runtime *rt = urb->context;
@@ -157,6 +161,12 @@ int __devinit usb6fire_midi_init(struct
 	if (!rt)
 		return -ENOMEM;
 
+	rt->out_buffer = kzalloc(MIDI_BUFSIZE, GFP_KERNEL);
+	if (!rt->out_buffer) {
+		kfree(rt);
+		return -ENOMEM;
+	}
+
 	rt->chip = chip;
 	rt->in_received = usb6fire_midi_in_received;
 	rt->out_buffer[0] = 0x80; /* 'send midi' command */
@@ -170,6 +180,7 @@ int __devinit usb6fire_midi_init(struct
 
 	ret = snd_rawmidi_new(chip->card, "6FireUSB", 0, 1, 1, &rt->instance);
 	if (ret < 0) {
+		kfree(rt->out_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "unable to create midi.\n");
 		return ret;
@@ -198,6 +209,9 @@ void usb6fire_midi_abort(struct sfire_ch
 
 void usb6fire_midi_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->midi);
+	struct midi_runtime *rt = chip->midi;
+
+	kfree(rt->out_buffer);
+	kfree(rt);
 	chip->midi = NULL;
 }
--- a/sound/usb/6fire/midi.h
+++ b/sound/usb/6fire/midi.h
@@ -17,10 +17,6 @@
 
 #include "common.h"
 
-enum {
-	MIDI_BUFSIZE = 64
-};
-
 struct midi_runtime {
 	struct sfire_chip *chip;
 	struct snd_rawmidi *instance;
@@ -33,7 +29,7 @@ struct midi_runtime {
 	struct snd_rawmidi_substream *out;
 	struct urb out_urb;
 	u8 out_serial; /* serial number of out packet */
-	u8 out_buffer[MIDI_BUFSIZE];
+	u8 *out_buffer;
 	int buffer_offset;
 
 	void (*in_received)(struct midi_runtime *rt, u8 *data, int length);

