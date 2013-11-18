Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3KRLdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:33:43 -0500
Received: from eu1sys200aog124.obsmtp.com ([207.126.144.157]:49342 "EHLO
	eu1sys200aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172Ab3KRLdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:33:31 -0500
From: <srinivas.kandagatla@st.com>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <srinivas.kandagatla@st.com>
Subject: [PATCH RFC 1/9] net: stmmac: support max-speed device tree property
Date: Mon, 18 Nov 2013 11:31:42 +0000
Message-ID: <1384774302-10095-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1384774256-10039-1-git-send-email-srinivas.kandagatla@st.com>
References: <1384774256-10039-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.65.51.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

This patch adds support to "max-speed" property which is a standard
ethernet device tree property. max-speed specifies maximum speed
(specified in megabits per second) supported the device.

Depending on the clocking schemes some of the boards can only support
few link speeds, so having a way to limit the link speed in the mac
driver would allow such setups to work reliably.

Without this patch there is no way to tell the driver to limit the
link speed.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    4 +++-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    4 ++++
 include/linux/stmmac.h                             |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8d4ccd3..f72c6a2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -784,6 +784,7 @@ static int stmmac_init_phy(struct net_device *dev)
 	char phy_id_fmt[MII_BUS_ID_SIZE + 3];
 	char bus_id[MII_BUS_ID_SIZE];
 	int interface = priv->plat->interface;
+	int max_speed = priv->plat->max_speed;
 	priv->oldlink = 0;
 	priv->speed = 0;
 	priv->oldduplex = -1;
@@ -808,7 +809,8 @@ static int stmmac_init_phy(struct net_device *dev)
 
 	/* Stop Advertising 1000BASE Capability if interface is not GMII */
 	if ((interface == PHY_INTERFACE_MODE_MII) ||
-	    (interface == PHY_INTERFACE_MODE_RMII))
+	    (interface == PHY_INTERFACE_MODE_RMII) ||
+		(max_speed < 1000 &&  max_speed > 0))
 		phydev->advertising &= ~(SUPPORTED_1000baseT_Half |
 					 SUPPORTED_1000baseT_Full);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 51c9069..3073c50 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -42,6 +42,10 @@ static int stmmac_probe_config_dt(struct platform_device *pdev,
 	*mac = of_get_mac_address(np);
 	plat->interface = of_get_phy_mode(np);
 
+	/* Get max speed of operation from device tree */
+	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
+		plat->max_speed = -1;
+
 	plat->bus_id = of_alias_get_id(np, "ethernet");
 	if (plat->bus_id < 0)
 		plat->bus_id = 0;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index bb5deb0..33ace71 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -110,6 +110,7 @@ struct plat_stmmacenet_data {
 	int force_sf_dma_mode;
 	int force_thresh_dma_mode;
 	int riwt_off;
+	int max_speed;
 	void (*fix_mac_speed)(void *priv, unsigned int speed);
 	void (*bus_setup)(void __iomem *ioaddr);
 	int (*init)(struct platform_device *pdev);
-- 
1.7.6.5

