Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106AbaLKWNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:13:13 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57943 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751AbaLKWNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:13:10 -0500
Date: Thu, 11 Dec 2014 23:13:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, khilman@kernel.org,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<ivo.g.dimitrov.75@gmail.com>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: __hci_cmd_sync() not suitable for nokia h4p
Message-ID: <20141211221306.GA2905@amd>
References: <20141209190210.GA15641@amd>
 <304050AD-DB11-4A2B-A1F7-8B1BBB5F04F0@holtmann.org>
 <20141209201328.GA18003@amd>
 <7EFD3C33-E503-4FB6-BCCF-52836080ABD6@holtmann.org>
 <20141210131519.GA14748@amd>
 <EE1A4B9D-30D5-4BD9-9A43-532619494A0C@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE1A4B9D-30D5-4BD9-9A43-532619494A0C@holtmann.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > h4p changes uart speed again after load of the firmware, but I guess
> > that's ok.

>  if you can do it the other way around it would result in a faster
> init. Depending on how many patches are actually required to be
> loaded.

IIRC driver does two speed changes, so it looks to me like someone
already tried that (and it did not work).

> >> What needs to be done is the bring up of the device including the proper UART settings and speed and then just run the firmware downloads. All firmware files on the Nokia devices where just HCI commands with vendor specific details. Some from CSR, some from Broadcom and some from TI. You can actually decode them if you really want to. Shouldn't be that hard.
> >> 
> > 
> > Speed changes at the end of firmware load, but I guess that's detail?
> > Anyway, patch would look like this.
> 
> You should really look into providing hdev->setup() callback. That is normally the callback where you want to load the firmware.
> 

I can provide setup() callback and load firmware from there.

I have created provisional device tree binding, and the driver still
works.

Some time ago you mentioned that with the "big" issues fixed, you'd be
willing to take it into the tree. What way forward do you see? Would
it make sense to re-enable the driver in staging, so that "big"
changes could be applied, followed by renames?

Thanks,
								Pavel

diff --git a/arch/arm/boot/dts/omap3-n900.dts b/arch/arm/boot/dts/omap3-n900.dts
index 9e0e5a2..201f21b 100644
--- a/arch/arm/boot/dts/omap3-n900.dts
+++ b/arch/arm/boot/dts/omap3-n900.dts
@@ -790,9 +776,21 @@
 };
 
 &uart2 {
+        compatible = "brcm,uart,bcm2048";
 	interrupts-extended = <&intc 73 &omap3_pmx_core OMAP3_UART2_RX>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart2_pins>;
+	device {
+		  compatible = "brcm,bcm2048";
+		  uart = <&uart2>;
+		  reset-gpios = <&gpio3 27 GPIO_ACTIVE_HIGH>; /* want 91 */
+		  host-wakeup-gpios = <&gpio4 5 GPIO_ACTIVE_HIGH>; /* want 101 */
+		  bluetooth-wakeup-gpios = <&gpio2 5 GPIO_ACTIVE_HIGH>; /* want 37 */
+		  chip-type = <3>;
+		  bt-sysclk = <2>;
+		  clocks = <&uart2_fck>, <&uart2_ick>;
+		  clock-names = "fck", "ick";
+	};
 };
 
 &uart3 {
diff --git a/drivers/staging/nokia_h4p/nokia_core.c b/drivers/staging/nokia_h4p/nokia_core.c
index 5cdb86a..ac61cfd 100644
--- a/drivers/staging/nokia_h4p/nokia_core.c
+++ b/drivers/staging/nokia_h4p/nokia_core.c
@@ -37,6 +37,8 @@
 #include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
 #include <linux/timer.h>
 #include <linux/kthread.h>
 #include <linux/io.h>
@@ -1112,12 +1114,75 @@ free:
 	return -ENODEV;
 }
 
+static int hci_h4p_probe_pdata(struct platform_device *pdev, struct hci_h4p_info *info,
+			       struct hci_h4p_platform_data *bt_plat_data)
+{
+	info->chip_type = bt_plat_data->chip_type;
+	info->bt_wakeup_gpio = bt_plat_data->bt_wakeup_gpio;
+	info->host_wakeup_gpio = bt_plat_data->host_wakeup_gpio;
+	info->reset_gpio = bt_plat_data->reset_gpio;
+	info->reset_gpio_shared = bt_plat_data->reset_gpio_shared;
+	info->bt_sysclk = bt_plat_data->bt_sysclk;
+
+	info->irq = bt_plat_data->uart_irq;
+	info->uart_base = devm_ioremap(&pdev->dev, bt_plat_data->uart_base,
+					SZ_2K);
+	info->uart_iclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_iclk);
+	info->uart_fclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_fclk);
+	return 0;
+}
+
+static int hci_h4p_probe_dt(struct platform_device *pdev, struct hci_h4p_info *info)
+{
+	struct device_node *node;
+	struct device_node *uart = pdev->dev.of_node;
+	u32 val;
+	struct resource *mem;	
+
+	node = of_get_child_by_name(uart, "device");
+
+	if (!node)
+		return -ENODATA;
+
+	if (of_property_read_u32(node, "chip-type", &val)) return -EINVAL;
+	info->chip_type = val;
+	
+	if (of_property_read_u32(node, "bt-sysclk", &val)) return -EINVAL;
+	info->bt_sysclk = val;
+
+	info->reset_gpio       = of_get_named_gpio(node, "reset-gpios", 0);
+	info->host_wakeup_gpio = of_get_named_gpio(node, "host-wakeup-gpios", 0);
+	info->bt_wakeup_gpio   = of_get_named_gpio(node, "bluetooth-wakeup-gpios", 0);	
+	//uart = of_parse_phandle(node, "uart", 0);
+	if (!uart) {
+		dev_err(&pdev->dev, "UART link not provided\n");
+		return -EINVAL;
+	}
+
+	info->irq = irq_of_parse_and_map(uart, 0);
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	info->uart_base = devm_ioremap_resource(&pdev->dev, mem);
+
+	info->uart_iclk = of_clk_get_by_name(node, "ick");
+	info->uart_fclk = of_clk_get_by_name(node, "fck");	
+
+	printk("DT: have neccessary data\n");
+	return 0;
+}
+			  
+
 static int hci_h4p_probe(struct platform_device *pdev)
 {
-	struct hci_h4p_platform_data *bt_plat_data;
+
 	struct hci_h4p_info *info;
 	int err;
 
+	printk("HCI h4p probe\n");
+	if (pdev->dev.of_node) {
+		printk("Have platform data.\n");
+	}
+
 	dev_info(&pdev->dev, "Registering HCI H4P device\n");
 	info = devm_kzalloc(&pdev->dev, sizeof(struct hci_h4p_info),
 			GFP_KERNEL);
@@ -1131,40 +1196,36 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	spin_lock_init(&info->clocks_lock);
 	skb_queue_head_init(&info->txq);
 
-	if (pdev->dev.platform_data == NULL) {
+	if (pdev->dev.platform_data) {
+		err = hci_h4p_probe_pdata(pdev, info, pdev->dev.platform_data);
+	} else {
+		err = hci_h4p_probe_dt(pdev, info);
+	}
+	if (err) {
 		dev_err(&pdev->dev, "Could not get Bluetooth config data\n");
 		return -ENODATA;
 	}
 
-	bt_plat_data = pdev->dev.platform_data;
-	info->chip_type = bt_plat_data->chip_type;
-	info->bt_wakeup_gpio = bt_plat_data->bt_wakeup_gpio;
-	info->host_wakeup_gpio = bt_plat_data->host_wakeup_gpio;
-	info->reset_gpio = bt_plat_data->reset_gpio;
-	info->reset_gpio_shared = bt_plat_data->reset_gpio_shared;
-	info->bt_sysclk = bt_plat_data->bt_sysclk;
-
-	BT_DBG("RESET gpio: %d", info->reset_gpio);
-	BT_DBG("BTWU gpio: %d", info->bt_wakeup_gpio);
-	BT_DBG("HOSTWU gpio: %d", info->host_wakeup_gpio);
-	BT_DBG("sysclk: %d", info->bt_sysclk);
+	printk("base/irq gpio: %lx/%d/%d\n",
+	       info->uart_base, info->irq);
+	printk("RESET/BTWU/HOSTWU gpio: %d/%d/%d\n",
+	       info->reset_gpio, info->bt_wakeup_gpio, info->host_wakeup_gpio);
+	printk("chip type, sysclk: %d/%d\n", info->chip_type, info->bt_sysclk);
+	printk("clock i/f: %lx/%lx\n", info->uart_iclk, info->uart_fclk);	
 
 	init_completion(&info->test_completion);
 	complete_all(&info->test_completion);
 
-	if (!info->reset_gpio_shared) {
-		err = devm_gpio_request_one(&pdev->dev, info->reset_gpio,
-					    GPIOF_OUT_INIT_LOW, "bt_reset");
-		if (err < 0) {
-			dev_err(&pdev->dev, "Cannot get GPIO line %d\n",
-				info->reset_gpio);
-			return err;
-		}
+	err = devm_gpio_request_one(&pdev->dev, info->reset_gpio,
+				    GPIOF_OUT_INIT_LOW, "bt_reset");
+	if (err < 0) {
+		dev_err(&pdev->dev, "Cannot get GPIO line %d\n",
+			info->reset_gpio);
+		return err;
 	}
 
 	err = devm_gpio_request_one(&pdev->dev, info->bt_wakeup_gpio,
 				    GPIOF_OUT_INIT_LOW, "bt_wakeup");
-
 	if (err < 0) {
 		dev_err(info->dev, "Cannot get GPIO line 0x%d",
 			info->bt_wakeup_gpio);
@@ -1179,12 +1240,6 @@ static int hci_h4p_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	info->irq = bt_plat_data->uart_irq;
-	info->uart_base = devm_ioremap(&pdev->dev, bt_plat_data->uart_base,
-					SZ_2K);
-	info->uart_iclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_iclk);
-	info->uart_fclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_fclk);
-
 	err = devm_request_irq(&pdev->dev, info->irq, hci_h4p_interrupt,
 				IRQF_DISABLED, "hci_h4p", info);
 	if (err < 0) {
@@ -1246,12 +1301,38 @@ static int hci_h4p_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#if 0
+struct hci_h4p_platform_data bt_plat_data = {
+	.chip_type              = 3,
+	.bt_sysclk              = 2,
+	.bt_wakeup_gpio         = RX51_HCI_H4P_BTWU_GPIO,
+	.host_wakeup_gpio       = RX51_HCI_H4P_HOSTWU_GPIO,
+	.reset_gpio             = RX51_HCI_H4P_RESET_GPIO,
+	.reset_gpio_shared      = 0,
+	//      .uart_irq               = 73 + OMAP_INTC_START,
+	/* It seems to be 223 in hci_h4p case */
+	.uart_irq               = 223,
+	.uart_base              = OMAP3_UART2_BASE,
+	.uart_iclk              = "uart2_ick",
+	.uart_fclk              = "uart2_fck",
+	.set_pm_limits          = rx51_bt_set_pm_limits,
+};
+#endif
+
+static const struct of_device_id hci_h4p_of_match[] = {
+	{ .compatible = "brcm,uart,bcm2048" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, hci_h4p_of_match);
+
 
 static struct platform_driver hci_h4p_driver = {
 	.probe		= hci_h4p_probe,
 	.remove		= hci_h4p_remove,
 	.driver		= {
-		.name	= "hci_h4p",
+		.name	= "disabled" "hci_h4p",
+		.owner  = THIS_MODULE,
+		.of_match_table = of_match_ptr(hci_h4p_of_match),
 	},
 };
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
