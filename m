Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbaDTQ1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 12:27:19 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:11694
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755476AbaDTQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 12:27:13 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(z551bizzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzdchz1de098h8275bh1de097hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <leoli@freescale.com>, <balbi@ti.com>, <michal.simek@xilinx.com>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <kalluripunnaiahchoudary@gmail.com>, <kpc528@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [RFC PATCH 1/2] usb: gadget: fsl_udc: Add support for zynq usb device controller
Date: Sun, 20 Apr 2014 21:57:04 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1398011225-19835-1-git-send-email-punnaia@xilinx.com>
References: <1398011225-19835-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <428dce63-7b2f-4375-8f69-41eadbf0c042@VA3EHSMHS011.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since zynq soc usb controller is a synopsys IP and there is a driver
available for this controller from freescale in opensource, reusing this
driver for zynq use.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
 drivers/usb/gadget/Kconfig        |    2 +-
 drivers/usb/gadget/Makefile       |    1 +
 drivers/usb/gadget/fsl_mxc_udc.c  |   21 +++++++++++++++++++++
 drivers/usb/gadget/fsl_udc_core.c |    5 +++++
 drivers/usb/gadget/fsl_usb2_udc.h |    2 +-
 drivers/usb/host/fsl-mph-dr-of.c  |    9 +++++++++
 6 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 3557c7e..7f18ab47 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -186,7 +186,7 @@ config USB_BCM63XX_UDC
 
 config USB_FSL_USB2
 	tristate "Freescale Highspeed USB DR Peripheral Controller"
-	depends on FSL_SOC || ARCH_MXC
+	depends on FSL_SOC || ARCH_MXC || ARCH_ZYNQ
 	select USB_FSL_MPH_DR_OF if OF
 	help
 	   Some of Freescale PowerPC and i.MX processors have a High Speed
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 5f150bc..38b009f 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_USB_BCM63XX_UDC)	+= bcm63xx_udc.o
 obj-$(CONFIG_USB_FSL_USB2)	+= fsl_usb2_udc.o
 fsl_usb2_udc-y			:= fsl_udc_core.o
 fsl_usb2_udc-$(CONFIG_ARCH_MXC)	+= fsl_mxc_udc.o
+fsl_usb2_udc-$(CONFIG_ARCH_ZYNQ) += fsl_mxc_udc.o
 obj-$(CONFIG_USB_M66592)	+= m66592-udc.o
 obj-$(CONFIG_USB_R8A66597)	+= r8a66597-udc.o
 obj-$(CONFIG_USB_FSL_QE)	+= fsl_qe_udc.o
diff --git a/drivers/usb/gadget/fsl_mxc_udc.c b/drivers/usb/gadget/fsl_mxc_udc.c
index 9b140fc..181245c 100644
--- a/drivers/usb/gadget/fsl_mxc_udc.c
+++ b/drivers/usb/gadget/fsl_mxc_udc.c
@@ -19,8 +19,10 @@
 #include <linux/io.h>
 
 static struct clk *mxc_ahb_clk;
+#ifndef CONFIG_ARCH_ZYNQ
 static struct clk *mxc_per_clk;
 static struct clk *mxc_ipg_clk;
+#endif
 
 /* workaround ENGcm09152 for i.MX35 */
 #define MX35_USBPHYCTRL_OFFSET		0x600
@@ -30,6 +32,7 @@ static struct clk *mxc_ipg_clk;
 int fsl_udc_clk_init(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata;
+#ifndef CONFIG_ARCH_ZYNQ
 	unsigned long freq;
 	int ret;
 
@@ -76,10 +79,21 @@ eclkrate:
 	clk_disable_unprepare(mxc_per_clk);
 	mxc_per_clk = NULL;
 	return ret;
+#else
+	pdata = dev_get_platdata(&pdev->dev);
+	mxc_ahb_clk = devm_clk_get(pdev->dev.parent, NULL);
+	if (IS_ERR(mxc_ahb_clk))
+		return PTR_ERR(mxc_ahb_clk);
+
+	clk_prepare_enable(mxc_ahb_clk);
+
+	return 0;
+#endif
 }
 
 int fsl_udc_clk_finalize(struct platform_device *pdev)
 {
+#ifndef CONFIG_ARCH_ZYNQ
 	struct fsl_usb2_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	int ret = 0;
 
@@ -112,12 +126,19 @@ ioremap_err:
 	}
 
 	return ret;
+#else
+	return 0;
+#endif
 }
 
 void fsl_udc_clk_release(void)
 {
+#ifndef CONFIG_ARCH_ZYNQ
 	if (mxc_per_clk)
 		clk_disable_unprepare(mxc_per_clk);
 	clk_disable_unprepare(mxc_ahb_clk);
 	clk_disable_unprepare(mxc_ipg_clk);
+#else
+	clk_disable_unprepare(mxc_ahb_clk);
+#endif
 }
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 15960af..c3ff3fb 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2492,6 +2492,9 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 		goto err_free_irq;
 	}
 
+#ifdef CONFIG_ARCH_ZYNQ
+	udc_controller->vbus_active = 1;
+#endif
 	ret = usb_add_gadget_udc_release(&pdev->dev, &udc_controller->gadget,
 			fsl_udc_release);
 	if (ret)
@@ -2661,8 +2664,10 @@ static const struct platform_device_id fsl_udc_devtype[] = {
 MODULE_DEVICE_TABLE(platform, fsl_udc_devtype);
 static struct platform_driver udc_driver = {
 	.remove		= __exit_p(fsl_udc_remove),
+#ifndef CONFIG_ARCH_ZYNQ
 	/* Just for FSL i.mx SoC currently */
 	.id_table	= fsl_udc_devtype,
+#endif
 	/* these suspend and resume are not usb suspend and resume */
 	.suspend	= fsl_udc_suspend,
 	.resume		= fsl_udc_resume,
diff --git a/drivers/usb/gadget/fsl_usb2_udc.h b/drivers/usb/gadget/fsl_usb2_udc.h
index c6703bb..6394138 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.h
+++ b/drivers/usb/gadget/fsl_usb2_udc.h
@@ -590,7 +590,7 @@ static inline struct ep_queue_head *get_qh_by_ep(struct fsl_ep *ep)
 }
 
 struct platform_device;
-#ifdef CONFIG_ARCH_MXC
+#if defined CONFIG_ARCH_MXC || defined CONFIG_ARCH_ZYNQ
 int fsl_udc_clk_init(struct platform_device *pdev);
 int fsl_udc_clk_finalize(struct platform_device *pdev);
 void fsl_udc_clk_release(void);
diff --git a/drivers/usb/host/fsl-mph-dr-of.c b/drivers/usb/host/fsl-mph-dr-of.c
index 9162d1b..7d89415 100644
--- a/drivers/usb/host/fsl-mph-dr-of.c
+++ b/drivers/usb/host/fsl-mph-dr-of.c
@@ -42,6 +42,10 @@ static struct fsl_usb2_dev_data dr_mode_data[] = {
 	},
 };
 
+#ifdef CONFIG_ARCH_ZYNQ
+static u64 dma_mask = 0xFFFFFFF0;
+#endif
+
 static struct fsl_usb2_dev_data *get_dr_mode_data(struct device_node *np)
 {
 	const unsigned char *prop;
@@ -94,7 +98,11 @@ static struct platform_device *fsl_usb2_device_register(
 	pdev->dev.parent = &ofdev->dev;
 
 	pdev->dev.coherent_dma_mask = ofdev->dev.coherent_dma_mask;
+#ifndef CONFIG_ARCH_ZYNQ
 	*pdev->dev.dma_mask = *ofdev->dev.dma_mask;
+#else
+	pdev->dev.dma_mask = &dma_mask;
+#endif
 
 	retval = platform_device_add_data(pdev, pdata, sizeof(*pdata));
 	if (retval)
@@ -320,6 +328,7 @@ static const struct of_device_id fsl_usb2_mph_dr_of_match[] = {
 #ifdef CONFIG_PPC_MPC512x
 	{ .compatible = "fsl,mpc5121-usb2-dr", .data = &fsl_usb2_mpc5121_pd, },
 #endif
+	{ .compatible = "synopsys,usb2-dr-2.20a", },
 	{},
 };
 
-- 
1.7.4


