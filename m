Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab3HNJLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:11:45 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:57962
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759641Ab3HNJLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:11:40 -0400
X-IronPort-AV: E=Sophos;i="4.89,875,1367964000"; 
   d="scan'208";a="23908316"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Vinod Koul <vinod.koul@intel.com>
Cc: kernel-janitors@vger.kernel.org, Dan Williams <djbw@fb.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/29] dma: mmp: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 11:11:11 +0200
Message-Id: <1376471493-22215-8-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/dma/mmp_pdma.c |    3 ---
 drivers/dma/mmp_tdma.c |    3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 9a32f2d..afa5a2e 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -786,9 +786,6 @@ static int mmp_pdma_probe(struct platform_device *op)
 	spin_lock_init(&pdev->phy_lock);
 
 	iores = platform_get_resource(op, IORESOURCE_MEM, 0);
-	if (!iores)
-		return -EINVAL;
-
 	pdev->base = devm_ioremap_resource(pdev->dev, iores);
 	if (IS_ERR(pdev->base))
 		return PTR_ERR(pdev->base);
diff --git a/drivers/dma/mmp_tdma.c b/drivers/dma/mmp_tdma.c
index a9345d0..38cb517 100644
--- a/drivers/dma/mmp_tdma.c
+++ b/drivers/dma/mmp_tdma.c
@@ -550,9 +550,6 @@ static int mmp_tdma_probe(struct platform_device *pdev)
 	}
 
 	iores = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!iores)
-		return -EINVAL;
-
 	tdev->base = devm_ioremap_resource(&pdev->dev, iores);
 	if (IS_ERR(tdev->base))
 		return PTR_ERR(tdev->base);

