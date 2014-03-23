Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaCWGhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 02:37:52 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:37019 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaCWGht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 02:37:49 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] staging: media: davinci: vpfe: use v4l2_fh for priority handling
Date: Sun, 23 Mar 2014 12:07:24 +0530
Message-Id: <1395556645-1207-2-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395556645-1207-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1395556645-1207-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 .../staging/media/davinci_vpfe/vpfe_mc_capture.h   |    2 --
 drivers/staging/media/davinci_vpfe/vpfe_video.c    |    8 +++-----
 drivers/staging/media/davinci_vpfe/vpfe_video.h    |    2 --
 3 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
index 68f6fe4..2632a80 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.h
@@ -87,8 +87,6 @@ struct vpfe_fh {
 	struct vpfe_video_device *video;
 	/* Indicates whether this file handle is doing IO */
 	u8 io_allowed;
-	/* Used to keep track priority of this instance */
-	enum v4l2_priority prio;
 };
 
 void mbus_to_pix(const struct v4l2_mbus_framefmt *mbus,
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index acc8184..c86ab84 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -415,7 +415,6 @@ static int vpfe_open(struct file *file)
 	video->usrs++;
 	/* Set io_allowed member to false */
 	handle->io_allowed = 0;
-	v4l2_prio_open(&video->prio, &handle->prio);
 	handle->video = video;
 	file->private_data = &handle->vfh;
 	mutex_unlock(&video->lock);
@@ -532,8 +531,8 @@ static int vpfe_release(struct file *file)
 	}
 	/* Decrement device users counter */
 	video->usrs--;
-	/* Close the priority */
-	v4l2_prio_close(&video->prio, fh->prio);
+	v4l2_fh_del(&fh->vfh);
+	v4l2_fh_exit(&fh->vfh);
 	/* If this is the last file handle */
 	if (!video->usrs)
 		video->initialized = 0;
@@ -1590,8 +1589,6 @@ int vpfe_video_init(struct vpfe_video_device *video, const char *name)
 	snprintf(video->video_dev.name, sizeof(video->video_dev.name),
 		 "DAVINCI VIDEO %s %s", name, direction);
 
-	/* Initialize prio member of device object */
-	v4l2_prio_init(&video->prio);
 	spin_lock_init(&video->irqlock);
 	spin_lock_init(&video->dma_queue_lock);
 	mutex_init(&video->lock);
@@ -1600,6 +1597,7 @@ int vpfe_video_init(struct vpfe_video_device *video, const char *name)
 	if (ret < 0)
 		return ret;
 
+	set_bit(V4L2_FL_USE_FH_PRIO, &video->video_dev.flags);
 	video_set_drvdata(&video->video_dev, video);
 
 	return 0;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index df0aeec..eed0864 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -102,8 +102,6 @@ struct vpfe_video_device {
 	 * user has selected
 	 */
 	enum v4l2_memory			memory;
-	/* Used to keep track of state of the priority */
-	struct v4l2_prio_state			prio;
 	/* number of open instances of the channel */
 	u32					usrs;
 	/* flag to indicate whether decoder is initialized */
-- 
1.7.9.5

