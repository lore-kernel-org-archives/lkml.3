Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446Ab3EJGYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 02:24:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42287 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab3EJGYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 02:24:03 -0400
Message-ID: <518C9232.1000803@huawei.com>
Date: Fri, 10 May 2013 14:22:42 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: <stern@rowland.harvard.edu>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com >> Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v2] usb: ohci: fix goto wrong tag in err case
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix goto wrong tag in usb_hcd_nxp_probe

* Changelog from v1:
    * instead of all these statement labels suggested by Alan Stern

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/host/ohci-nxp.c |   46 +++++++++++++++++++++---------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/host/ohci-nxp.c b/drivers/usb/host/ohci-nxp.c
index f4988fb..5b7389c 100644
--- a/drivers/usb/host/ohci-nxp.c
+++ b/drivers/usb/host/ohci-nxp.c
@@ -223,8 +223,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)

 	isp1301_i2c_client = isp1301_get_client(isp1301_node);
 	if (!isp1301_i2c_client) {
-		ret = -EPROBE_DEFER;
-		goto out;
+		return -EPROBE_DEFER;
 	}

 	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
@@ -234,7 +233,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (usb_disabled()) {
 		dev_err(&pdev->dev, "USB is disabled\n");
 		ret = -ENODEV;
-		goto out;
+		goto fail_disable;
 	}

 	/* Enable AHB slave USB clock, needed for further USB clock control */
@@ -245,19 +244,19 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (IS_ERR(usb_pll_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB PLL\n");
 		ret = PTR_ERR(usb_pll_clk);
-		goto out1;
+		goto fail_pll;
 	}

 	ret = clk_enable(usb_pll_clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to start USB PLL\n");
-		goto out2;
+		goto fail_pllen;
 	}

 	ret = clk_set_rate(usb_pll_clk, 48000);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to set USB clock rate\n");
-		goto out3;
+		goto fail_rate;
 	}

 	/* Enable USB device clock */
@@ -265,13 +264,13 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (IS_ERR(usb_dev_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
 		ret = PTR_ERR(usb_dev_clk);
-		goto out4;
+		goto fail_dev;
 	}

 	ret = clk_enable(usb_dev_clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to start USB DEV Clock\n");
-		goto out5;
+		goto fail_deven;
 	}

 	/* Enable USB otg clocks */
@@ -279,7 +278,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (IS_ERR(usb_otg_clk)) {
 		dev_err(&pdev->dev, "failed to acquire USB DEV Clock\n");
 		ret = PTR_ERR(usb_otg_clk);
-		goto out6;
+		goto fail_otg;
 	}

 	__raw_writel(__raw_readl(USB_CTRL) | USB_HOST_NEED_CLK_EN, USB_CTRL);
@@ -287,7 +286,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	ret = clk_enable(usb_otg_clk);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to start USB DEV Clock\n");
-		goto out7;
+		goto fail_otgen;
 	}

 	isp1301_configure();
@@ -296,20 +295,20 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	if (!hcd) {
 		dev_err(&pdev->dev, "Failed to allocate HC buffer\n");
 		ret = -ENOMEM;
-		goto out8;
+		goto fail_hcd;
 	}

 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "Failed to get MEM resource\n");
 		ret =  -ENOMEM;
-		goto out8;
+		goto fail_resource;
 	}

 	hcd->regs = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hcd->regs)) {
 		ret = PTR_ERR(hcd->regs);
-		goto out8;
+		goto fail_resource;
 	}
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
@@ -317,7 +316,7 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		ret = -ENXIO;
-		goto out8;
+		goto fail_resource;
 	}

 	nxp_start_hc();
@@ -331,23 +330,24 @@ static int usb_hcd_nxp_probe(struct platform_device *pdev)
 		return ret;

 	nxp_stop_hc();
-out8:
+fail_resource:
 	usb_put_hcd(hcd);
-out7:
+fail_hcd:
 	clk_disable(usb_otg_clk);
-out6:
+fail_otgen:
 	clk_put(usb_otg_clk);
-out5:
+fail_otg:
 	clk_disable(usb_dev_clk);
-out4:
+fail_deven:
 	clk_put(usb_dev_clk);
-out3:
+fail_dev:
+fail_rate:
 	clk_disable(usb_pll_clk);
-out2:
+fail_pllen:
 	clk_put(usb_pll_clk);
-out1:
+fail_pll:
+fail_disable:
 	isp1301_i2c_client = NULL;
-out:
 	return ret;
 }

-- 
1.7.1


