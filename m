Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbaJCV7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:59:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46124 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaJCV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:59:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 3.16 287/357] tty/serial: at91: BUG: disable interrupts when !UART_ENABLE_MS()
Date: Fri,  3 Oct 2014 14:31:13 -0700
Message-Id: <20141003212942.106051461@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@gmail.com>

commit 35b675b9100fc38f58cb75b30e422ecd342519a8 upstream.

In set_termios(), interrupts where not disabled if UART_ENABLE_MS() was
false.

Tested on at91sam9g35.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/atmel_serial.c |   43 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -527,6 +527,45 @@ static void atmel_enable_ms(struct uart_
 }
 
 /*
+ * Disable modem status interrupts
+ */
+static void atmel_disable_ms(struct uart_port *port)
+{
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
+	uint32_t idr = 0;
+
+	/*
+	 * Interrupt should not be disabled twice
+	 */
+	if (!atmel_port->ms_irq_enabled)
+		return;
+
+	atmel_port->ms_irq_enabled = false;
+
+	if (atmel_port->gpio_irq[UART_GPIO_CTS] >= 0)
+		disable_irq(atmel_port->gpio_irq[UART_GPIO_CTS]);
+	else
+		idr |= ATMEL_US_CTSIC;
+
+	if (atmel_port->gpio_irq[UART_GPIO_DSR] >= 0)
+		disable_irq(atmel_port->gpio_irq[UART_GPIO_DSR]);
+	else
+		idr |= ATMEL_US_DSRIC;
+
+	if (atmel_port->gpio_irq[UART_GPIO_RI] >= 0)
+		disable_irq(atmel_port->gpio_irq[UART_GPIO_RI]);
+	else
+		idr |= ATMEL_US_RIIC;
+
+	if (atmel_port->gpio_irq[UART_GPIO_DCD] >= 0)
+		disable_irq(atmel_port->gpio_irq[UART_GPIO_DCD]);
+	else
+		idr |= ATMEL_US_DCDIC;
+
+	UART_PUT_IDR(port, idr);
+}
+
+/*
  * Control the transmission of a break signal
  */
 static void atmel_break_ctl(struct uart_port *port, int break_state)
@@ -1993,7 +2032,9 @@ static void atmel_set_termios(struct uar
 
 	/* CTS flow-control and modem-status interrupts */
 	if (UART_ENABLE_MS(port, termios->c_cflag))
-		port->ops->enable_ms(port);
+		atmel_enable_ms(port);
+	else
+		atmel_disable_ms(port);
 
 	spin_unlock_irqrestore(&port->lock, flags);
 }


