Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaAIXir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:38:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44217 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaAIXip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:38:45 -0500
Date: Fri, 10 Jan 2014 00:38:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v4] Bluetooth: Add hci_h4p driver
Message-ID: <20140109233843.GB19974@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
 <20140103013640.GB27678@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140103013640.GB27678@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Here are some cleanup suggestions for probe, removal & module
> initialization functions.

...and here's the patch implementing those suggestions. Thanks!

Reported-by: Sebastian Reichel <sre@ring0.de>
Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
index 5c7acad..d69362d 100644
--- a/drivers/bluetooth/nokia_core.c
+++ b/drivers/bluetooth/nokia_core.c
@@ -39,6 +39,7 @@
 #include <linux/gpio.h>
 #include <linux/timer.h>
 #include <linux/kthread.h>
+#include <linux/io.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -1079,7 +1080,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	int err;
 
 	dev_info(&pdev->dev, "Registering HCI H4P device\n");
-	info = kzalloc(sizeof(struct hci_h4p_info), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct hci_h4p_info), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
 
@@ -1092,7 +1093,6 @@ static int hci_h4p_probe(struct platform_device *pdev)
 
 	if (pdev->dev.platform_data == NULL) {
 		dev_err(&pdev->dev, "Could not get Bluetooth config data\n");
-		kfree(info);
 		return -ENODATA;
 	}
 
@@ -1113,67 +1113,59 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	complete_all(&info->test_completion);
 
 	if (!info->reset_gpio_shared) {
-		err = gpio_request(info->reset_gpio, "bt_reset");
+		err = devm_gpio_request_one(&pdev->dev, info->reset_gpio,
+					    GPIOF_OUT_INIT_LOW, "bt_reset");
 		if (err < 0) {
 			dev_err(&pdev->dev, "Cannot get GPIO line %d\n",
 				info->reset_gpio);
-			goto cleanup_setup;
+			return err;
 		}
 	}
 
-	err = gpio_request(info->bt_wakeup_gpio, "bt_wakeup");
+	err = devm_gpio_request_one(&pdev->dev, info->bt_wakeup_gpio,
+				    GPIOF_OUT_INIT_LOW, "bt_wakeup");
+
 	if (err < 0) {
 		dev_err(info->dev, "Cannot get GPIO line 0x%d",
 			info->bt_wakeup_gpio);
-		if (!info->reset_gpio_shared)
-			gpio_free(info->reset_gpio);
-		goto cleanup_setup;
+		return err;
 	}
 
-	err = gpio_request(info->host_wakeup_gpio, "host_wakeup");
+	err = devm_gpio_request_one(&pdev->dev, info->host_wakeup_gpio,
+				    GPIOF_DIR_IN, "host_wakeup");
 	if (err < 0) {
 		dev_err(info->dev, "Cannot get GPIO line %d",
 		       info->host_wakeup_gpio);
-		if (!info->reset_gpio_shared)
-			gpio_free(info->reset_gpio);
-		gpio_free(info->bt_wakeup_gpio);
-		goto cleanup_setup;
+		return err;
 	}
 
-	gpio_direction_output(info->reset_gpio, 0);
-	gpio_direction_output(info->bt_wakeup_gpio, 0);
-	gpio_direction_input(info->host_wakeup_gpio);
-
 	info->irq = bt_plat_data->uart_irq;
-	info->uart_base = ioremap(bt_plat_data->uart_base, SZ_2K);
-	info->uart_iclk = clk_get(NULL, bt_plat_data->uart_iclk);
-	info->uart_fclk = clk_get(NULL, bt_plat_data->uart_fclk);
+	info->uart_base = devm_ioremap(&pdev->dev, bt_plat_data->uart_base, SZ_2K);
+	info->uart_iclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_iclk);
+	info->uart_fclk = devm_clk_get(&pdev->dev, bt_plat_data->uart_fclk);
 
 	err = request_irq(info->irq, hci_h4p_interrupt, IRQF_DISABLED, "hci_h4p",
 			  info);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n", info->irq);
-		goto cleanup;
+		return err;
 	}
 
-	err = request_irq(gpio_to_irq(info->host_wakeup_gpio),
+	err = devm_request_irq(&pdev->dev, gpio_to_irq(info->host_wakeup_gpio),
 			  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
 			  IRQF_TRIGGER_RISING | IRQF_DISABLED,
 			  "hci_h4p_wkup", info);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
 			  gpio_to_irq(info->host_wakeup_gpio));
-		free_irq(info->irq, info);
-		goto cleanup;
+		return err;
 	}
 
 	err = irq_set_irq_wake(gpio_to_irq(info->host_wakeup_gpio), 1);
 	if (err < 0) {
 		dev_err(info->dev, "hci_h4p: unable to set wakeup for IRQ %d\n",
 				gpio_to_irq(info->host_wakeup_gpio));
-		free_irq(info->irq, info);
-		free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
-		goto cleanup;
+		return err;
 	}
 
 	init_timer_deferrable(&info->lazy_release);
@@ -1182,7 +1174,7 @@ static int hci_h4p_probe(struct platform_device *pdev)
 	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
 	err = hci_h4p_reset_uart(info);
 	if (err < 0)
-		goto cleanup_irq;
+		return err;
 	gpio_set_value(info->reset_gpio, 0);
 	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
 
@@ -1190,23 +1182,10 @@ static int hci_h4p_probe(struct platform_device *pdev)
 
 	if (hci_h4p_register_hdev(info) < 0) {
 		dev_err(info->dev, "failed to register hci_h4p hci device\n");
-		goto cleanup_irq;
+		return -EINVAL;
 	}
 
 	return 0;
-
-cleanup_irq:
-	free_irq(info->irq, (void *)info);
-	free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
-cleanup:
-	gpio_set_value(info->reset_gpio, 0);
-	if (!info->reset_gpio_shared)
-		gpio_free(info->reset_gpio);
-	gpio_free(info->bt_wakeup_gpio);
-	gpio_free(info->host_wakeup_gpio);
-cleanup_setup:
-	kfree(info);
-	return err;
 }
 
 static int hci_h4p_remove(struct platform_device *pdev)
@@ -1238,25 +1217,7 @@ static struct platform_driver hci_h4p_driver = {
 	},
 };
 
-static int __init hci_h4p_init(void)
-{
-	int err = 0;
-
-	/* Register the driver with LDM */
-	err = platform_driver_register(&hci_h4p_driver);
-	if (err < 0)
-		printk(KERN_WARNING "failed to register hci_h4p driver\n");
-
-	return err;
-}
-
-static void __exit hci_h4p_exit(void)
-{
-	platform_driver_unregister(&hci_h4p_driver);
-}
-
-module_init(hci_h4p_init);
-module_exit(hci_h4p_exit);
+module_platform_driver(hci_h4p_driver);
 
 MODULE_ALIAS("platform:hci_h4p");
 MODULE_DESCRIPTION("Bluetooth h4 driver with nokia extensions");



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
