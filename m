Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab3GJQAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:00:06 -0400
Received: from sauhun.de ([89.238.76.85]:44355 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab3GJQAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:00:04 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 11/12] drivers/tty/serial: don't use devm_pinctrl_get_select_default() in probe
Date: Wed, 10 Jul 2013 16:57:46 +0100
Message-Id: <1373471889-18107-11-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
References: <1373471889-18107-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit ab78029 (drivers/pinctrl: grab default handles from device core),
we can rely on device core for setting the default pins. Compile tested only.

Acked-by: Linus Walleij <linus.walleij@linaro.org> (personally at LCE13)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/tty/serial/atmel_serial.c |    8 --------
 drivers/tty/serial/imx.c          |    9 ---------
 drivers/tty/serial/mxs-auart.c    |    8 --------
 drivers/tty/serial/omap-serial.c  |    9 ---------
 4 files changed, 34 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 691265f..0e39fac 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -39,7 +39,6 @@
 #include <linux/atmel_pdc.h>
 #include <linux/atmel_serial.h>
 #include <linux/uaccess.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/atmel.h>
 
 #include <asm/io.h>
@@ -1775,7 +1774,6 @@ static int atmel_serial_probe(struct platform_device *pdev)
 	struct atmel_uart_data *pdata = pdev->dev.platform_data;
 	void *data;
 	int ret = -ENODEV;
-	struct pinctrl *pinctrl;
 
 	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
 
@@ -1809,12 +1807,6 @@ static int atmel_serial_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(pinctrl);
-		goto err;
-	}
-
 	if (!atmel_use_dma_rx(&port->uart)) {
 		ret = -ENOMEM;
 		data = kmalloc(sizeof(struct atmel_uart_char)
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 415cec6..2797e55 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -47,7 +47,6 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/io.h>
 
 #include <asm/irq.h>
@@ -1507,7 +1506,6 @@ static int serial_imx_probe(struct platform_device *pdev)
 	void __iomem *base;
 	int ret = 0;
 	struct resource *res;
-	struct pinctrl *pinctrl;
 
 	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
 	if (!sport)
@@ -1543,13 +1541,6 @@ static int serial_imx_probe(struct platform_device *pdev)
 	sport->timer.function = imx_timeout;
 	sport->timer.data     = (unsigned long)sport;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(pinctrl);
-		dev_err(&pdev->dev, "failed to get default pinctrl: %d\n", ret);
-		return ret;
-	}
-
 	sport->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(sport->clk_ipg)) {
 		ret = PTR_ERR(sport->clk_ipg);
diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 4f5f161..a63a20e 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -32,7 +32,6 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/of_device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
@@ -1015,7 +1014,6 @@ static int mxs_auart_probe(struct platform_device *pdev)
 	u32 version;
 	int ret = 0;
 	struct resource *r;
-	struct pinctrl *pinctrl;
 
 	s = kzalloc(sizeof(struct mxs_auart_port), GFP_KERNEL);
 	if (!s) {
@@ -1029,12 +1027,6 @@ static int mxs_auart_probe(struct platform_device *pdev)
 	else if (ret < 0)
 		goto out_free;
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(pinctrl);
-		goto out_free;
-	}
-
 	if (of_id) {
 		pdev->id_entry = of_id->data;
 		s->devtype = pdev->id_entry->driver_data;
diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b6d1728..eacb0de 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -40,7 +40,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/of.h>
 #include <linux/gpio.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/platform_data/serial-omap.h>
 
 #define OMAP_MAX_HSUART_PORTS	6
@@ -160,7 +159,6 @@ struct uart_omap_port {
 	u32			latency;
 	u32			calc_latency;
 	struct work_struct	qos_work;
-	struct pinctrl		*pins;
 	bool			is_suspending;
 };
 
@@ -1468,13 +1466,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 		goto err_port_line;
 	}
 
-	up->pins = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(up->pins)) {
-		dev_warn(&pdev->dev, "did not get pins for uart%i error: %li\n",
-			 up->port.line, PTR_ERR(up->pins));
-		up->pins = NULL;
-	}
-
 	sprintf(up->name, "OMAP UART%d", up->port.line);
 	up->port.mapbase = mem->start;
 	up->port.membase = devm_ioremap(&pdev->dev, mem->start,
-- 
1.7.10.4

