Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3EMKOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:14:22 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59996 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab3EMKOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:14:21 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 May 2013 06:14:20 EDT
X-AuditID: 9c93017e-b7cf8ae000004f65-47-5190b975a793
From: Jongsung Kim <neidhard.kim@lge.com>
To: davem@davemloft.net, peppe.cavallaro@st.com, chohnstaedt@innominate.com,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jongsung Kim <neidhard.kim@lge.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: [PATCH v3 1/4] net: phy: realtek: simplify multiple drivers registration
Date: Mon, 13 May 2013 18:58:37 +0900
Message-Id: <1368439120-26322-1-git-send-email-neidhard.kim@lge.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <518CD784.1030709@cogentembedded.com>
References: <518CD784.1030709@cogentembedded.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the phy_drivers_register and phy_drivers_unregister to
simplify registration and error handling. The two existing
phy_driver structures are converted to an array of the
structures to do this.

v2: use proper way to register multiple drivers.

Signed-off-by: Jongsung Kim <neidhard.kim@lge.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/phy/realtek.c |   65 ++++++++++++++++++++-------------------------
 1 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 8e7af83..f902107 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -64,50 +64,43 @@ static int rtl8211e_config_intr(struct phy_device *phydev)
 	return err;
 }
 
-/* RTL8211B */
-static struct phy_driver rtl8211b_driver = {
-	.phy_id		= 0x001cc912,
-	.name		= "RTL8211B Gigabit Ethernet",
-	.phy_id_mask	= 0x001fffff,
-	.features	= PHY_GBIT_FEATURES,
-	.flags		= PHY_HAS_INTERRUPT,
-	.config_aneg	= &genphy_config_aneg,
-	.read_status	= &genphy_read_status,
-	.ack_interrupt	= &rtl821x_ack_interrupt,
-	.config_intr	= &rtl8211b_config_intr,
-	.driver		= { .owner = THIS_MODULE,},
-};
-
-/* RTL8211E */
-static struct phy_driver rtl8211e_driver = {
-	.phy_id		= 0x001cc915,
-	.name		= "RTL8211E Gigabit Ethernet",
-	.phy_id_mask	= 0x001fffff,
-	.features	= PHY_GBIT_FEATURES,
-	.flags		= PHY_HAS_INTERRUPT,
-	.config_aneg	= &genphy_config_aneg,
-	.read_status	= &genphy_read_status,
-	.ack_interrupt	= &rtl821x_ack_interrupt,
-	.config_intr	= &rtl8211e_config_intr,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
-	.driver		= { .owner = THIS_MODULE,},
+static struct phy_driver realtek_drv[] = {
+	{	/* RTL8211B */
+		.phy_id		= 0x001cc912,
+		.name		= "RTL8211B Gigabit Ethernet",
+		.phy_id_mask	= 0x001fffff,
+		.features	= PHY_GBIT_FEATURES,
+		.flags		= PHY_HAS_INTERRUPT,
+		.config_aneg	= &genphy_config_aneg,
+		.read_status	= &genphy_read_status,
+		.ack_interrupt	= &rtl821x_ack_interrupt,
+		.config_intr	= &rtl8211b_config_intr,
+		.driver		= { .owner = THIS_MODULE,},
+	},
+	{	/* RTL8211E */
+		.phy_id		= 0x001cc915,
+		.name		= "RTL8211E Gigabit Ethernet",
+		.phy_id_mask	= 0x001fffff,
+		.features	= PHY_GBIT_FEATURES,
+		.flags		= PHY_HAS_INTERRUPT,
+		.config_aneg	= &genphy_config_aneg,
+		.read_status	= &genphy_read_status,
+		.ack_interrupt	= &rtl821x_ack_interrupt,
+		.config_intr	= &rtl8211e_config_intr,
+		.suspend	= genphy_suspend,
+		.resume		= genphy_resume,
+		.driver		= { .owner = THIS_MODULE,},
+	},
 };
 
 static int __init realtek_init(void)
 {
-	int ret;
-
-	ret = phy_driver_register(&rtl8211b_driver);
-	if (ret < 0)
-		return -ENODEV;
-	return phy_driver_register(&rtl8211e_driver);
+	return phy_drivers_register(realtek_drv, ARRAY_SIZE(realtek_drv));
 }
 
 static void __exit realtek_exit(void)
 {
-	phy_driver_unregister(&rtl8211b_driver);
-	phy_driver_unregister(&rtl8211e_driver);
+	phy_drivers_unregister(realtek_drv, ARRAY_SIZE(realtek_drv));
 }
 
 module_init(realtek_init);
-- 
1.7.1

