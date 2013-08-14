Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3HNJM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:12:26 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44583
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932311Ab3HNJLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:50 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908338"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Tejun Heo <tj@kernel.org>
Cc: kernel-janitors@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 27/29] drivers/ata/sata_rcar.c: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:31 +0200
Message-Id: <1376471493-22215-28-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/ata/sata_rcar.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ata/sata_rcar.c b/drivers/ata/sata_rcar.c
index 8108eb0..c2d95e9 100644
--- a/drivers/ata/sata_rcar.c
+++ b/drivers/ata/sata_rcar.c
@@ -778,10 +778,6 @@ static int sata_rcar_probe(struct platform_device *pdev)
 	int irq;
 	int ret = 0;
 
-	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (mem == NULL)
-		return -EINVAL;
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0)
 		return -EINVAL;
@@ -807,6 +803,7 @@ static int sata_rcar_probe(struct platform_device *pdev)
 
 	host->private_data = priv;
 
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	priv->base = devm_ioremap_resource(&pdev->dev, mem);
 	if (IS_ERR(priv->base)) {
 		ret = PTR_ERR(priv->base);

