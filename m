Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaEPNvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:51:20 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58485 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033AbaEPNkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:40:39 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 21/49] media: davinci: vpif_display: use SIMPLE_DEV_PM_OPS
Date: Fri, 16 May 2014 19:03:26 +0530
Message-Id: <1400247235-31434-23-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch uses SIMPLE_DEV_PM_OPS, and drops unneeded members
from io_usrs, usrs and makes use of vb2 helepers instead.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_display.c |   64 ++++++++++++-------------
 drivers/media/platform/davinci/vpif_display.h |    4 --
 2 files changed, 30 insertions(+), 38 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 401d03a..81d955a 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1124,10 +1124,8 @@ static int vpif_probe_complete(void)
 	for (j = 0; j < VPIF_DISPLAY_MAX_DEVICES; j++) {
 		ch = vpif_obj.dev[j];
 		/* Initialize field of the channel objects */
-		atomic_set(&ch->usrs, 0);
 		for (k = 0; k < VPIF_NUMOBJECTS; k++) {
 			common = &ch->common[k];
-			common->io_usrs = 0;
 			spin_lock_init(&common->irqlock);
 			mutex_init(&common->lock);
 			common->set_addr = NULL;
@@ -1371,7 +1369,7 @@ static int vpif_remove(struct platform_device *device)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int vpif_suspend(struct device *dev)
 {
 	struct common_obj *common;
@@ -1382,18 +1380,20 @@ static int vpif_suspend(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (atomic_read(&ch->usrs) && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
-				enable_channel2(0);
-				channel2_intr_enable(0);
-			}
-			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-				ycmux_mode == 2) {
-				enable_channel3(0);
-				channel3_intr_enable(0);
-			}
+		/* Disable channel */
+		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
+			enable_channel2(0);
+			channel2_intr_enable(0);
+		}
+		if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
+			ycmux_mode == 2) {
+			enable_channel3(0);
+			channel3_intr_enable(0);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -1412,18 +1412,20 @@ static int vpif_resume(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (atomic_read(&ch->usrs) && common->io_usrs) {
-			/* Enable channel */
-			if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
-				enable_channel2(1);
-				channel2_intr_enable(1);
-			}
-			if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
-					ycmux_mode == 2) {
-				enable_channel3(1);
-				channel3_intr_enable(1);
-			}
+		/* Enable channel */
+		if (ch->channel_id == VPIF_CHANNEL2_VIDEO) {
+			enable_channel2(1);
+			channel2_intr_enable(1);
+		}
+		if (ch->channel_id == VPIF_CHANNEL3_VIDEO ||
+				ycmux_mode == 2) {
+			enable_channel3(1);
+			channel3_intr_enable(1);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -1431,21 +1433,15 @@ static int vpif_resume(struct device *dev)
 	return 0;
 }
 
-static const struct dev_pm_ops vpif_pm = {
-	.suspend        = vpif_suspend,
-	.resume         = vpif_resume,
-};
-
-#define vpif_pm_ops (&vpif_pm)
-#else
-#define vpif_pm_ops NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
+
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
 			.name	= VPIF_DRIVER_NAME,
 			.owner	= THIS_MODULE,
-			.pm	= vpif_pm_ops,
+			.pm	= &vpif_pm_ops,
 	},
 	.probe	= vpif_probe,
 	.remove	= vpif_remove,
diff --git a/drivers/media/platform/davinci/vpif_display.h b/drivers/media/platform/davinci/vpif_display.h
index 089e860..18cba9a 100644
--- a/drivers/media/platform/davinci/vpif_display.h
+++ b/drivers/media/platform/davinci/vpif_display.h
@@ -83,8 +83,6 @@ struct common_obj {
 	/* channel specific parameters */
 	struct mutex lock;			/* lock used to access this
 						 * structure */
-	u32 io_usrs;				/* number of users performing
-						 * IO */
 	u32 ytop_off;				/* offset of Y top from the
 						 * starting of the buffer */
 	u32 ybtm_off;				/* offset of Y bottom from the
@@ -104,8 +102,6 @@ struct channel_obj {
 	/* V4l2 specific parameters */
 	struct video_device *video_dev;	/* Identifies video device for
 					 * this channel */
-	atomic_t usrs;			/* number of open instances of
-					 * the channel */
 	u32 field_id;			/* Indicates id of the field
 					 * which is being displayed */
 	u8 initialized;			/* flag to indicate whether
-- 
1.7.9.5

