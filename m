Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbbALPE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 10:04:27 -0500
Received: from mail-bl2on0089.outbound.protection.outlook.com ([65.55.169.89]:51389
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751202AbbALPEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 10:04:24 -0500
From: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
To: <wg@grandegger.com>, <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <soren.brinkmann@xilinx.com>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>
CC: <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: [PATCH v5] can: Convert to runtime_pm
Date: Mon, 12 Jan 2015 20:34:15 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21242.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <baf987c11c0242c2bf87b81f9396b09d@BN1BFFO11FD018.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(2201001)(62966003)(106466001)(104016003)(33646002)(229853001)(50226001)(108616004)(92566002)(92726002)(6806004)(87936001)(77156002)(48376002)(64706001)(86362001)(47776003)(46102003)(53416004)(74316001)(19580405001)(19580395003)(50466002)(50986999)(107986001)(24736002)(23106004)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB029;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB029;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1BFFO11HUB029;
X-Forefront-PRVS: 0454444834
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB029;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2015 15:04:21.3880
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of enabling/disabling clocks at several locations in the driver,
Use the runtime_pm framework. This consolidates the actions for runtime PM
In the appropriate callbacks and makes the driver more readable and mantainable.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
---
Changes for v5:
 - Updated with the review comments.
   Updated the remove fuction to use runtime_pm.
Chnages for v4:
 - Updated with the review comments.
Changes for v3:
  - Converted the driver to use runtime_pm.
Changes for v2:
  - Removed the struct platform_device* from suspend/resume
    as suggest by Lothar.

 drivers/net/can/xilinx_can.c |  157 ++++++++++++++++++++++++++++-------------
 1 files changed, 107 insertions(+), 50 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 6c67643..67aef00 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -32,6 +32,7 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 #include <linux/can/led.h>
+#include <linux/pm_runtime.h>
 
 #define DRIVER_NAME	"xilinx_can"
 
@@ -138,7 +139,7 @@ struct xcan_priv {
 	u32 (*read_reg)(const struct xcan_priv *priv, enum xcan_reg reg);
 	void (*write_reg)(const struct xcan_priv *priv, enum xcan_reg reg,
 			u32 val);
-	struct net_device *dev;
+	struct device *dev;
 	void __iomem *reg_base;
 	unsigned long irq_flags;
 	struct clk *bus_clk;
@@ -842,6 +843,13 @@ static int xcan_open(struct net_device *ndev)
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+				__func__, ret);
+		return ret;
+	}
+
 	ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
 			ndev->name, ndev);
 	if (ret < 0) {
@@ -849,29 +857,17 @@ static int xcan_open(struct net_device *ndev)
 		goto err;
 	}
 
-	ret = clk_prepare_enable(priv->can_clk);
-	if (ret) {
-		netdev_err(ndev, "unable to enable device clock\n");
-		goto err_irq;
-	}
-
-	ret = clk_prepare_enable(priv->bus_clk);
-	if (ret) {
-		netdev_err(ndev, "unable to enable bus clock\n");
-		goto err_can_clk;
-	}
-
 	/* Set chip into reset mode */
 	ret = set_reset_mode(ndev);
 	if (ret < 0) {
 		netdev_err(ndev, "mode resetting failed!\n");
-		goto err_bus_clk;
+		goto err_irq;
 	}
 
 	/* Common open */
 	ret = open_candev(ndev);
 	if (ret)
-		goto err_bus_clk;
+		goto err_irq;
 
 	ret = xcan_chip_start(ndev);
 	if (ret < 0) {
@@ -887,13 +883,11 @@ static int xcan_open(struct net_device *ndev)
 
 err_candev:
 	close_candev(ndev);
-err_bus_clk:
-	clk_disable_unprepare(priv->bus_clk);
-err_can_clk:
-	clk_disable_unprepare(priv->can_clk);
 err_irq:
 	free_irq(ndev->irq, ndev);
 err:
+	pm_runtime_put(priv->dev);
+
 	return ret;
 }
 
@@ -910,12 +904,11 @@ static int xcan_close(struct net_device *ndev)
 	netif_stop_queue(ndev);
 	napi_disable(&priv->napi);
 	xcan_chip_stop(ndev);
-	clk_disable_unprepare(priv->bus_clk);
-	clk_disable_unprepare(priv->can_clk);
 	free_irq(ndev->irq, ndev);
 	close_candev(ndev);
 
 	can_led_event(ndev, CAN_LED_EVENT_STOP);
+	pm_runtime_put(priv->dev);
 
 	return 0;
 }
@@ -934,27 +927,20 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
 
-	ret = clk_prepare_enable(priv->can_clk);
-	if (ret)
-		goto err;
-
-	ret = clk_prepare_enable(priv->bus_clk);
-	if (ret)
-		goto err_clk;
+	ret = pm_runtime_get_sync(priv->dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+				__func__, ret);
+		return ret;
+	}
 
 	bec->txerr = priv->read_reg(priv, XCAN_ECR_OFFSET) & XCAN_ECR_TEC_MASK;
 	bec->rxerr = ((priv->read_reg(priv, XCAN_ECR_OFFSET) &
 			XCAN_ECR_REC_MASK) >> XCAN_ESR_REC_SHIFT);
 
-	clk_disable_unprepare(priv->bus_clk);
-	clk_disable_unprepare(priv->can_clk);
+	pm_runtime_put(priv->dev);
 
 	return 0;
-
-err_clk:
-	clk_disable_unprepare(priv->can_clk);
-err:
-	return ret;
 }
 
 
@@ -967,15 +953,45 @@ static const struct net_device_ops xcan_netdev_ops = {
 
 /**
  * xcan_suspend - Suspend method for the driver
- * @dev:	Address of the platform_device structure
+ * @dev:	Address of the device structure
  *
  * Put the driver into low power mode.
- * Return: 0 always
+ * Return: 0 on success and failure value on error
  */
 static int __maybe_unused xcan_suspend(struct device *dev)
 {
-	struct platform_device *pdev = dev_get_drvdata(dev);
-	struct net_device *ndev = platform_get_drvdata(pdev);
+	if (!device_may_wakeup(dev))
+		return pm_runtime_force_suspend(dev);
+
+	return 0;
+}
+
+/**
+ * xcan_resume - Resume from suspend
+ * @dev:	Address of the device structure
+ *
+ * Resume operation after suspend.
+ * Return: 0 on success and failure value on error
+ */
+static int __maybe_unused xcan_resume(struct device *dev)
+{
+	if (!device_may_wakeup(dev))
+		return pm_runtime_force_resume(dev);
+
+	return 0;
+
+}
+
+/**
+ * xcan_runtime_suspend - Runtime suspend method for the driver
+ * @dev:	Address of the device structure
+ *
+ * Put the driver into low power mode.
+ * Return: 0 always
+ */
+static int __maybe_unused xcan_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
 	struct xcan_priv *priv = netdev_priv(ndev);
 
 	if (netif_running(ndev)) {
@@ -993,18 +1009,18 @@ static int __maybe_unused xcan_suspend(struct device *dev)
 }
 
 /**
- * xcan_resume - Resume from suspend
- * @dev:	Address of the platformdevice structure
+ * xcan_runtime_resume - Runtime resume from suspend
+ * @dev:	Address of the device structure
  *
  * Resume operation after suspend.
  * Return: 0 on success and failure value on error
  */
-static int __maybe_unused xcan_resume(struct device *dev)
+static int __maybe_unused xcan_runtime_resume(struct device *dev)
 {
-	struct platform_device *pdev = dev_get_drvdata(dev);
-	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct net_device *ndev = dev_get_drvdata(dev);
 	struct xcan_priv *priv = netdev_priv(ndev);
 	int ret;
+	u32 isr, status;
 
 	ret = clk_enable(priv->bus_clk);
 	if (ret) {
@@ -1014,15 +1030,28 @@ static int __maybe_unused xcan_resume(struct device *dev)
 	ret = clk_enable(priv->can_clk);
 	if (ret) {
 		dev_err(dev, "Cannot enable clock.\n");
-		clk_disable_unprepare(priv->bus_clk);
+		clk_disable(priv->bus_clk);
 		return ret;
 	}
 
 	priv->write_reg(priv, XCAN_MSR_OFFSET, 0);
 	priv->write_reg(priv, XCAN_SRR_OFFSET, XCAN_SRR_CEN_MASK);
-	priv->can.state = CAN_STATE_ERROR_ACTIVE;
+	isr = priv->read_reg(priv, XCAN_ISR_OFFSET);
+	status = priv->read_reg(priv, XCAN_SR_OFFSET);
 
 	if (netif_running(ndev)) {
+		if (isr & XCAN_IXR_BSOFF_MASK) {
+			priv->can.state = CAN_STATE_BUS_OFF;
+			priv->write_reg(priv, XCAN_SRR_OFFSET,
+					XCAN_SRR_RESET_MASK);
+		} else if ((status & XCAN_SR_ESTAT_MASK) ==
+					XCAN_SR_ESTAT_MASK) {
+			priv->can.state = CAN_STATE_ERROR_PASSIVE;
+		} else if (status & XCAN_SR_ERRWRN_MASK) {
+			priv->can.state = CAN_STATE_ERROR_WARNING;
+		} else {
+			priv->can.state = CAN_STATE_ERROR_ACTIVE;
+		}
 		netif_device_attach(ndev);
 		netif_start_queue(ndev);
 	}
@@ -1030,7 +1059,10 @@ static int __maybe_unused xcan_resume(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(xcan_dev_pm_ops, xcan_suspend, xcan_resume);
+static const struct dev_pm_ops xcan_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(xcan_suspend, xcan_resume)
+	SET_PM_RUNTIME_PM_OPS(xcan_runtime_suspend, xcan_runtime_resume, NULL)
+};
 
 /**
  * xcan_probe - Platform registration call
@@ -1071,7 +1103,7 @@ static int xcan_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = netdev_priv(ndev);
-	priv->dev = ndev;
+	priv->dev = &pdev->dev;
 	priv->can.bittiming_const = &xcan_bittiming_const;
 	priv->can.do_set_mode = xcan_do_set_mode;
 	priv->can.do_get_berr_counter = xcan_get_berr_counter;
@@ -1137,6 +1169,16 @@ static int xcan_probe(struct platform_device *pdev)
 
 	netif_napi_add(ndev, &priv->napi, xcan_rx_poll, rx_max);
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_irq_safe(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+			__func__, ret);
+		goto err_pmdisable;
+	}
+
 	ret = register_candev(ndev);
 	if (ret) {
 		dev_err(&pdev->dev, "fail to register failed (err=%d)\n", ret);
@@ -1144,15 +1186,19 @@ static int xcan_probe(struct platform_device *pdev)
 	}
 
 	devm_can_led_init(ndev);
-	clk_disable_unprepare(priv->bus_clk);
-	clk_disable_unprepare(priv->can_clk);
+
+	pm_runtime_put(&pdev->dev);
+
 	netdev_dbg(ndev, "reg_base=0x%p irq=%d clock=%d, tx fifo depth:%d\n",
 			priv->reg_base, ndev->irq, priv->can.clock.freq,
 			priv->tx_max);
 
 	return 0;
 
+err_pmdisable:
+	pm_runtime_disable(&pdev->dev);
 err_unprepare_disable_busclk:
+	pm_runtime_put(priv->dev);
 	clk_disable_unprepare(priv->bus_clk);
 err_unprepare_disable_dev:
 	clk_disable_unprepare(priv->can_clk);
@@ -1173,12 +1219,23 @@ static int xcan_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct xcan_priv *priv = netdev_priv(ndev);
+	int ret;
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
+				__func__, ret);
+		return ret;
+	}
 
 	if (set_reset_mode(ndev) < 0)
 		netdev_err(ndev, "mode resetting failed!\n");
 
 	unregister_candev(ndev);
+	pm_runtime_disable(&pdev->dev);
 	netif_napi_del(&priv->napi);
+	clk_disable_unprepare(priv->bus_clk);
+	clk_disable_unprepare(priv->can_clk);
 	free_candev(ndev);
 
 	return 0;
-- 
1.7.4

