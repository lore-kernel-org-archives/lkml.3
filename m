Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaCVLkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 07:40:05 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:35164 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaCVLkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 07:40:02 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: [PATCH] media: davinci: vpfe: use v4l2_fh for priority handling
Date: Sat, 22 Mar 2014 17:09:24 +0530
Message-Id: <1395488364-29856-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch migrates the vpfe driver to use v4l2_fh for
priority handling.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c |   13 ++++++-------
 include/media/davinci/vpfe_capture.h          |    6 ++----
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 944a5ec..28ebf0e 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -498,6 +498,7 @@ unlock:
 static int vpfe_open(struct file *file)
 {
 	struct vpfe_device *vpfe_dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
 	struct vpfe_fh *fh;
 
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev, "vpfe_open\n");
@@ -517,6 +518,7 @@ static int vpfe_open(struct file *file)
 	/* store pointer to fh in private_data member of file */
 	file->private_data = fh;
 	fh->vpfe_dev = vpfe_dev;
+	v4l2_fh_init(&fh->fh, vdev);
 	mutex_lock(&vpfe_dev->lock);
 	/* If decoder is not initialized. initialize it */
 	if (!vpfe_dev->initialized) {
@@ -529,9 +531,7 @@ static int vpfe_open(struct file *file)
 	vpfe_dev->usrs++;
 	/* Set io_allowed member to false */
 	fh->io_allowed = 0;
-	/* Initialize priority of this instance to default priority */
-	fh->prio = V4L2_PRIORITY_UNSET;
-	v4l2_prio_open(&vpfe_dev->prio, &fh->prio);
+	v4l2_fh_add(&fh->fh);
 	mutex_unlock(&vpfe_dev->lock);
 	return 0;
 }
@@ -739,8 +739,8 @@ static int vpfe_release(struct file *file)
 
 	/* Decrement device usrs counter */
 	vpfe_dev->usrs--;
-	/* Close the priority */
-	v4l2_prio_close(&vpfe_dev->prio, fh->prio);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	/* If this is the last file handle */
 	if (!vpfe_dev->usrs) {
 		vpfe_dev->initialized = 0;
@@ -1909,14 +1909,13 @@ static int vpfe_probe(struct platform_device *pdev)
 	/* Initialize field of the device objects */
 	vpfe_dev->numbuffers = config_params.numbuffers;
 
-	/* Initialize prio member of device object */
-	v4l2_prio_init(&vpfe_dev->prio);
 	/* register video device */
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		"trying to register vpfe device.\n");
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		"video_dev=%x\n", (int)&vpfe_dev->video_dev);
 	vpfe_dev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	set_bit(V4L2_FL_USE_FH_PRIO, &vpfe_dev->video_dev->flags);
 	ret = video_register_device(vpfe_dev->video_dev,
 				    VFL_TYPE_GRABBER, -1);
 
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index cc973ed..288772e 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -26,6 +26,7 @@
 #include <linux/videodev2.h>
 #include <linux/clk.h>
 #include <linux/i2c.h>
+#include <media/v4l2-fh.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/videobuf-dma-contig.h>
@@ -110,8 +111,6 @@ struct vpfe_device {
 	struct v4l2_device v4l2_dev;
 	/* parent device */
 	struct device *pdev;
-	/* Used to keep track of state of the priority */
-	struct v4l2_prio_state prio;
 	/* number of open instances of the channel */
 	u32 usrs;
 	/* Indicates id of the field which is being displayed */
@@ -174,11 +173,10 @@ struct vpfe_device {
 
 /* File handle structure */
 struct vpfe_fh {
+	struct v4l2_fh fh;
 	struct vpfe_device *vpfe_dev;
 	/* Indicates whether this file handle is doing IO */
 	u8 io_allowed;
-	/* Used to keep track priority of this instance */
-	enum v4l2_priority prio;
 };
 
 struct vpfe_config_params {
-- 
1.7.9.5

