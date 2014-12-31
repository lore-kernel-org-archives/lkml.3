Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaLaAWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 19:22:21 -0500
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:47735 "EHLO
	resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbaLaAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 19:22:18 -0500
From: Shuah Khan <shuahkh@osg.samsung.com>
To: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, prabhakar.csengg@gmail.com,
        laurent.pinchart@ideasonboard.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: au0828 analog_register error path fixes to do proper cleanup
Date: Tue, 30 Dec 2014 17:22:14 -0700
Message-Id: <1419985334-6155-1-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au0828_analog_register() doesn't release video and vbi queues
created by vb2_queue_init(). In addition, it doesn't unregister
vdev when vbi register fails. Add vb2_queue_release() calls to
release video and vbi queues to the failure path to be called
when vdev register fails. Add video_unregister_device() for
vdev when vbi register fails.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
Please note that this patch is dependent on the au0828 vb2
conversion patch.

 drivers/media/usb/au0828/au0828-video.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 94b65b8..17450eb 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1785,7 +1785,7 @@ int au0828_analog_register(struct au0828_dev *dev,
 		dprintk(1, "unable to register video device (error = %d).\n",
 			retval);
 		ret = -ENODEV;
-		goto err_vbi_dev;
+		goto err_reg_vdev;
 	}
 
 	/* Register the vbi device */
@@ -1795,14 +1795,18 @@ int au0828_analog_register(struct au0828_dev *dev,
 		dprintk(1, "unable to register vbi device (error = %d).\n",
 			retval);
 		ret = -ENODEV;
-		goto err_vbi_dev;
+		goto err_reg_vbi_dev;
 	}
 
-
 	dprintk(1, "%s completed!\n", __func__);
 
 	return 0;
 
+err_reg_vbi_dev:
+	video_unregister_device(dev->vdev);
+err_reg_vdev:
+	vb2_queue_release(&dev->vb_vidq);
+	vb2_queue_release(&dev->vb_vbiq);
 err_vbi_dev:
 	video_device_release(dev->vbi_dev);
 err_vdev:
-- 
2.1.0

