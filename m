Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab3HPSKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:10:16 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39850 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab3HPSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:10:08 -0400
Message-Id: <2b97e8deb412ae0087bffe227690a26ea9dd9bba.1376596224.git.joshc@codeaurora.org>
In-Reply-To: <cover.1376596224.git.joshc@codeaurora.org>
References: <cover.1376596224.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Fri, 9 Aug 2013 13:37:07 -0700
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH RFC 2/3] spmi: Add MSM PMIC Arbiter SPMI controller
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenneth Heitke <kheitke@codeaurora.org>

Qualcomm's PMIC Arbiter SPMI controller functions as a bus master and
is used to communication with one or more PMIC (slave) devices on the
SPMI bus.  The PMIC Arbiter is actually a hardware wrapper around the
SPMI controller that provides concurrent and autonomous PMIC access
to various entities that need to communicate with the PMIC.

The SPMI controller hardware handles all of the SPMI bus activity (bus
arbitration, sequence start condition, transmission of frames, etc).
This software driver uses the PMIC Arbiter register interface to
initiate command sequences on the SPMI bus.  The status register is
read to determine when the command sequence has completed and whether
or not it completed successfully.

Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
---
 drivers/spmi/Kconfig         |  15 ++
 drivers/spmi/Makefile        |   2 +
 drivers/spmi/spmi-pmic-arb.c | 499 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 516 insertions(+)
 create mode 100644 drivers/spmi/spmi-pmic-arb.c

diff --git a/drivers/spmi/Kconfig b/drivers/spmi/Kconfig
index a03835f..056891d 100644
--- a/drivers/spmi/Kconfig
+++ b/drivers/spmi/Kconfig
@@ -7,3 +7,18 @@ menuconfig SPMI
 	  SPMI (System Power Management Interface) is a two-wire
 	  serial interface between baseband and application processors
 	  and Power Management Integrated Circuits (PMIC).
+
+if SPMI
+
+config SPMI_MSM_PMIC_ARB
+	tristate "Qualcomm MSM SPMI Controller (PMIC Arbiter)"
+	depends on ARCH_MSM
+	help
+	  If you say yes to this option, support will be included for the
+	  built-in SPMI PMIC Arbiter interface on Qualcomm MSM family
+	  processors.
+
+	  This is required for communicating with Qualcomm PMICs and
+	  other devices that have the SPMI interface.
+
+endif
diff --git a/drivers/spmi/Makefile b/drivers/spmi/Makefile
index ef96afd..f83ea87 100644
--- a/drivers/spmi/Makefile
+++ b/drivers/spmi/Makefile
@@ -5,3 +5,5 @@ obj-$(CONFIG_SPMI)	+= spmi-core.o
 
 spmi-core-y			+= spmi.o
 spmi-core-$(CONFIG_DEBUG_FS)	+= spmi-dbgfs.o
+
+obj-$(CONFIG_SPMI_MSM_PMIC_ARB)	+= spmi-pmic-arb.o
diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
new file mode 100644
index 0000000..ebc0038
--- /dev/null
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -0,0 +1,499 @@
+/* Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#define pr_fmt(fmt) "%s: " fmt, __func__
+
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/spmi.h>
+#include <linux/of.h>
+#include <linux/interrupt.h>
+#include <linux/of_spmi.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+#include "spmi-dbgfs.h"
+
+#define SPMI_PMIC_ARB_NAME		"spmi_pmic_arb"
+
+/* PMIC Arbiter configuration registers */
+#define PMIC_ARB_VERSION		0x0000
+#define PMIC_ARB_INT_EN			0x0004
+
+/* PMIC Arbiter channel registers */
+#define PMIC_ARB_CMD(N)			(0x0800 + (0x80 * (N)))
+#define PMIC_ARB_CONFIG(N)		(0x0804 + (0x80 * (N)))
+#define PMIC_ARB_STATUS(N)		(0x0808 + (0x80 * (N)))
+#define PMIC_ARB_WDATA0(N)		(0x0810 + (0x80 * (N)))
+#define PMIC_ARB_WDATA1(N)		(0x0814 + (0x80 * (N)))
+#define PMIC_ARB_RDATA0(N)		(0x0818 + (0x80 * (N)))
+#define PMIC_ARB_RDATA1(N)		(0x081C + (0x80 * (N)))
+
+/* Interrupt Controller */
+#define SPMI_PIC_OWNER_ACC_STATUS(M, N)	(0x0000 + ((32 * (M)) + (4 * (N))))
+#define SPMI_PIC_ACC_ENABLE(N)		(0x0200 + (4 * (N)))
+#define SPMI_PIC_IRQ_STATUS(N)		(0x0600 + (4 * (N)))
+#define SPMI_PIC_IRQ_CLEAR(N)		(0x0A00 + (4 * (N)))
+
+/* Mapping Table */
+#define SPMI_MAPPING_TABLE_REG(N)	(0x0B00 + (4 * (N)))
+#define SPMI_MAPPING_BIT_INDEX(X)	(((X) >> 18) & 0xF)
+#define SPMI_MAPPING_BIT_IS_0_FLAG(X)	(((X) >> 17) & 0x1)
+#define SPMI_MAPPING_BIT_IS_0_RESULT(X)	(((X) >> 9) & 0xFF)
+#define SPMI_MAPPING_BIT_IS_1_FLAG(X)	(((X) >> 8) & 0x1)
+#define SPMI_MAPPING_BIT_IS_1_RESULT(X)	(((X) >> 0) & 0xFF)
+
+#define SPMI_MAPPING_TABLE_LEN		255
+#define SPMI_MAPPING_TABLE_TREE_DEPTH	16	/* Maximum of 16-bits */
+
+/* Ownership Table */
+#define SPMI_OWNERSHIP_TABLE_REG(N)	(0x0700 + (4 * (N)))
+#define SPMI_OWNERSHIP_PERIPH2OWNER(X)	((X) & 0x7)
+
+/* Channel Status fields */
+enum pmic_arb_chnl_status {
+	PMIC_ARB_STATUS_DONE	= (1 << 0),
+	PMIC_ARB_STATUS_FAILURE	= (1 << 1),
+	PMIC_ARB_STATUS_DENIED	= (1 << 2),
+	PMIC_ARB_STATUS_DROPPED	= (1 << 3),
+};
+
+/* Command register fields */
+#define PMIC_ARB_CMD_MAX_BYTE_COUNT	8
+
+/* Command Opcodes */
+enum pmic_arb_cmd_op_code {
+	PMIC_ARB_OP_EXT_WRITEL = 0,
+	PMIC_ARB_OP_EXT_READL = 1,
+	PMIC_ARB_OP_EXT_WRITE = 2,
+	PMIC_ARB_OP_RESET = 3,
+	PMIC_ARB_OP_SLEEP = 4,
+	PMIC_ARB_OP_SHUTDOWN = 5,
+	PMIC_ARB_OP_WAKEUP = 6,
+	PMIC_ARB_OP_AUTHENTICATE = 7,
+	PMIC_ARB_OP_MSTR_READ = 8,
+	PMIC_ARB_OP_MSTR_WRITE = 9,
+	PMIC_ARB_OP_EXT_READ = 13,
+	PMIC_ARB_OP_WRITE = 14,
+	PMIC_ARB_OP_READ = 15,
+	PMIC_ARB_OP_ZERO_WRITE = 16,
+};
+
+/* Maximum number of support PMIC peripherals */
+#define PMIC_ARB_MAX_PERIPHS		256
+#define PMIC_ARB_PERIPH_ID_VALID	(1 << 15)
+#define PMIC_ARB_TIMEOUT_US		100
+#define PMIC_ARB_MAX_TRANS_BYTES	(8)
+
+#define PMIC_ARB_APID_MASK		0xFF
+#define PMIC_ARB_PPID_MASK		0xFFF
+
+/* interrupt enable bit */
+#define SPMI_PIC_ACC_ENABLE_BIT		BIT(0)
+
+/**
+ * base - base address of the PMIC Arbiter core registers.
+ * intr - base address of the SPMI interrupt control registers
+ */
+struct spmi_pmic_arb_dev {
+	struct spmi_controller	controller;
+	struct device		*dev;
+	struct device		*slave;
+	void __iomem		*base;
+	void __iomem		*intr;
+	void __iomem		*cnfg;
+	bool			allow_wakeup;
+	spinlock_t		lock;
+	u8			channel;
+	u8			min_apid;
+	u8			max_apid;
+	u16			periph_id_map[PMIC_ARB_MAX_PERIPHS];
+	u32			mapping_table[SPMI_MAPPING_TABLE_LEN];
+};
+
+static u32 pmic_arb_read(struct spmi_pmic_arb_dev *dev, u32 offset)
+{
+	u32 val = readl_relaxed(dev->base + offset);
+	pr_debug("address 0x%p, val 0x%x\n", dev->base + offset, val);
+	return val;
+}
+
+static void pmic_arb_write(struct spmi_pmic_arb_dev *dev, u32 offset, u32 val)
+{
+	pr_debug("address 0x%p, val 0x%x\n", dev->base + offset, val);
+	writel_relaxed(val, dev->base + offset);
+}
+
+static int pmic_arb_wait_for_done(struct spmi_pmic_arb_dev *dev)
+{
+	u32 status = 0;
+	u32 timeout = PMIC_ARB_TIMEOUT_US;
+	u32 offset = PMIC_ARB_STATUS(dev->channel);
+
+	while (timeout--) {
+		status = pmic_arb_read(dev, offset);
+
+		if (status & PMIC_ARB_STATUS_DONE) {
+			if (status & PMIC_ARB_STATUS_DENIED) {
+				dev_err(dev->dev,
+					"%s: transaction denied (0x%x)\n",
+					__func__, status);
+				return -EPERM;
+			}
+
+			if (status & PMIC_ARB_STATUS_FAILURE) {
+				dev_err(dev->dev,
+					"%s: transaction failed (0x%x)\n",
+					__func__, status);
+				return -EIO;
+			}
+
+			if (status & PMIC_ARB_STATUS_DROPPED) {
+				dev_err(dev->dev,
+					"%s: transaction dropped (0x%x)\n",
+					__func__, status);
+				return -EIO;
+			}
+
+			return 0;
+		}
+		udelay(1);
+	}
+
+	dev_err(dev->dev, "%s: timeout, status 0x%x\n", __func__, status);
+	return -ETIMEDOUT;
+}
+
+/**
+ * pa_read_data: reads pmic-arb's register and copy 1..4 bytes to buf
+ * @bc byte count -1. range: 0..3
+ * @reg register's address
+ * @buf output parameter, length must be bc+1
+ */
+static void pa_read_data(struct spmi_pmic_arb_dev *dev, u8 *buf, u32 reg, u8 bc)
+{
+	u32 data = pmic_arb_read(dev, reg);
+	memcpy(buf, &data, (bc & 3) + 1);
+}
+
+/**
+ * pa_write_data: write 1..4 bytes from buf to pmic-arb's register
+ * @bc byte-count -1. range: 0..3
+ * @reg register's address
+ * @buf buffer to write. length must be bc+1
+ */
+static void
+pa_write_data(struct spmi_pmic_arb_dev *dev, u8 *buf, u32 reg, u8 bc)
+{
+	u32 data = 0;
+	memcpy(&data, buf, (bc & 3) + 1);
+	pmic_arb_write(dev, reg, data);
+}
+
+/* Non-data command */
+static int pmic_arb_cmd(struct spmi_controller *ctrl, u8 opc, u8 sid)
+{
+	struct spmi_pmic_arb_dev *pmic_arb = spmi_get_ctrldata(ctrl);
+	unsigned long flags;
+	u32 cmd;
+	int rc;
+
+	pr_debug("op:0x%x sid:%d\n", opc, sid);
+
+	/* Check for valid non-data command */
+	if (opc < SPMI_CMD_RESET || opc > SPMI_CMD_WAKEUP)
+		return -EINVAL;
+
+	cmd = ((opc | 0x40) << 27) | ((sid & 0xf) << 20);
+
+	spin_lock_irqsave(&pmic_arb->lock, flags);
+	pmic_arb_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
+	rc = pmic_arb_wait_for_done(pmic_arb);
+	spin_unlock_irqrestore(&pmic_arb->lock, flags);
+
+	return rc;
+}
+
+static int pmic_arb_read_cmd(struct spmi_controller *ctrl,
+				u8 opc, u8 sid, u16 addr, u8 bc, u8 *buf)
+{
+	struct spmi_pmic_arb_dev *pmic_arb = spmi_get_ctrldata(ctrl);
+	unsigned long flags;
+	u32 cmd;
+	int rc;
+
+	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
+		dev_err(pmic_arb->dev
+		, "pmic-arb supports 1..%d bytes per trans, but:%d requested"
+					, PMIC_ARB_MAX_TRANS_BYTES, bc+1);
+		return  -EINVAL;
+	}
+	pr_debug("op:0x%x sid:%d bc:%d addr:0x%x\n", opc, sid, bc, addr);
+
+	/* Check the opcode */
+	if (opc >= 0x60 && opc <= 0x7F)
+		opc = PMIC_ARB_OP_READ;
+	else if (opc >= 0x20 && opc <= 0x2F)
+		opc = PMIC_ARB_OP_EXT_READ;
+	else if (opc >= 0x38 && opc <= 0x3F)
+		opc = PMIC_ARB_OP_EXT_READL;
+	else
+		return -EINVAL;
+
+	cmd = (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
+
+	spin_lock_irqsave(&pmic_arb->lock, flags);
+	pmic_arb_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
+	rc = pmic_arb_wait_for_done(pmic_arb);
+	if (rc)
+		goto done;
+
+	/* Read from FIFO, note 'bc' is actually number of bytes minus 1 */
+	pa_read_data(pmic_arb, buf, PMIC_ARB_RDATA0(pmic_arb->channel)
+							, min_t(u8, bc, 3));
+
+	if (bc > 3)
+		pa_read_data(pmic_arb, buf + 4,
+				PMIC_ARB_RDATA1(pmic_arb->channel), bc - 4);
+
+done:
+	spin_unlock_irqrestore(&pmic_arb->lock, flags);
+	return rc;
+}
+
+static int pmic_arb_write_cmd(struct spmi_controller *ctrl,
+				u8 opc, u8 sid, u16 addr, u8 bc, u8 *buf)
+{
+	struct spmi_pmic_arb_dev *pmic_arb = spmi_get_ctrldata(ctrl);
+	unsigned long flags;
+	u32 cmd;
+	int rc;
+
+	if (bc >= PMIC_ARB_MAX_TRANS_BYTES) {
+		dev_err(pmic_arb->dev
+		, "pmic-arb supports 1..%d bytes per trans, but:%d requested"
+					, PMIC_ARB_MAX_TRANS_BYTES, bc+1);
+		return  -EINVAL;
+	}
+	pr_debug("op:0x%x sid:%d bc:%d addr:0x%x\n", opc, sid, bc, addr);
+
+	/* Check the opcode */
+	if (opc >= 0x40 && opc <= 0x5F)
+		opc = PMIC_ARB_OP_WRITE;
+	else if (opc >= 0x00 && opc <= 0x0F)
+		opc = PMIC_ARB_OP_EXT_WRITE;
+	else if (opc >= 0x30 && opc <= 0x37)
+		opc = PMIC_ARB_OP_EXT_WRITEL;
+	else if (opc >= 0x80 && opc <= 0xFF)
+		opc = PMIC_ARB_OP_ZERO_WRITE;
+	else
+		return -EINVAL;
+
+	cmd = (opc << 27) | ((sid & 0xf) << 20) | (addr << 4) | (bc & 0x7);
+
+	/* Write data to FIFOs */
+	spin_lock_irqsave(&pmic_arb->lock, flags);
+	pa_write_data(pmic_arb, buf, PMIC_ARB_WDATA0(pmic_arb->channel)
+							, min_t(u8, bc, 3));
+	if (bc > 3)
+		pa_write_data(pmic_arb, buf + 4,
+				PMIC_ARB_WDATA1(pmic_arb->channel), bc - 4);
+
+	/* Start the transaction */
+	pmic_arb_write(pmic_arb, PMIC_ARB_CMD(pmic_arb->channel), cmd);
+	rc = pmic_arb_wait_for_done(pmic_arb);
+	spin_unlock_irqrestore(&pmic_arb->lock, flags);
+
+	return rc;
+}
+
+/* APID to PPID */
+static inline u16 get_peripheral_id(struct spmi_pmic_arb_dev *pmic_arb, u8 apid)
+{
+	return pmic_arb->periph_id_map[apid] & PMIC_ARB_PPID_MASK;
+}
+
+/* APID to PPID, returns valid flag */
+static inline int is_apid_valid(struct spmi_pmic_arb_dev *pmic_arb, u8 apid)
+{
+	return pmic_arb->periph_id_map[apid] & PMIC_ARB_PERIPH_ID_VALID;
+}
+
+static int pmic_arb_mapping_data_show(struct seq_file *file, void *unused)
+{
+	struct spmi_pmic_arb_dev *pmic_arb = file->private;
+	int first = pmic_arb->min_apid;
+	int last = pmic_arb->max_apid;
+	int i;
+
+	for (i = first; i <= last; ++i) {
+		if (!is_apid_valid(pmic_arb, i))
+			continue;
+
+		seq_printf(file, "APID 0x%.2x = PPID 0x%.3x. Enabled:%d\n",
+			i, get_peripheral_id(pmic_arb, i),
+			readl_relaxed(pmic_arb->intr + SPMI_PIC_ACC_ENABLE(i)));
+	}
+
+	return 0;
+}
+
+static int pmic_arb_mapping_data_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pmic_arb_mapping_data_show, inode->i_private);
+}
+
+static const struct file_operations pmic_arb_dfs_fops = {
+	.open		= pmic_arb_mapping_data_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int
+spmi_pmic_arb_get_property(struct platform_device *pdev, char *pname, u32 *prop)
+{
+	int ret = of_property_read_u32(pdev->dev.of_node, pname, prop);
+
+	if (ret)
+		dev_err(&pdev->dev, "missing property: %s\n", pname);
+	else
+		pr_debug("%s = 0x%x\n", pname, *prop);
+
+	return ret;
+}
+
+static int spmi_pmic_arb_probe(struct platform_device *pdev)
+{
+	struct spmi_pmic_arb_dev *pmic_arb;
+	struct resource *mem_res;
+	int ret = 0;
+	u32 prop;
+	int i;
+
+	pr_debug("SPMI PMIC Arbiter\n");
+
+	pmic_arb = devm_kzalloc(&pdev->dev,
+				sizeof(struct spmi_pmic_arb_dev), GFP_KERNEL);
+	if (!pmic_arb) {
+		dev_err(&pdev->dev, "can not allocate pmic_arb data\n");
+		return -ENOMEM;
+	}
+
+	mem_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "core");
+	if (!mem_res) {
+		dev_err(&pdev->dev, "missing base memory resource\n");
+		return -ENODEV;
+	}
+
+	pmic_arb->base = devm_ioremap(&pdev->dev,
+					mem_res->start, resource_size(mem_res));
+	if (!pmic_arb->base) {
+		dev_err(&pdev->dev, "ioremap of 'base' failed\n");
+		return -ENOMEM;
+	}
+
+	mem_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "intr");
+	if (!mem_res) {
+		dev_err(&pdev->dev, "missing mem resource (interrupts)\n");
+		return -ENODEV;
+	}
+
+	pmic_arb->intr = devm_ioremap(&pdev->dev,
+					mem_res->start, resource_size(mem_res));
+	if (!pmic_arb->intr) {
+		dev_err(&pdev->dev, "ioremap of 'intr' failed\n");
+		return -ENOMEM;
+	}
+
+	mem_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "cnfg");
+	if (!mem_res) {
+		dev_err(&pdev->dev, "missing mem resource (configuration)\n");
+		return -ENODEV;
+	}
+
+	pmic_arb->cnfg = devm_ioremap(&pdev->dev,
+					mem_res->start, resource_size(mem_res));
+	if (!pmic_arb->cnfg) {
+		dev_err(&pdev->dev, "ioremap of 'cnfg' failed\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pmic_arb->mapping_table); ++i)
+		pmic_arb->mapping_table[i] = readl_relaxed(
+				pmic_arb->cnfg + SPMI_MAPPING_TABLE_REG(i));
+
+	ret = spmi_pmic_arb_get_property(pdev, "qcom,pmic-arb-channel", &prop);
+	if (ret)
+		return -ENODEV;
+	pmic_arb->channel = (u8)prop;
+
+	pmic_arb->max_apid = 0;
+	pmic_arb->min_apid = PMIC_ARB_MAX_PERIPHS - 1;
+
+	pmic_arb->dev = &pdev->dev;
+	platform_set_drvdata(pdev, pmic_arb);
+	spmi_set_ctrldata(&pmic_arb->controller, pmic_arb);
+
+	spin_lock_init(&pmic_arb->lock);
+
+	pmic_arb->controller.dev.parent = pdev->dev.parent;
+	pmic_arb->controller.dev.of_node = of_node_get(pdev->dev.of_node);
+
+	/* Callbacks */
+	pmic_arb->controller.cmd = pmic_arb_cmd;
+	pmic_arb->controller.read_cmd = pmic_arb_read_cmd;
+	pmic_arb->controller.write_cmd =  pmic_arb_write_cmd;
+
+	ret = spmi_add_controller(&pmic_arb->controller);
+	if (ret)
+		goto err_add_controller;
+
+	/* Register device(s) from the device tree */
+	of_spmi_register_devices(&pmic_arb->controller);
+
+	pr_debug("PMIC Arb Version 0x%x\n",
+			pmic_arb_read(pmic_arb, PMIC_ARB_VERSION));
+
+	return 0;
+
+err_add_controller:
+	platform_set_drvdata(pdev, NULL);
+	return ret;
+}
+
+static int __exit spmi_pmic_arb_remove(struct platform_device *pdev)
+{
+	struct spmi_pmic_arb_dev *pmic_arb = platform_get_drvdata(pdev);
+	spmi_del_controller(&pmic_arb->controller);
+	return 0;
+}
+
+static struct of_device_id spmi_pmic_arb_match_table[] = {
+	{	.compatible = "qcom,spmi-pmic-arb", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, spmi_pmic_arb_match_table);
+
+static struct platform_driver spmi_pmic_arb_driver = {
+	.probe		= spmi_pmic_arb_probe,
+	.remove		= __exit_p(spmi_pmic_arb_remove),
+	.driver		= {
+		.name	= SPMI_PMIC_ARB_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table = spmi_pmic_arb_match_table,
+	},
+};
+module_platform_driver(spmi_pmic_arb_driver);
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


