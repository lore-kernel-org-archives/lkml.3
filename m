Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3ITUQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:16:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab3ITUPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 66/93] [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()
Date: Fri, 20 Sep 2013 13:09:01 -0700
Message-Id: <1379707768-1804-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

commit 2e923a0527ac439e135b9961e58d3acd876bba10 upstream.

free_buff_list and rec_buff_list are initialized in the middle of hdpvr_probe(),
but if something bad happens before that, error handling code calls hdpvr_delete(),
which contains iteration over the lists (via hdpvr_free_buffers()).
The patch moves the lists initialization to the beginning and by the way fixes
goto label in error handling of registering videodev.
Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 84dc26f..e35fab4 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -309,6 +309,11 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	dev->workqueue = 0;
 
+	/* init video transfer queues first of all */
+	/* to prevent oops in hdpvr_delete() on error paths */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		dev_err(&interface->dev, "v4l2_device_register failed\n");
@@ -331,10 +336,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
@@ -388,7 +389,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 	if (hdpvr_register_videodev(dev, &interface->dev,
 				    video_nr[atomic_inc_return(&dev_nr)])) {
 		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
+		goto reg_fail;
 	}
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
-- 
1.8.1.2

