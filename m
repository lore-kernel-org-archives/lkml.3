Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965031AbaDJDoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:44:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935055AbaDJDWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Torsten Schenk <torsten.schenk@zoho.com>, Takashi Iwai <tiwai@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 107/134] ALSA: 6fire: make buffers DMA-able (pcm)
Date: Wed,  9 Apr 2014 20:23:43 -0700
Message-Id: <20140410032313.545913978@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Torsten Schenk <torsten.schenk@zoho.com>

commit 5ece263f1d93fba8d992e67e3ab8a71acf674db9 upstream.

Patch makes pcm buffers DMA-able by allocating each one separately.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/6fire/pcm.c |   41 ++++++++++++++++++++++++++++++++++++++++-
 sound/usb/6fire/pcm.h |    2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -578,6 +578,33 @@ static void __devinit usb6fire_pcm_init_
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
@@ -589,6 +616,13 @@ int __devinit usb6fire_pcm_init(struct s
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
@@ -610,6 +644,7 @@ int __devinit usb6fire_pcm_init(struct s
 
 	ret = snd_pcm_new(chip->card, "DMX6FireUSB", 0, 1, 1, &pcm);
 	if (ret < 0) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create pcm instance.\n");
 		return ret;
@@ -625,6 +660,7 @@ int __devinit usb6fire_pcm_init(struct s
 			snd_dma_continuous_data(GFP_KERNEL),
 			MAX_BUFSIZE, MAX_BUFSIZE);
 	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX
 				"error preallocating pcm buffers.\n");
@@ -669,6 +705,9 @@ void usb6fire_pcm_abort(struct sfire_chi
 
 void usb6fire_pcm_destroy(struct sfire_chip *chip)
 {
-	kfree(chip->pcm);
+	struct pcm_runtime *rt = chip->pcm;
+
+	usb6fire_pcm_buffers_destroy(rt);
+	kfree(rt);
 	chip->pcm = NULL;
 }
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


