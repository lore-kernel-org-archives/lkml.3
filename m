Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbaC1GvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:51:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43156 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaC1GvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:51:18 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <gregkh@linuxfoundation.org>, <balbi@ti.com>
Subject: [PATCH] extcon: palmas: explicitly set edev name as node name
Date: Fri, 28 Mar 2014 12:21:02 +0530
Message-ID: <1395989462-14613-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit ca488 (extcon: of: Remove unnecessary function call by using the
name of device_node) started using node name instead of device name
to get the extcon device. This breaks dwc3-omap since it's not able to
get the extcon device anymore. Fixed it by setting edev name of
palmas to be the same as its node name.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Reported-by: Felipe Balbi <balbi@ti.com>
---
 drivers/extcon/extcon-palmas.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 2aea4bc..51dee21 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
+#include <linux/slab.h>
 #include <linux/err.h>
 #include <linux/mfd/palmas.h>
 #include <linux/of.h>
@@ -188,11 +189,13 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 	palmas_usb->edev.supported_cable = palmas_extcon_cable;
 	palmas_usb->edev.dev.parent = palmas_usb->dev;
+	palmas_usb->edev.name = kstrdup(node->name, GFP_KERNEL);
 	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
 
 	status = extcon_dev_register(&palmas_usb->edev);
 	if (status) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
+		kfree(palmas_usb->edev.name);
 		return status;
 	}
 
@@ -230,6 +233,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 
 fail_extcon:
 	extcon_dev_unregister(&palmas_usb->edev);
+	kfree(palmas_usb->edev.name);
 
 	return status;
 }
@@ -239,6 +243,7 @@ static int palmas_usb_remove(struct platform_device *pdev)
 	struct palmas_usb *palmas_usb = platform_get_drvdata(pdev);
 
 	extcon_dev_unregister(&palmas_usb->edev);
+	kfree(palmas_usb->edev.name);
 
 	return 0;
 }
-- 
1.7.9.5

