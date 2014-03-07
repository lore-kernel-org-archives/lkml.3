Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaCGTOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 14:14:32 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49225 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbaCGTO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 14:14:29 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC v2 05/11] tty: xuartps: Rebrand driver as Cadence UART
Date: Fri,  7 Mar 2014 11:13:28 -0800
Message-Id: <1394219614-3197-6-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zynq's UART is Cadence IP. Make this visible in the prompt in kconfig
and additional comments in the driver.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/Kconfig         |  9 +++--
 drivers/tty/serial/xilinx_uartps.c | 77 +++++++++++++++++++++++---------------
 include/uapi/linux/serial_core.h   |  2 +-
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index a3815eaed421..1294284342bc 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1368,18 +1368,19 @@ config SERIAL_MXS_AUART_CONSOLE
 	  Enable a MXS AUART port to be the system console.
 
 config SERIAL_XILINX_PS_UART
-	tristate "Xilinx PS UART support"
+	tristate "Cadence (Xilinx Zynq) UART support"
 	depends on OF
 	select SERIAL_CORE
 	help
-	  This driver supports the Xilinx PS UART port.
+	  This driver supports the Cadence UART. It is found e.g. in Xilinx
+	  Zynq.
 
 config SERIAL_XILINX_PS_UART_CONSOLE
-	bool "Xilinx PS UART console support"
+	bool "Cadence UART console support"
 	depends on SERIAL_XILINX_PS_UART=y
 	select SERIAL_CORE_CONSOLE
 	help
-	  Enable a Xilinx PS UART port to be the system console.
+	  Enable a Cadence UART port to be the system console.
 
 config SERIAL_AR933X
 	tristate "AR933X serial port support"
diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index a39c2d290902..b4a2a68b5e0e 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1,5 +1,5 @@
 /*
- * Xilinx PS UART driver
+ * Cadence UART driver (found in Xilinx Zynq)
  *
  * 2011 - 2014 (C) Xilinx Inc.
  *
@@ -8,6 +8,9 @@
  * License as published by the Free Software Foundation;
  * either version 2 of the License, or (at your option) any
  * later version.
+ *
+ * This driver has originally been pushed by Xilinx using a Zynq-branding. This
+ * still shows in the file name, function/symbol name prefixes.
  */
 
 #if defined(CONFIG_SERIAL_XILINX_PS_UART_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -147,15 +150,15 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 /**
  * struct xuartps - device data
  * @port:		Pointer to the UART port
- * @refclk:		Reference clock
- * @aperclk:		APB clock
+ * @uartclk:		Reference clock
+ * @pclk:		APB clock
  * @baud:		Current baud rate
  * @clk_rate_change_nb:	Notifier block for clock changes
  */
 struct xuartps {
 	struct uart_port	*port;
-	struct clk		*refclk;
-	struct clk		*aperclk;
+	struct clk		*uartclk;
+	struct clk		*pclk;
 	unsigned int		baud;
 	struct notifier_block	clk_rate_change_nb;
 };
@@ -1187,8 +1190,8 @@ static int xuartps_suspend(struct device *device)
 	if (console_suspend_enabled && !may_wake) {
 		struct xuartps *xuartps = port->private_data;
 
-		clk_disable(xuartps->refclk);
-		clk_disable(xuartps->aperclk);
+		clk_disable(xuartps->uartclk);
+		clk_disable(xuartps->pclk);
 	} else {
 		unsigned long flags = 0;
 
@@ -1232,8 +1235,8 @@ static int xuartps_resume(struct device *device)
 	if (console_suspend_enabled && !may_wake) {
 		struct xuartps *xuartps = port->private_data;
 
-		clk_enable(xuartps->aperclk);
-		clk_enable(xuartps->refclk);
+		clk_enable(xuartps->pclk);
+		clk_enable(xuartps->uartclk);
 
 		spin_lock_irqsave(&port->lock, flags);
 
@@ -1287,26 +1290,37 @@ static int xuartps_probe(struct platform_device *pdev)
 	if (!xuartps_data)
 		return -ENOMEM;
 
-	xuartps_data->aperclk = devm_clk_get(&pdev->dev, "aper_clk");
-	if (IS_ERR(xuartps_data->aperclk)) {
-		dev_err(&pdev->dev, "aper_clk clock not found.\n");
-		return PTR_ERR(xuartps_data->aperclk);
+	xuartps_data->pclk = devm_clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(xuartps_data->pclk)) {
+		xuartps_data->pclk = devm_clk_get(&pdev->dev, "aper_clk");
+		if (!IS_ERR(xuartps_data->pclk))
+			dev_err(&pdev->dev, "clock name 'aper_clk' is deprecated.\n");
+	}
+	if (IS_ERR(xuartps_data->pclk)) {
+		dev_err(&pdev->dev, "pclk clock not found.\n");
+		return PTR_ERR(xuartps_data->pclk);
+	}
+
+	xuartps_data->uartclk = devm_clk_get(&pdev->dev, "uart_clk");
+	if (IS_ERR(xuartps_data->uartclk)) {
+		xuartps_data->uartclk = devm_clk_get(&pdev->dev, "ref_clk");
+		if (!IS_ERR(xuartps_data->uartclk))
+			dev_err(&pdev->dev, "clock name 'ref_clk' is deprecated.\n");
 	}
-	xuartps_data->refclk = devm_clk_get(&pdev->dev, "ref_clk");
-	if (IS_ERR(xuartps_data->refclk)) {
-		dev_err(&pdev->dev, "ref_clk clock not found.\n");
-		return PTR_ERR(xuartps_data->refclk);
+	if (IS_ERR(xuartps_data->uartclk)) {
+		dev_err(&pdev->dev, "uart_clk clock not found.\n");
+		return PTR_ERR(xuartps_data->uartclk);
 	}
 
-	rc = clk_prepare_enable(xuartps_data->aperclk);
+	rc = clk_prepare_enable(xuartps_data->pclk);
 	if (rc) {
-		dev_err(&pdev->dev, "Unable to enable APER clock.\n");
+		dev_err(&pdev->dev, "Unable to enable pclk clock.\n");
 		return rc;
 	}
-	rc = clk_prepare_enable(xuartps_data->refclk);
+	rc = clk_prepare_enable(xuartps_data->uartclk);
 	if (rc) {
 		dev_err(&pdev->dev, "Unable to enable device clock.\n");
-		goto err_out_clk_dis_aper;
+		goto err_out_clk_dis_pclk;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -1324,7 +1338,7 @@ static int xuartps_probe(struct platform_device *pdev)
 #ifdef CONFIG_COMMON_CLK
 	xuartps_data->clk_rate_change_nb.notifier_call =
 			xuartps_clk_notifier_cb;
-	if (clk_notifier_register(xuartps_data->refclk,
+	if (clk_notifier_register(xuartps_data->uartclk,
 				&xuartps_data->clk_rate_change_nb))
 		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
 #endif
@@ -1344,7 +1358,7 @@ static int xuartps_probe(struct platform_device *pdev)
 		port->mapbase = res->start;
 		port->irq = res2->start;
 		port->dev = &pdev->dev;
-		port->uartclk = clk_get_rate(xuartps_data->refclk);
+		port->uartclk = clk_get_rate(xuartps_data->uartclk);
 		port->private_data = xuartps_data;
 		xuartps_data->port = port;
 		platform_set_drvdata(pdev, port);
@@ -1359,13 +1373,13 @@ static int xuartps_probe(struct platform_device *pdev)
 
 err_out_notif_unreg:
 #ifdef CONFIG_COMMON_CLK
-	clk_notifier_unregister(xuartps_data->refclk,
+	clk_notifier_unregister(xuartps_data->uartclk,
 			&xuartps_data->clk_rate_change_nb);
 #endif
 err_out_clk_disable:
-	clk_disable_unprepare(xuartps_data->refclk);
-err_out_clk_dis_aper:
-	clk_disable_unprepare(xuartps_data->aperclk);
+	clk_disable_unprepare(xuartps_data->uartclk);
+err_out_clk_dis_pclk:
+	clk_disable_unprepare(xuartps_data->pclk);
 
 	return rc;
 }
@@ -1384,19 +1398,20 @@ static int xuartps_remove(struct platform_device *pdev)
 
 	/* Remove the xuartps port from the serial core */
 #ifdef CONFIG_COMMON_CLK
-	clk_notifier_unregister(xuartps_data->refclk,
+	clk_notifier_unregister(xuartps_data->uartclk,
 			&xuartps_data->clk_rate_change_nb);
 #endif
 	rc = uart_remove_one_port(&xuartps_uart_driver, port);
 	port->mapbase = 0;
-	clk_disable_unprepare(xuartps_data->refclk);
-	clk_disable_unprepare(xuartps_data->aperclk);
+	clk_disable_unprepare(xuartps_data->uartclk);
+	clk_disable_unprepare(xuartps_data->pclk);
 	return rc;
 }
 
 /* Match table for of_platform binding */
 static struct of_device_id xuartps_of_match[] = {
 	{ .compatible = "xlnx,xuartps", },
+	{ .compatible = "cdns,uart-r1p8", },
 	{}
 };
 MODULE_DEVICE_TABLE(of, xuartps_of_match);
@@ -1441,6 +1456,6 @@ static void __exit xuartps_exit(void)
 module_init(xuartps_init);
 module_exit(xuartps_exit);
 
-MODULE_DESCRIPTION("Driver for PS UART");
+MODULE_DESCRIPTION("Driver for Cadence UART");
 MODULE_AUTHOR("Xilinx Inc.");
 MODULE_LICENSE("GPL");
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index b47dba2c1e6f..22aaf8ed7735 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -211,7 +211,7 @@
 /* VIA VT8500 SoC */
 #define PORT_VT8500	97
 
-/* Xilinx PSS UART */
+/* Cadence (Xilinx Zynq) UART */
 #define PORT_XUARTPS	98
 
 /* Atheros AR933X SoC */
-- 
1.9.0.1.g4196000

