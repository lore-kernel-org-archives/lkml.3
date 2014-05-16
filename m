Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933475AbaEPNmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:42:31 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60451 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933442AbaEPNmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:42:24 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v5 40/49] media: davinci: vpif_capture: initialize the video device in single place
Date: Fri, 16 May 2014 19:03:46 +0530
Message-Id: <1400247235-31434-43-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1400247235-31434-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch moves the initalization of video device to a
single place and uses macro to define the driver name and
use it appropraitely in required places.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpif_capture.c |   30 ++++++++++---------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index b898779..d452eaf 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -65,6 +65,8 @@ static struct vpif_config_params config_params = {
 	.channel_bufsize[1] = 720 * 576 * 2,
 };
 
+#define VPIF_DRIVER_NAME	"vpif_capture"
+
 /* global variables */
 static struct vpif_device vpif_obj = { {NULL} };
 static struct device *vpif_dev;
@@ -1114,7 +1116,7 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	snprintf(cap->driver, sizeof(cap->driver), "%s", dev_name(vpif_dev));
+	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpif_dev));
 	strlcpy(cap->card, config->card_name, sizeof(cap->card));
@@ -1349,14 +1351,6 @@ static struct v4l2_file_operations vpif_fops = {
 	.poll = vb2_fop_poll
 };
 
-/* vpif video template */
-static struct video_device vpif_video_template = {
-	.name		= "vpif",
-	.fops		= &vpif_fops,
-	.minor		= -1,
-	.ioctl_ops	= &vpif_ioctl_ops,
-};
-
 /**
  * initialize_vpif() - Initialize vpif data structures
  *
@@ -1476,7 +1470,14 @@ static int vpif_probe_complete(void)
 
 		INIT_LIST_HEAD(&common->dma_queue);
 
+		/* Initialize the video_device structure */
 		vdev = ch->video_dev;
+		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
+		vdev->release = video_device_release;
+		vdev->fops = &vpif_fops;
+		vdev->ioctl_ops = &vpif_ioctl_ops;
+		vdev->v4l2_dev = &vpif_obj.v4l2_dev;
+		vdev->vfl_dir = VFL_DIR_RX;
 		vdev->queue = q;
 		vdev->lock = &common->lock;
 		set_bit(V4L2_FL_USE_FH_PRIO, &vdev->flags);
@@ -1549,7 +1550,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	while ((res = platform_get_resource(pdev, IORESOURCE_IRQ, res_idx))) {
 		err = devm_request_irq(&pdev->dev, res->start, vpif_channel_isr,
-					IRQF_SHARED, "VPIF_Capture",
+					IRQF_SHARED, VPIF_DRIVER_NAME,
 					(void *)(&vpif_obj.dev[res_idx]->
 					channel_id));
 		if (err) {
@@ -1573,13 +1574,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 			goto vpif_unregister;
 		}
 
-		/* Initialize field of video device */
-		*vfd = vpif_video_template;
-		vfd->v4l2_dev = &vpif_obj.v4l2_dev;
-		vfd->release = video_device_release;
-		snprintf(vfd->name, sizeof(vfd->name),
-			 "VPIF_Capture_DRIVER_V%s",
-			 VPIF_CAPTURE_VERSION);
 		/* Set video_dev to the video device */
 		ch->video_dev = vfd;
 	}
@@ -1754,7 +1748,7 @@ static const struct dev_pm_ops vpif_dev_pm_ops = {
 
 static __refdata struct platform_driver vpif_driver = {
 	.driver	= {
-		.name	= "vpif_capture",
+		.name	= VPIF_DRIVER_NAME,
 		.owner	= THIS_MODULE,
 		.pm	= vpif_pm_ops,
 	},
-- 
1.7.9.5

