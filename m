Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaC2AeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 20:34:18 -0400
Received: from ring0.de ([5.45.105.125]:43123 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494AbaC2AeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 20:34:14 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        =?UTF-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE=20=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@kernel.org>,
        Carlos Chinea <carlos.chinea@nokia.com>
Subject: [PATCHv3 08/14] HSI: Introduce OMAP SSI driver
Date: Sat, 29 Mar 2014 01:31:44 +0100
Message-Id: <1396053110-21639-9-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1396053110-21639-1-git-send-email-sre@kernel.org>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OMAP SSI driver to the HSI subsystem.

The Synchronous Serial Interface (SSI) is a legacy version
of HSI. As in the case of HSI, it is mainly used to connect
Application engines (APE) with cellular modem engines (CMT)
in cellular handsets.

It provides a multichannel, full-duplex, multi-core communication
with no reference clock. The OMAP SSI block is capable of reaching
speeds of 110 Mbit/s.

Signed-off-by: Carlos Chinea <carlos.chinea@nokia.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/Kconfig                     |    1 +
 drivers/hsi/Makefile                    |    1 +
 drivers/hsi/controllers/Kconfig         |   19 +
 drivers/hsi/controllers/Makefile        |    6 +
 drivers/hsi/controllers/omap_ssi.c      |  621 ++++++++++++++
 drivers/hsi/controllers/omap_ssi.h      |  166 ++++
 drivers/hsi/controllers/omap_ssi_port.c | 1401 +++++++++++++++++++++++++++++++
 drivers/hsi/controllers/omap_ssi_regs.h |  171 ++++
 8 files changed, 2386 insertions(+)
 create mode 100644 drivers/hsi/controllers/Kconfig
 create mode 100644 drivers/hsi/controllers/Makefile
 create mode 100644 drivers/hsi/controllers/omap_ssi.c
 create mode 100644 drivers/hsi/controllers/omap_ssi.h
 create mode 100644 drivers/hsi/controllers/omap_ssi_port.c
 create mode 100644 drivers/hsi/controllers/omap_ssi_regs.h

diff --git a/drivers/hsi/Kconfig b/drivers/hsi/Kconfig
index d94e38d..2c76de4 100644
--- a/drivers/hsi/Kconfig
+++ b/drivers/hsi/Kconfig
@@ -14,6 +14,7 @@ config HSI_BOARDINFO
 	bool
 	default y
 
+source "drivers/hsi/controllers/Kconfig"
 source "drivers/hsi/clients/Kconfig"
 
 endif # HSI
diff --git a/drivers/hsi/Makefile b/drivers/hsi/Makefile
index 9d5d33f..360371e 100644
--- a/drivers/hsi/Makefile
+++ b/drivers/hsi/Makefile
@@ -3,4 +3,5 @@
 #
 obj-$(CONFIG_HSI_BOARDINFO)	+= hsi_boardinfo.o
 obj-$(CONFIG_HSI)		+= hsi.o
+obj-y				+= controllers/
 obj-y				+= clients/
diff --git a/drivers/hsi/controllers/Kconfig b/drivers/hsi/controllers/Kconfig
new file mode 100644
index 0000000..037a344
--- /dev/null
+++ b/drivers/hsi/controllers/Kconfig
@@ -0,0 +1,19 @@
+#
+# HSI controllers configuration
+#
+comment "HSI controllers"
+
+config OMAP_SSI
+	tristate "OMAP SSI hardware driver"
+	depends on ARCH_OMAP && HSI
+	---help---
+	  SSI is a legacy version of HSI. It is usually used to connect
+	  an application engine with a cellular modem.
+	  If you say Y here, you will enable the OMAP SSI hardware driver.
+
+	  If unsure, say N.
+
+config OMAP_SSI_PORT
+	tristate
+	default m if OMAP_SSI=m
+	default y if OMAP_SSI=y
diff --git a/drivers/hsi/controllers/Makefile b/drivers/hsi/controllers/Makefile
new file mode 100644
index 0000000..d2665cf
--- /dev/null
+++ b/drivers/hsi/controllers/Makefile
@@ -0,0 +1,6 @@
+#
+# Makefile for HSI controllers drivers
+#
+
+obj-$(CONFIG_OMAP_SSI)		+= omap_ssi.o
+obj-$(CONFIG_OMAP_SSI_PORT)	+= omap_ssi_port.o
diff --git a/drivers/hsi/controllers/omap_ssi.c b/drivers/hsi/controllers/omap_ssi.c
new file mode 100644
index 0000000..772f3e3
--- /dev/null
+++ b/drivers/hsi/controllers/omap_ssi.c
@@ -0,0 +1,621 @@
+/* OMAP SSI driver.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ * Copyright (C) 2014 Sebastian Reichel <sre@kernel.org>
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/compiler.h>
+#include <linux/err.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+#include <linux/clk.h>
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmaengine.h>
+#include <linux/delay.h>
+#include <linux/seq_file.h>
+#include <linux/scatterlist.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/debugfs.h>
+#include <linux/pm_runtime.h>
+#include <linux/of_platform.h>
+#include <linux/hsi/hsi.h>
+#include <linux/idr.h>
+
+#include "omap_ssi_regs.h"
+#include "omap_ssi.h"
+
+/* For automatically allocated device IDs */
+static DEFINE_IDA(platform_omap_ssi_ida);
+
+#ifdef CONFIG_DEBUG_FS
+static int ssi_debug_show(struct seq_file *m, void *p __maybe_unused)
+{
+	struct hsi_controller *ssi = m->private;
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem *sys = omap_ssi->sys;
+
+	pm_runtime_get_sync(ssi->device.parent);
+	seq_printf(m, "REVISION\t: 0x%08x\n",  readl(sys + SSI_REVISION_REG));
+	seq_printf(m, "SYSCONFIG\t: 0x%08x\n", readl(sys + SSI_SYSCONFIG_REG));
+	seq_printf(m, "SYSSTATUS\t: 0x%08x\n", readl(sys + SSI_SYSSTATUS_REG));
+	pm_runtime_put_sync(ssi->device.parent);
+
+	return 0;
+}
+
+static int ssi_debug_gdd_show(struct seq_file *m, void *p __maybe_unused)
+{
+	struct hsi_controller *ssi = m->private;
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem *gdd = omap_ssi->gdd;
+	void __iomem *sys = omap_ssi->sys;
+	int lch;
+
+	pm_runtime_get_sync(ssi->device.parent);
+
+	seq_printf(m, "GDD_MPU_STATUS\t: 0x%08x\n",
+		readl(sys + SSI_GDD_MPU_IRQ_STATUS_REG));
+	seq_printf(m, "GDD_MPU_ENABLE\t: 0x%08x\n\n",
+		readl(sys + SSI_GDD_MPU_IRQ_ENABLE_REG));
+	seq_printf(m, "HW_ID\t\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_HW_ID_REG));
+	seq_printf(m, "PPORT_ID\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_PPORT_ID_REG));
+	seq_printf(m, "MPORT_ID\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_MPORT_ID_REG));
+	seq_printf(m, "TEST\t\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_TEST_REG));
+	seq_printf(m, "GCR\t\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_GCR_REG));
+
+	for (lch = 0; lch < SSI_MAX_GDD_LCH; lch++) {
+		seq_printf(m, "\nGDD LCH %d\n=========\n", lch);
+		seq_printf(m, "CSDP\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CSDP_REG(lch)));
+		seq_printf(m, "CCR\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CCR_REG(lch)));
+		seq_printf(m, "CICR\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CICR_REG(lch)));
+		seq_printf(m, "CSR\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CSR_REG(lch)));
+		seq_printf(m, "CSSA\t\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_CSSA_REG(lch)));
+		seq_printf(m, "CDSA\t\t: 0x%08x\n",
+				readl(gdd + SSI_GDD_CDSA_REG(lch)));
+		seq_printf(m, "CEN\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CEN_REG(lch)));
+		seq_printf(m, "CSAC\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CSAC_REG(lch)));
+		seq_printf(m, "CDAC\t\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CDAC_REG(lch)));
+		seq_printf(m, "CLNK_CTRL\t: 0x%04x\n",
+				readw(gdd + SSI_GDD_CLNK_CTRL_REG(lch)));
+	}
+
+	pm_runtime_put_sync(ssi->device.parent);
+
+	return 0;
+}
+
+static int ssi_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ssi_debug_show, inode->i_private);
+}
+
+static int ssi_gdd_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ssi_debug_gdd_show, inode->i_private);
+}
+
+static const struct file_operations ssi_regs_fops = {
+	.open		= ssi_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static const struct file_operations ssi_gdd_regs_fops = {
+	.open		= ssi_gdd_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init ssi_debug_add_ctrl(struct hsi_controller *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct dentry *dir;
+
+	/* SSI controller */
+	omap_ssi->dir = debugfs_create_dir(dev_name(&ssi->device), NULL);
+	if (IS_ERR(omap_ssi->dir))
+		return PTR_ERR(omap_ssi->dir);
+
+	debugfs_create_file("regs", S_IRUGO, omap_ssi->dir, ssi,
+								&ssi_regs_fops);
+	/* SSI GDD (DMA) */
+	dir = debugfs_create_dir("gdd", omap_ssi->dir);
+	if (IS_ERR(dir))
+		goto rback;
+	debugfs_create_file("regs", S_IRUGO, dir, ssi, &ssi_gdd_regs_fops);
+
+	return 0;
+rback:
+	debugfs_remove_recursive(omap_ssi->dir);
+
+	return PTR_ERR(dir);
+}
+
+static void ssi_debug_remove_ctrl(struct hsi_controller *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	debugfs_remove_recursive(omap_ssi->dir);
+}
+#endif /* CONFIG_DEBUG_FS */
+
+/*
+ * FIXME: Horrible HACK needed until we remove the useless wakeline test
+ * in the CMT. To be removed !!!!
+ */
+void ssi_waketest(struct hsi_client *cl, unsigned int enable)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	omap_port->wktest = !!enable;
+	if (omap_port->wktest) {
+		pm_runtime_get_sync(ssi->device.parent);
+		writel_relaxed(SSI_WAKE(0),
+				omap_ssi->sys + SSI_SET_WAKE_REG(port->num));
+	} else {
+		writel_relaxed(SSI_WAKE(0),
+				omap_ssi->sys +	SSI_CLEAR_WAKE_REG(port->num));
+		pm_runtime_put_sync(ssi->device.parent);
+	}
+}
+EXPORT_SYMBOL_GPL(ssi_waketest);
+
+static void ssi_gdd_complete(struct hsi_controller *ssi, unsigned int lch)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct hsi_msg *msg = omap_ssi->gdd_trn[lch].msg;
+	struct hsi_port *port = to_hsi_port(msg->cl->device.parent);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	unsigned int dir;
+	u32 csr;
+	u32 val;
+
+	spin_lock(&omap_ssi->lock);
+
+	val = readl(omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	val &= ~SSI_GDD_LCH(lch);
+	writel_relaxed(val, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+
+	if (msg->ttype == HSI_MSG_READ) {
+		dir = DMA_FROM_DEVICE;
+		val = SSI_DATAAVAILABLE(msg->channel);
+		pm_runtime_put_sync(ssi->device.parent);
+	} else {
+		dir = DMA_TO_DEVICE;
+		val = SSI_DATAACCEPT(msg->channel);
+		/* Keep clocks reference for write pio event */
+	}
+	dma_unmap_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents, dir);
+	csr = readw(omap_ssi->gdd + SSI_GDD_CSR_REG(lch));
+	omap_ssi->gdd_trn[lch].msg = NULL; /* release GDD lch */
+	dev_dbg(&port->device, "DMA completed ch %d ttype %d\n",
+				msg->channel, msg->ttype);
+	spin_unlock(&omap_ssi->lock);
+	if (csr & SSI_CSR_TOUR) { /* Timeout error */
+		msg->status = HSI_STATUS_ERROR;
+		msg->actual_len = 0;
+		spin_lock(&omap_port->lock);
+		list_del(&msg->link); /* Dequeue msg */
+		spin_unlock(&omap_port->lock);
+		msg->complete(msg);
+		return;
+	}
+	spin_lock(&omap_port->lock);
+	val |= readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	writel_relaxed(val, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	spin_unlock(&omap_port->lock);
+
+	msg->status = HSI_STATUS_COMPLETED;
+	msg->actual_len = sg_dma_len(msg->sgt.sgl);
+}
+
+static void ssi_gdd_tasklet(unsigned long dev)
+{
+	struct hsi_controller *ssi = (struct hsi_controller *)dev;
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem *sys = omap_ssi->sys;
+	unsigned int lch;
+	u32 status_reg;
+
+	pm_runtime_get_sync(ssi->device.parent);
+
+	status_reg = readl(sys + SSI_GDD_MPU_IRQ_STATUS_REG);
+	for (lch = 0; lch < SSI_MAX_GDD_LCH; lch++) {
+		if (status_reg & SSI_GDD_LCH(lch))
+			ssi_gdd_complete(ssi, lch);
+	}
+	writel_relaxed(status_reg, sys + SSI_GDD_MPU_IRQ_STATUS_REG);
+	status_reg = readl(sys + SSI_GDD_MPU_IRQ_STATUS_REG);
+
+	pm_runtime_put_sync(ssi->device.parent);
+
+	if (status_reg)
+		tasklet_hi_schedule(&omap_ssi->gdd_tasklet);
+	else
+		enable_irq(omap_ssi->gdd_irq);
+
+}
+
+static irqreturn_t ssi_gdd_isr(int irq, void *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	tasklet_hi_schedule(&omap_ssi->gdd_tasklet);
+	disable_irq_nosync(irq);
+
+	return IRQ_HANDLED;
+}
+
+static unsigned long ssi_get_clk_rate(struct hsi_controller *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	unsigned long rate = clk_get_rate(omap_ssi->fck);
+	return rate;
+}
+
+static int __init ssi_get_iomem(struct platform_device *pd,
+		const char *name, void __iomem **pbase, dma_addr_t *phy)
+{
+	struct resource *mem;
+	struct resource *ioarea;
+	void __iomem *base;
+	struct hsi_controller *ssi = platform_get_drvdata(pd);
+
+	mem = platform_get_resource_byname(pd, IORESOURCE_MEM, name);
+	if (!mem) {
+		dev_err(&pd->dev, "IO memory region missing (%s)\n", name);
+		return -ENXIO;
+	}
+	ioarea = devm_request_mem_region(&ssi->device, mem->start,
+					resource_size(mem), dev_name(&pd->dev));
+	if (!ioarea) {
+		dev_err(&pd->dev, "%s IO memory region request failed\n",
+								mem->name);
+		return -ENXIO;
+	}
+	base = devm_ioremap(&ssi->device, mem->start, resource_size(mem));
+	if (!base) {
+		dev_err(&pd->dev, "%s IO remap failed\n", mem->name);
+		return -ENXIO;
+	}
+	*pbase = base;
+
+	if (phy)
+		*phy = mem->start;
+
+	return 0;
+}
+
+static int __init ssi_add_controller(struct hsi_controller *ssi,
+						struct platform_device *pd)
+{
+	struct omap_ssi_controller *omap_ssi;
+	int err;
+
+	omap_ssi = devm_kzalloc(&ssi->device, sizeof(*omap_ssi), GFP_KERNEL);
+	if (!omap_ssi) {
+		dev_err(&pd->dev, "not enough memory for omap ssi\n");
+		return -ENOMEM;
+	}
+
+	ssi->id = ida_simple_get(&platform_omap_ssi_ida, 0, 0, GFP_KERNEL);
+	if (ssi->id < 0) {
+		err = ssi->id;
+		goto out_err;
+	}
+
+	ssi->owner = THIS_MODULE;
+	ssi->device.parent = &pd->dev;
+	dev_set_name(&ssi->device, "ssi%d", ssi->id);
+	hsi_controller_set_drvdata(ssi, omap_ssi);
+	omap_ssi->dev = &ssi->device;
+	err = ssi_get_iomem(pd, "sys", &omap_ssi->sys, NULL);
+	if (err < 0)
+		goto out_err;
+	err = ssi_get_iomem(pd, "gdd", &omap_ssi->gdd, NULL);
+	if (err < 0)
+		goto out_err;
+	omap_ssi->gdd_irq = platform_get_irq_byname(pd, "gdd_mpu");
+	if (omap_ssi->gdd_irq < 0) {
+		dev_err(&pd->dev, "GDD IRQ resource missing\n");
+		err = omap_ssi->gdd_irq;
+		goto out_err;
+	}
+	tasklet_init(&omap_ssi->gdd_tasklet, ssi_gdd_tasklet,
+							(unsigned long)ssi);
+	err = devm_request_irq(&ssi->device, omap_ssi->gdd_irq, ssi_gdd_isr,
+						0, "gdd_mpu", ssi);
+	if (err < 0) {
+		dev_err(&ssi->device, "Request GDD IRQ %d failed (%d)",
+							omap_ssi->gdd_irq, err);
+		goto out_err;
+	}
+
+	omap_ssi->port = devm_kzalloc(&ssi->device,
+		sizeof(struct omap_ssi_port *) * ssi->num_ports, GFP_KERNEL);
+	if (!omap_ssi->port) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+
+	omap_ssi->fck = devm_clk_get(&ssi->device, "ssi_ssr_fck");
+	if (IS_ERR(omap_ssi->fck)) {
+		dev_err(&pd->dev, "Could not acquire clock \"ssi_ssr_fck\": %li\n",
+			PTR_ERR(omap_ssi->fck));
+		err = -ENODEV;
+		goto out_err;
+	}
+
+	/* TODO: find register, which can be used to detect context loss */
+	omap_ssi->get_loss = NULL;
+
+	omap_ssi->max_speed = UINT_MAX;
+	spin_lock_init(&omap_ssi->lock);
+	err = hsi_register_controller(ssi);
+
+	if (err < 0)
+		goto out_err;
+
+	return 0;
+
+out_err:
+	ida_simple_remove(&platform_omap_ssi_ida, ssi->id);
+	return err;
+}
+
+static int __init ssi_hw_init(struct hsi_controller *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	unsigned int i;
+	u32 val;
+	int err;
+
+	err = pm_runtime_get_sync(ssi->device.parent);
+	if (err < 0) {
+		dev_err(&ssi->device, "runtime PM failed %d\n", err);
+		return err;
+	}
+	/* Reseting SSI controller */
+	writel_relaxed(SSI_SOFTRESET, omap_ssi->sys + SSI_SYSCONFIG_REG);
+	val = readl(omap_ssi->sys + SSI_SYSSTATUS_REG);
+	for (i = 0; ((i < 20) && !(val & SSI_RESETDONE)); i++) {
+		msleep(20);
+		val = readl(omap_ssi->sys + SSI_SYSSTATUS_REG);
+	}
+	if (!(val & SSI_RESETDONE)) {
+		dev_err(&ssi->device, "SSI HW reset failed\n");
+		pm_runtime_put_sync(ssi->device.parent);
+		return -EIO;
+	}
+	/* Reseting GDD */
+	writel_relaxed(SSI_SWRESET, omap_ssi->gdd + SSI_GDD_GRST_REG);
+	/* Get FCK rate in KHz */
+	omap_ssi->fck_rate = DIV_ROUND_CLOSEST(ssi_get_clk_rate(ssi), 1000);
+	dev_dbg(&ssi->device, "SSI fck rate %lu KHz\n", omap_ssi->fck_rate);
+	/* Set default PM settings */
+	val = SSI_AUTOIDLE | SSI_SIDLEMODE_SMART | SSI_MIDLEMODE_SMART;
+	writel_relaxed(val, omap_ssi->sys + SSI_SYSCONFIG_REG);
+	omap_ssi->sysconfig = val;
+	writel_relaxed(SSI_CLK_AUTOGATING_ON, omap_ssi->sys + SSI_GDD_GCR_REG);
+	omap_ssi->gdd_gcr = SSI_CLK_AUTOGATING_ON;
+	pm_runtime_put_sync(ssi->device.parent);
+
+	return 0;
+}
+
+static void ssi_remove_controller(struct hsi_controller *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	int id = ssi->id;
+	tasklet_kill(&omap_ssi->gdd_tasklet);
+	hsi_unregister_controller(ssi);
+	ida_simple_remove(&platform_omap_ssi_ida, id);
+}
+
+static inline int ssi_of_get_available_ports_count(const struct device_node *np)
+{
+	struct device_node *child;
+	int num = 0;
+
+	for_each_available_child_of_node(np, child)
+		if (of_device_is_compatible(child, "ti,omap3-ssi-port"))
+			num++;
+
+	return num;
+}
+
+static const struct of_device_id ssi_port_match[] = {
+	{ .compatible = "ti,omap3-ssi-port" },
+	{},
+};
+
+static int __init ssi_probe(struct platform_device *pd)
+{
+	struct device_node *np = pd->dev.of_node;
+	struct hsi_controller *ssi;
+	int err;
+	int num_ports;
+
+	if (!np) {
+		dev_err(&pd->dev, "missing device tree data\n");
+		return -EINVAL;
+	}
+
+	num_ports = ssi_of_get_available_ports_count(np);
+
+	ssi = hsi_alloc_controller(num_ports, GFP_KERNEL);
+	if (!ssi) {
+		dev_err(&pd->dev, "No memory for controller\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pd, ssi);
+
+	err = ssi_add_controller(ssi, pd);
+	if (err < 0)
+		goto out1;
+
+	pm_runtime_irq_safe(&pd->dev);
+	pm_runtime_enable(&pd->dev);
+
+	err = ssi_hw_init(ssi);
+	if (err < 0)
+		goto out2;
+#ifdef CONFIG_DEBUG_FS
+	err = ssi_debug_add_ctrl(ssi);
+	if (err < 0)
+		goto out2;
+#endif
+
+	err = of_platform_populate(pd->dev.of_node, NULL, ssi_port_match, &pd->dev);
+	if (err) {
+		dev_err(&pd->dev, "failed to create ssi controller ports (err=%d)\n",
+			err);
+		return -ENODEV;
+	}
+
+	dev_info(&pd->dev, "ssi controller %d initialized (%d ports)!\n",
+		ssi->id, num_ports);
+	return err;
+out2:
+	ssi_remove_controller(ssi);
+out1:
+	platform_set_drvdata(pd, NULL);
+	pm_runtime_disable(&pd->dev);
+
+	return err;
+}
+
+static int __exit ssi_remove_ports(struct device *dev, void *c)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+
+	of_device_unregister(pdev);
+
+	return 0;
+}
+
+static int __exit ssi_remove(struct platform_device *pd)
+{
+	struct hsi_controller *ssi = platform_get_drvdata(pd);
+
+#ifdef CONFIG_DEBUG_FS
+	ssi_debug_remove_ctrl(ssi);
+#endif
+	ssi_remove_controller(ssi);
+	platform_set_drvdata(pd, NULL);
+
+	pm_runtime_disable(&pd->dev);
+
+	/* cleanup of of_platform_populate() call */
+	device_for_each_child(&pd->dev, NULL, ssi_remove_ports);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int omap_ssi_runtime_suspend(struct device *dev)
+{
+	struct hsi_controller *ssi = dev_get_drvdata(dev);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	dev_dbg(dev, "runtime suspend!\n");
+
+	if (omap_ssi->get_loss)
+		omap_ssi->loss_count =
+				omap_ssi->get_loss(ssi->device.parent);
+
+	return 0;
+}
+
+static int omap_ssi_runtime_resume(struct device *dev)
+{
+	struct hsi_controller *ssi = dev_get_drvdata(dev);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	dev_dbg(dev, "runtime resume!\n");
+
+	if ((omap_ssi->get_loss) && (omap_ssi->loss_count ==
+				omap_ssi->get_loss(ssi->device.parent)))
+		return 0;
+
+	writel_relaxed(omap_ssi->gdd_gcr, omap_ssi->gdd + SSI_GDD_GCR_REG);
+
+	return 0;
+}
+
+static const struct dev_pm_ops omap_ssi_pm_ops = {
+	SET_RUNTIME_PM_OPS(omap_ssi_runtime_suspend, omap_ssi_runtime_resume,
+		NULL)
+};
+
+#define DEV_PM_OPS     (&omap_ssi_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id omap_ssi_of_match[] = {
+	{ .compatible = "ti,omap3-ssi", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_ssi_of_match);
+#else
+#define omap_ssi_of_match NULL
+#endif
+
+static struct platform_driver ssi_pdriver = {
+	.remove	= __exit_p(ssi_remove),
+	.driver	= {
+		.name	= "omap_ssi",
+		.owner	= THIS_MODULE,
+		.pm     = DEV_PM_OPS,
+		.of_match_table = omap_ssi_of_match,
+	},
+};
+
+module_platform_driver_probe(ssi_pdriver, ssi_probe);
+
+MODULE_ALIAS("platform:omap_ssi");
+MODULE_AUTHOR("Carlos Chinea <carlos.chinea@nokia.com>");
+MODULE_AUTHOR("Sebastian Reichel <sre@debian.org>");
+MODULE_DESCRIPTION("Synchronous Serial Interface Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hsi/controllers/omap_ssi.h b/drivers/hsi/controllers/omap_ssi.h
new file mode 100644
index 0000000..9d05641
--- /dev/null
+++ b/drivers/hsi/controllers/omap_ssi.h
@@ -0,0 +1,166 @@
+/* OMAP SSI internal interface.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ * Copyright (C) 2013 Sebastian Reichel
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __LINUX_HSI_OMAP_SSI_H__
+#define __LINUX_HSI_OMAP_SSI_H__
+
+#include <linux/device.h>
+#include <linux/platform_device.h>
+#include <linux/hsi/hsi.h>
+#include <linux/gpio.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#define SSI_MAX_CHANNELS	8
+#define SSI_MAX_GDD_LCH		8
+#define SSI_BYTES_TO_FRAMES(x) ((((x) - 1) >> 2) + 1)
+
+/**
+ * struct omap_ssm_ctx - OMAP synchronous serial module (TX/RX) context
+ * @mode: Bit transmission mode
+ * @channels: Number of channels
+ * @framesize: Frame size in bits
+ * @timeout: RX frame timeout
+ * @divisor: TX divider
+ * @arb_mode: Arbitration mode for TX frame (Round robin, priority)
+ */
+struct omap_ssm_ctx {
+	u32	mode;
+	u32	channels;
+	u32	frame_size;
+	union	{
+			u32	timeout; /* Rx Only */
+			struct	{
+					u32	arb_mode;
+					u32	divisor;
+			}; /* Tx only */
+	};
+};
+
+/**
+ * struct omap_ssi_port - OMAP SSI port data
+ * @dev: device associated to the port (HSI port)
+ * @pdev: platform device associated to the port
+ * @sst_dma: SSI transmitter physical base address
+ * @ssr_dma: SSI receiver physical base address
+ * @sst_base: SSI transmitter base address
+ * @ssr_base: SSI receiver base address
+ * @wk_lock: spin lock to serialize access to the wake lines
+ * @lock: Spin lock to serialize access to the SSI port
+ * @channels: Current number of channels configured (1,2,4 or 8)
+ * @txqueue: TX message queues
+ * @rxqueue: RX message queues
+ * @brkqueue: Queue of incoming HWBREAK requests (FRAME mode)
+ * @irq: IRQ number
+ * @wake_irq: IRQ number for incoming wake line (-1 if none)
+ * @wake_gpio: GPIO number for incoming wake line (-1 if none)
+ * @pio_tasklet: Bottom half for PIO transfers and events
+ * @wake_tasklet: Bottom half for incoming wake events
+ * @wkin_cken: Keep track of clock references due to the incoming wake line
+ * @wk_refcount: Reference count for output wake line
+ * @sys_mpu_enable: Context for the interrupt enable register for irq 0
+ * @sst: Context for the synchronous serial transmitter
+ * @ssr: Context for the synchronous serial receiver
+ */
+struct omap_ssi_port {
+	struct device		*dev;
+	struct device           *pdev;
+	dma_addr_t		sst_dma;
+	dma_addr_t		ssr_dma;
+	void __iomem		*sst_base;
+	void __iomem		*ssr_base;
+	spinlock_t		wk_lock;
+	spinlock_t		lock;
+	unsigned int		channels;
+	struct list_head	txqueue[SSI_MAX_CHANNELS];
+	struct list_head	rxqueue[SSI_MAX_CHANNELS];
+	struct list_head	brkqueue;
+	unsigned int		irq;
+	int			wake_irq;
+	int			wake_gpio;
+	struct tasklet_struct	pio_tasklet;
+	struct tasklet_struct	wake_tasklet;
+	bool			wktest:1; /* FIXME: HACK to be removed */
+	bool			wkin_cken:1; /* Workaround */
+	unsigned int		wk_refcount;
+	/* OMAP SSI port context */
+	u32			sys_mpu_enable; /* We use only one irq */
+	struct omap_ssm_ctx	sst;
+	struct omap_ssm_ctx	ssr;
+	u32			loss_count;
+	u32			port_id;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dir;
+#endif
+};
+
+/**
+ * struct gdd_trn - GDD transaction data
+ * @msg: Pointer to the HSI message being served
+ * @sg: Pointer to the current sg entry being served
+ */
+struct gdd_trn {
+	struct hsi_msg		*msg;
+	struct scatterlist	*sg;
+};
+
+/**
+ * struct omap_ssi_controller - OMAP SSI controller data
+ * @dev: device associated to the controller (HSI controller)
+ * @sys: SSI I/O base address
+ * @gdd: GDD I/O base address
+ * @fck: SSI functional clock
+ * @gdd_irq: IRQ line for GDD
+ * @gdd_tasklet: bottom half for DMA transfers
+ * @gdd_trn: Array of GDD transaction data for ongoing GDD transfers
+ * @lock: lock to serialize access to GDD
+ * @loss_count: To follow if we need to restore context or not
+ * @max_speed: Maximum TX speed (Kb/s) set by the clients.
+ * @sysconfig: SSI controller saved context
+ * @gdd_gcr: SSI GDD saved context
+ * @get_loss: Pointer to omap_pm_get_dev_context_loss_count, if any
+ * @port: Array of pointers of the ports of the controller
+ * @dir: Debugfs SSI root directory
+ */
+struct omap_ssi_controller {
+	struct device		*dev;
+	void __iomem		*sys;
+	void __iomem		*gdd;
+	struct clk		*fck;
+	unsigned int		gdd_irq;
+	struct tasklet_struct	gdd_tasklet;
+	struct gdd_trn		gdd_trn[SSI_MAX_GDD_LCH];
+	spinlock_t		lock;
+	unsigned long		fck_rate;
+	u32			loss_count;
+	u32			max_speed;
+	/* OMAP SSI Controller context */
+	u32			sysconfig;
+	u32			gdd_gcr;
+	int			(*get_loss)(struct device *dev);
+	struct omap_ssi_port	**port;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *dir;
+#endif
+};
+
+#endif /* __LINUX_HSI_OMAP_SSI_H__ */
diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
new file mode 100644
index 0000000..04115f6
--- /dev/null
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -0,0 +1,1401 @@
+/* OMAP SSI port driver.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ * Copyright (C) 2014 Sebastian Reichel <sre@kernel.org>
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/pm_runtime.h>
+
+#include <linux/of_gpio.h>
+#include <linux/debugfs.h>
+
+#include "omap_ssi_regs.h"
+#include "omap_ssi.h"
+
+static inline int hsi_dummy_msg(struct hsi_msg *msg __maybe_unused)
+{
+	return 0;
+}
+
+static inline int hsi_dummy_cl(struct hsi_client *cl __maybe_unused)
+{
+	return 0;
+}
+
+static inline unsigned int ssi_wakein(struct hsi_port *port)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	return gpio_get_value(omap_port->wake_gpio);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void ssi_debug_remove_port(struct hsi_port *port)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+
+	debugfs_remove_recursive(omap_port->dir);
+}
+
+static int ssi_debug_port_show(struct seq_file *m, void *p __maybe_unused)
+{
+	struct hsi_port *port = m->private;
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem	*base = omap_ssi->sys;
+	unsigned int ch;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	if (omap_port->wake_irq > 0)
+		seq_printf(m, "CAWAKE\t\t: %d\n", ssi_wakein(port));
+	seq_printf(m, "WAKE\t\t: 0x%08x\n",
+				readl(base + SSI_WAKE_REG(port->num)));
+	seq_printf(m, "MPU_ENABLE_IRQ%d\t: 0x%08x\n", 0,
+			readl(base + SSI_MPU_ENABLE_REG(port->num, 0)));
+	seq_printf(m, "MPU_STATUS_IRQ%d\t: 0x%08x\n", 0,
+			readl(base + SSI_MPU_STATUS_REG(port->num, 0)));
+	/* SST */
+	base = omap_port->sst_base;
+	seq_puts(m, "\nSST\n===\n");
+	seq_printf(m, "ID SST\t\t: 0x%08x\n",
+				readl(base + SSI_SST_ID_REG));
+	seq_printf(m, "MODE\t\t: 0x%08x\n",
+				readl(base + SSI_SST_MODE_REG));
+	seq_printf(m, "FRAMESIZE\t: 0x%08x\n",
+				readl(base + SSI_SST_FRAMESIZE_REG));
+	seq_printf(m, "DIVISOR\t\t: 0x%08x\n",
+				readl(base + SSI_SST_DIVISOR_REG));
+	seq_printf(m, "CHANNELS\t: 0x%08x\n",
+				readl(base + SSI_SST_CHANNELS_REG));
+	seq_printf(m, "ARBMODE\t\t: 0x%08x\n",
+				readl(base + SSI_SST_ARBMODE_REG));
+	seq_printf(m, "TXSTATE\t\t: 0x%08x\n",
+				readl(base + SSI_SST_TXSTATE_REG));
+	seq_printf(m, "BUFSTATE\t: 0x%08x\n",
+				readl(base + SSI_SST_BUFSTATE_REG));
+	seq_printf(m, "BREAK\t\t: 0x%08x\n",
+				readl(base + SSI_SST_BREAK_REG));
+	for (ch = 0; ch < omap_port->channels; ch++) {
+		seq_printf(m, "BUFFER_CH%d\t: 0x%08x\n", ch,
+				readl(base + SSI_SST_BUFFER_CH_REG(ch)));
+	}
+	/* SSR */
+	base = omap_port->ssr_base;
+	seq_puts(m, "\nSSR\n===\n");
+	seq_printf(m, "ID SSR\t\t: 0x%08x\n",
+				readl(base + SSI_SSR_ID_REG));
+	seq_printf(m, "MODE\t\t: 0x%08x\n",
+				readl(base + SSI_SSR_MODE_REG));
+	seq_printf(m, "FRAMESIZE\t: 0x%08x\n",
+				readl(base + SSI_SSR_FRAMESIZE_REG));
+	seq_printf(m, "CHANNELS\t: 0x%08x\n",
+				readl(base + SSI_SSR_CHANNELS_REG));
+	seq_printf(m, "TIMEOUT\t\t: 0x%08x\n",
+				readl(base + SSI_SSR_TIMEOUT_REG));
+	seq_printf(m, "RXSTATE\t\t: 0x%08x\n",
+				readl(base + SSI_SSR_RXSTATE_REG));
+	seq_printf(m, "BUFSTATE\t: 0x%08x\n",
+				readl(base + SSI_SSR_BUFSTATE_REG));
+	seq_printf(m, "BREAK\t\t: 0x%08x\n",
+				readl(base + SSI_SSR_BREAK_REG));
+	seq_printf(m, "ERROR\t\t: 0x%08x\n",
+				readl(base + SSI_SSR_ERROR_REG));
+	seq_printf(m, "ERRORACK\t: 0x%08x\n",
+				readl(base + SSI_SSR_ERRORACK_REG));
+	for (ch = 0; ch < omap_port->channels; ch++) {
+		seq_printf(m, "BUFFER_CH%d\t: 0x%08x\n", ch,
+				readl(base + SSI_SSR_BUFFER_CH_REG(ch)));
+	}
+	pm_runtime_put_sync(omap_port->pdev);
+
+	return 0;
+}
+
+static int ssi_port_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ssi_debug_port_show, inode->i_private);
+}
+
+static const struct file_operations ssi_port_regs_fops = {
+	.open		= ssi_port_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int ssi_div_get(void *data, u64 *val)
+{
+	struct hsi_port *port = data;
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+
+	pm_runtime_get_sync(omap_port->pdev);
+	*val = readl(omap_port->sst_base + SSI_SST_DIVISOR_REG);
+	pm_runtime_put_sync(omap_port->pdev);
+
+	return 0;
+}
+
+static int ssi_div_set(void *data, u64 val)
+{
+	struct hsi_port *port = data;
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+
+	if (val > 127)
+		return -EINVAL;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	writel(val, omap_port->sst_base + SSI_SST_DIVISOR_REG);
+	omap_port->sst.divisor = val;
+	pm_runtime_put_sync(omap_port->pdev);
+
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(ssi_sst_div_fops, ssi_div_get, ssi_div_set, "%llu\n");
+
+static int __init ssi_debug_add_port(struct omap_ssi_port *omap_port,
+							struct dentry *dir)
+{
+	struct hsi_port *port = to_hsi_port(omap_port->dev);
+
+	dir = debugfs_create_dir(dev_name(omap_port->dev), dir);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+	omap_port->dir = dir;
+	debugfs_create_file("regs", S_IRUGO, dir, port, &ssi_port_regs_fops);
+	dir = debugfs_create_dir("sst", dir);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+	debugfs_create_file("divisor", S_IRUGO | S_IWUSR, dir, port,
+							&ssi_sst_div_fops);
+
+	return 0;
+}
+#endif
+
+static int ssi_claim_lch(struct hsi_msg *msg)
+{
+
+	struct hsi_port *port = hsi_get_port(msg->cl);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	int lch;
+
+	for (lch = 0; lch < SSI_MAX_GDD_LCH; lch++)
+		if (!omap_ssi->gdd_trn[lch].msg) {
+			omap_ssi->gdd_trn[lch].msg = msg;
+			omap_ssi->gdd_trn[lch].sg = msg->sgt.sgl;
+			return lch;
+		}
+
+	return -EBUSY;
+}
+
+static int ssi_start_dma(struct hsi_msg *msg, int lch)
+{
+	struct hsi_port *port = hsi_get_port(msg->cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem *gdd = omap_ssi->gdd;
+	int err;
+	u16 csdp;
+	u16 ccr;
+	u32 s_addr;
+	u32 d_addr;
+	u32 tmp;
+
+	if (msg->ttype == HSI_MSG_READ) {
+		err = dma_map_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents,
+							DMA_FROM_DEVICE);
+		if (err < 0) {
+			dev_dbg(&ssi->device, "DMA map SG failed !\n");
+			return err;
+		}
+		csdp = SSI_DST_BURST_4x32_BIT | SSI_DST_MEMORY_PORT |
+			SSI_SRC_SINGLE_ACCESS0 | SSI_SRC_PERIPHERAL_PORT |
+			SSI_DATA_TYPE_S32;
+		ccr = msg->channel + 0x10 + (port->num * 8); /* Sync */
+		ccr |= SSI_DST_AMODE_POSTINC | SSI_SRC_AMODE_CONST |
+			SSI_CCR_ENABLE;
+		s_addr = omap_port->ssr_dma +
+					SSI_SSR_BUFFER_CH_REG(msg->channel);
+		d_addr = sg_dma_address(msg->sgt.sgl);
+	} else {
+		err = dma_map_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents,
+							DMA_TO_DEVICE);
+		if (err < 0) {
+			dev_dbg(&ssi->device, "DMA map SG failed !\n");
+			return err;
+		}
+		csdp = SSI_SRC_BURST_4x32_BIT | SSI_SRC_MEMORY_PORT |
+			SSI_DST_SINGLE_ACCESS0 | SSI_DST_PERIPHERAL_PORT |
+			SSI_DATA_TYPE_S32;
+		ccr = (msg->channel + 1 + (port->num * 8)) & 0xf; /* Sync */
+		ccr |= SSI_SRC_AMODE_POSTINC | SSI_DST_AMODE_CONST |
+			SSI_CCR_ENABLE;
+		s_addr = sg_dma_address(msg->sgt.sgl);
+		d_addr = omap_port->sst_dma +
+					SSI_SST_BUFFER_CH_REG(msg->channel);
+	}
+	dev_dbg(&ssi->device, "lch %d cdsp %08x ccr %04x s_addr %08x d_addr %08x\n",
+		lch, csdp, ccr, s_addr, d_addr);
+
+	/* Hold clocks during the transfer */
+	pm_runtime_get_sync(omap_port->pdev);
+
+	writew_relaxed(csdp, gdd + SSI_GDD_CSDP_REG(lch));
+	writew_relaxed(SSI_BLOCK_IE | SSI_TOUT_IE, gdd + SSI_GDD_CICR_REG(lch));
+	writel_relaxed(d_addr, gdd + SSI_GDD_CDSA_REG(lch));
+	writel_relaxed(s_addr, gdd + SSI_GDD_CSSA_REG(lch));
+	writew_relaxed(SSI_BYTES_TO_FRAMES(msg->sgt.sgl->length),
+						gdd + SSI_GDD_CEN_REG(lch));
+
+	spin_lock_bh(&omap_ssi->lock);
+	tmp = readl(omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	tmp |= SSI_GDD_LCH(lch);
+	writel_relaxed(tmp, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	spin_unlock_bh(&omap_ssi->lock);
+	writew(ccr, gdd + SSI_GDD_CCR_REG(lch));
+	msg->status = HSI_STATUS_PROCEEDING;
+
+	return 0;
+}
+
+static int ssi_start_pio(struct hsi_msg *msg)
+{
+	struct hsi_port *port = hsi_get_port(msg->cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	u32 val;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	if (msg->ttype == HSI_MSG_WRITE) {
+		val = SSI_DATAACCEPT(msg->channel);
+		/* Hold clocks for pio writes */
+		pm_runtime_get_sync(omap_port->pdev);
+	} else {
+		val = SSI_DATAAVAILABLE(msg->channel) | SSI_ERROROCCURED;
+	}
+	dev_dbg(&port->device, "Single %s transfer\n",
+						msg->ttype ? "write" : "read");
+	val |= readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	writel(val, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	pm_runtime_put_sync(omap_port->pdev);
+	msg->actual_len = 0;
+	msg->status = HSI_STATUS_PROCEEDING;
+
+	return 0;
+}
+
+static int ssi_start_transfer(struct list_head *queue)
+{
+	struct hsi_msg *msg;
+	int lch = -1;
+
+	if (list_empty(queue))
+		return 0;
+	msg = list_first_entry(queue, struct hsi_msg, link);
+	if (msg->status != HSI_STATUS_QUEUED)
+		return 0;
+	if ((msg->sgt.nents) && (msg->sgt.sgl->length > sizeof(u32)))
+		lch = ssi_claim_lch(msg);
+	if (lch >= 0)
+		return ssi_start_dma(msg, lch);
+	else
+		return ssi_start_pio(msg);
+}
+
+static int ssi_async_break(struct hsi_msg *msg)
+{
+	struct hsi_port *port = hsi_get_port(msg->cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	int err = 0;
+	u32 tmp;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	if (msg->ttype == HSI_MSG_WRITE) {
+		if (omap_port->sst.mode != SSI_MODE_FRAME) {
+			err = -EINVAL;
+			goto out;
+		}
+		writel(1, omap_port->sst_base + SSI_SST_BREAK_REG);
+		msg->status = HSI_STATUS_COMPLETED;
+		msg->complete(msg);
+	} else {
+		if (omap_port->ssr.mode != SSI_MODE_FRAME) {
+			err = -EINVAL;
+			goto out;
+		}
+		spin_lock_bh(&omap_port->lock);
+		tmp = readl(omap_ssi->sys +
+					SSI_MPU_ENABLE_REG(port->num, 0));
+		writel(tmp | SSI_BREAKDETECTED,
+			omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+		msg->status = HSI_STATUS_PROCEEDING;
+		list_add_tail(&msg->link, &omap_port->brkqueue);
+		spin_unlock_bh(&omap_port->lock);
+	}
+out:
+	pm_runtime_put_sync(omap_port->pdev);
+
+	return err;
+}
+
+static int ssi_async(struct hsi_msg *msg)
+{
+	struct hsi_port *port = hsi_get_port(msg->cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct list_head *queue;
+	int err = 0;
+
+	BUG_ON(!msg);
+
+	if (msg->sgt.nents > 1)
+		return -ENOSYS; /* TODO: Add sg support */
+
+	if (msg->break_frame)
+		return ssi_async_break(msg);
+
+	if (msg->ttype) {
+		BUG_ON(msg->channel >= omap_port->sst.channels);
+		queue = &omap_port->txqueue[msg->channel];
+	} else {
+		BUG_ON(msg->channel >= omap_port->ssr.channels);
+		queue = &omap_port->rxqueue[msg->channel];
+	}
+	msg->status = HSI_STATUS_QUEUED;
+	spin_lock_bh(&omap_port->lock);
+	list_add_tail(&msg->link, queue);
+	err = ssi_start_transfer(queue);
+	if (err < 0) {
+		list_del(&msg->link);
+		msg->status = HSI_STATUS_ERROR;
+	}
+	spin_unlock_bh(&omap_port->lock);
+	dev_dbg(&port->device, "msg status %d ttype %d ch %d\n",
+				msg->status, msg->ttype, msg->channel);
+
+	return err;
+}
+
+static u32 ssi_calculate_div(struct hsi_controller *ssi)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	u32 tx_fckrate = (u32) omap_ssi->fck_rate;
+
+	/* / 2 : SSI TX clock is always half of the SSI functional clock */
+	tx_fckrate >>= 1;
+	/* Round down when tx_fckrate % omap_ssi->max_speed == 0 */
+	tx_fckrate--;
+	dev_dbg(&ssi->device, "TX div %d for fck_rate %lu Khz speed %d Kb/s\n",
+			tx_fckrate / omap_ssi->max_speed, omap_ssi->fck_rate,
+							omap_ssi->max_speed);
+
+	return tx_fckrate / omap_ssi->max_speed;
+}
+
+static void ssi_flush_queue(struct list_head *queue, struct hsi_client *cl)
+{
+	struct list_head *node, *tmp;
+	struct hsi_msg *msg;
+
+	list_for_each_safe(node, tmp, queue) {
+		msg = list_entry(node, struct hsi_msg, link);
+		if ((cl) && (cl != msg->cl))
+			continue;
+		list_del(node);
+		pr_debug("flush queue: ch %d, msg %p len %d type %d ctxt %p\n",
+			msg->channel, msg, msg->sgt.sgl->length,
+					msg->ttype, msg->context);
+		if (msg->destructor)
+			msg->destructor(msg);
+		else
+			hsi_free_msg(msg);
+	}
+}
+
+static int ssi_setup(struct hsi_client *cl)
+{
+	struct hsi_port *port = to_hsi_port(cl->device.parent);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem *sst = omap_port->sst_base;
+	void __iomem *ssr = omap_port->ssr_base;
+	u32 div;
+	u32 val;
+	int err = 0;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	spin_lock_bh(&omap_port->lock);
+	if (cl->tx_cfg.speed)
+		omap_ssi->max_speed = cl->tx_cfg.speed;
+	div = ssi_calculate_div(ssi);
+	if (div > SSI_MAX_DIVISOR) {
+		dev_err(&cl->device, "Invalid TX speed %d Mb/s (div %d)\n",
+						cl->tx_cfg.speed, div);
+		err = -EINVAL;
+		goto out;
+	}
+	/* Set TX/RX module to sleep to stop TX/RX during cfg update */
+	writel_relaxed(SSI_MODE_SLEEP, sst + SSI_SST_MODE_REG);
+	writel_relaxed(SSI_MODE_SLEEP, ssr + SSI_SSR_MODE_REG);
+	/* Flush posted write */
+	val = readl(ssr + SSI_SSR_MODE_REG);
+	/* TX */
+	writel_relaxed(31, sst + SSI_SST_FRAMESIZE_REG);
+	writel_relaxed(div, sst + SSI_SST_DIVISOR_REG);
+	writel_relaxed(cl->tx_cfg.num_hw_channels, sst + SSI_SST_CHANNELS_REG);
+	writel_relaxed(cl->tx_cfg.arb_mode, sst + SSI_SST_ARBMODE_REG);
+	writel_relaxed(cl->tx_cfg.mode, sst + SSI_SST_MODE_REG);
+	/* RX */
+	writel_relaxed(31, ssr + SSI_SSR_FRAMESIZE_REG);
+	writel_relaxed(cl->rx_cfg.num_hw_channels, ssr + SSI_SSR_CHANNELS_REG);
+	writel_relaxed(0, ssr + SSI_SSR_TIMEOUT_REG);
+	/* Cleanup the break queue if we leave FRAME mode */
+	if ((omap_port->ssr.mode == SSI_MODE_FRAME) &&
+		(cl->rx_cfg.mode != SSI_MODE_FRAME))
+		ssi_flush_queue(&omap_port->brkqueue, cl);
+	writel_relaxed(cl->rx_cfg.mode, ssr + SSI_SSR_MODE_REG);
+	omap_port->channels = max(cl->rx_cfg.num_hw_channels, cl->tx_cfg.num_hw_channels);
+	/* Shadow registering for OFF mode */
+	/* SST */
+	omap_port->sst.divisor = div;
+	omap_port->sst.frame_size = 31;
+	omap_port->sst.channels = cl->tx_cfg.num_hw_channels;
+	omap_port->sst.arb_mode = cl->tx_cfg.arb_mode;
+	omap_port->sst.mode = cl->tx_cfg.mode;
+	/* SSR */
+	omap_port->ssr.frame_size = 31;
+	omap_port->ssr.timeout = 0;
+	omap_port->ssr.channels = cl->rx_cfg.num_hw_channels;
+	omap_port->ssr.mode = cl->rx_cfg.mode;
+out:
+	spin_unlock_bh(&omap_port->lock);
+	pm_runtime_put_sync(omap_port->pdev);
+
+	return err;
+}
+
+static int ssi_flush(struct hsi_client *cl)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct hsi_msg *msg;
+	void __iomem *sst = omap_port->sst_base;
+	void __iomem *ssr = omap_port->ssr_base;
+	unsigned int i;
+	u32 err;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	spin_lock_bh(&omap_port->lock);
+	/* Stop all DMA transfers */
+	for (i = 0; i < SSI_MAX_GDD_LCH; i++) {
+		msg = omap_ssi->gdd_trn[i].msg;
+		if (!msg || (port != hsi_get_port(msg->cl)))
+			continue;
+		writew_relaxed(0, omap_ssi->gdd + SSI_GDD_CCR_REG(i));
+		if (msg->ttype == HSI_MSG_READ)
+			pm_runtime_put_sync(omap_port->pdev);
+		omap_ssi->gdd_trn[i].msg = NULL;
+	}
+	/* Flush all SST buffers */
+	writel_relaxed(0, sst + SSI_SST_BUFSTATE_REG);
+	writel_relaxed(0, sst + SSI_SST_TXSTATE_REG);
+	/* Flush all SSR buffers */
+	writel_relaxed(0, ssr + SSI_SSR_RXSTATE_REG);
+	writel_relaxed(0, ssr + SSI_SSR_BUFSTATE_REG);
+	/* Flush all errors */
+	err = readl(ssr + SSI_SSR_ERROR_REG);
+	writel_relaxed(err, ssr + SSI_SSR_ERRORACK_REG);
+	/* Flush break */
+	writel_relaxed(0, ssr + SSI_SSR_BREAK_REG);
+	/* Clear interrupts */
+	writel_relaxed(0, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	writel_relaxed(0xffffff00,
+			omap_ssi->sys + SSI_MPU_STATUS_REG(port->num, 0));
+	writel_relaxed(0, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	writel(0xff, omap_ssi->sys + SSI_GDD_MPU_IRQ_STATUS_REG);
+	/* Dequeue all pending requests */
+	for (i = 0; i < omap_port->channels; i++) {
+		/* Release write clocks */
+		if (!list_empty(&omap_port->txqueue[i]))
+			pm_runtime_put_sync(omap_port->pdev);
+		ssi_flush_queue(&omap_port->txqueue[i], NULL);
+		ssi_flush_queue(&omap_port->rxqueue[i], NULL);
+	}
+	ssi_flush_queue(&omap_port->brkqueue, NULL);
+	spin_unlock_bh(&omap_port->lock);
+	pm_runtime_put_sync(omap_port->pdev);
+
+	return 0;
+}
+
+static int ssi_start_tx(struct hsi_client *cl)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	dev_dbg(&port->device, "Wake out high %d\n", omap_port->wk_refcount);
+
+	spin_lock_bh(&omap_port->wk_lock);
+	if (omap_port->wk_refcount++) {
+		spin_unlock_bh(&omap_port->wk_lock);
+		return 0;
+	}
+	pm_runtime_get_sync(omap_port->pdev); /* Grab clocks */
+	writel(SSI_WAKE(0), omap_ssi->sys + SSI_SET_WAKE_REG(port->num));
+	spin_unlock_bh(&omap_port->wk_lock);
+
+	return 0;
+}
+
+static int ssi_stop_tx(struct hsi_client *cl)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	dev_dbg(&port->device, "Wake out low %d\n", omap_port->wk_refcount);
+
+	spin_lock_bh(&omap_port->wk_lock);
+	BUG_ON(!omap_port->wk_refcount);
+	if (--omap_port->wk_refcount) {
+		spin_unlock_bh(&omap_port->wk_lock);
+		return 0;
+	}
+	writel(SSI_WAKE(0),
+				omap_ssi->sys + SSI_CLEAR_WAKE_REG(port->num));
+	pm_runtime_put_sync(omap_port->pdev); /* Release clocks */
+	spin_unlock_bh(&omap_port->wk_lock);
+
+	return 0;
+}
+
+static void ssi_transfer(struct omap_ssi_port *omap_port,
+							struct list_head *queue)
+{
+	struct hsi_msg *msg;
+	int err = -1;
+
+	spin_lock_bh(&omap_port->lock);
+	while (err < 0) {
+		err = ssi_start_transfer(queue);
+		if (err < 0) {
+			msg = list_first_entry(queue, struct hsi_msg, link);
+			msg->status = HSI_STATUS_ERROR;
+			msg->actual_len = 0;
+			list_del(&msg->link);
+			spin_unlock_bh(&omap_port->lock);
+			msg->complete(msg);
+			spin_lock_bh(&omap_port->lock);
+		}
+	}
+	spin_unlock_bh(&omap_port->lock);
+}
+
+static void ssi_cleanup_queues(struct hsi_client *cl)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct hsi_msg *msg;
+	unsigned int i;
+	u32 rxbufstate = 0;
+	u32 txbufstate = 0;
+	u32 status = SSI_ERROROCCURED;
+	u32 tmp;
+
+	ssi_flush_queue(&omap_port->brkqueue, cl);
+	if (list_empty(&omap_port->brkqueue))
+		status |= SSI_BREAKDETECTED;
+
+	for (i = 0; i < omap_port->channels; i++) {
+		if (list_empty(&omap_port->txqueue[i]))
+			continue;
+		msg = list_first_entry(&omap_port->txqueue[i], struct hsi_msg,
+									link);
+		if ((msg->cl == cl) && (msg->status == HSI_STATUS_PROCEEDING)) {
+			txbufstate |= (1 << i);
+			status |= SSI_DATAACCEPT(i);
+			/* Release the clocks writes, also GDD ones */
+			pm_runtime_put_sync(omap_port->pdev);
+		}
+		ssi_flush_queue(&omap_port->txqueue[i], cl);
+	}
+	for (i = 0; i < omap_port->channels; i++) {
+		if (list_empty(&omap_port->rxqueue[i]))
+			continue;
+		msg = list_first_entry(&omap_port->rxqueue[i], struct hsi_msg,
+									link);
+		if ((msg->cl == cl) && (msg->status == HSI_STATUS_PROCEEDING)) {
+			rxbufstate |= (1 << i);
+			status |= SSI_DATAAVAILABLE(i);
+		}
+		ssi_flush_queue(&omap_port->rxqueue[i], cl);
+		/* Check if we keep the error detection interrupt armed */
+		if (!list_empty(&omap_port->rxqueue[i]))
+			status &= ~SSI_ERROROCCURED;
+	}
+	/* Cleanup write buffers */
+	tmp = readl(omap_port->sst_base + SSI_SST_BUFSTATE_REG);
+	tmp &= ~txbufstate;
+	writel_relaxed(tmp, omap_port->sst_base + SSI_SST_BUFSTATE_REG);
+	/* Cleanup read buffers */
+	tmp = readl(omap_port->ssr_base + SSI_SSR_BUFSTATE_REG);
+	tmp &= ~rxbufstate;
+	writel_relaxed(tmp, omap_port->ssr_base + SSI_SSR_BUFSTATE_REG);
+	/* Disarm and ack pending interrupts */
+	tmp = readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	tmp &= ~status;
+	writel_relaxed(tmp, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	writel_relaxed(status, omap_ssi->sys +
+		SSI_MPU_STATUS_REG(port->num, 0));
+}
+
+static void ssi_cleanup_gdd(struct hsi_controller *ssi, struct hsi_client *cl)
+{
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_msg *msg;
+	unsigned int i;
+	u32 val = 0;
+	u32 tmp;
+
+	for (i = 0; i < SSI_MAX_GDD_LCH; i++) {
+		msg = omap_ssi->gdd_trn[i].msg;
+		if ((!msg) || (msg->cl != cl))
+			continue;
+		writew_relaxed(0, omap_ssi->gdd + SSI_GDD_CCR_REG(i));
+		val |= (1 << i);
+		/*
+		 * Clock references for write will be handled in
+		 * ssi_cleanup_queues
+		 */
+		if (msg->ttype == HSI_MSG_READ)
+			pm_runtime_put_sync(omap_port->pdev);
+		omap_ssi->gdd_trn[i].msg = NULL;
+	}
+	tmp = readl_relaxed(omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	tmp &= ~val;
+	writel_relaxed(tmp, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	writel(val, omap_ssi->sys + SSI_GDD_MPU_IRQ_STATUS_REG);
+}
+
+static int ssi_set_port_mode(struct omap_ssi_port *omap_port, u32 mode)
+{
+	writel(mode, omap_port->sst_base + SSI_SST_MODE_REG);
+	writel(mode, omap_port->ssr_base + SSI_SSR_MODE_REG);
+	/* OCP barrier */
+	mode = readl(omap_port->ssr_base + SSI_SSR_MODE_REG);
+
+	return 0;
+}
+
+static int ssi_release(struct hsi_client *cl)
+{
+	struct hsi_port *port = hsi_get_port(cl);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+
+	spin_lock_bh(&omap_port->lock);
+	pm_runtime_get_sync(omap_port->pdev);
+	/* Stop all the pending DMA requests for that client */
+	ssi_cleanup_gdd(ssi, cl);
+	/* Now cleanup all the queues */
+	ssi_cleanup_queues(cl);
+	pm_runtime_put_sync(omap_port->pdev);
+	/* If it is the last client of the port, do extra checks and cleanup */
+	if (port->claimed <= 1) {
+		/*
+		 * Drop the clock reference for the incoming wake line
+		 * if it is still kept high by the other side.
+		 */
+		if (omap_port->wkin_cken) {
+			pm_runtime_put_sync(omap_port->pdev);
+			omap_port->wkin_cken = 0;
+		}
+		pm_runtime_get_sync(omap_port->pdev);
+		/* Stop any SSI TX/RX without a client */
+		ssi_set_port_mode(omap_port, SSI_MODE_SLEEP);
+		omap_port->sst.mode = SSI_MODE_SLEEP;
+		omap_port->ssr.mode = SSI_MODE_SLEEP;
+		pm_runtime_put_sync(omap_port->pdev);
+		WARN_ON(omap_port->wk_refcount != 0);
+	}
+	spin_unlock_bh(&omap_port->lock);
+
+	return 0;
+}
+
+
+
+static void ssi_error(struct hsi_port *port)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct hsi_msg *msg;
+	unsigned int i;
+	u32 err;
+	u32 val;
+	u32 tmp;
+
+	/* ACK error */
+	err = readl(omap_port->ssr_base + SSI_SSR_ERROR_REG);
+	dev_err(&port->device, "SSI error: 0x%02x\n", err);
+	if (!err) {
+		dev_dbg(&port->device, "spurious SSI error ignored!\n");
+		return;
+	}
+	spin_lock(&omap_ssi->lock);
+	/* Cancel all GDD read transfers */
+	for (i = 0, val = 0; i < SSI_MAX_GDD_LCH; i++) {
+		msg = omap_ssi->gdd_trn[i].msg;
+		if ((msg) && (msg->ttype == HSI_MSG_READ)) {
+			writew_relaxed(0, omap_ssi->gdd + SSI_GDD_CCR_REG(i));
+			val |= (1 << i);
+			omap_ssi->gdd_trn[i].msg = NULL;
+		}
+	}
+	tmp = readl(omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	tmp &= ~val;
+	writel_relaxed(tmp, omap_ssi->sys + SSI_GDD_MPU_IRQ_ENABLE_REG);
+	spin_unlock(&omap_ssi->lock);
+	/* Cancel all PIO read transfers */
+	spin_lock(&omap_port->lock);
+	tmp = readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	tmp &= 0xfeff00ff; /* Disable error & all dataavailable interrupts */
+	writel_relaxed(tmp, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	/* ACK error */
+	writel_relaxed(err, omap_port->ssr_base + SSI_SSR_ERRORACK_REG);
+	writel_relaxed(SSI_ERROROCCURED,
+			omap_ssi->sys + SSI_MPU_STATUS_REG(port->num, 0));
+	/* Signal the error all current pending read requests */
+	for (i = 0; i < omap_port->channels; i++) {
+		if (list_empty(&omap_port->rxqueue[i]))
+			continue;
+		msg = list_first_entry(&omap_port->rxqueue[i], struct hsi_msg,
+									link);
+		list_del(&msg->link);
+		msg->status = HSI_STATUS_ERROR;
+		spin_unlock(&omap_port->lock);
+		msg->complete(msg);
+		/* Now restart queued reads if any */
+		ssi_transfer(omap_port, &omap_port->rxqueue[i]);
+		spin_lock(&omap_port->lock);
+	}
+	spin_unlock(&omap_port->lock);
+}
+
+static void ssi_break_complete(struct hsi_port *port)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct hsi_msg *msg;
+	struct hsi_msg *tmp;
+	u32 val;
+
+	dev_dbg(&port->device, "HWBREAK received\n");
+
+	spin_lock(&omap_port->lock);
+	val = readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	val &= ~SSI_BREAKDETECTED;
+	writel_relaxed(val, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	writel_relaxed(0, omap_port->ssr_base + SSI_SSR_BREAK_REG);
+	writel(SSI_BREAKDETECTED,
+			omap_ssi->sys + SSI_MPU_STATUS_REG(port->num, 0));
+	spin_unlock(&omap_port->lock);
+
+	list_for_each_entry_safe(msg, tmp, &omap_port->brkqueue, link) {
+		msg->status = HSI_STATUS_COMPLETED;
+		spin_lock(&omap_port->lock);
+		list_del(&msg->link);
+		spin_unlock(&omap_port->lock);
+		msg->complete(msg);
+	}
+
+}
+
+static void ssi_pio_complete(struct hsi_port *port, struct list_head *queue)
+{
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_msg *msg;
+	u32 *buf;
+	u32 reg;
+	u32 val;
+
+	spin_lock(&omap_port->lock);
+	msg = list_first_entry(queue, struct hsi_msg, link);
+	if ((!msg->sgt.nents) || (!msg->sgt.sgl->length)) {
+		msg->actual_len = 0;
+		msg->status = HSI_STATUS_PENDING;
+	}
+	if (msg->ttype == HSI_MSG_WRITE)
+		val = SSI_DATAACCEPT(msg->channel);
+	else
+		val = SSI_DATAAVAILABLE(msg->channel);
+	if (msg->status == HSI_STATUS_PROCEEDING) {
+		buf = sg_virt(msg->sgt.sgl) + msg->actual_len;
+		if (msg->ttype == HSI_MSG_WRITE)
+			writel(*buf, omap_port->sst_base +
+					SSI_SST_BUFFER_CH_REG(msg->channel));
+		 else
+			*buf = readl(omap_port->ssr_base +
+					SSI_SSR_BUFFER_CH_REG(msg->channel));
+		dev_dbg(&port->device, "ch %d ttype %d 0x%08x\n", msg->channel,
+							msg->ttype, *buf);
+		msg->actual_len += sizeof(*buf);
+		if (msg->actual_len >= msg->sgt.sgl->length)
+			msg->status = HSI_STATUS_COMPLETED;
+		/*
+		 * Wait for the last written frame to be really sent before
+		 * we call the complete callback
+		 */
+		if ((msg->status == HSI_STATUS_PROCEEDING) ||
+				((msg->status == HSI_STATUS_COMPLETED) &&
+					(msg->ttype == HSI_MSG_WRITE))) {
+			writel(val, omap_ssi->sys +
+					SSI_MPU_STATUS_REG(port->num, 0));
+			spin_unlock(&omap_port->lock);
+
+			return;
+		}
+
+	}
+	/* Transfer completed at this point */
+	reg = readl(omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	if (msg->ttype == HSI_MSG_WRITE) {
+		/* Release clocks for write transfer */
+		pm_runtime_put_sync(omap_port->pdev);
+	}
+	reg &= ~val;
+	writel_relaxed(reg, omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	writel_relaxed(val, omap_ssi->sys + SSI_MPU_STATUS_REG(port->num, 0));
+	list_del(&msg->link);
+	spin_unlock(&omap_port->lock);
+	msg->complete(msg);
+	ssi_transfer(omap_port, queue);
+}
+
+static void ssi_pio_tasklet(unsigned long ssi_port)
+{
+	struct hsi_port *port = (struct hsi_port *)ssi_port;
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem *sys = omap_ssi->sys;
+	unsigned int ch;
+	u32 status_reg;
+
+	pm_runtime_get_sync(omap_port->pdev);
+	status_reg = readl(sys + SSI_MPU_STATUS_REG(port->num, 0));
+	status_reg &= readl(sys + SSI_MPU_ENABLE_REG(port->num, 0));
+
+	for (ch = 0; ch < omap_port->channels; ch++) {
+		if (status_reg & SSI_DATAACCEPT(ch))
+			ssi_pio_complete(port, &omap_port->txqueue[ch]);
+		if (status_reg & SSI_DATAAVAILABLE(ch))
+			ssi_pio_complete(port, &omap_port->rxqueue[ch]);
+	}
+	if (status_reg & SSI_BREAKDETECTED)
+		ssi_break_complete(port);
+	if (status_reg & SSI_ERROROCCURED)
+		ssi_error(port);
+
+	status_reg = readl(sys + SSI_MPU_STATUS_REG(port->num, 0));
+	status_reg &= readl(sys + SSI_MPU_ENABLE_REG(port->num, 0));
+	pm_runtime_put_sync(omap_port->pdev);
+
+	if (status_reg)
+		tasklet_hi_schedule(&omap_port->pio_tasklet);
+	else
+		enable_irq(omap_port->irq);
+}
+
+static irqreturn_t ssi_pio_isr(int irq, void *port)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+
+	tasklet_hi_schedule(&omap_port->pio_tasklet);
+	disable_irq_nosync(irq);
+
+	return IRQ_HANDLED;
+}
+
+static void ssi_wake_tasklet(unsigned long ssi_port)
+{
+	struct hsi_port *port = (struct hsi_port *)ssi_port;
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	if (ssi_wakein(port)) {
+		/**
+		 * We can have a quick High-Low-High transition in the line.
+		 * In such a case if we have long interrupt latencies,
+		 * we can miss the low event or get twice a high event.
+		 * This workaround will avoid breaking the clock reference
+		 * count when such a situation ocurrs.
+		 */
+		spin_lock(&omap_port->lock);
+		if (!omap_port->wkin_cken) {
+			omap_port->wkin_cken = 1;
+			pm_runtime_get_sync(omap_port->pdev);
+		}
+		spin_unlock(&omap_port->lock);
+		dev_dbg(&ssi->device, "Wake in high\n");
+		if (omap_port->wktest) { /* FIXME: HACK ! To be removed */
+			writel(SSI_WAKE(0),
+				omap_ssi->sys + SSI_SET_WAKE_REG(port->num));
+		}
+		hsi_event(port, HSI_EVENT_START_RX);
+	} else {
+		dev_dbg(&ssi->device, "Wake in low\n");
+		if (omap_port->wktest) { /* FIXME: HACK ! To be removed */
+			writel(SSI_WAKE(0),
+				omap_ssi->sys + SSI_CLEAR_WAKE_REG(port->num));
+		}
+		hsi_event(port, HSI_EVENT_STOP_RX);
+		spin_lock(&omap_port->lock);
+		if (omap_port->wkin_cken) {
+			pm_runtime_put_sync(omap_port->pdev);
+			omap_port->wkin_cken = 0;
+		}
+		spin_unlock(&omap_port->lock);
+	}
+}
+
+static irqreturn_t ssi_wake_isr(int irq __maybe_unused, void *ssi_port)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(ssi_port);
+
+	tasklet_hi_schedule(&omap_port->wake_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+static int __init ssi_port_irq(struct hsi_port *port,
+						struct platform_device *pd)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct resource *irq;
+	int err;
+
+	irq = platform_get_resource_byname(pd, IORESOURCE_IRQ, "mpu_irq0");
+	if (!irq) {
+		dev_err(&port->device, "Port IRQ resource missing\n");
+		return -ENXIO;
+	}
+	omap_port->irq = irq->start;
+	tasklet_init(&omap_port->pio_tasklet, ssi_pio_tasklet,
+							(unsigned long)port);
+	err = devm_request_irq(&port->device, omap_port->irq, ssi_pio_isr,
+						0, irq->name, port);
+	if (err < 0)
+		dev_err(&port->device, "Request IRQ %d failed (%d)\n",
+							omap_port->irq, err);
+	return err;
+}
+
+static int __init ssi_wake_irq(struct hsi_port *port,
+						struct platform_device *pd)
+{
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	int cawake_irq;
+	int err;
+
+	if (omap_port->wake_gpio == -1) {
+		omap_port->wake_irq = -1;
+		return 0;
+	}
+
+	cawake_irq = gpio_to_irq(omap_port->wake_gpio);
+
+	omap_port->wake_irq = cawake_irq;
+	tasklet_init(&omap_port->wake_tasklet, ssi_wake_tasklet,
+							(unsigned long)port);
+	err = devm_request_irq(&port->device, cawake_irq, ssi_wake_isr,
+		IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
+							"cawake", port);
+	if (err < 0)
+		dev_err(&port->device, "Request Wake in IRQ %d failed %d\n",
+						cawake_irq, err);
+	err = enable_irq_wake(cawake_irq);
+	if (err < 0)
+		dev_err(&port->device, "Enable wake on the wakeline in irq %d failed %d\n",
+			cawake_irq, err);
+
+	return err;
+}
+
+static void __init ssi_queues_init(struct omap_ssi_port *omap_port)
+{
+	unsigned int ch;
+
+	for (ch = 0; ch < SSI_MAX_CHANNELS; ch++) {
+		INIT_LIST_HEAD(&omap_port->txqueue[ch]);
+		INIT_LIST_HEAD(&omap_port->rxqueue[ch]);
+	}
+	INIT_LIST_HEAD(&omap_port->brkqueue);
+}
+
+static int __init ssi_port_get_iomem(struct platform_device *pd,
+		const char *name, void __iomem **pbase, dma_addr_t *phy)
+{
+	struct hsi_port *port = platform_get_drvdata(pd);
+	struct resource *mem;
+	struct resource *ioarea;
+	void __iomem *base;
+
+	mem = platform_get_resource_byname(pd, IORESOURCE_MEM, name);
+	if (!mem) {
+		dev_err(&pd->dev, "IO memory region missing (%s)\n", name);
+		return -ENXIO;
+	}
+	ioarea = devm_request_mem_region(&port->device, mem->start,
+					resource_size(mem), dev_name(&pd->dev));
+	if (!ioarea) {
+		dev_err(&pd->dev, "%s IO memory region request failed\n",
+								mem->name);
+		return -ENXIO;
+	}
+	base = devm_ioremap(&port->device, mem->start, resource_size(mem));
+	if (!base) {
+		dev_err(&pd->dev, "%s IO remap failed\n", mem->name);
+		return -ENXIO;
+	}
+	*pbase = base;
+
+	if (phy)
+		*phy = mem->start;
+
+	return 0;
+}
+
+static int __init ssi_port_probe(struct platform_device *pd)
+{
+	struct device_node *np = pd->dev.of_node;
+	struct hsi_port *port;
+	struct omap_ssi_port *omap_port;
+	struct hsi_controller *ssi = dev_get_drvdata(pd->dev.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	u32 cawake_gpio = 0;
+	u32 port_id;
+	int err;
+
+	dev_dbg(&pd->dev, "init ssi port...\n");
+
+	err = ref_module(THIS_MODULE, ssi->owner);
+	if (err) {
+		dev_err(&pd->dev, "could not increment parent module refcount (err=%d)\n",
+			err);
+		return -ENODEV;
+	}
+
+	if (!ssi->port || !omap_ssi->port) {
+		dev_err(&pd->dev, "ssi controller not initialized!\n");
+		err = -ENODEV;
+		goto error;
+	}
+
+	/* get id of first uninitialized port in controller */
+	for (port_id = 0; port_id < ssi->num_ports && omap_ssi->port[port_id];
+		port_id++)
+		;
+
+	if (port_id >= ssi->num_ports) {
+		dev_err(&pd->dev, "port id out of range!\n");
+		err = -ENODEV;
+		goto error;
+	}
+
+	port = ssi->port[port_id];
+
+	if (!np) {
+		dev_err(&pd->dev, "missing device tree data\n");
+		err = -EINVAL;
+		goto error;
+	}
+
+	cawake_gpio = of_get_named_gpio(np, "ti,ssi-cawake-gpio", 0);
+	if (cawake_gpio < 0) {
+		dev_err(&pd->dev, "DT data is missing cawake gpio (err=%d)\n",
+			cawake_gpio);
+		err = -ENODEV;
+		goto error;
+	}
+
+	err = devm_gpio_request_one(&port->device, cawake_gpio, GPIOF_DIR_IN,
+		"cawake");
+	if (err) {
+		dev_err(&pd->dev, "could not request cawake gpio (err=%d)!\n",
+			err);
+		err = -ENXIO;
+		goto error;
+	}
+
+	omap_port = devm_kzalloc(&port->device, sizeof(*omap_port), GFP_KERNEL);
+	if (!omap_port) {
+		err = -ENOMEM;
+		goto error;
+	}
+	omap_port->wake_gpio = cawake_gpio;
+	omap_port->pdev = &pd->dev;
+	omap_port->port_id = port_id;
+
+	/* initialize HSI port */
+	port->async	= ssi_async;
+	port->setup	= ssi_setup;
+	port->flush	= ssi_flush;
+	port->start_tx	= ssi_start_tx;
+	port->stop_tx	= ssi_stop_tx;
+	port->release	= ssi_release;
+	hsi_port_set_drvdata(port, omap_port);
+	omap_ssi->port[port_id] = omap_port;
+
+	platform_set_drvdata(pd, port);
+
+	err = ssi_port_get_iomem(pd, "tx", &omap_port->sst_base,
+		&omap_port->sst_dma);
+	if (err < 0)
+		goto error;
+	err = ssi_port_get_iomem(pd, "rx", &omap_port->ssr_base,
+		&omap_port->ssr_dma);
+	if (err < 0)
+		goto error;
+
+	err = ssi_port_irq(port, pd);
+	if (err < 0)
+		goto error;
+	err = ssi_wake_irq(port, pd);
+	if (err < 0)
+		goto error;
+
+	ssi_queues_init(omap_port);
+	spin_lock_init(&omap_port->lock);
+	spin_lock_init(&omap_port->wk_lock);
+	omap_port->dev = &port->device;
+
+	pm_runtime_irq_safe(omap_port->pdev);
+	pm_runtime_enable(omap_port->pdev);
+
+#ifdef CONFIG_DEBUG_FS
+	err = ssi_debug_add_port(omap_port, omap_ssi->dir);
+	if (err < 0) {
+		pm_runtime_disable(omap_port->pdev);
+		goto error;
+	}
+#endif
+
+	hsi_add_clients_from_dt(port, np);
+
+	dev_info(&pd->dev, "ssi port %u successfully initialized (cawake=%d)\n",
+		port_id, cawake_gpio);
+
+	return 0;
+
+error:
+	return err;
+}
+
+static int __exit ssi_port_remove(struct platform_device *pd)
+{
+	struct hsi_port *port = platform_get_drvdata(pd);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+#ifdef CONFIG_DEBUG_FS
+	ssi_debug_remove_port(port);
+#endif
+
+	hsi_port_unregister_clients(port);
+
+	tasklet_kill(&omap_port->wake_tasklet);
+	tasklet_kill(&omap_port->pio_tasklet);
+
+	port->async	= hsi_dummy_msg;
+	port->setup	= hsi_dummy_cl;
+	port->flush	= hsi_dummy_cl;
+	port->start_tx	= hsi_dummy_cl;
+	port->stop_tx	= hsi_dummy_cl;
+	port->release	= hsi_dummy_cl;
+
+	omap_ssi->port[omap_port->port_id] = NULL;
+	platform_set_drvdata(pd, NULL);
+	pm_runtime_disable(&pd->dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM_RUNTIME
+static int ssi_save_port_ctx(struct omap_ssi_port *omap_port)
+{
+	struct hsi_port *port = to_hsi_port(omap_port->dev);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	omap_port->sys_mpu_enable = readl(omap_ssi->sys +
+					SSI_MPU_ENABLE_REG(port->num, 0));
+
+	return 0;
+}
+
+static int ssi_restore_port_ctx(struct omap_ssi_port *omap_port)
+{
+	struct hsi_port *port = to_hsi_port(omap_port->dev);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+	void __iomem	*base;
+
+	writel_relaxed(omap_port->sys_mpu_enable,
+			omap_ssi->sys + SSI_MPU_ENABLE_REG(port->num, 0));
+
+	/* SST context */
+	base = omap_port->sst_base;
+	writel_relaxed(omap_port->sst.frame_size, base + SSI_SST_FRAMESIZE_REG);
+	writel_relaxed(omap_port->sst.channels, base + SSI_SST_CHANNELS_REG);
+	writel_relaxed(omap_port->sst.arb_mode, base + SSI_SST_ARBMODE_REG);
+
+	/* SSR context */
+	base = omap_port->ssr_base;
+	writel_relaxed(omap_port->ssr.frame_size, base + SSI_SSR_FRAMESIZE_REG);
+	writel_relaxed(omap_port->ssr.channels, base + SSI_SSR_CHANNELS_REG);
+	writel_relaxed(omap_port->ssr.timeout, base + SSI_SSR_TIMEOUT_REG);
+
+	return 0;
+}
+
+static int ssi_restore_port_mode(struct omap_ssi_port *omap_port)
+{
+	u32 mode;
+
+	writel_relaxed(omap_port->sst.mode,
+				omap_port->sst_base + SSI_SST_MODE_REG);
+	writel_relaxed(omap_port->ssr.mode,
+				omap_port->ssr_base + SSI_SSR_MODE_REG);
+	/* OCP barrier */
+	mode = readl(omap_port->ssr_base + SSI_SSR_MODE_REG);
+
+	return 0;
+}
+
+static int ssi_restore_divisor(struct omap_ssi_port *omap_port)
+{
+	writel_relaxed(omap_port->sst.divisor,
+				omap_port->sst_base + SSI_SST_DIVISOR_REG);
+
+	return 0;
+}
+
+static int omap_ssi_port_runtime_suspend(struct device *dev)
+{
+	struct hsi_port *port = dev_get_drvdata(dev);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	dev_dbg(dev, "port runtime suspend!\n");
+
+	ssi_set_port_mode(omap_port, SSI_MODE_SLEEP);
+	if (omap_ssi->get_loss)
+		omap_port->loss_count =
+				omap_ssi->get_loss(ssi->device.parent);
+	ssi_save_port_ctx(omap_port);
+
+	return 0;
+}
+
+static int omap_ssi_port_runtime_resume(struct device *dev)
+{
+	struct hsi_port *port = dev_get_drvdata(dev);
+	struct omap_ssi_port *omap_port = hsi_port_drvdata(port);
+	struct hsi_controller *ssi = to_hsi_controller(port->device.parent);
+	struct omap_ssi_controller *omap_ssi = hsi_controller_drvdata(ssi);
+
+	dev_dbg(dev, "port runtime resume!\n");
+
+	if ((omap_ssi->get_loss) && (omap_port->loss_count ==
+				omap_ssi->get_loss(ssi->device.parent)))
+		goto mode; /* We always need to restore the mode & TX divisor */
+
+	ssi_restore_port_ctx(omap_port);
+
+mode:
+	ssi_restore_divisor(omap_port);
+	ssi_restore_port_mode(omap_port);
+
+	return 0;
+}
+
+static const struct dev_pm_ops omap_ssi_port_pm_ops = {
+	SET_RUNTIME_PM_OPS(omap_ssi_port_runtime_suspend,
+		omap_ssi_port_runtime_resume, NULL)
+};
+
+#define DEV_PM_OPS     (&omap_ssi_port_pm_ops)
+#else
+#define DEV_PM_OPS     NULL
+#endif
+
+
+#ifdef CONFIG_OF
+static const struct of_device_id omap_ssi_port_of_match[] = {
+	{ .compatible = "ti,omap3-ssi-port", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, omap_ssi_port_of_match);
+#else
+#define omap_ssi_port_of_match NULL
+#endif
+
+static struct platform_driver ssi_port_pdriver = {
+	.remove	= __exit_p(ssi_port_remove),
+	.driver	= {
+		.name	= "omap_ssi_port",
+		.owner	= THIS_MODULE,
+		.of_match_table = omap_ssi_port_of_match,
+		.pm	= DEV_PM_OPS,
+	},
+};
+
+module_platform_driver_probe(ssi_port_pdriver, ssi_port_probe);
+
+MODULE_ALIAS("platform:omap_ssi_port");
+MODULE_AUTHOR("Carlos Chinea <carlos.chinea@nokia.com>");
+MODULE_AUTHOR("Sebastian Reichel <sre@debian.org>");
+MODULE_DESCRIPTION("Synchronous Serial Interface Port Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/hsi/controllers/omap_ssi_regs.h b/drivers/hsi/controllers/omap_ssi_regs.h
new file mode 100644
index 0000000..08f98dd
--- /dev/null
+++ b/drivers/hsi/controllers/omap_ssi_regs.h
@@ -0,0 +1,171 @@
+/* Hardware definitions for SSI.
+ *
+ * Copyright (C) 2010 Nokia Corporation. All rights reserved.
+ *
+ * Contact: Carlos Chinea <carlos.chinea@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ */
+
+#ifndef __OMAP_SSI_REGS_H__
+#define __OMAP_SSI_REGS_H__
+
+/*
+ * SSI SYS registers
+ */
+#define SSI_REVISION_REG    0
+#  define SSI_REV_MAJOR    0xf0
+#  define SSI_REV_MINOR    0xf
+#define SSI_SYSCONFIG_REG    0x10
+#  define SSI_AUTOIDLE    (1 << 0)
+#  define SSI_SOFTRESET    (1 << 1)
+#  define SSI_SIDLEMODE_FORCE  0
+#  define SSI_SIDLEMODE_NO    (1 << 3)
+#  define SSI_SIDLEMODE_SMART  (1 << 4)
+#  define SSI_SIDLEMODE_MASK  0x18
+#  define SSI_MIDLEMODE_FORCE  0
+#  define SSI_MIDLEMODE_NO    (1 << 12)
+#  define SSI_MIDLEMODE_SMART  (1 << 13)
+#  define SSI_MIDLEMODE_MASK  0x3000
+#define SSI_SYSSTATUS_REG    0x14
+#  define SSI_RESETDONE    1
+#define SSI_MPU_STATUS_REG(port, irq)  (0x808 + ((port) * 0x10) + ((irq) * 2))
+#define SSI_MPU_ENABLE_REG(port, irq)  (0x80c + ((port) * 0x10) + ((irq) * 8))
+#  define SSI_DATAACCEPT(channel)    (1 << (channel))
+#  define SSI_DATAAVAILABLE(channel)  (1 << ((channel) + 8))
+#  define SSI_DATAOVERRUN(channel)    (1 << ((channel) + 16))
+#  define SSI_ERROROCCURED      (1 << 24)
+#  define SSI_BREAKDETECTED    (1 << 25)
+#define SSI_GDD_MPU_IRQ_STATUS_REG  0x0800
+#define SSI_GDD_MPU_IRQ_ENABLE_REG  0x0804
+#  define SSI_GDD_LCH(channel)  (1 << (channel))
+#define SSI_WAKE_REG(port)    (0xc00 + ((port) * 0x10))
+#define SSI_CLEAR_WAKE_REG(port)  (0xc04 + ((port) * 0x10))
+#define SSI_SET_WAKE_REG(port)    (0xc08 + ((port) * 0x10))
+#  define SSI_WAKE(channel)  (1 << (channel))
+#  define SSI_WAKE_MASK    0xff
+
+/*
+ * SSI SST registers
+ */
+#define SSI_SST_ID_REG      0
+#define SSI_SST_MODE_REG    4
+#  define SSI_MODE_VAL_MASK  3
+#  define SSI_MODE_SLEEP    0
+#  define SSI_MODE_STREAM    1
+#  define SSI_MODE_FRAME    2
+#  define SSI_MODE_MULTIPOINTS  3
+#define SSI_SST_FRAMESIZE_REG    8
+#  define SSI_FRAMESIZE_DEFAULT  31
+#define SSI_SST_TXSTATE_REG    0xc
+#  define  SSI_TXSTATE_IDLE  0
+#define SSI_SST_BUFSTATE_REG    0x10
+#  define  SSI_FULL(channel)  (1 << (channel))
+#define SSI_SST_DIVISOR_REG    0x18
+#  define SSI_MAX_DIVISOR    127
+#define SSI_SST_BREAK_REG    0x20
+#define SSI_SST_CHANNELS_REG    0x24
+#  define SSI_CHANNELS_DEFAULT  4
+#define SSI_SST_ARBMODE_REG    0x28
+#  define SSI_ARBMODE_ROUNDROBIN  0
+#  define SSI_ARBMODE_PRIORITY  1
+#define SSI_SST_BUFFER_CH_REG(channel)  (0x80 + ((channel) * 4))
+#define SSI_SST_SWAPBUF_CH_REG(channel)  (0xc0 + ((channel) * 4))
+
+/*
+ * SSI SSR registers
+ */
+#define SSI_SSR_ID_REG      0
+#define SSI_SSR_MODE_REG    4
+#define SSI_SSR_FRAMESIZE_REG    8
+#define SSI_SSR_RXSTATE_REG    0xc
+#define SSI_SSR_BUFSTATE_REG    0x10
+#  define SSI_NOTEMPTY(channel)  (1 << (channel))
+#define SSI_SSR_BREAK_REG    0x1c
+#define SSI_SSR_ERROR_REG    0x20
+#define SSI_SSR_ERRORACK_REG    0x24
+#define SSI_SSR_OVERRUN_REG    0x2c
+#define SSI_SSR_OVERRUNACK_REG    0x30
+#define SSI_SSR_TIMEOUT_REG    0x34
+#  define SSI_TIMEOUT_DEFAULT  0
+#define SSI_SSR_CHANNELS_REG    0x28
+#define SSI_SSR_BUFFER_CH_REG(channel)  (0x80 + ((channel) * 4))
+#define SSI_SSR_SWAPBUF_CH_REG(channel)  (0xc0 + ((channel) * 4))
+
+/*
+ * SSI GDD registers
+ */
+#define SSI_GDD_HW_ID_REG    0
+#define SSI_GDD_PPORT_ID_REG    0x10
+#define SSI_GDD_MPORT_ID_REG    0x14
+#define SSI_GDD_PPORT_SR_REG    0x20
+#define SSI_GDD_MPORT_SR_REG    0x24
+#  define SSI_ACTIVE_LCH_NUM_MASK  0xff
+#define SSI_GDD_TEST_REG    0x40
+#  define SSI_TEST      1
+#define SSI_GDD_GCR_REG      0x100
+#  define  SSI_CLK_AUTOGATING_ON  (1 << 3)
+#  define  SSI_FREE    (1 << 2)
+#  define  SSI_SWITCH_OFF    (1 << 0)
+#define SSI_GDD_GRST_REG    0x200
+#  define SSI_SWRESET    1
+#define SSI_GDD_CSDP_REG(channel)  (0x800 + ((channel) * 0x40))
+#  define SSI_DST_BURST_EN_MASK  0xc000
+#  define SSI_DST_SINGLE_ACCESS0  0
+#  define SSI_DST_SINGLE_ACCESS  (1 << 14)
+#  define SSI_DST_BURST_4x32_BIT  (2 << 14)
+#  define SSI_DST_BURST_8x32_BIT  (3 << 14)
+#  define SSI_DST_MASK    0x1e00
+#  define SSI_DST_MEMORY_PORT  (8 << 9)
+#  define SSI_DST_PERIPHERAL_PORT  (9 << 9)
+#  define SSI_SRC_BURST_EN_MASK  0x180
+#  define SSI_SRC_SINGLE_ACCESS0  0
+#  define SSI_SRC_SINGLE_ACCESS  (1 << 7)
+#  define SSI_SRC_BURST_4x32_BIT  (2 << 7)
+#  define SSI_SRC_BURST_8x32_BIT  (3 << 7)
+#  define SSI_SRC_MASK    0x3c
+#  define SSI_SRC_MEMORY_PORT  (8 << 2)
+#  define SSI_SRC_PERIPHERAL_PORT  (9 << 2)
+#  define SSI_DATA_TYPE_MASK  3
+#  define SSI_DATA_TYPE_S32  2
+#define SSI_GDD_CCR_REG(channel)  (0x802 + ((channel) * 0x40))
+#  define SSI_DST_AMODE_MASK  (3 << 14)
+#  define SSI_DST_AMODE_CONST  0
+#  define SSI_DST_AMODE_POSTINC  (1 << 12)
+#  define SSI_SRC_AMODE_MASK  (3 << 12)
+#  define SSI_SRC_AMODE_CONST  0
+#  define SSI_SRC_AMODE_POSTINC  (1 << 12)
+#  define SSI_CCR_ENABLE    (1 << 7)
+#  define SSI_CCR_SYNC_MASK  0x1f
+#define SSI_GDD_CICR_REG(channel)  (0x804 + ((channel) * 0x40))
+#  define SSI_BLOCK_IE    (1 << 5)
+#  define SSI_HALF_IE    (1 << 2)
+#  define SSI_TOUT_IE    (1 << 0)
+#define SSI_GDD_CSR_REG(channel)  (0x806 + ((channel) * 0x40))
+#  define SSI_CSR_SYNC    (1 << 6)
+#  define SSI_CSR_BLOCK    (1 << 5)
+#  define SSI_CSR_HALF    (1 << 2)
+#  define SSI_CSR_TOUR    (1 << 0)
+#define SSI_GDD_CSSA_REG(channel)  (0x808 + ((channel) * 0x40))
+#define SSI_GDD_CDSA_REG(channel)  (0x80c + ((channel) * 0x40))
+#define SSI_GDD_CEN_REG(channel)  (0x810 + ((channel) * 0x40))
+#define SSI_GDD_CSAC_REG(channel)  (0x818 + ((channel) * 0x40))
+#define SSI_GDD_CDAC_REG(channel)  (0x81a + ((channel) * 0x40))
+#define SSI_GDD_CLNK_CTRL_REG(channel)  (0x828 + ((channel) * 0x40))
+#  define SSI_ENABLE_LNK    (1 << 15)
+#  define SSI_STOP_LNK    (1 << 14)
+#  define SSI_NEXT_CH_ID_MASK  0xf
+
+#endif /* __OMAP_SSI_REGS_H__ */
-- 
1.9.0

