Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3GCURv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:17:51 -0400
Received: from mail.ispras.ru ([83.149.199.45]:34471 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab3GCURu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:17:50 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] [media] hdpvr: fix iteration over uninitialized lists in hdpvr_probe()
Date: Thu,  4 Jul 2013 00:17:34 +0400
Message-Id: <1372882654-22234-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

free_buff_list and rec_buff_list are initialized in the middle of hdpvr_probe(),
but if something bad happens before that, error handling code calls hdpvr_delete(),
which contains iteration over the lists (via hdpvr_free_buffers()).

The patch moves the lists initialization to the beginning and by the way fixes
goto label in error handling of registering videodev.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/usb/hdpvr/hdpvr-core.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-core.c b/drivers/media/usb/hdpvr/hdpvr-core.c
index 8247c19..77d7b7f 100644
--- a/drivers/media/usb/hdpvr/hdpvr-core.c
+++ b/drivers/media/usb/hdpvr/hdpvr-core.c
@@ -311,6 +311,11 @@ static int hdpvr_probe(struct usb_interface *interface,
 
 	dev->workqueue = 0;
 
+	/* init video transfer queues first of all */
+	/* to prevent oops in hdpvr_delete() on error paths */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		dev_err(&interface->dev, "v4l2_device_register failed\n");
@@ -333,10 +338,6 @@ static int hdpvr_probe(struct usb_interface *interface,
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
@@ -413,7 +414,7 @@ static int hdpvr_probe(struct usb_interface *interface,
 				    video_nr[atomic_inc_return(&dev_nr)]);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
+		goto reg_fail;
 	}
 
 	/* let the user know what node this device is now attached to */
-- 
1.8.1.2

