Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbaKMHcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 02:32:10 -0500
Received: from mail-by2on0096.outbound.protection.outlook.com ([207.46.100.96]:50272
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751336AbaKMHcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 02:32:08 -0500
From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
To: <wg@grandegger.com>, <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
CC: <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: [PATCH] can: Fix bug in suspend/resume
Date: Thu, 13 Nov 2014 12:28:11 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21098.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <a44efc1fb0144cca9d0c4851cc51db25@BL2FFO11FD024.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(199003)(6806004)(102836001)(229853001)(50986999)(2201001)(53416004)(104166001)(20776003)(46102003)(77156002)(50466002)(77096003)(104016003)(87286001)(92566001)(86362001)(50226001)(47776003)(74316001)(4396001)(107046002)(19580405001)(95666004)(44976005)(106466001)(21056001)(62966003)(99396003)(120916001)(64706001)(88136002)(87936001)(108616004)(48376002)(89996001)(19580395003)(31966008)(93916002)(107986001)(24736002)(23106004)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB054;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB054;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB054;
X-Forefront-PRVS: 0394259C80
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB054;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When accessing the priv structure use container_of instead of dev_get_drvdata.
Enable the clocks in the suspend before accessing the registers of the CAN.

Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
---
 drivers/net/can/xilinx_can.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 5e8b560..63ef645 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -972,15 +972,30 @@ static const struct net_device_ops xcan_netdev_ops = {
  */
 static int __maybe_unused xcan_suspend(struct device *dev)
 {
-	struct platform_device *pdev = dev_get_drvdata(dev);
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
 	struct net_device *ndev = platform_get_drvdata(pdev);
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
 
@@ -999,7 +1014,8 @@ static int __maybe_unused xcan_suspend(struct device *dev)
  */
 static int __maybe_unused xcan_resume(struct device *dev)
 {
-	struct platform_device *pdev = dev_get_drvdata(dev);
+	struct platform_device *pdev = container_of(dev,
+			struct platform_device, dev);
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
-- 
1.7.4

