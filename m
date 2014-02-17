Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaBQEs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 23:48:29 -0500
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:46478 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaBQEs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 23:48:28 -0500
X-AuditID: 85900ec0-d3b2cb9000001514-d4-5301948cfd30
Subject: [PATCH V2] serial/uart: Add tunable RX interrupt trigger I/F of
 FIFO buffers
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com
Date: Mon, 17 Feb 2014 13:48:12 +0900
Message-ID: <20140217044812.4868.28106.stgit@yunodevel>
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
unsigned char rx_trig_byte = 1;
fd = open(TTY_PASS, O_RDWR | O_NONBLOCK);
ioctl(fd, TIOCSFIFOTRIG, rx_trig_byte);
read(fd, buf, size);

<Support uart device>
- 16550A (1, 4, 8, or 14 bytes)

Changed in V2:
 - Use _IOW for TIOCSFIFORTRIG definition
 - Pass the interrupt trigger value itself

Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_core.c |   58 +++++++++++++++++++++++++++++++++++
 include/uapi/asm-generic/ioctls.h   |    1 +
 2 files changed, 59 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 61ecd70..429f3a6 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -2699,6 +2699,63 @@ serial8250_verify_port(struct uart_port *port, struct serial_struct *ser)
 	return 0;
 }
 
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
+static int set_fifo_rx_trigger(struct uart_8250_port *up, unsigned char val)
+{
+	unsigned char fcr;
+	int rx_trig;
+
+	rx_trig = convert_val2rxtrig(up, val);
+	if (rx_trig < 0)
+		return rx_trig;
+
+	fcr = uart_config[up->port.type].fcr;
+	serial8250_clear_fifos(up);
+	fcr &= ~UART_FCR_TRIGGER_MASK;
+	fcr |= (unsigned char)rx_trig;
+	serial_out(up, UART_FCR, fcr);
+	return 0;
+}
+
+static int
+serial8250_ioctl(struct uart_port *port, unsigned int cmd, unsigned long arg)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	int ret;
+
+	if (!(up->capabilities & UART_CAP_FIFO) || port->fifosize <= 1)
+		return -EINVAL;
+
+	switch (cmd) {
+	case TIOCSFIFORTRIG:
+		ret = set_fifo_rx_trigger(up, (unsigned char)arg);
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+	}
+	return ret;
+}
+
 static const char *
 serial8250_type(struct uart_port *port)
 {
@@ -2728,6 +2785,7 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+	.ioctl		= serial8250_ioctl,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char = serial8250_get_poll_char,
 	.poll_put_char = serial8250_put_poll_char,
diff --git a/include/uapi/asm-generic/ioctls.h b/include/uapi/asm-generic/ioctls.h
index 143dacb..9504dca 100644
--- a/include/uapi/asm-generic/ioctls.h
+++ b/include/uapi/asm-generic/ioctls.h
@@ -77,6 +77,7 @@
 #define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
 #define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
 #define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
+#define TIOCSFIFORTRIG	_IOW('T', 0x41, unsigned char) /* Set RX int. trigger */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451

