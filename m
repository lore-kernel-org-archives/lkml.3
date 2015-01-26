Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbbAZAKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 19:10:24 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:46018 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAZAKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 19:10:21 -0500
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stefan@agner.ch
Subject: [PATCH] tty: serial: fsl_lpuart: terminate DMA on buffer flush
Date: Mon, 26 Jan 2015 01:10:16 +0100
Message-Id: <1422231016-27793-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On uart buffer flush, serial core resets the circular buffer.
If a DMA transfer is in progress at that time, the callback
lpuart_dma_tx_complete will move buffer's tail unconditionally,
hence tail moves beyond head. Use the flush_buffer hook to
terminate the DMA imeaditely and avoid lpuart_dma_tx_complete
being called in this situation.

This bug often showed up while shutdown and lead to duplicate
serial console output.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
 drivers/tty/serial/fsl_lpuart.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index e95c497..7615b5d 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -454,6 +454,15 @@ static int lpuart_dma_rx(struct lpuart_port *sport)
 	return 0;
 }
 
+static void lpuart_flush_buffer(struct uart_port *port)
+{
+	struct lpuart_port *sport = container_of(port, struct lpuart_port, port);
+	if (sport->lpuart_dma_tx_use) {
+		dmaengine_terminate_all(sport->dma_tx_chan);
+		sport->dma_tx_in_progress = 0;
+	}
+}
+
 static void lpuart_dma_rx_complete(void *arg)
 {
 	struct lpuart_port *sport = arg;
@@ -1519,6 +1528,7 @@ static struct uart_ops lpuart_pops = {
 	.release_port	= lpuart_release_port,
 	.config_port	= lpuart_config_port,
 	.verify_port	= lpuart_verify_port,
+	.flush_buffer	= lpuart_flush_buffer,
 };
 
 static struct uart_ops lpuart32_pops = {
@@ -1537,6 +1547,7 @@ static struct uart_ops lpuart32_pops = {
 	.release_port	= lpuart_release_port,
 	.config_port	= lpuart_config_port,
 	.verify_port	= lpuart_verify_port,
+	.flush_buffer	= lpuart_flush_buffer,
 };
 
 static struct lpuart_port *lpuart_ports[UART_NR];
-- 
2.2.2

