Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaEVVBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:01:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33069 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaEVVAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:00:21 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/5] net: ks8851: Use devm_regulator_get_optional()
Date: Thu, 22 May 2014 14:00:11 -0700
Message-Id: <1400792413-21618-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
In-Reply-To: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
References: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simplifies error paths and removes the need to
regulator_put().

Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/net/ethernet/micrel/ks8851.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 13767eb36a48..f2bfc708880c 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -1417,7 +1417,7 @@ static int ks8851_probe(struct spi_device *spi)
 	ks->spidev = spi;
 	ks->tx_space = 6144;
 
-	ks->vdd_reg = regulator_get_optional(&spi->dev, "vdd");
+	ks->vdd_reg = devm_regulator_get_optional(&spi->dev, "vdd");
 	if (IS_ERR(ks->vdd_reg)) {
 		ret = PTR_ERR(ks->vdd_reg);
 		if (ret == -EPROBE_DEFER)
@@ -1427,7 +1427,7 @@ static int ks8851_probe(struct spi_device *spi)
 		if (ret) {
 			dev_err(&spi->dev, "regulator enable fail: %d\n",
 				ret);
-			goto err_reg_en;
+			goto err_reg;
 		}
 	}
 
@@ -1530,9 +1530,6 @@ err_irq:
 err_id:
 	if (!IS_ERR(ks->vdd_reg))
 		regulator_disable(ks->vdd_reg);
-err_reg_en:
-	if (!IS_ERR(ks->vdd_reg))
-		regulator_put(ks->vdd_reg);
 err_reg:
 	free_netdev(ndev);
 	return ret;
@@ -1547,10 +1544,8 @@ static int ks8851_remove(struct spi_device *spi)
 
 	unregister_netdev(priv->netdev);
 	free_irq(spi->irq, priv);
-	if (!IS_ERR(priv->vdd_reg)) {
+	if (!IS_ERR(priv->vdd_reg))
 		regulator_disable(priv->vdd_reg);
-		regulator_put(priv->vdd_reg);
-	}
 	free_netdev(priv->netdev);
 
 	return 0;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

