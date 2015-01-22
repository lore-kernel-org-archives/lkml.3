Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbbAVWVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:21:04 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:48420 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbbAVWUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:46 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 02/15] media: blackfin: bfin_capture: release buffers in case start_streaming() call back fails
Date: Thu, 22 Jan 2015 22:18:35 +0000
Message-Id: <1421965128-10470-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
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
2.1.0

