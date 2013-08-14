Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702Ab3HNJNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:13:52 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44583
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932282Ab3HNJLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:48 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908334"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: kernel-janitors@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 23/29] drivers/i2c/busses/i2c-ocores.c: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:27 +0200
Message-Id: <1376471493-22215-24-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/i2c/busses/i2c-ocores.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ocores.c b/drivers/i2c/busses/i2c-ocores.c
index 0e1f824..e686e2c 100644
--- a/drivers/i2c/busses/i2c-ocores.c
+++ b/drivers/i2c/busses/i2c-ocores.c
@@ -353,10 +353,6 @@ static int ocores_i2c_probe(struct platform_device *pdev)
 	int ret;
 	int i;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
@@ -365,6 +361,7 @@ static int ocores_i2c_probe(struct platform_device *pdev)
 	if (!i2c)
 		return -ENOMEM;
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	i2c->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(i2c->base))
 		return PTR_ERR(i2c->base);

