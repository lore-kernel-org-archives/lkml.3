Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbaFAUn2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 16:43:28 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65222 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbaFAUn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:43:27 -0400
Date: Mon, 2 Jun 2014 02:13:21 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] usb: musb/backfin: Introduce the use of the managed version
 of kzalloc
Message-ID: <20140601204321.GA29473@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, a label is done away with and err2 and err3 renamed.

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
Not compile tested due to incompatible architechture.

why is platform_device_alloc called for allocating musb from within the
platform driver probe function where presumably the platform device structure
is already available? I would like to know whether the incoming pdev structure
is somehow not usable or it is a parent device of the device to be used.

 drivers/usb/musb/blackfin.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index d40d5f0..ac4422b 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -455,7 +455,7 @@ static int bfin_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
@@ -464,7 +464,7 @@ static int bfin_probe(struct platform_device *pdev)
 	musb = platform_device_alloc("musb-hdrc", PLATFORM_DEVID_AUTO);
 	if (!musb) {
 		dev_err(&pdev->dev, "failed to allocate musb device\n");
-		goto err1;
+		goto err0;
 	}
 
 	musb->dev.parent		= &pdev->dev;
@@ -478,7 +478,7 @@ static int bfin_probe(struct platform_device *pdev)
 
 	glue->phy = usb_phy_generic_register();
 	if (IS_ERR(glue->phy))
-		goto err2;
+		goto err1;
 	platform_set_drvdata(pdev, glue);
 
 	memset(musb_resources, 0x00, sizeof(*musb_resources) *
@@ -498,31 +498,28 @@ static int bfin_probe(struct platform_device *pdev)
 			ARRAY_SIZE(musb_resources));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add resources\n");
-		goto err3;
+		goto err2;
 	}
 
 	ret = platform_device_add_data(musb, pdata, sizeof(*pdata));
 	if (ret) {
 		dev_err(&pdev->dev, "failed to add platform_data\n");
-		goto err3;
+		goto err2;
 	}
 
 	ret = platform_device_add(musb);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register musb device\n");
-		goto err3;
+		goto err2;
 	}
 
 	return 0;
 
-err3:
-	usb_phy_generic_unregister(glue->phy);
-
 err2:
-	platform_device_put(musb);
+	usb_phy_generic_unregister(glue->phy);
 
 err1:
-	kfree(glue);
+	platform_device_put(musb);
 
 err0:
 	return ret;
@@ -534,7 +531,6 @@ static int bfin_remove(struct platform_device *pdev)
 
 	platform_device_unregister(glue->musb);
 	usb_phy_generic_unregister(glue->phy);
-	kfree(glue);
 
 	return 0;
 }
-- 
1.9.1

