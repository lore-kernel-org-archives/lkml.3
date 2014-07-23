Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402AbaGWPdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 11:33:17 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:36456 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757823AbaGWPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 11:33:12 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/2] serial: 8250_dw: Add optional reset control support
Date: Wed, 23 Jul 2014 23:33:06 +0800
Message-Id: <1406129587-24668-2-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1406129587-24668-1-git-send-email-wens@csie.org>
References: <1406129587-24668-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Allwinner A31 and A23 SoCs have a reset controller
maintaining the UART in reset by default.

This patch adds optional reset support to the driver.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt | 1 +
 drivers/tty/serial/8250/8250_dw.c                             | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt b/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt
index 095ac71..7f76214 100644
--- a/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt
+++ b/Documentation/devicetree/bindings/serial/snps-dw-apb-uart.txt
@@ -15,6 +15,7 @@ The supplying peripheral clock can also be handled, needing a second property
 	Required elements: "baudclk", "apb_pclk"
 
 Optional properties:
+- resets : phandle to the parent reset controller.
 - reg-shift : quantity to shift the register offsets by.  If this property is
   not present then the register offsets are not shifted.
 - reg-io-width : the size (in bytes) of the IO accesses that should be
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index affdcb1..501db2f 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/acpi.h>
 #include <linux/clk.h>
+#include <linux/reset.h>
 #include <linux/pm_runtime.h>
 
 #include <asm/byteorder.h>
@@ -60,6 +61,7 @@ struct dw8250_data {
 	int			line;
 	struct clk		*clk;
 	struct clk		*pclk;
+	struct reset_control	*rst;
 	struct uart_8250_dma	dma;
 };
 
@@ -383,6 +385,10 @@ static int dw8250_probe(struct platform_device *pdev)
 		}
 	}
 
+	data->rst = devm_reset_control_get_optional(&pdev->dev, NULL);
+	if (!IS_ERR(data->rst))
+		reset_control_deassert(data->rst);
+
 	data->dma.rx_chan_id = -1;
 	data->dma.tx_chan_id = -1;
 	data->dma.rx_param = data;
@@ -426,6 +432,9 @@ static int dw8250_remove(struct platform_device *pdev)
 
 	serial8250_unregister_port(data->line);
 
+	if (!IS_ERR(data->rst))
+		reset_control_assert(data->rst);
+
 	if (!IS_ERR(data->pclk))
 		clk_disable_unprepare(data->pclk);
 
-- 
2.0.1

