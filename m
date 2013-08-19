Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3HSLVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:21:08 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:50170
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab3HSLVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:04 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233032"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: kernel-janitors@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] video: xilinxfb: replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:40 +0200
Message-Id: <1376911241-27720-7-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use devm_ioremap_resource instead of devm_request_and_ioremap.

This was done using the semantic patch
scripts/coccinelle/api/devm_ioremap_resource.cocci

The initialization of drvdata->regs_phys was manually moved lower, to take
advantage of the NULL test on res performed by devm_ioremap_resource.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/xilinxfb.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 6629b29..84c664e 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -259,12 +259,12 @@ static int xilinxfb_assign(struct platform_device *pdev,
 		struct resource *res;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-		drvdata->regs_phys = res->start;
-		drvdata->regs = devm_request_and_ioremap(&pdev->dev, res);
-		if (!drvdata->regs) {
-			rc = -EADDRNOTAVAIL;
+		drvdata->regs = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(drvdata->regs)) {
+			rc = PTR_ERR(drvdata->regs);
 			goto err_region;
 		}
+		drvdata->regs_phys = res->start;
 	}
 
 	/* Allocate the framebuffer memory */

