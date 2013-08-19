Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab3HSQAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:00:39 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:19229 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075Ab3HSQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:00:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,914,1367964000"; 
   d="scan'208";a="29764505"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Chris Ball <cjb@laptop.org>
Cc: kernel-janitors@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mmc: jz4740: fix devm_ioremap_resource error detection code
Date: Mon, 19 Aug 2013 18:00:09 +0200
Message-Id: <1376928009-25637-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

devm_ioremap_resource returns an ERR_PTR value, not NULL, on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
statement S;
@@

*e = devm_ioremap_resource(...);
if (!e1) S

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mmc/host/jz4740_mmc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index 0308c9f..30589c8 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -783,8 +783,8 @@ static int jz4740_mmc_probe(struct platform_device* pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	host->base = devm_ioremap_resource(&pdev->dev, res);
-	if (!host->base) {
-		ret = -EBUSY;
+	if (IS_ERR(host->base)) {
+		ret = PTR_ERR(host->base);
 		dev_err(&pdev->dev, "Failed to ioremap base memory\n");
 		goto err_free_host;
 	}

