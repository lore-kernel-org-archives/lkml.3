Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaCNCWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 22:22:01 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55391 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211AbaCNCV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 22:21:59 -0400
X-AuditID: 85900ec0-d1328b9000001514-dc-532267c325b1
Subject: [PATCH V3] serial/uart/8250: Add tunable RX interrupt trigger I/F
 of FIFO buffers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan <gnomes@lxorguk.ukuu.org.uk>
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Date: Fri, 14 Mar 2014 11:21:54 +0900
Message-ID: <20140314022154.4345.23024.stgit@yunodevel>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

This patch makes a 16550A device change RX interrupt trigger from userland.

<How to use>
- Read current setting
 # cat /sys/dev/char/4\:64/rx_int_trig
 8

- Write user setting
 # echo 1 > /sys/dev/char/4\:64/rx_int_trig
 # cat /sys/dev/char/4\:64/rx_int_trig
 1

<Support uart device>
- 16550A (1, 4, 8, or 14 bytes)

Changed in V2:
 - Use _IOW for TIOCSFIFORTRIG definition
 - Pass the interrupt trigger value itself

Changes in V3:
 - Change I/F from ioctl(2) to sysfs(rx_int_trig)

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
 drivers/tty/serial/8250/8250_core.c |  189 ++++++++++++++++++++++++++++++++++-
 drivers/tty/serial/serial_core.c    |   18 ++-
 include/linux/serial_8250.h         |    1 
 include/linux/serial_core.h         |    4 +
 4 files changed, 198 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 69932b7..c945ceb 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -531,11 +531,9 @@ static void serial8250_clear_fifos(struct uart_8250_port *p)
 
 void serial8250_clear_and_reinit_fifos(struct uart_8250_port *p)
 {
-	unsigned char fcr;
-
 	serial8250_clear_fifos(p);
-	fcr = uart_config[p->port.type].fcr;
-	serial_out(p, UART_FCR, fcr);
+	p->fcr = uart_config[p->port.type].fcr;
+	serial_out(p, UART_FCR, p->fcr);
 }
 EXPORT_SYMBOL_GPL(serial8250_clear_and_reinit_fifos);
 
@@ -2325,10 +2323,19 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 		if ((baud < 2400 && !up->dma) || fifo_bug) {
 			fcr &= ~UART_FCR_TRIGGER_MASK;
 			fcr |= UART_FCR_TRIGGER_1;
+			/* Don't use user setting RX trigger */
+			up->fcr = 0;
 		}
 	}
 
 	/*
+	 * If up->fcr exists, a user has opened this port, changed RX trigger,
+	 * or read RX trigger before. So, we don't need to change up->fcr here.
+	 */
+	if (!up->fcr)
+		up->fcr = fcr;
+
+	/*
 	 * MCR-based auto flow control.  When AFE is enabled, RTS will be
 	 * deasserted when the receive FIFO contains more characters than
 	 * the trigger, or the MCR RTS bit is cleared.  In the case where
@@ -2455,15 +2462,15 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
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
@@ -2656,6 +2663,172 @@ static int serial8250_request_port(struct uart_port *port)
 	return ret;
 }
 
+static unsigned char convert_fcr2val(struct uart_8250_port *up,
+				     unsigned char fcr)
+{
+	unsigned char val = 0, trig_raw = fcr & UART_FCR_TRIGGER_MASK;
+
+	switch (up->port.type) {
+	case PORT_16550A:
+		if (trig_raw == UART_FCR_R_TRIG_00)
+			val = 1;
+		else if (trig_raw == UART_FCR_R_TRIG_01)
+			val = 4;
+		else if (trig_raw == UART_FCR_R_TRIG_10)
+			val = 8;
+		else if (trig_raw == UART_FCR_R_TRIG_11)
+			val = 14;
+		break;
+	}
+	return val;
+}
+
+static int convert_val2rxtrig(struct uart_8250_port *up, unsigned char val)
+{
+	switch (up->port.type) {
+	case PORT_16550A:
+		if (val == 1)
+			return UART_FCR_R_TRIG_00;
+		else if (val == 4)
+			return UART_FCR_R_TRIG_01;
+		else if (val == 8)
+			return UART_FCR_R_TRIG_10;
+		else if (val == 14)
+			return UART_FCR_R_TRIG_11;
+		break;
+	default:
+		pr_info("Not support RX-trigger setting for this serial %u\n",
+			up->port.type);
+	}
+	return -EINVAL;
+}
+
+static unsigned char do_get_rx_int_trig(struct tty_port *port)
+{
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+	struct uart_8250_port *up =
+		container_of(uport, struct uart_8250_port, port);
+
+	if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1)
+		return 0;
+
+	if (!up->fcr)
+		/* termios is not set yet */
+		up->fcr = uart_config[up->port.type].fcr;
+
+	return convert_fcr2val(up, up->fcr);
+}
+
+static unsigned char do_serial8250_get_rx_int_trig(struct tty_port *port)
+{
+	unsigned char rx_trig_byte;
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
+	unsigned char rx_trig_byte;
+
+	rx_trig_byte = do_serial8250_get_rx_int_trig(port);
+	/* rx_trig_byte == 0 means RX interrupt trigger is undefined */
+	if (!rx_trig_byte)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%u\n", rx_trig_byte);
+}
+
+static int do_set_rx_int_trig(struct tty_port *port, unsigned char val)
+{
+	struct uart_state *state = container_of(port, struct uart_state, port);
+	struct uart_port *uport = state->uart_port;
+	struct uart_8250_port *up =
+		container_of(uport, struct uart_8250_port, port);
+	unsigned char fcr;
+	int rx_trig;
+
+	if (!(up->capabilities & UART_CAP_FIFO) || uport->fifosize <= 1)
+		return -EINVAL;
+
+	rx_trig = convert_val2rxtrig(up, val);
+	if (rx_trig < 0)
+		return rx_trig;
+
+	serial8250_clear_fifos(up);
+	if (!up->fcr)
+		/* termios is not set yet */
+		fcr = uart_config[up->port.type].fcr;
+	else
+		fcr = up->fcr;
+	fcr &= ~UART_FCR_TRIGGER_MASK;
+	fcr |= (unsigned char)rx_trig;
+	up->fcr = fcr;
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
+		up->port.dev_spec_attr_group = &serial8250_dev_attr_group;
+		break;
+	}
+}
+
 static void serial8250_config_port(struct uart_port *port, int flags)
 {
 	struct uart_8250_port *up =
@@ -2704,6 +2877,8 @@ static void serial8250_config_port(struct uart_port *port, int flags)
 	if ((port->type == PORT_XR17V35X) ||
 	   (port->type == PORT_XR17D15X))
 		port->handle_irq = exar_handle_irq;
+
+	register_dev_spec_attr_grp(up);
 }
 
 static int
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ece2049..5cfa732 100644
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
 	 * setserial to be used to alter this ports parameters.
 	 */
 	tty_dev = tty_port_register_device_attr(port, drv->tty_driver,
-			uport->line, uport->dev, port, tty_dev_attr_groups);
+			uport->line, uport->dev, port,
+			(const struct attribute_group **)uport->attr_grps);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index af47a8a..2ce1152 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -76,6 +76,7 @@ struct uart_8250_port {
 	unsigned short		bugs;		/* port bugs */
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

