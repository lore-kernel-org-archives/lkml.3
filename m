Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaDOIHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 04:07:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40603 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbaDOIGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 04:06:54 -0400
X-AuditID: 85900ec0-d452db9000001514-1a-534ce89a24f7
Subject: [PATCH V5.1] serial/uart/8250: Add tunable RX interrupt trigger I/F
 of FIFO buffers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Date: Tue, 15 Apr 2014 17:06:49 +0900
Message-ID: <20140415080649.19209.60645.stgit@yunodevel>
In-Reply-To: <20140415055216.14660.18270.stgit@yunodevel>
References: <20140415055216.14660.18270.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/* I found a bug in V5, so I resend this as V5.1. Please do not review V5. */

Add tunable RX interrupt trigger I/F of FIFO buffers.
Serial devices are used as not only message communication devices but control
or sending communication devices. For the latter uses, normally small data
will be exchanged, so user applications want to receive data unit as soon as
possible for real-time tendency. If we have a sensor which sends a 1 byte data
each time and must control a device based on the sensor feedback, the RX
interrupt should be triggered for each data.

According to HW specification of serial UART devices, RX interrupt trigger
can be changed, but the trigger is hard-coded. For example, RX interrupt trigger
in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current driver sets
the trigger to only 8bytes.

This patch makes some devices change RX interrupt trigger from userland.

<How to use>
- Read current setting
 # cat /sys/dev/char/4\:64/rx_int_trig
 8

- Write user setting
 # echo 1 > /sys/dev/char/4\:64/rx_int_trig
 # cat /sys/dev/char/4\:64/rx_int_trig
 1

<Support uart devices>
- 16550A and Tegra (1, 4, 8, or 14 bytes)
- 16650V2 (8, 16, 24, or 28 bytes)
- 16654 (8, 16, 56, or 60 bytes)
- 16750 (1, 16, 32, or 56 bytes)

Changed in V2:
 - Use _IOW for TIOCSFIFORTRIG definition
 - Pass the interrupt trigger value itself

Changes in V3:
 - Change I/F from ioctl(2) to sysfs(rx_int_trig)

Changes in V4:
 - Introduce fifo_bug flag in uart_8250_port structure
   This is enabled only when parity is enabled and UART_BUG_PARITY is enabled
   for up->bugs. If this flag is enabled, user cannot set RX trigger.
 - Return -EOPNOTSUPP when it does not support device at convert_fcr2val() and
   at convert_val2rxtrig()
 - Set the nearest lower RX trigger when users input a meaningless value at
   convert_val2rxtrig()
 - Check whether p->fcr is existing at serial8250_clear_and_reinit_fifos()
 - Set fcr = up->fcr in the begging of serial8250_do_set_termios()

Changes in V5:
 - Support Tegra, 16650V2, 16654, and 16750
 - Store default FCR value to up->fcr when the port is first created
 - Add rx_trig_byte[] in uart_config[] for each device and use rx_trig_byte[]
   in convert_fcr2val() and convert_val2rxtrig()

Changes in V5.1:
 - Fix FCR_RX_TRIG_MAX_STATE definition

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Aaron Sierra <asierra@xes-inc.com>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/tty/serial/8250/8250.h      |    6 +
 drivers/tty/serial/8250/8250_core.c |  184 ++++++++++++++++++++++++++++++++---
 drivers/tty/serial/serial_core.c    |   18 ++-
 include/linux/serial_8250.h         |    2 
 include/linux/serial_core.h         |    4 +
 5 files changed, 192 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index 1ebf853..0025694 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -12,6 +12,7 @@
  */
 
 #include <linux/serial_8250.h>
+#include <linux/serial_reg.h>
 #include <linux/dmaengine.h>
 
 struct uart_8250_dma {
@@ -55,11 +56,16 @@ struct old_serial_port {
 	unsigned long irqflags;
 };
 
+#define FCR_RX_TRIG_OFFSET	6
+#define FCR_RX_TRIG_BITS(x)	(((x) >> FCR_RX_TRIG_OFFSET) & 0x3)
+#define FCR_RX_TRIG_MAX_STATE	4
+
 struct serial8250_config {
 	const char	*name;
 	unsigned short	fifo_size;
 	unsigned short	tx_loadsz;
 	unsigned char	fcr;
+	unsigned char	rx_trig_byte[FCR_RX_TRIG_MAX_STATE];
 	unsigned int	flags;
 };
 
diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 81f909c..9987845 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -31,7 +31,6 @@
 #include <linux/tty.h>
 #include <linux/ratelimit.h>
 #include <linux/tty_flip.h>
-#include <linux/serial_reg.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
 #include <linux/serial_8250.h>
@@ -161,6 +160,7 @@ static const struct serial8250_config uart_config[] = {
 		.fifo_size	= 16,
 		.tx_loadsz	= 16,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.rx_trig_byte	= {1, 4, 8, 14},
 		.flags		= UART_CAP_FIFO,
 	},
 	[PORT_CIRRUS] = {
@@ -180,6 +180,7 @@ static const struct serial8250_config uart_config[] = {
 		.tx_loadsz	= 16,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01 |
 				  UART_FCR_T_TRIG_00,
+		.rx_trig_byte	= {8, 16, 24, 28},
 		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
 	},
 	[PORT_16750] = {
@@ -188,6 +189,7 @@ static const struct serial8250_config uart_config[] = {
 		.tx_loadsz	= 64,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10 |
 				  UART_FCR7_64BYTE,
+		.rx_trig_byte	= {1, 16, 32, 56},
 		.flags		= UART_CAP_FIFO | UART_CAP_SLEEP | UART_CAP_AFE,
 	},
 	[PORT_STARTECH] = {
@@ -209,6 +211,7 @@ static const struct serial8250_config uart_config[] = {
 		.tx_loadsz	= 32,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01 |
 				  UART_FCR_T_TRIG_10,
+		.rx_trig_byte	= {8, 16, 56, 60},
 		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
 	},
 	[PORT_16850] = {
@@ -266,6 +269,7 @@ static const struct serial8250_config uart_config[] = {
 		.tx_loadsz	= 8,
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01 |
 				  UART_FCR_T_TRIG_01,
+		.rx_trig_byte	= {1, 4, 8, 14},
 		.flags		= UART_CAP_FIFO | UART_CAP_RTOIE,
 	},
 	[PORT_XR17D15X] = {
@@ -531,11 +535,8 @@ static void serial8250_clear_fifos(struct uart_8250_port *p)
 
 void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
 {
-	unsigned char fcr;
-
 	serial8250_clear_fifos(p);
-	fcr = uart_config[p->port.type].fcr;
-	serial_out(p, UART_FCR, fcr);
+	serial_out(p, UART_FCR, p->fcr);
 }
 EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
 
@@ -2275,10 +2276,9 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 {
 	struct uart_8250_port *up =
 		container_of(port, struct uart_8250_port, port);
-	unsigned char cval, fcr = 0;
+	unsigned char cval;
 	unsigned long flags;
 	unsigned int baud, quot;
-	int fifo_bug = 0;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
@@ -2301,7 +2301,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	if (termios->c_cflag & PARENB) {
 		cval |= UART_LCR_PARITY;
 		if (up->bugs & UART_BUG_PARITY)
-			fifo_bug = 1;
+			up->fifo_bug = true;
 	}
 	if (!(termios->c_cflag & PARODD))
 		cval |= UART_LCR_EPAR;
@@ -2325,10 +2325,11 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 		quot++;
 
 	if (up->capabilities & UART_CAP_FIFO && port->fifosize > 1) {
-		fcr = uart_config[port->type].fcr;
-		if ((baud < 2400 && !up->dma) || fifo_bug) {
-			fcr &= ~UART_FCR_TRIGGER_MASK;
-			fcr |= UART_FCR_TRIGGER_1;
+		/* NOTE: If fifo_bug is not set, a uaser can set RX_trigger. */
+		if ((baud < 2400 && !up->dma &&
+		    (up->fcr == uart_config[port->type].fcr)) || up->fifo_bug) {
+			up->fcr &= ~UART_FCR_TRIGGER_MASK;
+			up->fcr |= UART_FCR_TRIGGER_1;
 		}
 	}
 
@@ -2459,15 +2460,15 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * is written without DLAB set, this mode will be disabled.
 	 */
 	if (port->type == PORT_16750)
-		serial_port_out(port, UART_FCR, fcr);
+		serial_port_out(port, UART_FCR, up->fcr);
 
 	serial_port_out(port, UART_LCR, cval);		/* reset DLAB */
 	up->lcr = cval;					/* Save LCR */
 	if (port->type != PORT_16750) {
 		/* emulated UARTs (Lucent Venus 167x) need two steps */
-		if (fcr & UART_FCR_ENABLE_FIFO)
+		if (up->fcr & UART_FCR_ENABLE_FIFO)
 			serial_port_out(port, UART_FCR, UART_FCR_ENABLE_FIFO);
-		serial_port_out(port, UART_FCR, fcr);		/* set fcr */
+		serial_port_out(port, UART_FCR, up->fcr);	/* set fcr */
 	}
 	serial8250_set_mctrl(port, port->mctrl);
 	spin_unlock_irqrestore(&port->lock, flags);
@@ -2660,6 +2661,156 @@ static int serial8250_request_port(struct uart_port *port)
 	return ret;
 }
 
+static int convert_fcr2val(struct uart_8250_port *up)
+{
+	const struct serial8250_config *conf_type = &uart_config[up->port.type];
+	unsigned char rx_trig_raw = up->fcr & UART_FCR_TRIGGER_MASK;
+	unsigned char val;
+
+	val = conf_type->rx_trig_byte[FCR_RX_TRIG_BITS(rx_trig_raw)];
+
+	return val ? val : -EOPNOTSUPP;
+}
+
+static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
+{
+	const struct serial8250_config *conf_type = &uart_config[up->port.type];
+	int i;
+
+	if (!conf_type->rx_trig_byte[FCR_RX_TRIG_BITS(UART_FCR_R_TRIG_00)]) {
+		pr_info("Not support RX-trigger setting for this serial %s\n",
+			conf_type->name);
+		return -EOPNOTSUPP;
+	}
+
+	for (i = 1; i < FCR_RX_TRIG_MAX_STATE; i++) {
+		if (val < conf_type->rx_trig_byte[i])
+			/* Use the nearest lower value */
+			return (--i) << FCR_RX_TRIG_OFFSET;
+	}
+
+	return UART_FCR_R_TRIG_11;
+}
+
+static int do_get_rx_int_trig(struct tty_port *port)
+{
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+	struct uart_8250_port *up =
+		container_of(uport, struct uart_8250_port, port);
+
+	if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1)
+		return -EINVAL;
+
+	return convert_fcr2val(up);
+}
+
+static int do_serial8250_get_rx_int_trig(struct tty_port *port)
+{
+	int rx_trig_byte;
+
+	mutex_lock(&port->mutex);
+	rx_trig_byte = do_get_rx_int_trig(port);
+	mutex_unlock(&port->mutex);
+
+	return rx_trig_byte;
+}
+
+static ssize_t serial8250_get_attr_rx_int_trig(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct tty_port *port = dev_get_drvdata(dev);
+	int rx_trig_byte;
+
+	rx_trig_byte = do_serial8250_get_rx_int_trig(port);
+	if (rx_trig_byte < 0)
+		return rx_trig_byte;
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", rx_trig_byte);
+}
+
+static int do_set_rx_int_trig(struct tty_port *port, unsigned char val)
+{
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+	struct uart_8250_port *up =
+		container_of(uport, struct uart_8250_port, port);
+	int rx_trig;
+
+	if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1 ||
+	    up->fifo_bug)
+		return -EINVAL;
+
+	rx_trig = convert_val2rxtrig(up, val);
+	if (rx_trig < 0)
+		return rx_trig;
+
+	serial8250_clear_fifos(up);
+	up->fcr &= ~UART_FCR_TRIGGER_MASK;
+	up->fcr |= (unsigned char)rx_trig;
+	serial_out(up, UART_FCR, up->fcr);
+	return 0;
+}
+
+static int do_serial8250_set_rx_int_trig(struct tty_port *port,
+					 unsigned char val)
+{
+	int ret;
+
+	mutex_lock(&port->mutex);
+	ret = do_set_rx_int_trig(port, val);
+	mutex_unlock(&port->mutex);
+
+	return ret;
+}
+
+static ssize_t serial8250_set_attr_rx_int_trig(struct device *dev,
+	struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct tty_port *port = dev_get_drvdata(dev);
+	unsigned char val;
+	int ret;
+
+	if (!count)
+		return -EINVAL;
+
+	ret = kstrtou8(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	ret = do_serial8250_set_rx_int_trig(port, val);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+static DEVICE_ATTR(rx_int_trig, S_IRUSR | S_IWUSR | S_IRGRP,
+		   serial8250_get_attr_rx_int_trig,
+		   serial8250_set_attr_rx_int_trig);
+
+static struct attribute *serial8250_dev_attrs[] = {
+	&dev_attr_rx_int_trig.attr,
+	NULL,
+	};
+
+static struct attribute_group serial8250_dev_attr_group = {
+	.attrs = serial8250_dev_attrs,
+	};
+
+static void register_dev_spec_attr_grp(struct uart_8250_port *up)
+{
+	switch (up->port.type) {
+	case PORT_16550A:
+	case PORT_16650V2:
+	case PORT_16654:
+	case PORT_16750:
+	case PORT_TEGRA:
+		up->port.dev_spec_attr_group = &serial8250_dev_attr_group;
+		break;
+	}
+}
+
 static void serial8250_config_port(struct uart_port *port, int flags)
 {
 	struct uart_8250_port *up =
@@ -2708,6 +2859,9 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if ((port->type == PORT_XR17V35X) ||
 	   (port->type == PORT_XR17D15X))
 		port->handle_irq = exar_handle_irq;
+
+	register_dev_spec_attr_grp(up);
+	up->fcr = uart_config[up->port.type].fcr;
 }
 
 static int
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 2cf5649..41ac44b 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2548,15 +2548,16 @@ static struct attribute *tty_dev_attrs[] = {
 	NULL,
 	};
 
-static const struct attribute_group tty_dev_attr_group = {
+static struct attribute_group tty_dev_attr_group = {
 	.attrs = tty_dev_attrs,
 	};
 
-static const struct attribute_group *tty_dev_attr_groups[] = {
-	&tty_dev_attr_group,
-	NULL
-	};
-
+static void make_uport_attr_grps(struct uart_port *uport)
+{
+	uport->attr_grps[0] = &tty_dev_attr_group;
+	if (uport->dev_spec_attr_group)
+		uport->attr_grps[1] = uport->dev_spec_attr_group;
+}
 
 /**
  *	uart_add_one_port - attach a driver-defined port structure
@@ -2607,12 +2608,15 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 
 	uart_configure_port(drv, state, uport);
 
+	make_uport_attr_grps(uport);
+
 	/*
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this port's parameters.
 	 */
 	tty_dev = tty_port_register_device_attr(port, drv->tty_driver,
-			uport->line, uport->dev, port, tty_dev_attr_groups);
+			uport->line, uport->dev, port,
+			(const struct attribute_group **)uport->attr_grps);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index af47a8a..8d0c215 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -74,8 +74,10 @@ struct uart_8250_port {
 	struct list_head	list;		/* ports on this IRQ */
 	unsigned short		capabilities;	/* port capabilities */
 	unsigned short		bugs;		/* port bugs */
+	bool			fifo_bug;	/* min RX trigger if enabled */
 	unsigned int		tx_loadsz;	/* transmit fifo load size */
 	unsigned char		acr;
+	unsigned char		fcr;
 	unsigned char		ier;
 	unsigned char		lcr;
 	unsigned char		mcr;
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index f729be9..7e3122f 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -113,6 +113,8 @@ struct uart_icount {
 
 typedef unsigned int __bitwise__ upf_t;
 
+#define MAX_ATTR_GRPS		3
+
 struct uart_port {
 	spinlock_t		lock;			/* port lock */
 	unsigned long		iobase;			/* in/out[bwl] */
@@ -195,6 +197,8 @@ struct uart_port {
 	unsigned int		line;			/* port index */
 	resource_size_t		mapbase;		/* for ioremap */
 	struct device		*dev;			/* parent device */
+	struct attribute_group	*dev_spec_attr_group;	/* specific attribute */
+	struct attribute_group	*attr_grps[MAX_ATTR_GRPS];/* all attr. groups */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		suspended;
 	unsigned char		irq_wake;

