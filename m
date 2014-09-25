Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaIYOoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:44:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:31554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbaIYOny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:43:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,597,1406617200"; 
   d="scan'208";a="578908396"
From: Octavian Purdila <octavian.purdila@intel.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, johan@kernel.org,
        Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v3 2/3] mfd: viperboard: switch to devm_ allocation
Date: Thu, 25 Sep 2014 17:43:16 +0300
Message-Id: <1411656197-26517-3-git-send-email-octavian.purdila@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
References: <1411656197-26517-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using devm_ allocation to simplify the error path. Also
remove a redundant OOM error message.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 drivers/mfd/viperboard.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 5f62f4e..57fac1d 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -53,18 +53,16 @@ static int vprbrd_probe(struct usb_interface *interface,
 			      const struct usb_device_id *id)
 {
 	struct vprbrd *vb;
-
 	u16 version = 0;
 	int pipe, ret;
 
 	/* allocate memory for our device state and initialize it */
-	vb = kzalloc(sizeof(*vb), GFP_KERNEL);
-	if (vb == NULL) {
-		dev_err(&interface->dev, "Out of memory\n");
+	vb = devm_kzalloc(&interface->dev, sizeof(*vb), GFP_KERNEL);
+	if (vb == NULL)
 		return -ENOMEM;
-	}
 
-	vb->buf = kzalloc(sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
+	vb->buf = devm_kzalloc(&interface->dev,
+			       sizeof(struct vprbrd_i2c_write_msg), GFP_KERNEL);
 	if (vb->buf == NULL) {
 		ret = -ENOMEM;
 		goto error;
@@ -109,11 +107,7 @@ static int vprbrd_probe(struct usb_interface *interface,
 	return 0;
 
 error:
-	if (vb) {
-		usb_put_dev(vb->usb_dev);
-		kfree(vb->buf);
-		kfree(vb);
-	}
+	usb_put_dev(vb->usb_dev);
 
 	return ret;
 }
@@ -125,8 +119,6 @@ static void vprbrd_disconnect(struct usb_interface *interface)
 	mfd_remove_devices(&interface->dev);
 	usb_set_intfdata(interface, NULL);
 	usb_put_dev(vb->usb_dev);
-	kfree(vb->buf);
-	kfree(vb);
 
 	dev_dbg(&interface->dev, "disconnected\n");
 }
-- 
1.9.1

