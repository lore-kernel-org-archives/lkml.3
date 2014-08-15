Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaHORn0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:43:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:57695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbaHORnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:43:22 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, tony@atomide.com, balbi@ti.com,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 05/15] tty: serial: Add 8250-core based omap driver
Date: Fri, 15 Aug 2014 19:42:33 +0200
Message-Id: <1408124563-31541-6-git-send-email-bigeasy@linutronix.de>
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

This patch provides a 8250-core based UART driver for the internal OMAP
UART. The long term goal is to provide the same functionality as the
current OMAP uart driver and DMA support.
I tried to merge omap-serial code together with the 8250-core code.
There should should be hardly a noticable difference. The trigger levels
are different compared to omap-serial:
- omap serial
  TX: Interrupt comes after TX FIFO has room for 16 bytes.
      TX of 4096 bytes in one go results in 256 interrupts

  RX: Interrupt comes after there is on byte in the FIFO.
      RX of 4096 bytes results in 4096 interrupts.

- this driver
  TX: Interrupt comes once the TX FIFO is empty.
      TX of 4096 bytes results in 65 interrupts. That means there will
      be gaps on the line while the driver reloads the FIFO.

  RX: Interrupt comes once there are 48 bytes in the FIFO or less over
      "longer" time frame. We have
          1 / 11520 * 10^3 * 16 => 1.38… ms
      1.38ms to react and purge the FIFO on 115200,8N1. Since the other
      driver fired after each byte it had ~5.47ms time to react. This
      _may_ cause problems if one relies on no missing bytes and has no
      flow control. On the other hand we get only 85 interrupts for the
      same amount of data.

It has been only tested as console UART on am335x-evm, dra7-evm and
beagle bone. I also did some longer raw-transfers to meassure the load.

The device name is ttyS based instead of ttyO. If a ttyO based node name
is required please ask udev for it. If both driver are activated (this
and omap-serial) then this serial driver will take control over the
device due to the link order

v4…v7:
	- change trigger levels after some tests with raw transfers.
v3…v4:
	- drop RS485 support
	- wire up ->throttle / ->unthrottle
v2…v3:
	- wire up startup & shutdown for wakeup-irq handling.
	- RS485 handling (well the core does).

v1…v2:
	- added runtime PM. Could somebody could please double check
	  this?
	- added omap_8250_set_termios()

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c |   8 +
 drivers/tty/serial/8250/8250_omap.c | 911 ++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig     |   9 +
 drivers/tty/serial/8250/Makefile    |   1 +
 include/uapi/linux/serial_core.h    |   3 +-
 5 files changed, 931 insertions(+), 1 deletion(-)
 create mode 100644 drivers/tty/serial/8250/8250_omap.c

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index cc90c19..ab003b6 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -264,6 +264,12 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
 	},
+	[PORT_OMAP_16750] = {
+		.name		= "OMAP",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+	},
 	[PORT_TEGRA] = {
 		.name		= "Tegra",
 		.fifo_size	= 32,
@@ -1390,6 +1396,8 @@ static void serial8250_stop_rx(struct uart_port *port)
 	serial8250_rpm_get(up);
 
 	up->ier &= ~UART_IER_RLSI;
+	if (port->type == PORT_OMAP_16750)
+		up->ier &= ~UART_IER_RDI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
 	serial_port_out(port, UART_IER, up->ier);
 
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
new file mode 100644
index 0000000..368e9d8
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -0,0 +1,911 @@
+/*
+ * 8250-core based driver for the OMAP internal UART
+ *
+ *  Copyright (C) 2014 Sebastian Andrzej Siewior
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/serial_8250.h>
+#include <linux/serial_core.h>
+#include <linux/serial_reg.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/of_irq.h>
+#include <linux/delay.h>
+#include <linux/pm_runtime.h>
+#include <linux/console.h>
+#include <linux/pm_qos.h>
+
+#include "8250.h"
+
+#define UART_DLL_EM 9
+#define UART_DLM_EM 10
+
+#define DEFAULT_CLK_SPEED	48000000 /* 48 Mhz*/
+
+#define UART_ERRATA_i202_MDR1_ACCESS	(1 << 0)
+#define OMAP_UART_WER_HAS_TX_WAKEUP	(1 << 1)
+
+/* SCR register bitmasks */
+#define OMAP_UART_SCR_RX_TRIG_GRANU1_MASK	(1 << 7)
+#define OMAP_UART_SCR_TX_TRIG_GRANU1_MASK	(1 << 6)
+#define OMAP_UART_SCR_TX_EMPTY			(1 << 3)
+
+/* MVR register bitmasks */
+#define OMAP_UART_MVR_SCHEME_SHIFT	30
+#define OMAP_UART_LEGACY_MVR_MAJ_MASK	0xf0
+#define OMAP_UART_LEGACY_MVR_MAJ_SHIFT	4
+#define OMAP_UART_LEGACY_MVR_MIN_MASK	0x0f
+#define OMAP_UART_MVR_MAJ_MASK		0x700
+#define OMAP_UART_MVR_MAJ_SHIFT		8
+#define OMAP_UART_MVR_MIN_MASK		0x3f
+
+/* Enable XON/XOFF flow control on output */
+#define OMAP_UART_SW_TX		0x08
+/* Enable XON/XOFF flow control on input */
+#define OMAP_UART_SW_RX		0x02
+
+#define OMAP_UART_WER_MOD_WKUP	0x7f
+#define OMAP_UART_TX_WAKEUP_EN	(1 << 7)
+
+#define TX_TRIGGER	1
+#define RX_TRIGGER	48
+
+#define OMAP_UART_TCR_RESTORE(x)	((x / 4) << 4)
+#define OMAP_UART_TCR_HALT(x)		((x / 4) << 0)
+
+#define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
+
+#define OMAP_UART_REV_46 0x0406
+#define OMAP_UART_REV_52 0x0502
+#define OMAP_UART_REV_63 0x0603
+
+struct omap8250_priv {
+	int line;
+	u32 habit;
+	u32 fcr;
+	u32 mdr1;
+	u32 efr;
+	u32 quot;
+	u32 scr;
+	u32 wer;
+
+	bool is_suspending;
+	int wakeirq;
+	int wakeups_enabled;
+	u32 latency;
+	u32 calc_latency;
+	struct pm_qos_request pm_qos_request;
+	struct work_struct qos_work;
+};
+
+static u32 uart_read(struct uart_8250_port *up, u32 reg)
+{
+	return readl(up->port.membase + (reg << up->port.regshift));
+}
+
+/*
+ * Work Around for Errata i202 (2430, 3430, 3630, 4430 and 4460)
+ * The access to uart register after MDR1 Access
+ * causes UART to corrupt data.
+ *
+ * Need a delay =
+ * 5 L4 clock cycles + 5 UART functional clock cycle (@48MHz = ~0.2uS)
+ * give 10 times as much
+ */
+static void omap_8250_mdr1_errataset(struct uart_8250_port *up, u8 mdr1)
+{
+	struct omap8250_priv *priv = up->port.private_data;
+	u8 timeout = 255;
+
+	serial_out(up, UART_OMAP_MDR1, mdr1);
+	udelay(2);
+	serial_out(up, UART_FCR, priv->fcr | UART_FCR_CLEAR_XMIT |
+			UART_FCR_CLEAR_RCVR);
+	/*
+	 * Wait for FIFO to empty: when empty, RX_FIFO_E bit is 0 and
+	 * TX_FIFO_E bit is 1.
+	 */
+	while (UART_LSR_THRE != (serial_in(up, UART_LSR) &
+				(UART_LSR_THRE | UART_LSR_DR))) {
+		timeout--;
+		if (!timeout) {
+			/* Should *never* happen. we warn and carry on */
+			dev_crit(up->port.dev, "Errata i202: timedout %x\n",
+						serial_in(up, UART_LSR));
+			break;
+		}
+		udelay(1);
+	}
+}
+
+static void omap_8250_get_divisor(struct uart_port *port, unsigned int baud,
+		struct omap8250_priv *priv)
+{
+	unsigned int uartclk = port->uartclk;
+	unsigned int div_13, div_16;
+	unsigned int abs_d13, abs_d16;
+
+	/*
+	 * Old custom speed handling.
+	 */
+	if (baud == 38400 && (port->flags & UPF_SPD_MASK) == UPF_SPD_CUST) {
+		priv->quot = port->custom_divisor & 0xffff;
+		/*
+		 * I assume that nobody is using this. But hey, if somebody
+		 * would like to specify the divisor _and_ the mode then the
+		 * driver is ready and waiting for it.
+		 */
+		if (port->custom_divisor & (1 << 16))
+			priv->mdr1 = UART_OMAP_MDR1_13X_MODE;
+		else
+			priv->mdr1 = UART_OMAP_MDR1_16X_MODE;
+		return;
+	}
+	div_13 = DIV_ROUND_CLOSEST(uartclk, 13 * baud);
+	div_16 = DIV_ROUND_CLOSEST(uartclk, 16 * baud);
+
+	abs_d13 = abs(baud - port->uartclk / 13 / div_13);
+	abs_d16 = abs(baud - port->uartclk / 16 / div_16);
+
+	if (abs_d13 >= abs_d16) {
+		priv->mdr1 = UART_OMAP_MDR1_16X_MODE;
+		priv->quot = div_16;
+	} else {
+		priv->mdr1 = UART_OMAP_MDR1_13X_MODE;
+		priv->quot = div_13;
+	}
+}
+
+/*
+ * OMAP can use "CLK / (16 or 13) / div" for baud rate. And then we have have
+ * some differences in how we want to handle flow control.
+ */
+static void omap_8250_set_termios(struct uart_port *port,
+		struct ktermios *termios, struct ktermios *old)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	struct omap8250_priv *priv = up->port.private_data;
+	unsigned char cval = 0;
+	unsigned long flags = 0;
+	unsigned int baud;
+
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		cval = UART_LCR_WLEN5;
+		break;
+	case CS6:
+		cval = UART_LCR_WLEN6;
+		break;
+	case CS7:
+		cval = UART_LCR_WLEN7;
+		break;
+	default:
+	case CS8:
+		cval = UART_LCR_WLEN8;
+		break;
+	}
+
+	if (termios->c_cflag & CSTOPB)
+		cval |= UART_LCR_STOP;
+	if (termios->c_cflag & PARENB)
+		cval |= UART_LCR_PARITY;
+	if (!(termios->c_cflag & PARODD))
+		cval |= UART_LCR_EPAR;
+	if (termios->c_cflag & CMSPAR)
+		cval |= UART_LCR_SPAR;
+
+	/*
+	 * Ask the core to calculate the divisor for us.
+	 */
+	baud = uart_get_baud_rate(port, termios, old,
+			port->uartclk / 16 / 0xffff,
+			port->uartclk / 13);
+	omap_8250_get_divisor(port, baud, priv);
+
+	/*
+	 * Ok, we're now changing the port state. Do it with
+	 * interrupts disabled.
+	 */
+	pm_runtime_get_sync(port->dev);
+	spin_lock_irqsave(&port->lock, flags);
+
+	/*
+	 * Update the per-port timeout.
+	 */
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	up->port.read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
+	if (termios->c_iflag & INPCK)
+		up->port.read_status_mask |= UART_LSR_FE | UART_LSR_PE;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		up->port.read_status_mask |= UART_LSR_BI;
+
+	/*
+	 * Characters to ignore
+	 */
+	up->port.ignore_status_mask = 0;
+	if (termios->c_iflag & IGNPAR)
+		up->port.ignore_status_mask |= UART_LSR_PE | UART_LSR_FE;
+	if (termios->c_iflag & IGNBRK) {
+		up->port.ignore_status_mask |= UART_LSR_BI;
+		/*
+		 * If we're ignoring parity and break indicators,
+		 * ignore overruns too (for real raw support).
+		 */
+		if (termios->c_iflag & IGNPAR)
+			up->port.ignore_status_mask |= UART_LSR_OE;
+	}
+
+	/*
+	 * ignore all characters if CREAD is not set
+	 */
+	if ((termios->c_cflag & CREAD) == 0)
+		up->port.ignore_status_mask |= UART_LSR_DR;
+
+	/*
+	 * Modem status interrupts
+	 */
+	up->ier &= ~UART_IER_MSI;
+	if (UART_ENABLE_MS(&up->port, termios->c_cflag))
+		up->ier |= UART_IER_MSI;
+	serial_out(up, UART_IER, up->ier);
+
+	serial_out(up, UART_LCR, cval);         /* reset DLAB */
+	up->lcr = cval;
+
+	/* Up to here it was mostly serial8250_do_set_termios() */
+
+	/* FCR can be changed only when the
+	 * baud clock is not running
+	 * DLL_REG and DLH_REG set to 0.
+	 */
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
+	serial_out(up, UART_DLL, 0);
+	serial_out(up, UART_DLM, 0);
+	serial_out(up, UART_LCR, 0);
+
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	serial_out(up, UART_EFR, UART_EFR_ECB);
+
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
+	serial_out(up, UART_MCR, up->mcr | UART_MCR_TCRTLR);
+
+	serial_out(up, UART_TI752_TCR,
+			OMAP_UART_TCR_RESTORE(16) | OMAP_UART_TCR_HALT(52));
+
+	priv->scr = OMAP_UART_SCR_RX_TRIG_GRANU1_MASK | OMAP_UART_SCR_TX_EMPTY |
+		OMAP_UART_SCR_TX_TRIG_GRANU1_MASK;
+
+	serial_out(up, UART_TI752_TLR,
+			TRIGGER_TLR_MASK(TX_TRIGGER) << UART_TI752_TLR_TX |
+			TRIGGER_TLR_MASK(RX_TRIGGER) << UART_TI752_TLR_RX);
+	/*
+	 * We enable TRIG_GRANU for RX and TX and additionaly we set
+	 * SCR_TX_EMPTY bit. The result is the following:
+	 * - RX_TRIGGER amount of bytes in the FIFO will cause an interrupt.
+	 * - less than RX_TRIGGER number of bytes will also cause an interrupt
+	 *   once the UART decides that there no new bytes arriving.
+	 * - Once THRE is enabled, the interrupt will be fired once the FIFO is
+	 *   empty - the trigger level is ignored here.
+	 */
+	priv->fcr = UART_FCR_ENABLE_FIFO;
+	priv->fcr |= TRIGGER_FCR_MASK(TX_TRIGGER) << OMAP_UART_FCR_TX_TRIG;
+	priv->fcr |= TRIGGER_FCR_MASK(RX_TRIGGER) << OMAP_UART_FCR_RX_TRIG;
+
+	serial_out(up, UART_FCR, priv->fcr);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+
+	serial_out(up, UART_OMAP_SCR, priv->scr);
+
+	/* Reset UART_MCR_TCRTLR: this must be done with the EFR_ECB bit set */
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
+	serial_out(up, UART_MCR, up->mcr);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	serial_out(up, UART_EFR, 0);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
+
+	/* Protocol, Baud Rate, and Interrupt Settings */
+
+	if (priv->habit & UART_ERRATA_i202_MDR1_ACCESS)
+		omap_8250_mdr1_errataset(up, UART_OMAP_MDR1_DISABLE);
+	else
+		serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
+
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	serial_out(up, UART_EFR, UART_EFR_ECB);
+
+	serial_out(up, UART_LCR, 0);
+	serial_out(up, UART_IER, 0);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+
+	serial_dl_write(up, priv->quot);
+
+	serial_out(up, UART_LCR, 0);
+	serial_out(up, UART_IER, up->ier);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+
+	serial_out(up, UART_EFR, 0);
+	serial_out(up, UART_LCR, up->lcr);
+
+	if (priv->habit & UART_ERRATA_i202_MDR1_ACCESS)
+		omap_8250_mdr1_errataset(up, priv->mdr1);
+	else
+		serial_out(up, UART_OMAP_MDR1, priv->mdr1);
+
+	/* Configure flow control */
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+
+	/* XON1/XOFF1 accessible mode B, TCRTLR=0, ECB=0 */
+	serial_out(up, UART_XON1, termios->c_cc[VSTART]);
+	serial_out(up, UART_XOFF1, termios->c_cc[VSTOP]);
+
+	priv->efr = 0;
+	if (termios->c_cflag & CRTSCTS && up->port.flags & UPF_HARD_FLOW) {
+		/* Enable AUTORTS and AUTOCTS */
+		priv->efr |= UART_EFR_CTS | UART_EFR_RTS;
+
+		/* Ensure MCR RTS is asserted */
+		up->mcr |= UART_MCR_RTS;
+	}
+
+	if (up->port.flags & UPF_SOFT_FLOW) {
+		/*
+		 * IXON Flag:
+		 * Enable XON/XOFF flow control on input.
+		 * Receiver compares XON1, XOFF1.
+		 */
+		if (termios->c_iflag & IXON)
+			priv->efr |= OMAP_UART_SW_RX;
+
+		/*
+		 * IXOFF Flag:
+		 * Enable XON/XOFF flow control on output.
+		 * Transmit XON1, XOFF1
+		 */
+		if (termios->c_iflag & IXOFF)
+			priv->efr |= OMAP_UART_SW_TX;
+
+		/*
+		 * IXANY Flag:
+		 * Enable any character to restart output.
+		 * Operation resumes after receiving any
+		 * character after recognition of the XOFF character
+		 */
+		if (termios->c_iflag & IXANY)
+			up->mcr |= UART_MCR_XONANY;
+		else
+			up->mcr &= ~UART_MCR_XONANY;
+	}
+	serial_out(up, UART_MCR, up->mcr);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	serial_out(up, UART_EFR, priv->efr);
+	serial_out(up, UART_LCR, up->lcr);
+
+	port->ops->set_mctrl(port, port->mctrl);
+
+	spin_unlock_irqrestore(&up->port.lock, flags);
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+
+	/* calculate wakeup latency constraint */
+	priv->calc_latency = (USEC_PER_SEC * up->port.fifosize) / (baud / 8);
+	priv->latency = priv->calc_latency;
+	schedule_work(&priv->qos_work);
+
+	/* Don't rewrite B0 */
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
+}
+
+/* same as 8250 except that we may have extra flow bits set in EFR */
+static void omap_8250_pm(struct uart_port *port, unsigned int state,
+		unsigned int oldstate)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	struct omap8250_priv *priv = up->port.private_data;
+
+	pm_runtime_get_sync(port->dev);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	serial_out(up, UART_EFR, priv->efr | UART_EFR_ECB);
+	serial_out(up, UART_LCR, 0);
+
+	serial_out(up, UART_IER, (state != 0) ? UART_IERX_SLEEP : 0);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
+	serial_out(up, UART_EFR, priv->efr);
+	serial_out(up, UART_LCR, 0);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
+static void omap_serial_fill_features_erratas(struct uart_8250_port *up,
+		struct omap8250_priv *priv)
+{
+	u32 mvr, scheme;
+	u16 revision, major, minor;
+
+	mvr = uart_read(up, UART_OMAP_MVER);
+
+	/* Check revision register scheme */
+	scheme = mvr >> OMAP_UART_MVR_SCHEME_SHIFT;
+
+	switch (scheme) {
+	case 0: /* Legacy Scheme: OMAP2/3 */
+		/* MINOR_REV[0:4], MAJOR_REV[4:7] */
+		major = (mvr & OMAP_UART_LEGACY_MVR_MAJ_MASK) >>
+			OMAP_UART_LEGACY_MVR_MAJ_SHIFT;
+		minor = (mvr & OMAP_UART_LEGACY_MVR_MIN_MASK);
+		break;
+	case 1:
+		/* New Scheme: OMAP4+ */
+		/* MINOR_REV[0:5], MAJOR_REV[8:10] */
+		major = (mvr & OMAP_UART_MVR_MAJ_MASK) >>
+			OMAP_UART_MVR_MAJ_SHIFT;
+		minor = (mvr & OMAP_UART_MVR_MIN_MASK);
+		break;
+	default:
+		dev_warn(up->port.dev,
+				"Unknown revision, defaulting to highest\n");
+		/* highest possible revision */
+		major = 0xff;
+		minor = 0xff;
+	}
+	/* normalize revision for the driver */
+	revision = UART_BUILD_REVISION(major, minor);
+
+	switch (revision) {
+	case OMAP_UART_REV_46:
+		priv->habit = UART_ERRATA_i202_MDR1_ACCESS;
+		break;
+	case OMAP_UART_REV_52:
+		priv->habit = UART_ERRATA_i202_MDR1_ACCESS |
+				OMAP_UART_WER_HAS_TX_WAKEUP;
+		break;
+	case OMAP_UART_REV_63:
+		priv->habit = UART_ERRATA_i202_MDR1_ACCESS |
+			OMAP_UART_WER_HAS_TX_WAKEUP;
+		break;
+	default:
+		break;
+	}
+}
+
+static void omap8250_uart_qos_work(struct work_struct *work)
+{
+	struct omap8250_priv *priv;
+
+	priv = container_of(work, struct omap8250_priv, qos_work);
+	pm_qos_update_request(&priv->pm_qos_request, priv->latency);
+}
+
+static irqreturn_t omap_wake_irq(int irq, void *dev_id)
+{
+	struct uart_port *port = dev_id;
+	int ret;
+
+	ret = port->handle_irq(port);
+	if (ret)
+		return IRQ_HANDLED;
+	return IRQ_NONE;
+}
+
+static int omap_8250_startup(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	struct omap8250_priv *priv = port->private_data;
+
+	int ret;
+
+	if (priv->wakeirq) {
+		ret = request_irq(priv->wakeirq, omap_wake_irq,
+				port->irqflags, "wakeup irq", port);
+		if (ret)
+			return ret;
+		disable_irq(priv->wakeirq);
+	}
+
+	ret = serial8250_do_startup(port);
+	if (ret)
+		goto err;
+
+	pm_runtime_get_sync(port->dev);
+
+	/* Enable module level wake up */
+	priv->wer = OMAP_UART_WER_MOD_WKUP;
+	if (priv->habit & OMAP_UART_WER_HAS_TX_WAKEUP)
+		priv->wer |= OMAP_UART_TX_WAKEUP_EN;
+	serial_out(up, UART_OMAP_WER, priv->wer);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+	return 0;
+err:
+	if (priv->wakeirq)
+		free_irq(priv->wakeirq, port);
+	return ret;
+}
+
+static void omap_8250_shutdown(struct uart_port *port)
+{
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+	struct omap8250_priv *priv = port->private_data;
+
+	pm_runtime_get_sync(port->dev);
+
+	serial_out(up, UART_OMAP_WER, 0);
+	serial8250_do_shutdown(port);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+
+	if (priv->wakeirq)
+		free_irq(priv->wakeirq, port);
+}
+
+static void omap_8250_throttle(struct uart_port *port)
+{
+	unsigned long flags;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	pm_runtime_get_sync(port->dev);
+
+	spin_lock_irqsave(&port->lock, flags);
+	up->ier &= ~(UART_IER_RLSI | UART_IER_RDI);
+	serial_out(up, UART_IER, up->ier);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
+static void omap_8250_unthrottle(struct uart_port *port)
+{
+	unsigned long flags;
+	struct uart_8250_port *up =
+		container_of(port, struct uart_8250_port, port);
+
+	pm_runtime_get_sync(port->dev);
+
+	spin_lock_irqsave(&port->lock, flags);
+	up->ier |= UART_IER_RLSI | UART_IER_RDI;
+	serial_out(up, UART_IER, up->ier);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	pm_runtime_mark_last_busy(port->dev);
+	pm_runtime_put_autosuspend(port->dev);
+}
+
+static int omap8250_probe(struct platform_device *pdev)
+{
+	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	struct omap8250_priv *priv;
+	struct uart_8250_port up;
+	int ret;
+	void __iomem *membase;
+
+	if (!regs || !irq) {
+		dev_err(&pdev->dev, "missing registers or irq\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "unable to allocate private data\n");
+		return -ENOMEM;
+	}
+	membase = devm_ioremap_nocache(&pdev->dev, regs->start,
+			resource_size(regs));
+	if (!membase)
+		return -ENODEV;
+
+	memset(&up, 0, sizeof(up));
+	up.port.dev = &pdev->dev;
+	up.port.mapbase = regs->start;
+	up.port.membase = membase;
+	up.port.irq = irq->start;
+	/*
+	 * It claims to be 16C750 compatible however it is a little different.
+	 * It has EFR and has no FCR7_64byte bit. The AFE which it claims to
+	 * have is enabled via EFR instead of MCR.
+	 */
+	up.port.type = PORT_OMAP_16750;
+	up.port.iotype = UPIO_MEM32;
+	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_FIXED_TYPE |
+		UPF_SOFT_FLOW | UPF_HARD_FLOW;
+	up.port.private_data = priv;
+
+	up.port.regshift = 2;
+	up.port.fifosize = 64;
+
+	up.port.set_termios = omap_8250_set_termios;
+	up.port.pm = omap_8250_pm;
+	up.port.startup = omap_8250_startup;
+	up.port.shutdown = omap_8250_shutdown;
+	up.port.throttle = omap_8250_throttle;
+	up.port.unthrottle = omap_8250_unthrottle;
+
+	if (pdev->dev.of_node) {
+		up.port.line = of_alias_get_id(pdev->dev.of_node, "serial");
+		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
+				&up.port.uartclk);
+		priv->wakeirq = irq_of_parse_and_map(pdev->dev.of_node, 1);
+	} else {
+		up.port.line = pdev->id;
+	}
+
+	if (up.port.line < 0) {
+		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n",
+				up.port.line);
+		return -ENODEV;
+	}
+	if (!up.port.uartclk) {
+		up.port.uartclk = DEFAULT_CLK_SPEED;
+		dev_warn(&pdev->dev,
+				"No clock speed specified: using default: %d\n",
+				DEFAULT_CLK_SPEED);
+	}
+
+#ifdef CONFIG_PM_RUNTIME
+	up.capabilities |= UART_CAP_RPM;
+#endif
+
+	priv->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
+	priv->calc_latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
+	pm_qos_add_request(&priv->pm_qos_request,
+			PM_QOS_CPU_DMA_LATENCY, priv->latency);
+	INIT_WORK(&priv->qos_work, omap8250_uart_qos_work);
+
+	device_init_wakeup(&pdev->dev, true);
+	pm_runtime_use_autosuspend(&pdev->dev);
+	pm_runtime_set_autosuspend_delay(&pdev->dev, -1);
+
+	pm_runtime_irq_safe(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
+	pm_runtime_get_sync(&pdev->dev);
+
+	omap_serial_fill_features_erratas(&up, priv);
+
+	ret = serial8250_register_8250_port(&up);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to register 8250 port\n");
+		goto err;
+	}
+	priv->line = ret;
+	platform_set_drvdata(pdev, priv);
+	pm_runtime_mark_last_busy(&pdev->dev);
+	pm_runtime_put_autosuspend(&pdev->dev);
+	return 0;
+err:
+	pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	return ret;
+}
+
+static int omap8250_remove(struct platform_device *pdev)
+{
+	struct omap8250_priv *priv = platform_get_drvdata(pdev);
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	serial8250_unregister_port(priv->line);
+	pm_qos_remove_request(&priv->pm_qos_request);
+	device_init_wakeup(&pdev->dev, false);
+	return 0;
+}
+
+#if defined(CONFIG_PM_SLEEP) || defined(CONFIG_PM_RUNTIME)
+
+static inline void omap8250_enable_wakeirq(struct omap8250_priv *priv,
+		bool enable)
+{
+	if (!priv->wakeirq)
+		return;
+
+	if (enable)
+		enable_irq(priv->wakeirq);
+	else
+		disable_irq_nosync(priv->wakeirq);
+}
+
+static void omap8250_enable_wakeup(struct omap8250_priv *priv,
+		bool enable)
+{
+	if (enable == priv->wakeups_enabled)
+		return;
+
+	omap8250_enable_wakeirq(priv, enable);
+	priv->wakeups_enabled = enable;
+}
+#endif
+
+#ifdef CONFIG_PM_SLEEP
+static int omap8250_prepare(struct device *dev)
+{
+	struct omap8250_priv *priv = dev_get_drvdata(dev);
+
+	if (!priv)
+		return 0;
+	priv->is_suspending = true;
+	return 0;
+}
+
+static void omap8250_complete(struct device *dev)
+{
+	struct omap8250_priv *priv = dev_get_drvdata(dev);
+
+	if (!priv)
+		return;
+	priv->is_suspending = false;
+}
+
+static int omap8250_suspend(struct device *dev)
+{
+	struct omap8250_priv *priv = dev_get_drvdata(dev);
+
+	serial8250_suspend_port(priv->line);
+	flush_work(&priv->qos_work);
+
+	if (device_may_wakeup(dev))
+		omap8250_enable_wakeup(priv, true);
+	else
+		omap8250_enable_wakeup(priv, false);
+	return 0;
+}
+
+static int omap8250_resume(struct device *dev)
+{
+	struct omap8250_priv *priv = dev_get_drvdata(dev);
+
+	if (device_may_wakeup(dev))
+		omap8250_enable_wakeup(priv, false);
+
+	serial8250_resume_port(priv->line);
+	return 0;
+}
+#else
+#define omap8250_prepare NULL
+#define omap8250_complete NULL
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+static int omap8250_lost_context(struct omap8250_priv *priv)
+{
+	struct uart_8250_port *up;
+	u32 val;
+
+	up = serial8250_get_port(priv->line);
+	val = serial_in(up, UART_OMAP_MDR1);
+	/*
+	 * If we lose context, then MDR1 is set to its reset value which is
+	 * UART_OMAP_MDR1_DISABLE. After set_termios() we set it either to 13x
+	 * or 16x but never to disable again.
+	 */
+	if (val == UART_OMAP_MDR1_DISABLE)
+		return 1;
+	return 0;
+}
+
+static int omap8250_runtime_suspend(struct device *dev)
+{
+	struct omap8250_priv *priv = dev_get_drvdata(dev);
+
+	/*
+	 * When using 'no_console_suspend', the console UART must not be
+	 * suspended. Since driver suspend is managed by runtime suspend,
+	 * preventing runtime suspend (by returning error) will keep device
+	 * active during suspend.
+	 */
+	if (priv->is_suspending && !console_suspend_enabled) {
+		struct uart_8250_port *up;
+
+		up = serial8250_get_port(priv->line);
+		if (uart_console(&up->port))
+			return -EBUSY;
+	}
+
+	omap8250_enable_wakeup(priv, true);
+
+	priv->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
+	schedule_work(&priv->qos_work);
+	return 0;
+}
+
+static void omap8250_restore_context(struct omap8250_priv *priv)
+{
+	struct uart_8250_port *up;
+
+	up = serial8250_get_port(priv->line);
+
+	if (priv->habit & UART_ERRATA_i202_MDR1_ACCESS)
+		omap_8250_mdr1_errataset(up, UART_OMAP_MDR1_DISABLE);
+	else
+		serial_out(up, UART_OMAP_MDR1, UART_OMAP_MDR1_DISABLE);
+
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B); /* Config B mode */
+	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, UART_LCR, 0x0); /* Operational mode */
+	serial_out(up, UART_IER, 0x0);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B); /* Config B mode */
+
+	serial_dl_write(up, priv->quot);
+
+	serial_out(up, UART_LCR, 0x0); /* Operational mode */
+	serial_out(up, UART_IER, up->ier);
+	serial_out(up, UART_FCR, priv->fcr);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_A);
+	serial_out(up, UART_MCR, up->mcr);
+	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B); /* Config B mode */
+	serial_out(up, UART_OMAP_SCR, priv->scr);
+	serial_out(up, UART_EFR, priv->efr);
+	serial_out(up, UART_LCR, up->lcr);
+	if (priv->habit & UART_ERRATA_i202_MDR1_ACCESS)
+		omap_8250_mdr1_errataset(up, priv->mdr1);
+	else
+		serial_out(up, UART_OMAP_MDR1, priv->mdr1);
+	serial_out(up, UART_OMAP_WER, priv->wer);
+}
+
+static int omap8250_runtime_resume(struct device *dev)
+{
+	struct omap8250_priv *priv = dev_get_drvdata(dev);
+	int loss_cntx;
+
+	/* In case runtime-pm tries this before we are setup */
+	if (!priv)
+		return 0;
+	omap8250_enable_wakeup(priv, false);
+	loss_cntx = omap8250_lost_context(priv);
+
+	if (loss_cntx)
+		omap8250_restore_context(priv);
+
+	priv->latency = priv->calc_latency;
+	schedule_work(&priv->qos_work);
+	return 0;
+}
+#endif
+
+static const struct dev_pm_ops omap8250_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(omap8250_suspend, omap8250_resume)
+	SET_RUNTIME_PM_OPS(omap8250_runtime_suspend,
+			omap8250_runtime_resume, NULL)
+	.prepare        = omap8250_prepare,
+	.complete       = omap8250_complete,
+};
+
+static const struct of_device_id omap8250_dt_ids[] = {
+	{ .compatible = "ti,omap2-uart" },
+	{ .compatible = "ti,omap3-uart" },
+	{ .compatible = "ti,omap4-uart" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap8250_dt_ids);
+
+static struct platform_driver omap8250_platform_driver = {
+	.driver = {
+		.name		= "omap8250",
+		.pm		= &omap8250_dev_pm_ops,
+		.of_match_table = omap8250_dt_ids,
+		.owner		= THIS_MODULE,
+	},
+	.probe			= omap8250_probe,
+	.remove			= omap8250_remove,
+};
+module_platform_driver(omap8250_platform_driver);
+
+MODULE_AUTHOR("Sebastian Andrzej Siewior");
+MODULE_DESCRIPTION("OMAP 8250 Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 349ee59..7a5073b 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -298,3 +298,12 @@ config SERIAL_8250_RT288X
 	  If you have a Ralink RT288x/RT305x SoC based board and want to use the
 	  serial port, say Y to this option. The driver can handle up to 2 serial
 	  ports. If unsure, say N.
+
+config SERIAL_8250_OMAP
+	tristate "Support for OMAP internal UART (8250 based driver)"
+	depends on SERIAL_8250 && ARCH_OMAP2PLUS
+	help
+	  If you have a machine based on an Texas Instruments OMAP CPU you
+	  can enable its onboard serial ports by enabling this option.
+
+	  This driver is in early stage and uses ttyS instead of ttyO.
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 36d68d0..4bac392 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
+obj-$(CONFIG_SERIAL_8250_OMAP)		+= 8250_omap.o
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index 5820269..74f9b11 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -54,7 +54,8 @@
 #define PORT_ALTR_16550_F32 26	/* Altera 16550 UART with 32 FIFOs */
 #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
 #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
-#define PORT_MAX_8250	28	/* max port ID */
+#define PORT_OMAP_16750	29	/* TI's OMAP internal 16C750 compatible UART */
+#define PORT_MAX_8250	29	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
2.0.1

