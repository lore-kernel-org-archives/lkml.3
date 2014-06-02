Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620AbaFBQ0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:26:15 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:60810 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbaFBQ0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:26:11 -0400
Date: Mon, 2 Jun 2014 21:56:01 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] iusb: musb: davinci: use devm_ functions.
Message-ID: <20140602162600.GA4974@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, a label is done away with and clk_get is replaced by it
corresponding devm version and the clk_puts are done away with. The
labels are renamed to make them ordered.

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
 drivers/usb/musb/davinci.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index de8492b..110b784 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -519,23 +519,23 @@ static int davinci_probe(struct platform_device *pdev)
 
 	int				ret = -ENOMEM;
 
-	glue = kzalloc(sizeof(*glue), GFP_KERNEL);
+	glue = devm_kzalloc(&pdev->dev, sizeof(*glue), GFP_KERNEL);
 	if (!glue) {
 		dev_err(&pdev->dev, "failed to allocate glue context\n");
 		goto err0;
 	}
 
-	clk = clk_get(&pdev->dev, "usb");
+	clk = devm_clk_get(&pdev->dev, "usb");
 	if (IS_ERR(clk)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		ret = PTR_ERR(clk);
-		goto err3;
+		goto err0;
 	}
 
 	ret = clk_enable(clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
-		goto err4;
+		goto err0;
 	}
 
 	glue->dev			= &pdev->dev;
@@ -579,20 +579,14 @@ static int davinci_probe(struct platform_device *pdev)
 	if (IS_ERR(musb)) {
 		ret = PTR_ERR(musb);
 		dev_err(&pdev->dev, "failed to register musb device: %d\n", ret);
-		goto err5;
+		goto err1;
 	}
 
 	return 0;
 
-err5:
+err1:
 	clk_disable(clk);
 
-err4:
-	clk_put(clk);
-
-err3:
-	kfree(glue);
-
 err0:
 	return ret;
 }
@@ -604,8 +598,6 @@ static int davinci_remove(struct platform_device *pdev)
 	platform_device_unregister(glue->musb);
 	usb_phy_generic_unregister();
 	clk_disable(glue->clk);
-	clk_put(glue->clk);
-	kfree(glue);
 
 	return 0;
 }
-- 
1.9.1

