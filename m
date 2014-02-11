Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaBKUEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:04:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40076 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbaBKTGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kamil Debski <k.debski@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.12 065/107] [media] media: s5p_mfc: remove s5p_mfc_get_node_type() function
Date: Tue, 11 Feb 2014 11:05:31 -0800
Message-Id: <20140211184750.050688419@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |   28 ++++++------------------
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    9 -------
 2 files changed, 7 insertions(+), 30 deletions(-)

--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -177,21 +177,6 @@ unlock:
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
@@ -701,6 +686,7 @@ irq_cleanup_hw:
 /* Open an MFC node */
 static int s5p_mfc_open(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 	struct s5p_mfc_ctx *ctx = NULL;
 	struct vb2_queue *q;
@@ -738,7 +724,7 @@ static int s5p_mfc_open(struct file *fil
 	/* Mark context as idle */
 	clear_work_bit_irqsave(ctx);
 	dev->ctx[ctx->num] = ctx;
-	if (s5p_mfc_get_node_type(file) == MFCNODE_DECODER) {
+	if (vdev == dev->vfd_dec) {
 		ctx->type = MFCINST_DECODER;
 		ctx->c_ops = get_dec_codec_ops();
 		s5p_mfc_dec_init(ctx);
@@ -748,7 +734,7 @@ static int s5p_mfc_open(struct file *fil
 			mfc_err("Failed to setup mfc controls\n");
 			goto err_ctrls_setup;
 		}
-	} else if (s5p_mfc_get_node_type(file) == MFCNODE_ENCODER) {
+	} else if (vdev == dev->vfd_enc) {
 		ctx->type = MFCINST_ENCODER;
 		ctx->c_ops = get_enc_codec_ops();
 		/* only for encoder */
@@ -793,10 +779,10 @@ static int s5p_mfc_open(struct file *fil
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
@@ -815,10 +801,10 @@ static int s5p_mfc_open(struct file *fil
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
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -115,15 +115,6 @@ enum s5p_mfc_fmt_type {
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


