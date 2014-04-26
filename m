Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381AbaDZALU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:11:20 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:39869 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbaDZALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:11:19 -0400
From: jon@ringle.org
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: gregkh@linuxfoundation.org, shc_work@mail.ru,
        Jon Ringle <jringle@gridpoint.com>
Subject: [PATCH] serial: sc16is7xx: dynamically allocate tx/rx buffer
Date: Fri, 25 Apr 2014 20:11:07 -0400
Message-Id: <1398471067-3142-1-git-send-email-jon@ringle.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Ringle <jringle@gridpoint.com>

This fixes the warnings:

   drivers/tty/serial/sc16is7xx.c: In function 'sc16is7xx_handle_rx':
>> drivers/tty/serial/sc16is7xx.c:548:1: warning: 'sc16is7xx_handle_rx' uses dynamic stack allocation [enabled by default]
   drivers/tty/serial/sc16is7xx.c: In function 'sc16is7xx_handle_tx':
>> drivers/tty/serial/sc16is7xx.c:589:1: warning: 'sc16is7xx_handle_tx' uses dynamic stack allocation [enabled by default]

Signed-off-by: Jon Ringle <jringle@gridpoint.com>
---
 drivers/tty/serial/sc16is7xx.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 7206a64..880cedd 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -317,6 +317,7 @@ struct sc16is7xx_port {
 #ifdef CONFIG_GPIOLIB
 	struct gpio_chip		gpio;
 #endif
+	unsigned char			buf[SC16IS7XX_FIFO_SIZE];
 	struct sc16is7xx_one		p[0];
 };
 
@@ -471,16 +472,15 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 {
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	unsigned int lsr = 0, ch, flag, bytes_read, i;
-	u8 buf[port->fifosize];
 	bool read_lsr = (iir == SC16IS7XX_IIR_RLSE_SRC) ? true : false;
 
-	if (unlikely(rxlen >= port->fifosize)) {
+	if (unlikely(rxlen >= sizeof(s->buf))) {
 		dev_warn_ratelimited(port->dev,
 				     "Port %i: Possible RX FIFO overrun: %d\n",
 				     port->line, rxlen);
 		port->icount.buf_overrun++;
 		/* Ensure sanity of RX level */
-		rxlen = port->fifosize;
+		rxlen = sizeof(s->buf);
 	}
 
 	while (rxlen) {
@@ -493,12 +493,12 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 			lsr = 0;
 
 		if (read_lsr) {
-			buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
+			s->buf[0] = sc16is7xx_port_read(port, SC16IS7XX_RHR_REG);
 			bytes_read = 1;
 		} else {
 			regcache_cache_bypass(s->regmap, true);
 			regmap_raw_read(s->regmap, SC16IS7XX_RHR_REG,
-					buf, rxlen);
+					s->buf, rxlen);
 			regcache_cache_bypass(s->regmap, false);
 			bytes_read = rxlen;
 		}
@@ -532,7 +532,7 @@ static void sc16is7xx_handle_rx(struct uart_port *port, unsigned int rxlen,
 		}
 
 		for (i = 0; i < bytes_read; ++i) {
-			ch = buf[i];
+			ch = s->buf[i];
 			if (uart_handle_sysrq_char(port, ch))
 				continue;
 
@@ -553,7 +553,6 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 	struct sc16is7xx_port *s = dev_get_drvdata(port->dev);
 	struct circ_buf *xmit = &port->state->xmit;
 	unsigned int txlen, to_send, i;
-	u8 buf[port->fifosize];
 
 	if (unlikely(port->x_char)) {
 		sc16is7xx_port_write(port, SC16IS7XX_THR_REG, port->x_char);
@@ -577,11 +576,11 @@ static void sc16is7xx_handle_tx(struct uart_port *port)
 
 		/* Convert to linear buffer */
 		for (i = 0; i < to_send; ++i) {
-			buf[i] = xmit->buf[xmit->tail];
+			s->buf[i] = xmit->buf[xmit->tail];
 			xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
 		}
 		regcache_cache_bypass(s->regmap, true);
-		regmap_raw_write(s->regmap, SC16IS7XX_THR_REG, buf, to_send);
+		regmap_raw_write(s->regmap, SC16IS7XX_THR_REG, s->buf, to_send);
 		regcache_cache_bypass(s->regmap, false);
 	}
 
-- 
1.8.5.4

