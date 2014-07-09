Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbaGIRvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:51:17 -0400
Received: from www.linutronix.de ([62.245.132.108]:43735 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbaGIRuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:50:14 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/6] tty: serial: 8250-core: add rs485 support
Date: Wed,  9 Jul 2014 19:49:36 +0200
Message-Id: <1404928177-26554-6-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
References: <1404928177-26554-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after I stuffed the rs485 support from the omap-serial into
8250-omap, I've been looking at it and the only omap specific part was
the OMAP_UART_SCR_TX_EMPTY part. The driver has always TX_EMPTY set
because the 8250 core expects an interrupt after the TX fifo + shift
register is empty. The rs485 parts seems to wait for half fifo and then
again for the empty fifo. With this change gone it fits fine as generic
code and here it is.

It is expected that the potential rs485 user invokes
serial_omap_probe_rs485() to configure atleast RTS gpio which is a must
have property. The code has been taken from omap-serial driver and
received limited tested due to -ENODEV (the compiler said it works).

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c | 171 ++++++++++++++++++++++++++++++++++++
 include/linux/serial_8250.h         |   6 ++
 2 files changed, 177 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index c7c3bf7..bf06a4c 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -39,6 +39,8 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
 #ifdef CONFIG_SPARC
 #include <linux/sunserialcore.h>
 #endif
@@ -1281,10 +1283,34 @@ static void autoconfig_irq(struct uart_8250_port *up)
 
 static inline void __stop_tx(struct uart_8250_port *p)
 {
+	if (p->rs485.flags & SER_RS485_ENABLED) {
+		int ret;
+
+		ret = (p->rs485.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0;
+		if (gpio_get_value(p->rts_gpio) != ret) {
+			if (p->rs485.delay_rts_after_send > 0)
+				mdelay(p->rs485.delay_rts_after_send);
+			gpio_set_value(p->rts_gpio, ret);
+		}
+	}
+
 	if (p->ier & UART_IER_THRI) {
 		p->ier &= ~UART_IER_THRI;
 		serial_out(p, UART_IER, p->ier);
 	}
+
+	if ((p->rs485.flags & SER_RS485_ENABLED) &&
+			!(p->rs485.flags & SER_RS485_RX_DURING_TX)) {
+		/*
+		 * Empty the RX FIFO, we are not interested in anything
+		 * received during the half-duplex transmission.
+		 */
+		serial_out(p, UART_FCR, p->fcr | UART_FCR_CLEAR_RCVR);
+		/* Re-enable RX interrupts */
+		p->ier |= UART_IER_RLSI | UART_IER_RDI;
+		p->port.read_status_mask |= UART_LSR_DR;
+		serial_out(p, UART_IER, p->ier);
+	}
 }
 
 static void serial8250_stop_tx(struct uart_port *port)
@@ -1330,6 +1356,20 @@ static void serial8250_start_tx(struct uart_port *port)
 	if (up->dma && !serial8250_tx_dma(up)) {
 		goto out;
 	} else if (!(up->ier & UART_IER_THRI)) {
+
+		if (up->rs485.flags & SER_RS485_ENABLED) {
+			int ret;
+
+			ret = (up->rs485.flags & SER_RS485_RTS_ON_SEND) ? 1 : 0;
+			if (gpio_get_value(up->rts_gpio) != ret) {
+				gpio_set_value(up->rts_gpio, ret);
+				if (up->rs485.delay_rts_before_send > 0)
+					mdelay(up->rs485.delay_rts_before_send);
+			}
+			if (!(up->rs485.flags & SER_RS485_RX_DURING_TX))
+				serial8250_stop_rx(port);
+		}
+
 		up->ier |= UART_IER_THRI;
 		serial_port_out(port, UART_IER, up->ier);
 
@@ -2556,6 +2596,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 			serial_port_out(port, UART_FCR, UART_FCR_ENABLE_FIFO);
 		serial_port_out(port, UART_FCR, fcr);		/* set fcr */
 	}
+	up->fcr = fcr;
 	serial8250_set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
 	pm_runtime_mark_last_busy(port->dev);
@@ -2811,6 +2852,124 @@ serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return 0;
 }
 
+int serial8250_probe_rs485(struct uart_8250_port *up,
+		struct device *dev)
+{
+	struct serial_rs485 *rs485conf = &up->rs485;
+	struct device_node *np = dev->of_node;
+	u32 rs485_delay[2];
+	enum of_gpio_flags flags;
+	int ret;
+
+	rs485conf->flags = 0;
+	if (!np)
+		return 0;
+
+	/* check for tx enable gpio */
+	up->rts_gpio = of_get_named_gpio_flags(np, "rts-gpio", 0, &flags);
+	if (up->rts_gpio == -EPROBE_DEFER)
+		return -EPROBE_DEFER;
+	if (!gpio_is_valid(up->rts_gpio))
+		return 0;
+
+	ret = devm_gpio_request(dev, up->rts_gpio, "serial_rts");
+	if (ret < 0)
+		return ret;
+	ret = gpio_direction_output(up->rts_gpio,
+			flags & SER_RS485_RTS_AFTER_SEND);
+	if (ret < 0)
+		return ret;
+
+	up->rts_gpio_valid = true;
+
+	if (of_property_read_bool(np, "rs485-rts-active-high"))
+		rs485conf->flags |= SER_RS485_RTS_ON_SEND;
+	else
+		rs485conf->flags |= SER_RS485_RTS_AFTER_SEND;
+
+	if (of_property_read_u32_array(np, "rs485-rts-delay",
+				rs485_delay, 2) == 0) {
+		rs485conf->delay_rts_before_send = rs485_delay[0];
+		rs485conf->delay_rts_after_send = rs485_delay[1];
+	}
+
+	if (of_property_read_bool(np, "rs485-rx-during-tx"))
+		rs485conf->flags |= SER_RS485_RX_DURING_TX;
+
+	if (of_property_read_bool(np, "linux,rs485-enabled-at-boot-time"))
+		rs485conf->flags |= SER_RS485_ENABLED;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(serial8250_probe_rs485);
+
+static void serial8250_config_rs485(struct uart_port *port,
+		struct serial_rs485 *rs485conf)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	unsigned long flags;
+	unsigned int mode;
+	int val;
+
+	pm_runtime_get_sync(port->dev);
+	spin_lock_irqsave(&up->port.lock, flags);
+
+	/* Disable interrupts from this port */
+	mode = up->ier;
+	up->ier = 0;
+	serial_out(up, UART_IER, 0);
+
+	/* store new config */
+	up->rs485 = *rs485conf;
+
+	/* enable / disable rts */
+	val = (up->rs485.flags & SER_RS485_ENABLED) ?
+		SER_RS485_RTS_AFTER_SEND : SER_RS485_RTS_ON_SEND;
+	val = (up->rs485.flags & val) ? 1 : 0;
+	gpio_set_value(up->rts_gpio, val);
+
+	/* Enable interrupts */
+	up->ier = mode;
+	serial_out(up, UART_IER, up->ier);
+
+	spin_unlock_irqrestore(&up->port.lock, flags);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
+static int serial8250_ioctl(struct uart_port *port, unsigned int cmd,
+		unsigned long arg)
+{
+	struct serial_rs485 rs485conf;
+	struct uart_8250_port *up;
+
+	up = container_of(port, struct uart_8250_port, port);
+	switch (cmd) {
+	case TIOCSRS485:
+		if (!gpio_is_valid(up->rts_gpio))
+			return -ENODEV;
+		if (copy_from_user(&rs485conf, (void __user *) arg,
+					sizeof(rs485conf)))
+			return -EFAULT;
+
+		serial8250_config_rs485(port, &rs485conf);
+		break;
+
+	case TIOCGRS485:
+		if (!gpio_is_valid(up->rts_gpio))
+			return -ENODEV;
+		if (copy_to_user((void __user *) arg, &up->rs485,
+					sizeof(rs485conf)))
+			return -EFAULT;
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+	return 0;
+}
+
 static const char *
 serial8250_type(struct uart_port *port)
 {
@@ -2840,6 +2999,7 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+	.ioctl		= serial8250_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
@@ -3375,6 +3535,17 @@ int serial8250_register_8250_port(struct uart_8250_port *up)
 		uart->tx_loadsz		= up->tx_loadsz;
 		uart->capabilities	= up->capabilities;
 
+		/*
+		 * gpio_is_valid() is nice but if this struct wasn't initialized
+		 * then it is 0 which is considered as valid. With the ioctl()
+		 * which can enable the rs485 routine we could abuse a gpio.
+		 */
+		if (up->rts_gpio_valid) {
+			uart->rs485		= up->rs485;
+			uart->rts_gpio		= up->rts_gpio;
+		} else
+			uart->rts_gpio = -EINVAL;
+
 		/* Take tx_loadsz from fifosize if it wasn't set separately */
 		if (uart->port.fifosize && !uart->tx_loadsz)
 			uart->tx_loadsz = uart->port.fifosize;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 0ec21ec..056a73f 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -78,6 +78,7 @@ struct uart_8250_port {
 	unsigned char		acr;
 	unsigned char		ier;
 	unsigned char		lcr;
+	unsigned char		fcr;
 	unsigned char		mcr;
 	unsigned char		mcr_mask;	/* mask of user bits */
 	unsigned char		mcr_force;	/* mask of forced bits */
@@ -94,6 +95,9 @@ struct uart_8250_port {
 	unsigned char		msr_saved_flags;
 
 	struct uart_8250_dma	*dma;
+	struct serial_rs485	rs485;
+	int			rts_gpio;
+	bool			rts_gpio_valid;
 
 	/* 8250 specific callbacks */
 	int			(*dl_read)(struct uart_8250_port *);
@@ -107,6 +111,8 @@ void serial8250_resume_port(int line);
 
 extern int early_serial_setup(struct uart_port *port);
 
+extern int serial8250_probe_rs485(struct uart_8250_port *up,
+		struct device *dev);
 extern int serial8250_find_port(struct uart_port *p);
 extern int serial8250_find_port_for_earlycon(void);
 extern unsigned int serial8250_early_in(struct uart_port *port, int offset);
-- 
2.0.1

