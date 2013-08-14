Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab3HNJLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:11:43 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57951
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759626Ab3HNJLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:39 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908313"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/29] mtd: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:08 +0200
Message-Id: <1376471493-22215-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

Move the call to platform_get_resource adjacent to the call to
devm_ioremap_resource to make the connection between them more clear.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mtd/devices/elm.c    |    5 -----
 drivers/mtd/nand/txx9ndfmc.c |    4 +---
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/mtd/devices/elm.c b/drivers/mtd/devices/elm.c
index 4f683d2..d1dd6a3 100644
--- a/drivers/mtd/devices/elm.c
+++ b/drivers/mtd/devices/elm.c
@@ -368,11 +368,6 @@ static int elm_probe(struct platform_device *pdev)
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no memory resource defined\n");
-		return -ENODEV;
-	}
-
 	info->elm_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(info->elm_base))
 		return PTR_ERR(info->elm_base);
diff --git a/drivers/mtd/nand/txx9ndfmc.c b/drivers/mtd/nand/txx9ndfmc.c
index 440b570..235714a 100644
--- a/drivers/mtd/nand/txx9ndfmc.c
+++ b/drivers/mtd/nand/txx9ndfmc.c
@@ -281,12 +281,10 @@ static int __init txx9ndfmc_probe(struct platform_device *dev)
 	unsigned long gbusclk = plat->gbus_clock;
 	struct resource *res;
 
-	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	drvdata = devm_kzalloc(&dev->dev, sizeof(*drvdata), GFP_KERNEL);
 	if (!drvdata)
 		return -ENOMEM;
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	drvdata->base = devm_ioremap_resource(&dev->dev, res);
 	if (IS_ERR(drvdata->base))
 		return PTR_ERR(drvdata->base);

