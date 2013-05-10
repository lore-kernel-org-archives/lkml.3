Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab3EJHaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 03:30:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64614 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3EJHaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 03:30:10 -0400
X-AuditID: 9c930179-b7bb6ae000001131-2d-518ca2010128
From: Jongsung Kim <neidhard.kim@lge.com>
To: r58129@freescale.com, davem@davemloft.net,
        sergei.shtylyov@cogentembedded.com, peppe.cavallaro@st.com,
        chohnstaedt@innominate.com, timur@freescale.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        neidhard.kim@lge.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] net: phy: realtek: add support for the RTL8201F
Date: Fri, 10 May 2013 16:29:25 +0900
Message-Id: <1368170967-20589-2-git-send-email-neidhard.kim@lge.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <201305081910.27203.neidhard.kim@lge.com>
References: <201305081910.27203.neidhard.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the minimal driver to support the Realtek RTL8201F 10/100Mbps
Ethernet Transceivers.

The help message for the config REALTEK_PHY is also modified to
describe the current status of the module correctly.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
---
 drivers/net/phy/Kconfig   |    2 +-
 drivers/net/phy/realtek.c |   52 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 1e11f2b..000425e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -84,7 +84,7 @@ config ICPLUS_PHY
 config REALTEK_PHY
 	tristate "Drivers for Realtek PHYs"
 	---help---
-	  Supports the Realtek 821x PHY.
+	  Currently supports the RTL8201F, RTL8211B and RTL8211E PHYs.
 
 config NATIONAL_PHY
 	tristate "Drivers for National Semiconductor PHYs"
diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index f902107..8e95e38 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -16,6 +16,11 @@
 #include <linux/phy.h>
 #include <linux/module.h>
 
+#define RTL8201F_INSR		0x1e
+#define RTL8201F_PGSR		0x1f
+#define RTL8201F_INER		0x13
+#define RTL8201F_INER_MASK	0x3800
+
 #define RTL821x_PHYSR		0x11
 #define RTL821x_PHYSR_DUPLEX	0x2000
 #define RTL821x_PHYSR_SPEED	0xc000
@@ -29,6 +34,15 @@ MODULE_DESCRIPTION("Realtek PHY driver");
 MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
 
+static int rtl8201f_ack_interrupt(struct phy_device *phydev)
+{
+	int err;
+
+	err = phy_read(phydev, RTL8201F_INSR);
+
+	return (err < 0) ? err : 0;
+}
+
 static int rtl821x_ack_interrupt(struct phy_device *phydev)
 {
 	int err;
@@ -38,6 +52,29 @@ static int rtl821x_ack_interrupt(struct phy_device *phydev)
 	return (err < 0) ? err : 0;
 }
 
+static void rtl8201f_select_page(struct phy_device *phydev, int page)
+{
+	phy_write(phydev, RTL8201F_PGSR, page);
+}
+
+static int rtl8201f_config_intr(struct phy_device *phydev)
+{
+	int err;
+
+	rtl8201f_select_page(phydev, 7);
+
+	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
+		err = phy_write(phydev, RTL8201F_INER, RTL8201F_INER_MASK |
+				phy_read(phydev, RTL8201F_INER));
+	else
+		err = phy_write(phydev, RTL8201F_INER, ~RTL8201F_INER_MASK &
+				phy_read(phydev, RTL8201F_INER));
+
+	rtl8201f_select_page(phydev, 0);
+
+	return err;
+}
+
 static int rtl8211b_config_intr(struct phy_device *phydev)
 {
 	int err;
@@ -65,6 +102,20 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
 }
 
 static struct phy_driver realtek_drv[] = {
+	{	/* RTL8201F */
+		.phy_id		= 0x001cc816,
+		.name		= "RTL8201F 10/100Mbps Ethernet",
+		.phy_id_mask	= 0x001fffff,
+		.features	= PHY_BASIC_FEATURES,
+		.flags		= PHY_HAS_INTERRUPT,
+		.config_aneg	= &genphy_config_aneg,
+		.read_status	= &genphy_read_status,
+		.ack_interrupt	= &rtl8201f_ack_interrupt,
+		.config_intr	= &rtl8201f_config_intr,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.driver		= { .owner = THIS_MODULE,},
+	},
 	{	/* RTL8211B */
 		.phy_id		= 0x001cc912,
 		.name		= "RTL8211B Gigabit Ethernet",
@@ -107,6 +158,7 @@ module_init(realtek_init);
 module_exit(realtek_exit);
 
 static struct mdio_device_id __maybe_unused realtek_tbl[] = {
+	{ 0x001cc816, 0x001fffff },
 	{ 0x001cc912, 0x001fffff },
 	{ 0x001cc915, 0x001fffff },
 	{ }
-- 
1.7.1

