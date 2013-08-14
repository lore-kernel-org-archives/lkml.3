Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab3HNJOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:14:46 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57962
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932255Ab3HNJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908331"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ben Dooks <ben-linux@fluff.org>
Cc: kernel-janitors@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/29] watchdog: s3c2410_wdt: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:24 +0200
Message-Id: <1376471493-22215-21-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/watchdog/s3c2410_wdt.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 6a22cf5..9fbc993 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -325,12 +325,6 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	dev = &pdev->dev;
 	wdt_dev = &pdev->dev;
 
-	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (wdt_mem == NULL) {
-		dev_err(dev, "no memory resource specified\n");
-		return -ENOENT;
-	}
-
 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (wdt_irq == NULL) {
 		dev_err(dev, "no irq resource specified\n");
@@ -339,6 +333,7 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	}
 
 	/* get the memory region for the watchdog timer */
+	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	wdt_base = devm_ioremap_resource(dev, wdt_mem);
 	if (IS_ERR(wdt_base)) {
 		ret = PTR_ERR(wdt_base);

