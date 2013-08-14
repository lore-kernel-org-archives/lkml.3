Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759726Ab3HNJO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:14:29 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57951
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932273Ab3HNJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908332"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 21/29] pwm: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:25 +0200
Message-Id: <1376471493-22215-22-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/pwm/pwm-lpc32xx.c     |    3 ---
 drivers/pwm/pwm-renesas-tpu.c |    5 -----
 drivers/pwm/pwm-spear.c       |    7 +------
 3 files changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index efb6c7b..efac99e 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -124,9 +124,6 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -EINVAL;
-
 	lpc32xx->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(lpc32xx->base))
 		return PTR_ERR(lpc32xx->base);
diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index 2600892..444d589 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -404,11 +404,6 @@ static int tpu_probe(struct platform_device *pdev)
 
 	/* Map memory, get clock and pin control. */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get I/O memory\n");
-		return -ENXIO;
-	}
-
 	tpu->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(tpu->base))
 		return PTR_ERR(tpu->base);
diff --git a/drivers/pwm/pwm-spear.c b/drivers/pwm/pwm-spear.c
index a54d214..8ad26b8 100644
--- a/drivers/pwm/pwm-spear.c
+++ b/drivers/pwm/pwm-spear.c
@@ -178,18 +178,13 @@ static int spear_pwm_probe(struct platform_device *pdev)
 	int ret;
 	u32 val;
 
-	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		dev_err(&pdev->dev, "no memory resources defined\n");
-		return -ENODEV;
-	}
-
 	pc = devm_kzalloc(&pdev->dev, sizeof(*pc), GFP_KERNEL);
 	if (!pc) {
 		dev_err(&pdev->dev, "failed to allocate memory\n");
 		return -ENOMEM;
 	}
 
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	pc->mmio_base = devm_ioremap_resource(&pdev->dev, r);
 	if (IS_ERR(pc->mmio_base))
 		return PTR_ERR(pc->mmio_base);

