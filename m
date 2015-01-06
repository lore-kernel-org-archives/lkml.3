Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbbAFNsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:48:52 -0500
Received: from mail-am1on0137.outbound.protection.outlook.com ([157.56.112.137]:24773
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755294AbbAFNsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:48:16 -0500
X-Greylist: delayed 560 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2015 08:48:15 EST
From: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
To: <linux-kernel@vger.kernel.org>
CC: <b45643@freescale.com>, <LW@KARO-electronics.de>, <Frank.Li@freescale.com>,
        <B38611@freescale.com>, <davem@davemloft.net>, <stefan@agner.ch>,
        Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
Subject: [PATCH] net: fec: Fix dual ethernet issue in VFxx
Date: Tue, 6 Jan 2015 19:17:32 +0530
Message-ID: <1420552052-4697-1-git-send-email-bhuvanchandra.dv@toradex.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [122.166.214.162]
X-ClientProxiedBy: HKNPR06CA0042.apcprd06.prod.outlook.com (10.141.16.32) To
 DB4PR05MB270.eurprd05.prod.outlook.com (10.242.158.24)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=bhuvanchandra.dv@toradex.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:DB4PR05MB270;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DB4PR05MB270;
X-Forefront-PRVS: 0448A97BF2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(46102003)(50986999)(101416001)(77156002)(68736005)(31966008)(77096005)(66066001)(64706001)(47776003)(62966003)(89996001)(20776003)(87976001)(53416004)(229853001)(2351001)(107046002)(4396001)(42186005)(50226001)(105586002)(81156004)(33646002)(50466002)(106356001)(36756003)(120916001)(110136001)(92566001)(21056001)(48376002)(86362001)(19580395003)(97736003)(40100003)(99396003)(69596002)(122386002)(19580405001)(7059030);DIR:OUT;SFP:1102;SCL:1;SRVR:DB4PR05MB270;H:trdx.toradex.int;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DB4PR05MB270;
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 13:48:00.2064 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR05MB270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On i.MX28, the MDIO bus is shared between the
two RMII interfaces. However, in newer designs,
such as Vybrid, this is not the case. This patch
adds a quirk for the single MDIO case. This allows
to use both FEC interfaces working independently
on Vybird.

Signed-off-by: Bhuvanchandra DV <bhuvanchandra.dv@toradex.com>
---
 drivers/net/ethernet/freescale/fec.h      |    3 +++
 drivers/net/ethernet/freescale/fec_main.c |    7 ++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 469691a..c9515bc 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -425,6 +425,9 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_BUG_CAPTURE		(1 << 10)
 
+/* Controller has only one MDIO bus for interfacing external PHY's */
+#define FEC_QUIRK_SINGLE_MDIO		(1 << 11)
+
 struct fec_enet_priv_tx_q {
 	int index;
 	unsigned char *tx_bounce[TX_RING_SIZE];
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 5ebdf8d..22b7748 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -91,7 +91,8 @@ static struct platform_device_id fec_devtype[] = {
 		.driver_data = 0,
 	}, {
 		.name = "imx28-fec",
-		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME,
+		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_SWAP_FRAME |
+				FEC_QUIRK_SINGLE_MDIO,
 	}, {
 		.name = "imx6q-fec",
 		.driver_data = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
@@ -1952,7 +1953,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	 * mdio interface in board design, and need to be configured by
 	 * fec0 mii_bus.
 	 */
-	if ((fep->quirks & FEC_QUIRK_ENET_MAC) && fep->dev_id > 0) {
+	if ((fep->quirks & FEC_QUIRK_SINGLE_MDIO) && fep->dev_id > 0) {
 		/* fec1 uses fec0 mii_bus */
 		if (mii_cnt && fec0_mii_bus) {
 			fep->mii_bus = fec0_mii_bus;
@@ -2015,7 +2016,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	mii_cnt++;
 
 	/* save fec0 mii_bus */
-	if (fep->quirks & FEC_QUIRK_ENET_MAC)
+	if (fep->quirks & FEC_QUIRK_SINGLE_MDIO)
 		fec0_mii_bus = fep->mii_bus;
 
 	return 0;
-- 
1.7.9.5

