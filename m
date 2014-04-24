Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375AbaDXJZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:25:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47016 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaDXIz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 152/182] Revert "net: mvneta: fix usage as a module on RGMII configurations"
Date: Thu, 24 Apr 2014 09:51:17 +0100
Message-Id: <1398329507-5911-153-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit cc6ca3023f2c2bbcd062e9d4cf6afc2ba2821ada upstream.

This reverts commit e3a8786c10e75903f1269474e21fe8cb49c3a670. While
this commit allows to use the mvneta driver as a module on some
configurations, it breaks other configurations even if mvneta is used
built-in.

This breakage is due to the fact that on some RGMII platforms, the PCS
bit has to be set, and on some other platforms, it has to be
cleared. At the moment, we lack informations to know exactly the
significance of this bit (the datasheet only says "enables PCS"), and
so we can't produce a patch that will work on all platforms at this
point. And since this change is breaking the network completely for
many users, it's much better to revert it for now. We'll come back
later with a proper fix that takes into account all platforms.

Basically:

 * Armada XP GP is configured as RGMII-ID, and needs the PCS bit to be
   set.
 * Armada 370 Mirabox is configured as RGMII-ID, and needs the PCS bit
   to be cleared.

And at the moment, we don't know how to make the distinction between
those two cases. One hint is that the Armada XP GP appears in fact to
be using a QSGMII connection with the PHY (Quad-SGMII), but
configuring it as SGMII doesn't work, while RGMII-ID works. This needs
more investigation, but in the mean time, let's unbreak the network
for all those users.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Reported-by: Arnaud Ebalard <arno@natisbad.org>
Reported-by: Alexander Reuter <Alexander.Reuter@gmx.net>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=73401
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 41 ++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 79ffd68..b8aea9a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -88,9 +88,8 @@
 #define      MVNETA_TX_IN_PRGRS                  BIT(1)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
-#define MVNETA_SERDES_CFG			 0x24A0
+#define MVNETA_SGMII_SERDES_CFG			 0x24A0
 #define      MVNETA_SGMII_SERDES_PROTO		 0x0cc7
-#define      MVNETA_RGMII_SERDES_PROTO		 0x0667
 #define MVNETA_TYPE_PRIO                         0x24bc
 #define      MVNETA_FORCE_UNI                    BIT(21)
 #define MVNETA_TXQ_CMD_1                         0x24e4
@@ -635,6 +634,35 @@ static void mvneta_rxq_bm_disable(struct mvneta_port *pp,
 	mvreg_write(pp, MVNETA_RXQ_CONFIG_REG(rxq->id), val);
 }
 
+
+
+/* Sets the RGMII Enable bit (RGMIIEn) in port MAC control register */
+static void mvneta_gmac_rgmii_set(struct mvneta_port *pp, int enable)
+{
+	u32  val;
+
+	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
+
+	if (enable)
+		val |= MVNETA_GMAC2_PORT_RGMII;
+	else
+		val &= ~MVNETA_GMAC2_PORT_RGMII;
+
+	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
+}
+
+/* Config SGMII port */
+static void mvneta_port_sgmii_config(struct mvneta_port *pp)
+{
+	u32 val;
+
+	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
+	val |= MVNETA_GMAC2_PCS_ENABLE;
+	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
+
+	mvreg_write(pp, MVNETA_SGMII_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
+}
+
 /* Start the Ethernet port RX and TX activity */
 static void mvneta_port_up(struct mvneta_port *pp)
 {
@@ -2646,15 +2674,12 @@ static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
 
 	if (phy_mode == PHY_INTERFACE_MODE_SGMII)
-		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_SGMII_SERDES_PROTO);
-	else
-		mvreg_write(pp, MVNETA_SERDES_CFG, MVNETA_RGMII_SERDES_PROTO);
+		mvneta_port_sgmii_config(pp);
 
-	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
-
-	val |= MVNETA_GMAC2_PCS_ENABLE | MVNETA_GMAC2_PORT_RGMII;
+	mvneta_gmac_rgmii_set(pp, 1);
 
 	/* Cancel Port Reset */
+	val = mvreg_read(pp, MVNETA_GMAC_CTRL_2);
 	val &= ~MVNETA_GMAC2_PORT_RESET;
 	mvreg_write(pp, MVNETA_GMAC_CTRL_2, val);
 
-- 
1.9.1

