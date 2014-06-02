Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaFBPpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 11:45:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61851 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaFBPpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 11:45:13 -0400
Date: Mon, 2 Jun 2014 21:15:05 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: musb: tusb6010: Introduce the use of the managed
 version of kzalloc
Message-ID: <20140602154505.GA3250@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, the unnecesary labels are removed and linux/device.h is
added to make sure the devm_*() routine declarations are unambiguously
available.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/usb/musb/tusb6010.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 159ef4b..7dfc6cb 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -22,6 +22,7 @@
 #include <linux/usb.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/device.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/usb/usb_phy_generic.h>
@@ -1160,12 +1161,12 @@ static int tusb_probe(struct platform_device *pdev)
 	struct platform_device		*musb;
 	struct tusb6010_glue		*glue;
 	struct platform_device_info	pinfo;
-	int				ret = -ENOMEM;
+	int				ret;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
-		goto err0;
+		return -ENOMEM;
 	}
 
 	glue->dev			= &pdev->dev;
@@ -1204,16 +1205,10 @@ static int tusb_probe(struct platform_device *pdev)
 	if (IS_ERR(musb)) {
 		ret = PTR_ERR(musb);
 		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
-		goto err3;
+		return ret;
 	}
 
 	return 0;
-
-err3:
-	kfree(glue);
-
-err0:
-	return ret;
 }
 
 static int tusb_remove(struct platform_device *pdev)
@@ -1222,7 +1217,6 @@ static int tusb_remove(struct platform_device *pdev)
 
 	platform_device_unregister(glue->musb);
 	usb_phy_generic_unregister(glue->phy);
-	kfree(glue);
 
 	return 0;
 }
-- 
1.9.1

