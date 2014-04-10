Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200AbaDJDf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:35:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935184AbaDJDXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:23:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 129/134] media: hdpvr: register the video node at the end of probe
Date: Wed,  9 Apr 2014 20:24:05 -0700
Message-Id: <20140410032315.953791643@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 280847b532433ffe7a22795f926327805a127162 upstream.

Video nodes can be used at once after registration, so make sure the full
initialization is done before registering them.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
[bwh: Backported to 3.2: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/video/hdpvr/hdpvr-core.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/media/video/hdpvr/hdpvr-core.c
+++ b/drivers/media/video/hdpvr/hdpvr-core.c
@@ -385,12 +385,6 @@ static int hdpvr_probe(struct usb_interf
 	}
 	mutex_unlock(&dev->io_mutex);
 
-	if (hdpvr_register_videodev(dev, &interface->dev,
-				    video_nr[atomic_inc_return(&dev_nr)])) {
-		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
-		goto error;
-	}
-
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
 	retval = hdpvr_register_i2c_adapter(dev);
 	if (retval < 0) {
@@ -411,6 +405,13 @@ static int hdpvr_probe(struct usb_interf
 	}
 #endif
 
+	retval = hdpvr_register_videodev(dev, &interface->dev,
+				    video_nr[atomic_inc_return(&dev_nr)]);
+	if (retval < 0) {
+		v4l2_err(&dev->v4l2_dev, "registering videodev failed\n");
+		goto error;
+	}
+
 	/* let the user know what node this device is now attached to */
 	v4l2_info(&dev->v4l2_dev, "device now attached to %s\n",
 		  video_device_node_name(dev->video_dev));


