Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaDCSAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:00:00 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:58772 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbaDCR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 13:59:50 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Harini Katakam <harinik@xilinx.com>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH v4 2/3] i2c: Add driver for Cadence I2C controller
Date: Thu,  3 Apr 2014 10:59:26 -0700
Message-Id: <1396547967-19260-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.1.1.gbb9f595
In-Reply-To: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1396547967-19260-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a driver for the Cadence I2C controller. This controller is for
example found in Xilinx Zynq.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
Tested-by: Michal Simek <michal.simek@xilinx.com>
Reviewed-by: Harini Katakam <harinik@xilinx.com>
---

Changes in v4:
 - Addressing Wolfram's feedback
   - style improvements (e.g. magic numbers, typos,...)
   - initialize completion in probe and use reinit_completion during
     transfers
   - refactor code to let the core handle retries (on xfer error and bus-busy)
   - use i2c_add_adapter instead of i2c_add_numbered_adapter
   - use msecs_to_jiffies to specify timeout
 - revise timeouts
 - reformat kernel doc
 - remove CONFIG_PM_SLEEP ifdefs and annotate suspend/resume functions
   with '__maybe_unsued'
 - moved DT documentation into separate patch
 - use (read|write)l_relaxed IO helpers
 - revise ISR to return IRQ_HANDLED only if an IRQ has actually been
   handled

Changes in v3:
 - incorporate signal handling changes from Mike Looijmans
   <mike.looijmans@topic.nl> (https://lkml.org/lkml/2014/3/11/64)

Changes in v2:
 - make driver depend on COMMON_CLK instead of ARCH_ZYNQ

---
 MAINTAINERS                      |   1 +
 drivers/i2c/busses/Kconfig       |   7 +
 drivers/i2c/busses/Makefile      |   1 +
 drivers/i2c/busses/i2c-cadence.c | 903 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 912 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-cadence.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 11b3937adb89..f59a6ccf05ce 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1411,6 +1411,7 @@ F:	drivers/cpuidle/cpuidle-zynq.c
 N:	zynq
 N:	xilinx
 F:	drivers/clocksource/cadence_ttc_timer.c
+F:	drivers/i2c/busses/i2c-cadence.c
 F:	drivers/mmc/host/sdhci-of-arasan.c
 
 ARM SMMU DRIVER
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index de17c5593d97..66e68e48218f 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -375,6 +375,13 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
 	help
 	  The unit of the TWI clock is kHz.
 
+config I2C_CADENCE
+	tristate "Cadence I2C Controller"
+	depends on COMMON_CLK
+	help
+	  Say yes here to select Cadence I2C Host Controller. This controller is
+	  e.g. used by Xilinx Zynq.
+
 config I2C_CBUS_GPIO
 	tristate "CBUS I2C driver"
 	depends on GPIOLIB
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index a08931fe73e1..f9ebb8c6cdc1 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -33,6 +33,7 @@ obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
 obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
 obj-$(CONFIG_I2C_BCM2835)	+= i2c-bcm2835.o
 obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
+obj-$(CONFIG_I2C_CADENCE)	+= i2c-cadence.o
 obj-$(CONFIG_I2C_CBUS_GPIO)	+= i2c-cbus-gpio.o
 obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
 obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
new file mode 100644
index 000000000000..d2f12cab0efc
--- /dev/null
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -0,0 +1,903 @@
+/*
+ * I2C bus driver for the Cadence I2C controller.
+ *
+ * Copyright (C) 2009 - 2014 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it
+ * and/or modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2 of the License, or (at your option) any
+ * later version.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/i2c.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+/* Register offsets for the I2C device. */
+#define CDNS_I2C_CR_OFFSET		0x00 /* Control Register, RW */
+#define CDNS_I2C_SR_OFFSET		0x04 /* Status Register, RO */
+#define CDNS_I2C_ADDR_OFFSET		0x08 /* I2C Address Register, RW */
+#define CDNS_I2C_DATA_OFFSET		0x0C /* I2C Data Register, RW */
+#define CDNS_I2C_ISR_OFFSET		0x10 /* IRQ Status Register, RW */
+#define CDNS_I2C_XFER_SIZE_OFFSET	0x14 /* Transfer Size Register, RW */
+#define CDNS_I2C_TIME_OUT_OFFSET	0x1C /* Time Out Register, RW */
+#define CDNS_I2C_IER_OFFSET		0x24 /* IRQ Enable Register, WO */
+#define CDNS_I2C_IDR_OFFSET		0x28 /* IRQ Disable Register, WO */
+
+/* Control Register Bit mask definitions */
+#define CDNS_I2C_CR_HOLD		BIT(4) /* Hold Bus bit */
+#define CDNS_I2C_CR_ACK_EN		BIT(3)
+#define CDNS_I2C_CR_NEA			BIT(2)
+#define CDNS_I2C_CR_MS			BIT(1)
+/* Read or Write Master transfer 0 = Transmitter, 1 = Receiver */
+#define CDNS_I2C_CR_RW			BIT(0)
+/* 1 = Auto init FIFO to zeroes */
+#define CDNS_I2C_CR_CLR_FIFO		BIT(6)
+#define CDNS_I2C_CR_DIVA_SHIFT		14
+#define CDNS_I2C_CR_DIVA_MASK		(3 << CDNS_I2C_CR_DIVA_SHIFT)
+#define CDNS_I2C_CR_DIVB_SHIFT		8
+#define CDNS_I2C_CR_DIVB_MASK		(0x3f << CDNS_I2C_CR_DIVB_SHIFT)
+
+/* Status Register Bit mask definitions */
+#define CDNS_I2C_SR_BA		BIT(8)
+#define CDNS_I2C_SR_RXDV	BIT(5)
+
+/*
+ * I2C Address Register Bit mask definitions
+ * Normal addressing mode uses [6:0] bits. Extended addressing mode uses [9:0]
+ * bits. A write access to this register always initiates a transfer if the I2C
+ * is in master mode.
+ */
+#define CDNS_I2C_ADDR_MASK	0x000003FF /* I2C Address Mask */
+
+/*
+ * I2C Interrupt Registers Bit mask definitions
+ * All the four interrupt registers (Status/Mask/Enable/Disable) have the same
+ * bit definitions.
+ */
+#define CDNS_I2C_IXR_ARB_LOST		BIT(9)
+#define CDNS_I2C_IXR_RX_UNF		BIT(7)
+#define CDNS_I2C_IXR_TX_OVF		BIT(6)
+#define CDNS_I2C_IXR_RX_OVF		BIT(5)
+#define CDNS_I2C_IXR_SLV_RDY		BIT(4)
+#define CDNS_I2C_IXR_TO			BIT(3)
+#define CDNS_I2C_IXR_NACK		BIT(2)
+#define CDNS_I2C_IXR_DATA		BIT(1)
+#define CDNS_I2C_IXR_COMP		BIT(0)
+
+#define CDNS_I2C_IXR_ALL_INTR_MASK	(CDNS_I2C_IXR_ARB_LOST | \
+					 CDNS_I2C_IXR_RX_UNF | \
+					 CDNS_I2C_IXR_TX_OVF | \
+					 CDNS_I2C_IXR_RX_OVF | \
+					 CDNS_I2C_IXR_SLV_RDY | \
+					 CDNS_I2C_IXR_TO | \
+					 CDNS_I2C_IXR_NACK | \
+					 CDNS_I2C_IXR_DATA | \
+					 CDNS_I2C_IXR_COMP)
+
+#define CDNS_I2C_IXR_ERR_INTR_MASK	(CDNS_I2C_IXR_ARB_LOST | \
+					 CDNS_I2C_IXR_RX_UNF | \
+					 CDNS_I2C_IXR_TX_OVF | \
+					 CDNS_I2C_IXR_RX_OVF | \
+					 CDNS_I2C_IXR_NACK)
+
+#define CDNS_I2C_ENABLED_INTR_MASK	(CDNS_I2C_IXR_ARB_LOST | \
+					 CDNS_I2C_IXR_RX_UNF | \
+					 CDNS_I2C_IXR_TX_OVF | \
+					 CDNS_I2C_IXR_RX_OVF | \
+					 CDNS_I2C_IXR_NACK | \
+					 CDNS_I2C_IXR_DATA | \
+					 CDNS_I2C_IXR_COMP)
+
+#define CDNS_I2C_TIMEOUT		msecs_to_jiffies(1000)
+
+#define CDNS_I2C_FIFO_DEPTH		16
+/* FIFO depth at which the DATA interrupt occurs */
+#define CDNS_I2C_DATA_INTR_DEPTH	(CDNS_I2C_FIFO_DEPTH - 2)
+#define CDNS_I2C_MAX_TRANSFER_SIZE	255
+/* Transfer size in multiples of data interrupt depth */
+#define CDNS_I2C_TRANSFER_SIZE	(CDNS_I2C_MAX_TRANSFER_SIZE - 3)
+
+#define DRIVER_NAME		"cdns-i2c"
+
+#define CDNS_I2C_SPEED_MAX	400000
+
+#define CDNS_I2C_DIVA_MAX	4
+#define CDNS_I2C_DIVB_MAX	64
+
+#define cdns_i2c_readreg(offset)       readl_relaxed(id->membase + offset)
+#define cdns_i2c_writereg(val, offset) writel_relaxed(val, id->membase + offset)
+
+/**
+ * struct cdns_i2c - I2C device private data structure
+ * @membase:		Base address of the I2C device
+ * @adap:		I2C adapter instance
+ * @p_msg:		Message pointer
+ * @err_status:		Error status in Interrupt Status Register
+ * @xfer_done:		Transfer complete status
+ * @p_send_buf:		Pointer to transmit buffer
+ * @p_recv_buf:		Pointer to receive buffer
+ * @suspended:		Flag holding the device's PM status
+ * @send_count:		Number of bytes still expected to send
+ * @recv_count:		Number of bytes still expected to receive
+ * @irq:		IRQ number
+ * @input_clk:		Input clock to I2C controller
+ * @i2c_clk:		Maximum I2C clock speed
+ * @bus_hold_flag:	Flag used in repeated start for clearing HOLD bit
+ * @clk:		Pointer to struct clk
+ * @clk_rate_change_nb:	Notifier block for clock rate changes
+ */
+struct cdns_i2c {
+	void __iomem *membase;
+	struct i2c_adapter adap;
+	struct i2c_msg *p_msg;
+	int err_status;
+	struct completion xfer_done;
+	unsigned char *p_send_buf;
+	unsigned char *p_recv_buf;
+	u8 suspended;
+	unsigned int send_count;
+	unsigned int recv_count;
+	int irq;
+	unsigned long input_clk;
+	unsigned int i2c_clk;
+	unsigned int bus_hold_flag;
+	struct clk *clk;
+	struct notifier_block clk_rate_change_nb;
+};
+
+#define to_cdns_i2c(_nb)	container_of(_nb, struct cdns_i2c, \
+					     clk_rate_change_nb)
+
+/**
+ * cdns_i2c_clear_bus_hold() - Clear bus hold bit
+ * @id:	Pointer to driver data struct
+ *
+ * Helper to clear the controller's bus hold bit.
+ */
+static void cdns_i2c_clear_bus_hold(struct cdns_i2c *id)
+{
+	u32 reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+	if (reg & CDNS_I2C_CR_HOLD)
+		cdns_i2c_writereg(reg & ~CDNS_I2C_CR_HOLD, CDNS_I2C_CR_OFFSET);
+}
+
+/**
+ * cdns_i2c_isr - Interrupt handler for the I2C device
+ * @irq:	irq number for the I2C device
+ * @ptr:	void pointer to cdns_i2c structure
+ *
+ * This function handles the data interrupt, transfer complete interrupt and
+ * the error interrupts of the I2C device.
+ *
+ * Return: IRQ_HANDLED always
+ */
+static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
+{
+	unsigned int isr_status, avail_bytes;
+	unsigned int bytes_to_recv, bytes_to_send;
+	struct cdns_i2c *id = ptr;
+	/* Signal completion only after everything is updated */
+	int done_flag = 0;
+	irqreturn_t status = IRQ_NONE;
+
+	isr_status = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
+
+	/* Handling nack and arbitration lost interrupt */
+	if (isr_status & (CDNS_I2C_IXR_NACK | CDNS_I2C_IXR_ARB_LOST)) {
+		done_flag = 1;
+		status = IRQ_HANDLED;
+	}
+
+	/* Handling Data interrupt */
+	if ((isr_status & CDNS_I2C_IXR_DATA) &&
+			(id->recv_count >= CDNS_I2C_DATA_INTR_DEPTH)) {
+		/* Always read data interrupt threshold bytes */
+		bytes_to_recv = CDNS_I2C_DATA_INTR_DEPTH;
+		id->recv_count -= CDNS_I2C_DATA_INTR_DEPTH;
+		avail_bytes = cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
+
+		/*
+		 * if the tranfer size register value is zero, then
+		 * check for the remaining bytes and update the
+		 * transfer size register.
+		 */
+		if (!avail_bytes) {
+			if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
+				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
+						CDNS_I2C_XFER_SIZE_OFFSET);
+			else
+				cdns_i2c_writereg(id->recv_count,
+						CDNS_I2C_XFER_SIZE_OFFSET);
+		}
+
+		/* Process the data received */
+		while (bytes_to_recv--)
+			*(id->p_recv_buf)++ =
+				cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
+
+		if (!id->bus_hold_flag &&
+				(id->recv_count <= CDNS_I2C_FIFO_DEPTH))
+			cdns_i2c_clear_bus_hold(id);
+
+		status = IRQ_HANDLED;
+	}
+
+	/* Handling Transfer Complete interrupt */
+	if (isr_status & CDNS_I2C_IXR_COMP) {
+		if (!id->p_recv_buf) {
+			/*
+			 * If the device is sending data If there is further
+			 * data to be sent. Calculate the available space
+			 * in FIFO and fill the FIFO with that many bytes.
+			 */
+			if (id->send_count) {
+				avail_bytes = CDNS_I2C_FIFO_DEPTH -
+				    cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
+				if (id->send_count > avail_bytes)
+					bytes_to_send = avail_bytes;
+				else
+					bytes_to_send = id->send_count;
+
+				while (bytes_to_send--) {
+					cdns_i2c_writereg(
+						(*(id->p_send_buf)++),
+						 CDNS_I2C_DATA_OFFSET);
+					id->send_count--;
+				}
+			} else {
+				/*
+				 * Signal the completion of transaction and
+				 * clear the hold bus bit if there are no
+				 * further messages to be processed.
+				 */
+				done_flag = 1;
+			}
+			if (!id->send_count && !id->bus_hold_flag)
+				cdns_i2c_clear_bus_hold(id);
+		} else {
+			if (!id->bus_hold_flag)
+				cdns_i2c_clear_bus_hold(id);
+			/*
+			 * If the device is receiving data, then signal
+			 * the completion of transaction and read the data
+			 * present in the FIFO. Signal the completion of
+			 * transaction.
+			 */
+			while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
+					CDNS_I2C_SR_RXDV) {
+				*(id->p_recv_buf)++ =
+					cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
+				id->recv_count--;
+			}
+			done_flag = 1;
+		}
+
+		status = IRQ_HANDLED;
+	}
+
+	/* Update the status for errors */
+	id->err_status = isr_status & CDNS_I2C_IXR_ERR_INTR_MASK;
+	if (id->err_status)
+		status = IRQ_HANDLED;
+
+	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
+
+	if (done_flag)
+		complete(&id->xfer_done);
+
+	return status;
+}
+
+/**
+ * cdns_i2c_mrecv - Prepare and start a master receive operation
+ * @id:		pointer to the i2c device structure
+ */
+static void cdns_i2c_mrecv(struct cdns_i2c *id)
+{
+	unsigned int ctrl_reg;
+	unsigned int isr_status;
+
+	id->p_recv_buf = id->p_msg->buf;
+	id->recv_count = id->p_msg->len;
+
+	/* Put the controller in master receive mode and clear the FIFO */
+	ctrl_reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+	ctrl_reg |= CDNS_I2C_CR_RW | CDNS_I2C_CR_CLR_FIFO;
+
+	if ((id->p_msg->flags & I2C_M_RECV_LEN) == I2C_M_RECV_LEN)
+		id->recv_count = I2C_SMBUS_BLOCK_MAX + 1;
+
+	/*
+	 * Check for the message size against FIFO depth and set the
+	 * 'hold bus' bit if it is greater than FIFO depth.
+	 */
+	if (id->recv_count > CDNS_I2C_FIFO_DEPTH)
+		ctrl_reg |= CDNS_I2C_CR_HOLD;
+
+	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
+
+	/* Clear the interrupts in interrupt status register */
+	isr_status = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
+	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
+
+	/*
+	 * The no. of bytes to receive is checked against the limit of
+	 * max transfer size. Set transfer size register with no of bytes
+	 * receive if it is less than transfer size and transfer size if
+	 * it is more. Enable the interrupts.
+	 */
+	if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
+		cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
+				  CDNS_I2C_XFER_SIZE_OFFSET);
+	else
+		cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);
+	/* Clear the bus hold flag if bytes to receive is less than FIFO size */
+	if (!id->bus_hold_flag &&
+		((id->p_msg->flags & I2C_M_RECV_LEN) != I2C_M_RECV_LEN) &&
+		(id->recv_count <= CDNS_I2C_FIFO_DEPTH))
+			cdns_i2c_clear_bus_hold(id);
+	/* Set the slave address in address register - triggers operation */
+	cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
+						CDNS_I2C_ADDR_OFFSET);
+	cdns_i2c_writereg(CDNS_I2C_ENABLED_INTR_MASK, CDNS_I2C_IER_OFFSET);
+}
+
+/**
+ * cdns_i2c_msend - Prepare and start a master send operation
+ * @id:		pointer to the i2c device
+ */
+static void cdns_i2c_msend(struct cdns_i2c *id)
+{
+	unsigned int avail_bytes;
+	unsigned int bytes_to_send;
+	unsigned int ctrl_reg;
+	unsigned int isr_status;
+
+	id->p_recv_buf = NULL;
+	id->p_send_buf = id->p_msg->buf;
+	id->send_count = id->p_msg->len;
+
+	/* Set the controller in Master transmit mode and clear the FIFO. */
+	ctrl_reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+	ctrl_reg &= ~CDNS_I2C_CR_RW;
+	ctrl_reg |= CDNS_I2C_CR_CLR_FIFO;
+
+	/*
+	 * Check for the message size against FIFO depth and set the
+	 * 'hold bus' bit if it is greater than FIFO depth.
+	 */
+	if (id->send_count > CDNS_I2C_FIFO_DEPTH)
+		ctrl_reg |= CDNS_I2C_CR_HOLD;
+	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
+
+	/* Clear the interrupts in interrupt status register. */
+	isr_status = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
+	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
+
+	/*
+	 * Calculate the space available in FIFO. Check the message length
+	 * against the space available, and fill the FIFO accordingly.
+	 * Enable the interrupts.
+	 */
+	avail_bytes = CDNS_I2C_FIFO_DEPTH -
+				cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
+
+	if (id->send_count > avail_bytes)
+		bytes_to_send = avail_bytes;
+	else
+		bytes_to_send = id->send_count;
+
+	while (bytes_to_send--) {
+		cdns_i2c_writereg((*(id->p_send_buf)++), CDNS_I2C_DATA_OFFSET);
+		id->send_count--;
+	}
+
+	/*
+	 * Clear the bus hold flag if there is no more data
+	 * and if it is the last message.
+	 */
+	if (!id->bus_hold_flag && !id->send_count)
+		cdns_i2c_clear_bus_hold(id);
+	/* Set the slave address in address register - triggers operation. */
+	cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
+						CDNS_I2C_ADDR_OFFSET);
+
+	cdns_i2c_writereg(CDNS_I2C_ENABLED_INTR_MASK, CDNS_I2C_IER_OFFSET);
+}
+
+/**
+ * cdns_i2c_master_reset - Reset the interface
+ * @adap:	pointer to the i2c adapter driver instance
+ *
+ * This function cleanup the fifos, clear the hold bit and status
+ * and disable the interrupts.
+ */
+static void cdns_i2c_master_reset(struct i2c_adapter *adap)
+{
+	struct cdns_i2c *id = adap->algo_data;
+	u32 regval;
+
+	/* Disable the interrupts */
+	cdns_i2c_writereg(CDNS_I2C_IXR_ALL_INTR_MASK, CDNS_I2C_IDR_OFFSET);
+	/* Clear the hold bit and fifos */
+	regval = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+	regval &= ~CDNS_I2C_CR_HOLD;
+	regval |= CDNS_I2C_CR_CLR_FIFO;
+	cdns_i2c_writereg(regval, CDNS_I2C_CR_OFFSET);
+	/* Update the transfercount register to zero */
+	cdns_i2c_writereg(0, CDNS_I2C_XFER_SIZE_OFFSET);
+	/* Clear the interupt status register */
+	regval = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
+	cdns_i2c_writereg(regval, CDNS_I2C_ISR_OFFSET);
+	/* Clear the status register */
+	regval = cdns_i2c_readreg(CDNS_I2C_SR_OFFSET);
+	cdns_i2c_writereg(regval, CDNS_I2C_SR_OFFSET);
+}
+
+static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
+		struct i2c_adapter *adap)
+{
+	int ret;
+	u32 reg;
+
+	id->p_msg = msg;
+	id->err_status = 0;
+	reinit_completion(&id->xfer_done);
+
+	/* Check for the TEN Bit mode on each msg */
+	reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+	if (msg->flags & I2C_M_TEN) {
+		if (reg & CDNS_I2C_CR_NEA)
+			cdns_i2c_writereg(reg & ~CDNS_I2C_CR_NEA,
+					CDNS_I2C_CR_OFFSET);
+	} else {
+		if (!(reg & CDNS_I2C_CR_NEA))
+			cdns_i2c_writereg(reg | CDNS_I2C_CR_NEA,
+					CDNS_I2C_CR_OFFSET);
+	}
+
+	/* Check for the R/W flag on each msg */
+	if (msg->flags & I2C_M_RD)
+		cdns_i2c_mrecv(id);
+	else
+		cdns_i2c_msend(id);
+
+	/* Wait for the signal of completion */
+	ret = wait_for_completion_timeout(&id->xfer_done, adap->timeout);
+	if (!ret) {
+		cdns_i2c_master_reset(adap);
+		dev_err(id->adap.dev.parent,
+				"timeout waiting on completion\n");
+		return -ETIMEDOUT;
+	}
+
+	cdns_i2c_writereg(CDNS_I2C_IXR_ALL_INTR_MASK,
+			  CDNS_I2C_IDR_OFFSET);
+
+	/* If it is bus arbitration error, try again */
+	if (id->err_status & CDNS_I2C_IXR_ARB_LOST)
+		return -EAGAIN;
+
+	return 0;
+}
+
+/**
+ * cdns_i2c_master_xfer - The main i2c transfer function
+ * @adap:	pointer to the i2c adapter driver instance
+ * @msgs:	pointer to the i2c message structure
+ * @num:	the number of messages to transfer
+ *
+ * Initiates the send/recv activity based on the transfer message received.
+ *
+ * Return: number of msgs processed on success, negative error otherwise
+ */
+static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
+				int num)
+{
+	int ret, count;
+	u32 reg;
+	struct cdns_i2c *id = adap->algo_data;
+
+	/* Check if the bus is free */
+	if (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) & CDNS_I2C_SR_BA)
+		return -EAGAIN;
+
+	/*
+	 * Set the flag to one when multiple messages are to be
+	 * processed with a repeated start.
+	 */
+	if (num > 1) {
+		id->bus_hold_flag = 1;
+		reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+		reg |= CDNS_I2C_CR_HOLD;
+		cdns_i2c_writereg(reg, CDNS_I2C_CR_OFFSET);
+	} else {
+		id->bus_hold_flag = 0;
+	}
+
+	/* Process the msg one by one */
+	for (count = 0; count < num; count++, msgs++) {
+		if (count == (num - 1))
+			id->bus_hold_flag = 0;
+
+		ret = cdns_i2c_process_msg(id, msgs, adap);
+		if (ret)
+			return ret;
+
+		/* Report the other error interrupts to application as EIO */
+		if (id->err_status & (CDNS_I2C_IXR_RX_UNF |
+				      CDNS_I2C_IXR_TX_OVF |
+				      CDNS_I2C_IXR_RX_OVF |
+				      CDNS_I2C_IXR_NACK)) {
+			cdns_i2c_master_reset(adap);
+			return -EIO;
+		}
+	}
+
+	return num;
+}
+
+/**
+ * cdns_i2c_func - Returns the supported features of the I2C driver
+ * @adap:	pointer to the i2c adapter structure
+ *
+ * Return: 32 bit value, each bit corresponding to a feature
+ */
+static u32 cdns_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR |
+		(I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK) |
+		I2C_FUNC_SMBUS_BLOCK_DATA;
+}
+
+static const struct i2c_algorithm cdns_i2c_algo = {
+	.master_xfer	= cdns_i2c_master_xfer,
+	.functionality	= cdns_i2c_func,
+};
+
+/**
+ * cdns_i2c_calc_divs - Calculate clock dividers
+ * @f:		I2C clock frequency
+ * @input_clk:	Input clock frequency
+ * @a:		First divider (return value)
+ * @b:		Second divider (return value)
+ *
+ * f is used as input and output variable. As input it is used as target I2C
+ * frequency. On function exit f holds the actually resulting I2C frequency.
+ *
+ * Return: 0 on success, negative errno otherwise.
+ */
+static int cdns_i2c_calc_divs(unsigned long *f, unsigned long input_clk,
+		unsigned int *a, unsigned int *b)
+{
+	unsigned long fscl = *f, best_fscl = *f, actual_fscl, temp;
+	unsigned int div_a, div_b, calc_div_a = 0, calc_div_b = 0;
+	unsigned int last_error, current_error;
+
+	/* calculate (divisor_a+1) x (divisor_b+1) */
+	temp = input_clk / (22 * fscl);
+
+	/*
+	 * If the calculated value is negative or 0, the fscl input is out of
+	 * range. Return error.
+	 */
+	if (!temp || (temp > (CDNS_I2C_DIVA_MAX * CDNS_I2C_DIVB_MAX)))
+		return -EINVAL;
+
+	last_error = -1;
+	for (div_a = 0; div_a < CDNS_I2C_DIVA_MAX; div_a++) {
+		div_b = DIV_ROUND_UP(input_clk, 22 * fscl * (div_a + 1));
+
+		if ((div_b < 1) || (div_b > CDNS_I2C_DIVB_MAX))
+			continue;
+		div_b--;
+
+		actual_fscl = input_clk / (22 * (div_a + 1) * (div_b + 1));
+
+		if (actual_fscl > fscl)
+			continue;
+
+		current_error = ((actual_fscl > fscl) ? (actual_fscl - fscl) :
+							(fscl - actual_fscl));
+
+		if (last_error > current_error) {
+			calc_div_a = div_a;
+			calc_div_b = div_b;
+			best_fscl = actual_fscl;
+			last_error = current_error;
+		}
+	}
+
+	*a = calc_div_a;
+	*b = calc_div_b;
+	*f = best_fscl;
+
+	return 0;
+}
+
+/**
+ * cdns_i2c_setclk - This function sets the serial clock rate for the I2C device
+ * @clk_in:	I2C clock input frequency in Hz
+ * @id:		Pointer to the I2C device structure
+ *
+ * The device must be idle rather than busy transferring data before setting
+ * these device options.
+ * The data rate is set by values in the control register.
+ * The formula for determining the correct register values is
+ *	Fscl = Fpclk/(22 x (divisor_a+1) x (divisor_b+1))
+ * See the hardware data sheet for a full explanation of setting the serial
+ * clock rate. The clock can not be faster than the input clock divide by 22.
+ * The two most common clock rates are 100KHz and 400KHz.
+ *
+ * Return: 0 on success, negative error otherwise
+ */
+static int cdns_i2c_setclk(unsigned long clk_in, struct cdns_i2c *id)
+{
+	unsigned int div_a, div_b;
+	unsigned int ctrl_reg;
+	int ret = 0;
+	unsigned long fscl = id->i2c_clk;
+
+	ret = cdns_i2c_calc_divs(&fscl, clk_in, &div_a, &div_b);
+	if (ret)
+		return ret;
+
+	ctrl_reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
+	ctrl_reg &= ~(CDNS_I2C_CR_DIVA_MASK | CDNS_I2C_CR_DIVB_MASK);
+	ctrl_reg |= ((div_a << CDNS_I2C_CR_DIVA_SHIFT) |
+			(div_b << CDNS_I2C_CR_DIVB_SHIFT));
+	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
+
+	return 0;
+}
+
+/**
+ * cdns_i2c_clk_notifier_cb - Clock rate change callback
+ * @nb:		Pointer to notifier block
+ * @event:	Notification reason
+ * @data:	Pointer to notification data object
+ *
+ * This function is called when the cdns_i2c input clock frequency changes.
+ * The callback checks whether a valid bus frequency can be generated after the
+ * change. If so, the change is acknowledged, otherwise the change is aborted.
+ * New dividers are written to the HW in the pre- or post change notification
+ * depending on the scaling direction.
+ *
+ * Return:	NOTIFY_STOP if the rate change should be aborted, NOTIFY_OK
+ *		to acknowedge the change, NOTIFY_DONE if the notification is
+ *		considered irrelevant.
+ */
+static int cdns_i2c_clk_notifier_cb(struct notifier_block *nb, unsigned long
+		event, void *data)
+{
+	struct clk_notifier_data *ndata = data;
+	struct cdns_i2c *id = to_cdns_i2c(nb);
+
+	if (id->suspended)
+		return NOTIFY_OK;
+
+	switch (event) {
+	case PRE_RATE_CHANGE:
+	{
+		unsigned long input_clk = ndata->new_rate;
+		unsigned long fscl = id->i2c_clk;
+		unsigned int div_a, div_b;
+		int ret;
+
+		ret = cdns_i2c_calc_divs(&fscl, input_clk, &div_a, &div_b);
+		if (ret) {
+			dev_warn(id->adap.dev.parent,
+					"clock rate change rejected\n");
+			return NOTIFY_STOP;
+		}
+
+		/* scale up */
+		if (ndata->new_rate > ndata->old_rate)
+			cdns_i2c_setclk(ndata->new_rate, id);
+
+		return NOTIFY_OK;
+	}
+	case POST_RATE_CHANGE:
+		id->input_clk = ndata->new_rate;
+		/* scale down */
+		if (ndata->new_rate < ndata->old_rate)
+			cdns_i2c_setclk(ndata->new_rate, id);
+		return NOTIFY_OK;
+	case ABORT_RATE_CHANGE:
+		/* scale up */
+		if (ndata->new_rate > ndata->old_rate)
+			cdns_i2c_setclk(ndata->old_rate, id);
+		return NOTIFY_OK;
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+/**
+ * cdns_i2c_suspend - Suspend method for the driver
+ * @_dev:	Address of the platform_device structure
+ *
+ * Put the driver into low power mode.
+ *
+ * Return: 0 always
+ */
+static int __maybe_unused cdns_i2c_suspend(struct device *_dev)
+{
+	struct platform_device *pdev = container_of(_dev,
+			struct platform_device, dev);
+	struct cdns_i2c *xi2c = platform_get_drvdata(pdev);
+
+	clk_disable(xi2c->clk);
+	xi2c->suspended = 1;
+
+	return 0;
+}
+
+/**
+ * cdns_i2c_resume - Resume from suspend
+ * @_dev:	Address of the platform_device structure
+ *
+ * Resume operation after suspend.
+ *
+ * Return: 0 on success and error value on error
+ */
+static int __maybe_unused cdns_i2c_resume(struct device *_dev)
+{
+	struct platform_device *pdev = container_of(_dev,
+			struct platform_device, dev);
+	struct cdns_i2c *xi2c = platform_get_drvdata(pdev);
+	int ret;
+
+	ret = clk_enable(xi2c->clk);
+	if (ret) {
+		dev_err(_dev, "Cannot enable clock.\n");
+		return ret;
+	}
+
+	xi2c->suspended = 0;
+
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(cdns_i2c_dev_pm_ops, cdns_i2c_suspend,
+			 cdns_i2c_resume);
+
+/**
+ * cdns_i2c_probe - Platform registration call
+ * @pdev:	Handle to the platform device structure
+ *
+ * This function does all the memory allocation and registration for the i2c
+ * device. User can modify the address mode to 10 bit address mode using the
+ * ioctl call with option I2C_TENBIT.
+ *
+ * Return: 0 on success, negative error otherwise
+ */
+static int cdns_i2c_probe(struct platform_device *pdev)
+{
+	struct resource *r_mem;
+	struct cdns_i2c *id;
+	int ret;
+
+	id = devm_kzalloc(&pdev->dev, sizeof(*id), GFP_KERNEL);
+	if (!id)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, id);
+
+	r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	id->membase = devm_ioremap_resource(&pdev->dev, r_mem);
+	if (IS_ERR(id->membase))
+		return PTR_ERR(id->membase);
+
+	id->irq = platform_get_irq(pdev, 0);
+
+	id->adap.dev.of_node = pdev->dev.of_node;
+	id->adap.algo = &cdns_i2c_algo;
+	id->adap.timeout = CDNS_I2C_TIMEOUT;
+	id->adap.retries = 3;		/* Default retry value. */
+	id->adap.algo_data = id;
+	id->adap.dev.parent = &pdev->dev;
+	init_completion(&id->xfer_done);
+	snprintf(id->adap.name, sizeof(id->adap.name),
+		 "Cadence I2C at %08lx", (unsigned long)r_mem->start);
+
+	id->clk = devm_clk_get(&pdev->dev, NULL);
+	if (IS_ERR(id->clk)) {
+		dev_err(&pdev->dev, "input clock not found.\n");
+		return PTR_ERR(id->clk);
+	}
+	ret = clk_prepare_enable(id->clk);
+	if (ret) {
+		dev_err(&pdev->dev, "Unable to enable clock.\n");
+		return ret;
+	}
+	id->clk_rate_change_nb.notifier_call = cdns_i2c_clk_notifier_cb;
+	if (clk_notifier_register(id->clk, &id->clk_rate_change_nb))
+		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
+	id->input_clk = clk_get_rate(id->clk);
+
+	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency",
+			&id->i2c_clk);
+	if (ret || (id->i2c_clk > CDNS_I2C_SPEED_MAX))
+		id->i2c_clk = CDNS_I2C_SPEED_MAX;
+
+	cdns_i2c_writereg(CDNS_I2C_CR_ACK_EN | CDNS_I2C_CR_NEA | CDNS_I2C_CR_MS,
+			  CDNS_I2C_CR_OFFSET);
+
+	ret = cdns_i2c_setclk(id->input_clk, id);
+	if (ret) {
+		dev_err(&pdev->dev, "invalid SCL clock: %u Hz\n", id->i2c_clk);
+		ret = -EINVAL;
+		goto err_clk_dis;
+	}
+
+	ret = devm_request_irq(&pdev->dev, id->irq, cdns_i2c_isr, 0,
+				 DRIVER_NAME, id);
+	if (ret) {
+		dev_err(&pdev->dev, "cannot get irq %d\n", id->irq);
+		goto err_clk_dis;
+	}
+
+	ret = i2c_add_adapter(&id->adap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "reg adap failed: %d\n", ret);
+		goto err_clk_dis;
+	}
+
+	dev_info(&pdev->dev, "%u kHz mmio %08lx irq %d\n",
+		 id->i2c_clk / 1000, (unsigned long)r_mem->start, id->irq);
+
+	return 0;
+
+err_clk_dis:
+	clk_disable_unprepare(id->clk);
+	return ret;
+}
+
+/**
+ * cdns_i2c_remove - Unregister the device after releasing the resources
+ * @pdev:	Handle to the platform device structure
+ *
+ * This function frees all the resources allocated to the device.
+ *
+ * Return: 0 always
+ */
+static int cdns_i2c_remove(struct platform_device *pdev)
+{
+	struct cdns_i2c *id = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&id->adap);
+	clk_notifier_unregister(id->clk, &id->clk_rate_change_nb);
+	clk_disable_unprepare(id->clk);
+
+	return 0;
+}
+
+static const struct of_device_id cdns_i2c_of_match[] = {
+	{ .compatible = "cdns,i2c-r1p10", },
+	{ /* end of table */ }
+};
+MODULE_DEVICE_TABLE(of, cdns_i2c_of_match);
+
+static struct platform_driver cdns_i2c_drv = {
+	.driver = {
+		.name  = DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = cdns_i2c_of_match,
+		.pm = &cdns_i2c_dev_pm_ops,
+	},
+	.probe  = cdns_i2c_probe,
+	.remove = cdns_i2c_remove,
+};
+
+module_platform_driver(cdns_i2c_drv);
+
+MODULE_AUTHOR("Xilinx Inc.");
+MODULE_DESCRIPTION("Cadence I2C bus driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1.1.gbb9f595

