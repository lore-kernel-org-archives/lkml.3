Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaKNIQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:16:36 -0500
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:16299
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754440AbaKNIQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:16:34 -0500
X-Greylist: delayed 76702 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Nov 2014 03:16:33 EST
From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
To: <wg@grandegger.com>, <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
CC: <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: [PATCH v2] can: Fix bug in suspend/resume
Date: Fri, 14 Nov 2014 13:46:19 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21102.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <e7070431858e49e29cd03d76fd7a66c3@BN1AFFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(46102003)(92566001)(4396001)(31966008)(47776003)(20776003)(19580405001)(50226001)(87286001)(87936001)(62966003)(44976005)(77156002)(77096003)(2201001)(88136002)(93916002)(102836001)(104166001)(50986999)(99396003)(86362001)(64706001)(120916001)(95666004)(21056001)(6806004)(33646002)(19580395003)(53416004)(48376002)(50466002)(106466001)(107046002)(104016003)(229853001)(89996001)(108616004)(107986001)(24736002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB017;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB017;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB017;
X-Forefront-PRVS: 03950F25EC
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB017;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drvdata in the suspend/resume is of type struct net_device,
not the platform device.Enable the clocks in the suspend before
accessing the registers of the CAN.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
---
Changes for v2:
  - Removed the struct platform_device* from suspend/resume
    as suggest by Lothar.
  - The clocks are getting disabled and un prepared at the end of the probe. 
    In the suspend the driver is doing a register write.In order
    To do that register write we have to again enable and prepare the clocks.

  
 drivers/net/can/xilinx_can.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 5e8b560..485262f 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -972,15 +972,28 @@ static const struct net_device_ops xcan_netdev_ops = {
  */
 static int __maybe_unused xcan_suspend(struct device *dev)
 {
-	struct platform_device *pdev = dev_get_drvdata(dev);
-	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 	struct xcan_priv *priv = netdev_priv(ndev);
+	int ret;
 
 	if (netif_running(ndev)) {
 		netif_stop_queue(ndev);
 		netif_device_detach(ndev);
 	}
 
+	ret = clk_prepare_enable(priv->can_clk);
+	if (ret) {
+		dev_err(dev, "unable to enable device clock\n");
+		return ret;
+	}
+
+	ret = clk_prepare_enable(priv->bus_clk);
+	if (ret) {
+		dev_err(dev, "unable to enable bus clock\n");
+		clk_disable_unprepare(priv->can_clk);
+		return ret;
+	}
+
 	priv->write_reg(priv, XCAN_MSR_OFFSET, XCAN_MSR_SLEEP_MASK);
 	priv->can.state = CAN_STATE_SLEEPING;
 
@@ -999,8 +1012,7 @@ static int __maybe_unused xcan_suspend(struct device *dev)
  */
 static int __maybe_unused xcan_resume(struct device *dev)
 {
-	struct platform_device *pdev = dev_get_drvdata(dev);
-	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-- 
1.7.4

