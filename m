Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab3FGSIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:08:07 -0400
Received: from 1.mo1.mail-out.ovh.net ([178.32.127.22]:37765 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754298Ab3FGSIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:08:06 -0400
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [RFC PATCH 31/50] tty: atmel_serial: prepare clk before calling enable
Date: Fri,  7 Jun 2013 20:07:55 +0200
Message-Id: <1370628479-2542-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
References: <1370615115-16979-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 2455587698231703580
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrgeduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
avoid common clk framework warnings.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/tty/serial/atmel_serial.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 3467462..b9b42cf 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -1458,9 +1458,10 @@ static void atmel_of_init_port(struct atmel_uart_port *atmel_port,
 /*
  * Configure the port from the platform device resource info.
  */
-static void atmel_init_port(struct atmel_uart_port *atmel_port,
+static int atmel_init_port(struct atmel_uart_port *atmel_port,
 				      struct platform_device *pdev)
 {
+	int ret;
 	struct uart_port *port = &atmel_port->uart;
 	struct atmel_uart_data *pdata = pdev->dev.platform_data;
 
@@ -1496,7 +1497,17 @@ static void atmel_init_port(struct atmel_uart_port *atmel_port,
 	/* for console, the clock could already be configured */
 	if (!atmel_port->clk) {
 		atmel_port->clk = clk_get(&pdev->dev, "usart");
-		clk_enable(atmel_port->clk);
+		if (IS_ERR(atmel_port->clk)) {
+			ret = PTR_ERR(atmel_port->clk);
+			atmel_port->clk = NULL;
+			return ret;
+		}
+		ret = clk_prepare_enable(atmel_port->clk);
+		if (ret) {
+			clk_put(atmel_port->clk);
+			atmel_port->clk = NULL;
+			return ret;
+		}
 		port->uartclk = clk_get_rate(atmel_port->clk);
 		clk_disable(atmel_port->clk);
 		/* only enable clock when USART is in use */
@@ -1511,6 +1522,8 @@ static void atmel_init_port(struct atmel_uart_port *atmel_port,
 	} else {
 		atmel_port->tx_done_mask = ATMEL_US_TXRDY;
 	}
+
+	return 0;
 }
 
 struct platform_device *atmel_default_console_device;	/* the serial console device */
@@ -1601,6 +1614,7 @@ static void __init atmel_console_get_options(struct uart_port *port, int *baud,
 
 static int __init atmel_console_setup(struct console *co, char *options)
 {
+	int ret;
 	struct uart_port *port = &atmel_ports[co->index].uart;
 	int baud = 115200;
 	int bits = 8;
@@ -1612,7 +1626,9 @@ static int __init atmel_console_setup(struct console *co, char *options)
 		return -ENODEV;
 	}
 
-	clk_enable(atmel_ports[co->index].clk);
+	ret = clk_enable(atmel_ports[co->index].clk);
+	if (ret)
+		return ret;
 
 	UART_PUT_IDR(port, -1);
 	UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
@@ -1645,6 +1661,7 @@ static struct console atmel_console = {
  */
 static int __init atmel_console_init(void)
 {
+	int ret;
 	if (atmel_default_console_device) {
 		struct atmel_uart_data *pdata =
 			atmel_default_console_device->dev.platform_data;
@@ -1655,7 +1672,9 @@ static int __init atmel_console_init(void)
 		port->uart.line = id;
 
 		add_preferred_console(ATMEL_DEVICENAME, id, NULL);
-		atmel_init_port(port, atmel_default_console_device);
+		ret = atmel_init_port(port, atmel_default_console_device);
+		if (ret)
+			return ret;
 		register_console(&atmel_console);
 	}
 
@@ -1786,7 +1805,9 @@ static int atmel_serial_probe(struct platform_device *pdev)
 	port->backup_imr = 0;
 	port->uart.line = ret;
 
-	atmel_init_port(port, pdev);
+	ret = atmel_init_port(port, pdev);
+	if (ret)
+		goto err;
 
 	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
 	if (IS_ERR(pinctrl)) {
@@ -1812,9 +1833,9 @@ static int atmel_serial_probe(struct platform_device *pdev)
 			&& ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
 		/*
 		 * The serial core enabled the clock for us, so undo
-		 * the clk_enable() in atmel_console_setup()
+		 * the clk_prepare_enable() in atmel_console_setup()
 		 */
-		clk_disable(port->clk);
+		clk_disable_unprepare(port->clk);
 	}
 #endif
 
-- 
1.7.9.5

