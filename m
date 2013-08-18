Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3HRUnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:43:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43676 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756387Ab3HRUfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 25/45] ALSA: 6fire: make buffers DMA-able (midi)
Date: Sun, 18 Aug 2013 13:36:14 -0700
Message-Id: <20130818203622.751615025@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Schenk <torsten.schenk@zoho.com>

commit 4c2aee0032b70083dafebd733ed9c774633b2fa3 upstream.

Patch makes midi output buffer DMA-able by allocating it separately.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/6fire/midi.c |   16 +++++++++++++++-
 sound/usb/6fire/midi.h |    6 +-----
 2 files changed, 16 insertions(+), 6 deletions(-)

--- a/sound/usb/6fire/midi.c
+++ b/sound/usb/6fire/midi.c
@@ -19,6 +19,10 @@
 #include "chip.h"
 #include "comm.h"
 
+enum {
+	MIDI_BUFSIZE = 64
+};
+
 static void usb6fire_midi_out_handler(struct urb *urb)
 {
 	struct midi_runtime *rt = urb->context;
@@ -156,6 +160,12 @@ int usb6fire_midi_init(struct sfire_chip
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
@@ -169,6 +179,7 @@ int usb6fire_midi_init(struct sfire_chip
 
 	ret = snd_rawmidi_new(chip->card, "6FireUSB", 0, 1, 1, &rt->instance);
 	if (ret < 0) {
+		kfree(rt->out_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "unable to create midi.\n");
 		return ret;
@@ -197,6 +208,9 @@ void usb6fire_midi_abort(struct sfire_ch
 
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
@@ -16,10 +16,6 @@
 
 #include "common.h"
 
-enum {
-	MIDI_BUFSIZE = 64
-};
-
 struct midi_runtime {
 	struct sfire_chip *chip;
 	struct snd_rawmidi *instance;
@@ -32,7 +28,7 @@ struct midi_runtime {
 	struct snd_rawmidi_substream *out;
 	struct urb out_urb;
 	u8 out_serial; /* serial number of out packet */
-	u8 out_buffer[MIDI_BUFSIZE];
+	u8 *out_buffer;
 	int buffer_offset;
 
 	void (*in_received)(struct midi_runtime *rt, u8 *data, int length);


