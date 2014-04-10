Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298AbaDJDcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:32:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41408 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934626AbaDJDXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:23:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 130/134] media: hdpvr: fix iteration over uninitialized lists in hdpvr_probe()
Date: Wed,  9 Apr 2014 20:24:06 -0700
Message-Id: <20140410032316.084456404@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/hdpvr/hdpvr-core.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -309,6 +309,11 @@ static int hdpvr_probe(struct usb_interf
 
 	dev->workqueue = 0;
 
+	/* init video transfer queues first of all */
+	/* to prevent oops in hdpvr_delete() on error paths */
+	INIT_LIST_HEAD(&dev->free_buff_list);
+	INIT_LIST_HEAD(&dev->rec_buff_list);
+
 	/* register v4l2_device early so it can be used for printks */
 	if (v4l2_device_register(&interface->dev, &dev->v4l2_dev)) {
 		err("v4l2_device_register failed");
@@ -331,10 +336,6 @@ static int hdpvr_probe(struct usb_interf
 	if (!dev->workqueue)
 		goto error;
 
-	/* init video transfer queues */
-	INIT_LIST_HEAD(&dev->free_buff_list);
-	INIT_LIST_HEAD(&dev->rec_buff_list);
-
 	dev->options = hdpvr_default_options;
 
 	if (default_video_input < HDPVR_VIDEO_INPUTS)
@@ -409,7 +410,7 @@ static int hdpvr_probe(struct usb_interf
 				    video_nr[atomic_inc_return(&dev_nr)]);
 	if (retval < 0) {
 		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
+		goto reg_fail;
 	}
 
 	/* let the user know what node this device is now attached to */


