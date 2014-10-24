Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaJXDDF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:03:05 -0400
Received: from mail-bl2on0082.outbound.protection.outlook.com ([65.55.169.82]:43072
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbaJXDDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:03:03 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Oct 2014 23:03:03 EDT
From: <vndao@altera.com>
To: <f.fainelli@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ngachi86@gmail.com>, Viet Nga Dao <vndao@altera.com>
Subject: [net-next] net: phy: Adding SGMII support for Marvell 88ee1145 driver
Date: Thu, 23 Oct 2014 19:47:57 -0700
Message-ID: <1414118877-12837-1-git-send-email-vndao@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(43544003)(189002)(46102003)(50986999)(44976005)(19580395003)(19580405001)(85306004)(36756003)(77156001)(87286001)(87936001)(68736004)(64706001)(33646002)(104166001)(84676001)(47776003)(6806004)(110136001)(20776003)(99396003)(80022003)(21056001)(120916001)(76482002)(106466001)(93916002)(105596002)(86362001)(229853001)(2351001)(107046002)(86152002)(92726001)(92566001)(77096002)(95666004)(4396001)(50226001)(50466002)(48376002)(102836001)(88136002)(89996001)(62966002)(16796002)(31966008)(85852003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB1024;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB1024;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=vndao@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viet Nga Dao <vndao@altera.com>

Additional code to m88e1145_config_init function to allow the driver to
support SGMII mode.

Signed-off-by: Viet Nga Dao <vndao@altera.com>
---
 drivers/net/phy/marvell.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index bd37e45..b14cb10 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -50,9 +50,13 @@
 #define MII_M1011_PHY_SCR		0x10
 #define MII_M1011_PHY_SCR_AUTO_CROSS	0x0060
 
+#define MII_M1145_PHY_EXT_SR		0x1b
 #define MII_M1145_PHY_EXT_CR		0x14
 #define MII_M1145_RGMII_RX_DELAY	0x0080
 #define MII_M1145_RGMII_TX_DELAY	0x0002
+#define MII_M1145_HWCFG_MODE_SGMII_NO_CLK	0x4
+#define MII_M1145_HWCFG_MODE_MASK		0xf
+#define MII_M1145_HWCFG_FIBER_COPPER_AUTO	0x8000
 
 #define MII_M1111_PHY_LED_CONTROL	0x18
 #define MII_M1111_PHY_LED_DIRECT	0x4100
@@ -620,6 +624,7 @@ static int m88e1149_config_init(struct phy_device *phydev)
 static int m88e1145_config_init(struct phy_device *phydev)
 {
 	int err;
+	int temp;
 
 	/* Take care of errata E0 & E1 */
 	err = phy_write(phydev, 0x1d, 0x001b);
@@ -676,6 +681,20 @@ static int m88e1145_config_init(struct phy_device *phydev)
 		}
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		temp = phy_read(phydev, MII_M1145_PHY_EXT_SR);
+		if (temp < 0)
+			return temp;
+
+		temp &= ~(MII_M1145_HWCFG_MODE_MASK);
+		temp |= MII_M1145_HWCFG_MODE_SGMII_NO_CLK;
+		temp |= MII_M1145_HWCFG_FIBER_COPPER_AUTO;
+
+		err = phy_write(phydev, MII_M1145_PHY_EXT_SR, temp);
+		if (err < 0)
+			return err;
+	}
+
 	err = marvell_of_reg_init(phydev);
 	if (err < 0)
 		return err;
-- 
1.7.7.4

