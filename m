Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaLTKs1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:48:27 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:34341 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbaLTKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:48:24 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 05/15] media: blackfin: bfin_capture: improve queue_setup() callback
Date: Sat, 20 Dec 2014 16:17:32 +0530
Message-Id: <1419072462-3168-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1419072462-3168-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch improves the queue_setup() callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8bd94a1..76d42bb 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -44,7 +44,6 @@
 #include <media/blackfin/ppi.h>
 
 #define CAPTURE_DRV_NAME        "bfin_capture"
-#define BCAP_MIN_NUM_BUF        2
 
 struct bcap_format {
 	char *desc;
@@ -292,11 +291,14 @@ static int bcap_queue_setup(struct vb2_queue *vq,
 {
 	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
 
-	if (*nbuffers < BCAP_MIN_NUM_BUF)
-		*nbuffers = BCAP_MIN_NUM_BUF;
+	if (fmt && fmt->fmt.pix.sizeimage < bcap_dev->fmt.sizeimage)
+		return -EINVAL;
+
+	if (vq->num_buffers + *nbuffers < 3)
+		*nbuffers = 3 - vq->num_buffers;
 
 	*nplanes = 1;
-	sizes[0] = bcap_dev->fmt.sizeimage;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : bcap_dev->fmt.sizeimage;
 	alloc_ctxs[0] = bcap_dev->alloc_ctx;
 
 	return 0;
-- 
1.9.1

