Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaAPK6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 05:58:20 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:58916 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbaAPK6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:58:16 -0500
From: <srinivas.kandagatla@st.com>
To: <netdev@vger.kernel.org>
Cc: Giuseppe CAVALLARO <peppe.cavallaro@st.com>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@st.com>
Subject: [PATCH v2 6/9] net: stmmac: fix power management suspend-resume case
Date: Thu, 16 Jan 2014 10:52:35 +0000
Message-ID: <1389869555-28259-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1389869450-28003-1-git-send-email-srinivas.kandagatla@st.com>
References: <1389869450-28003-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

The driver PM resume assumes that the IP is still powered up and the
all the register contents are not disturbed when it comes out of low
power suspend case. This assumption is wrong, basically the driver
should not consider any state of registers after it comes out of low
power. However driver can keep the part of the IP powered up if its a
wake up source. But it can not assume the register state of the IP. Also
its possible that SOC glue layer can take the power off the IP if its
not wake-up source to reduce the power consumption.

This patch re initializes hardware by calling stmmac_hw_setup function in
resume case.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 341c8dc..742a83f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2887,18 +2887,19 @@ int stmmac_resume(struct net_device *ndev)
 	 * this bit because it can generate problems while resuming
 	 * from another devices (e.g. serial console).
 	 */
-	if (device_may_wakeup(priv->device))
+	if (device_may_wakeup(priv->device)) {
 		priv->hw->mac->pmt(priv->ioaddr, 0);
-	else
+	} else {
 		/* enable the clk prevously disabled */
 		clk_prepare_enable(priv->stmmac_clk);
+		/* reset the phy so that it's ready */
+		if (priv->mii)
+			stmmac_mdio_reset(priv->mii);
+	}
 
 	netif_device_attach(ndev);
 
-	/* Enable the MAC and DMA */
-	stmmac_set_mac(priv->ioaddr, true);
-	priv->hw->dma->start_tx(priv->ioaddr);
-	priv->hw->dma->start_rx(priv->ioaddr);
+	stmmac_hw_setup(ndev);
 
 	napi_enable(&priv->napi);
 
-- 
1.7.6.5

