Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab3HNJS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:18:57 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57951
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932093Ab3HNJLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:42 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908321"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        linux-arm-kernel@lists.infradead.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/29] drivers/watchdog/nuc900_wdt.c: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:14 +0200
Message-Id: <1376471493-22215-11-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

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
 drivers/watchdog/nuc900_wdt.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index e2b6d2c..b15b6ef 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -256,11 +256,6 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 	spin_lock_init(&nuc900_wdt->wdt_lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no memory resource specified\n");
-		return -ENOENT;
-	}
-
 	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_wdt->wdt_base))
 		return PTR_ERR(nuc900_wdt->wdt_base);

