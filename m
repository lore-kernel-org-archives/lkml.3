Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927Ab3CGWOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:14:55 -0500
Received: from mail.free-electrons.com ([94.23.35.102]:33214 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab3CGWOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:14:53 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] serial: 8250_dw: add support for clocks property when using DeviceTree
Date: Thu,  7 Mar 2013 23:14:15 +0100
Message-Id: <1362694460-1919-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1362694460-1919-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>

This commit implements support for using the "clocks" DT property, instead
of having to use clock-frequency.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
---
 drivers/tty/serial/8250/8250_dw.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index db0e66f..8f03800 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -26,6 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/clk.h>
 
 #include "8250.h"
 
@@ -55,8 +56,9 @@
 
 
 struct dw8250_data {
-	int	last_lcr;
-	int	line;
+	int		last_lcr;
+	int		line;
+	struct clk	*clk;
 };
 
 static void dw8250_serial_out(struct uart_port *p, int offset, int value)
@@ -116,6 +118,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 static int dw8250_probe_of(struct uart_port *p)
 {
 	struct device_node	*np = p->dev->of_node;
+	struct dw8250_data	*data = p->private_data;
 	u32			val;
 
 	if (!of_property_read_u32(np, "reg-io-width", &val)) {
@@ -137,8 +140,15 @@ static int dw8250_probe_of(struct uart_port *p)
 		p->regshift = val;
 
 	if (of_property_read_u32(np, "clock-frequency", &val)) {
-		dev_err(p->dev, "no clock-frequency property set\n");
-		return -EINVAL;
+		/* Get clk rate through clk driver if present */
+		data->clk = clk_get(p->dev, NULL);
+		if (IS_ERR(data->clk)) {
+			dev_err(p->dev, "clk or clock-frequency not defined\n");
+			return -EINVAL;
+		}
+
+		clk_prepare_enable(data->clk);
+		val = clk_get_rate(data->clk);
 	}
 	p->uartclk = val;
 
@@ -300,6 +310,12 @@ static int dw8250_probe(struct platform_device *pdev)
 
 	dw8250_setup_port(&uart);
 
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	uart.port.private_data = data;
+
 	if (pdev->dev.of_node) {
 		err = dw8250_probe_of(&uart.port);
 		if (err)
@@ -312,12 +328,6 @@ static int dw8250_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	uart.port.private_data = data;
-
 	data->line = serial8250_register_8250_port(&uart);
 	if (data->line < 0)
 		return data->line;
@@ -333,6 +343,8 @@ static int dw8250_remove(struct platform_device *pdev)
 
 	serial8250_unregister_port(data->line);
 
+	clk_disable_unprepare(data->clk);
+
 	return 0;
 }
 
-- 
1.7.10.4

