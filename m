Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3DRIO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 04:14:27 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:61722 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab3DRIOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 04:14:23 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2] serial: pl011: Add Device Tree support to request DMA channels
Date: Thu, 18 Apr 2013 09:14:16 +0100
Message-Id: <1366272857-14038-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new DMA API is operational. It is now possible to request DMA
channels from information passed via Device Tree.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/tty/serial/amba-pl011.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/amba-pl011.c b/drivers/tty/serial/amba-pl011.c
index 3ea5408..1b39f58 100644
--- a/drivers/tty/serial/amba-pl011.c
+++ b/drivers/tty/serial/amba-pl011.c
@@ -249,6 +249,7 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 {
 	/* DMA is the sole user of the platform data right now */
 	struct amba_pl011_data *plat = uap->port.dev->platform_data;
+	struct device_node *np = uap->port.dev->of_node;
 	struct dma_slave_config tx_conf = {
 		.dst_addr = uap->port.mapbase + UART01x_DR,
 		.dst_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
@@ -259,9 +260,9 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 	struct dma_chan *chan;
 	dma_cap_mask_t mask;
 
-	/* We need platform data */
-	if (!plat || !plat->dma_filter) {
-		dev_info(uap->port.dev, "no DMA platform data\n");
+	/* We need platform data or DT */
+	if (!(plat && plat->dma_filter) && !np) {
+		dev_info(uap->port.dev, "no DMA platform data or DT\n");
 		return;
 	}
 
@@ -269,7 +270,10 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	chan = dma_request_channel(mask, plat->dma_filter, plat->dma_tx_param);
+	chan = dma_request_slave_channel_compat(mask,
+				(plat) ? plat->dma_filter : NULL,
+				(plat) ? plat->dma_tx_param : NULL,
+				uap->port.dev, "tx");
 	if (!chan) {
 		dev_err(uap->port.dev, "no TX DMA channel!\n");
 		return;
@@ -282,7 +286,7 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 		 dma_chan_name(uap->dmatx.chan));
 
 	/* Optionally make use of an RX channel as well */
-	if (plat->dma_rx_param) {
+	if ((plat && plat->dma_rx_param) || np) {
 		struct dma_slave_config rx_conf = {
 			.src_addr = uap->port.mapbase + UART01x_DR,
 			.src_addr_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
@@ -291,7 +295,10 @@ static void pl011_dma_probe_initcall(struct uart_amba_port *uap)
 			.device_fc = false,
 		};
 
-		chan = dma_request_channel(mask, plat->dma_filter, plat->dma_rx_param);
+		chan = dma_request_slave_channel_compat(mask,
+					(plat) ? plat->dma_filter : NULL,
+					(plat) ? plat->dma_rx_param : NULL,
+					uap->port.dev, "rx");
 		if (!chan) {
 			dev_err(uap->port.dev, "no RX DMA channel!\n");
 			return;
-- 
1.7.10.4

