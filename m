Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbbARBpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 20:45:04 -0500
Received: from www.osadl.org ([62.245.132.105]:33488 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbbARBpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 20:45:01 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Jingoo Han <jg1.han@samsung.com>, Denis Carikli <denis@eukrea.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] video: mx3fb: fix up wait_for_completion_timeout return handling
Date: Sun, 18 Jan 2015 02:37:02 +0100
Message-Id: <1421545022-24017-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
return type of wait_for_completion_timeout is unsigned long as ret is 
used only for checking wait_for_completion_timeout here the type was
changed to unsigned long, wait_for_completion_timeout return >= 0 only
so the checks for negative return canbe dropped.

This patch was only compiletested using imx_v4_v5_defconfig                     

Patch is against 3.19.0-rc4 -next-20150116

 drivers/video/fbdev/mx3fb.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/mx3fb.c b/drivers/video/fbdev/mx3fb.c
index 7947634..523134f 100644
--- a/drivers/video/fbdev/mx3fb.c
+++ b/drivers/video/fbdev/mx3fb.c
@@ -1144,7 +1144,7 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 	struct scatterlist *sg = mx3_fbi->sg;
 	struct dma_chan *dma_chan = &mx3_fbi->idmac_channel->dma_chan;
 	struct dma_async_tx_descriptor *txd;
-	int ret;
+	unsigned long ret;
 
 	dev_dbg(fbi->device, "%s [%c]\n", __func__,
 		list_empty(&mx3_fbi->idmac_channel->queue) ? '-' : '+');
@@ -1184,12 +1184,11 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 	enable_irq(mx3_fbi->idmac_channel->eof_irq);
 
 	ret = wait_for_completion_timeout(&mx3_fbi->flip_cmpl, HZ / 10);
-	if (ret <= 0) {
+	if (ret == 0) {
 		mutex_unlock(&mx3_fbi->mutex);
-		dev_info(fbi->device, "Panning failed due to %s\n", ret < 0 ?
-			 "user interrupt" : "timeout");
+		dev_info(fbi->device, "Panning failed due to timeout\n");
 		disable_irq(mx3_fbi->idmac_channel->eof_irq);
-		return ret ? : -ETIMEDOUT;
+		return -ETIMEDOUT;
 	}
 
 	mx3_fbi->cur_ipu_buf = !mx3_fbi->cur_ipu_buf;
-- 
1.7.10.4

