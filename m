Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbbAVWVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:21:23 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60729 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbAVWUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:20:53 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        adi-buildroot-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 07/15] media: blackfin: bfin_capture: use v4l2_fh_open and vb2_fop_release
Date: Thu, 22 Jan 2015 22:18:40 +0000
Message-Id: <1421965128-10470-8-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1421965128-10470-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds support to use v4l2_fh_open() and vb2_fop_release,
which allows to drop driver specific struct bcap_fh, as this is handled
by core.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/blackfin/bfin_capture.c | 79 +-------------------------
 1 file changed, 2 insertions(+), 77 deletions(-)

diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 8ddff32..b2eeace 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -105,12 +105,6 @@ struct bcap_device {
 	bool stop;
 };
 
-struct bcap_fh {
-	struct v4l2_fh fh;
-	/* indicates whether this file handle is doing IO */
-	bool io_allowed;
-};
-
 static const struct bcap_format bcap_formats[] = {
 	{
 		.desc        = "YCbCr 4:2:2 Interleaved UYVY",
@@ -200,50 +194,6 @@ static void bcap_free_sensor_formats(struct bcap_device *bcap_dev)
 	bcap_dev->sensor_formats = NULL;
 }
 
-static int bcap_open(struct file *file)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct video_device *vfd = bcap_dev->video_dev;
-	struct bcap_fh *bcap_fh;
-
-	if (!bcap_dev->sd) {
-		v4l2_err(&bcap_dev->v4l2_dev, "No sub device registered\n");
-		return -ENODEV;
-	}
-
-	bcap_fh = kzalloc(sizeof(*bcap_fh), GFP_KERNEL);
-	if (!bcap_fh) {
-		v4l2_err(&bcap_dev->v4l2_dev,
-			 "unable to allocate memory for file handle object\n");
-		return -ENOMEM;
-	}
-
-	v4l2_fh_init(&bcap_fh->fh, vfd);
-
-	/* store pointer to v4l2_fh in private_data member of file */
-	file->private_data = &bcap_fh->fh;
-	v4l2_fh_add(&bcap_fh->fh);
-	bcap_fh->io_allowed = false;
-	return 0;
-}
-
-static int bcap_release(struct file *file)
-{
-	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct v4l2_fh *fh = file->private_data;
-	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
-
-	/* if this instance is doing IO */
-	if (bcap_fh->io_allowed)
-		vb2_queue_release(&bcap_dev->buffer_queue);
-
-	file->private_data = NULL;
-	v4l2_fh_del(&bcap_fh->fh);
-	v4l2_fh_exit(&bcap_fh->fh);
-	kfree(bcap_fh);
-	return 0;
-}
-
 #ifndef CONFIG_MMU
 static unsigned long bcap_get_unmapped_area(struct file *file,
 					    unsigned long addr,
@@ -432,13 +382,6 @@ static int bcap_reqbufs(struct file *file, void *priv,
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 	struct vb2_queue *vq = &bcap_dev->buffer_queue;
-	struct v4l2_fh *fh = file->private_data;
-	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
-
-	if (vb2_is_busy(vq))
-		return -EBUSY;
-
-	bcap_fh->io_allowed = true;
 
 	return vb2_reqbufs(vq, req_buf);
 }
@@ -455,11 +398,6 @@ static int bcap_qbuf(struct file *file, void *priv,
 			struct v4l2_buffer *buf)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct v4l2_fh *fh = file->private_data;
-	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
-
-	if (!bcap_fh->io_allowed)
-		return -EBUSY;
 
 	return vb2_qbuf(&bcap_dev->buffer_queue, buf);
 }
@@ -468,11 +406,6 @@ static int bcap_dqbuf(struct file *file, void *priv,
 			struct v4l2_buffer *buf)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct v4l2_fh *fh = file->private_data;
-	struct bcap_fh *bcap_fh = container_of(fh, struct bcap_fh, fh);
-
-	if (!bcap_fh->io_allowed)
-		return -EBUSY;
 
 	return vb2_dqbuf(&bcap_dev->buffer_queue,
 				buf, file->f_flags & O_NONBLOCK);
@@ -523,14 +456,10 @@ static int bcap_streamon(struct file *file, void *priv,
 				enum v4l2_buf_type buf_type)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct bcap_fh *fh = file->private_data;
 	struct ppi_if *ppi = bcap_dev->ppi;
 	dma_addr_t addr;
 	int ret;
 
-	if (!fh->io_allowed)
-		return -EBUSY;
-
 	/* call streamon to start streaming in videobuf */
 	ret = vb2_streamon(&bcap_dev->buffer_queue, buf_type);
 	if (ret)
@@ -564,10 +493,6 @@ static int bcap_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type buf_type)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
-	struct bcap_fh *fh = file->private_data;
-
-	if (!fh->io_allowed)
-		return -EBUSY;
 
 	return vb2_streamoff(&bcap_dev->buffer_queue, buf_type);
 }
@@ -870,8 +795,8 @@ static const struct v4l2_ioctl_ops bcap_ioctl_ops = {
 
 static struct v4l2_file_operations bcap_fops = {
 	.owner = THIS_MODULE,
-	.open = bcap_open,
-	.release = bcap_release,
+	.open = v4l2_fh_open,
+	.release = vb2_fop_release,
 	.unlocked_ioctl = video_ioctl2,
 	.mmap = vb2_fop_mmap,
 #ifndef CONFIG_MMU
-- 
2.1.0

