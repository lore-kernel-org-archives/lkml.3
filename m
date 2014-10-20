Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaJTS4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:56:47 -0400
Received: from mail-bn1bon0096.outbound.protection.outlook.com ([157.56.111.96]:15424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751360AbaJTS4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:56:40 -0400
From: <dinguyen@opensource.altera.com>
To: <paulz@synopsys.com>, <balbi@ti.com>
CC: <dinh.linux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <b.zolnierkie@samsung.com>,
        <matthijs@stdin.nl>, <r.baldyga@samsung.com>, <jg1.han@samsung.com>,
        <sachin.kamat@linaro.org>, <ben-linux@fluff.org>,
        <dianders@chromium.org>, <kever.yang@rock-chips.com>,
        <linux-usb@vger.kernel.org>,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Subject: [PATCHv5 2/7] usb: dwc2: Move gadget probe function into platform code
Date: Mon, 20 Oct 2014 13:52:01 -0500
Message-ID: <1413831126-24193-3-git-send-email-dinguyen@opensource.altera.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
References: <1413831126-24193-1-git-send-email-dinguyen@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: SIXPR03CA014.apcprd03.prod.outlook.com (10.141.119.24) To
 BY1PR0301MB1189.namprd03.prod.outlook.com (25.160.195.148)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1189;
X-Forefront-PRVS: 03706074BC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(189002)(199003)(95666004)(20776003)(105586002)(88136002)(21056001)(102836001)(77096002)(97736003)(80022003)(99396003)(31966008)(107046002)(77156001)(106356001)(229853001)(81156004)(42186005)(76482002)(46102003)(66066001)(64706001)(120916001)(47776003)(53416004)(40100003)(33646002)(87976001)(93916002)(62966002)(575784001)(86362001)(122386002)(19580405001)(19580395003)(50466002)(69596002)(87286001)(4396001)(104166001)(50226001)(86152002)(92726001)(92566001)(48376002)(50986999)(76176999)(85306004)(101416001)(85852003)(89996001)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1189;H:linux-builds1.altera.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@opensource.altera.com>

This patch will aggregate the probing of gadget/hcd driver into platform.c.
The gadget probe funtion is converted into gadget_init that is now only
responsible for gadget only initialization. All the gadget resources is now
handled by platform.c

Since the host workqueue will not get initialized if the driver is configured
for peripheral mode only. Thus we need to check for wq_otg before calling
queue_work().

Also, we move spin_lock_init to common location for both host and gadget that
is either in platform.c or pci.c.

We also ove suspend/resume code to common platform code, and update it to use
the new PM API (struct dev_pm_ops).

Lastly, move the "samsung,s3c6400-hsotg" binding into dwc2_of_match_table.

Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
Acked-by: Paul Zimmerman <paulz@synopsys.com>
---
v5: Reworked by squashing the following commits into this one:
* [PATCHv4 02/12] usb: dwc2: move "samsung,s3c6400-hsotg" into common platform
* [PATCHv4 03/12] usb: dwc2: Update the gadget driver to use common dwc2_hsotg
  structure
* [PATCHv4 09/12] usb: dwc2: initialize the spin_lock for both host and gadget
* [PATCHv4 10/12] usb: dwc2: Add suspend/resume for gadget
* [PATCHv4 11/12] usb: dwc2: check that the host work queue is valid
    Also use IS_ENABLED instead of #if defined
---
 drivers/usb/dwc2/core.h      | 34 +++++++++++++++-
 drivers/usb/dwc2/core_intr.c |  8 ++--
 drivers/usb/dwc2/gadget.c    | 97 +++++++++-----------------------------------
 drivers/usb/dwc2/hcd.c       |  1 -
 drivers/usb/dwc2/hcd.h       | 10 -----
 drivers/usb/dwc2/pci.c       |  1 +
 drivers/usb/dwc2/platform.c  | 32 +++++++++++++++
 7 files changed, 91 insertions(+), 92 deletions(-)

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 5412f57..b21aace 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -667,7 +667,6 @@ struct dwc2_hsotg {
 	struct usb_phy *uphy;
 	struct s3c_hsotg_plat *plat;
 
-	int	irq;
 	struct clk *clk;
 
 	struct regulator_bulk_data supplies[ARRAY_SIZE(s3c_hsotg_supply_names)];
@@ -961,4 +960,37 @@ extern void dwc2_dump_global_registers(struct dwc2_hsotg *hsotg);
  */
 extern u16 dwc2_get_otg_version(struct dwc2_hsotg *hsotg);
 
+/* Gadget defines */
+#if IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+extern int s3c_hsotg_remove(struct dwc2_hsotg *hsotg);
+extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
+extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
+extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
+#else
+static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
+{ return 0; }
+static inline int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2)
+{ return 0; }
+static inline int s3c_hsotg_resume(struct dwc2_hsotg *dwc2)
+{ return 0; }
+static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
+{ return 0; }
+#endif
+
+#if IS_ENABLED(CONFIG_USB_DWC2_HOST) || IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)
+extern int dwc2_hcd_get_frame_number(struct dwc2_hsotg *hsotg);
+extern void dwc2_hcd_disconnect(struct dwc2_hsotg *hsotg);
+extern void dwc2_hcd_start(struct dwc2_hsotg *hsotg);
+#else
+static inline void dwc2_set_all_params(struct dwc2_core_params *params, int value) {}
+static inline int dwc2_hcd_get_frame_number(struct dwc2_hsotg *hsotg)
+{ return 0; }
+static inline void dwc2_hcd_disconnect(struct dwc2_hsotg *hsotg) {}
+static inline void dwc2_hcd_start(struct dwc2_hsotg *hsotg) {}
+static inline void dwc2_hcd_remove(struct dwc2_hsotg *hsotg) {}
+static inline int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int irq,
+				const struct dwc2_core_params *params)
+{ return 0; }
+#endif
+
 #endif /* __DWC2_CORE_H__ */
diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index c93918b..b176c2f 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -287,9 +287,11 @@ static void dwc2_handle_conn_id_status_change_intr(struct dwc2_hsotg *hsotg)
 	 * Release lock before scheduling workq as it holds spinlock during
 	 * scheduling.
 	 */
-	spin_unlock(&hsotg->lock);
-	queue_work(hsotg->wq_otg, &hsotg->wf_otg);
-	spin_lock(&hsotg->lock);
+	if (hsotg->wq_otg) {
+		spin_unlock(&hsotg->lock);
+		queue_work(hsotg->wq_otg, &hsotg->wf_otg);
+		spin_lock(&hsotg->lock);
+	}
 
 	/* Clear interrupt */
 	writel(GINTSTS_CONIDSTSCHNG, hsotg->regs + GINTSTS);
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 6611ea3..c407d33 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3404,26 +3404,21 @@ static void s3c_hsotg_delete_debug(struct dwc2_hsotg *hsotg)
 }
 
 /**
- * s3c_hsotg_probe - probe function for hsotg driver
- * @pdev: The platform information for the driver
+ * dwc2_gadget_init - init function for gadget
+ * @dwc2: The data structure for the DWC2 driver.
+ * @irq: The IRQ number for the controller.
  */
-static int s3c_hsotg_probe(struct platform_device *pdev)
+int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
 {
-	struct s3c_hsotg_plat *plat = dev_get_platdata(&pdev->dev);
+	struct device *dev = hsotg->dev;
+	struct s3c_hsotg_plat *plat = dev->platform_data;
 	struct phy *phy;
 	struct usb_phy *uphy;
-	struct device *dev = &pdev->dev;
 	struct s3c_hsotg_ep *eps;
-	struct dwc2_hsotg *hsotg;
-	struct resource *res;
 	int epnum;
 	int ret;
 	int i;
 
-	hsotg = devm_kzalloc(&pdev->dev, sizeof(struct dwc2_hsotg), GFP_KERNEL);
-	if (!hsotg)
-		return -ENOMEM;
-
 	/* Set default UTMI width */
 	hsotg->phyif = GUSBCFG_PHYIF16;
 
@@ -3431,14 +3426,14 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	 * Attempt to find a generic PHY, then look for an old style
 	 * USB PHY, finally fall back to pdata
 	 */
-	phy = devm_phy_get(&pdev->dev, "usb2-phy");
+	phy = devm_phy_get(dev, "usb2-phy");
 	if (IS_ERR(phy)) {
 		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
 		if (IS_ERR(uphy)) {
 			/* Fallback for pdata */
-			plat = dev_get_platdata(&pdev->dev);
+			plat = dev_get_platdata(dev);
 			if (!plat) {
-				dev_err(&pdev->dev,
+				dev_err(dev,
 				"no platform data or transceiver defined\n");
 				return -EPROBE_DEFER;
 			}
@@ -3455,36 +3450,12 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 			hsotg->phyif = GUSBCFG_PHYIF8;
 	}
 
-	hsotg->dev = dev;
-
-	hsotg->clk = devm_clk_get(&pdev->dev, "otg");
+	hsotg->clk = devm_clk_get(dev, "otg");
 	if (IS_ERR(hsotg->clk)) {
 		dev_err(dev, "cannot get otg clock\n");
 		return PTR_ERR(hsotg->clk);
 	}
 
-	platform_set_drvdata(pdev, hsotg);
-
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	hsotg->regs = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(hsotg->regs)) {
-		ret = PTR_ERR(hsotg->regs);
-		goto err_clk;
-	}
-
-	ret = platform_get_irq(pdev, 0);
-	if (ret < 0) {
-		dev_err(dev, "cannot find IRQ\n");
-		goto err_clk;
-	}
-
-	spin_lock_init(&hsotg->lock);
-
-	hsotg->irq = ret;
-
-	dev_info(dev, "regs %p, irq %d\n", hsotg->regs, hsotg->irq);
-
 	hsotg->gadget.max_speed = USB_SPEED_HIGH;
 	hsotg->gadget.ops = &s3c_hsotg_gadget_ops;
 	hsotg->gadget.name = dev_name(dev);
@@ -3501,7 +3472,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(hsotg->supplies),
 				 hsotg->supplies);
 	if (ret) {
-		dev_err(hsotg->dev, "failed to request supplies: %d\n", ret);
+		dev_err(dev, "failed to request supplies: %d\n", ret);
 		goto err_clk;
 	}
 
@@ -3520,7 +3491,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	s3c_hsotg_hw_cfg(hsotg);
 	s3c_hsotg_init(hsotg);
 
-	ret = devm_request_irq(&pdev->dev, hsotg->irq, s3c_hsotg_irq, 0,
+	ret = devm_request_irq(dev, irq, s3c_hsotg_irq, 0,
 				dev_name(dev), hsotg);
 	if (ret < 0) {
 		s3c_hsotg_phy_disable(hsotg);
@@ -3572,7 +3543,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
 	ret = regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies),
 				    hsotg->supplies);
 	if (ret) {
-		dev_err(&pdev->dev, "failed to disable supplies: %d\n", ret);
+		dev_err(dev, "failed to disable supplies: %d\n", ret);
 		goto err_ep_mem;
 	}
 
@@ -3597,15 +3568,14 @@ err_clk:
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dwc2_gadget_init);
 
 /**
  * s3c_hsotg_remove - remove function for hsotg driver
  * @pdev: The platform information for the driver
  */
-static int s3c_hsotg_remove(struct platform_device *pdev)
+int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
 {
-	struct dwc2_hsotg *hsotg = platform_get_drvdata(pdev);
-
 	usb_del_gadget_udc(&hsotg->gadget);
 
 	s3c_hsotg_delete_debug(hsotg);
@@ -3619,10 +3589,10 @@ static int s3c_hsotg_remove(struct platform_device *pdev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(s3c_hsotg_remove);
 
-static int s3c_hsotg_suspend(struct platform_device *pdev, pm_message_t state)
+int s3c_hsotg_suspend(struct dwc2_hsotg *hsotg)
 {
-	struct dwc2_hsotg *hsotg = platform_get_drvdata(pdev);
 	unsigned long flags;
 	int ret = 0;
 
@@ -3648,10 +3618,10 @@ static int s3c_hsotg_suspend(struct platform_device *pdev, pm_message_t state)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(s3c_hsotg_suspend);
 
-static int s3c_hsotg_resume(struct platform_device *pdev)
+int s3c_hsotg_resume(struct dwc2_hsotg *hsotg)
 {
-	struct dwc2_hsotg *hsotg = platform_get_drvdata(pdev);
 	unsigned long flags;
 	int ret = 0;
 
@@ -3672,31 +3642,4 @@ static int s3c_hsotg_resume(struct platform_device *pdev)
 
 	return ret;
 }
-
-#ifdef CONFIG_OF
-static const struct of_device_id s3c_hsotg_of_ids[] = {
-	{ .compatible = "samsung,s3c6400-hsotg", },
-	{ .compatible = "snps,dwc2", },
-	{ /* sentinel */ }
-};
-MODULE_DEVICE_TABLE(of, s3c_hsotg_of_ids);
-#endif
-
-static struct platform_driver s3c_hsotg_driver = {
-	.driver		= {
-		.name	= "s3c-hsotg",
-		.owner	= THIS_MODULE,
-		.of_match_table = of_match_ptr(s3c_hsotg_of_ids),
-	},
-	.probe		= s3c_hsotg_probe,
-	.remove		= s3c_hsotg_remove,
-	.suspend	= s3c_hsotg_suspend,
-	.resume		= s3c_hsotg_resume,
-};
-
-module_platform_driver(s3c_hsotg_driver);
-
-MODULE_DESCRIPTION("Samsung S3C USB High-speed/OtG device");
-MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
-MODULE_LICENSE("GPL");
-MODULE_ALIAS("platform:s3c-hsotg");
+EXPORT_SYMBOL_GPL(s3c_hsotg_resume);
diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
index 0a0e6f0..4a3cce0 100644
--- a/drivers/usb/dwc2/hcd.c
+++ b/drivers/usb/dwc2/hcd.c
@@ -2839,7 +2839,6 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int irq,
 
 	hcd->has_tt = 1;
 
-	spin_lock_init(&hsotg->lock);
 	((struct wrapper_priv_data *) &hcd->hcd_priv)->hsotg = hsotg;
 	hsotg->priv = hcd;
 
diff --git a/drivers/usb/dwc2/hcd.h b/drivers/usb/dwc2/hcd.h
index a12bb15..e69a843 100644
--- a/drivers/usb/dwc2/hcd.h
+++ b/drivers/usb/dwc2/hcd.h
@@ -668,9 +668,6 @@ extern irqreturn_t dwc2_handle_hcd_intr(struct dwc2_hsotg *hsotg);
  */
 extern void dwc2_hcd_stop(struct dwc2_hsotg *hsotg);
 
-extern void dwc2_hcd_start(struct dwc2_hsotg *hsotg);
-extern void dwc2_hcd_disconnect(struct dwc2_hsotg *hsotg);
-
 /**
  * dwc2_hcd_is_b_host() - Returns 1 if core currently is acting as B host,
  * and 0 otherwise
@@ -680,13 +677,6 @@ extern void dwc2_hcd_disconnect(struct dwc2_hsotg *hsotg);
 extern int dwc2_hcd_is_b_host(struct dwc2_hsotg *hsotg);
 
 /**
- * dwc2_hcd_get_frame_number() - Returns current frame number
- *
- * @hsotg: The DWC2 HCD
- */
-extern int dwc2_hcd_get_frame_number(struct dwc2_hsotg *hsotg);
-
-/**
  * dwc2_hcd_dump_state() - Dumps hsotg state
  *
  * @hsotg: The DWC2 HCD
diff --git a/drivers/usb/dwc2/pci.c b/drivers/usb/dwc2/pci.c
index c291fca..6d33ecf 100644
--- a/drivers/usb/dwc2/pci.c
+++ b/drivers/usb/dwc2/pci.c
@@ -141,6 +141,7 @@ static int dwc2_driver_probe(struct pci_dev *dev,
 
 	pci_set_master(dev);
 
+	spin_lock_init(&hsotg->lock);
 	retval = dwc2_hcd_init(hsotg, dev->irq, &dwc2_module_params);
 	if (retval) {
 		pci_disable_device(dev);
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 121dbda..5783ed0 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -121,6 +121,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
 	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
 
 	dwc2_hcd_remove(hsotg);
+	s3c_hsotg_remove(hsotg);
 
 	return 0;
 }
@@ -129,6 +130,7 @@ static const struct of_device_id dwc2_of_match_table[] = {
 	{ .compatible = "brcm,bcm2835-usb", .data = &params_bcm2835 },
 	{ .compatible = "rockchip,rk3066-usb", .data = &params_rk3066 },
 	{ .compatible = "snps,dwc2", .data = NULL },
+	{ .compatible = "samsung,s3c6400-hsotg", .data = NULL},
 	{},
 };
 MODULE_DEVICE_TABLE(of, dwc2_of_match_table);
@@ -204,6 +206,10 @@ static int dwc2_driver_probe(struct platform_device *dev)
 
 	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
 
+	spin_lock_init(&hsotg->lock);
+	retval = dwc2_gadget_init(hsotg, irq);
+	if (retval)
+		return retval;
 	retval = dwc2_hcd_init(hsotg, irq, params);
 	if (retval)
 		return retval;
@@ -213,10 +219,36 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	return retval;
 }
 
+static int dwc2_suspend(struct device *dev)
+{
+	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (dwc2_is_device_mode(dwc2))
+		ret = s3c_hsotg_suspend(dwc2);
+	return ret;
+}
+
+static int dwc2_resume(struct device *dev)
+{
+	struct dwc2_hsotg *dwc2 = dev_get_drvdata(dev);
+	int ret = 0;
+
+	if (dwc2_is_device_mode(dwc2))
+		ret = s3c_hsotg_resume(dwc2);
+
+	return ret;
+}
+
+static const struct dev_pm_ops dwc2_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(dwc2_suspend, dwc2_resume)
+};
+
 static struct platform_driver dwc2_platform_driver = {
 	.driver = {
 		.name = dwc2_driver_name,
 		.of_match_table = dwc2_of_match_table,
+		.pm = &dwc2_dev_pm_ops,
 	},
 	.probe = dwc2_driver_probe,
 	.remove = dwc2_driver_remove,
-- 
2.0.3

