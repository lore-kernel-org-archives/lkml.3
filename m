Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbaEPNms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:48 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40790 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605AbaEPNmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:43 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 44/49] media: davinci: vpif_capture: use SIMPLE_DEV_PM_OPS
Date: Fri, 16 May 2014 19:03:50 +0530
Message-Id: <1400247235-31434-47-git-send-email-prabhakar.csengg@gmail.com>
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
 drivers/media/platform/davinci/vpif_capture.c |   63 ++++++++++++-------------
 drivers/media/platform/davinci/vpif_capture.h |    4 --
 2 files changed, 30 insertions(+), 37 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 9b41465..f4cf24c 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1595,7 +1595,7 @@ static int vpif_remove(struct platform_device *device)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 /**
  * vpif_suspend: vpif device suspend
  */
@@ -1610,18 +1610,20 @@ static int vpif_suspend(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (ch->usrs && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
-				enable_channel0(0);
-				channel0_intr_enable(0);
-			}
-			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
-				ycmux_mode == 2) {
-				enable_channel1(0);
-				channel1_intr_enable(0);
-			}
+		/* Disable channel */
+		if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
+			enable_channel0(0);
+			channel0_intr_enable(0);
+		}
+		if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
+			ycmux_mode == 2) {
+			enable_channel1(0);
+			channel1_intr_enable(0);
 		}
 		mutex_unlock(&common->lock);
 	}
@@ -1642,40 +1644,35 @@ static int vpif_resume(struct device *dev)
 		/* Get the pointer to the channel object */
 		ch = vpif_obj.dev[i];
 		common = &ch->common[VPIF_VIDEO_INDEX];
+
+		if (!vb2_is_streaming(&common->buffer_queue))
+			continue;
+
 		mutex_lock(&common->lock);
-		if (ch->usrs && common->io_usrs) {
-			/* Disable channel */
-			if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
-				enable_channel0(1);
-				channel0_intr_enable(1);
-			}
-			if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
-				ycmux_mode == 2) {
-				enable_channel1(1);
-				channel1_intr_enable(1);
-			}
+		/* Enable channel */
+		if (ch->channel_id == VPIF_CHANNEL0_VIDEO) {
+			enable_channel0(1);
+			channel0_intr_enable(1);
+		}
+		if (ch->channel_id == VPIF_CHANNEL1_VIDEO ||
+			ycmux_mode == 2) {
+			enable_channel1(1);
+			channel1_intr_enable(1);
 		}
 		mutex_unlock(&common->lock);
 	}
 
 	return 0;
 }
-
-static const struct dev_pm_ops vpif_dev_pm_ops = {
-	.suspend = vpif_suspend,
-	.resume = vpif_resume,
-};
-
-#define vpif_pm_ops (&vpif_dev_pm_ops)
-#else
-#define vpif_pm_ops NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(vpif_pm_ops, vpif_suspend, vpif_resume);
+
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
 		.name	= VPIF_DRIVER_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= vpif_pm_ops,
+		.pm	= &vpif_pm_ops,
 	},
 	.probe = vpif_probe,
 	.remove = vpif_remove,
diff --git a/drivers/media/platform/davinci/vpif_capture.h b/drivers/media/platform/davinci/vpif_capture.h
index 537076a..3b5ea30 100644
--- a/drivers/media/platform/davinci/vpif_capture.h
+++ b/drivers/media/platform/davinci/vpif_capture.h
@@ -75,8 +75,6 @@ struct common_obj {
 	spinlock_t irqlock;
 	/* lock used to access this structure */
 	struct mutex lock;
-	/* number of users performing IO */
-	u32 io_usrs;
 	/* Function pointer to set the addresses */
 	void (*set_addr) (unsigned long, unsigned long, unsigned long,
 			  unsigned long);
@@ -97,8 +95,6 @@ struct common_obj {
 struct channel_obj {
 	/* Identifies video device for this channel */
 	struct video_device *video_dev;
-	/* number of open instances of the channel */
-	int usrs;
 	/* Indicates id of the field which is being displayed */
 	u32 field_id;
 	/* flag to indicate whether decoder is initialized */
-- 
1.7.9.5

