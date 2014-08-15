Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaHORpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:45:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:57638 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaHORm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:42:58 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        mika.westerberg@linux.intel.com
Subject: [PATCH 03/15] tty: serial: 8250_core: add run time pm
Date: Fri, 15 Aug 2014 19:42:31 +0200
Message-Id: <1408124563-31541-4-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While comparing the OMAP-serial and the 8250 part of this I noticed that
the latter does not use run time-pm. Here are the pieces. It is
basically a get before first register access and a last_busy + put after
last access. This has to be enabled from userland _and_ UART_CAP_RPM is
required for this.
The runtime PM can usually work transparently in the background however
there is one exception to this: After serial8250_tx_chars() completes
there still may be unsent bytes in the FIFO (depending on CPU speed vs
baud rate + flow control). Even if the TTY-buffer is empty we do not
want RPM to disable the device because it won't send the remaining
bytes. Instead we leave serial8250_tx_chars() with RPM enabled and wait
for the FIFO empty interrupt. Once we enter serial8250_tx_chars() with
an empty buffer we know that the FIFO is empty and since we are not going
to send anything, we can disable the device.
That xchg() is to ensure that serial8250_tx_chars() can be called
multiple times and only the first invocation will actually invoke the
runtime PM function. So that the last invocation of __stop_tx() will
disable runtime pm.

v4…v5:
	- add a wrapper around rpm function and introduce UART_CAP_RPM
	  to ensure RPM put is invoked after the TX FIFO is empty.
v3…v4:
	- added runtime to the console code
	- removed device_may_wakeup() from serial8250_set_sleep()

Cc: mika.westerberg@linux.intel.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250.h      |   1 +
 drivers/tty/serial/8250/8250_core.c | 134 ++++++++++++++++++++++++++++++++----
 include/linux/serial_8250.h         |   1 +
 3 files changed, 123 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 85bfec5..1bcb4b2 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -72,6 +72,7 @@ struct serial8250_config {
 #define UART_CAP_UUE	(1 << 12)	/* UART needs IER bit 6 set (Xscale) */
 #define UART_CAP_RTOIE	(1 << 13)	/* UART needs IER bit 4 set (Xscale, Tegra) */
 #define UART_CAP_HFIFO	(1 << 14)	/* UART has a "hidden" FIFO */
+#define UART_CAP_RPM	(1 << 15)	/* Runtime PM is active while idle */
 
 #define UART_BUG_QUOT	(1 << 0)	/* UART has buggy quot LSB */
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 35fe96e..ae268e3 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -37,6 +37,7 @@
 #include <linux/nmi.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #ifdef CONFIG_SPARC
 #include <linux/sunserialcore.h>
 #endif
@@ -539,6 +540,53 @@ void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
 }
 EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
 
+static void serial8250_rpm_get(struct uart_8250_port *p)
+{
+	if (!(p->capabilities & UART_CAP_RPM))
+		return;
+	pm_runtime_get_sync(p->port.dev);
+}
+
+static void serial8250_rpm_put(struct uart_8250_port *p)
+{
+	if (!(p->capabilities & UART_CAP_RPM))
+		return;
+	pm_runtime_mark_last_busy(p->port.dev);
+	pm_runtime_put_autosuspend(p->port.dev);
+}
+
+/*
+ * This two wrapper ensure, that enable_runtime_pm_tx() can be called more than
+ * once and disable_runtime_pm_tx() will still disable RPM because the fifo is
+ * empty and the HW can idle again.
+ */
+static void serial8250_rpm_get_tx(struct uart_8250_port *p)
+{
+	unsigned char rpm_active;
+
+	if (!(p->capabilities & UART_CAP_RPM))
+		return;
+
+	rpm_active = xchg(&p->rpm_tx_active, 1);
+	if (rpm_active)
+		return;
+	pm_runtime_get_sync(p->port.dev);
+}
+
+static void serial8250_rpm_put_tx(struct uart_8250_port *p)
+{
+	unsigned char rpm_active;
+
+	if (!(p->capabilities & UART_CAP_RPM))
+		return;
+
+	rpm_active = xchg(&p->rpm_tx_active, 0);
+	if (!rpm_active)
+		return;
+	pm_runtime_mark_last_busy(p->port.dev);
+	pm_runtime_put_autosuspend(p->port.dev);
+}
+
 /*
  * IER sleep support.  UARTs which have EFRs need the "extended
  * capability" bit enabled.  Note that on XR16C850s, we need to
@@ -553,10 +601,11 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 	 * offset but the UART channel may only write to the corresponding
 	 * bit.
 	 */
+	serial8250_rpm_get(p);
 	if ((p->port.type == PORT_XR17V35X) ||
 	   (p->port.type == PORT_XR17D15X)) {
 		serial_out(p, UART_EXAR_SLEEP, sleep ? 0xff : 0);
-		return;
+		goto out;
 	}
 
 	if (p->capabilities & UART_CAP_SLEEP) {
@@ -572,6 +621,8 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
 			serial_out(p, UART_LCR, 0);
 		}
 	}
+out:
+	serial8250_rpm_put(p);
 }
 
 #ifdef CONFIG_SERIAL_8250_RSA
@@ -1272,6 +1323,7 @@ static inline void __stop_tx(struct uart_8250_port *p)
 	if (p->ier & UART_IER_THRI) {
 		p->ier &= ~UART_IER_THRI;
 		serial_out(p, UART_IER, p->ier);
+		serial8250_rpm_put_tx(p);
 	}
 }
 
@@ -1279,6 +1331,7 @@ static void serial8250_stop_tx(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 
+	serial8250_rpm_get(up);
 	__stop_tx(up);
 
 	/*
@@ -1288,12 +1341,14 @@ static void serial8250_stop_tx(struct uart_port *port)
 		up->acr |= UART_ACR_TXDIS;
 		serial_icr_write(up, UART_ACR, up->acr);
 	}
+	serial8250_rpm_put(up);
 }
 
 static void serial8250_start_tx(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 
+	serial8250_rpm_get_tx(up);
 	if (up->dma && !serial8250_tx_dma(up)) {
 		return;
 	} else if (!(up->ier & UART_IER_THRI)) {
@@ -1332,9 +1387,13 @@ static void serial8250_stop_rx(struct uart_port *port)
 {
 	struct uart_8250_port *up = up_to_u8250p(port);
 
+	serial8250_rpm_get(up);
+
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
 	serial_port_out(port, UART_IER, up->ier);
+
+	serial8250_rpm_put(up);
 }
 
 static void serial8250_enable_ms(struct uart_port *port)
@@ -1346,7 +1405,10 @@ static void serial8250_enable_ms(struct uart_port *port)
 		return;
 
 	up->ier |= UART_IER_MSI;
+
+	serial8250_rpm_get(up);
 	serial_port_out(port, UART_IER, up->ier);
+	serial8250_rpm_put(up);
 }
 
 /*
@@ -1468,7 +1530,12 @@ void serial8250_tx_chars(struct uart_8250_port *up)
 
 	DEBUG_INTR("THRE...");
 
-	if (uart_circ_empty(xmit))
+	/*
+	 * With RPM enabled, we have to wait once the FIFO is empty before the
+	 * HW can go idle. So we get here once again with empty FIFO and disable
+	 * the interrupt and RPM in __stop_tx()
+	 */
+	if (uart_circ_empty(xmit) && !(up->capabilities & UART_CAP_RPM))
 		__stop_tx(up);
 }
 EXPORT_SYMBOL_GPL(serial8250_tx_chars);
@@ -1535,9 +1602,17 @@ EXPORT_SYMBOL_GPL(serial8250_handle_irq);
 
 static int serial8250_default_handle_irq(struct uart_port *port)
 {
-	unsigned int iir = serial_port_in(port, UART_IIR);
+	struct uart_8250_port *up = up_to_u8250p(port);
+	unsigned int iir;
+	int ret;
 
-	return serial8250_handle_irq(port, iir);
+	serial8250_rpm_get(up);
+
+	iir = serial_port_in(port, UART_IIR);
+	ret = serial8250_handle_irq(port, iir);
+
+	serial8250_rpm_put(up);
+	return ret;
 }
 
 /*
@@ -1794,11 +1869,15 @@ static unsigned int serial8250_tx_empty(struct uart_port *port)
 	unsigned long flags;
 	unsigned int lsr;
 
+	serial8250_rpm_get(up);
+
 	spin_lock_irqsave(&port->lock, flags);
 	lsr = serial_port_in(port, UART_LSR);
 	up->lsr_saved_flags |= lsr & LSR_SAVE_FLAGS;
 	spin_unlock_irqrestore(&port->lock, flags);
 
+	serial8250_rpm_put(up);
+
 	return (lsr & BOTH_EMPTY) == BOTH_EMPTY ? TIOCSER_TEMT : 0;
 }
 
@@ -1808,7 +1887,9 @@ static unsigned int serial8250_get_mctrl(struct uart_port *port)
 	unsigned int status;
 	unsigned int ret;
 
+	serial8250_rpm_get(up);
 	status = serial8250_modem_status(up);
+	serial8250_rpm_put(up);
 
 	ret = 0;
 	if (status & UART_MSR_DCD)
@@ -1840,7 +1921,9 @@ static void serial8250_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 	mcr = (mcr & up->mcr_mask) | up->mcr_force | up->mcr;
 
+	serial8250_rpm_get(up);
 	serial_port_out(port, UART_MCR, mcr);
+	serial8250_rpm_put(up);
 }
 
 static void serial8250_break_ctl(struct uart_port *port, int break_state)
@@ -1848,6 +1931,7 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned long flags;
 
+	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 	if (break_state == -1)
 		up->lcr |= UART_LCR_SBC;
@@ -1855,6 +1939,7 @@ static void serial8250_break_ctl(struct uart_port *port, int break_state)
 		up->lcr &= ~UART_LCR_SBC;
 	serial_port_out(port, UART_LCR, up->lcr);
 	spin_unlock_irqrestore(&port->lock, flags);
+	serial8250_rpm_put(up);
 }
 
 /*
@@ -1899,12 +1984,22 @@ static void wait_for_xmitr(struct uart_8250_port *up, int bits)
 
 static int serial8250_get_poll_char(struct uart_port *port)
 {
-	unsigned char lsr = serial_port_in(port, UART_LSR);
+	unsigned char lsr;
+	int status;
+
+	serial8250_rpm_get(up);
 
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
+	serial8250_rpm_put(up);
+	return status;
 }
 
 
@@ -1914,6 +2009,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	unsigned int ier;
 	struct uart_8250_port *up = up_to_u8250p(port);
 
+	serial8250_rpm_get(up);
 	/*
 	 *	First save the IER then disable the interrupts
 	 */
@@ -1935,6 +2031,7 @@ static void serial8250_put_poll_char(struct uart_port *port,
 	 */
 	wait_for_xmitr(up, BOTH_EMPTY);
 	serial_port_out(port, UART_IER, ier);
+	serial8250_rpm_put(up);
 }
 
 #endif /* CONFIG_CONSOLE_POLL */
@@ -1960,6 +2057,7 @@ int serial8250_do_startup(struct uart_port *port)
 	if (port->iotype != up->cur_iotype)
 		set_io_from_upio(port);
 
+	serial8250_rpm_get(up);
 	if (port->type == PORT_16C950) {
 		/* Wake up and initialize UART */
 		up->acr = 0;
@@ -1980,7 +2078,6 @@ int serial8250_do_startup(struct uart_port *port)
 	 */
 	enable_rsa(up);
 #endif
-
 	/*
 	 * Clear the FIFO buffers and disable them.
 	 * (they will be reenabled in set_termios())
@@ -2004,7 +2101,8 @@ int serial8250_do_startup(struct uart_port *port)
 	    (serial_port_in(port, UART_LSR) == 0xff)) {
 		printk_ratelimited(KERN_INFO "ttyS%d: LSR safety check engaged!\n",
 				   serial_index(port));
-		return -ENODEV;
+		retval = -ENODEV;
+		goto out;
 	}
 
 	/*
@@ -2089,7 +2187,7 @@ int serial8250_do_startup(struct uart_port *port)
 	} else {
 		retval = serial_link_irq_chain(up);
 		if (retval)
-			return retval;
+			goto out;
 	}
 
 	/*
@@ -2187,8 +2285,10 @@ int serial8250_do_startup(struct uart_port *port)
 		outb_p(0x80, icp);
 		inb_p(icp);
 	}
-
-	return 0;
+	retval = 0;
+out:
+	serial8250_rpm_put(up);
+	return retval;
 }
 EXPORT_SYMBOL_GPL(serial8250_do_startup);
 
@@ -2205,6 +2305,7 @@ void serial8250_do_shutdown(struct uart_port *port)
 	struct uart_8250_port *up = up_to_u8250p(port);
 	unsigned long flags;
 
+	serial8250_rpm_get(up);
 	/*
 	 * Disable interrupts from this port
 	 */
@@ -2244,6 +2345,7 @@ void serial8250_do_shutdown(struct uart_port *port)
 	 * the IRQ chain.
 	 */
 	serial_port_in(port, UART_RX);
+	serial8250_rpm_put(up);
 
 	del_timer_sync(&up->timer);
 	up->timer.function = serial8250_timeout;
@@ -2361,6 +2463,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Ok, we're now changing the port state.  Do it with
 	 * interrupts disabled.
 	 */
+	serial8250_rpm_get(up);
 	spin_lock_irqsave(&port->lock, flags);
 
 	/*
@@ -2482,6 +2585,8 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	}
 	serial8250_set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
+	serial8250_rpm_put(up);
+
 	/* Don't rewrite B0 */
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
@@ -3055,6 +3160,8 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 
 	touch_nmi_watchdog();
 
+	serial8250_rpm_get(up);
+
 	if (port->sysrq || oops_in_progress)
 		locked = spin_trylock_irqsave(&port->lock, flags);
 	else
@@ -3091,6 +3198,7 @@ serial8250_console_write(struct console *co, const char *s, unsigned int count)
 
 	if (locked)
 		spin_unlock_irqrestore(&port->lock, flags);
+	serial8250_rpm_put(up);
 }
 
 static int __init serial8250_console_setup(struct console *co, char *options)
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index c3aa004..b161eee 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -84,6 +84,7 @@ struct uart_8250_port {
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
 	unsigned char		cur_iotype;	/* Running I/O type */
+	unsigned char		rpm_tx_active;
 
 	/*
 	 * Some bits in registers are cleared on a read, so they must
-- 
2.0.1

