Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab3IBJMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:12:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37669 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab3IBIzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 11/58] ALSA: 6fire: make buffers DMA-able (pcm)
Date: Mon,  2 Sep 2013 09:53:56 +0100
Message-Id: <1378112083-9475-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Schenk <torsten.schenk@zoho.com>

commit 5ece263f1d93fba8d992e67e3ab8a71acf674db9 upstream.

Patch makes pcm buffers DMA-able by allocating each one separately.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/6fire/pcm.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 sound/usb/6fire/pcm.h |  2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/sound/usb/6fire/pcm.c b/sound/usb/6fire/pcm.c
index 7c4f311..51e3f62f 100644
--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -578,6 +578,33 @@ static void __devinit usb6fire_pcm_init_urb(struct pcm_urb *urb,
 	urb->instance.number_of_packets = PCM_N_PACKETS_PER_URB;
 }
 
+static int usb6fire_pcm_buffers_init(struct pcm_runtime *rt)
+{
+	int i;
+
+	for (i = 0; i < PCM_N_URBS; i++) {
+		rt->out_urbs[i].buffer = kzalloc(PCM_N_PACKETS_PER_URB
+				* PCM_MAX_PACKET_SIZE, GFP_KERNEL);
+		if (!rt->out_urbs[i].buffer)
+			return -ENOMEM;
+		rt->in_urbs[i].buffer = kzalloc(PCM_N_PACKETS_PER_URB
+				* PCM_MAX_PACKET_SIZE, GFP_KERNEL);
+		if (!rt->in_urbs[i].buffer)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
+static void usb6fire_pcm_buffers_destroy(struct pcm_runtime *rt)
+{
+	int i;
+
+	for (i = 0; i < PCM_N_URBS; i++) {
+		kfree(rt->out_urbs[i].buffer);
+		kfree(rt->in_urbs[i].buffer);
+	}
+}
+
 int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 {
 	int i;
@@ -589,6 +616,13 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 	if (!rt)
 		return -ENOMEM;
 
+	ret = usb6fire_pcm_buffers_init(rt);
+	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
+		kfree(rt);
+		return ret;
+	}
+
 	rt->chip = chip;
 	rt->stream_state = STREAM_DISABLED;
 	rt->rate = ARRAY_SIZE(rates);
@@ -610,6 +644,7 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 
 	ret = snd_pcm_new(chip->card, "DMX6FireUSB", 0, 1, 1, &pcm);
 	if (ret < 0) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create pcm instance.\n");
 		return ret;
@@ -625,6 +660,7 @@ int __devinit usb6fire_pcm_init(struct sfire_chip *chip)
 			snd_dma_continuous_data(GFP_KERNEL),
 			MAX_BUFSIZE, MAX_BUFSIZE);
 	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX
 				"error preallocating pcm buffers.\n");
@@ -669,6 +705,9 @@ void usb6fire_pcm_abort(struct sfire_chip *chip)
 
 void usb6fire_pcm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->pcm);
+	struct pcm_runtime *rt = chip->pcm;
+
+	usb6fire_pcm_buffers_destroy(rt);
+	kfree(rt);
 	chip->pcm = NULL;
 }
diff --git a/sound/usb/6fire/pcm.h b/sound/usb/6fire/pcm.h
index 3104301..84610cf 100644
--- a/sound/usb/6fire/pcm.h
+++ b/sound/usb/6fire/pcm.h
@@ -32,7 +32,7 @@ struct pcm_urb {
 	struct urb instance;
 	struct usb_iso_packet_descriptor packets[PCM_N_PACKETS_PER_URB];
 	/* END DO NOT SEPARATE */
-	u8 buffer[PCM_N_PACKETS_PER_URB * PCM_MAX_PACKET_SIZE];
+	u8 *buffer;
 
 	struct pcm_urb *peer;
 };
-- 
1.8.3.2

