Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030222AbaDBUQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 16:16:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:42875 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758937AbaDBUNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 16:13:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 38/40] net: mvneta: fix usage as a module on RGMII configurations
Date: Wed,  2 Apr 2014 22:13:24 +0200
Message-Id: <8253c853ea4c0d62e085b49cab5b7153c87fad36.1396469191.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
References: <4c74007da904cc0411d788200034b2fb4c9e0d01.1396469191.git.jslaby@suse.cz>
In-Reply-To: <cover.1396469191.git.jslaby@suse.cz>
References: <cover.1396469191.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e3a8786c10e75903f1269474e21fe8cb49c3a670 upstream.

Commit 5445eaf309ff ('mvneta: Try to fix mvneta when compiled as
module') fixed the mvneta driver to make it work properly when loaded
as a module in SGMII configuration, which was tested successful by the
author on the Armada XP OpenBlocks AX3, which uses SGMII.

However, it turns out that the Armada XP GP, which uses RGMII, is
affected by a similar problem: its SERDES configuration is lost when
mvneta is loaded as a module, because this configuration is set by the
bootloader, and then lost because the clock is gated by the clock
framework until the mvneta driver is loaded again and the clock is
re-enabled.

However, it turns out that for the RGMII case, setting the SERDES
configuration is not sufficient: the PCS enable bit in the
MVNETA_GMAC_CTRL_2 register must also be set, like in the SGMII
configuration.

Therefore, this commit reworks the SGMII/RGMII initialization: the
only difference between the two now is a different SERDES
configuration, all the rest is identical.

In detail, to achieve this, the commit:

 * Renames MVNETA_SGMII_SERDES_CFG to MVNETA_SERDES_CFG because it is
   not specific to SGMII, but also used on RGMII configurations.

 * Adds a MVNETA_RGMII_SERDES_PROTO definition, that must be used as
   the MVNETA_SERDES_CFG value in RGMII configurations.

 * Removes the mvneta_gmac_rgmii_set() and mvneta_port_sgmii_config()
   functions, and instead directly do the SGMII/RGMII configuration in
   mvneta_port_up(), from where those functions where called. It is
   worth mentioning that mvneta_gmac_rgmii_set() had an 'enable'
   parameter that was always passed as '1', so it was pretty useless.

 * Reworks the mvneta_port_up() function to set the MVNETA_SERDES_CFG
   register to the appropriate value depending on the RGMII vs. SGMII
   configuration. It also unconditionally set the PCS_ENABLE bit (was
   already done for SGMII, but is now also needed for RGMII), and sets
   the PORT_RGMII bit (which was already done for both SGMII and
   RGMII).

This commit was successfully tested with mvneta compiled as a module,
on both the OpenBlocks AX3 (SGMII configuration) and the Armada XP GP
(RGMII configuration).

Reported-by: Steve McIntyre <steve@einval.com>
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/marvell/mvneta.c | 41 +++++++----------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 5cdd2b2f18c5..71d9cad02704 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -88,8 +88,9 @@
 #define      MVNETA_TX_IN_PRGRS                  BIT(1)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
-#define MVNETA_SGMII_SERDES_CFG			 0x24A0
+#define MVNETA_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
+#define      MVNETA_RGMII_SERDES_PROTO		 0x0667
 #define MVNETA_TYPE_PRIO                         0x24bc
 #define      MVNETA_FORCE_UNI                    BIT(21)
 #define MVNETA_TXQ_CMD_1                         0x24e4
@@ -665,35 +666,6 @@ static void mvneta_rxq_bm_disable(struct mvneta_port *pp,
 	mvreg_write(pp, MVNETA_RXQ_CONFIG_REG(rxq->id), val);
 }
 
-
-
-/* Sets the RGMII Enable bit (RGMIIEn) in port MAC control register */
-static void mvneta_gmac_rgmii_set(struct mvneta_port *pp, int enable)
-{
-	u32  val;
-
-	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
-
-	if (enable)
-		val |= MVNETA_GMAC2_PORT_RGMII;
-	else
-		val &= ~MVNETA_GMAC2_PORT_RGMII;
-
-	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
-}
-
-/* Config SGMII port */
-static void mvneta_port_sgmii_config(struct mvneta_port *pp)
-{
-	u32 val;
-
-	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
-	val |= MVNETA_GMAC2_PCS_ENABLE;
-	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
-
-	mvreg_write(pp, MVNETA_SGMII_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
-}
-
 /* Start the Ethernet port RX and TX activity */
 static void mvneta_port_up(struct mvneta_port *pp)
 {
@@ -2723,12 +2695,15 @@ static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
 
 	if (phy_mode == PHY_INTERFACE_MODE_SGMII)
-		mvneta_port_sgmii_config(pp);
+		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
+	else
+		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_RGMII_SERDES_PROTO);
 
-	mvneta_gmac_rgmii_set(pp, 1);
+	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
+
+	val |= MVNETA_GMAC2_PCS_ENABLE | MVNETA_GMAC2_PORT_RGMII;
 
 	/* Cancel Port Reset */
-	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
 	val &= ~MVNETA_GMAC2_PORT_RESET;
 	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
 
-- 
1.9.1

