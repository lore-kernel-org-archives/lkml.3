Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaGIRuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:50:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:43734 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbaGIRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:50:14 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        mika.westerberg@linux.intel.com
Subject: [PATCH 3/6] tty: serial: 8250 core: add runtime pm
Date: Wed,  9 Jul 2014 19:49:34 +0200
Message-Id: <1404928177-26554-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While comparing the OMAP-serial and the 8250 part of this I noticed that
the the latter does not use runtime-pm. Here are the pieces. It is
basically a get before first register access and a last_busy + put after
last access.
If I understand this correct, it should do nothing as long as
pm_runtime_use_autosuspend() + pm_runtime_enable() isn't invoked on the
device.

Cc: mika.westerberg@linux.intel.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 101 +++++++++++++++++++++++++++++++-----
 1 file changed, 88 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index d37eb08..1a91a89 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -38,6 +38,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #ifdef CONFIG_SPARC
 #include <linux/sunserialcore.h>
 #endif
@@ -553,10 +554,11 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 	 * offset but the UART channel may only write to the corresponding
 	 * bit.
 	 */
+	pm_runtime_get_sync(p->port.dev);
 	if ((p->port.type == PORT_XR17V35X) ||
 	   (p->port.type == PORT_XR17D15X)) {
 		serial_out(p, UART_EXAR_SLEEP, sleep ? 0xff : 0);
-		return;
+		goto out;
 	}
 
 	if (p->capabilities & UART_CAP_SLEEP) {
@@ -571,7 +573,17 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 			serial_out(p, UART_EFR, 0);
 			serial_out(p, UART_LCR, 0);
 		}
+
+		if (!device_may_wakeup(p->port.dev)) {
+			if (sleep)
+				pm_runtime_forbid(p->port.dev);
+			else
+				pm_runtime_allow(p->port.dev);
+		}
 	}
+out:
+	pm_runtime_mark_last_busy(p->port.dev);
+	pm_runtime_put_autosuspend(p->port.dev);
 }
 
 #ifdef CONFIG_SERIAL_8250_RSA
@@ -1280,6 +1292,7 @@ static void serial8250_stop_tx(struct uart_port *port)
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
 
+	pm_runtime_get_sync(port->dev);
 	__stop_tx(up);
 
 	/*
@@ -1289,6 +1302,8 @@ static void serial8250_stop_tx(struct uart_port *port)
 		up->acr |= UART_ACR_TXDIS;
 		serial_icr_write(up, UART_ACR, up->acr);
 	}
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 }
 
 static void serial8250_start_tx(struct uart_port *port)
@@ -1296,8 +1311,9 @@ static void serial8250_start_tx(struct uart_port *port)
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
 
+	pm_runtime_get_sync(port->dev);
 	if (up->dma && !serial8250_tx_dma(up)) {
-		return;
+		goto out;
 	} else if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
 		serial_port_out(port, UART_IER, up->ier);
@@ -1318,6 +1334,9 @@ static void serial8250_start_tx(struct uart_port *port)
 		up->acr &= ~UART_ACR_TXDIS;
 		serial_icr_write(up, UART_ACR, up->acr);
 	}
+out:
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 }
 
 static void serial8250_stop_rx(struct uart_port *port)
@@ -1325,9 +1344,14 @@ static void serial8250_stop_rx(struct uart_port *port)
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
 
+	pm_runtime_get_sync(port->dev);
+
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
 	serial_port_out(port, UART_IER, up->ier);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 }
 
 static void serial8250_enable_ms(struct uart_port *port)
@@ -1340,7 +1364,10 @@ static void serial8250_enable_ms(struct uart_port *port)
 		return;
 
 	up->ier |= UART_IER_MSI;
+	pm_runtime_get_sync(port->dev);
 	serial_port_out(port, UART_IER, up->ier);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 }
 
 /*
@@ -1530,9 +1557,17 @@ EXPORT_SYMBOL_GPL(serial8250_handle_irq);
 
 static int serial8250_default_handle_irq(struct uart_port *port)
 {
-	unsigned int iir = serial_port_in(port, UART_IIR);
+	unsigned int iir;
+	int ret;
 
-	return serial8250_handle_irq(port, iir);
+	pm_runtime_get_sync(port->dev);
+
+	iir = serial_port_in(port, UART_IIR);
+	ret = serial8250_handle_irq(port, iir);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+	return ret;
 }
 
 /*
@@ -1790,11 +1825,16 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	unsigned long flags;
 	unsigned int lsr;
 
+	pm_runtime_get_sync(port->dev);
+
 	spin_lock_irqsave(&port->lock, flags);
 	lsr = serial_port_in(port, UART_LSR);
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&port->lock, flags);
 
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+
 	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
@@ -1805,7 +1845,10 @@ static unsigned int serial8250_get_mctrl(struct uart_port *port)
 	unsigned int status;
 	unsigned int ret;
 
+	pm_runtime_get_sync(port->dev);
 	status = serial8250_modem_status(up);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 
 	ret = 0;
 	if (status & UART_MSR_DCD)
@@ -1838,7 +1881,10 @@ static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	mcr = (mcr & up->mcr_mask) | up->mcr_force | up->mcr;
 
+	pm_runtime_get_sync(port->dev);
 	serial_port_out(port, UART_MCR, mcr);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 }
 
 static void serial8250_break_ctl(struct uart_port *port, int break_state)
@@ -1847,6 +1893,7 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 		container_of(port, struct uart_8250_port, port);
 	unsigned long flags;
 
+	pm_runtime_get_sync(port->dev);
 	spin_lock_irqsave(&port->lock, flags);
 	if (break_state == -1)
 		up->lcr |= UART_LCR_SBC;
@@ -1854,6 +1901,8 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 		up->lcr &= ~UART_LCR_SBC;
 	serial_port_out(port, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&port->lock, flags);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 }
 
 /*
@@ -1898,12 +1947,23 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 
 static int serial8250_get_poll_char(struct uart_port *port)
 {
-	unsigned char lsr = serial_port_in(port, UART_LSR);
+	unsigned char lsr;
+	int status;
+
+	pm_runtime_get_sync(port->dev);
 
-	if (!(lsr & UART_LSR_DR))
-		return NO_POLL_CHAR;
+	lsr = serial_port_in(port, UART_LSR);
 
-	return serial_port_in(port, UART_RX);
+	if (!(lsr & UART_LSR_DR)) {
+		status = NO_POLL_CHAR;
+		goto out;
+	}
+
+	status = serial_port_in(port, UART_RX);
+out:
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
+	return status;
 }
 
 
@@ -1914,6 +1974,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
 
+	pm_runtime_get_sync(up->dev);
 	/*
 	 *	First save the IER then disable the interrupts
 	 */
@@ -1935,6 +1996,9 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	 */
 	wait_for_xmitr(up, BOTH_EMPTY);
 	serial_port_out(port, UART_IER, ier);
+	pm_runtime_mark_last_busy(up->dev);
+	pm_runtime_put_autosuspend(up->dev);
+
 }
 
 #endif /* CONFIG_CONSOLE_POLL */
@@ -1961,6 +2025,7 @@ int serial8250_do_startup(struct uart_port *port)
 	if (port->iotype != up->cur_iotype)
 		set_io_from_upio(port);
 
+	pm_runtime_get_sync(port->dev);
 	if (port->type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
@@ -1981,7 +2046,6 @@ int serial8250_do_startup(struct uart_port *port)
 	 */
 	enable_rsa(up);
 #endif
-
 	/*
 	 * Clear the FIFO buffers and disable them.
 	 * (they will be reenabled in set_termios())
@@ -2005,7 +2069,8 @@ int serial8250_do_startup(struct uart_port *port)
 	    (serial_port_in(port, UART_LSR) == 0xff)) {
 		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
 				   serial_index(port));
-		return -ENODEV;
+		retval = -ENODEV;
+		goto out;
 	}
 
 	/*
@@ -2090,7 +2155,7 @@ int serial8250_do_startup(struct uart_port *port)
 	} else {
 		retval = serial_link_irq_chain(up);
 		if (retval)
-			return retval;
+			goto out;
 	}
 
 	/*
@@ -2188,8 +2253,11 @@ int serial8250_do_startup(struct uart_port *port)
 		outb_p(0x80, icp);
 		inb_p(icp);
 	}
-
-	return 0;
+	retval = 0;
+out:
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+	return retval;
 }
 EXPORT_SYMBOL_GPL(serial8250_do_startup);
 
@@ -2207,6 +2275,7 @@ void serial8250_do_shutdown(struct uart_port *port)
 		container_of(port, struct uart_8250_port, port);
 	unsigned long flags;
 
+	pm_runtime_get_sync(port->dev);
 	/*
 	 * Disable interrupts from this port
 	 */
@@ -2246,6 +2315,8 @@ void serial8250_do_shutdown(struct uart_port *port)
 	 * the IRQ chain.
 	 */
 	serial_port_in(port, UART_RX);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
 
 	del_timer_sync(&up->timer);
 	up->timer.function = serial8250_timeout;
@@ -2365,6 +2436,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Ok, we're now changing the port state.  Do it with
 	 * interrupts disabled.
 	 */
+	pm_runtime_get_sync(port->dev);
 	spin_lock_irqsave(&port->lock, flags);
 
 	/*
@@ -2486,6 +2558,9 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 	serial8250_set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+
 	/* Don't rewrite B0 */
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
-- 
2.0.1

