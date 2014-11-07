Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaKGOPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:15:09 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54179 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752792AbaKGOPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:15:05 -0500
Message-ID: <545CD3BF.8040905@arm.com>
Date: Fri, 07 Nov 2014 14:14:23 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 5/5] serial: pl011: Add device tree support for RX DMA polling
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add equivalent attributes to those provided in the platform data
for use when RX DMA is enabled.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
---
 Documentation/devicetree/bindings/serial/pl011.txt |   19 ++++++++++------
 drivers/tty/serial/amba-pl011.c                    |   22 +++++++++++++++++--
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/pl011.txt b/Documentation/devicetree/bindings/serial/pl011.txt
index 5d2e840..0e05340 100644
--- a/Documentation/devicetree/bindings/serial/pl011.txt
+++ b/Documentation/devicetree/bindings/serial/pl011.txt
@@ -6,12 +6,17 @@ Required properties:
 - interrupts: exactly one interrupt specifier
 
 Optional properties:
-- pinctrl: When present, must have one state named "sleep"
-	   and one state named "default"
-- clocks:  When present, must refer to exactly one clock named
-	   "apb_pclk"
-- dmas:	   When present, may have one or two dma channels.
-	   The first one must be named "rx", the second one
-	   must be named "tx".
+- pinctrl:		When present, must have one state named "sleep"
+			and one state named "default"
+- clocks:		When present, must refer to exactly one clock named
+			"apb_pclk"
+- dmas:			When present, may have one or two dma channels.
+			The first one must be named "rx", the second one
+			must be named "tx".
+- auto-poll:		Enables polling when using RX DMA.
+- poll-rate-ms:		Rate at which poll occurs when auto-poll is set,
+			default 100ms.
+- poll-timeout-ms:	Poll timeout when auto-poll is set, default
+			3000ms.
 
 See also bindings/arm/primecell.txt
diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 79b9c93..767711b 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -341,6 +341,7 @@ static void pl011_dma_probe_initcall(struct device *dev, struct uart_amba_port *
 		dmaengine_slave_config(chan, &rx_conf);
 		uap->dmarx.chan = chan;
 
+		uap->dmarx.auto_poll_rate = false;
 		if (plat && plat->dma_rx_poll_enable) {
 			/* Set poll rate if specified. */
 			if (plat->dma_rx_poll_rate) {
@@ -361,9 +362,24 @@ static void pl011_dma_probe_initcall(struct device *dev, struct uart_amba_port *
 					plat->dma_rx_poll_timeout;
 			else
 				uap->dmarx.poll_timeout = 3000;
-		} else
-			uap->dmarx.auto_poll_rate = false;
-
+		} else if (!plat && dev->of_node) {
+			uap->dmarx.auto_poll_rate = of_property_read_bool(
+						dev->of_node, "auto-poll");
+			if (uap->dmarx.auto_poll_rate) {
+				u32 x;
+
+				if (0 == of_property_read_u32(dev->of_node,
+						"poll-rate-ms", &x))
+					uap->dmarx.poll_rate = x;
+				else
+					uap->dmarx.poll_rate = 100;
+				if (0 == of_property_read_u32(dev->of_node,
+						"poll-timeout-ms", &x))
+					uap->dmarx.poll_timeout = x;
+				else
+					uap->dmarx.poll_timeout = 3000;
+			}
+		}
 		dev_info(uap->port.dev, "DMA channel RX %s\n",
 			 dma_chan_name(uap->dmarx.chan));
 	}
-- 
1.7.1

