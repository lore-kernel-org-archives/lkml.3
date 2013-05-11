Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3EKG17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 May 2013 02:27:59 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:49305 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3EKG15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 May 2013 02:27:57 -0400
Message-ID: <518DE4FF.1000702@gmail.com>
Date: Sat, 11 May 2013 14:28:15 +0800
From: Libo Chen <chenlibo.3@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: ben-linux@fluff.org, kgene.kim@samsung.com, balbi@ti.com
CC: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lizefan@huawei.com, libo.chen@huawei.com, stern@rowland.harvard.edu,
        akpm@linux-foundation.org
Subject: [PATCH] usb: gadget: s3c2410: fix clk resource leak and update
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Libo Chen <libo.chen@huawei.com>

currently, when clk_get(NULL,"usb-device") fail, it does not
disable && put usb_bus_clock. It is incorrect.

this patch use new interface devm_xxx instead of xxx then
we no need to care about cleanup resource in err case that is boring
and reduce code size.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/gadget/s3c2410_udc.c | 85
++++++++++++----------------------------
 1 file changed, 25 insertions(+), 60 deletions(-)

diff --git a/drivers/usb/gadget/s3c2410_udc.c
b/drivers/usb/gadget/s3c2410_udc.c
old mode 100644
new mode 100755
index d0e75e1..0c573a8
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1780,7 +1780,7 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)

 	dev_dbg(dev, "%s()\n", __func__);

-	usb_bus_clock = clk_get(NULL, "usb-bus-gadget");
+	usb_bus_clock = devm_clk_get(NULL, "usb-bus-gadget");
 	if (IS_ERR(usb_bus_clock)) {
 		dev_err(dev, "failed to get usb bus clock source\n");
 		return PTR_ERR(usb_bus_clock);
@@ -1788,8 +1788,9 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)

 	clk_enable(usb_bus_clock);

-	udc_clock = clk_get(NULL, "usb-device");
+	udc_clock = devm_clk_get(NULL, "usb-device");
 	if (IS_ERR(udc_clock)) {
+		clk_disable(usb_bus_clock);
 		dev_err(dev, "failed to get udc clock source\n");
 		return PTR_ERR(udc_clock);
 	}
@@ -1814,13 +1815,15 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)
 	rsrc_start = S3C2410_PA_USBDEV;
 	rsrc_len   = S3C24XX_SZ_USBDEV;

-	if (!request_mem_region(rsrc_start, rsrc_len, gadget_name))
-		return -EBUSY;
+	if (!devm_request_mem_region(rsrc_start, rsrc_len, gadget_name)) {
+		retval = -EBUSY;
+		goto out;
+	}

-	base_addr = ioremap(rsrc_start, rsrc_len);
+	base_addr = devm_ioremap(rsrc_start, rsrc_len);
 	if (!base_addr) {
 		retval = -ENOMEM;
-		goto err_mem;
+		goto out;
 	}

 	the_controller = udc;
@@ -1830,31 +1833,31 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)
 	s3c2410_udc_reinit(udc);

 	/* irq setup after old hardware state is cleaned up */
-	retval = request_irq(IRQ_USBD, s3c2410_udc_irq,
+	retval = devm_request_irq(IRQ_USBD, s3c2410_udc_irq,
 			     0, gadget_name, udc);

 	if (retval != 0) {
 		dev_err(dev, "cannot get irq %i, err %d\n", IRQ_USBD, retval);
 		retval = -EBUSY;
-		goto err_map;
+		goto out;
 	}

 	dev_dbg(dev, "got irq %i\n", IRQ_USBD);

 	if (udc_info && udc_info->vbus_pin > 0) {
-		retval = gpio_request(udc_info->vbus_pin, "udc vbus");
+		retval = devm_gpio_request(udc_info->vbus_pin, "udc vbus");
 		if (retval < 0) {
 			dev_err(dev, "cannot claim vbus pin\n");
-			goto err_int;
+			goto out;
 		}

 		irq = gpio_to_irq(udc_info->vbus_pin);
 		if (irq < 0) {
 			dev_err(dev, "no irq for gpio vbus pin\n");
-			goto err_gpio_claim;
+			goto out;
 		}

-		retval = request_irq(irq, s3c2410_udc_vbus_irq,
+		retval = devm_request_irq(irq, s3c2410_udc_vbus_irq,
 				     IRQF_TRIGGER_RISING
 				     | IRQF_TRIGGER_FALLING | IRQF_SHARED,
 				     gadget_name, udc);
@@ -1863,7 +1866,7 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)
 			dev_err(dev, "can't get vbus irq %d, err %d\n",
 				irq, retval);
 			retval = -EBUSY;
-			goto err_gpio_claim;
+			goto out;
 		}

 		dev_dbg(dev, "got irq %i\n", irq);
@@ -1874,17 +1877,17 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)
 	if (udc_info && !udc_info->udc_command &&
 		gpio_is_valid(udc_info->pullup_pin)) {

-		retval = gpio_request_one(udc_info->pullup_pin,
+		retval = devm_gpio_request_one(udc_info->pullup_pin,
 				udc_info->vbus_pin_inverted ?
 				GPIOF_OUT_INIT_HIGH : GPIOF_OUT_INIT_LOW,
 				"udc pullup");
 		if (retval)
-			goto err_vbus_irq;
+			goto out;
 	}

 	retval = usb_add_gadget_udc(&pdev->dev, &udc->gadget);
 	if (retval)
-		goto err_add_udc;
+		goto out;

 	if (s3c2410_udc_debugfs_root) {
 		udc->regs_info = debugfs_create_file("registers", S_IRUGO,
@@ -1898,22 +1901,9 @@ static int s3c2410_udc_probe(struct
platform_device *pdev)

 	return 0;

-err_add_udc:
-	if (udc_info && !udc_info->udc_command &&
-			gpio_is_valid(udc_info->pullup_pin))
-		gpio_free(udc_info->pullup_pin);
-err_vbus_irq:
-	if (udc_info && udc_info->vbus_pin > 0)
-		free_irq(gpio_to_irq(udc_info->vbus_pin), udc);
-err_gpio_claim:
-	if (udc_info && udc_info->vbus_pin > 0)
-		gpio_free(udc_info->vbus_pin);
-err_int:
-	free_irq(IRQ_USBD, udc);
-err_map:
-	iounmap(base_addr);
-err_mem:
-	release_mem_region(rsrc_start, rsrc_len);
+out:
+	clk_disable(udc_clock);
+	clk_disable(usb_bus_clock);

 	return retval;
 }
@@ -1931,36 +1921,11 @@ static int s3c2410_udc_remove(struct
platform_device *pdev)
 	if (udc->driver)
 		return -EBUSY;

-	usb_del_gadget_udc(&udc->gadget);
 	debugfs_remove(udc->regs_info);
+	usb_del_gadget_udc(&udc->gadget);

-	if (udc_info && !udc_info->udc_command &&
-		gpio_is_valid(udc_info->pullup_pin))
-		gpio_free(udc_info->pullup_pin);
-
-	if (udc_info && udc_info->vbus_pin > 0) {
-		irq = gpio_to_irq(udc_info->vbus_pin);
-		free_irq(irq, udc);
-	}
-
-	free_irq(IRQ_USBD, udc);
-
-	iounmap(base_addr);
-	release_mem_region(rsrc_start, rsrc_len);
-
-	platform_set_drvdata(pdev, NULL);
-
-	if (!IS_ERR(udc_clock) && udc_clock != NULL) {
-		clk_disable(udc_clock);
-		clk_put(udc_clock);
-		udc_clock = NULL;
-	}
-
-	if (!IS_ERR(usb_bus_clock) && usb_bus_clock != NULL) {
-		clk_disable(usb_bus_clock);
-		clk_put(usb_bus_clock);
-		usb_bus_clock = NULL;
-	}
+	clk_disable(udc_clock);
+	clk_disable(usb_bus_clock);

 	dev_dbg(&pdev->dev, "%s: remove ok\n", __func__);
 	return 0;
-- 
1.8.1.2

