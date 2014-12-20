Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867AbaLTKsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:48:16 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50526 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbaLTKsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:12 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 02/15] media: blackfin: bfin_capture: release buffers in case start_streaming() call back fails
Date: Sat, 20 Dec 2014 16:17:29 +0530
Message-Id: <1419072462-3168-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support to release the buffer by calling
vb2_buffer_done(), with state marked as VB2_BUF_STATE_QUEUED
if start_streaming() call back fails.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index d4eeae9..80463fa 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -345,6 +345,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 	struct ppi_if *ppi = bcap_dev->ppi;
+	struct bcap_buffer *buf, *tmp;
 	struct ppi_params params;
 	int ret;
 
@@ -352,7 +353,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	ret = v4l2_subdev_call(bcap_dev->sd, video, s_stream, 1);
 	if (ret && (ret != -ENOIOCTLCMD)) {
 		v4l2_err(&bcap_dev->v4l2_dev, "stream on failed in subdev\n");
-		return ret;
+		goto err;
 	}
 
 	/* set ppi params */
@@ -391,7 +392,7 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0) {
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"Error in setting ppi params\n");
-		return ret;
+		goto err;
 	}
 
 	/* attach ppi DMA irq handler */
@@ -399,12 +400,21 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (ret < 0) {
 		v4l2_err(&bcap_dev->v4l2_dev,
 				"Error in attaching interrupt handler\n");
-		return ret;
+		goto err;
 	}
 
 	reinit_completion(&bcap_dev->comp);
 	bcap_dev->stop = false;
+
 	return 0;
+
+err:
+	list_for_each_entry_safe(buf, tmp, &bcap_dev->dma_queue, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+
+	return ret;
 }
 
 static void bcap_stop_streaming(struct vb2_queue *vq)
-- 
1.9.1

