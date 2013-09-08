Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3IHDnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:43:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56024 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711Ab3IHDTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Torsten Schenk" <torsten.schenk@zoho.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.65468940@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [065/121] ALSA: 6fire: make buffers DMA-able (pcm)
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

commit 5ece263f1d93fba8d992e67e3ab8a71acf674db9 upstream.

Patch makes pcm buffers DMA-able by allocating each one separately.

Signed-off-by: Torsten Schenk <torsten.schenk@zoho.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/usb/6fire/pcm.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 sound/usb/6fire/pcm.h |  2 +-
 2 files changed, 41 insertions(+), 2 deletions(-)

--- a/sound/usb/6fire/pcm.c
+++ b/sound/usb/6fire/pcm.c
@@ -579,6 +579,33 @@ static void __devinit usb6fire_pcm_init_
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
@@ -590,6 +617,13 @@ int __devinit usb6fire_pcm_init(struct s
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
@@ -611,6 +645,7 @@ int __devinit usb6fire_pcm_init(struct s
 
 	ret = snd_pcm_new(chip->card, "DMX6FireUSB", 0, 1, 1, &pcm);
 	if (ret < 0) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX "cannot create pcm instance.\n");
 		return ret;
@@ -626,6 +661,7 @@ int __devinit usb6fire_pcm_init(struct s
 			snd_dma_continuous_data(GFP_KERNEL),
 			MAX_BUFSIZE, MAX_BUFSIZE);
 	if (ret) {
+		usb6fire_pcm_buffers_destroy(rt);
 		kfree(rt);
 		snd_printk(KERN_ERR PREFIX
 				"error preallocating pcm buffers.\n");
@@ -670,6 +706,9 @@ void usb6fire_pcm_abort(struct sfire_chi
 
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
@@ -33,7 +33,7 @@ struct pcm_urb {
 	struct urb instance;
 	struct usb_iso_packet_descriptor packets[PCM_N_PACKETS_PER_URB];
 	/* END DO NOT SEPARATE */
-	u8 buffer[PCM_N_PACKETS_PER_URB * PCM_MAX_PACKET_SIZE];
+	u8 *buffer;
 
 	struct pcm_urb *peer;
 };

