Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760391Ab3ICQg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:36:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46441 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab3ICQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 09/58] ALSA: 6fire: make buffers DMA-able (midi)
Date: Tue,  3 Sep 2013 09:23:13 -0700
Message-Id: <1378225442-20654-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Schenk <torsten.schenk@zoho.com>

commit 4c2aee0032b70083dafebd733ed9c774633b2fa3 upstream.

Patch makes midi output buffer DMA-able by allocating it separately.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/6fire/midi.c | 16 +++++++++++++++-
 sound/usb/6fire/midi.h |  6 +-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/sound/usb/6fire/midi.c b/sound/usb/6fire/midi.c
index 2672242..f3dd726 100644
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
@@ -156,6 +160,12 @@ int usb6fire_midi_init(struct sfire_chip *chip)
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
@@ -169,6 +179,7 @@ int usb6fire_midi_init(struct sfire_chip *chip)
 
 	ret = snd_rawmidi_new(chip->card, "6FireUSB", 0, 1, 1, &rt->instance);
 	if (ret < 0) {
+		kfree(rt->out_buffer);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "unable to create midi.\n");
 		return ret;
@@ -197,6 +208,9 @@ void usb6fire_midi_abort(struct sfire_chip *chip)
 
 void usb6fire_midi_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->midi);
+	struct midi_runtime *rt = chip->midi;
+
+	kfree(rt->out_buffer);
+	kfree(rt);
 	chip->midi = NULL;
 }
diff --git a/sound/usb/6fire/midi.h b/sound/usb/6fire/midi.h
index c321006..84851b9 100644
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
-- 
1.8.1.2

