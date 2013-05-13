Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3EMT3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:29:19 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45581 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3EMT3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:29:16 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: davem@davemloft.net
Cc: Frank.Li@freescale.com, fabio.estevam@freescale.com, shawn.guo@linaro.org,
        joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] net: ethernet: freescale: use devm_ioremap_resource()
Date: Mon, 13 May 2013 21:37:54 +0200
Message-Id: <1368473874-9569-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.
also remove tests on 'r' since devm_ioremap_resource() checks for it
in a better way.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_ioremap_resource.cocci

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index aff0310..0afc7ff 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1843,8 +1843,6 @@ fec_probe(struct platform_device *pdev)
 		pdev->id_entry = of_id->data;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r)
-		return -ENXIO;
 
 	/* Init network device */
 	ndev = alloc_etherdev(sizeof(struct fec_enet_private));
@@ -1861,17 +1859,16 @@ fec_probe(struct platform_device *pdev)
 	    (pdev->id_entry->driver_data & FEC_QUIRK_HAS_GBIT))
 		fep->pause_flag |= FEC_PAUSE_FLAG_AUTONEG;
 
-	fep->hwp = devm_request_and_ioremap(&pdev->dev, r);
+	fep->hwp = devm_ioremap_resource(&pdev->dev, r);
+	if (IS_ERR(fep->hwp)) {
+		ret = PTR_ERR(fep->hwp);
+		goto failed_ioremap;
+	}
 	fep->pdev = pdev;
 	fep->dev_id = dev_id++;
 
 	fep->bufdesc_ex = 0;
 
-	if (!fep->hwp) {
-		ret = -ENOMEM;
-		goto failed_ioremap;
-	}
-
 	platform_set_drvdata(pdev, ndev);
 
 	ret = of_get_phy_mode(pdev->dev.of_node);
-- 
1.7.10.4

