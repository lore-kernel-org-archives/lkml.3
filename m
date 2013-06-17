Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3FQPvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:51:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:58475 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3FQPv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:51:26 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Pawel Moll <pawel.moll@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [RFC PATCH v4 2/2] drivers: mfd: vexpress: add Serial Power Controller (SPC) support
Date: Mon, 17 Jun 2013 16:51:09 +0100
Message-Id: <1371484269-11743-3-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
References: <1371484269-11743-1-git-send-email-lorenzo.pieralisi@arm.com>
X-OriginalArrivalTime: 17 Jun 2013 15:51:21.0502 (UTC) FILETIME=[83623BE0:01CE6B72]
X-MC-Unique: 113061716512402801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r5HFprrt022422

The TC2 versatile express core tile integrates a logic block that provides the
interface between the dual cluster test-chip and the M3 microcontroller that
carries out power management. The logic block, called Serial Power Controller
(SPC), contains several memory mapped registers to control among other things
low-power states, operating points and reset control.

This patch provides a driver that enables run-time control of features
implemented by the SPC control logic.

The SPC control logic is required to be programmed very early in the boot
process to reset secondary CPUs on the TC2 testchip, set-up jump addresses and
wake-up IRQs for power management.
Since the SPC logic is also used to control clocks and operating points,
that have to be initialized early as well, the SPC interface consumers can not
rely on early initcalls ordering, which is inconsistent, to wait for SPC
initialization. Hence, in order to keep the components relying on the SPC
coded in a sane way, the driver puts in place a synchronization scheme that
allows kernel drivers to check if the SPC driver has been initialized and if
not, to initialize it upon check.

A status variable is kept in memory so that loadable modules that require SPC
interface (eg CPUfreq drivers) can still check the correct initialization and
use the driver correctly after functions used at boot to init the driver are
freed.

The driver also provides a bridge interface through the vexpress config
infrastructure. Operations allowing to read/write operating points are
made to go via the same interface as configuration transactions so that
all requests to M3 are serialized.

Device tree bindings documentation for the SPC component is provided with
the patchset.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Achin Gupta <achin.gupta@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
---
 Documentation/devicetree/bindings/mfd/vexpress-spc.txt |  36 +
 drivers/mfd/Kconfig                                    |  13 +
 drivers/mfd/Makefile                                   |   1 +
 drivers/mfd/vexpress-spc.c                             | 666 ++++++++++
 include/linux/vexpress.h                               |  33 +
 5 files changed, 749 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/vexpress-spc.txt b/Documentation/devicetree/bindings/mfd/vexpress-spc.txt
new file mode 100644
index 0000000..bd381d1
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/vexpress-spc.txt
@@ -0,0 +1,36 @@
+* ARM Versatile Express Serial Power Controller device tree bindings
+
+Latest ARM development boards implement a power management interface (serial
+power controller - SPC) that is capable of managing power/voltage and
+operating point transitions, through memory mapped registers interface.
+
+On testchips like TC2 it also provides a serial configuration interface
+that can be used to retrieve temperature sensors, energy/voltage/current
+probes and oscillators values through the SYS configuration protocol defined
+for versatile express motherboards.
+
+- spc node
+
+	- compatible:
+		Usage: required
+		Value type: <stringlist>
+		Definition: must be
+			    "arm,vexpress-spc,v2p-ca15_a7","arm,vexpress-spc"
+	- reg:
+		Usage: required
+		Value type: <prop-encode-array>
+		Definition: A standard property that specifies the base address
+			    and the size of the SPC address space
+	- interrupts:
+		Usage: required
+		Value type: <prop-encoded-array>
+		Definition:  SPC interrupt configuration. A standard property
+			     that follows ePAPR interrupts specifications
+
+Example:
+
+spc: spc@7fff0000 {
+	compatible = "arm,vexpress-spc,v2p-ca15_a7", "arm,vexpress-spc";
+	reg = <0x7fff0000 0x1000>;
+	interrupts = <0 95 4>;
+};
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index d54e985..e032099 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1148,3 +1148,16 @@ config VEXPRESS_CONFIG
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
+
+config VEXPRESS_SPC
+	bool "Versatile Express SPC driver support"
+	depends on ARM
+	depends on VEXPRESS_CONFIG
+	help
+	  The Serial Power Controller (SPC) for ARM Ltd. test chips, is
+	  an IP that provides a memory mapped interface to power controller
+	  HW and also a configuration interface compatible with the existing
+	  Versatile Express SYS configuration protocol. The driver provides
+	  an API abstraction allowing to control operating points and to
+	  program registers controlling low-level power management features
+	  like power down flags, global and per-cpu wake-up IRQs.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 718e94a..3a01203 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -153,5 +153,6 @@ obj-$(CONFIG_MFD_SEC_CORE)	+= sec-core.o sec-irq.o
 obj-$(CONFIG_MFD_SYSCON)	+= syscon.o
 obj-$(CONFIG_MFD_LM3533)	+= lm3533-core.o lm3533-ctrlbank.o
 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o vexpress-sysreg.o
+obj-$(CONFIG_VEXPRESS_SPC)	+= vexpress-spc.o
 obj-$(CONFIG_MFD_RETU)		+= retu-mfd.o
 obj-$(CONFIG_MFD_AS3711)	+= as3711.o
diff --git a/drivers/mfd/vexpress-spc.c b/drivers/mfd/vexpress-spc.c
new file mode 100644
index 0000000..4c58c01
--- /dev/null
+++ b/drivers/mfd/vexpress-spc.c
@@ -0,0 +1,666 @@
+/*
+ * Versatile Express Serial Power Controller (SPC) support
+ *
+ * Copyright (C) 2013 ARM Ltd.
+ *
+ * Authors: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
+ *          Achin Gupta           <achin.gupta@arm.com>
+ *          Lorenzo Pieralisi     <lorenzo.pieralisi@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/slab.h>
+#include <linux/vexpress.h>
+
+#include <asm/cacheflush.h>
+
+#define SPCLOG "vexpress-spc: "
+
+/* Clock multiplier factor for TC2 core tiles */
+#define PLL_MULT		20
+
+/* SCC registers */
+#define A15_CONF		0x400
+#define SYS_INFO		0x700
+
+/* SPC registers */
+#define SPC_BASE		0xB00
+
+/* SPC Performance levels */
+#define PERF_LVL_A15		(SPC_BASE + 0x00)
+#define PERF_REQ_A15		(SPC_BASE + 0x04)
+#define PERF_LVL_A7		(SPC_BASE + 0x08)
+#define PERF_REQ_A7		(SPC_BASE + 0x0c)
+/* SPC SYS config ctrl registers */
+#define SYS_CFGCTRL		(SPC_BASE + 0x10)
+#define SYS_CFGCTRL_REQ		(SPC_BASE + 0x14)
+/* SPC power status and flag */
+#define PWC_STATUS		(SPC_BASE + 0x18)
+#define PWC_FLAG		(SPC_BASE + 0x1c)
+/* SPC wake-up IRQs status and mask */
+#define WAKE_INT_MASK		(SPC_BASE + 0x24)
+#define WAKE_INT_RAW		(SPC_BASE + 0x28)
+#define WAKE_INT_STAT		(SPC_BASE + 0x2c)
+/* SPC power down registers */
+#define A15_PWRDN_EN		(SPC_BASE + 0x30)
+#define A7_PWRDN_EN		(SPC_BASE + 0x34)
+#define A7_PWRDNACK		(SPC_BASE + 0x54)
+/* SPC CPU mailboxes and SYS config interface data */
+#define A15_BX_ADDR0		(SPC_BASE + 0x68)
+#define SYS_CFG_WDATA		(SPC_BASE + 0x70)
+#define SYS_CFG_RDATA		(SPC_BASE + 0x74)
+#define A7_BX_ADDR0		(SPC_BASE + 0x78)
+
+/* wake-up interrupt masks */
+#define GBL_WAKEUP_INT_MSK		(0x3 << 10)
+#define WAKEUP_IRQ_MASK			0xFFF
+
+/* vexpress config function parameters used to retrieve OPPs */
+#define OPP_FUNCTION		6
+#define OPP_BASE_DEVICE		0x300
+#define OPP_A15_OFFSET		0x4
+#define OPP_A7_OFFSET		0xc
+/* SPC SYS CFGCTRL register format initializer */
+#define SYS_CFGCTRL_START	(1 << 31)
+#define SYS_CFGCTRL_WRITE	(1 << 30)
+#define SYS_CFGCTRL_FUNC(n)	(((n) & 0x3f) << 20)
+#define SYS_CFGCTRL_DEVICE(n)	(((n) & 0xfff) << 0)
+
+#define MAX_OPPS	8
+#define MAX_CLUSTERS	2
+
+enum {
+	/*
+	 * OPP functions are used to read OPP tables for
+	 * A15 and A7 clusters
+	 */
+	OPP_TYPE_A15		= 0,
+	OPP_TYPE_A7		= 1,
+	/*
+	 * Function that provides the Versatile Express SYS config IF
+	 * through Data Communication Channel (DCC)
+	 */
+	SYS_CFGCTRL_TYPE	= 2,
+	INVALID_TYPE
+};
+
+#define STAT_COMPLETE(type)	((1 << 0) << (type << 2))
+#define STAT_ERR(type)		((1 << 1) << (type << 2))
+#define RESPONSE_MASK(type)	(STAT_COMPLETE(type) | STAT_ERR(type))
+
+struct ve_spc_drvdata {
+	void __iomem *baseaddr;
+	/* A15 processor MPIDR[15:8] bitfield */
+	u32 a15_clusid;
+	u32 irq;
+	/* Pending request type */
+	u32 pend_req_type;
+	/* Operating points table */
+	u32 freqs[MAX_CLUSTERS][MAX_OPPS];
+	/* Operating points cluster counter */
+	u32 freqs_cnt[MAX_CLUSTERS];
+	/*
+	 * Versatile Express SPC configuration bridge data and functions
+	 */
+	u32 *config_data;
+	struct vexpress_config_bridge *config_bridge;
+	struct vexpress_config_func *opp_func, *perf_func;
+};
+
+/*
+ * SPC function types
+ *  - CONFIG_FUNC implements serial configuration interface
+ *  - PERF_FUNC implements performance levels management
+ */
+enum spc_func_type {
+	CONFIG_FUNC = 0,
+	PERF_FUNC   = 1,
+};
+
+struct ve_spc_func {
+	enum spc_func_type type;
+	u32 function;
+	u32 device;
+};
+
+static struct ve_spc_drvdata *info;
+/* probe status */
+static int ve_spc_load_result = -EAGAIN;
+
+static inline bool cluster_is_a15(u32 cluster)
+{
+	return cluster == info->a15_clusid;
+}
+
+/* Initialization check/late probe interfaces */
+static int ve_spc_late_probe(void)
+{
+	return ve_spc_load_result;
+}
+
+static inline bool ve_spc_initialized(void)
+{
+	return ve_spc_load_result == 0;
+}
+
+/**
+ * ve_spc_get_freq - get cluster operating frequency
+ *
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ *
+ * Return: frequency on success
+ *         < 0 on error
+ */
+int ve_spc_get_freq(u32 cluster)
+{
+	u32 perf_cfg_reg;
+	int perf, ret;
+
+	if (!ve_spc_initialized() || (cluster >= MAX_CLUSTERS))
+		return -EINVAL;
+
+	perf_cfg_reg = cluster_is_a15(cluster) ? PERF_LVL_A15 : PERF_LVL_A7;
+	ret = vexpress_config_read(info->perf_func, perf_cfg_reg, &perf);
+
+	if (!ret)
+		return info->freqs[cluster][perf];
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ve_spc_get_freq);
+
+static int ve_spc_find_perf_index(u32 cluster, u32 freq)
+{
+	int idx;
+
+	for (idx = 0; idx < info->freqs_cnt[cluster]; idx++)
+		if (info->freqs[cluster][idx] == freq)
+			break;
+	return (idx == info->freqs_cnt[cluster]) ? -EINVAL : idx;
+}
+
+/**
+ * ve_spc_set_freq - set cluster operating frequency
+ *
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ * @freq: frequency to be programmed
+ *
+ * Returns: 0 on success
+ *          < 0 on write error
+ */
+int ve_spc_set_freq(u32 cluster, u32 freq)
+{
+	int ret, perf, offset;
+
+	if (!ve_spc_initialized() || (cluster >= MAX_CLUSTERS))
+		return -EINVAL;
+
+	offset = cluster_is_a15(cluster) ? PERF_LVL_A15 : PERF_LVL_A7;
+
+	perf = ve_spc_find_perf_index(cluster, freq);
+
+	if (perf < 0 || perf >= MAX_OPPS)
+		return -EINVAL;
+
+	ret = vexpress_config_write(info->perf_func, offset, perf);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ve_spc_set_freq);
+
+static int ve_spc_populate_opps(u32 cluster)
+{
+	u32 data = 0, ret, i, offset;
+
+	if (cluster >= MAX_CLUSTERS)
+		return -EINVAL;
+
+	offset = cluster_is_a15(cluster) ? OPP_A15_OFFSET : OPP_A7_OFFSET;
+	for (i = 0; i < MAX_OPPS; i++) {
+		ret = vexpress_config_read(info->opp_func, offset + i, &data);
+		if (!ret)
+			info->freqs[cluster][i] = (data & 0xFFFFF) * PLL_MULT;
+		else
+			break;
+	}
+
+	info->freqs_cnt[cluster] = i;
+	return ret;
+}
+
+/**
+ * ve_spc_get_freq_table() - Retrieve a pointer to OPP array for a cluster
+ *
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ * @fptr: pointer used to return array of operating points
+ * Returns: operating points count on success
+ *         -EINVAL on parameter error
+ */
+int ve_spc_get_freq_table(u32 cluster, const u32 **fptr)
+{
+	int cnt;
+	if (!fptr || cluster >= MAX_CLUSTERS)
+		return -EINVAL;
+	cnt = info->freqs_cnt[cluster];
+	*fptr = info->freqs[cluster];
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(ve_spc_get_freq_table);
+
+/**
+ * ve_spc_global_wakeup_irq()
+ *
+ * Function to set/clear global wakeup IRQs. Not protected by locking since
+ * it might be used in code paths where normal cacheable locks are not
+ * working. Locking must be provided by the caller to ensure atomicity.
+ *
+ * @set: if true, global wake-up IRQs are set, if false they are cleared
+ */
+void ve_spc_global_wakeup_irq(bool set)
+{
+	u32 reg = 0;
+
+	reg = readl_relaxed(info->baseaddr + WAKE_INT_MASK);
+	if (set)
+		reg |= GBL_WAKEUP_INT_MSK;
+	else
+		reg &= ~GBL_WAKEUP_INT_MSK;
+	reg &= WAKEUP_IRQ_MASK;
+	writel_relaxed(reg, info->baseaddr + WAKE_INT_MASK);
+}
+
+/**
+ * ve_spc_cpu_wakeup_irq()
+ *
+ * Function to set/clear per-CPU wake-up IRQs. Not protected by locking since
+ * it might be used in code paths where normal cacheable locks are not
+ * working. Locking must be provided by the caller to ensure atomicity.
+ *
+ * @cpu: mpidr[7:0] bitfield describing cpu affinity level
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ * @set: if true, wake-up IRQs are set, if false they are cleared
+ */
+void ve_spc_cpu_wakeup_irq(u32 cpu, u32 cluster, bool set)
+{
+	u32 mask = 0;
+	u32 reg = 0;
+
+	mask = 1 << cpu;
+	if (!cluster_is_a15(cluster))
+		mask <<= 4;
+	reg = readl_relaxed(info->baseaddr + WAKE_INT_MASK);
+	if (set)
+		reg |= mask;
+	else
+		reg &= ~mask;
+	reg &= WAKEUP_IRQ_MASK;
+	writel_relaxed(reg, info->baseaddr + WAKE_INT_MASK);
+}
+
+/**
+ * ve_spc_set_resume_addr() - set the jump address used for warm boot
+ *
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ * @cpu: mpidr[7:0] bitfield describing cpu affinity level
+ * @addr: physical resume address
+ */
+void ve_spc_set_resume_addr(u32 cluster, u32 cpu, u32 addr)
+{
+	void __iomem *baseaddr;
+
+	if (cluster >= MAX_CLUSTERS)
+		return;
+
+	if (cluster_is_a15(cluster))
+		baseaddr = info->baseaddr + A15_BX_ADDR0 + (cpu << 2);
+	else
+		baseaddr = info->baseaddr + A7_BX_ADDR0 + (cpu << 2);
+
+	writel_relaxed(addr, baseaddr);
+}
+
+/**
+ * ve_spc_get_nr_cpus() - get number of cpus in a cluster
+ *
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ *
+ * Return: > 0 number of cpus in the cluster
+ *         or 0 if cluster number invalid
+ */
+u32 ve_spc_get_nr_cpus(u32 cluster)
+{
+	u32 val;
+
+	if (cluster >= MAX_CLUSTERS)
+		return 0;
+
+	val = readl_relaxed(info->baseaddr + SYS_INFO);
+	val = (cluster_is_a15(cluster)) ? (val >> 16) : (val >> 20);
+	return val & 0xf;
+}
+EXPORT_SYMBOL_GPL(ve_spc_get_nr_cpus);
+
+/**
+ * ve_spc_powerdown()
+ *
+ * Function to enable/disable cluster powerdown. Not protected by locking
+ * since it might be used in code paths where normal cacheable locks are not
+ * working. Locking must be provided by the caller to ensure atomicity.
+ *
+ * @cluster: mpidr[15:8] bitfield describing cluster affinity level
+ * @enable: if true enables powerdown, if false disables it
+ */
+void ve_spc_powerdown(u32 cluster, bool enable)
+{
+	u32 pwdrn_reg = 0;
+
+	if (cluster >= MAX_CLUSTERS)
+		return;
+	pwdrn_reg = cluster_is_a15(cluster) ? A15_PWRDN_EN : A7_PWRDN_EN;
+	writel_relaxed(enable, info->baseaddr + pwdrn_reg);
+}
+
+static irqreturn_t ve_spc_irq_handler(int irq, void *data)
+{
+	int ret;
+	u32 status = readl_relaxed(info->baseaddr + PWC_STATUS);
+
+	if (!(status & RESPONSE_MASK(info->pend_req_type)))
+		return IRQ_NONE;
+
+	if ((status == STAT_COMPLETE(SYS_CFGCTRL_TYPE)) && info->config_data) {
+		*info->config_data =
+				readl_relaxed(info->baseaddr + SYS_CFG_RDATA);
+		info->config_data = NULL;
+	}
+
+	ret = (status == STAT_COMPLETE(info->pend_req_type)) ? 0 : -EIO;
+	info->pend_req_type = INVALID_TYPE;
+	vexpress_config_complete(info->config_bridge, ret);
+	return IRQ_HANDLED;
+}
+
+/*
+ * ve_spc_func_get() -  Allocates an SPC function to be executed through the
+ *			vexpress config interface
+ *
+ * @dev: device to bind to the function
+ * @node: device tree node to bind to the function
+ * @id: special function identifiers - SPC requires "opp" for operating points
+ *	setting and retrieval and "perf" to control operating points
+ */
+static void *ve_spc_func_get(struct device *dev, struct device_node *node,
+			     const char *id)
+{
+	struct ve_spc_func *spc_func;
+	u32 func_device[2];
+	int err = 0;
+
+	spc_func = kzalloc(sizeof(*spc_func), GFP_KERNEL);
+	if (!spc_func)
+		return NULL;
+
+	if (strcmp(id, "opp") == 0) {
+		spc_func->type = CONFIG_FUNC;
+		spc_func->function = OPP_FUNCTION;
+		spc_func->device = OPP_BASE_DEVICE;
+	} else if (strcmp(id, "perf") == 0) {
+		spc_func->type = PERF_FUNC;
+	} else if (node) {
+		of_node_get(node);
+		err = of_property_read_u32_array(node,
+				"arm,vexpress-sysreg,func", func_device,
+				ARRAY_SIZE(func_device));
+		of_node_put(node);
+		spc_func->type = CONFIG_FUNC;
+		spc_func->function = func_device[0];
+		spc_func->device = func_device[1];
+	}
+
+	if (WARN_ON(err)) {
+		kfree(spc_func);
+		return NULL;
+	}
+
+	pr_debug("func 0x%p = 0x%x, %d %d\n", spc_func,
+					      spc_func->function,
+					      spc_func->device,
+					      spc_func->type);
+
+	return spc_func;
+}
+
+static void ve_spc_func_put(void *func)
+{
+	kfree(func);
+}
+
+/*
+ * ve_spc_func_exec() -  Function executing SPC transactions
+ *
+ *                       Performance levels programming and serial Versatile
+ *                       Express communication are made to go through the same
+ *                       interface so that requests are serialized; this is
+ *                       strictly required since the Data Communication Channel
+ *                       (DCC) control interface can not control multiple
+ *                       pending requests at once. Performance level reads
+ *                       are non-blocking, performance level writes and sys
+ *                       configuration reads and writes complete upon IRQ
+ *                       handling.
+ *
+ * @func: pointer to function to execute
+ * @offset:
+ *		if function type is PERF_FUNC
+ *		 - A15/A7 offset for performance level programming
+ *		if function type is CONFIG_FUNC
+ *		 - offset field of the serial configuration protocol
+ * @write: true for writes, false for reads
+ * @data: pointer to data to be read/written
+ */
+static int ve_spc_func_exec(void *func, int offset, bool write, u32 *data)
+{
+	struct ve_spc_func *spc_func = func;
+	u32 command;
+
+	if (!data)
+		return -EINVAL;
+	/*
+	 * Setting and retrieval of operating points is not part of
+	 * DCC config interface. It was made to go through the same
+	 * code path so that requests to the M3 can be serialized
+	 * properly with config reads/writes through the common
+	 * vexpress config interface
+	 */
+	switch (spc_func->type) {
+	case PERF_FUNC:
+		if (write) {
+			info->pend_req_type = (offset == PERF_LVL_A15) ?
+					OPP_TYPE_A15 : OPP_TYPE_A7;
+			writel_relaxed(*data, info->baseaddr + offset);
+			return VEXPRESS_CONFIG_STATUS_WAIT;
+		} else {
+			*data = readl_relaxed(info->baseaddr + offset);
+			return VEXPRESS_CONFIG_STATUS_DONE;
+		}
+	case CONFIG_FUNC:
+		info->pend_req_type = SYS_CFGCTRL_TYPE;
+
+		command = SYS_CFGCTRL_START;
+		command |= write ? SYS_CFGCTRL_WRITE : 0;
+		command |= SYS_CFGCTRL_FUNC(spc_func->function);
+		command |= SYS_CFGCTRL_DEVICE(spc_func->device + offset);
+
+		pr_debug("command %x\n", command);
+
+		if (!write)
+			info->config_data = data;
+		else
+			writel_relaxed(*data, info->baseaddr + SYS_CFG_WDATA);
+		writel_relaxed(command, info->baseaddr + SYS_CFGCTRL);
+
+		return VEXPRESS_CONFIG_STATUS_WAIT;
+	default:
+		return -EINVAL;
+	}
+}
+
+struct vexpress_config_bridge_info ve_spc_config_bridge_info = {
+	.name = "vexpress-spc",
+	.func_get = ve_spc_func_get,
+	.func_put = ve_spc_func_put,
+	.func_exec = ve_spc_func_exec,
+};
+
+static const struct of_device_id ve_spc_ids[] __initconst = {
+	{ .compatible = "arm,vexpress-spc,v2p-ca15_a7" },
+	{ .compatible = "arm,vexpress-spc" },
+	{},
+};
+
+static int __init ve_spc_setup(void)
+{
+	int ret;
+	struct device_node *node = of_find_matching_node(NULL, ve_spc_ids);
+
+	if (!node)
+		return -ENODEV;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info) {
+		pr_err(SPCLOG "unable to allocate mem\n");
+		return -ENOMEM;
+	}
+	info->pend_req_type = INVALID_TYPE;
+
+	info->baseaddr = of_iomap(node, 0);
+	if (!info->baseaddr) {
+		pr_err(SPCLOG "unable to ioremap memory\n");
+		ret = -ENXIO;
+		goto mem_free;
+	}
+
+	info->irq = irq_of_parse_and_map(node, 0);
+
+	if (!info->irq) {
+		pr_err(SPCLOG "unable to retrieve irq\n");
+		ret = -ENXIO;
+		goto unmap;
+	}
+
+	readl_relaxed(info->baseaddr + PWC_STATUS);
+
+	ret = request_irq(info->irq, ve_spc_irq_handler,
+			  IRQF_DISABLED | IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+			  "arm-spc", info);
+
+	if (ret) {
+		pr_err(SPCLOG "IRQ %d request failed\n", info->irq);
+		ret = -ENODEV;
+		goto dispose_irq;
+	}
+
+	info->a15_clusid = readl_relaxed(info->baseaddr + A15_CONF) & 0xf;
+
+	info->config_bridge = vexpress_config_bridge_register(node,
+					&ve_spc_config_bridge_info);
+
+	if (!info->config_bridge) {
+		pr_err(SPCLOG "failed to register config bridge\n");
+		ret = -ENODEV;
+		goto free_irq;
+	}
+
+	info->opp_func = vexpress_config_func_get(info->config_bridge, "opp");
+
+	if (!info->opp_func) {
+		pr_err(SPCLOG "failed to init opp function\n");
+		ret = -ENODEV;
+		goto unregister_bridge;
+	}
+
+	info->perf_func = vexpress_config_func_get(info->config_bridge, "perf");
+	if (!info->perf_func) {
+		pr_err(SPCLOG "failed to init perf function\n");
+		ret = -ENODEV;
+		goto put_opp;
+	}
+
+	if (ve_spc_populate_opps(0) || ve_spc_populate_opps(1)) {
+		pr_err(SPCLOG "failed to build OPP tables\n");
+		ret = -EIO;
+		goto put_perf;
+	}
+	/*
+	 * Multi-cluster systems may need this data when non-coherent, during
+	 * cluster power-up/power-down. Make sure it reaches main memory:
+	 */
+	sync_cache_w(info);
+	sync_cache_w(&info);
+	pr_info("vexpress-spc loaded at %p\n", info->baseaddr);
+	return 0;
+
+put_perf:
+	vexpress_config_func_put(info->perf_func);
+put_opp:
+	vexpress_config_func_put(info->opp_func);
+unregister_bridge:
+	vexpress_config_bridge_unregister(info->config_bridge);
+free_irq:
+	free_irq(info->irq, info);
+dispose_irq:
+	irq_dispose_mapping(info->irq);
+unmap:
+	iounmap(info->baseaddr);
+mem_free:
+	kfree(info);
+	return ret;
+}
+
+static int __init ve_spc_init(void);
+/*
+ * Pointer spc_probe is swapped after init hence it is safe
+ * to initialize it to a function in the __init section
+ */
+static int (*spc_probe)(void) __refdata = &ve_spc_init;
+
+/*
+ * Function exported to manage early_initcall ordering.
+ * SPC code is needed very early in the boot process
+ * to bring CPUs out of reset and initialize power
+ * management back-end. After boot swap pointers to
+ * make the functionality check available to loadable
+ * modules, when early boot init functions have been
+ * already freed from kernel address space.
+ */
+int ve_spc_probe(void)
+{
+	return spc_probe();
+}
+EXPORT_SYMBOL_GPL(ve_spc_probe);
+
+static int __init ve_spc_init(void)
+{
+	if (ve_spc_load_result == -EAGAIN) {
+		ve_spc_load_result = ve_spc_setup();
+		spc_probe = &ve_spc_late_probe;
+	}
+	return ve_spc_load_result;
+}
+early_initcall(ve_spc_init);
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Versatile Express Serial Power Controller (SPC) support");
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 50368e0..af5f099 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -132,4 +132,37 @@ void vexpress_clk_of_register_spc(void);
 void vexpress_clk_init(void __iomem *sp810_base);
 void vexpress_clk_of_init(void);
 
+/* SPC */
+
+#ifdef CONFIG_VEXPRESS_SPC
+int ve_spc_probe(void);
+int ve_spc_get_freq(u32 cluster);
+int ve_spc_set_freq(u32 cluster, u32 freq);
+int ve_spc_get_freq_table(u32 cluster, const u32 **fptr);
+void ve_spc_global_wakeup_irq(bool set);
+void ve_spc_cpu_wakeup_irq(u32 cpu, u32 cluster, bool set);
+void ve_spc_set_resume_addr(u32 cluster, u32 cpu, u32 addr);
+u32 ve_spc_get_nr_cpus(u32 cluster);
+void ve_spc_powerdown(u32 cluster, bool enable);
+#else
+static inline bool ve_spc_probe(void) { return -ENODEV; }
+static inline int ve_spc_get_freq(u32 cluster)
+{
+	return -ENODEV;
+}
+static inline int ve_spc_set_freq(u32 cluster, u32 freq)
+{
+	return -ENODEV;
+}
+static inline int ve_spc_get_freq_table(u32 cluster, const u32 **fptr)
+{
+	return -ENODEV;
+}
+static inline void ve_spc_global_wakeup_irq(bool set) { }
+static inline void ve_spc_cpu_wakeup_irq(u32 cpu, u32 cluster, bool set) { }
+static inline void ve_spc_set_resume_addr(u32 cluster, u32 cpu, u32 addr) { }
+static inline u32 ve_spc_get_nr_cpus(u32 cluster) { return 0; }
+static inline void ve_spc_powerdown(u32 cluster, bool enable) { }
+#endif
+
 #endif
-- 
1.8.2.2


