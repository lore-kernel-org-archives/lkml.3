Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaBJTmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:42:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34644 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaBJTmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:42:47 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 047/124] [media] media: s5p_mfc: remove s5p_mfc_get_node_type() function
Date: Mon, 10 Feb 2014 11:39:47 -0800
Message-Id: <1392061264-28124-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit b80cb8dc4162bc954cc71efec192ed89f2061573 upstream.

s5p_mfc_get_node_type() relies on get_index() helper function, which in
turn relies on video_device index numbers assigned on driver
registration. All this code is not really needed, because there is
already access to respective video_device structures via common
s5p_mfc_dev structure. This fixes the issues introduced by patch
1056e4388b0454917a512618c8416a98628fc9ce ("v4l2-dev: Fix race condition
on __video_register_device"), which has been merged in v3.12-rc1.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        | 28 +++++++------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  9 --------
 2 files changed, 7 insertions(+), 30 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 681bc6b..1c30a63 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -176,21 +176,6 @@ unlock:
 		mutex_unlock(&dev->mfc_mutex);
 }
 
-static enum s5p_mfc_node_type s5p_mfc_get_node_type(struct file *file)
-{
-	struct video_device *vdev = video_devdata(file);
-
-	if (!vdev) {
-		mfc_err("failed to get video_device");
-		return MFCNODE_INVALID;
-	}
-	if (vdev->index == 0)
-		return MFCNODE_DECODER;
-	else if (vdev->index == 1)
-		return MFCNODE_ENCODER;
-	return MFCNODE_INVALID;
-}
-
 static void s5p_mfc_clear_int_flags(struct s5p_mfc_dev *dev)
 {
 	mfc_write(dev, 0, S5P_FIMV_RISC_HOST_INT);
@@ -700,6 +685,7 @@ irq_cleanup_hw:
 /* Open an MFC node */
 static int s5p_mfc_open(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = NULL;
 	struct vb2_queue *q;
@@ -737,7 +723,7 @@ static int s5p_mfc_open(struct file *file)
 	/* Mark context as idle */
 	clear_work_bit_irqsave(ctx);
 	dev->ctx[ctx->num] = ctx;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		ctx->type = MFCINST_DECODER;
 		ctx->c_ops = get_dec_codec_ops();
 		s5p_mfc_dec_init(ctx);
@@ -747,7 +733,7 @@ static int s5p_mfc_open(struct file *file)
 			mfc_err("Failed to setup mfc controls\n");
 			goto err_ctrls_setup;
 		}
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		ctx->type = MFCINST_ENCODER;
 		ctx->c_ops = get_enc_codec_ops();
 		/* only for encoder */
@@ -790,10 +776,10 @@ static int s5p_mfc_open(struct file *file)
 	q = &ctx->vq_dst;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
 	q->drv_priv = &ctx->fh;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		q->io_modes = VB2_MMAP | VB2_USERPTR;
 		q->ops = get_enc_queue_ops();
 	} else {
@@ -811,10 +797,10 @@ static int s5p_mfc_open(struct file *file)
 	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
 	q->io_modes = VB2_MMAP;
 	q->drv_priv = &ctx->fh;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		q->io_modes = VB2_MMAP;
 		q->ops = get_dec_queue_ops();
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		q->io_modes = VB2_MMAP | VB2_USERPTR;
 		q->ops = get_enc_queue_ops();
 	} else {
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index f02e049..fb6629d 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -113,15 +113,6 @@ enum s5p_mfc_fmt_type {
 };
 
 /**
- * enum s5p_mfc_node_type - The type of an MFC device node.
- */
-enum s5p_mfc_node_type {
-	MFCNODE_INVALID = -1,
-	MFCNODE_DECODER = 0,
-	MFCNODE_ENCODER = 1,
-};
-
-/**
  * enum s5p_mfc_inst_type - The type of an MFC instance.
  */
 enum s5p_mfc_inst_type {
-- 
1.8.3.2

