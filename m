Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaJXEPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:15:23 -0400
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:40224
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750780AbaJXEPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:15:21 -0400
From: <vndao@altera.com>
To: <f.faineli@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ngachi86@gmail.com>, Viet Nga Dao <vndao@altera.com>
Subject: [net-next] net: phy: Adding SGMII support for Marvell 88ee1145 driver
Date: Thu, 23 Oct 2014 19:41:53 -0700
Message-ID: <1414118513-12765-1-git-send-email-vndao@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(43544003)(50466002)(19580405001)(110136001)(19580395003)(68736004)(44976005)(6806004)(229853001)(105596002)(77156001)(31966008)(16796002)(102836001)(48376002)(76482002)(84676001)(99396003)(33646002)(2351001)(107046002)(104166001)(120916001)(80022003)(46102003)(87936001)(106466001)(21056001)(87286001)(88136002)(4396001)(50226001)(50986999)(36756003)(92726001)(92566001)(89996001)(62966002)(86152002)(64706001)(47776003)(93916002)(85306004)(86362001)(85852003)(95666004)(77096002)(20776003);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB214;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0374433C81
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=vndao@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB084;
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

