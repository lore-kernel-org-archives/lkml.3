Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab3HNJLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:11:52 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57951
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932241Ab3HNJLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908328"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: kernel-janitors@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/29] drivers/rtc: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:21 +0200
Message-Id: <1376471493-22215-18-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/rtc/rtc-ds1216.c |    4 +---
 drivers/rtc/rtc-ds1286.c |    4 +---
 drivers/rtc/rtc-spear.c  |    7 +------
 3 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-ds1216.c b/drivers/rtc/rtc-ds1216.c
index 9c04fd2..c948bd3 100644
--- a/drivers/rtc/rtc-ds1216.c
+++ b/drivers/rtc/rtc-ds1216.c
@@ -144,15 +144,13 @@ static int __init ds1216_rtc_probe(struct platform_device *pdev)
 	struct ds1216_priv *priv;
 	u8 dummy[8];
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, priv);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->ioaddr = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->ioaddr))
 		return PTR_ERR(priv->ioaddr);
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 50e109b..14c4b24 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -332,13 +332,11 @@ static int ds1286_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct ds1286_priv *priv;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	priv = devm_kzalloc(&pdev->dev, sizeof(struct ds1286_priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->rtcregs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->rtcregs))
 		return PTR_ERR(priv->rtcregs);
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index c492cf0..6470641 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -358,12 +358,6 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	int status = 0;
 	int irq;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no resource defined\n");
-		return -EBUSY;
-	}
-
 	config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
 	if (!config) {
 		dev_err(&pdev->dev, "out of memory\n");
@@ -385,6 +379,7 @@ static int spear_rtc_probe(struct platform_device *pdev)
 		return status;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	config->ioaddr = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(config->ioaddr))
 		return PTR_ERR(config->ioaddr);

