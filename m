Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbbAVWVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:21:16 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40718 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbbAVWUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:50 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 05/15] media: blackfin: bfin_capture: improve queue_setup() callback
Date: Thu, 22 Jan 2015 22:18:38 +0000
Message-Id: <1421965128-10470-6-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch improves the queue_setup() callback.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8bd94a1..0d8593b 100644
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
+	if (vq->num_buffers + *nbuffers < 2)
+		*nbuffers = 2;
 
 	*nplanes = 1;
-	sizes[0] = bcap_dev->fmt.sizeimage;
+	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : bcap_dev->fmt.sizeimage;
 	alloc_ctxs[0] = bcap_dev->alloc_ctx;
 
 	return 0;
-- 
2.1.0

