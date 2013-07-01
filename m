Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3GAJNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:13:19 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:37696 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab3GAJNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:13:17 -0400
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: gregkh@linuxfoundation.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, jslaby@suse.cz
Cc: devicetree-discuss@lists.ozlabs.org, linux-serial@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, mrana@codeaurora.org,
        sambley@codeaurora.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>
Subject: [PATCH] tty: serial: Add initial MSM UART High Speed Lite driver
Date: Mon,  1 Jul 2013 12:11:50 +0300
Message-Id: <1372669910-24409-1-git-send-email-iivanov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Ivan T. Ivanov" <iivanov@mm-sol.com>

This is a tty driver with console support for Qualcomm's UART
controllers found in the MSM8974 chipsets. Driver is completely
based on implementation found in codeaurora.org msm_serial_hs_lite
with Android dependences removed. Other changes include, moved to
device managed resources and few cleanups.

Driver functionality was tested in LEGACY_HSUART mode.

Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
---
 .../bindings/tty/serial/msm_serial_hsl.txt         |   52 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/msm_serial_hsl.c                | 1399 ++++++++++++++++++++
 drivers/tty/serial/msm_serial_hsl.h                |  294 ++++
 5 files changed, 1764 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/tty/serial/msm_serial_hsl.txt
 create mode 100644 drivers/tty/serial/msm_serial_hsl.c
 create mode 100644 drivers/tty/serial/msm_serial_hsl.h

diff --git a/Documentation/devicetree/bindings/tty/serial/msm_serial_hsl.txt b/Documentation/devicetree/bindings/tty/serial/msm_serial_hsl.txt
new file mode 100644
index 0000000..972552f
--- /dev/null
+++ b/Documentation/devicetree/bindings/tty/serial/msm_serial_hsl.txt
@@ -0,0 +1,52 @@
+* Qualcomm MSM HSUART Lite
+
+Required properties:
+- compatible :
+	"qcom,msm-lsuart-v14" to be used for UARTDM Core v1.4
+
+- reg :
+	offset and length of the register set for both the device,
+	UART core and GBSI core
+
+- reg-names :
+	"uart_mem" to be used as name of the UART core
+	"gbsi_mem" to be used as name of the GBSI core
+
+The registers for the "qcom,msm-lsuart-v14" device have specify
+UART core block. GSBI reg is optional if specified driver will use
+GSBI specific functionality.
+
+- interrupts : interrupts for UART core
+
+- clocks : Must contain an entry for each entry in clock-names.
+
+- clock-names : Must include the following entries:
+  "core_clk" - mandatory
+  "iface_clk" - optional
+
+For details see:
+Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Example:
+
+	serial@f991e000 {
+		compatible = "qcom,msm-lsuart-v14";
+		reg = <0xf991e000 0x1000>;
+		reg-names = "uart_mem";
+		interrupts = <0 108 0>;
+		clocks = <&blsp1_uart2_apps_cxc>, <&blsp1_ahb_cxc>;
+		clock-names = "core_clk", "iface_clk";
+	};
+
+Aliases :
+An alias may be optionally used to bind the UART device to a TTY device
+(ttyHSL<alias_num>) with a given alias number. Aliases are of the form
+uart<n> where <n> is an integer representing the alias number to use.
+On systems with multiple UART devices present, an alias may optionally be
+defined for such devices. The alias value should be from 0 to 255.
+
+Example:
+
+	aliases {
+		uart4 = &uart7; // This device will be enumerated as ttyHSL4
+	};
diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
index 7e7006f..4482bc7 100644
--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1046,6 +1046,24 @@ config SERIAL_MSM_HS
 	  Choose M here to compile it as a module. The module will be
 	  called msm_serial_hs.
 
+config SERIAL_MSM_HSL
+	tristate "MSM High speed serial lite mode driver"
+	depends on ARM && ARCH_MSM
+	select SERIAL_CORE
+	default n
+	help
+	  Select this module to enable MSM high speed lite mode driver
+	  for UART controllers found in MSM8974 SoC's
+
+	  Choose M here to compile it as a module. The module will be
+	  called msm_serial_hsl.
+
+config SERIAL_MSM_HSL_CONSOLE
+	bool "MSM High speed serial lite mode console support"
+	depends on SERIAL_MSM_HSL=y
+	select SERIAL_CORE_CONSOLE
+	default n
+
 config SERIAL_VT8500
 	bool "VIA VT8500 on-chip serial port support"
 	depends on ARCH_VT8500
diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
index eedfec4..86c023b 100644
--- a/drivers/tty/serial/Makefile
+++ b/drivers/tty/serial/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_SERIAL_ATMEL) += atmel_serial.o
 obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_MSM) += msm_serial.o
 obj-$(CONFIG_SERIAL_MSM_HS) += msm_serial_hs.o
+obj-$(CONFIG_SERIAL_MSM_HSL) += msm_serial_hsl.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM_NWPSERIAL) += nwpserial.o
diff --git a/drivers/tty/serial/msm_serial_hsl.c b/drivers/tty/serial/msm_serial_hsl.c
new file mode 100644
index 0000000..56c15a8
--- /dev/null
+++ b/drivers/tty/serial/msm_serial_hsl.c
@@ -0,0 +1,1399 @@
+/*
+ * drivers/tty/serial/msm_serial_hsl.c - driver for serial device and console
+ *
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2010-2013, The Linux Foundation. All rights reserved.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Acknowledgements:
+ * This file is based on msm_serial.c, originally
+ * Written by Robert Love <rlove@google.com>  */
+
+#include <linux/clk.h>
+#include <linux/console.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/tty_flip.h>
+
+#include "msm_serial_hsl.h"
+
+/*
+ * There are 3 different kind of UART Core available on MSM.
+ * High Speed UART (i.e. Legacy HSUART), GSBI based HSUART
+ * and BSLP based HSUART.
+ */
+enum uart_core_type {
+	LEGACY_HSUART,
+	GSBI_HSUART,
+	BLSP_HSUART,
+};
+
+/*
+ * @uart: uart port instance
+ * @name: name of the port
+ * @clk: reference to core clock
+ * @pclk: reference to interface clock
+ * @imr: shadow interrupt mask register
+ * @mapped_gsbi: GSBI contol memory
+ * @old_snap_state: How many data still left in the FIFO
+ * @tx_timeout - transmit timout ~600x the character transmit time
+ * @uart_type - see enum uart_core_type
+ * @regmap - Register map based on controller version
+ * It is mainly required where same UART is used across different processor.
+ * Make sure that Clock driver for platform support setting clock rate to zero.
+ */
+struct msm_hsl_port {
+	struct uart_port	uart;
+	char			name[16];
+	struct clk		*clk;
+	struct clk		*pclk;
+	struct dentry		*loopback_dir;
+	unsigned int		imr;
+	unsigned int		*mapped_gsbi;
+	unsigned int		old_snap_state;
+	int			tx_timeout;
+	enum uart_core_type	uart_type;
+	const unsigned int	*regmap;
+};
+
+#define UARTDM_VERSION_11_13	0
+#define UARTDM_VERSION_14	1
+#define UART_NR			3
+
+#define to_hsl_port(p)		(container_of(p, struct msm_hsl_port, uart))
+#define is_console(port)	((port)->cons && \
+				(port)->cons->index == (port)->line)
+
+static const unsigned int regmap[][UARTDM_LAST] = {
+	[UARTDM_VERSION_11_13] = {
+		[UARTDM_MR1] = UARTDM_MR1_ADDR,
+		[UARTDM_MR2] = UARTDM_MR2_ADDR,
+		[UARTDM_IMR] = UARTDM_IMR_ADDR,
+		[UARTDM_SR] = UARTDM_SR_ADDR,
+		[UARTDM_CR] = UARTDM_CR_ADDR,
+		[UARTDM_CSR] = UARTDM_CSR_ADDR,
+		[UARTDM_IPR] = UARTDM_IPR_ADDR,
+		[UARTDM_ISR] = UARTDM_ISR_ADDR,
+		[UARTDM_RX_TOTAL_SNAP] = UARTDM_RX_TOTAL_SNAP_ADDR,
+		[UARTDM_TFWR] = UARTDM_TFWR_ADDR,
+		[UARTDM_RFWR] = UARTDM_RFWR_ADDR,
+		[UARTDM_RF] = UARTDM_RF_ADDR,
+		[UARTDM_TF] = UARTDM_TF_ADDR,
+		[UARTDM_MISR] = UARTDM_MISR_ADDR,
+		[UARTDM_DMRX] = UARTDM_DMRX_ADDR,
+		[UARTDM_NCF_TX] = UARTDM_NCF_TX_ADDR,
+		[UARTDM_DMEN] = UARTDM_DMEN_ADDR,
+		[UARTDM_TXFS] = UARTDM_TXFS_ADDR,
+		[UARTDM_RXFS] = UARTDM_RXFS_ADDR,
+	},
+	[UARTDM_VERSION_14] = {
+		[UARTDM_MR1] = UARTDM_MR1_ADDR,
+		[UARTDM_MR2] = UARTDM_MR2_ADDR,
+		[UARTDM_IMR] = UARTDM_IMR_ADDR_V14,
+		[UARTDM_SR] = UARTDM_SR_ADDR_V14,
+		[UARTDM_CR] = UARTDM_CR_ADDR_V14,
+		[UARTDM_CSR] = UARTDM_CSR_ADDR_V14,
+		[UARTDM_IPR] = UARTDM_IPR_ADDR,
+		[UARTDM_ISR] = UARTDM_ISR_ADDR_V14,
+		[UARTDM_RX_TOTAL_SNAP] = UARTDM_RX_TOTAL_SNAP_ADDR_V14,
+		[UARTDM_TFWR] = UARTDM_TFWR_ADDR,
+		[UARTDM_RFWR] = UARTDM_RFWR_ADDR,
+		[UARTDM_RF] = UARTDM_RF_ADDR_V14,
+		[UARTDM_TF] = UARTDM_TF_ADDR_V14,
+		[UARTDM_MISR] = UARTDM_MISR_ADDR_V14,
+		[UARTDM_DMRX] = UARTDM_DMRX_ADDR,
+		[UARTDM_NCF_TX] = UARTDM_NCF_TX_ADDR,
+		[UARTDM_DMEN] = UARTDM_DMEN_ADDR,
+		[UARTDM_TXFS] = UARTDM_TXFS_ADDR,
+		[UARTDM_RXFS] = UARTDM_RXFS_ADDR,
+	},
+};
+
+/*
+ * get_console_state - check the per-port serial console state.
+ * @port: uart_port structure describing the port
+ *
+ * Return the state of serial console availability on port.
+ * return 1: If serial console is enabled on particular UART port.
+ * return 0: If serial console is disabled on particular UART port.
+ */
+static int get_console_state(struct uart_port *port)
+{
+#ifdef CONFIG_SERIAL_MSM_HSL_CONSOLE
+	if (is_console(port) && (port->cons->flags & CON_ENABLED))
+		return 1;
+	else
+		return 0;
+#else
+	return -ENODEV;
+#endif
+}
+
+static inline void msm_hsl_write(struct uart_port *port,
+				 unsigned int val, unsigned int off)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	iowrite32(val, port->membase + hslp->regmap[off]);
+}
+
+static inline unsigned int msm_hsl_read(struct uart_port *port,
+					unsigned int off)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	return ioread32(port->membase + hslp->regmap[off]);
+}
+
+static unsigned int msm_serial_hsl_has_gsbi(struct uart_port *port)
+{
+	return (to_hsl_port(port)->uart_type == GSBI_HSUART);
+}
+
+/*
+ * set_gsbi_uart_func_mode: Check the currently used GSBI UART mode
+ * and set the new required GSBI UART Mode if it is different.
+ * @port: uart port
+ */
+static void set_gsbi_uart_func_mode(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	unsigned int set_mode = GSBI_PROTOCOL_I2C_UART;
+	unsigned int cur_mode;
+
+	if (hslp->pclk)
+		clk_prepare_enable(hslp->pclk);
+
+	/* Read current used GSBI UART Mode and set only if it is different. */
+	cur_mode = ioread32(hslp->mapped_gsbi + GSBI_CONTROL_ADDR);
+	if ((cur_mode & GSBI_PROTOCOL_CODE_MASK) != set_mode)
+		/*
+		 * Programmed GSBI based UART protocol mode i.e. I2C/UART
+		 * Shared Mode or UART Mode.
+		 */
+		iowrite32(set_mode, hslp->mapped_gsbi + GSBI_CONTROL_ADDR);
+
+	if (hslp->pclk)
+		clk_disable_unprepare(hslp->pclk);
+}
+
+static int msm_hsl_clock_enable(struct uart_port *port, int enable)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	int ret = 0;
+
+	if (enable) {
+		ret = clk_prepare_enable(hslp->clk);
+		if (ret)
+			return ret;
+		if (hslp->pclk) {
+			ret = clk_prepare_enable(hslp->pclk);
+			if (ret)
+				clk_disable_unprepare(hslp->clk);
+		}
+	} else {
+		clk_disable_unprepare(hslp->clk);
+		if (hslp->pclk)
+			clk_disable_unprepare(hslp->pclk);
+	}
+
+	return ret;
+}
+
+static int msm_hsl_loopback_set(void *data, u64 val)
+{
+	struct msm_hsl_port *hslp = data;
+	struct uart_port *port = &(hslp->uart);
+	unsigned long flags;
+	int ret = 0;
+
+	ret = clk_set_rate(hslp->clk, port->uartclk);
+	if (!ret)
+		msm_hsl_clock_enable(port, 1);
+	else
+		return -EINVAL;
+
+	if (val) {
+		spin_lock_irqsave(&port->lock, flags);
+		ret = msm_hsl_read(port, UARTDM_MR2);
+		ret |= UARTDM_MR2_LOOP_MODE_BMSK;
+		msm_hsl_write(port, ret, UARTDM_MR2);
+		spin_unlock_irqrestore(&port->lock, flags);
+	} else {
+		spin_lock_irqsave(&port->lock, flags);
+		ret = msm_hsl_read(port, UARTDM_MR2);
+		ret &= ~UARTDM_MR2_LOOP_MODE_BMSK;
+		msm_hsl_write(port, ret, UARTDM_MR2);
+		spin_unlock_irqrestore(&port->lock, flags);
+	}
+
+	msm_hsl_clock_enable(port, 0);
+	return 0;
+}
+
+static int msm_hsl_loopback_get(void *data, u64 *val)
+{
+	struct msm_hsl_port *hslp = data;
+	struct uart_port *port = &hslp->uart;
+	unsigned long flags;
+	int ret = 0;
+
+	ret = clk_set_rate(hslp->clk, port->uartclk);
+	if (!ret)
+		msm_hsl_clock_enable(port, 1);
+	else
+		return -EINVAL;
+
+	spin_lock_irqsave(&port->lock, flags);
+	ret = msm_hsl_read(port, UARTDM_MR2);
+	spin_unlock_irqrestore(&port->lock, flags);
+	msm_hsl_clock_enable(port, 0);
+
+	*val = (ret & UARTDM_MR2_LOOP_MODE_BMSK) ? 1 : 0;
+	return 0;
+}
+
+static void msm_hsl_stop_tx(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	hslp->imr &= ~UARTDM_ISR_TXLEV_BMSK;
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+}
+
+static void msm_hsl_start_tx(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	hslp->imr |= UARTDM_ISR_TXLEV_BMSK;
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+}
+
+static void msm_hsl_stop_rx(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	hslp->imr &= ~(UARTDM_ISR_RXLEV_BMSK | UARTDM_ISR_RXSTALE_BMSK);
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+}
+
+static void msm_hsl_enable_ms(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	hslp->imr |= UARTDM_ISR_DELTA_CTS_BMSK;
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+}
+
+static void msm_hsl_handle_rx(struct uart_port *port, unsigned int misr)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	struct tty_port *tty = &port->state->port;
+	unsigned int sr;
+	int count = 0;
+
+	/*
+	 * Handle overrun. My understanding of the hardware is that overrun
+	 * is not tied to the RX buffer, so we handle the case out of band.
+	 */
+	sr = msm_hsl_read(port, UARTDM_SR);
+	if (sr & UARTDM_SR_OVERRUN_BMSK) {
+		port->icount.overrun++;
+		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+		msm_hsl_write(port, RESET_ERROR_STATUS, UARTDM_CR);
+	}
+
+	if (misr & UARTDM_ISR_RXSTALE_BMSK) {
+		count = msm_hsl_read(port, UARTDM_RX_TOTAL_SNAP) -
+				     hslp->old_snap_state;
+		hslp->old_snap_state = 0;
+	} else {
+		count = 4 * (msm_hsl_read(port, UARTDM_RFWR));
+		hslp->old_snap_state += count;
+	}
+
+	/* and now the main RX loop */
+	while (count > 0) {
+		unsigned int c;
+		char flag = TTY_NORMAL;
+
+		sr = msm_hsl_read(port, UARTDM_SR);
+		if ((sr & UARTDM_SR_RXRDY_BMSK) == 0) {
+			hslp->old_snap_state -= count;
+			break;
+		}
+		c = msm_hsl_read(port, UARTDM_RF);
+		if (sr & UARTDM_SR_RX_BREAK_BMSK) {
+			port->icount.brk++;
+			if (uart_handle_break(port))
+				continue;
+		} else if (sr & UARTDM_SR_PAR_FRAME_BMSK) {
+			port->icount.frame++;
+		} else {
+			port->icount.rx++;
+		}
+
+		/* Mask conditions we're ignorning. */
+		sr &= port->read_status_mask;
+		if (sr & UARTDM_SR_RX_BREAK_BMSK)
+			flag = TTY_BREAK;
+		else if (sr & UARTDM_SR_PAR_FRAME_BMSK)
+			flag = TTY_FRAME;
+
+		/* TODO: handle sysrq */
+		/* if (!uart_handle_sysrq_char(port, c)) */
+		tty_insert_flip_string(tty, (char *)&c,
+				       (count > 4) ? 4 : count);
+		count -= 4;
+	}
+
+	tty_flip_buffer_push(tty);
+}
+
+static void msm_hsl_dump_regs(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	unsigned int sr, isr, mr1, mr2, ncf, txfs, rxfs, con_state;
+
+	sr = msm_hsl_read(port, UARTDM_SR);
+	isr = msm_hsl_read(port, UARTDM_ISR);
+	mr1 = msm_hsl_read(port, UARTDM_MR1);
+	mr2 = msm_hsl_read(port, UARTDM_MR2);
+	ncf = msm_hsl_read(port, UARTDM_NCF_TX);
+	txfs = msm_hsl_read(port, UARTDM_TXFS);
+	rxfs = msm_hsl_read(port, UARTDM_RXFS);
+	con_state = get_console_state(port);
+
+	pr_info("Timeout: %d uS\n", hslp->tx_timeout);
+	pr_info("SR:  %08x\n", sr);
+	pr_info("ISR: %08x\n", isr);
+	pr_info("MR1: %08x\n", mr1);
+	pr_info("MR2: %08x\n", mr2);
+	pr_info("NCF: %08x\n", ncf);
+	pr_info("TXFS: %08x\n", txfs);
+	pr_info("RXFS: %08x\n", rxfs);
+	pr_info("Console state: %d\n", con_state);
+}
+
+/*
+ *  Wait for transmitter & holding register to empty
+ *  Derived from msm_hsl_wait_for_xmitr in 8250 serial driver by Russell King
+ */
+static void msm_hsl_wait_for_xmitr(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	int count = 0;
+	int sr;
+	int isr;
+
+	sr = msm_hsl_read(port, UARTDM_SR);
+	if (sr & UARTDM_SR_TXEMT_BMSK)
+		return;
+
+	do {
+		isr = msm_hsl_read(port, UARTDM_ISR);
+		sr = msm_hsl_read(port, UARTDM_SR);
+
+		if ((isr & UARTDM_ISR_TX_READY_BMSK) ||
+		    (sr & UARTDM_SR_TXEMT_BMSK))
+			break;
+
+		udelay(1);
+		touch_nmi_watchdog();
+		cpu_relax();
+
+		if (++count == hslp->tx_timeout) {
+			msm_hsl_dump_regs(port);
+			panic("MSM HSL msm_hsl_wait_for_xmitr is stuck!");
+		}
+
+	} while (true);
+
+	msm_hsl_write(port, CLEAR_TX_READY, UARTDM_CR);
+
+}
+
+static void msm_hsl_handle_tx(struct uart_port *port)
+{
+	struct circ_buf *xmit = &port->state->xmit;
+	unsigned int tf_pointer = 0;
+	int sent_tx;
+	int tx_count;
+	int x;
+	int sr;
+
+	tx_count = uart_circ_chars_pending(xmit);
+
+	if (tx_count > (UART_XMIT_SIZE - xmit->tail))
+		tx_count = UART_XMIT_SIZE - xmit->tail;
+	if (tx_count >= port->fifosize)
+		tx_count = port->fifosize;
+
+	/* Handle x_char */
+	if (port->x_char) {
+		msm_hsl_wait_for_xmitr(port);
+		msm_hsl_write(port, tx_count + 1, UARTDM_NCF_TX);
+		msm_hsl_read(port, UARTDM_NCF_TX);
+		msm_hsl_write(port, port->x_char, UARTDM_TF);
+		port->icount.tx++;
+		port->x_char = 0;
+	} else if (tx_count) {
+		msm_hsl_wait_for_xmitr(port);
+		msm_hsl_write(port, tx_count, UARTDM_NCF_TX);
+		msm_hsl_read(port, UARTDM_NCF_TX);
+	}
+	if (!tx_count) {
+		msm_hsl_stop_tx(port);
+		return;
+	}
+
+	while (tf_pointer < tx_count) {
+		sr = msm_hsl_read(port, UARTDM_SR);
+		if (!(sr & UARTDM_SR_TXRDY_BMSK))
+			continue;
+		switch (tx_count - tf_pointer) {
+		case 1:
+			x = xmit->buf[xmit->tail];
+			port->icount.tx++;
+			break;
+		case 2:
+			x = xmit->buf[xmit->tail]
+			    | xmit->buf[xmit->tail + 1] << 8;
+			port->icount.tx += 2;
+			break;
+		case 3:
+			x = xmit->buf[xmit->tail]
+			    | xmit->buf[xmit->tail + 1] << 8
+			    | xmit->buf[xmit->tail + 2] << 16;
+			port->icount.tx += 3;
+			break;
+		default:
+			x = *((int *)&(xmit->buf[xmit->tail]));
+			port->icount.tx += 4;
+			break;
+		}
+		msm_hsl_write(port, x, UARTDM_TF);
+		xmit->tail = ((tx_count - tf_pointer < 4) ?
+			      (tx_count - tf_pointer + xmit->tail) :
+			      (xmit->tail + 4)) & (UART_XMIT_SIZE - 1);
+		tf_pointer += 4;
+		sent_tx = 1;
+	}
+
+	if (uart_circ_empty(xmit))
+		msm_hsl_stop_tx(port);
+
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+		uart_write_wakeup(port);
+
+}
+
+static void msm_hsl_handle_delta_cts(struct uart_port *port)
+{
+	msm_hsl_write(port, RESET_CTS, UARTDM_CR);
+	port->icount.cts++;
+	wake_up_interruptible(&port->state->port.delta_msr_wait);
+}
+
+static irqreturn_t msm_hsl_irq(int irq, void *dev_id)
+{
+	struct uart_port *port = dev_id;
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	unsigned int misr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	misr = msm_hsl_read(port, UARTDM_MISR);
+	/* disable interrupt */
+	msm_hsl_write(port, 0, UARTDM_IMR);
+
+	if (misr & (UARTDM_ISR_RXSTALE_BMSK | UARTDM_ISR_RXLEV_BMSK)) {
+		msm_hsl_handle_rx(port, misr);
+		if (misr & (UARTDM_ISR_RXSTALE_BMSK))
+			msm_hsl_write(port, RESET_STALE_INT,
+				      UARTDM_CR);
+		msm_hsl_write(port, 6500, UARTDM_DMRX);
+		msm_hsl_write(port, STALE_EVENT_ENABLE, UARTDM_CR);
+	}
+	if (misr & UARTDM_ISR_TXLEV_BMSK)
+		msm_hsl_handle_tx(port);
+
+	if (misr & UARTDM_ISR_DELTA_CTS_BMSK)
+		msm_hsl_handle_delta_cts(port);
+
+	/* restore interrupt */
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned int msm_hsl_tx_empty(struct uart_port *port)
+{
+	unsigned int ret;
+
+	ret = msm_hsl_read(port, UARTDM_SR);
+	ret &= UARTDM_SR_TXEMT_BMSK;
+
+	if (ret)
+		ret = TIOCSER_TEMT;
+
+	return ret;
+}
+
+static void msm_hsl_reset(struct uart_port *port)
+{
+	/* reset everything */
+	msm_hsl_write(port, RESET_RX, UARTDM_CR);
+	msm_hsl_write(port, RESET_TX, UARTDM_CR);
+	msm_hsl_write(port, RESET_ERROR_STATUS, UARTDM_CR);
+	msm_hsl_write(port, RESET_BREAK_INT, UARTDM_CR);
+	msm_hsl_write(port, RESET_CTS, UARTDM_CR);
+	msm_hsl_write(port, RFR_LOW, UARTDM_CR);
+}
+
+static unsigned int msm_hsl_get_mctrl(struct uart_port *port)
+{
+	return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR | TIOCM_RTS;
+}
+
+static void msm_hsl_set_mctrl(struct uart_port *port, unsigned int mctrl)
+{
+	unsigned int mr;
+	unsigned int loop_mode;
+
+	mr = msm_hsl_read(port, UARTDM_MR1);
+
+	if (!(mctrl & TIOCM_RTS)) {
+		mr &= ~UARTDM_MR1_RX_RDY_CTL_BMSK;
+		msm_hsl_write(port, mr, UARTDM_MR1);
+		msm_hsl_write(port, RFR_HIGH, UARTDM_CR);
+	} else {
+		mr |= UARTDM_MR1_RX_RDY_CTL_BMSK;
+		msm_hsl_write(port, mr, UARTDM_MR1);
+	}
+
+	loop_mode = TIOCM_LOOP & mctrl;
+	if (loop_mode) {
+		mr = msm_hsl_read(port, UARTDM_MR2);
+		mr |= UARTDM_MR2_LOOP_MODE_BMSK;
+		msm_hsl_write(port, mr, UARTDM_MR2);
+
+		/* Reset TX */
+		msm_hsl_reset(port);
+
+		/* Turn on Uart Receiver & Transmitter */
+		msm_hsl_write(port, UARTDM_CR_RX_EN_BMSK | UARTDM_CR_TX_EN_BMSK,
+			      UARTDM_CR);
+	}
+}
+
+static void msm_hsl_break_ctl(struct uart_port *port, int break_ctl)
+{
+
+	if (break_ctl)
+		msm_hsl_write(port, START_BREAK, UARTDM_CR);
+	else
+		msm_hsl_write(port, STOP_BREAK, UARTDM_CR);
+}
+
+/*
+ * msm_hsl_set_baud_rate: set requested baud rate
+ * @port: uart port
+ * @baud: baud rate to set (in bps)
+ */
+static void msm_hsl_set_baud_rate(struct uart_port *port, unsigned int baud)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	unsigned int baud_code, rxstale, watermark;
+	unsigned int data;
+
+	switch (baud) {
+	case 300:
+		baud_code = 0x00;
+		rxstale = 1;
+		break;
+	case 600:
+		baud_code = 0x11;
+		rxstale = 1;
+		break;
+	case 1200:
+		baud_code = 0x22;
+		rxstale = 1;
+		break;
+	case 2400:
+		baud_code = 0x33;
+		rxstale = 1;
+		break;
+	case 4800:
+		baud_code = 0x44;
+		rxstale = 1;
+		break;
+	case 9600:
+		baud_code = 0x55;
+		rxstale = 2;
+		break;
+	case 14400:
+		baud_code = 0x66;
+		rxstale = 3;
+		break;
+	case 19200:
+		baud_code = 0x77;
+		rxstale = 4;
+		break;
+	case 28800:
+		baud_code = 0x88;
+		rxstale = 6;
+		break;
+	case 38400:
+		baud_code = 0x99;
+		rxstale = 8;
+		break;
+	case 57600:
+		baud_code = 0xaa;
+		rxstale = 16;
+		break;
+	case 115200:
+		baud_code = 0xcc;
+		rxstale = 31;
+		break;
+	case 230400:
+		baud_code = 0xee;
+		rxstale = 31;
+		break;
+	case 460800:
+		baud_code = 0xff;
+		rxstale = 31;
+		break;
+	default:		/*115200 baud rate */
+		baud_code = 0xcc;
+		rxstale = 31;
+		break;
+	}
+
+	msm_hsl_write(port, baud_code, UARTDM_CSR);
+
+	/*
+	 * uart baud rate depends on CSR and MND Values
+	 * we are updating CSR before and then calling
+	 * clk_set_rate which updates MND Values. Hence
+	 * dsb requires here.
+	 */
+	mb();
+
+	/*
+	 * Check requested baud rate and for higher baud rate than 460800,
+	 * calculate required uart clock frequency and set the same.
+	 */
+	if (baud > 460800)
+		port->uartclk = baud * 16;
+	else
+		port->uartclk = 7372800;
+
+	if (clk_set_rate(hslp->clk, port->uartclk)) {
+		WARN_ON(1);
+		return;
+	}
+
+	/* Set timeout to be ~600x the character transmit time */
+	hslp->tx_timeout = (1000000000 / baud) * 6;
+
+	/* RX stale watermark */
+	watermark = UARTDM_IPR_STALE_LSB_BMSK & rxstale;
+	watermark |= UARTDM_IPR_STALE_TIMEOUT_MSB_BMSK & (rxstale << 2);
+	msm_hsl_write(port, watermark, UARTDM_IPR);
+
+	/* Set RX watermark
+	 * Configure Rx Watermark as 3/4 size of Rx FIFO.
+	 * RFWR register takes value in Words for UARTDM Core
+	 * whereas it is consider to be in Bytes for UART Core.
+	 * Hence configuring Rx Watermark as 48 Words.
+	 */
+	watermark = (port->fifosize * 3) / 4;
+	msm_hsl_write(port, watermark, UARTDM_RFWR);
+
+	/* set TX watermark */
+	msm_hsl_write(port, 0, UARTDM_TFWR);
+
+	msm_hsl_write(port, CR_PROTECTION_EN, UARTDM_CR);
+	msm_hsl_reset(port);
+
+	data = UARTDM_CR_TX_EN_BMSK;
+	data |= UARTDM_CR_RX_EN_BMSK;
+	/* enable TX & RX */
+	msm_hsl_write(port, data, UARTDM_CR);
+
+	msm_hsl_write(port, RESET_STALE_INT, UARTDM_CR);
+	/* turn on RX and CTS interrupts */
+	hslp->imr = UARTDM_ISR_RXSTALE_BMSK | UARTDM_ISR_DELTA_CTS_BMSK |
+		    UARTDM_ISR_RXLEV_BMSK;
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+	msm_hsl_write(port, 6500, UARTDM_DMRX);
+	msm_hsl_write(port, STALE_EVENT_ENABLE, UARTDM_CR);
+}
+
+static int msm_hsl_startup(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	unsigned int data, rfr_level;
+	int ret;
+	unsigned long flags;
+
+	snprintf(hslp->name, sizeof(hslp->name),
+		 "msm_serial_hsl%d", port->line);
+
+	if (!(is_console(port)) || (!port->cons) ||
+	    (port->cons && (!(port->cons->flags & CON_ENABLED)))) {
+
+		if (msm_serial_hsl_has_gsbi(port))
+			set_gsbi_uart_func_mode(port);
+	}
+
+	/*
+	 * Set RFR Level as 3/4 of UARTDM FIFO Size
+	 * i.e. 48 Words = 192 bytes as Rx FIFO is 64 words ( 256 bytes).
+	 */
+	if (port->fifosize > 48)
+		rfr_level = port->fifosize - 16;
+	else
+		rfr_level = port->fifosize;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	/* set automatic RFR level */
+	data = msm_hsl_read(port, UARTDM_MR1);
+	data &= ~UARTDM_MR1_AUTO_RFR_LEVEL1_BMSK;
+	data &= ~UARTDM_MR1_AUTO_RFR_LEVEL0_BMSK;
+	data |= UARTDM_MR1_AUTO_RFR_LEVEL1_BMSK & (rfr_level << 2);
+	data |= UARTDM_MR1_AUTO_RFR_LEVEL0_BMSK & rfr_level;
+	msm_hsl_write(port, data, UARTDM_MR1);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	ret = request_irq(port->irq, msm_hsl_irq, IRQF_TRIGGER_HIGH,
+			  hslp->name, port);
+	if (ret)
+		dev_err(port->dev, "Failed to request irq\n");
+
+	return ret;
+}
+
+static void msm_hsl_shutdown(struct uart_port *port)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+
+	hslp->imr = 0;
+	/* disable interrupts */
+	msm_hsl_write(port, 0, UARTDM_IMR);
+
+	free_irq(port->irq, port);
+}
+
+static void msm_hsl_set_termios(struct uart_port *port,
+				struct ktermios *termios, struct ktermios *old)
+{
+	unsigned int baud, mr;
+	unsigned long flags;
+
+	if (!termios->c_cflag)
+		return;
+
+	/*
+	 * Calculate and set baud rate
+	 * 300 is the minimum and 4 Mbps is the maximum baud rate
+	 * supported by driver.
+	 */
+	baud = uart_get_baud_rate(port, termios, old, 200, 4000000);
+
+	/*
+	 * Due to non-availability of 3.2 Mbps baud rate as standard baud rate
+	 * with TTY/serial core. Map 200 BAUD to 3.2 Mbps
+	 */
+	if (baud == 200)
+		baud = 3200000;
+
+	spin_lock_irqsave(&port->lock, flags);
+
+	msm_hsl_set_baud_rate(port, baud);
+
+	/* calculate parity */
+	mr = msm_hsl_read(port, UARTDM_MR2);
+	mr &= ~UARTDM_MR2_PARITY_MODE_BMSK;
+	if (termios->c_cflag & PARENB) {
+		if (termios->c_cflag & PARODD)
+			mr |= ODD_PARITY;
+		else if (termios->c_cflag & CMSPAR)
+			mr |= SPACE_PARITY;
+		else
+			mr |= EVEN_PARITY;
+	}
+
+	/* calculate bits per char */
+	mr &= ~UARTDM_MR2_BITS_PER_CHAR_BMSK;
+	switch (termios->c_cflag & CSIZE) {
+	case CS5:
+		mr |= FIVE_BPC;
+		break;
+	case CS6:
+		mr |= SIX_BPC;
+		break;
+	case CS7:
+		mr |= SEVEN_BPC;
+		break;
+	case CS8:
+	default:
+		mr |= EIGHT_BPC;
+		break;
+	}
+
+	/* calculate stop bits */
+	mr &= ~(STOP_BIT_ONE | STOP_BIT_TWO);
+	if (termios->c_cflag & CSTOPB)
+		mr |= STOP_BIT_TWO;
+	else
+		mr |= STOP_BIT_ONE;
+
+	/* set parity, bits per char, and stop bit */
+	msm_hsl_write(port, mr, UARTDM_MR2);
+
+	/* calculate and set hardware flow control */
+	mr = msm_hsl_read(port, UARTDM_MR1);
+	mr &= ~(UARTDM_MR1_CTS_CTL_BMSK | UARTDM_MR1_RX_RDY_CTL_BMSK);
+	if (termios->c_cflag & CRTSCTS) {
+		mr |= UARTDM_MR1_CTS_CTL_BMSK;
+		mr |= UARTDM_MR1_RX_RDY_CTL_BMSK;
+	}
+	msm_hsl_write(port, mr, UARTDM_MR1);
+
+	/* Configure status bits to ignore based on termio flags. */
+	port->read_status_mask = 0;
+	if (termios->c_iflag & INPCK)
+		port->read_status_mask |= UARTDM_SR_PAR_FRAME_BMSK;
+	if (termios->c_iflag & (BRKINT | PARMRK))
+		port->read_status_mask |= UARTDM_SR_RX_BREAK_BMSK;
+
+	uart_update_timeout(port, termios->c_cflag, baud);
+
+	spin_unlock_irqrestore(&port->lock, flags);
+}
+
+static const char *msm_hsl_type(struct uart_port *port)
+{
+	return "MSM";
+}
+
+static void msm_hsl_release_port(struct uart_port *port)
+{
+}
+
+static int msm_hsl_request_port(struct uart_port *port)
+{
+	return 0;
+}
+
+static void msm_hsl_config_port(struct uart_port *port, int flags)
+{
+	if (flags & UART_CONFIG_TYPE)
+		port->type = PORT_MSM;
+
+	/* Configure required GSBI based UART protocol. */
+	if (msm_serial_hsl_has_gsbi(port))
+		set_gsbi_uart_func_mode(port);
+}
+
+static int msm_hsl_verify_port(struct uart_port *port,
+			       struct serial_struct *ser)
+{
+	if (ser->type != PORT_UNKNOWN && ser->type != PORT_MSM)
+		return -EINVAL;
+	if (port->irq != ser->irq)
+		return -EINVAL;
+	return 0;
+}
+
+static void msm_hsl_power(struct uart_port *port, unsigned int state,
+			  unsigned int oldstate)
+{
+	struct msm_hsl_port *hslp = to_hsl_port(port);
+	int ret;
+
+	switch (state) {
+	case UART_PM_STATE_ON:
+		ret = clk_set_rate(hslp->clk, port->uartclk);
+		if (ret)
+			dev_err(port->dev, "Can't change rate to %u\n",
+				port->uartclk);
+		msm_hsl_clock_enable(port, 1);
+		break;
+	case UART_PM_STATE_OFF:
+		msm_hsl_clock_enable(port, 0);
+		break;
+	default:
+		dev_err(port->dev, "Unknown PM state %d\n", state);
+	}
+}
+
+static struct uart_ops msm_hsl_uart_pops = {
+	.tx_empty	= msm_hsl_tx_empty,
+	.set_mctrl	= msm_hsl_set_mctrl,
+	.get_mctrl	= msm_hsl_get_mctrl,
+	.stop_tx	= msm_hsl_stop_tx,
+	.start_tx	= msm_hsl_start_tx,
+	.stop_rx	= msm_hsl_stop_rx,
+	.enable_ms	= msm_hsl_enable_ms,
+	.break_ctl	= msm_hsl_break_ctl,
+	.startup	= msm_hsl_startup,
+	.shutdown	= msm_hsl_shutdown,
+	.set_termios	= msm_hsl_set_termios,
+	.type		= msm_hsl_type,
+	.release_port	= msm_hsl_release_port,
+	.request_port	= msm_hsl_request_port,
+	.config_port	= msm_hsl_config_port,
+	.verify_port	= msm_hsl_verify_port,
+	.pm		= msm_hsl_power,
+};
+
+#ifdef CONFIG_SERIAL_MSM_HSL_CONSOLE
+
+static struct msm_hsl_port *msm_hsl_uart_ports[UART_NR];
+
+static void msm_hsl_console_putchar(struct uart_port *port, int ch)
+{
+	msm_hsl_wait_for_xmitr(port);
+	msm_hsl_write(port, 1, UARTDM_NCF_TX);
+	/*
+	 * Dummy read to add 1 AHB clock delay to fix UART hardware bug.
+	 * Bug: Delay required on TX-transfer-init. after writing to
+	 * NO_CHARS_FOR_TX register.
+	 */
+	msm_hsl_read(port, UARTDM_SR);
+	msm_hsl_write(port, ch, UARTDM_TF);
+}
+
+static void msm_hsl_console_write(struct console *co, const char *s,
+				  unsigned int count)
+{
+	struct uart_port *port;
+	struct msm_hsl_port *hslp;
+	int locked;
+
+	BUG_ON(co->index < 0 || co->index >= UART_NR);
+
+	hslp = msm_hsl_uart_ports[co->index];
+	port = &hslp->uart;
+
+	/* not pretty, but we can end up here via various convoluted paths */
+	if (port->sysrq || oops_in_progress)
+		locked = spin_trylock(&port->lock);
+	else {
+		locked = 1;
+		spin_lock(&port->lock);
+	}
+	msm_hsl_write(port, 0, UARTDM_IMR);
+	uart_console_write(port, s, count, msm_hsl_console_putchar);
+	msm_hsl_write(port, hslp->imr, UARTDM_IMR);
+	if (locked == 1)
+		spin_unlock(&port->lock);
+}
+
+static int msm_hsl_console_setup(struct console *co, char *options)
+{
+	struct uart_port *port;
+	int baud = 0, flow, bits, parity, mr2;
+	int ret;
+
+	if (co->index >= UART_NR || co->index < 0)
+		return -ENXIO;
+
+	port = &msm_hsl_uart_ports[co->index]->uart;
+
+	if (!port->membase)
+		return -ENXIO;
+
+	port->cons = co;
+
+	pm_runtime_get_noresume(port->dev);
+
+#ifndef CONFIG_PM_RUNTIME
+	msm_hsl_clock_enable(port, 1);
+#endif
+	pm_runtime_resume(port->dev);
+
+	if (options)
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+
+	bits = 8;
+	parity = 'n';
+	flow = 'n';
+	msm_hsl_write(port, UARTDM_MR2_BITS_PER_CHAR_8 |
+		      STOP_BIT_ONE, UARTDM_MR2);	/* 8N1 */
+
+	if (baud < 300 || baud > 115200)
+		baud = 115200;
+
+	msm_hsl_set_baud_rate(port, baud);
+
+	ret = uart_set_options(port, co, baud, parity, bits, flow);
+
+	mr2 = msm_hsl_read(port, UARTDM_MR2);
+	mr2 |= UARTDM_MR2_RX_ERROR_CHAR_OFF;
+	mr2 |= UARTDM_MR2_RX_BREAK_ZERO_CHAR_OFF;
+	msm_hsl_write(port, mr2, UARTDM_MR2);
+
+	msm_hsl_reset(port);
+	/* Enable transmitter */
+	msm_hsl_write(port, CR_PROTECTION_EN, UARTDM_CR);
+	msm_hsl_write(port, UARTDM_CR_TX_EN_BMSK, UARTDM_CR);
+
+	msm_hsl_write(port, 1, UARTDM_NCF_TX);
+	msm_hsl_read(port, UARTDM_NCF_TX);
+
+	dev_dbg(port->dev, "Console setup on port #%d\n", port->line);
+
+	return ret;
+}
+
+static struct uart_driver msm_hsl_uart_driver;
+
+static struct console msm_hsl_console = {
+	.name = "ttyHSL",
+	.write = msm_hsl_console_write,
+	.device = uart_console_device,
+	.setup = msm_hsl_console_setup,
+	.flags = CON_PRINTBUFFER,
+	.index = -1,
+	.data = &msm_hsl_uart_driver,
+};
+
+#define MSM_HSL_CONSOLE	(&msm_hsl_console)
+
+#else
+#define MSM_HSL_CONSOLE	NULL
+#endif
+
+static struct uart_driver msm_hsl_uart_driver = {
+	.owner = THIS_MODULE,
+	.driver_name = "msm_serial_hsl",
+	.dev_name = "ttyHSL",
+	.nr = UART_NR,
+	.cons = MSM_HSL_CONSOLE,
+};
+
+static struct dentry *debug_base;
+
+DEFINE_SIMPLE_ATTRIBUTE(loopback_enable_fops, msm_hsl_loopback_get,
+			msm_hsl_loopback_set, "%llu\n");
+/*
+ * msm_serial_hsl debugfs node: <debugfs_root>/msm_serial_hsl/loopback.<id>
+ * writing 1 turns on internal loopback mode in HW. Useful for automation
+ * test scripts.
+ * writing 0 disables the internal loopback mode. Default is disabled.
+ */
+static void msm_hsl_debugfs_init(struct msm_hsl_port *hslp, int id)
+{
+	char node_name[15];
+
+	snprintf(node_name, sizeof(node_name), "loopback.%d", id);
+	hslp->loopback_dir = debugfs_create_file(node_name,
+						 S_IRUGO | S_IWUSR,
+						 debug_base, hslp,
+						 &loopback_enable_fops);
+}
+
+static atomic_t msm_serial_hsl_next_id = ATOMIC_INIT(0);
+
+static struct of_device_id msm_hsl_match_table[] = {
+	{.compatible = "qcom,msm-lsuart-v14"},
+	{ /* Sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, msm_hsl_match_table);
+
+static int msm_serial_hsl_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct msm_hsl_port *hslp;
+	struct resource *mem;
+	struct uart_port *port;
+	const struct of_device_id *match;
+	u32 line;
+	int ret;
+
+	if (pdev->id == -1)
+		pdev->id = atomic_inc_return(&msm_serial_hsl_next_id) - 1;
+
+	line = pdev->id;
+
+	/* Use line number from device tree alias if present */
+	if (!node)
+		return -EINVAL;
+
+	ret = of_alias_get_id(node, "serial");
+	if (ret >= 0)
+		line = ret;
+
+	if (line < 0 || line >= UART_NR)
+		return -ENXIO;
+
+	pr_info("detected port #%d (ttyHSL%d)\n", pdev->id, line);
+
+	hslp = devm_kzalloc(&pdev->dev, sizeof(*hslp), GFP_KERNEL);
+	if (!hslp)
+		return -ENOMEM;
+
+	port = &hslp->uart;
+	port->dev = &pdev->dev;
+	port->uartclk = 7372800;
+	port->iotype = UPIO_MEM;
+	port->ops = &msm_hsl_uart_pops;
+	port->flags = UPF_BOOT_AUTOCONF;
+	port->fifosize = 64;
+	port->line = line;
+
+	hslp->clk = devm_clk_get(&pdev->dev, "core_clk");
+	if (IS_ERR(hslp->clk)) {
+		ret = PTR_ERR(hslp->clk);
+		if (ret != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Error getting core clk\n");
+		return ret;
+	}
+
+	/*
+	 * Interface clock is not required by all UART configurations.
+	 * GSBI UART and BLSP UART needs interface clock but Legacy UART
+	 * do not require interface clock. Hence, do not fail probe with
+	 * iface of_clk_get_by_name failure.
+	 */
+	hslp->pclk = devm_clk_get(&pdev->dev, "iface_clk");
+	if (IS_ERR(hslp->pclk)) {
+		ret = PTR_ERR(hslp->pclk);
+		if (ret == -EPROBE_DEFER)
+			return ret;
+		else
+			hslp->pclk = NULL;
+	}
+
+	hslp->uart_type = LEGACY_HSUART;
+
+	match = of_match_device(msm_hsl_match_table, &pdev->dev);
+	if (!match) {
+		hslp->regmap = regmap[UARTDM_VERSION_11_13];
+	} else {
+		hslp->regmap = regmap[UARTDM_VERSION_14];
+		/*
+		 * BLSP based UART configuration is available with
+		 * UARTDM v14 Revision. Hence set uart_type as UART_BLSP.
+		 */
+		hslp->uart_type = BLSP_HSUART;
+	}
+
+	mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "gbsi_mem");
+	if (mem) {
+		hslp->mapped_gsbi = devm_request_and_ioremap(&pdev->dev, mem);
+		if (!hslp->mapped_gsbi)
+			dev_warn(&pdev->dev, "GSBI region already claimed\n");
+		else
+			hslp->uart_type = GSBI_HSUART;
+	}
+
+	mem = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uart_mem");
+	if (!mem) {
+		dev_err(&pdev->dev, "Getting UART mem failed\n");
+		return -ENXIO;
+	}
+
+	port->mapbase = mem->start;
+
+	port->irq = platform_get_irq(pdev, 0);
+	if ((int)port->irq < 0) {
+		dev_err(&pdev->dev, "Getting irq failed\n");
+		return -ENXIO;
+	}
+
+	port->membase = devm_request_and_ioremap(&pdev->dev, mem);
+	if (!port->membase) {
+		dev_err(&pdev->dev, "UART region already claimed\n");
+		return -EADDRNOTAVAIL;
+	}
+
+	device_set_wakeup_capable(&pdev->dev, 1);
+	platform_set_drvdata(pdev, port);
+	pm_runtime_enable(port->dev);
+#ifdef CONFIG_SERIAL_MSM_HSL_CONSOLE
+	msm_hsl_uart_ports[line] = hslp;
+#endif
+	msm_hsl_debugfs_init(hslp, hslp->uart.line);
+
+	/* Temporarily increase the refcount on the GSBI clock to avoid a race
+	 * condition with the earlyprintk handover mechanism.
+	 */
+	if (hslp->pclk)
+		clk_prepare_enable(hslp->pclk);
+	ret = uart_add_one_port(&msm_hsl_uart_driver, port);
+	if (hslp->pclk)
+		clk_disable_unprepare(hslp->pclk);
+
+	if (!ret)
+		platform_set_drvdata(pdev, hslp);
+
+	return ret;
+}
+
+static int msm_serial_hsl_remove(struct platform_device *pdev)
+{
+	struct msm_hsl_port *hslp = platform_get_drvdata(pdev);
+	struct uart_port *port;
+
+	port = &hslp->uart;
+
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
+	device_set_wakeup_capable(&pdev->dev, 0);
+	platform_set_drvdata(pdev, NULL);
+
+	uart_remove_one_port(&msm_hsl_uart_driver, port);
+
+	debugfs_remove(hslp->loopback_dir);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int msm_serial_hsl_suspend(struct device *dev)
+{
+	struct msm_hsl_port *hslp = dev_get_drvdata(dev);
+	struct uart_port *port;
+
+	port = &hslp->uart;
+
+	if (port)
+		return 0;
+
+	if (is_console(port))
+		msm_hsl_clock_enable(port, 0);
+
+	uart_suspend_port(&msm_hsl_uart_driver, port);
+	if (device_may_wakeup(dev))
+		enable_irq_wake(port->irq);
+
+	return 0;
+}
+
+static int msm_serial_hsl_resume(struct device *dev)
+{
+	struct msm_hsl_port *hslp = dev_get_drvdata(dev);
+	struct uart_port *port;
+
+	port = &hslp->uart;
+
+	if (!port)
+		return 0;
+
+	uart_resume_port(&msm_hsl_uart_driver, port);
+	if (device_may_wakeup(dev))
+		disable_irq_wake(port->irq);
+
+	if (is_console(port))
+		msm_hsl_clock_enable(port, 1);
+
+	return 0;
+}
+#else
+#define msm_serial_hsl_suspend NULL
+#define msm_serial_hsl_resume NULL
+#endif
+
+static int msm_hsl_runtime_suspend(struct device *dev)
+{
+	struct msm_hsl_port *hslp = dev_get_drvdata(dev);
+	struct uart_port *port;
+
+	port = &hslp->uart;
+
+	dev_dbg(dev, "pm_runtime: suspending\n");
+	msm_hsl_clock_enable(port, 0);
+	return 0;
+}
+
+static int msm_hsl_runtime_resume(struct device *dev)
+{
+	struct msm_hsl_port *hslp = dev_get_drvdata(dev);
+	struct uart_port *port;
+
+	port = &hslp->uart;
+
+	dev_dbg(dev, "pm_runtime: resuming\n");
+	msm_hsl_clock_enable(port, 1);
+	return 0;
+}
+
+static const struct dev_pm_ops msm_hsl_dev_pm_ops = {
+	.suspend = msm_serial_hsl_suspend,
+	.resume = msm_serial_hsl_resume,
+	.runtime_suspend = msm_hsl_runtime_suspend,
+	.runtime_resume = msm_hsl_runtime_resume,
+};
+
+static struct platform_driver msm_hsl_platform_driver = {
+	.probe = msm_serial_hsl_probe,
+	.remove = msm_serial_hsl_remove,
+	.driver = {
+		   .name = "msm_serial_hsl",
+		   .owner = THIS_MODULE,
+		   .pm = &msm_hsl_dev_pm_ops,
+		   .of_match_table = msm_hsl_match_table,
+	},
+};
+
+static int __init msm_serial_hsl_init(void)
+{
+	int ret;
+
+	ret = uart_register_driver(&msm_hsl_uart_driver);
+	if (ret)
+		return ret;
+
+	debug_base = debugfs_create_dir("msm_serial_hsl", NULL);
+	if (IS_ERR_OR_NULL(debug_base))
+		pr_err("Cannot create debugfs dir\n");
+
+	ret = platform_driver_register(&msm_hsl_platform_driver);
+	if (ret)
+		uart_unregister_driver(&msm_hsl_uart_driver);
+
+	pr_debug("Driver initialized\n");
+	return ret;
+}
+
+static void __exit msm_serial_hsl_exit(void)
+{
+	debugfs_remove_recursive(debug_base);
+#ifdef CONFIG_SERIAL_MSM_HSL_CONSOLE
+	unregister_console(&msm_hsl_console);
+#endif
+	platform_driver_unregister(&msm_hsl_platform_driver);
+	uart_unregister_driver(&msm_hsl_uart_driver);
+}
+
+module_init(msm_serial_hsl_init);
+module_exit(msm_serial_hsl_exit);
+
+MODULE_DESCRIPTION("Driver for MSM HSUART UART serial device");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/tty/serial/msm_serial_hsl.h b/drivers/tty/serial/msm_serial_hsl.h
new file mode 100644
index 0000000..beb97d4
--- /dev/null
+++ b/drivers/tty/serial/msm_serial_hsl.h
@@ -0,0 +1,294 @@
+/* drivers/tty/serial/msm_serial_hsl.h
+ *
+ * Copyright (c) 2007-2009, 2012-2013,The Linux Foundation. All rights reserved.
+ *
+ * All source code in this file is licensed under the following license
+ * except where indicated.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, you can find it at http://www.fsf.org
+ */
+
+#ifndef MSM_SERIAL_HSL_H
+#define MSM_SERIAL_HSL_H
+
+#define GSBI_CONTROL_ADDR              0x0
+#define GSBI_PROTOCOL_CODE_MASK        0x30
+#define GSBI_PROTOCOL_I2C_UART         0x60
+#define GSBI_PROTOCOL_UART             0x40
+#define GSBI_PROTOCOL_IDLE             0x0
+
+#define TCSR_ADM_1_A_CRCI_MUX_SEL      0x78
+#define TCSR_ADM_1_B_CRCI_MUX_SEL      0x7c
+#define ADM1_CRCI_GSBI6_RX_SEL         0x800
+#define ADM1_CRCI_GSBI6_TX_SEL         0x400
+
+enum msm_hsl_regs {
+	UARTDM_MR1,
+	UARTDM_MR2,
+	UARTDM_IMR,
+	UARTDM_SR,
+	UARTDM_CR,
+	UARTDM_CSR,
+	UARTDM_IPR,
+	UARTDM_ISR,
+	UARTDM_RX_TOTAL_SNAP,
+	UARTDM_RFWR,
+	UARTDM_TFWR,
+	UARTDM_RF,
+	UARTDM_TF,
+	UARTDM_MISR,
+	UARTDM_DMRX,
+	UARTDM_NCF_TX,
+	UARTDM_DMEN,
+	UARTDM_BCR,
+	UARTDM_TXFS,
+	UARTDM_RXFS,
+	UARTDM_LAST,
+};
+
+#define UARTDM_MR1_ADDR 0x0
+#define UARTDM_MR2_ADDR 0x4
+
+/* Backward Compatability Register for UARTDM Core v1.4 */
+#define UARTDM_BCR_ADDR	0xc8
+
+/*
+ * UARTDM Core v1.4 STALE_IRQ_EMPTY bit defination
+ * Stale interrupt will fire if bit is set when RX-FIFO is empty
+ */
+#define UARTDM_BCR_STALE_IRQ_EMPTY	0x2
+
+/* TRANSFER_CONTROL Register for UARTDM Core v1.4 */
+#define UARTDM_RX_TRANS_CTRL_ADDR      0xcc
+
+/* TRANSFER_CONTROL Register bits */
+#define RX_STALE_AUTO_RE_EN		0x1
+#define RX_TRANS_AUTO_RE_ACTIVATE	0x2
+#define RX_DMRX_CYCLIC_EN		0x4
+
+/* write only register */
+#define UARTDM_IPR_ADDR 0x18
+#define UARTDM_TFWR_ADDR 0x1c
+#define UARTDM_RFWR_ADDR 0x20
+#define UARTDM_HCR_ADDR 0x24
+#define UARTDM_DMRX_ADDR 0x34
+#define UARTDM_DMEN_ADDR 0x3c
+
+/* UART_DM_NO_CHARS_FOR_TX */
+#define UARTDM_NCF_TX_ADDR 0x40
+
+#define UARTDM_BADR_ADDR 0x44
+
+#define UARTDM_SIM_CFG_ADDR 0x80
+
+/* Read Only register */
+#define UARTDM_TXFS_ADDR 0x4c
+#define UARTDM_RXFS_ADDR 0x50
+
+/* Register field Mask Mapping */
+#define UARTDM_SR_RX_BREAK_BMSK	        BIT(6)
+#define UARTDM_SR_PAR_FRAME_BMSK	BIT(5)
+#define UARTDM_SR_OVERRUN_BMSK		BIT(4)
+#define UARTDM_SR_TXEMT_BMSK		BIT(3)
+#define UARTDM_SR_TXRDY_BMSK		BIT(2)
+#define UARTDM_SR_RXRDY_BMSK		BIT(0)
+
+#define UARTDM_CR_TX_DISABLE_BMSK	BIT(3)
+#define UARTDM_CR_RX_DISABLE_BMSK	BIT(1)
+#define UARTDM_CR_TX_EN_BMSK		BIT(2)
+#define UARTDM_CR_RX_EN_BMSK		BIT(0)
+
+/* UARTDM_CR channel_comman bit value (register field is bits 8:4) */
+#define RESET_RX		0x10
+#define RESET_TX		0x20
+#define RESET_ERROR_STATUS	0x30
+#define RESET_BREAK_INT		0x40
+#define START_BREAK		0x50
+#define STOP_BREAK		0x60
+#define RESET_CTS		0x70
+#define RESET_STALE_INT		0x80
+#define RFR_LOW			0xD0
+#define RFR_HIGH		0xE0
+#define CR_PROTECTION_EN	0x100
+#define STALE_EVENT_ENABLE	0x500
+#define STALE_EVENT_DISABLE	0x600
+#define FORCE_STALE_EVENT	0x400
+#define CLEAR_TX_READY		0x300
+#define RESET_TX_ERROR		0x800
+#define RESET_TX_DONE		0x810
+
+/*
+ * UARTDM_CR BAM IFC comman bit value
+ * for UARTDM Core v1.4
+ */
+#define START_RX_BAM_IFC	0x850
+#define START_TX_BAM_IFC	0x860
+
+#define UARTDM_MR1_AUTO_RFR_LEVEL1_BMSK 0xffffff00
+#define UARTDM_MR1_AUTO_RFR_LEVEL0_BMSK 0x3f
+#define UARTDM_MR1_CTS_CTL_BMSK 0x40
+#define UARTDM_MR1_RX_RDY_CTL_BMSK 0x80
+
+/*
+ * UARTDM Core v1.4 MR2_RFR_CTS_LOOP bitmask
+ * Enables internal loopback between RFR_N of
+ * RX channel and CTS_N of TX channel.
+ */
+#define UARTDM_MR2_RFR_CTS_LOOP_MODE_BMSK	0x400
+
+#define UARTDM_MR2_LOOP_MODE_BMSK		0x80
+#define UARTDM_MR2_ERROR_MODE_BMSK		0x40
+#define UARTDM_MR2_BITS_PER_CHAR_BMSK		0x30
+#define UARTDM_MR2_RX_ZERO_CHAR_OFF		0x100
+#define UARTDM_MR2_RX_ERROR_CHAR_OFF		0x200
+#define UARTDM_MR2_RX_BREAK_ZERO_CHAR_OFF	0x100
+
+#define UARTDM_MR2_BITS_PER_CHAR_8	(0x3 << 4)
+
+/* bits per character configuration */
+#define FIVE_BPC  (0 << 4)
+#define SIX_BPC   (1 << 4)
+#define SEVEN_BPC (2 << 4)
+#define EIGHT_BPC (3 << 4)
+
+#define UARTDM_MR2_STOP_BIT_LEN_BMSK 0xc
+#define STOP_BIT_ONE (1 << 2)
+#define STOP_BIT_TWO (3 << 2)
+
+#define UARTDM_MR2_PARITY_MODE_BMSK 0x3
+
+/* Parity configuration */
+#define NO_PARITY 0x0
+#define EVEN_PARITY 0x2
+#define ODD_PARITY 0x1
+#define SPACE_PARITY 0x3
+
+#define UARTDM_IPR_STALE_TIMEOUT_MSB_BMSK 0xffffff80
+#define UARTDM_IPR_STALE_LSB_BMSK 0x1f
+
+/* These can be used for both ISR and IMR register */
+#define UARTDM_ISR_TX_READY_BMSK	BIT(7)
+#define UARTDM_ISR_CURRENT_CTS_BMSK	BIT(6)
+#define UARTDM_ISR_DELTA_CTS_BMSK	BIT(5)
+#define UARTDM_ISR_RXLEV_BMSK		BIT(4)
+#define UARTDM_ISR_RXSTALE_BMSK		BIT(3)
+#define UARTDM_ISR_RXBREAK_BMSK		BIT(2)
+#define UARTDM_ISR_RXHUNT_BMSK		BIT(1)
+#define UARTDM_ISR_TXLEV_BMSK		BIT(0)
+
+/* Field definitions for UART_DM_DMEN*/
+#define UARTDM_TX_DM_EN_BMSK 0x1
+#define UARTDM_RX_DM_EN_BMSK 0x2
+
+/*
+ * UARTDM Core v1.4 bitmask
+ * Bitmasks for enabling Rx and Tx BAM Interface
+ */
+#define UARTDM_TX_BAM_ENABLE_BMSK 0x4
+#define UARTDM_RX_BAM_ENABLE_BMSK 0x8
+
+/*
+ * Some of the BLSP Based UART Core(v14) existing register offsets
+ * are different compare to GSBI based UART Core(v13)
+ * Hence add the changed register offsets for UART Core v14
+ */
+
+/* write only register */
+#define UARTDM_CSR_ADDR_V14    0xa0
+
+/* write only register */
+#define UARTDM_TF_ADDR_V14   0x100
+#define UARTDM_TF2_ADDR_V14  0x104
+#define UARTDM_TF3_ADDR_V14  0x108
+#define UARTDM_TF4_ADDR_V14  0x10c
+#define UARTDM_TF5_ADDR_V14  0x110
+#define UARTDM_TF6_ADDR_V14  0x114
+#define UARTDM_TF7_ADDR_V14  0x118
+#define UARTDM_TF8_ADDR_V14  0x11c
+#define UARTDM_TF9_ADDR_V14  0x120
+#define UARTDM_TF10_ADDR_V14 0x124
+#define UARTDM_TF11_ADDR_V14 0x128
+#define UARTDM_TF12_ADDR_V14 0x12c
+#define UARTDM_TF13_ADDR_V14 0x130
+#define UARTDM_TF14_ADDR_V14 0x134
+#define UARTDM_TF15_ADDR_V14 0x138
+#define UARTDM_TF16_ADDR_V14 0x13c
+
+/* write only register */
+#define UARTDM_CR_ADDR_V14 0xa8
+/* write only register */
+#define UARTDM_IMR_ADDR_V14 0xb0
+#define UARTDM_IRDA_ADDR_V14 0xb8
+
+/* Read Only register */
+#define UARTDM_SR_ADDR_V14 0xa4
+
+/* Read Only register */
+#define UARTDM_RF_ADDR_V14   0x140
+#define UARTDM_RF2_ADDR_V14  0x144
+#define UARTDM_RF3_ADDR_V14  0x148
+#define UARTDM_RF4_ADDR_V14  0x14c
+#define UARTDM_RF5_ADDR_V14  0x150
+#define UARTDM_RF6_ADDR_V14  0x154
+#define UARTDM_RF7_ADDR_V14  0x158
+#define UARTDM_RF8_ADDR_V14  0x15c
+#define UARTDM_RF9_ADDR_V14  0x160
+#define UARTDM_RF10_ADDR_V14 0x164
+#define UARTDM_RF11_ADDR_V14 0x168
+#define UARTDM_RF12_ADDR_V14 0x16c
+#define UARTDM_RF13_ADDR_V14 0x170
+#define UARTDM_RF14_ADDR_V14 0x174
+#define UARTDM_RF15_ADDR_V14 0x178
+#define UARTDM_RF16_ADDR_V14 0x17c
+
+/* Read Only register */
+#define UARTDM_MISR_ADDR_V14 0xac
+
+/* Read Only register */
+#define UARTDM_ISR_ADDR_V14 0xb4
+#define UARTDM_RX_TOTAL_SNAP_ADDR_V14 0xbc
+
+/* Register offsets for UART Core v13 */
+
+/* write only register */
+#define UARTDM_CSR_ADDR    0x8
+
+/* write only register */
+#define UARTDM_TF_ADDR   0x70
+#define UARTDM_TF2_ADDR  0x74
+#define UARTDM_TF3_ADDR  0x78
+#define UARTDM_TF4_ADDR  0x7c
+
+/* write only register */
+#define UARTDM_CR_ADDR 0x10
+/* write only register */
+#define UARTDM_IMR_ADDR 0x14
+#define UARTDM_IRDA_ADDR 0x38
+
+/* Read Only register */
+#define UARTDM_SR_ADDR 0x8
+
+/* Read Only register */
+#define UARTDM_RF_ADDR   0x70
+#define UARTDM_RF2_ADDR  0x74
+#define UARTDM_RF3_ADDR  0x78
+#define UARTDM_RF4_ADDR  0x7c
+
+/* Read Only register */
+#define UARTDM_MISR_ADDR 0x10
+
+/* Read Only register */
+#define UARTDM_ISR_ADDR 0x14
+#define UARTDM_RX_TOTAL_SNAP_ADDR 0x38
+
+#endif /* MSM_SERIAL_HSL_H */
-- 
1.7.9.5

