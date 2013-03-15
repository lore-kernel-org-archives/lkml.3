Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab3COUGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:06:45 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56675 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156Ab3COUGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:06:38 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: linux-arm-kernel@lists.infradead.org
Cc: kevin@allwinnertech.com, sunny@allwinnertech.com, shuge@allwinnertech.com,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] serial: 8250_dw: add support for clk api
Date: Fri, 15 Mar 2013 21:06:23 +0100
Message-Id: <1363377988-4966-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1363377988-4966-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>

This commit implements support for using the clk api; this lets us use
the "clocks" property with device tree, instead of having to use
clock-frequency.

Signed-off-by: Emilio López <emilio@elopez.com.ar>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/tty/serial/8250/8250_dw.c |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index db0e66f..9a834a1 100644
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
@@ -136,8 +138,13 @@ static int dw8250_probe_of(struct uart_port *p)
 	if (!of_property_read_u32(np, "reg-shift", &val))
 		p->regshift = val;
 
+	/* clock got configured through clk api, all done */
+	if (p->uartclk)
+		return 0;
+
+	/* try to find out clock frequency from DT as fallback */
 	if (of_property_read_u32(np, "clock-frequency", &val)) {
-		dev_err(p->dev, "no clock-frequency property set\n");
+		dev_err(p->dev, "clk or clock-frequency not defined\n");
 		return -EINVAL;
 	}
 	p->uartclk = val;
@@ -294,9 +301,21 @@ static int dw8250_probe(struct platform_device *pdev)
 	if (!uart.port.membase)
 		return -ENOMEM;
 
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(data->clk))
+		data->clk = NULL;
+	else
+		clk_prepare_enable(data->clk);
+
 	uart.port.iotype = UPIO_MEM;
 	uart.port.serial_in = dw8250_serial_in;
 	uart.port.serial_out = dw8250_serial_out;
+	uart.port.private_data = data;
+	uart.port.uartclk = clk_get_rate(data->clk);
 
 	dw8250_setup_port(&uart);
 
@@ -312,12 +331,6 @@ static int dw8250_probe(struct platform_device *pdev)
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
@@ -333,6 +346,8 @@ static int dw8250_remove(struct platform_device *pdev)
 
 	serial8250_unregister_port(data->line);
 
+	clk_disable_unprepare(data->clk);
+
 	return 0;
 }
 
-- 
1.7.10.4

