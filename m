Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaJBCcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 22:32:21 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:51262 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaJBCcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 22:32:19 -0400
From: Michael Welling <mwelling@ieee.org>
To: davem@davemloft.net, tony@atomide.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Michael Welling <mwelling@ieee.org>
Subject: [PATCH] drivers:ethernet:davinci_emac.c:Fixes flaw in mac address handling.
Date: Wed,  1 Oct 2014 21:32:05 -0500
Message-Id: <1412217125-11057-1-git-send-email-mwelling@ieee.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code currently checks the mac_addr variable that is clearly
zero'd out during allocation.

Further code is added to bring the mac_addr from the partial pdata.

Signed-off-by: Michael Welling <mwelling@ieee.org>
---
 drivers/net/ethernet/ti/davinci_emac.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/davinci_emac.c b/drivers/net/ethernet/ti/davinci_emac.c
index ea71251..e06f97c 100644
--- a/drivers/net/ethernet/ti/davinci_emac.c
+++ b/drivers/net/ethernet/ti/davinci_emac.c
@@ -1804,11 +1804,9 @@ davinci_emac_of_get_pdata(struct platform_device *pdev, struct emac_priv *priv)
 	np = pdev->dev.of_node;
 	pdata->version = EMAC_VERSION_2;
 
-	if (!is_valid_ether_addr(pdata->mac_addr)) {
-		mac_addr = of_get_mac_address(np);
-		if (mac_addr)
-			memcpy(pdata->mac_addr, mac_addr, ETH_ALEN);
-	}
+	mac_addr = of_get_mac_address(np);
+	if (mac_addr)
+		memcpy(pdata->mac_addr, mac_addr, ETH_ALEN);
 
 	of_property_read_u32(np, "ti,davinci-ctrl-reg-offset",
 			     &pdata->ctrl_reg_offset);
@@ -1834,6 +1832,8 @@ davinci_emac_of_get_pdata(struct platform_device *pdev, struct emac_priv *priv)
 	if (auxdata) {
 		pdata->interrupt_enable = auxdata->interrupt_enable;
 		pdata->interrupt_disable = auxdata->interrupt_disable;
+		if (is_valid_ether_addr(auxdata->mac_addr))
+			memcpy(pdata->mac_addr, auxdata->mac_addr, ETH_ALEN);
 	}
 
 	match = of_match_device(davinci_emac_of_match, &pdev->dev);
-- 
1.7.9.5

