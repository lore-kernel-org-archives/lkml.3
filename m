Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab3CSNoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:44:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60768 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab3CSNox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:44:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, manjunath.goudar@linaro.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: USB: simplify clock lookup for mv ehci/otg/udc
Date: Tue, 19 Mar 2013 14:44:46 +0100
Message-ID: <2174936.bGhG5fu0iO@wuerfel>
User-Agent: KMail/4.10.1 (Linux/3.8.0-12-generic; KDE/4.10.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:mWayE94yusRULWOcUvJnRGi1zKcEkw8Fw9ktdkSml9c
 2ha9xRz2CLO7QS8WaMMvN2hHQN3jhjS1QfqWcr29A3NmVgoIzh
 e7TwX3pptLcPvqPhNBZTOdEwgNOlJeY9EEZttuDATbqQrbIzUY
 06FDRsoXyAzNR/NvrThxspmjvQl89xNKI+m5xSvBF5FlXdDVzw
 kpOfid7SX6a9x+anCO3QtfWgndg6R/aHrx6H9TQIn2NXGL0F+Q
 4oFYl3JQC8H8pVT9ZzWm9Hk0/DyjFkkhGeF6bCL62hzxCYgvfV
 Mzq3ZiCS5j+MOYdkk7excToKUZ8eC/9iOCSlOrOhSoFHYIBMVW
 8VitcKW/hTKWp8TIdXbw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While going over the suggested changes for the ehci-mv separation patch,
we noticed that the driver uses a variable number of clock names it gets
passed from the platform code, which is highly unusual behavior and adds
a lot of extra complexity.

Even though there is a comment in the mv_udc driver stating that some SoCs
require multiple clocks, none of the code in the upstream kernel provides
more than one, and even if an out of tree SoC port needs multiple clocks,
it is still wrong to pass them them through platform data, since they are
a property of the device, not a property of the platform.

This patch attempts to clean up the situation by turning the one clock
that is passed into the ehci/udc/otg devices into an anomymous one and
removing the clkname array from the platform data. Another simplification
is to always call clk_prepare_enable/clk_disable_unprepare directly,
since that is a valid operation on a NULL clk pointer if the platform
has not attacked a clk to the device.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Haojian, does this look reasonable to you?

 arch/arm/mach-mmp/aspenite.c         |  5 -----
 arch/arm/mach-mmp/clock-pxa168.c     |  2 +-
 arch/arm/mach-mmp/clock-pxa910.c     |  4 +++-
 arch/arm/mach-mmp/ttc_dkb.c          |  6 ------
 drivers/usb/gadget/mv_udc.h          |  4 +---
 drivers/usb/gadget/mv_udc_core.c     | 37 +++++++++----------------------------
 drivers/usb/host/ehci-mv.c           | 43 ++++++++++---------------------------------
 drivers/usb/otg/mv_otg.c             | 38 +++++++++-----------------------------
 drivers/usb/otg/mv_otg.h             |  3 +--
 include/linux/platform_data/mv_usb.h |  1 -
 10 files changed, 34 insertions(+), 109 deletions(-)

diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
index 9f64d56..988bd80 100644
--- a/arch/arm/mach-mmp/aspenite.c
+++ b/arch/arm/mach-mmp/aspenite.c
@@ -223,13 +223,8 @@ static struct pxa27x_keypad_platform_data aspenite_keypad_info __initdata = {
 };
 
 #if defined(CONFIG_USB_EHCI_MV)
-static char *pxa168_sph_clock_name[] = {
-	[0] = "PXA168-USBCLK",
-};
-
 static struct mv_usb_platform_data pxa168_sph_pdata = {
 	.clknum         = 1,
-	.clkname        = pxa168_sph_clock_name,
 	.mode           = MV_USB_MODE_HOST,
 	.phy_init	= pxa_usb_phy_init,
 	.phy_deinit	= pxa_usb_phy_deinit,
diff --git a/arch/arm/mach-mmp/clock-pxa168.c b/arch/arm/mach-mmp/clock-pxa168.c
index 5e6c18c..9edc50e 100644
--- a/arch/arm/mach-mmp/clock-pxa168.c
+++ b/arch/arm/mach-mmp/clock-pxa168.c
@@ -81,7 +81,7 @@ static struct clk_lookup pxa168_clkregs[] = {
 	INIT_CLKREG(&clk_gpio, "pxa-gpio", NULL),
 	INIT_CLKREG(&clk_keypad, "pxa27x-keypad", NULL),
 	INIT_CLKREG(&clk_eth, "pxa168-eth", "MFUCLK"),
-	INIT_CLKREG(&clk_usb, NULL, "PXA168-USBCLK"),
+	INIT_CLKREG(&clk_usb, "pxa-sph", NULL);
 	INIT_CLKREG(&clk_rtc, "sa1100-rtc", NULL),
 };
 
diff --git a/arch/arm/mach-mmp/clock-pxa910.c b/arch/arm/mach-mmp/clock-pxa910.c
index 933ea71..6849155 100644
--- a/arch/arm/mach-mmp/clock-pxa910.c
+++ b/arch/arm/mach-mmp/clock-pxa910.c
@@ -57,7 +57,9 @@ static struct clk_lookup pxa910_clkregs[] = {
 	INIT_CLKREG(&clk_pwm4, "pxa910-pwm.3", NULL),
 	INIT_CLKREG(&clk_nand, "pxa3xx-nand", NULL),
 	INIT_CLKREG(&clk_gpio, "pxa-gpio", NULL),
-	INIT_CLKREG(&clk_u2o, NULL, "U2OCLK"),
+	INIT_CLKREG(&clk_u2o, "pxa-u2oehci", NULL),
+	INIT_CLKREG(&clk_u2o, "mv-udc", NULL),
+	INIT_CLKREG(&clk_u2o, "mv-otg", NULL),
 	INIT_CLKREG(&clk_rtc, "sa1100-rtc", NULL),
 };
 
diff --git a/arch/arm/mach-mmp/ttc_dkb.c b/arch/arm/mach-mmp/ttc_dkb.c
index 22a9058..39a7ad5 100644
--- a/arch/arm/mach-mmp/ttc_dkb.c
+++ b/arch/arm/mach-mmp/ttc_dkb.c
@@ -161,14 +161,8 @@ static struct i2c_board_info ttc_dkb_i2c_info[] = {
 
 #ifdef CONFIG_USB_SUPPORT
 #if defined(CONFIG_USB_MV_UDC) || defined(CONFIG_USB_EHCI_MV_U2O)
-
-static char *pxa910_usb_clock_name[] = {
-	[0] = "U2OCLK",
-};
-
 static struct mv_usb_platform_data ttc_usb_pdata = {
 	.clknum		= 1,
-	.clkname	= pxa910_usb_clock_name,
 	.vbus		= NULL,
 	.mode		= MV_USB_MODE_OTG,
 	.otg_force_a_bus_req = 1,
diff --git a/drivers/usb/gadget/mv_udc.h b/drivers/usb/gadget/mv_udc.h
index 9073436..fa87981 100644
--- a/drivers/usb/gadget/mv_udc.h
+++ b/drivers/usb/gadget/mv_udc.h
@@ -221,9 +221,7 @@ struct mv_udc {
 
 	struct mv_usb_platform_data     *pdata;
 
-	/* some SOC has mutiple clock sources for USB*/
-	unsigned int    clknum;
-	struct clk      *clk[0];
+	struct clk      *clk;
 };
 
 /* endpoint data structure */
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index c8cf959..8c4d4d2 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -1004,22 +1004,6 @@ static struct usb_ep_ops mv_ep_ops = {
 	.fifo_flush	= mv_ep_fifo_flush,	/* flush fifo */
 };
 
-static void udc_clock_enable(struct mv_udc *udc)
-{
-	unsigned int i;
-
-	for (i = 0; i < udc->clknum; i++)
-		clk_prepare_enable(udc->clk[i]);
-}
-
-static void udc_clock_disable(struct mv_udc *udc)
-{
-	unsigned int i;
-
-	for (i = 0; i < udc->clknum; i++)
-		clk_disable_unprepare(udc->clk[i]);
-}
-
 static void udc_stop(struct mv_udc *udc)
 {
 	u32 tmp;
@@ -1120,13 +1104,13 @@ static int mv_udc_enable_internal(struct mv_udc *udc)
 		return 0;
 
 	dev_dbg(&udc->dev->dev, "enable udc\n");
-	udc_clock_enable(udc);
+	clk_prepare_enable(udc->clk);
 	if (udc->pdata->phy_init) {
 		retval = udc->pdata->phy_init(udc->phy_regs);
 		if (retval) {
 			dev_err(&udc->dev->dev,
 				"init phy error %d\n", retval);
-			udc_clock_disable(udc);
+			clk_disable_unprepare(udc->clk);
 			return retval;
 		}
 	}
@@ -1149,7 +1133,7 @@ static void mv_udc_disable_internal(struct mv_udc *udc)
 		dev_dbg(&udc->dev->dev, "disable udc\n");
 		if (udc->pdata->phy_deinit)
 			udc->pdata->phy_deinit(udc->phy_regs);
-		udc_clock_disable(udc);
+		clk_disable_unprepare(udc->clk);
 		udc->active = 0;
 	}
 }
@@ -2151,17 +2135,16 @@ static int mv_udc_probe(struct platform_device *pdev)
 	struct mv_usb_platform_data *pdata = pdev->dev.platform_data;
 	struct mv_udc *udc;
 	int retval = 0;
-	int clk_i = 0;
 	struct resource *r;
 	size_t size;
 
+
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "missing platform_data\n");
 		return -ENODEV;
 	}
 
-	size = sizeof(*udc) + sizeof(struct clk *) * pdata->clknum;
-	udc = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	udc = devm_kzalloc(&pdev->dev, sizeof(*udc), GFP_KERNEL);
 	if (udc == NULL) {
 		dev_err(&pdev->dev, "failed to allocate memory for udc\n");
 		return -ENOMEM;
@@ -2184,12 +2167,10 @@ static int mv_udc_probe(struct platform_device *pdev)
 	}
 #endif
 
-	udc->clknum = pdata->clknum;
-	for (clk_i = 0; clk_i < udc->clknum; clk_i++) {
-		udc->clk[clk_i] = devm_clk_get(&pdev->dev,
-					pdata->clkname[clk_i]);
-		if (IS_ERR(udc->clk[clk_i])) {
-			retval = PTR_ERR(udc->clk[clk_i]);
+	if (pdata->clknum) {
+		udc->clk = devm_clk_get(&pdev->dev, NULL);
+		if (IS_ERR(udc->clk)) {
+			retval = PTR_ERR(udc->clk);
 			return retval;
 		}
 	}
diff --git a/drivers/usb/host/ehci-mv.c b/drivers/usb/host/ehci-mv.c
index 3065809..2c13689 100644
--- a/drivers/usb/host/ehci-mv.c
+++ b/drivers/usb/host/ehci-mv.c
@@ -33,32 +33,14 @@ struct ehci_hcd_mv {
 
 	struct mv_usb_platform_data *pdata;
 
-	/* clock source and total clock number */
-	unsigned int clknum;
-	struct clk *clk[0];
+	struct clk *clk;
 };
 
-static void ehci_clock_enable(struct ehci_hcd_mv *ehci_mv)
-{
-	unsigned int i;
-
-	for (i = 0; i < ehci_mv->clknum; i++)
-		clk_prepare_enable(ehci_mv->clk[i]);
-}
-
-static void ehci_clock_disable(struct ehci_hcd_mv *ehci_mv)
-{
-	unsigned int i;
-
-	for (i = 0; i < ehci_mv->clknum; i++)
-		clk_disable_unprepare(ehci_mv->clk[i]);
-}
-
 static int mv_ehci_enable(struct ehci_hcd_mv *ehci_mv)
 {
 	int retval;
 
-	ehci_clock_enable(ehci_mv);
+	clk_prepare_enable(ehci_mv->clk);
 	if (ehci_mv->pdata->phy_init) {
 		retval = ehci_mv->pdata->phy_init(ehci_mv->phy_regs);
 		if (retval)
@@ -72,7 +54,7 @@ static void mv_ehci_disable(struct ehci_hcd_mv *ehci_mv)
 {
 	if (ehci_mv->pdata->phy_deinit)
 		ehci_mv->pdata->phy_deinit(ehci_mv->phy_regs);
-	ehci_clock_disable(ehci_mv);
+	clk_disable_unprepare(ehci_mv->clk);
 }
 
 static int mv_ehci_reset(struct usb_hcd *hcd)
@@ -144,9 +126,8 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	struct ehci_hcd *ehci;
 	struct ehci_hcd_mv *ehci_mv;
 	struct resource *r;
-	int clk_i, retval = -ENODEV;
+	int retval;
 	u32 offset;
-	size_t size;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "missing platform_data\n");
@@ -160,8 +141,7 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	if (!hcd)
 		return -ENOMEM;
 
-	size = sizeof(*ehci_mv) + sizeof(struct clk *) * pdata->clknum;
-	ehci_mv = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	ehci_mv = devm_kzalloc(&pdev->dev, sizeof(*ehci_mv), GFP_KERNEL);
 	if (ehci_mv == NULL) {
 		dev_err(&pdev->dev, "cannot allocate ehci_hcd_mv\n");
 		retval = -ENOMEM;
@@ -172,14 +152,11 @@ static int mv_ehci_probe(struct platform_device *pdev)
 	ehci_mv->pdata = pdata;
 	ehci_mv->hcd = hcd;
 
-	ehci_mv->clknum = pdata->clknum;
-	for (clk_i = 0; clk_i < ehci_mv->clknum; clk_i++) {
-		ehci_mv->clk[clk_i] =
-		    devm_clk_get(&pdev->dev, pdata->clkname[clk_i]);
-		if (IS_ERR(ehci_mv->clk[clk_i])) {
-			dev_err(&pdev->dev, "error get clck \"%s\"\n",
-				pdata->clkname[clk_i]);
-			retval = PTR_ERR(ehci_mv->clk[clk_i]);
+	if (pdata->clknum) {
+		ehci_mv->clk = devm_clk_get(&pdev->dev, NULL);
+		if (IS_ERR(ehci_mv->clk)) {
+			dev_err(&pdev->dev, "error get clck\n");
+			retval = PTR_ERR(ehci_mv->clk);
 			goto err_clear_drvdata;
 		}
 	}
diff --git a/drivers/usb/otg/mv_otg.c b/drivers/usb/otg/mv_otg.c
index b6a9be3..c7f1dd9 100644
--- a/drivers/usb/otg/mv_otg.c
+++ b/drivers/usb/otg/mv_otg.c
@@ -235,22 +235,6 @@ static void mv_otg_start_periphrals(struct mv_otg *mvotg, int on)
 		usb_gadget_vbus_disconnect(otg->gadget);
 }
 
-static void otg_clock_enable(struct mv_otg *mvotg)
-{
-	unsigned int i;
-
-	for (i = 0; i < mvotg->clknum; i++)
-		clk_prepare_enable(mvotg->clk[i]);
-}
-
-static void otg_clock_disable(struct mv_otg *mvotg)
-{
-	unsigned int i;
-
-	for (i = 0; i < mvotg->clknum; i++)
-		clk_disable_unprepare(mvotg->clk[i]);
-}
-
 static int mv_otg_enable_internal(struct mv_otg *mvotg)
 {
 	int retval = 0;
@@ -260,13 +244,13 @@ static int mv_otg_enable_internal(struct mv_otg *mvotg)
 
 	dev_dbg(&mvotg->pdev->dev, "otg enabled\n");
 
-	otg_clock_enable(mvotg);
+	clk_prepare_enable(mvotg->clk);
 	if (mvotg->pdata->phy_init) {
 		retval = mvotg->pdata->phy_init(mvotg->phy_regs);
 		if (retval) {
 			dev_err(&mvotg->pdev->dev,
 				"init phy error %d\n", retval);
-			otg_clock_disable(mvotg);
+			clk_disable_unprepare(mvotg->clk);
 			return retval;
 		}
 	}
@@ -290,7 +274,7 @@ static void mv_otg_disable_internal(struct mv_otg *mvotg)
 		dev_dbg(&mvotg->pdev->dev, "otg disabled\n");
 		if (mvotg->pdata->phy_deinit)
 			mvotg->pdata->phy_deinit(mvotg->phy_regs);
-		otg_clock_disable(mvotg);
+		clk_disable_unprepare(mvotg->clk);
 		mvotg->active = 0;
 	}
 }
@@ -684,16 +668,14 @@ static int mv_otg_probe(struct platform_device *pdev)
 	struct mv_otg *mvotg;
 	struct usb_otg *otg;
 	struct resource *r;
-	int retval = 0, clk_i, i;
-	size_t size;
+	int retval = 0, i;
 
 	if (pdata == NULL) {
 		dev_err(&pdev->dev, "failed to get platform data\n");
 		return -ENODEV;
 	}
 
-	size = sizeof(*mvotg) + sizeof(struct clk *) * pdata->clknum;
-	mvotg = devm_kzalloc(&pdev->dev, size, GFP_KERNEL);
+	mvotg = devm_kzalloc(&pdev->dev, sizeof(*mvotg), GFP_KERNEL);
 	if (!mvotg) {
 		dev_err(&pdev->dev, "failed to allocate memory!\n");
 		return -ENOMEM;
@@ -708,12 +690,10 @@ static int mv_otg_probe(struct platform_device *pdev)
 	mvotg->pdev = pdev;
 	mvotg->pdata = pdata;
 
-	mvotg->clknum = pdata->clknum;
-	for (clk_i = 0; clk_i < mvotg->clknum; clk_i++) {
-		mvotg->clk[clk_i] = devm_clk_get(&pdev->dev,
-						pdata->clkname[clk_i]);
-		if (IS_ERR(mvotg->clk[clk_i])) {
-			retval = PTR_ERR(mvotg->clk[clk_i]);
+	if (pdata->clknum) {
+		mvotg->clk = devm_clk_get(&pdev->dev, NULL);
+		if (IS_ERR(mvotg->clk)) {
+			retval = PTR_ERR(mvotg->clk);
 			return retval;
 		}
 	}
diff --git a/drivers/usb/otg/mv_otg.h b/drivers/usb/otg/mv_otg.h
index 8a9e351..551da6e 100644
--- a/drivers/usb/otg/mv_otg.h
+++ b/drivers/usb/otg/mv_otg.h
@@ -158,8 +158,7 @@ struct mv_otg {
 
 	unsigned int active;
 	unsigned int clock_gating;
-	unsigned int clknum;
-	struct clk *clk[0];
+	struct clk *clk;
 };
 
 #endif
diff --git a/include/linux/platform_data/mv_usb.h b/include/linux/platform_data/mv_usb.h
index 944b01d..24a1005 100644
--- a/include/linux/platform_data/mv_usb.h
+++ b/include/linux/platform_data/mv_usb.h
@@ -35,7 +35,6 @@ struct mv_usb_addon_irq {
 
 struct mv_usb_platform_data {
 	unsigned int		clknum;
-	char			**clkname;
 	struct mv_usb_addon_irq	*id;	/* Only valid for OTG. ID pin change*/
 	struct mv_usb_addon_irq	*vbus;	/* valid for OTG/UDC. VBUS change*/
 

