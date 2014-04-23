Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaDWXsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:48:18 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58957 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaDWXrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:47:35 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: [PATCH v2 6/6] soc: ti: add Keystone Navigator DMA support
Date: Wed, 23 Apr 2014 19:46:22 -0400
Message-ID: <1398296783-1176-7-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Keystone Navigator DMA driver sets up the dma channels and flows for
the QMSS(Queue Manager SubSystem) who triggers the actual data movements
across clients using destination queues. Every client modules like
NETCP(Network Coprocessor), SRIO(Serial Rapid IO) and CRYPTO
Engines has its own instance of packet dma hardware. QMSS has also
an internal packet DMA module which is used as an infrastructure
DMA with zero copy.

Initially this driver was proposed as DMA engine driver but since the
hardware is not typical DMA engine and hence doesn't comply with typical
DMA engine driver needs, that approach was naked. Link to that
discussion -
	https://lkml.org/lkml/2014/3/18/340

As aligned, now we pair the Navigator DMA with its companion Navigator
QMSS subsystem driver.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/soc/ti/Kconfig          |   10 +
 drivers/soc/ti/Makefile         |    1 +
 drivers/soc/ti/knav_dma.c       |  776 +++++++++++++++++++++++++++++++++++++++
 include/linux/soc/ti/knav_dma.h |  175 +++++++++
 4 files changed, 962 insertions(+)
 create mode 100644 drivers/soc/ti/knav_dma.c
 create mode 100644 include/linux/soc/ti/knav_dma.h

diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
index f73896f..7266b21 100644
--- a/drivers/soc/ti/Kconfig
+++ b/drivers/soc/ti/Kconfig
@@ -18,4 +18,14 @@ config KEYSTONE_NAVIGATOR_QMSS
 
 	  If unsure, say N.
 
+config KEYSTONE_NAVIGATOR_DMA
+	tristate "TI Keystone Navigator Packet DMA support"
+	depends on ARCH_KEYSTONE
+	help
+	  Say y tp enable support for the Keystone Navigator Packet DMA on
+	  on Keystone family of devices. It sets up the dma channels for the
+	  Queue Manager Sub System.
+
+	  If unsure, say N.
+
 endif # SOC_TI
diff --git a/drivers/soc/ti/Makefile b/drivers/soc/ti/Makefile
index bf85cac..6bed611 100644
--- a/drivers/soc/ti/Makefile
+++ b/drivers/soc/ti/Makefile
@@ -2,3 +2,4 @@
 # TI Keystone SOC drivers
 #
 obj-$(CONFIG_KEYSTONE_NAVIGATOR_QMSS)	+= knav_qmss_queue.o knav_qmss_acc.o
+obj-$(CONFIG_KEYSTONE_NAVIGATOR_DMA)	+= knav_dma.o
diff --git a/drivers/soc/ti/knav_dma.c b/drivers/soc/ti/knav_dma.c
new file mode 100644
index 0000000..2c5eaa0
--- /dev/null
+++ b/drivers/soc/ti/knav_dma.c
@@ -0,0 +1,776 @@
+/*
+ * Copyright (C) 2014 Texas Instruments Incorporated
+ * Authors:	Sandeep Nair <sandeep_n@ti.com>
+ *		Cyril Chemparathy <cyril@ti.com>
+ *		Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/io.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/dma-direction.h>
+#include <linux/interrupt.h>
+#include <linux/of_dma.h>
+#include <linux/of_address.h>
+#include <linux/platform_device.h>
+#include <linux/soc/ti/knav_dma.h>
+#include <linux/pm_runtime.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#define REG_MASK		0xffffffff
+
+#define DMA_LOOPBACK		BIT(31)
+#define DMA_ENABLE		BIT(31)
+#define DMA_TEARDOWN		BIT(30)
+
+#define DMA_TX_FILT_PSWORDS	BIT(29)
+#define DMA_TX_FILT_EINFO	BIT(30)
+#define DMA_TX_PRIO_SHIFT	0
+#define DMA_RX_PRIO_SHIFT	16
+#define DMA_PRIO_MASK		GENMASK(3, 0)
+#define DMA_PRIO_DEFAULT	0
+#define DMA_RX_TIMEOUT_DEFAULT	17500 /* cycles */
+#define DMA_RX_TIMEOUT_MASK	GENMASK(16, 0)
+#define DMA_RX_TIMEOUT_SHIFT	0
+
+#define CHAN_HAS_EPIB		BIT(30)
+#define CHAN_HAS_PSINFO		BIT(29)
+#define CHAN_ERR_RETRY		BIT(28)
+#define CHAN_PSINFO_AT_SOP	BIT(25)
+#define CHAN_SOP_OFF_SHIFT	16
+#define CHAN_SOP_OFF_MASK	GENMASK(9, 0)
+#define DESC_TYPE_SHIFT		26
+#define DESC_TYPE_MASK		GENMASK(2, 0)
+
+/*
+ * QMGR & QNUM together make up 14 bits with QMGR as the 2 MSb's in the logical
+ * navigator cloud mapping scheme.
+ * using the 14bit physical queue numbers directly maps into this scheme.
+ */
+#define CHAN_QNUM_MASK		GENMASK(14, 0)
+#define DMA_MAX_QMS		4
+#define DMA_TIMEOUT		1000	/* msecs */
+#define DMA_INVALID_ID		0xffff
+
+struct reg_global {
+	u32	revision;
+	u32	perf_control;
+	u32	emulation_control;
+	u32	priority_control;
+	u32	qm_base_address[4];
+};
+
+struct reg_chan {
+	u32	control;
+	u32	mode;
+	u32	__rsvd[6];
+};
+
+struct reg_tx_sched {
+	u32	prio;
+};
+
+struct reg_rx_flow {
+	u32	control;
+	u32	tags;
+	u32	tag_sel;
+	u32	fdq_sel[2];
+	u32	thresh[3];
+};
+
+enum chan_state {
+	/* stable states */
+	CHAN_STATE_UNINITIALIZED,
+	CHAN_STATE_OPENED,
+	CHAN_STATE_CLOSED,
+};
+
+struct knav_dma_pool_device {
+	struct device			*dev;
+	struct list_head		list;
+};
+
+struct knav_dma_device {
+	unsigned			dma_id;
+	const char			*name;
+	bool				loopback, enable_all;
+	unsigned			tx_priority, rx_priority, rx_timeout;
+	unsigned			logical_queue_managers;
+	unsigned			qm_base_address[DMA_MAX_QMS];
+	struct reg_global __iomem	*reg_global;
+	struct reg_chan __iomem		*reg_tx_chan;
+	struct reg_rx_flow __iomem	*reg_rx_flow;
+	struct reg_chan __iomem		*reg_rx_chan;
+	struct reg_tx_sched __iomem	*reg_tx_sched;
+	unsigned			max_rx_chan, max_tx_chan;
+	unsigned			max_rx_flow;
+	atomic_t			ref_count;
+	struct list_head		list;
+	struct list_head		chan_list;
+};
+
+struct knav_dma_chan {
+	enum dma_transfer_direction	direction;
+	struct knav_dma_device		*dma;
+	atomic_t			state;
+	atomic_t			ref_count;
+
+	/* registers */
+	struct reg_chan __iomem		*reg_chan;
+	struct reg_tx_sched __iomem	*reg_tx_sched;
+	struct reg_rx_flow __iomem	*reg_rx_flow;
+
+	/* configuration stuff */
+	unsigned			channel, flow;
+	struct knav_dma_cfg		cfg;
+	struct list_head		list;
+};
+
+#define chan_number(ch)	((ch->direction == DMA_MEM_TO_DEV) ? \
+			ch->channel : ch->flow)
+
+static struct knav_dma_pool_device *kdev;
+
+static inline enum chan_state chan_get_state(struct knav_dma_chan *chan)
+{
+	return atomic_read(&chan->state);
+}
+
+static inline int chan_get_refcount(struct knav_dma_chan *chan)
+{
+	return atomic_read(&chan->ref_count);
+}
+
+static inline int dma_get_refcount(struct knav_dma_device *dma)
+{
+	return atomic_read(&dma->ref_count);
+}
+
+static bool check_config(struct knav_dma_chan *chan, struct knav_dma_cfg *cfg)
+{
+	if (!memcmp(&chan->cfg, cfg, sizeof(*cfg)))
+		return true;
+	else
+		return false;
+}
+
+static int chan_start(struct knav_dma_chan *chan,
+			struct knav_dma_cfg *cfg)
+{
+	u32 v = 0;
+
+	if ((chan->direction == DMA_MEM_TO_DEV) && chan->reg_chan) {
+		if (cfg->u.tx.filt_pswords)
+			v |= DMA_TX_FILT_PSWORDS;
+		if (cfg->u.tx.filt_einfo)
+			v |= DMA_TX_FILT_EINFO;
+		writel_relaxed(v, &chan->reg_chan->mode);
+		writel_relaxed(DMA_ENABLE, &chan->reg_chan->control);
+	}
+
+	if (chan->reg_tx_sched)
+		writel_relaxed(cfg->u.tx.priority, &chan->reg_tx_sched->prio);
+
+	if (chan->reg_rx_flow) {
+		v = 0;
+
+		if (cfg->u.rx.einfo_present)
+			v |= CHAN_HAS_EPIB;
+		if (cfg->u.rx.psinfo_present)
+			v |= CHAN_HAS_PSINFO;
+		if (cfg->u.rx.err_mode == DMA_RETRY)
+			v |= CHAN_ERR_RETRY;
+		v |= (cfg->u.rx.desc_type & DESC_TYPE_MASK) << DESC_TYPE_SHIFT;
+		if (cfg->u.rx.psinfo_at_sop)
+			v |= CHAN_PSINFO_AT_SOP;
+		v |= (cfg->u.rx.sop_offset & CHAN_SOP_OFF_MASK)
+			<< CHAN_SOP_OFF_SHIFT;
+		v |= cfg->u.rx.dst_q & CHAN_QNUM_MASK;
+
+		writel_relaxed(v, &chan->reg_rx_flow->control);
+		writel_relaxed(0, &chan->reg_rx_flow->tags);
+		writel_relaxed(0, &chan->reg_rx_flow->tag_sel);
+
+		v =  cfg->u.rx.fdq[0] << 16;
+		v |=  cfg->u.rx.fdq[1] & CHAN_QNUM_MASK;
+		writel_relaxed(v, &chan->reg_rx_flow->fdq_sel[0]);
+
+		v =  cfg->u.rx.fdq[2] << 16;
+		v |=  cfg->u.rx.fdq[3] & CHAN_QNUM_MASK;
+		writel_relaxed(v, &chan->reg_rx_flow->fdq_sel[1]);
+
+		writel_relaxed(0, &chan->reg_rx_flow->thresh[0]);
+		writel_relaxed(0, &chan->reg_rx_flow->thresh[1]);
+		writel_relaxed(0, &chan->reg_rx_flow->thresh[2]);
+	}
+
+	/* Keep a copy of the cfg */
+	memcpy(&chan->cfg, cfg, sizeof(*cfg));
+
+	return 0;
+}
+
+static int chan_teardown(struct knav_dma_chan *chan)
+{
+	unsigned long end, value;
+
+	if (!chan->reg_chan)
+		return 0;
+
+	/* indicate teardown */
+	writel_relaxed(DMA_TEARDOWN, &chan->reg_chan->control);
+
+	/* wait for the dma to shut itself down */
+	end = jiffies + msecs_to_jiffies(DMA_TIMEOUT);
+	do {
+		value = readl_relaxed(&chan->reg_chan->control);
+		if ((value & DMA_ENABLE) == 0)
+			break;
+	} while (time_after(end, jiffies));
+
+	if (readl_relaxed(&chan->reg_chan->control) & DMA_ENABLE) {
+		dev_err(kdev->dev, "timeout waiting for teardown\n");
+		return -ETIMEDOUT;
+	}
+
+	return 0;
+}
+
+static void chan_stop(struct knav_dma_chan *chan)
+{
+	if (chan->reg_rx_flow) {
+		/* first detach fdqs, starve out the flow */
+		writel_relaxed(0, &chan->reg_rx_flow->fdq_sel[0]);
+		writel_relaxed(0, &chan->reg_rx_flow->fdq_sel[1]);
+		writel_relaxed(0, &chan->reg_rx_flow->thresh[0]);
+		writel_relaxed(0, &chan->reg_rx_flow->thresh[1]);
+		writel_relaxed(0, &chan->reg_rx_flow->thresh[2]);
+	}
+
+	/* teardown the dma channel */
+	chan_teardown(chan);
+
+	/* then disconnect the completion side */
+	if (chan->reg_rx_flow) {
+		writel_relaxed(0, &chan->reg_rx_flow->control);
+		writel_relaxed(0, &chan->reg_rx_flow->tags);
+		writel_relaxed(0, &chan->reg_rx_flow->tag_sel);
+	}
+	dev_dbg(kdev->dev, "channel stopped\n");
+}
+
+static void knav_dma_hw_init(struct knav_dma_device *dma)
+{
+	unsigned v;
+	int i;
+
+	v  = dma->loopback ? DMA_LOOPBACK : 0;
+	writel_relaxed(v, &dma->reg_global->emulation_control);
+
+	v = readl_relaxed(&dma->reg_global->perf_control);
+	v |= ((dma->rx_timeout & DMA_RX_TIMEOUT_MASK) << DMA_RX_TIMEOUT_SHIFT);
+	writel_relaxed(v, &dma->reg_global->perf_control);
+
+	v = ((dma->tx_priority << DMA_TX_PRIO_SHIFT) |
+	     (dma->rx_priority << DMA_RX_PRIO_SHIFT));
+
+	writel_relaxed(v, &dma->reg_global->priority_control);
+
+	if (dma->enable_all) {
+		for (i = 0; i < dma->max_tx_chan; i++) {
+			writel_relaxed(0, &dma->reg_tx_chan[i].mode);
+			writel_relaxed(DMA_ENABLE,
+				       &dma->reg_tx_chan[i].control);
+		}
+	}
+
+	/* Always enable all Rx channels. Rx paths are managed using flows */
+	for (i = 0; i < dma->max_rx_chan; i++)
+		writel_relaxed(DMA_ENABLE, &dma->reg_rx_chan[i].control);
+
+	for (i = 0; i < dma->logical_queue_managers; i++)
+		writel_relaxed(dma->qm_base_address[i],
+			       &dma->reg_global->qm_base_address[i]);
+}
+
+static void knav_dma_hw_destroy(struct knav_dma_device *dma)
+{
+	int i;
+	unsigned v;
+
+	v = ~DMA_ENABLE & REG_MASK;
+
+	for (i = 0; i < dma->max_rx_chan; i++)
+		writel_relaxed(v, &dma->reg_rx_chan[i].control);
+
+	for (i = 0; i < dma->max_tx_chan; i++)
+		writel_relaxed(v, &dma->reg_tx_chan[i].control);
+}
+
+static void dma_debug_show_channels(struct seq_file *s,
+					struct knav_dma_chan *chan)
+{
+	int i;
+
+	seq_printf(s, "\t%s %d:\t",
+		((chan->direction == DMA_MEM_TO_DEV) ? "tx chan" : "rx flow"),
+		chan_number(chan));
+
+	if (chan->direction == DMA_MEM_TO_DEV) {
+		seq_printf(s, "einfo - %d, pswords - %d, priority - %d\n",
+			chan->cfg.u.tx.filt_einfo,
+			chan->cfg.u.tx.filt_pswords,
+			chan->cfg.u.tx.priority);
+	} else {
+		seq_printf(s, "einfo - %d, psinfo - %d, desc_type - %d\n",
+			chan->cfg.u.rx.einfo_present,
+			chan->cfg.u.rx.psinfo_present,
+			chan->cfg.u.rx.desc_type);
+		seq_printf(s, "\t\t\tdst_q: [%d], thresh: %d fdq: ",
+			chan->cfg.u.rx.dst_q,
+			chan->cfg.u.rx.thresh);
+		for (i = 0; i < KNAV_DMA_FDQ_PER_CHAN; i++)
+			seq_printf(s, "[%d]", chan->cfg.u.rx.fdq[i]);
+		seq_printf(s, "\n");
+	}
+}
+
+static void dma_debug_show_devices(struct seq_file *s,
+					struct knav_dma_device *dma)
+{
+	struct knav_dma_chan *chan;
+
+	list_for_each_entry(chan, &dma->chan_list, list) {
+		if (chan_get_refcount(chan))
+			dma_debug_show_channels(s, chan);
+	}
+}
+
+static int dma_debug_show(struct seq_file *s, void *v)
+{
+	struct knav_dma_device *dma;
+
+	list_for_each_entry(dma, &kdev->list, list) {
+		if (dma_get_refcount(dma)) {
+			seq_printf(s, "%s : max_tx_chan: (%d), max_rx_flows: (%d)\n",
+			dma->name, dma->max_tx_chan, dma->max_rx_flow);
+			dma_debug_show_devices(s, dma);
+		}
+	}
+
+	return 0;
+}
+
+static int knav_dma_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dma_debug_show, NULL);
+}
+
+static const struct file_operations knav_dma_debug_ops = {
+	.open		= knav_dma_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/**
+ * knav_dma_open_channel()	- Setup a dma channel
+ *
+ * @dma_id			- dma instance id
+ * @config			- dma configuration parameters
+ *
+ * Returns a dma channel handle on success
+ * Use IS_ERR_OR_NULL() to identify error values on return.
+ */
+void *knav_dma_open_channel(unsigned dma_id, struct knav_dma_cfg *config)
+{
+	struct knav_dma_chan *chan;
+	struct knav_dma_device *dma;
+	bool found = false;
+
+	if (!kdev) {
+		pr_err("keystone-navigator-dma driver not registered\n");
+		return (void *)-EINVAL;
+	}
+
+	dev_dbg(kdev->dev, "initializing %s channel %d from DMA ID %d\n",
+		  config->direction == DMA_MEM_TO_DEV   ? "transmit" :
+		  config->direction == DMA_DEV_TO_MEM ? "receive"  :
+		  "unknown", config->chan_num, dma_id);
+
+	if (config->direction != DMA_MEM_TO_DEV &&
+	    config->direction != DMA_DEV_TO_MEM) {
+		dev_err(kdev->dev, "bad direction\n");
+		return (void *)-EINVAL;
+	}
+
+	/* Look for correct dma instance */
+	list_for_each_entry(dma, &kdev->list, list) {
+		if (dma->dma_id == dma_id) {
+			found = true;
+			break;
+		}
+	}
+	if (!found) {
+		dev_err(kdev->dev, "No DMA instace by id %d\n", dma_id);
+		return (void *)-EINVAL;
+	}
+
+	/* Look for correct dma channel from dma instance */
+	found = false;
+	list_for_each_entry(chan, &dma->chan_list, list) {
+		if (config->direction == DMA_MEM_TO_DEV) {
+			if (chan->channel == config->chan_num) {
+				found = true;
+				break;
+			}
+		} else {
+			if (chan->flow == config->chan_num) {
+				found = true;
+				break;
+			}
+		}
+	}
+	if (!found) {
+		dev_err(kdev->dev, "channel %d is not in DMA id %d\n",
+			config->chan_num, dma_id);
+		return (void *)-EINVAL;
+	}
+
+	/* Just return the handled for same channel request */
+	if (chan_get_state(chan) == CHAN_STATE_OPENED) {
+		/* Ensure the config sanity */
+		if (check_config(chan, config)) {
+			return chan;
+		} else {
+			dev_err(kdev->dev, "channel %d config miss-match\n",
+					config->chan_num);
+			return (void *)-EINVAL;
+		}
+	}
+
+	if (atomic_inc_return(&chan->dma->ref_count) <= 1)
+		knav_dma_hw_init(chan->dma);
+
+	if (atomic_inc_return(&chan->ref_count) <= 1)
+		chan_start(chan, config);
+
+	atomic_set(&chan->state, CHAN_STATE_OPENED);
+	dev_dbg(kdev->dev, "channel %d opened from DMA id %d\n",
+			config->chan_num, dma_id);
+
+	return chan;
+}
+EXPORT_SYMBOL_GPL(knav_dma_open_channel);
+
+/**
+ * knav_dma_close_channel()	- Destroy a dma channel
+ *
+ * channel			- dma channel handle
+ *
+ */
+void knav_dma_close_channel(void *channel)
+{
+	struct knav_dma_chan *chan = channel;
+
+	if (!kdev) {
+		pr_err("keystone-navigator-dma driver not registered\n");
+		return;
+	}
+
+	if (chan_get_state(chan) == CHAN_STATE_CLOSED)
+		return;
+
+	if (atomic_dec_return(&chan->ref_count) <= 0)
+		chan_stop(chan);
+
+	if (atomic_dec_return(&chan->dma->ref_count) <= 0)
+		knav_dma_hw_destroy(chan->dma);
+
+	atomic_set(&chan->state, CHAN_STATE_CLOSED);
+	dev_dbg(kdev->dev, "channel %d or flow %d closed from DMA id %d\n",
+			chan->channel, chan->flow, chan->dma->dma_id);
+}
+EXPORT_SYMBOL_GPL(knav_dma_close_channel);
+
+static void __iomem *pktdma_get_regs(struct knav_dma_device *dma,
+				struct device_node *node,
+				unsigned index, resource_size_t *_size)
+{
+	struct device *dev = kdev->dev;
+	struct resource res;
+	void __iomem *regs;
+	int ret;
+
+	ret = of_address_to_resource(node, index, &res);
+	if (ret) {
+		dev_err(dev, "Can't translate of node(%s) address for index(%d)\n",
+			node->name, index);
+		return ERR_PTR(ret);
+	}
+
+	regs = devm_ioremap_resource(kdev->dev, &res);
+	if (IS_ERR(regs))
+		dev_err(dev, "Failed to map register base for index(%d) node(%s)\n",
+			index, node->name);
+	if (_size)
+		*_size = resource_size(&res);
+
+	return regs;
+}
+
+static int pktdma_init_rx_chan(struct knav_dma_chan *chan, u32 flow)
+{
+	struct knav_dma_device *dma = chan->dma;
+
+	chan->flow = flow;
+	chan->reg_rx_flow = dma->reg_rx_flow + flow;
+	chan->channel = DMA_INVALID_ID;
+	dev_dbg(kdev->dev, "rx flow(%d) (%p)\n", chan->flow, chan->reg_rx_flow);
+
+	return 0;
+}
+
+static int pktdma_init_tx_chan(struct knav_dma_chan *chan, u32 channel)
+{
+	struct knav_dma_device *dma = chan->dma;
+
+	chan->channel = channel;
+	chan->reg_chan = dma->reg_tx_chan + channel;
+	chan->reg_tx_sched = dma->reg_tx_sched + channel;
+	chan->flow = DMA_INVALID_ID;
+	dev_dbg(kdev->dev, "tx channel(%d) (%p)\n", chan->channel, chan->reg_chan);
+
+	return 0;
+}
+
+static int pktdma_init_chan(struct knav_dma_device *dma,
+				enum dma_transfer_direction dir,
+				unsigned chan_num)
+{
+	struct device *dev = kdev->dev;
+	struct knav_dma_chan *chan;
+	int ret = -EINVAL;
+
+	chan = devm_kzalloc(dev, sizeof(*chan), GFP_KERNEL);
+	if (!chan)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&chan->list);
+	chan->dma	= dma;
+	chan->direction	= DMA_NONE;
+	atomic_set(&chan->state, CHAN_STATE_UNINITIALIZED);
+	atomic_set(&chan->ref_count, 0);
+
+	if (dir == DMA_MEM_TO_DEV) {
+		chan->direction = dir;
+		ret = pktdma_init_tx_chan(chan, chan_num);
+	} else if (dir == DMA_DEV_TO_MEM) {
+		chan->direction = dir;
+		ret = pktdma_init_rx_chan(chan, chan_num);
+	} else {
+		dev_err(dev, "channel(%d) direction unknown\n", chan_num);
+	}
+
+	list_add_tail(&chan->list, &dma->chan_list);
+
+	return ret;
+}
+
+static int dma_init(struct device_node *dma_node)
+{
+	unsigned max_tx_chan, max_rx_chan, max_rx_flow, max_tx_sched;
+	struct device_node *node = dma_node;
+	struct knav_dma_device *dma;
+	int ret, len, num_chan = 0;
+	resource_size_t size;
+	u32 timeout;
+	u32 i;
+
+	dma = devm_kzalloc(kdev->dev, sizeof(*dma), GFP_KERNEL);
+	if (!dma) {
+		dev_err(kdev->dev, "could not allocate driver mem\n");
+		return -ENOMEM;
+	}
+	INIT_LIST_HEAD(&dma->list);
+	INIT_LIST_HEAD(&dma->chan_list);
+
+	ret = of_property_read_u32(node, "dma-id", &dma->dma_id);
+	if (ret < 0) {
+		dev_err(kdev->dev, "No Packet DMA device id, err %d\n", ret);
+		return -ENODEV;
+	}
+
+	dma->reg_global	 = pktdma_get_regs(dma, node, 0, &size);
+	if (!dma->reg_global)
+		return -ENODEV;
+	if (size < sizeof(struct reg_global)) {
+		dev_err(kdev->dev, "bad size %pa for global regs\n", &size);
+		return -ENODEV;
+	}
+
+	dma->reg_tx_chan = pktdma_get_regs(dma, node, 1, &size);
+	if (!dma->reg_tx_chan)
+		return -ENODEV;
+
+	max_tx_chan = size / sizeof(struct reg_chan);
+	dma->reg_rx_chan = pktdma_get_regs(dma, node, 2, &size);
+	if (!dma->reg_rx_chan)
+		return -ENODEV;
+
+	max_rx_chan = size / sizeof(struct reg_chan);
+	dma->reg_tx_sched = pktdma_get_regs(dma, node, 3, &size);
+	if (!dma->reg_tx_sched)
+		return -ENODEV;
+
+	max_tx_sched = size / sizeof(struct reg_tx_sched);
+	dma->reg_rx_flow = pktdma_get_regs(dma, node, 4, &size);
+	if (!dma->reg_rx_flow)
+		return -ENODEV;
+
+	max_rx_flow = size / sizeof(struct reg_rx_flow);
+	dma->rx_priority = DMA_PRIO_DEFAULT;
+	dma->tx_priority = DMA_PRIO_DEFAULT;
+
+	dma->enable_all	= (of_get_property(node, "enable-all", NULL) != NULL);
+	dma->loopback	= (of_get_property(node, "loop-back",  NULL) != NULL);
+
+	ret = of_property_read_u32(node, "rx-retry-timeout", &timeout);
+	if (ret < 0) {
+		dev_dbg(kdev->dev, "unspecified rx timeout using value %d\n",
+			DMA_RX_TIMEOUT_DEFAULT);
+		timeout = DMA_RX_TIMEOUT_DEFAULT;
+	}
+	dma->rx_timeout = timeout;
+
+	if (!of_find_property(node, "qm-base-address", &len)) {
+		dev_err(kdev->dev, "unspecified qm-base-address\n");
+		return -ENODEV;
+	}
+
+	dma->logical_queue_managers = len / sizeof(u32);
+	if (dma->logical_queue_managers > DMA_MAX_QMS) {
+		dev_warn(kdev->dev, "too many queue mgrs(>%d) rest ignored\n",
+			 dma->logical_queue_managers);
+		dma->logical_queue_managers = DMA_MAX_QMS;
+	}
+
+	ret = of_property_read_u32_array(node, "qm-base-address",
+					dma->qm_base_address,
+					dma->logical_queue_managers);
+	if (ret) {
+		dev_err(kdev->dev, "invalid qm-base-address\n");
+		return ret;
+	}
+
+	dma->max_rx_chan = max_rx_chan;
+	dma->max_rx_flow = max_rx_flow;
+	dma->max_tx_chan = min(max_tx_chan, max_tx_sched);
+	atomic_set(&dma->ref_count, 0);
+	dma->name = of_node_full_name(node);
+
+	for (i = 0; i < dma->max_tx_chan; i++) {
+		if (pktdma_init_chan(dma, DMA_MEM_TO_DEV, i) >= 0)
+			num_chan++;
+	}
+
+	for (i = 0; i < dma->max_rx_flow; i++) {
+		if (pktdma_init_chan(dma, DMA_DEV_TO_MEM, i) >= 0)
+			num_chan++;
+	}
+
+	list_add_tail(&dma->list, &kdev->list);
+	dev_info(kdev->dev, "DMA%d registered %d logical channels, flows %d, tx chans: %d, rx chans: %d%s\n",
+		dma->dma_id, num_chan, dma->max_rx_flow,
+		dma->max_tx_chan, dma->max_rx_chan,
+		dma->loopback ? ", loopback" : "");
+
+	return 0;
+}
+
+static int knav_dma_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *child;
+	int ret = 0;
+
+	if (!node) {
+		dev_err(&pdev->dev, "could not find device info\n");
+		return -EINVAL;
+	}
+
+	kdev = devm_kzalloc(dev,
+			sizeof(struct knav_dma_pool_device), GFP_KERNEL);
+	if (!kdev) {
+		dev_err(dev, "could not allocate driver mem\n");
+		return -ENOMEM;
+	}
+
+	kdev->dev = dev;
+	INIT_LIST_HEAD(&kdev->list);
+
+	pm_runtime_enable(kdev->dev);
+	ret = pm_runtime_get_sync(kdev->dev);
+	if (ret < 0) {
+		dev_err(kdev->dev, "unable to enable pktdma, err %d\n", ret);
+		return ret;
+	}
+
+	/* Initialise all packet dmas */
+	for_each_child_of_node(node, child) {
+		ret = dma_init(child);
+		if (ret) {
+			dev_err(&pdev->dev, "init failed with %d\n", ret);
+			break;
+		}
+	}
+
+	if (list_empty(&kdev->list)) {
+		dev_err(dev, "no valid dma instance\n");
+		return -ENODEV;
+	}
+
+	debugfs_create_file("knav_dma", S_IFREG | S_IRUGO, NULL, NULL,
+			    &knav_dma_debug_ops);
+
+	return ret;
+}
+
+static int knav_dma_remove(struct platform_device *pdev)
+{
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
+static struct of_device_id of_match[] = {
+	{ .compatible = "ti,keystone-navigator-dma", },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, of_match);
+
+static struct platform_driver knav_dma_driver = {
+	.probe	= knav_dma_probe,
+	.remove	= knav_dma_remove,
+	.driver = {
+		.name		= "keystone-navigator-dma",
+		.owner		= THIS_MODULE,
+		.of_match_table	= of_match,
+	},
+};
+module_platform_driver(knav_dma_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("TI Keystone Navigator Packet DMA driver");
diff --git a/include/linux/soc/ti/knav_dma.h b/include/linux/soc/ti/knav_dma.h
new file mode 100644
index 0000000..5790ce5
--- /dev/null
+++ b/include/linux/soc/ti/knav_dma.h
@@ -0,0 +1,175 @@
+/*
+ * Copyright (C) 2014 Texas Instruments Incorporated
+ * Authors:	Sandeep Nair <sandeep_n@ti.com
+ *		Cyril Chemparathy <cyril@ti.com
+		Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __SOC_TI_KEYSTONE_NAVIGATOR_DMA_H__
+#define __SOC_TI_KEYSTONE_NAVIGATOR_DMA_H__
+
+/*
+ * PKTDMA descriptor manipulation macros for host packet descriptor
+ */
+#define MASK(x)					(BIT(x) - 1)
+#define KNAV_DMA_DESC_PKT_LEN_MASK		MASK(22)
+#define KNAV_DMA_DESC_PKT_LEN_SHIFT		0
+#define KNAV_DMA_DESC_PS_INFO_IN_SOP		BIT(22)
+#define KNAV_DMA_DESC_PS_INFO_IN_DESC		0
+#define KNAV_DMA_DESC_TAG_MASK			MASK(8)
+#define KNAV_DMA_DESC_SAG_HI_SHIFT		24
+#define KNAV_DMA_DESC_STAG_LO_SHIFT		16
+#define KNAV_DMA_DESC_DTAG_HI_SHIFT		8
+#define KNAV_DMA_DESC_DTAG_LO_SHIFT		0
+#define KNAV_DMA_DESC_HAS_EPIB			BIT(31)
+#define KNAV_DMA_DESC_NO_EPIB			0
+#define KNAV_DMA_DESC_PSLEN_SHIFT		24
+#define KNAV_DMA_DESC_PSLEN_MASK		MASK(6)
+#define KNAV_DMA_DESC_ERR_FLAG_SHIFT		20
+#define KNAV_DMA_DESC_ERR_FLAG_MASK		MASK(4)
+#define KNAV_DMA_DESC_PSFLAG_SHIFT		16
+#define KNAV_DMA_DESC_PSFLAG_MASK		MASK(4)
+#define KNAV_DMA_DESC_RETQ_SHIFT		0
+#define KNAV_DMA_DESC_RETQ_MASK			MASK(14)
+#define KNAV_DMA_DESC_BUF_LEN_MASK		MASK(22)
+
+#define KNAV_DMA_NUM_EPIB_WORDS			4
+#define KNAV_DMA_NUM_PS_WORDS			16
+#define KNAV_DMA_FDQ_PER_CHAN			4
+
+/* Tx channel scheduling priority */
+enum knav_dma_tx_priority {
+	DMA_PRIO_HIGH	= 0,
+	DMA_PRIO_MED_H,
+	DMA_PRIO_MED_L,
+	DMA_PRIO_LOW
+};
+
+/* Rx channel error handling mode during buffer starvation */
+enum knav_dma_rx_err_mode {
+	DMA_DROP = 0,
+	DMA_RETRY
+};
+
+/* Rx flow size threshold configuration */
+enum knav_dma_rx_thresholds {
+	DMA_THRESH_NONE		= 0,
+	DMA_THRESH_0		= 1,
+	DMA_THRESH_0_1		= 3,
+	DMA_THRESH_0_1_2	= 7
+};
+
+/* Descriptor type */
+enum knav_dma_desc_type {
+	DMA_DESC_HOST = 0,
+	DMA_DESC_MONOLITHIC = 2
+};
+
+/**
+ * struct knav_dma_tx_cfg:	Tx channel configuration
+ * @filt_einfo:			Filter extended packet info
+ * @filt_pswords:		Filter PS words present
+ * @knav_dma_tx_priority:	Tx channel scheduling priority
+ */
+struct knav_dma_tx_cfg {
+	bool				filt_einfo;
+	bool				filt_pswords;
+	enum knav_dma_tx_priority	priority;
+};
+
+/**
+ * struct knav_dma_rx_cfg:	Rx flow configuration
+ * @einfo_present:		Extended packet info present
+ * @psinfo_present:		PS words present
+ * @knav_dma_rx_err_mode:	Error during buffer starvation
+ * @knav_dma_desc_type:	Host or Monolithic desc
+ * @psinfo_at_sop:		PS word located at start of packet
+ * @sop_offset:			Start of packet offset
+ * @dst_q:			Destination queue for a given flow
+ * @thresh:			Rx flow size threshold
+ * @fdq[]:			Free desc Queue array
+ * @sz_thresh0:			RX packet size threshold 0
+ * @sz_thresh1:			RX packet size threshold 1
+ * @sz_thresh2:			RX packet size threshold 2
+ */
+struct knav_dma_rx_cfg {
+	bool				einfo_present;
+	bool				psinfo_present;
+	enum knav_dma_rx_err_mode	err_mode;
+	enum knav_dma_desc_type		desc_type;
+	bool				psinfo_at_sop;
+	unsigned int			sop_offset;
+	unsigned int			dst_q;
+	enum knav_dma_rx_thresholds	thresh;
+	unsigned int			fdq[KNAV_DMA_FDQ_PER_CHAN];
+	unsigned int			sz_thresh0;
+	unsigned int			sz_thresh1;
+	unsigned int			sz_thresh2;
+};
+
+/**
+ * struct knav_dma_cfg:	Pktdma channel configuration
+ * @sl_cfg:			Slave configuration
+ * @tx:				Tx channel configuration
+ * @rx:				Rx flow configuration
+ */
+struct knav_dma_cfg {
+	unsigned chan_num;
+	enum dma_transfer_direction direction;
+	union {
+		struct knav_dma_tx_cfg	tx;
+		struct knav_dma_rx_cfg	rx;
+	} u;
+};
+
+/**
+ * struct knav_dma_desc:	Host packet descriptor layout
+ * @desc_info:			Descriptor information like id, type, length
+ * @tag_info:			Flow tag info written in during RX
+ * @packet_info:		Queue Manager, policy, flags etc
+ * @buff_len:			Buffer length in bytes
+ * @buff:			Buffer pointer
+ * @next_desc:			For chaining the descriptors
+ * @orig_len:			length since 'buff_len' can be overwritten
+ * @orig_buff:			buff pointer since 'buff' can be overwritten
+ * @epib:			Extended packet info block
+ * @psdata:			Protocol specific
+ */
+struct knav_dma_desc {
+	u32	desc_info;
+	u32	tag_info;
+	u32	packet_info;
+	u32	buff_len;
+	u32	buff;
+	u32	next_desc;
+	u32	orig_len;
+	u32	orig_buff;
+	u32	epib[KNAV_DMA_NUM_EPIB_WORDS];
+	u32	psdata[KNAV_DMA_NUM_PS_WORDS];
+	u32	pad[4];
+} ____cacheline_aligned;
+
+#ifdef CONFIG_KEYSTONE_NAVIGATOR_DMA
+void *knav_dma_open_channel(unsigned dma_id, struct knav_dma_cfg *config);
+void knav_dma_close_channel(void *channel);
+#else
+static inline void *knav_dma_open_channel(unsigned dma_id,
+			struct knav_dma_cfg *config);
+{
+	return (void *) NULL;
+}
+void knav_dma_close_channel(void *channel)
+{}
+
+#endif
+
+#endif /* __SOC_TI_KEYSTONE_NAVIGATOR_DMA_H__ */
-- 
1.7.9.5

