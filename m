Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaDWXrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:47:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48195 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599AbaDWXri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:47:38 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH v2 4/6] soc: ti: add Keystone Navigator QMSS driver
Date: Wed, 23 Apr 2014 19:46:20 -0400
Message-ID: <1398296783-1176-5-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sandeep Nair <sandeep_n@ti.com>

The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
the main hardware sub system which forms the backbone of the Keystone
Multi-core Navigator. QMSS consist of queue managers, packed-data structure
processors(PDSP), linking RAM, descriptor pools and infrastructure
Packet DMA.

The Queue Manager is a hardware module that is responsible for accelerating
management of the packet queues. Packets are queued/de-queued by writing or
reading descriptor address to a particular memory mapped location. The PDSPs
perform QMSS related functions like accumulation, QoS, or event management.
Linking RAM registers are used to link the descriptors which are stored in
descriptor RAM. Descriptor RAM is configurable as internal or external memory.

The QMSS driver manages the PDSP setups, linking RAM regions,
queue pool management (allocation, push, pop and notify) and descriptor
pool management. The specifics on the device tree bindings for
QMSS can be found in:
	Documentation/devicetree/bindings/soc/keystone-navigator-qmss.txt

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
 drivers/Kconfig                  |    2 +
 drivers/soc/Kconfig              |    2 +
 drivers/soc/Makefile             |    5 +
 drivers/soc/ti/Kconfig           |   21 +
 drivers/soc/ti/Makefile          |    4 +
 drivers/soc/ti/knav_qmss.h       |  386 ++++++++
 drivers/soc/ti/knav_qmss_acc.c   |  591 +++++++++++++
 drivers/soc/ti/knav_qmss_queue.c | 1814 ++++++++++++++++++++++++++++++++++++++
 include/linux/soc/ti/knav_qmss.h |   90 ++
 9 files changed, 2915 insertions(+)
 create mode 100644 drivers/soc/Makefile
 create mode 100644 drivers/soc/ti/Kconfig
 create mode 100644 drivers/soc/ti/Makefile
 create mode 100644 drivers/soc/ti/knav_qmss.h
 create mode 100644 drivers/soc/ti/knav_qmss_acc.c
 create mode 100644 drivers/soc/ti/knav_qmss_queue.c
 create mode 100644 include/linux/soc/ti/knav_qmss.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0e87a34..8993913 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -148,6 +148,8 @@ source "drivers/remoteproc/Kconfig"
 
 source "drivers/rpmsg/Kconfig"
 
+source "drivers/soc/Kconfig"
+
 source "drivers/devfreq/Kconfig"
 
 source "drivers/extcon/Kconfig"
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
index 339baa8..7b4e4d6 100644
--- a/drivers/soc/Kconfig
+++ b/drivers/soc/Kconfig
@@ -1,3 +1,5 @@
 menu "SOC (System On Chip) specific Drivers"
 
+source "drivers/soc/ti/Kconfig"
+
 endmenu
diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
new file mode 100644
index 0000000..e8baa0f
--- /dev/null
+++ b/drivers/soc/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for the Linux kernel SOC specific device drivers.
+#
+
+obj-$(CONFIG_SOC_TI)		+= ti/
diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
new file mode 100644
index 0000000..f73896f
--- /dev/null
+++ b/drivers/soc/ti/Kconfig
@@ -0,0 +1,21 @@
+#
+# TI SOC drivers
+#
+menuconfig SOC_TI
+	bool "TI SOC drivers support"
+
+if SOC_TI
+
+config KEYSTONE_NAVIGATOR_QMSS
+	tristate "Keystone Queue Manager Sub System"
+	depends on ARCH_KEYSTONE
+	help
+	  Say y here to support the Keystone multicore Navigator Queue
+	  Manager support. The Queue Manager is a hardware module that
+	  is responsible for accelerating management of the packet queues.
+	  Packets are queued/de-queued by writing/reading descriptor address
+	  to a particular memory mapped location in the Queue Manager module.
+
+	  If unsure, say N.
+
+endif # SOC_TI
diff --git a/drivers/soc/ti/Makefile b/drivers/soc/ti/Makefile
new file mode 100644
index 0000000..bf85cac
--- /dev/null
+++ b/drivers/soc/ti/Makefile
@@ -0,0 +1,4 @@
+#
+# TI Keystone SOC drivers
+#
+obj-$(CONFIG_KEYSTONE_NAVIGATOR_QMSS)	+= knav_qmss_queue.o knav_qmss_acc.o
diff --git a/drivers/soc/ti/knav_qmss.h b/drivers/soc/ti/knav_qmss.h
new file mode 100644
index 0000000..bc9dcc8
--- /dev/null
+++ b/drivers/soc/ti/knav_qmss.h
@@ -0,0 +1,386 @@
+/*
+ * Keystone Navigator QMSS driver internal header
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Author:	Sandeep Nair <sandeep_n@ti.com>
+ *		Cyril Chemparathy <cyril@ti.com>
+ *		Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#ifndef __KNAV_QMSS_H__
+#define __KNAV_QMSS_H__
+
+#define THRESH_GTE	BIT(7)
+#define THRESH_LT	0
+
+#define PDSP_CTRL_PC_MASK	0xffff0000
+#define PDSP_CTRL_SOFT_RESET	BIT(0)
+#define PDSP_CTRL_ENABLE	BIT(1)
+#define PDSP_CTRL_RUNNING	BIT(15)
+
+#define ACC_MAX_CHANNEL		48
+#define ACC_DEFAULT_PERIOD	25 /* usecs */
+
+#define ACC_CHANNEL_INT_BASE		2
+
+#define ACC_LIST_ENTRY_TYPE		1
+#define ACC_LIST_ENTRY_WORDS		(1 << ACC_LIST_ENTRY_TYPE)
+#define ACC_LIST_ENTRY_QUEUE_IDX	0
+#define ACC_LIST_ENTRY_DESC_IDX	(ACC_LIST_ENTRY_WORDS - 1)
+
+#define ACC_CMD_DISABLE_CHANNEL	0x80
+#define ACC_CMD_ENABLE_CHANNEL	0x81
+#define ACC_CFG_MULTI_QUEUE		BIT(21)
+
+#define ACC_INTD_OFFSET_EOI		(0x0010)
+#define ACC_INTD_OFFSET_COUNT(ch)	(0x0300 + 4 * (ch))
+#define ACC_INTD_OFFSET_STATUS(ch)	(0x0200 + 4 * ((ch) / 32))
+
+#define RANGE_MAX_IRQS			64
+
+#define ACC_DESCS_MAX		SZ_1K
+#define ACC_DESCS_MASK		(ACC_DESCS_MAX - 1)
+#define DESC_SIZE_MASK		0xful
+#define DESC_PTR_MASK		(~DESC_SIZE_MASK)
+
+#define KNAV_NAME_SIZE			32
+
+enum knav_acc_result {
+	ACC_RET_IDLE,
+	ACC_RET_SUCCESS,
+	ACC_RET_INVALID_COMMAND,
+	ACC_RET_INVALID_CHANNEL,
+	ACC_RET_INACTIVE_CHANNEL,
+	ACC_RET_ACTIVE_CHANNEL,
+	ACC_RET_INVALID_QUEUE,
+	ACC_RET_INVALID_RET,
+};
+
+struct knav_reg_config {
+	u32		revision;
+	u32		__pad1;
+	u32		divert;
+	u32		link_ram_base0;
+	u32		link_ram_size0;
+	u32		link_ram_base1;
+	u32		__pad2[2];
+	u32		starvation[0];
+};
+
+struct knav_reg_region {
+	u32		base;
+	u32		start_index;
+	u32		size_count;
+	u32		__pad;
+};
+
+struct knav_reg_pdsp_regs {
+	u32		control;
+	u32		status;
+	u32		cycle_count;
+	u32		stall_count;
+};
+
+struct knav_reg_acc_command {
+	u32		command;
+	u32		queue_mask;
+	u32		list_phys;
+	u32		queue_num;
+	u32		timer_config;
+};
+
+struct knav_link_ram_block {
+	dma_addr_t	 phys;
+	void		*virt;
+	size_t		 size;
+};
+
+struct knav_acc_info {
+	u32			 pdsp_id;
+	u32			 start_channel;
+	u32			 list_entries;
+	u32			 pacing_mode;
+	u32			 timer_count;
+	int			 mem_size;
+	int			 list_size;
+	struct knav_pdsp_info	*pdsp;
+};
+
+struct knav_acc_channel {
+	u32			channel;
+	u32			list_index;
+	u32			open_mask;
+	u32			*list_cpu[2];
+	dma_addr_t		list_dma[2];
+	char			name[KNAV_NAME_SIZE];
+	atomic_t		retrigger_count;
+};
+
+struct knav_pdsp_info {
+	const char					*name;
+	struct knav_reg_pdsp_regs  __iomem		*regs;
+	union {
+		void __iomem				*command;
+		struct knav_reg_acc_command __iomem	*acc_command;
+		u32 __iomem				*qos_command;
+	};
+	void __iomem					*intd;
+	u32 __iomem					*iram;
+	const char					*firmware;
+	u32						id;
+	struct list_head				list;
+};
+
+struct knav_qmgr_info {
+	unsigned			start_queue;
+	unsigned			num_queues;
+	struct knav_reg_config __iomem	*reg_config;
+	struct knav_reg_region __iomem	*reg_region;
+	struct knav_reg_queue __iomem	*reg_push, *reg_pop, *reg_peek;
+	void __iomem			*reg_status;
+	struct list_head		list;
+};
+
+#define KNAV_NUM_LINKRAM	2
+
+/**
+ * struct knav_queue_stats:	queue statistics
+ * pushes:			number of push operations
+ * pops:			number of pop operations
+ * push_errors:			number of push errors
+ * pop_errors:			number of pop errors
+ * notifies:			notifier counts
+ */
+struct knav_queue_stats {
+	atomic_t	 pushes;
+	atomic_t	 pops;
+	atomic_t	 push_errors;
+	atomic_t	 pop_errors;
+	atomic_t	 notifies;
+};
+
+/**
+ * struct knav_reg_queue:	queue registers
+ * @entry_count:		valid entries in the queue
+ * @byte_count:			total byte count in thhe queue
+ * @packet_size:		packet size for the queue
+ * @ptr_size_thresh:		packet pointer size threshold
+ */
+struct knav_reg_queue {
+	u32		entry_count;
+	u32		byte_count;
+	u32		packet_size;
+	u32		ptr_size_thresh;
+};
+
+/**
+ * struct knav_region:		qmss region info
+ * @dma_start, dma_end:		start and end dma address
+ * @virt_start, virt_end:	start and end virtual address
+ * @desc_size:			descriptor size
+ * @used_desc:			consumed descriptors
+ * @id:				region number
+ * @num_desc:			total descriptors
+ * @link_index:			index of the first descriptor
+ * @name:			region name
+ * @list:			instance in the device's region list
+ * @pools:			list of descriptor pools in the region
+ */
+struct knav_region {
+	dma_addr_t		dma_start, dma_end;
+	void			*virt_start, *virt_end;
+	unsigned		desc_size;
+	unsigned		used_desc;
+	unsigned		id;
+	unsigned		num_desc;
+	unsigned		link_index;
+	const char		*name;
+	struct list_head	list;
+	struct list_head	pools;
+};
+
+/**
+ * struct knav_pool:		qmss pools
+ * @dev:			device pointer
+ * @region:			qmss region info
+ * @queue:			queue registers
+ * @kdev:			qmss device pointer
+ * @region_offset:		offset from the base
+ * @num_desc:			total descriptors
+ * @desc_size:			descriptor size
+ * @region_id:			region number
+ * @name:			pool name
+ * @list:			list head
+ * @region_inst:		instance in the region's pool list
+ */
+struct knav_pool {
+	struct device			*dev;
+	struct knav_region		*region;
+	struct knav_queue		*queue;
+	struct knav_device		*kdev;
+	int				region_offset;
+	int				num_desc;
+	int				desc_size;
+	int				region_id;
+	const char			*name;
+	struct list_head		list;
+	struct list_head		region_inst;
+};
+
+/**
+ * struct knav_queue_inst:		qmss queue instace properties
+ * @descs:				descriptor pointer
+ * @desc_head, desc_tail, desc_count:	descriptor counters
+ * @acc:				accumulator channel pointer
+ * @kdev:				qmss device pointer
+ * @range:				range info
+ * @qmgr:				queue manager info
+ * @id:					queue instace id
+ * @irq_num:				irq line number
+ * @notify_needed:			notifier needed based on queue type
+ * @num_notifiers:			total notifiers
+ * @handles:				list head
+ * @name:				queue instance name
+ * @irq_name:				irq line name
+ */
+struct knav_queue_inst {
+	u32				*descs;
+	atomic_t			desc_head, desc_tail, desc_count;
+	struct knav_acc_channel	*acc;
+	struct knav_device		*kdev;
+	struct knav_range_info		*range;
+	struct knav_qmgr_info		*qmgr;
+	u32				id;
+	int				irq_num;
+	int				notify_needed;
+	atomic_t			num_notifiers;
+	struct list_head		handles;
+	const char			*name;
+	const char			*irq_name;
+};
+
+/**
+ * struct knav_queue:			qmss queue properties
+ * @reg_push, reg_pop, reg_peek:	push, pop queue registers
+ * @inst:				qmss queue instace properties
+ * @notifier_fn:			notifier function
+ * @notifier_fn_arg:			notifier function argument
+ * @notifier_enabled:			notier enabled for a give queue
+ * @rcu:				rcu head
+ * @flags:				queue flags
+ * @list:				list head
+ */
+struct knav_queue {
+	struct knav_reg_queue __iomem	*reg_push, *reg_pop, *reg_peek;
+	struct knav_queue_inst		*inst;
+	struct knav_queue_stats	stats;
+	knav_queue_notify_fn		notifier_fn;
+	void				*notifier_fn_arg;
+	atomic_t			notifier_enabled;
+	struct rcu_head			rcu;
+	unsigned			flags;
+	struct list_head		list;
+};
+
+struct knav_device {
+	struct device				*dev;
+	unsigned				base_id;
+	unsigned				num_queues;
+	unsigned				num_queues_in_use;
+	unsigned				inst_shift;
+	struct knav_link_ram_block		link_rams[KNAV_NUM_LINKRAM];
+	void					*instances;
+	struct list_head			regions;
+	struct list_head			queue_ranges;
+	struct list_head			pools;
+	struct list_head			pdsps;
+	struct list_head			qmgrs;
+};
+
+struct knav_range_ops {
+	int	(*init_range)(struct knav_range_info *range);
+	int	(*free_range)(struct knav_range_info *range);
+	int	(*init_queue)(struct knav_range_info *range,
+			      struct knav_queue_inst *inst);
+	int	(*open_queue)(struct knav_range_info *range,
+			      struct knav_queue_inst *inst, unsigned flags);
+	int	(*close_queue)(struct knav_range_info *range,
+			       struct knav_queue_inst *inst);
+	int	(*set_notify)(struct knav_range_info *range,
+			      struct knav_queue_inst *inst, bool enabled);
+};
+
+struct knav_irq_info {
+	int	irq;
+	u32	cpu_map;
+};
+
+struct knav_range_info {
+	const char			*name;
+	struct knav_device		*kdev;
+	unsigned			queue_base;
+	unsigned			num_queues;
+	void				*queue_base_inst;
+	unsigned			flags;
+	struct list_head		list;
+	struct knav_range_ops		*ops;
+	struct knav_acc_info		acc_info;
+	struct knav_acc_channel	*acc;
+	unsigned			num_irqs;
+	struct knav_irq_info		irqs[RANGE_MAX_IRQS];
+};
+
+#define RANGE_RESERVED		BIT(0)
+#define RANGE_HAS_IRQ		BIT(1)
+#define RANGE_HAS_ACCUMULATOR	BIT(2)
+#define RANGE_MULTI_QUEUE	BIT(3)
+
+#define for_each_region(kdev, region)				\
+	list_for_each_entry(region, &kdev->regions, list)
+
+#define first_region(kdev)					\
+	list_first_entry(&kdev->regions, \
+			struct knav_region, list)
+
+#define for_each_queue_range(kdev, range)			\
+	list_for_each_entry(range, &kdev->queue_ranges, list)
+
+#define first_queue_range(kdev)					\
+	list_first_entry(&kdev->queue_ranges, \
+			struct knav_range_info, list)
+
+#define for_each_pool(kdev, pool)				\
+	list_for_each_entry(pool, &kdev->pools, list)
+
+#define for_each_pdsp(kdev, pdsp)				\
+	list_for_each_entry(pdsp, &kdev->pdsps, list)
+
+#define for_each_qmgr(kdev, qmgr)				\
+	list_for_each_entry(qmgr, &kdev->qmgrs, list)
+
+static inline struct knav_pdsp_info *
+knav_find_pdsp(struct knav_device *kdev, unsigned pdsp_id)
+{
+	struct knav_pdsp_info *pdsp;
+
+	for_each_pdsp(kdev, pdsp)
+		if (pdsp_id == pdsp->id)
+			return pdsp;
+	return NULL;
+}
+
+extern int knav_init_acc_range(struct knav_device *kdev,
+					struct device_node *node,
+					struct knav_range_info *range);
+extern void knav_queue_notify(struct knav_queue_inst *inst);
+
+#endif /* __KNAV_QMSS_H__ */
diff --git a/drivers/soc/ti/knav_qmss_acc.c b/drivers/soc/ti/knav_qmss_acc.c
new file mode 100644
index 0000000..6fbfde6e
--- /dev/null
+++ b/drivers/soc/ti/knav_qmss_acc.c
@@ -0,0 +1,591 @@
+/*
+ * Keystone accumulator queue manager
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Author:	Sandeep Nair <sandeep_n@ti.com>
+ *		Cyril Chemparathy <cyril@ti.com>
+ *		Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/soc/ti/knav_qmss.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/firmware.h>
+
+#include "knav_qmss.h"
+
+#define knav_range_offset_to_inst(kdev, range, q)	\
+	(range->queue_base_inst + (q << kdev->inst_shift))
+
+static void __knav_acc_notify(struct knav_range_info *range,
+				struct knav_acc_channel *acc)
+{
+	struct knav_device *kdev = range->kdev;
+	struct knav_queue_inst *inst;
+	int range_base, queue;
+
+	range_base = kdev->base_id + range->queue_base;
+
+	if (range->flags & RANGE_MULTI_QUEUE) {
+		for (queue = 0; queue < range->num_queues; queue++) {
+			inst = knav_range_offset_to_inst(kdev, range,
+								queue);
+			if (inst->notify_needed) {
+				inst->notify_needed = 0;
+				dev_dbg(kdev->dev, "acc-irq: notifying %d\n",
+					range_base + queue);
+				knav_queue_notify(inst);
+			}
+		}
+	} else {
+		queue = acc->channel - range->acc_info.start_channel;
+		inst = knav_range_offset_to_inst(kdev, range, queue);
+		dev_dbg(kdev->dev, "acc-irq: notifying %d\n",
+			range_base + queue);
+		knav_queue_notify(inst);
+	}
+}
+
+static int knav_acc_set_notify(struct knav_range_info *range,
+				struct knav_queue_inst *kq,
+				bool enabled)
+{
+	struct knav_pdsp_info *pdsp = range->acc_info.pdsp;
+	struct knav_device *kdev = range->kdev;
+	u32 mask, offset;
+
+	/*
+	 * when enabling, we need to re-trigger an interrupt if we
+	 * have descriptors pending
+	 */
+	if (!enabled || atomic_read(&kq->desc_count) <= 0)
+		return 0;
+
+	kq->notify_needed = 1;
+	atomic_inc(&kq->acc->retrigger_count);
+	mask = BIT(kq->acc->channel % 32);
+	offset = ACC_INTD_OFFSET_STATUS(kq->acc->channel);
+	dev_dbg(kdev->dev, "setup-notify: re-triggering irq for %s\n",
+		kq->acc->name);
+	writel_relaxed(mask, pdsp->intd + offset);
+	return 0;
+}
+
+static irqreturn_t knav_acc_int_handler(int irq, void *_instdata)
+{
+	struct knav_acc_channel *acc;
+	struct knav_queue_inst *kq = NULL;
+	struct knav_range_info *range;
+	struct knav_pdsp_info *pdsp;
+	struct knav_acc_info *info;
+	struct knav_device *kdev;
+
+	u32 *list, *list_cpu, val, idx, notifies;
+	int range_base, channel, queue = 0;
+	dma_addr_t list_dma;
+
+	range = _instdata;
+	info  = &range->acc_info;
+	kdev  = range->kdev;
+	pdsp  = range->acc_info.pdsp;
+	acc   = range->acc;
+
+	range_base = kdev->base_id + range->queue_base;
+	if ((range->flags & RANGE_MULTI_QUEUE) == 0) {
+		for (queue = 0; queue < range->num_irqs; queue++)
+			if (range->irqs[queue].irq == irq)
+				break;
+		kq = knav_range_offset_to_inst(kdev, range, queue);
+		acc += queue;
+	}
+
+	channel = acc->channel;
+	list_dma = acc->list_dma[acc->list_index];
+	list_cpu = acc->list_cpu[acc->list_index];
+	dev_dbg(kdev->dev, "acc-irq: channel %d, list %d, virt %p, phys %x\n",
+		channel, acc->list_index, list_cpu, list_dma);
+	if (atomic_read(&acc->retrigger_count)) {
+		atomic_dec(&acc->retrigger_count);
+		__knav_acc_notify(range, acc);
+		writel_relaxed(1, pdsp->intd + ACC_INTD_OFFSET_COUNT(channel));
+		/* ack the interrupt */
+		writel_relaxed(ACC_CHANNEL_INT_BASE + channel,
+			       pdsp->intd + ACC_INTD_OFFSET_EOI);
+
+		return IRQ_HANDLED;
+	}
+
+	notifies = readl_relaxed(pdsp->intd + ACC_INTD_OFFSET_COUNT(channel));
+	WARN_ON(!notifies);
+	dma_sync_single_for_cpu(kdev->dev, list_dma, info->list_size,
+				DMA_FROM_DEVICE);
+
+	for (list = list_cpu; list < list_cpu + (info->list_size / sizeof(u32));
+	     list += ACC_LIST_ENTRY_WORDS) {
+		if (ACC_LIST_ENTRY_WORDS == 1) {
+			dev_dbg(kdev->dev,
+				"acc-irq: list %d, entry @%p, %08x\n",
+				acc->list_index, list, list[0]);
+		} else if (ACC_LIST_ENTRY_WORDS == 2) {
+			dev_dbg(kdev->dev,
+				"acc-irq: list %d, entry @%p, %08x %08x\n",
+				acc->list_index, list, list[0], list[1]);
+		} else if (ACC_LIST_ENTRY_WORDS == 4) {
+			dev_dbg(kdev->dev,
+				"acc-irq: list %d, entry @%p, %08x %08x %08x %08x\n",
+				acc->list_index, list, list[0], list[1],
+				list[2], list[3]);
+		}
+
+		val = list[ACC_LIST_ENTRY_DESC_IDX];
+		if (!val)
+			break;
+
+		if (range->flags & RANGE_MULTI_QUEUE) {
+			queue = list[ACC_LIST_ENTRY_QUEUE_IDX] >> 16;
+			if (queue < range_base ||
+			    queue >= range_base + range->num_queues) {
+				dev_err(kdev->dev,
+					"bad queue %d, expecting %d-%d\n",
+					queue, range_base,
+					range_base + range->num_queues);
+				break;
+			}
+			queue -= range_base;
+			kq = knav_range_offset_to_inst(kdev, range,
+								queue);
+		}
+
+		if (atomic_inc_return(&kq->desc_count) >= ACC_DESCS_MAX) {
+			atomic_dec(&kq->desc_count);
+			dev_err(kdev->dev,
+				"acc-irq: queue %d full, entry dropped\n",
+				queue + range_base);
+			continue;
+		}
+
+		idx = atomic_inc_return(&kq->desc_tail) & ACC_DESCS_MASK;
+		kq->descs[idx] = val;
+		kq->notify_needed = 1;
+		dev_dbg(kdev->dev, "acc-irq: enqueue %08x at %d, queue %d\n",
+			val, idx, queue + range_base);
+	}
+
+	__knav_acc_notify(range, acc);
+	memset(list_cpu, 0, info->list_size);
+	dma_sync_single_for_device(kdev->dev, list_dma, info->list_size,
+				   DMA_TO_DEVICE);
+
+	/* flip to the other list */
+	acc->list_index ^= 1;
+
+	/* reset the interrupt counter */
+	writel_relaxed(1, pdsp->intd + ACC_INTD_OFFSET_COUNT(channel));
+
+	/* ack the interrupt */
+	writel_relaxed(ACC_CHANNEL_INT_BASE + channel,
+		       pdsp->intd + ACC_INTD_OFFSET_EOI);
+
+	return IRQ_HANDLED;
+}
+
+int knav_range_setup_acc_irq(struct knav_range_info *range,
+				int queue, bool enabled)
+{
+	struct knav_device *kdev = range->kdev;
+	struct knav_acc_channel *acc;
+	unsigned long cpu_map;
+	int ret = 0, irq;
+	u32 old, new;
+
+	if (range->flags & RANGE_MULTI_QUEUE) {
+		acc = range->acc;
+		irq = range->irqs[0].irq;
+		cpu_map = range->irqs[0].cpu_map;
+	} else {
+		acc = range->acc + queue;
+		irq = range->irqs[queue].irq;
+		cpu_map = range->irqs[queue].cpu_map;
+	}
+
+	old = acc->open_mask;
+	if (enabled)
+		new = old | BIT(queue);
+	else
+		new = old & ~BIT(queue);
+	acc->open_mask = new;
+
+	dev_dbg(kdev->dev,
+		"setup-acc-irq: open mask old %08x, new %08x, channel %s\n",
+		old, new, acc->name);
+
+	if (likely(new == old))
+		return 0;
+
+	if (new && !old) {
+		dev_dbg(kdev->dev,
+			"setup-acc-irq: requesting %s for channel %s\n",
+			acc->name, acc->name);
+		ret = request_irq(irq, knav_acc_int_handler, 0, acc->name,
+				  range);
+		if (!ret && cpu_map) {
+			ret = irq_set_affinity_hint(irq, to_cpumask(&cpu_map));
+			if (ret) {
+				dev_warn(range->kdev->dev,
+					 "Failed to set IRQ affinity\n");
+				return ret;
+			}
+		}
+	}
+
+	if (old && !new) {
+		dev_dbg(kdev->dev, "setup-acc-irq: freeing %s for channel %s\n",
+			acc->name, acc->name);
+		free_irq(irq, range);
+	}
+
+	return ret;
+}
+
+static const char *knav_acc_result_str(enum knav_acc_result result)
+{
+	static const char * const result_str[] = {
+		[ACC_RET_IDLE]			= "idle",
+		[ACC_RET_SUCCESS]		= "success",
+		[ACC_RET_INVALID_COMMAND]	= "invalid command",
+		[ACC_RET_INVALID_CHANNEL]	= "invalid channel",
+		[ACC_RET_INACTIVE_CHANNEL]	= "inactive channel",
+		[ACC_RET_ACTIVE_CHANNEL]	= "active channel",
+		[ACC_RET_INVALID_QUEUE]		= "invalid queue",
+		[ACC_RET_INVALID_RET]		= "invalid return code",
+	};
+
+	if (result >= ARRAY_SIZE(result_str))
+		return result_str[ACC_RET_INVALID_RET];
+	else
+		return result_str[result];
+}
+
+static enum knav_acc_result
+knav_acc_write(struct knav_device *kdev, struct knav_pdsp_info *pdsp,
+		struct knav_reg_acc_command *cmd)
+{
+	u32 result;
+
+	dev_dbg(kdev->dev, "acc command %08x %08x %08x %08x %08x\n",
+		cmd->command, cmd->queue_mask, cmd->list_phys,
+		cmd->queue_num, cmd->timer_config);
+
+	writel_relaxed(cmd->timer_config, &pdsp->acc_command->timer_config);
+	writel_relaxed(cmd->queue_num, &pdsp->acc_command->queue_num);
+	writel_relaxed(cmd->list_phys, &pdsp->acc_command->list_phys);
+	writel_relaxed(cmd->queue_mask, &pdsp->acc_command->queue_mask);
+	writel_relaxed(cmd->command, &pdsp->acc_command->command);
+
+	/* wait for the command to clear */
+	do {
+		result = readl_relaxed(&pdsp->acc_command->command);
+	} while ((result >> 8) & 0xff);
+
+	return (result >> 24) & 0xff;
+}
+
+static void knav_acc_setup_cmd(struct knav_device *kdev,
+				struct knav_range_info *range,
+				struct knav_reg_acc_command *cmd,
+				int queue)
+{
+	struct knav_acc_info *info = &range->acc_info;
+	struct knav_acc_channel *acc;
+	int queue_base;
+	u32 queue_mask;
+
+	if (range->flags & RANGE_MULTI_QUEUE) {
+		acc = range->acc;
+		queue_base = range->queue_base;
+		queue_mask = BIT(range->num_queues) - 1;
+	} else {
+		acc = range->acc + queue;
+		queue_base = range->queue_base + queue;
+		queue_mask = 0;
+	}
+
+	memset(cmd, 0, sizeof(*cmd));
+	cmd->command    = acc->channel;
+	cmd->queue_mask = queue_mask;
+	cmd->list_phys  = acc->list_dma[0];
+	cmd->queue_num  = info->list_entries << 16;
+	cmd->queue_num |= queue_base;
+
+	cmd->timer_config = ACC_LIST_ENTRY_TYPE << 18;
+	if (range->flags & RANGE_MULTI_QUEUE)
+		cmd->timer_config |= ACC_CFG_MULTI_QUEUE;
+	cmd->timer_config |= info->pacing_mode << 16;
+	cmd->timer_config |= info->timer_count;
+}
+
+static void knav_acc_stop(struct knav_device *kdev,
+				struct knav_range_info *range,
+				int queue)
+{
+	struct knav_reg_acc_command cmd;
+	struct knav_acc_channel *acc;
+	enum knav_acc_result result;
+
+	acc = range->acc + queue;
+
+	knav_acc_setup_cmd(kdev, range, &cmd, queue);
+	cmd.command |= ACC_CMD_DISABLE_CHANNEL << 8;
+	result = knav_acc_write(kdev, range->acc_info.pdsp, &cmd);
+
+	dev_dbg(kdev->dev, "stopped acc channel %s, result %s\n",
+		acc->name, knav_acc_result_str(result));
+}
+
+static enum knav_acc_result knav_acc_start(struct knav_device *kdev,
+						struct knav_range_info *range,
+						int queue)
+{
+	struct knav_reg_acc_command cmd;
+	struct knav_acc_channel *acc;
+	enum knav_acc_result result;
+
+	acc = range->acc + queue;
+
+	knav_acc_setup_cmd(kdev, range, &cmd, queue);
+	cmd.command |= ACC_CMD_ENABLE_CHANNEL << 8;
+	result = knav_acc_write(kdev, range->acc_info.pdsp, &cmd);
+
+	dev_dbg(kdev->dev, "started acc channel %s, result %s\n",
+		acc->name, knav_acc_result_str(result));
+
+	return result;
+}
+
+static int knav_acc_init_range(struct knav_range_info *range)
+{
+	struct knav_device *kdev = range->kdev;
+	struct knav_acc_channel *acc;
+	enum knav_acc_result result;
+	int queue;
+
+	for (queue = 0; queue < range->num_queues; queue++) {
+		acc = range->acc + queue;
+
+		knav_acc_stop(kdev, range, queue);
+		acc->list_index = 0;
+		result = knav_acc_start(kdev, range, queue);
+
+		if (result != ACC_RET_SUCCESS)
+			return -EIO;
+
+		if (range->flags & RANGE_MULTI_QUEUE)
+			return 0;
+	}
+	return 0;
+}
+
+static int knav_acc_init_queue(struct knav_range_info *range,
+				struct knav_queue_inst *kq)
+{
+	unsigned id = kq->id - range->queue_base;
+
+	kq->descs = devm_kzalloc(range->kdev->dev,
+				 ACC_DESCS_MAX * sizeof(u32), GFP_KERNEL);
+	if (!kq->descs)
+		return -ENOMEM;
+
+	kq->acc = range->acc;
+	if ((range->flags & RANGE_MULTI_QUEUE) == 0)
+		kq->acc += id;
+	return 0;
+}
+
+static int knav_acc_open_queue(struct knav_range_info *range,
+				struct knav_queue_inst *inst, unsigned flags)
+{
+	unsigned id = inst->id - range->queue_base;
+
+	return knav_range_setup_acc_irq(range, id, true);
+}
+
+static int knav_acc_close_queue(struct knav_range_info *range,
+					struct knav_queue_inst *inst)
+{
+	unsigned id = inst->id - range->queue_base;
+
+	return knav_range_setup_acc_irq(range, id, false);
+}
+
+static int knav_acc_free_range(struct knav_range_info *range)
+{
+	struct knav_device *kdev = range->kdev;
+	struct knav_acc_channel *acc;
+	struct knav_acc_info *info;
+	int channel, channels;
+
+	info = &range->acc_info;
+
+	if (range->flags & RANGE_MULTI_QUEUE)
+		channels = 1;
+	else
+		channels = range->num_queues;
+
+	for (channel = 0; channel < channels; channel++) {
+		acc = range->acc + channel;
+		if (!acc->list_cpu[0])
+			continue;
+		dma_unmap_single(kdev->dev, acc->list_dma[0],
+				 info->mem_size, DMA_BIDIRECTIONAL);
+		free_pages_exact(acc->list_cpu[0], info->mem_size);
+	}
+	devm_kfree(range->kdev->dev, range->acc);
+	return 0;
+}
+
+struct knav_range_ops knav_acc_range_ops = {
+	.set_notify	= knav_acc_set_notify,
+	.init_queue	= knav_acc_init_queue,
+	.open_queue	= knav_acc_open_queue,
+	.close_queue	= knav_acc_close_queue,
+	.init_range	= knav_acc_init_range,
+	.free_range	= knav_acc_free_range,
+};
+
+/**
+ * knav_init_acc_range: Initialise accumulator ranges
+ *
+ * @kdev:		qmss device
+ * @node:		device node
+ * @range:		qmms range information
+ *
+ * Return 0 on success or error
+ */
+int knav_init_acc_range(struct knav_device *kdev,
+				struct device_node *node,
+				struct knav_range_info *range)
+{
+	struct knav_acc_channel *acc;
+	struct knav_pdsp_info *pdsp;
+	struct knav_acc_info *info;
+	int ret, channel, channels;
+	int list_size, mem_size;
+	dma_addr_t list_dma;
+	void *list_mem;
+	u32 config[5];
+
+	range->flags |= RANGE_HAS_ACCUMULATOR;
+	info = &range->acc_info;
+
+	ret = of_property_read_u32_array(node, "accumulator", config, 5);
+	if (ret)
+		return ret;
+
+	info->pdsp_id		= config[0];
+	info->start_channel	= config[1];
+	info->list_entries	= config[2];
+	info->pacing_mode	= config[3];
+	info->timer_count	= config[4] / ACC_DEFAULT_PERIOD;
+
+	if (info->start_channel > ACC_MAX_CHANNEL) {
+		dev_err(kdev->dev, "channel %d invalid for range %s\n",
+			info->start_channel, range->name);
+		return -EINVAL;
+	}
+
+	if (info->pacing_mode > 3) {
+		dev_err(kdev->dev, "pacing mode %d invalid for range %s\n",
+			info->pacing_mode, range->name);
+		return -EINVAL;
+	}
+
+	pdsp = knav_find_pdsp(kdev, info->pdsp_id);
+	if (!pdsp) {
+		dev_err(kdev->dev, "pdsp id %d not found for range %s\n",
+			info->pdsp_id, range->name);
+		return -EINVAL;
+	}
+
+	info->pdsp = pdsp;
+	channels = range->num_queues;
+	if (of_get_property(node, "multi-queue", NULL)) {
+		range->flags |= RANGE_MULTI_QUEUE;
+		channels = 1;
+		if (range->queue_base & (32 - 1)) {
+			dev_err(kdev->dev,
+				"misaligned multi-queue accumulator range %s\n",
+				range->name);
+			return -EINVAL;
+		}
+		if (range->num_queues > 32) {
+			dev_err(kdev->dev,
+				"too many queues in accumulator range %s\n",
+				range->name);
+			return -EINVAL;
+		}
+	}
+
+	/* figure out list size */
+	list_size  = info->list_entries;
+	list_size *= ACC_LIST_ENTRY_WORDS * sizeof(u32);
+	info->list_size = list_size;
+	mem_size   = PAGE_ALIGN(list_size * 2);
+	info->mem_size  = mem_size;
+	range->acc = devm_kzalloc(kdev->dev, channels * sizeof(*range->acc),
+				  GFP_KERNEL);
+	if (!range->acc)
+		return -ENOMEM;
+
+	for (channel = 0; channel < channels; channel++) {
+		acc = range->acc + channel;
+		acc->channel = info->start_channel + channel;
+
+		/* allocate memory for the two lists */
+		list_mem = alloc_pages_exact(mem_size, GFP_KERNEL | GFP_DMA);
+		if (!list_mem)
+			return -ENOMEM;
+
+		list_dma = dma_map_single(kdev->dev, list_mem, mem_size,
+					  DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(kdev->dev, list_dma)) {
+			free_pages_exact(list_mem, mem_size);
+			return -ENOMEM;
+		}
+
+		memset(list_mem, 0, mem_size);
+		dma_sync_single_for_device(kdev->dev, list_dma, mem_size,
+					   DMA_TO_DEVICE);
+		scnprintf(acc->name, sizeof(acc->name), "hwqueue-acc-%d",
+			  acc->channel);
+		acc->list_cpu[0] = list_mem;
+		acc->list_cpu[1] = list_mem + list_size;
+		acc->list_dma[0] = list_dma;
+		acc->list_dma[1] = list_dma + list_size;
+		dev_dbg(kdev->dev, "%s: channel %d, phys %08x, virt %8p\n",
+			acc->name, acc->channel, list_dma, list_mem);
+	}
+
+	range->ops = &knav_acc_range_ops;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(knav_init_acc_range);
diff --git a/drivers/soc/ti/knav_qmss_queue.c b/drivers/soc/ti/knav_qmss_queue.c
new file mode 100644
index 0000000..ea410f5
--- /dev/null
+++ b/drivers/soc/ti/knav_qmss_queue.c
@@ -0,0 +1,1814 @@
+/*
+ * Keystone Queue Manager subsystem driver
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Authors:	Sandeep Nair <sandeep_n@ti.com>
+ *		Cyril Chemparathy <cyril@ti.com>
+ *		Santosh Shilimkar <santosh.shilimkar@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/clk.h>
+#include <linux/io.h>
+#include <linux/interrupt.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/dma-mapping.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/pm_runtime.h>
+#include <linux/firmware.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/soc/ti/knav_qmss.h>
+
+#include "knav_qmss.h"
+
+static struct knav_device *kdev;
+static DEFINE_MUTEX(knav_dev_lock);
+
+/* Queue manager register indices in DTS */
+#define KNAV_QUEUE_PEEK_REG_INDEX	0
+#define KNAV_QUEUE_STATUS_REG_INDEX	1
+#define KNAV_QUEUE_CONFIG_REG_INDEX	2
+#define KNAV_QUEUE_REGION_REG_INDEX	3
+#define KNAV_QUEUE_PUSH_REG_INDEX	4
+#define KNAV_QUEUE_POP_REG_INDEX	5
+
+/* PDSP register indices in DTS */
+#define KNAV_QUEUE_PDSP_IRAM_REG_INDEX	0
+#define KNAV_QUEUE_PDSP_REGS_REG_INDEX	1
+#define KNAV_QUEUE_PDSP_INTD_REG_INDEX	2
+#define KNAV_QUEUE_PDSP_CMD_REG_INDEX	3
+
+#define knav_queue_idx_to_inst(kdev, idx)			\
+	(kdev->instances + (idx << kdev->inst_shift))
+
+#define for_each_handle_rcu(qh, inst)			\
+	list_for_each_entry_rcu(qh, &inst->handles, list)
+
+#define for_each_instance(idx, inst, kdev)		\
+	for (idx = 0, inst = kdev->instances;		\
+	     idx < (kdev)->num_queues_in_use;			\
+	     idx++, inst = knav_queue_idx_to_inst(kdev, idx))
+
+/**
+ * knav_queue_notify: qmss queue notfier call
+ *
+ * @inst:		qmss queue instance like accumulator
+ */
+void knav_queue_notify(struct knav_queue_inst *inst)
+{
+	struct knav_queue *qh;
+
+	if (!inst)
+		return;
+
+	rcu_read_lock();
+	for_each_handle_rcu(qh, inst) {
+		if (atomic_read(&qh->notifier_enabled) <= 0)
+			continue;
+		if (WARN_ON(!qh->notifier_fn))
+			continue;
+		atomic_inc(&qh->stats.notifies);
+		qh->notifier_fn(qh->notifier_fn_arg);
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(knav_queue_notify);
+
+static irqreturn_t knav_queue_int_handler(int irq, void *_instdata)
+{
+	struct knav_queue_inst *inst = _instdata;
+
+	knav_queue_notify(inst);
+	return IRQ_HANDLED;
+}
+
+static int knav_queue_setup_irq(struct knav_range_info *range,
+			  struct knav_queue_inst *inst)
+{
+	unsigned queue = inst->id - range->queue_base;
+	unsigned long cpu_map;
+	int ret = 0, irq;
+
+	if (range->flags & RANGE_HAS_IRQ) {
+		irq = range->irqs[queue].irq;
+		cpu_map = range->irqs[queue].cpu_map;
+		ret = request_irq(irq, knav_queue_int_handler, 0,
+					inst->irq_name, inst);
+		if (ret)
+			return ret;
+		disable_irq(irq);
+		if (cpu_map) {
+			ret = irq_set_affinity_hint(irq, to_cpumask(&cpu_map));
+			if (ret) {
+				dev_warn(range->kdev->dev,
+					 "Failed to set IRQ affinity\n");
+				return ret;
+			}
+		}
+	}
+	return ret;
+}
+
+static void knav_queue_free_irq(struct knav_queue_inst *inst)
+{
+	struct knav_range_info *range = inst->range;
+	unsigned queue = inst->id - inst->range->queue_base;
+	int irq;
+
+	if (range->flags & RANGE_HAS_IRQ) {
+		irq = range->irqs[queue].irq;
+		irq_set_affinity_hint(irq, NULL);
+		free_irq(irq, inst);
+	}
+}
+
+static inline bool knav_queue_is_busy(struct knav_queue_inst *inst)
+{
+	return !list_empty(&inst->handles);
+}
+
+static inline bool knav_queue_is_reserved(struct knav_queue_inst *inst)
+{
+	return inst->range->flags & RANGE_RESERVED;
+}
+
+static inline bool knav_queue_is_shared(struct knav_queue_inst *inst)
+{
+	struct knav_queue *tmp;
+
+	rcu_read_lock();
+	for_each_handle_rcu(tmp, inst) {
+		if (tmp->flags & KNAV_QUEUE_SHARED) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+	return false;
+}
+
+static inline bool knav_queue_match_type(struct knav_queue_inst *inst,
+						unsigned type)
+{
+	if ((type == KNAV_QUEUE_QPEND) &&
+	    (inst->range->flags & RANGE_HAS_IRQ)) {
+		return true;
+	} else if ((type == KNAV_QUEUE_ACC) &&
+		(inst->range->flags & RANGE_HAS_ACCUMULATOR)) {
+		return true;
+	} else if ((type == KNAV_QUEUE_GP) &&
+		!(inst->range->flags &
+			(RANGE_HAS_ACCUMULATOR | RANGE_HAS_IRQ))) {
+		return true;
+	}
+	return false;
+}
+
+static inline struct knav_queue_inst *
+knav_queue_match_id_to_inst(struct knav_device *kdev, unsigned id)
+{
+	struct knav_queue_inst *inst;
+	int idx;
+
+	for_each_instance(idx, inst, kdev) {
+		if (inst->id == id)
+			return inst;
+	}
+	return NULL;
+}
+
+static inline struct knav_queue_inst *knav_queue_find_by_id(int id)
+{
+	if (kdev->base_id <= id &&
+	    kdev->base_id + kdev->num_queues > id) {
+		id -= kdev->base_id;
+		return knav_queue_match_id_to_inst(kdev, id);
+	}
+	return NULL;
+}
+
+static struct knav_queue *__knav_queue_open(struct knav_queue_inst *inst,
+				      const char *name, unsigned flags)
+{
+	struct knav_queue *qh;
+	unsigned id;
+	int ret = 0;
+
+	qh = devm_kzalloc(inst->kdev->dev, sizeof(*qh), GFP_KERNEL);
+	if (!qh)
+		return ERR_PTR(-ENOMEM);
+
+	qh->flags = flags;
+	qh->inst = inst;
+	id = inst->id - inst->qmgr->start_queue;
+	qh->reg_push = &inst->qmgr->reg_push[id];
+	qh->reg_pop = &inst->qmgr->reg_pop[id];
+	qh->reg_peek = &inst->qmgr->reg_peek[id];
+
+	/* first opener? */
+	if (!knav_queue_is_busy(inst)) {
+		struct knav_range_info *range = inst->range;
+
+		inst->name = kstrndup(name, KNAV_NAME_SIZE, GFP_KERNEL);
+		if (range->ops && range->ops->open_queue)
+			ret = range->ops->open_queue(range, inst, flags);
+
+		if (ret) {
+			devm_kfree(inst->kdev->dev, qh);
+			return ERR_PTR(ret);
+		}
+	}
+	list_add_tail_rcu(&qh->list, &inst->handles);
+	return qh;
+}
+
+static struct knav_queue *
+knav_queue_open_by_id(const char *name, unsigned id, unsigned flags)
+{
+	struct knav_queue_inst *inst;
+	struct knav_queue *qh;
+
+	mutex_lock(&knav_dev_lock);
+
+	qh = ERR_PTR(-ENODEV);
+	inst = knav_queue_find_by_id(id);
+	if (!inst)
+		goto unlock_ret;
+
+	qh = ERR_PTR(-EEXIST);
+	if (!(flags & KNAV_QUEUE_SHARED) && knav_queue_is_busy(inst))
+		goto unlock_ret;
+
+	qh = ERR_PTR(-EBUSY);
+	if ((flags & KNAV_QUEUE_SHARED) &&
+	    (knav_queue_is_busy(inst) && !knav_queue_is_shared(inst)))
+		goto unlock_ret;
+
+	qh = __knav_queue_open(inst, name, flags);
+
+unlock_ret:
+	mutex_unlock(&knav_dev_lock);
+
+	return qh;
+}
+
+static struct knav_queue *knav_queue_open_by_type(const char *name,
+						unsigned type, unsigned flags)
+{
+	struct knav_queue_inst *inst;
+	struct knav_queue *qh = ERR_PTR(-EINVAL);
+	int idx;
+
+	mutex_lock(&knav_dev_lock);
+
+	for_each_instance(idx, inst, kdev) {
+		if (knav_queue_is_reserved(inst))
+			continue;
+		if (!knav_queue_match_type(inst, type))
+			continue;
+		if (knav_queue_is_busy(inst))
+			continue;
+		qh = __knav_queue_open(inst, name, flags);
+		goto unlock_ret;
+	}
+
+unlock_ret:
+	mutex_unlock(&knav_dev_lock);
+	return qh;
+}
+
+static void knav_queue_set_notify(struct knav_queue_inst *inst, bool enabled)
+{
+	struct knav_range_info *range = inst->range;
+
+	if (range->ops && range->ops->set_notify)
+		range->ops->set_notify(range, inst, enabled);
+}
+
+static int knav_queue_enable_notifier(struct knav_queue *qh)
+{
+	struct knav_queue_inst *inst = qh->inst;
+	bool first;
+
+	if (WARN_ON(!qh->notifier_fn))
+		return -EINVAL;
+
+	/* Adjust the per handle notifier count */
+	first = (atomic_inc_return(&qh->notifier_enabled) == 1);
+	if (!first)
+		return 0; /* nothing to do */
+
+	/* Now adjust the per instance notifier count */
+	first = (atomic_inc_return(&inst->num_notifiers) == 1);
+	if (first)
+		knav_queue_set_notify(inst, true);
+
+	return 0;
+}
+
+static int knav_queue_disable_notifier(struct knav_queue *qh)
+{
+	struct knav_queue_inst *inst = qh->inst;
+	bool last;
+
+	last = (atomic_dec_return(&qh->notifier_enabled) == 0);
+	if (!last)
+		return 0; /* nothing to do */
+
+	last = (atomic_dec_return(&inst->num_notifiers) == 0);
+	if (last)
+		knav_queue_set_notify(inst, false);
+
+	return 0;
+}
+
+static int knav_queue_set_notifier(struct knav_queue *qh,
+				struct knav_queue_notify_config *cfg)
+{
+	knav_queue_notify_fn old_fn = qh->notifier_fn;
+
+	if (!cfg)
+		return -EINVAL;
+
+	if (!(qh->inst->range->flags & (RANGE_HAS_ACCUMULATOR | RANGE_HAS_IRQ)))
+		return -ENOTSUPP;
+
+	if (!cfg->fn && old_fn)
+		knav_queue_disable_notifier(qh);
+
+	qh->notifier_fn = cfg->fn;
+	qh->notifier_fn_arg = cfg->fn_arg;
+
+	if (cfg->fn && !old_fn)
+		knav_queue_enable_notifier(qh);
+
+	return 0;
+}
+
+static int knav_gp_set_notify(struct knav_range_info *range,
+			       struct knav_queue_inst *inst,
+			       bool enabled)
+{
+	unsigned queue;
+
+	if (range->flags & RANGE_HAS_IRQ) {
+		queue = inst->id - range->queue_base;
+		if (enabled)
+			enable_irq(range->irqs[queue].irq);
+		else
+			disable_irq_nosync(range->irqs[queue].irq);
+	}
+	return 0;
+}
+
+static int knav_gp_open_queue(struct knav_range_info *range,
+				struct knav_queue_inst *inst, unsigned flags)
+{
+	return knav_queue_setup_irq(range, inst);
+}
+
+static int knav_gp_close_queue(struct knav_range_info *range,
+				struct knav_queue_inst *inst)
+{
+	knav_queue_free_irq(inst);
+	return 0;
+}
+
+struct knav_range_ops knav_gp_range_ops = {
+	.set_notify	= knav_gp_set_notify,
+	.open_queue	= knav_gp_open_queue,
+	.close_queue	= knav_gp_close_queue,
+};
+
+
+static int knav_queue_get_count(void *qhandle)
+{
+	struct knav_queue *qh = qhandle;
+	struct knav_queue_inst *inst = qh->inst;
+
+	return readl_relaxed(&qh->reg_peek[0].entry_count) +
+		atomic_read(&inst->desc_count);
+}
+
+static void knav_queue_debug_show_instance(struct seq_file *s,
+					struct knav_queue_inst *inst)
+{
+	struct knav_device *kdev = inst->kdev;
+	struct knav_queue *qh;
+
+	if (!knav_queue_is_busy(inst))
+		return;
+
+	seq_printf(s, "\tqueue id %d (%s)\n",
+		   kdev->base_id + inst->id, inst->name);
+	for_each_handle_rcu(qh, inst) {
+		seq_printf(s, "\t\thandle %p: ", qh);
+		seq_printf(s, "pushes %8d, ",
+			   atomic_read(&qh->stats.pushes));
+		seq_printf(s, "pops %8d, ",
+			   atomic_read(&qh->stats.pops));
+		seq_printf(s, "count %8d, ",
+			   knav_queue_get_count(qh));
+		seq_printf(s, "notifies %8d, ",
+			   atomic_read(&qh->stats.notifies));
+		seq_printf(s, "push errors %8d, ",
+			   atomic_read(&qh->stats.push_errors));
+		seq_printf(s, "pop errors %8d\n",
+			   atomic_read(&qh->stats.pop_errors));
+	}
+}
+
+static int knav_queue_debug_show(struct seq_file *s, void *v)
+{
+	struct knav_queue_inst *inst;
+	int idx;
+
+	mutex_lock(&knav_dev_lock);
+	seq_printf(s, "%s: %u-%u\n",
+		   dev_name(kdev->dev), kdev->base_id,
+		   kdev->base_id + kdev->num_queues - 1);
+	for_each_instance(idx, inst, kdev)
+		knav_queue_debug_show_instance(s, inst);
+	mutex_unlock(&knav_dev_lock);
+
+	return 0;
+}
+
+static int knav_queue_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, knav_queue_debug_show, NULL);
+}
+
+static const struct file_operations knav_queue_debug_ops = {
+	.open		= knav_queue_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static inline int knav_queue_pdsp_wait(u32 * __iomem addr, unsigned timeout,
+					u32 flags)
+{
+	unsigned long end;
+	u32 val = 0;
+
+	end = jiffies + msecs_to_jiffies(timeout);
+	while (time_after(end, jiffies)) {
+		val = readl_relaxed(addr);
+		if (flags)
+			val &= flags;
+		if (!val)
+			break;
+		cpu_relax();
+	}
+	return val ? -ETIMEDOUT : 0;
+}
+
+
+static int knav_queue_flush(struct knav_queue *qh)
+{
+	struct knav_queue_inst *inst = qh->inst;
+	unsigned id = inst->id - inst->qmgr->start_queue;
+
+	atomic_set(&inst->desc_count, 0);
+	writel_relaxed(0, &inst->qmgr->reg_push[id].ptr_size_thresh);
+	return 0;
+}
+
+/**
+ * knav_queue_open()	- open a hardware queue
+ * @name		- name to give the queue handle
+ * @id			- desired queue number if any or specifes the type
+ *			  of queue
+ * @flags		- the following flags are applicable to queues:
+ *	KNAV_QUEUE_SHARED - allow the queue to be shared. Queues are
+ *			     exclusive by default.
+ *			     Subsequent attempts to open a shared queue should
+ *			     also have this flag.
+ *
+ * Returns a handle to the open hardware queue if successful. Use IS_ERR()
+ * to check the returned value for error codes.
+ */
+void *knav_queue_open(const char *name, unsigned id,
+					unsigned flags)
+{
+	struct knav_queue *qh = ERR_PTR(-EINVAL);
+
+	switch (id) {
+	case KNAV_QUEUE_QPEND:
+	case KNAV_QUEUE_ACC:
+	case KNAV_QUEUE_GP:
+		qh = knav_queue_open_by_type(name, id, flags);
+		break;
+
+	default:
+		qh = knav_queue_open_by_id(name, id, flags);
+		break;
+	}
+	return qh;
+}
+EXPORT_SYMBOL_GPL(knav_queue_open);
+
+/**
+ * knav_queue_close()	- close a hardware queue handle
+ * @qh			- handle to close
+ */
+void knav_queue_close(void *qhandle)
+{
+	struct knav_queue *qh = qhandle;
+	struct knav_queue_inst *inst = qh->inst;
+
+	while (atomic_read(&qh->notifier_enabled) > 0)
+		knav_queue_disable_notifier(qh);
+
+	mutex_lock(&knav_dev_lock);
+	list_del_rcu(&qh->list);
+	mutex_unlock(&knav_dev_lock);
+	synchronize_rcu();
+	if (!knav_queue_is_busy(inst)) {
+		struct knav_range_info *range = inst->range;
+
+		if (range->ops && range->ops->close_queue)
+			range->ops->close_queue(range, inst);
+	}
+	devm_kfree(inst->kdev->dev, qh);
+}
+EXPORT_SYMBOL_GPL(knav_queue_close);
+
+/**
+ * knav_queue_device_control()	- Perform control operations on a queue
+ * @qh				- queue handle
+ * @cmd				- control commands
+ * @arg				- command argument
+ *
+ * Returns 0 on success, errno otherwise.
+ */
+int knav_queue_device_control(void *qhandle, enum knav_queue_ctrl_cmd cmd,
+				unsigned long arg)
+{
+	struct knav_queue *qh = qhandle;
+	struct knav_queue_notify_config *cfg;
+	int ret;
+
+	switch ((int)cmd) {
+	case KNAV_QUEUE_GET_ID:
+		ret = qh->inst->kdev->base_id + qh->inst->id;
+		break;
+
+	case KNAV_QUEUE_FLUSH:
+		ret = knav_queue_flush(qh);
+		break;
+
+	case KNAV_QUEUE_SET_NOTIFIER:
+		cfg = (void *)arg;
+		ret = knav_queue_set_notifier(qh, cfg);
+		break;
+
+	case KNAV_QUEUE_ENABLE_NOTIFY:
+		ret = knav_queue_enable_notifier(qh);
+		break;
+
+	case KNAV_QUEUE_DISABLE_NOTIFY:
+		ret = knav_queue_disable_notifier(qh);
+		break;
+
+	case KNAV_QUEUE_GET_COUNT:
+		ret = knav_queue_get_count(qh);
+		break;
+
+	default:
+		ret = -ENOTSUPP;
+		break;
+	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(knav_queue_device_control);
+
+
+
+/**
+ * knav_queue_push()	- push data (or descriptor) to the tail of a queue
+ * @qh			- hardware queue handle
+ * @data		- data to push
+ * @size		- size of data to push
+ * @flags		- can be used to pass additional information
+ *
+ * Returns 0 on success, errno otherwise.
+ */
+int knav_queue_push(void *qhandle, dma_addr_t dma,
+					unsigned size, unsigned flags)
+{
+	struct knav_queue *qh = qhandle;
+	u32 val;
+
+	val = (u32)dma | ((size / 16) - 1);
+	writel_relaxed(val, &qh->reg_push[0].ptr_size_thresh);
+
+	atomic_inc(&qh->stats.pushes);
+	return 0;
+}
+
+/**
+ * knav_queue_pop()	- pop data (or descriptor) from the head of a queue
+ * @qh			- hardware queue handle
+ * @size		- (optional) size of the data pop'ed.
+ *
+ * Returns a DMA address on success, 0 on failure.
+ */
+dma_addr_t knav_queue_pop(void *qhandle, unsigned *size)
+{
+	struct knav_queue *qh = qhandle;
+	struct knav_queue_inst *inst = qh->inst;
+	dma_addr_t dma;
+	u32 val, idx;
+
+	/* are we accumulated? */
+	if (inst->descs) {
+		if (unlikely(atomic_dec_return(&inst->desc_count) < 0)) {
+			atomic_inc(&inst->desc_count);
+			return 0;
+		}
+		idx  = atomic_inc_return(&inst->desc_head);
+		idx &= ACC_DESCS_MASK;
+		val = inst->descs[idx];
+	} else {
+		val = readl_relaxed(&qh->reg_pop[0].ptr_size_thresh);
+		if (unlikely(!val))
+			return 0;
+	}
+
+	dma = val & DESC_PTR_MASK;
+	if (size)
+		*size = ((val & DESC_SIZE_MASK) + 1) * 16;
+
+	atomic_inc(&qh->stats.pops);
+	return dma;
+}
+
+/* carve out descriptors and push into queue */
+static void kdesc_fill_pool(struct knav_pool *pool)
+{
+	struct knav_region *region;
+	int i;
+
+	region = pool->region;
+	pool->desc_size = region->desc_size;
+	for (i = 0; i < pool->num_desc; i++) {
+		int index = pool->region_offset + i;
+		dma_addr_t dma_addr;
+		unsigned dma_size;
+		dma_addr = region->dma_start + (region->desc_size * index);
+		dma_size = ALIGN(pool->desc_size, SMP_CACHE_BYTES);
+		dma_sync_single_for_device(pool->dev, dma_addr, dma_size,
+					   DMA_TO_DEVICE);
+		knav_queue_push(pool->queue, dma_addr, dma_size, 0);
+	}
+}
+
+/* pop out descriptors and close the queue */
+static void kdesc_empty_pool(struct knav_pool *pool)
+{
+	dma_addr_t dma;
+	unsigned size;
+	void *desc;
+	int i;
+
+	if (!pool->queue)
+		return;
+
+	for (i = 0;; i++) {
+		dma = knav_queue_pop(pool->queue, &size);
+		if (!dma)
+			break;
+		desc = knav_pool_desc_dma_to_virt(pool, dma);
+		if (!desc) {
+			dev_dbg(pool->kdev->dev,
+				"couldn't unmap desc, continuing\n");
+			continue;
+		}
+	}
+	WARN_ON(i != pool->num_desc);
+	knav_queue_close(pool->queue);
+}
+
+
+/* Get the DMA address of a descriptor */
+dma_addr_t knav_pool_desc_virt_to_dma(void *ph, void *virt)
+{
+	struct knav_pool *pool = ph;
+	return pool->region->dma_start + (virt - pool->region->virt_start);
+}
+
+void *knav_pool_desc_dma_to_virt(void *ph, dma_addr_t dma)
+{
+	struct knav_pool *pool = ph;
+	return pool->region->virt_start + (dma - pool->region->dma_start);
+}
+
+/**
+ * knav_pool_create()	- Create a pool of descriptors
+ * @name		- name to give the pool handle
+ * @num_desc		- numbers of descriptors in the pool
+ * @region_id		- QMSS region id from which the descriptors are to be
+ *			  allocated.
+ *
+ * Returns a pool handle on success.
+ * Use IS_ERR_OR_NULL() to identify error values on return.
+ */
+void *knav_pool_create(const char *name,
+					int num_desc, int region_id)
+{
+	struct knav_region *reg_itr, *region = NULL;
+	struct knav_pool *pool, *pi;
+	struct list_head *node;
+	unsigned last_offset;
+	bool slot_found;
+	int ret;
+
+	if (!kdev->dev)
+		return ERR_PTR(-ENODEV);
+
+	pool = devm_kzalloc(kdev->dev, sizeof(*pool), GFP_KERNEL);
+	if (!pool) {
+		dev_err(kdev->dev, "out of memory allocating pool\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	for_each_region(kdev, reg_itr) {
+		if (reg_itr->id != region_id)
+			continue;
+		region = reg_itr;
+		break;
+	}
+
+	if (!region) {
+		dev_err(kdev->dev, "region-id(%d) not found\n", region_id);
+		ret = -EINVAL;
+		goto err;
+	}
+
+	pool->queue = knav_queue_open(name, KNAV_QUEUE_GP, 0);
+	if (IS_ERR_OR_NULL(pool->queue)) {
+		dev_err(kdev->dev,
+			"failed to open queue for pool(%s), error %ld\n",
+			name, PTR_ERR(pool->queue));
+		ret = PTR_ERR(pool->queue);
+		goto err;
+	}
+
+	pool->name = kstrndup(name, KNAV_NAME_SIZE, GFP_KERNEL);
+	pool->kdev = kdev;
+	pool->dev = kdev->dev;
+
+	mutex_lock(&knav_dev_lock);
+
+	if (num_desc > (region->num_desc - region->used_desc)) {
+		dev_err(kdev->dev, "out of descs in region(%d) for pool(%s)\n",
+			region_id, name);
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	/* Region maintains a sorted (by region offset) list of pools
+	 * use the first free slot which is large enough to accomodate
+	 * the request
+	 */
+	last_offset = 0;
+	slot_found = false;
+	node = &region->pools;
+	list_for_each_entry(pi, &region->pools, region_inst) {
+		if ((pi->region_offset - last_offset) >= num_desc) {
+			slot_found = true;
+			break;
+		}
+		last_offset = pi->region_offset + pi->num_desc;
+	}
+	node = &pi->region_inst;
+
+	if (slot_found) {
+		pool->region = region;
+		pool->num_desc = num_desc;
+		pool->region_offset = last_offset;
+		region->used_desc += num_desc;
+		list_add_tail(&pool->list, &kdev->pools);
+		list_add_tail(&pool->region_inst, node);
+	} else {
+		dev_err(kdev->dev, "pool(%s) create failed: fragmented desc pool in region(%d)\n",
+			name, region_id);
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	mutex_unlock(&knav_dev_lock);
+	kdesc_fill_pool(pool);
+	return pool;
+
+err:
+	mutex_unlock(&knav_dev_lock);
+	kfree(pool->name);
+	devm_kfree(kdev->dev, pool);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(knav_pool_create);
+
+/**
+ * knav_pool_destroy()	- Free a pool of descriptors
+ * @pool		- pool handle
+ */
+void knav_pool_destroy(void *ph)
+{
+	struct knav_pool *pool = ph;
+
+	if (!pool)
+		return;
+
+	if (!pool->region)
+		return;
+
+	kdesc_empty_pool(pool);
+	mutex_lock(&knav_dev_lock);
+
+	pool->region->used_desc -= pool->num_desc;
+	list_del(&pool->region_inst);
+	list_del(&pool->list);
+
+	mutex_unlock(&knav_dev_lock);
+	kfree(pool->name);
+	devm_kfree(kdev->dev, pool);
+}
+EXPORT_SYMBOL_GPL(knav_pool_destroy);
+
+
+/**
+ * knav_pool_desc_get()	- Get a descriptor from the pool
+ * @pool			- pool handle
+ *
+ * Returns descriptor from the pool.
+ */
+void *knav_pool_desc_get(void *ph)
+{
+	struct knav_pool *pool = ph;
+	dma_addr_t dma;
+	unsigned size;
+	void *data;
+
+	dma = knav_queue_pop(pool->queue, &size);
+	if (unlikely(!dma))
+		return ERR_PTR(-ENOMEM);
+	data = knav_pool_desc_dma_to_virt(pool, dma);
+	return data;
+}
+
+/**
+ * knav_pool_desc_put()	- return a descriptor to the pool
+ * @pool			- pool handle
+ */
+void knav_pool_desc_put(void *ph, void *desc)
+{
+	struct knav_pool *pool = ph;
+	dma_addr_t dma;
+	dma = knav_pool_desc_virt_to_dma(pool, desc);
+	knav_queue_push(pool->queue, dma, pool->region->desc_size, 0);
+}
+
+/**
+ * knav_pool_desc_map()	- Map descriptor for DMA transfer
+ * @pool			- pool handle
+ * @desc			- address of descriptor to map
+ * @size			- size of descriptor to map
+ * @dma				- DMA address return pointer
+ * @dma_sz			- adjusted return pointer
+ *
+ * Returns 0 on success, errno otherwise.
+ */
+int knav_pool_desc_map(void *ph, void *desc, unsigned size,
+					dma_addr_t *dma, unsigned *dma_sz)
+{
+	struct knav_pool *pool = ph;
+	*dma = knav_pool_desc_virt_to_dma(pool, desc);
+	size = min(size, pool->region->desc_size);
+	size = ALIGN(size, SMP_CACHE_BYTES);
+	*dma_sz = size;
+	dma_sync_single_for_device(pool->dev, *dma, size, DMA_TO_DEVICE);
+
+	/* Ensure the descriptor reaches to the memory */
+	__iowmb();
+
+	return 0;
+}
+
+/**
+ * knav_pool_desc_unmap()	- Unmap descriptor after DMA transfer
+ * @pool			- pool handle
+ * @dma				- DMA address of descriptor to unmap
+ * @dma_sz			- size of descriptor to unmap
+ *
+ * Returns descriptor address on success, Use IS_ERR_OR_NULL() to identify
+ * error values on return.
+ */
+void *knav_pool_desc_unmap(void *ph, dma_addr_t dma, unsigned dma_sz)
+{
+	struct knav_pool *pool = ph;
+	unsigned desc_sz;
+	void *desc;
+
+	desc_sz = min(dma_sz, pool->region->desc_size);
+	desc = knav_pool_desc_dma_to_virt(pool, dma);
+	dma_sync_single_for_cpu(pool->dev, dma, desc_sz, DMA_FROM_DEVICE);
+	prefetch(desc);
+	return desc;
+}
+
+/**
+ * knav_pool_count()	- Get the number of descriptors in pool.
+ * @pool		- pool handle
+ * Returns number of elements in the pool.
+ */
+int knav_pool_count(void *ph)
+{
+	struct knav_pool *pool = ph;
+	return knav_queue_get_count(pool->queue);
+}
+
+static void knav_queue_setup_region(struct knav_device *kdev,
+					struct knav_region *region)
+{
+	unsigned hw_num_desc, hw_desc_size, size;
+	struct knav_reg_region __iomem  *regs;
+	struct knav_qmgr_info *qmgr;
+	struct knav_pool *pool;
+	int id = region->id;
+	struct page *page;
+
+	/* unused region? */
+	if (!region->num_desc) {
+		dev_warn(kdev->dev, "unused region %s\n", region->name);
+		return;
+	}
+
+	/* get hardware descriptor value */
+	hw_num_desc = ilog2(region->num_desc - 1) + 1;
+
+	/* did we force fit ourselves into nothingness? */
+	if (region->num_desc < 32) {
+		region->num_desc = 0;
+		dev_warn(kdev->dev, "too few descriptors in region %s\n",
+			 region->name);
+		return;
+	}
+
+	size = region->num_desc * region->desc_size;
+	region->virt_start = alloc_pages_exact(size, GFP_KERNEL | GFP_DMA |
+						GFP_DMA32);
+	if (!region->virt_start) {
+		region->num_desc = 0;
+		dev_err(kdev->dev, "memory alloc failed for region %s\n",
+			region->name);
+		return;
+	}
+	region->virt_end = region->virt_start + size;
+	page = virt_to_page(region->virt_start);
+
+	region->dma_start = dma_map_page(kdev->dev, page, 0, size,
+					 DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(kdev->dev, region->dma_start)) {
+		dev_err(kdev->dev, "dma map failed for region %s\n",
+			region->name);
+		goto fail;
+	}
+	region->dma_end = region->dma_start + size;
+
+	pool = devm_kzalloc(kdev->dev, sizeof(*pool), GFP_KERNEL);
+	if (!pool) {
+		dev_err(kdev->dev, "out of memory allocating dummy pool\n");
+		goto fail;
+	}
+	pool->num_desc = 0;
+	pool->region_offset = region->num_desc;
+	list_add(&pool->region_inst, &region->pools);
+
+	dev_dbg(kdev->dev,
+		"region %s (%d): size:%d, link:%d@%d, phys:%08x-%08x, virt:%p-%p\n",
+		region->name, id, region->desc_size, region->num_desc,
+		region->link_index, region->dma_start, region->dma_end,
+		region->virt_start, region->virt_end);
+
+	hw_desc_size = (region->desc_size / 16) - 1;
+	hw_num_desc -= 5;
+
+	for_each_qmgr(kdev, qmgr) {
+		regs = qmgr->reg_region + id;
+		writel_relaxed(region->dma_start, &regs->base);
+		writel_relaxed(region->link_index, &regs->start_index);
+		writel_relaxed(hw_desc_size << 16 | hw_num_desc,
+			       &regs->size_count);
+	}
+	return;
+
+fail:
+	if (region->dma_start)
+		dma_unmap_page(kdev->dev, region->dma_start, size,
+				DMA_BIDIRECTIONAL);
+	if (region->virt_start)
+		free_pages_exact(region->virt_start, size);
+	region->num_desc = 0;
+	return;
+}
+
+static const char *knav_queue_find_name(struct device_node *node)
+{
+	const char *name;
+
+	if (of_property_read_string(node, "label", &name) < 0)
+		name = node->name;
+	if (!name)
+		name = "unknown";
+	return name;
+}
+
+static int knav_queue_setup_regions(struct knav_device *kdev,
+					struct device_node *regions)
+{
+	struct device *dev = kdev->dev;
+	struct knav_region *region;
+	struct device_node *child;
+	u32 temp[2];
+	int ret;
+
+	for_each_child_of_node(regions, child) {
+		region = devm_kzalloc(dev, sizeof(*region), GFP_KERNEL);
+		if (!region) {
+			dev_err(dev, "out of memory allocating region\n");
+			return -ENOMEM;
+		}
+
+		region->name = knav_queue_find_name(child);
+		of_property_read_u32(child, "id", &region->id);
+		ret = of_property_read_u32_array(child, "region-spec", temp, 2);
+		if (!ret) {
+			region->num_desc  = temp[0];
+			region->desc_size = temp[1];
+		} else {
+			dev_err(dev, "invalid region info %s\n", region->name);
+			devm_kfree(dev, region);
+			continue;
+		}
+
+		if (!of_get_property(child, "link-index", NULL)) {
+			dev_err(dev, "No link info for %s\n", region->name);
+			devm_kfree(dev, region);
+			continue;
+		}
+		ret = of_property_read_u32(child, "link-index",
+					   &region->link_index);
+		if (ret) {
+			dev_err(dev, "link index not found for %s\n",
+				region->name);
+			devm_kfree(dev, region);
+			continue;
+		}
+
+		INIT_LIST_HEAD(&region->pools);
+		list_add_tail(&region->list, &kdev->regions);
+	}
+	if (list_empty(&kdev->regions)) {
+		dev_err(dev, "no valid region information found\n");
+		return -ENODEV;
+	}
+
+	/* Next, we run through the regions and set things up */
+	for_each_region(kdev, region)
+		knav_queue_setup_region(kdev, region);
+
+	return 0;
+}
+
+static int knav_get_link_ram(struct knav_device *kdev,
+				       const char *name,
+				       struct knav_link_ram_block *block)
+{
+	struct platform_device *pdev = to_platform_device(kdev->dev);
+	struct device_node *node = pdev->dev.of_node;
+	u32 temp[2];
+
+	/*
+	 * Note: link ram resources are specified in "entry" sized units. In
+	 * reality, although entries are ~40bits in hardware, we treat them as
+	 * 64-bit entities here.
+	 *
+	 * For example, to specify the internal link ram for Keystone-I class
+	 * devices, we would set the linkram0 resource to 0x80000-0x83fff.
+	 *
+	 * This gets a bit weird when other link rams are used.  For example,
+	 * if the range specified is 0x0c000000-0x0c003fff (i.e., 16K entries
+	 * in MSMC SRAM), the actual memory used is 0x0c000000-0x0c020000,
+	 * which accounts for 64-bits per entry, for 16K entries.
+	 */
+	if (!of_property_read_u32_array(node, name , temp, 2)) {
+		if (temp[0]) {
+			/*
+			 * queue_base specified => using internal or onchip
+			 * link ram WARNING - we do not "reserve" this block
+			 */
+			block->phys = (dma_addr_t)temp[0];
+			block->virt = NULL;
+			block->size = temp[1];
+		} else {
+			block->size = temp[1];
+			/* queue_base not specific => allocate requested size */
+			block->virt = dmam_alloc_coherent(kdev->dev,
+						  8 * block->size, &block->phys,
+						  GFP_KERNEL);
+			if (!block->virt) {
+				dev_err(kdev->dev, "failed to alloc linkram\n");
+				return -ENOMEM;
+			}
+		}
+	} else {
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int knav_queue_setup_link_ram(struct knav_device *kdev)
+{
+	struct knav_link_ram_block *block;
+	struct knav_qmgr_info *qmgr;
+
+	for_each_qmgr(kdev, qmgr) {
+		block = &kdev->link_rams[0];
+		dev_dbg(kdev->dev, "linkram0: phys:%x, virt:%p, size:%x\n",
+			block->phys, block->virt, block->size);
+		writel_relaxed(block->phys, &qmgr->reg_config->link_ram_base0);
+		writel_relaxed(block->size, &qmgr->reg_config->link_ram_size0);
+
+		block++;
+		if (!block->size)
+			return 0;
+
+		dev_dbg(kdev->dev, "linkram1: phys:%x, virt:%p, size:%x\n",
+			block->phys, block->virt, block->size);
+		writel_relaxed(block->phys, &qmgr->reg_config->link_ram_base1);
+	}
+
+	return 0;
+}
+
+static int knav_setup_queue_range(struct knav_device *kdev,
+					struct device_node *node)
+{
+	struct device *dev = kdev->dev;
+	struct knav_range_info *range;
+	struct knav_qmgr_info *qmgr;
+	u32 temp[2], start, end, id, index;
+	int ret, i;
+
+	range = devm_kzalloc(dev, sizeof(*range), GFP_KERNEL);
+	if (!range) {
+		dev_err(dev, "out of memory allocating range\n");
+		return -ENOMEM;
+	}
+
+	range->kdev = kdev;
+	range->name = knav_queue_find_name(node);
+	ret = of_property_read_u32_array(node, "qrange", temp, 2);
+	if (!ret) {
+		range->queue_base = temp[0] - kdev->base_id;
+		range->num_queues = temp[1];
+	} else {
+		dev_err(dev, "invalid queue range %s\n", range->name);
+		devm_kfree(dev, range);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < RANGE_MAX_IRQS; i++) {
+		struct of_phandle_args oirq;
+
+		if (of_irq_parse_one(node, i, &oirq))
+			break;
+
+		range->irqs[i].irq = irq_create_of_mapping(&oirq);
+		if (range->irqs[i].irq == IRQ_NONE)
+			break;
+
+		range->num_irqs++;
+
+		if (oirq.args_count == 3)
+			range->irqs[i].cpu_map =
+				(oirq.args[2] & 0x0000ff00) >> 8;
+	}
+
+	range->num_irqs = min(range->num_irqs, range->num_queues);
+	if (range->num_irqs)
+		range->flags |= RANGE_HAS_IRQ;
+
+	if (of_get_property(node, "qalloc-by-id", NULL))
+		range->flags |= RANGE_RESERVED;
+
+	if (of_get_property(node, "accumulator", NULL)) {
+		ret = knav_init_acc_range(kdev, node, range);
+		if (ret < 0) {
+			devm_kfree(dev, range);
+			return ret;
+		}
+	} else {
+		range->ops = &knav_gp_range_ops;
+	}
+
+	/* set threshold to 1, and flush out the queues */
+	for_each_qmgr(kdev, qmgr) {
+		start = max(qmgr->start_queue, range->queue_base);
+		end   = min(qmgr->start_queue + qmgr->num_queues,
+			    range->queue_base + range->num_queues);
+		for (id = start; id < end; id++) {
+			index = id - qmgr->start_queue;
+			writel_relaxed(THRESH_GTE | 1,
+				       &qmgr->reg_peek[index].ptr_size_thresh);
+			writel_relaxed(0,
+				       &qmgr->reg_push[index].ptr_size_thresh);
+		}
+	}
+
+	list_add_tail(&range->list, &kdev->queue_ranges);
+	dev_dbg(dev, "added range %s: %d-%d, %d irqs%s%s%s\n",
+		range->name, range->queue_base,
+		range->queue_base + range->num_queues - 1,
+		range->num_irqs,
+		(range->flags & RANGE_HAS_IRQ) ? ", has irq" : "",
+		(range->flags & RANGE_RESERVED) ? ", reserved" : "",
+		(range->flags & RANGE_HAS_ACCUMULATOR) ? ", acc" : "");
+	kdev->num_queues_in_use += range->num_queues;
+	return 0;
+}
+
+static int knav_setup_queue_pools(struct knav_device *kdev,
+				   struct device_node *queue_pools)
+{
+	struct device_node *type, *range;
+	int ret;
+
+	for_each_child_of_node(queue_pools, type) {
+		for_each_child_of_node(type, range) {
+			ret = knav_setup_queue_range(kdev, range);
+			/* return value ignored, we init the rest... */
+		}
+	}
+
+	/* ... and barf if they all failed! */
+	if (list_empty(&kdev->queue_ranges)) {
+		dev_err(kdev->dev, "no valid queue range found\n");
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static void knav_free_queue_range(struct knav_device *kdev,
+				  struct knav_range_info *range)
+{
+	if (range->ops && range->ops->free_range)
+		range->ops->free_range(range);
+	list_del(&range->list);
+	devm_kfree(kdev->dev, range);
+}
+
+static void knav_free_queue_ranges(struct knav_device *kdev)
+{
+	struct knav_range_info *range;
+
+	for (;;) {
+		range = first_queue_range(kdev);
+		if (!range)
+			break;
+		knav_free_queue_range(kdev, range);
+	}
+}
+
+static void knav_queue_free_regions(struct knav_device *kdev)
+{
+	struct knav_region *region;
+	struct knav_pool *pool;
+	unsigned size;
+
+	for (;;) {
+		region = first_region(kdev);
+		if (!region)
+			break;
+		list_for_each_entry(pool, &region->pools, region_inst)
+			knav_pool_destroy(pool);
+
+		size = region->virt_end - region->virt_start;
+		if (size)
+			free_pages_exact(region->virt_start, size);
+		list_del(&region->list);
+		devm_kfree(kdev->dev, region);
+	}
+}
+
+static void __iomem *knav_queue_map_reg(struct knav_device *kdev,
+					struct device_node *node, int index)
+{
+	struct resource res;
+	void __iomem *regs;
+	int ret;
+
+	ret = of_address_to_resource(node, index, &res);
+	if (ret) {
+		dev_err(kdev->dev, "Can't translate of node(%s) address for index(%d)\n",
+			node->name, index);
+		return ERR_PTR(ret);
+	}
+
+	regs = devm_ioremap_resource(kdev->dev, &res);
+	if (IS_ERR(regs))
+		dev_err(kdev->dev, "Failed to map register base for index(%d) node(%s)\n",
+			index, node->name);
+	return regs;
+}
+
+static int knav_queue_init_qmgrs(struct knav_device *kdev,
+					struct device_node *qmgrs)
+{
+	struct device *dev = kdev->dev;
+	struct knav_qmgr_info *qmgr;
+	struct device_node *child;
+	u32 temp[2];
+	int ret;
+
+	for_each_child_of_node(qmgrs, child) {
+		qmgr = devm_kzalloc(dev, sizeof(*qmgr), GFP_KERNEL);
+		if (!qmgr) {
+			dev_err(dev, "out of memory allocating qmgr\n");
+			return -ENOMEM;
+		}
+
+		ret = of_property_read_u32_array(child, "managed-queues",
+						 temp, 2);
+		if (!ret) {
+			qmgr->start_queue = temp[0];
+			qmgr->num_queues = temp[1];
+		} else {
+			dev_err(dev, "invalid qmgr queue range\n");
+			devm_kfree(dev, qmgr);
+			continue;
+		}
+
+		dev_info(dev, "qmgr start queue %d, number of queues %d\n",
+			 qmgr->start_queue, qmgr->num_queues);
+
+		qmgr->reg_peek =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_PEEK_REG_INDEX);
+		qmgr->reg_status =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_STATUS_REG_INDEX);
+		qmgr->reg_config =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_CONFIG_REG_INDEX);
+		qmgr->reg_region =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_REGION_REG_INDEX);
+		qmgr->reg_push =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_PUSH_REG_INDEX);
+		qmgr->reg_pop =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_POP_REG_INDEX);
+
+		if (IS_ERR(qmgr->reg_peek) || IS_ERR(qmgr->reg_status) ||
+		    IS_ERR(qmgr->reg_config) || IS_ERR(qmgr->reg_region) ||
+		    IS_ERR(qmgr->reg_push) || IS_ERR(qmgr->reg_pop)) {
+			dev_err(dev, "failed to map qmgr regs\n");
+			if (!IS_ERR(qmgr->reg_peek))
+				devm_iounmap(dev, qmgr->reg_peek);
+			if (!IS_ERR(qmgr->reg_status))
+				devm_iounmap(dev, qmgr->reg_status);
+			if (!IS_ERR(qmgr->reg_config))
+				devm_iounmap(dev, qmgr->reg_config);
+			if (!IS_ERR(qmgr->reg_region))
+				devm_iounmap(dev, qmgr->reg_region);
+			if (!IS_ERR(qmgr->reg_push))
+				devm_iounmap(dev, qmgr->reg_push);
+			if (!IS_ERR(qmgr->reg_pop))
+				devm_iounmap(dev, qmgr->reg_pop);
+			devm_kfree(dev, qmgr);
+			continue;
+		}
+
+		list_add_tail(&qmgr->list, &kdev->qmgrs);
+		dev_info(dev, "added qmgr start queue %d, num of queues %d, reg_peek %p, reg_status %p, reg_config %p, reg_region %p, reg_push %p, reg_pop %p\n",
+			 qmgr->start_queue, qmgr->num_queues,
+			 qmgr->reg_peek, qmgr->reg_status,
+			 qmgr->reg_config, qmgr->reg_region,
+			 qmgr->reg_push, qmgr->reg_pop);
+	}
+	return 0;
+}
+
+static int knav_queue_init_pdsps(struct knav_device *kdev,
+					struct device_node *pdsps)
+{
+	struct device *dev = kdev->dev;
+	struct knav_pdsp_info *pdsp;
+	struct device_node *child;
+	int ret;
+
+	for_each_child_of_node(pdsps, child) {
+		pdsp = devm_kzalloc(dev, sizeof(*pdsp), GFP_KERNEL);
+		if (!pdsp) {
+			dev_err(dev, "out of memory allocating pdsp\n");
+			return -ENOMEM;
+		}
+		pdsp->name = knav_queue_find_name(child);
+		ret = of_property_read_string(child, "firmware",
+					      &pdsp->firmware);
+		if (ret < 0 || !pdsp->firmware) {
+			dev_err(dev, "unknown firmware for pdsp %s\n",
+				pdsp->name);
+			devm_kfree(dev, pdsp);
+			continue;
+		}
+		dev_dbg(dev, "pdsp name %s fw name :%s\n", pdsp->name,
+			pdsp->firmware);
+
+		pdsp->iram =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_PDSP_IRAM_REG_INDEX);
+		pdsp->regs =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_PDSP_REGS_REG_INDEX);
+		pdsp->intd =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_PDSP_INTD_REG_INDEX);
+		pdsp->command =
+			knav_queue_map_reg(kdev, child,
+					   KNAV_QUEUE_PDSP_CMD_REG_INDEX);
+
+		if (IS_ERR(pdsp->command) || IS_ERR(pdsp->iram) ||
+		    IS_ERR(pdsp->regs) || IS_ERR(pdsp->intd)) {
+			dev_err(dev, "failed to map pdsp %s regs\n",
+				pdsp->name);
+			if (!IS_ERR(pdsp->command))
+				devm_iounmap(dev, pdsp->command);
+			if (!IS_ERR(pdsp->iram))
+				devm_iounmap(dev, pdsp->iram);
+			if (!IS_ERR(pdsp->regs))
+				devm_iounmap(dev, pdsp->regs);
+			if (!IS_ERR(pdsp->intd))
+				devm_iounmap(dev, pdsp->intd);
+			devm_kfree(dev, pdsp);
+			continue;
+		}
+		of_property_read_u32(child, "id", &pdsp->id);
+		list_add_tail(&pdsp->list, &kdev->pdsps);
+		dev_dbg(dev, "added pdsp %s: command %p, iram %p, regs %p, intd %p, firmware %s\n",
+			pdsp->name, pdsp->command, pdsp->iram, pdsp->regs,
+			pdsp->intd, pdsp->firmware);
+	}
+	return 0;
+}
+
+static int knav_queue_stop_pdsp(struct knav_device *kdev,
+			  struct knav_pdsp_info *pdsp)
+{
+	u32 val, timeout = 1000;
+	int ret;
+
+	val = readl_relaxed(&pdsp->regs->control) & ~PDSP_CTRL_ENABLE;
+	writel_relaxed(val, &pdsp->regs->control);
+	ret = knav_queue_pdsp_wait(&pdsp->regs->control, timeout,
+					PDSP_CTRL_RUNNING);
+	if (ret < 0) {
+		dev_err(kdev->dev, "timed out on pdsp %s stop\n", pdsp->name);
+		return ret;
+	}
+	return 0;
+}
+
+static int knav_queue_load_pdsp(struct knav_device *kdev,
+			  struct knav_pdsp_info *pdsp)
+{
+	int i, ret, fwlen;
+	const struct firmware *fw;
+	u32 *fwdata;
+
+	ret = request_firmware(&fw, pdsp->firmware, kdev->dev);
+	if (ret) {
+		dev_err(kdev->dev, "failed to get firmware %s for pdsp %s\n",
+			pdsp->firmware, pdsp->name);
+		return ret;
+	}
+	writel_relaxed(pdsp->id + 1, pdsp->command + 0x18);
+	/* download the firmware */
+	fwdata = (u32 *)fw->data;
+	fwlen = (fw->size + sizeof(u32) - 1) / sizeof(u32);
+	for (i = 0; i < fwlen; i++)
+		writel_relaxed(be32_to_cpu(fwdata[i]), pdsp->iram + i);
+
+	release_firmware(fw);
+	return 0;
+}
+
+static int knav_queue_start_pdsp(struct knav_device *kdev,
+			   struct knav_pdsp_info *pdsp)
+{
+	u32 val, timeout = 1000;
+	int ret;
+
+	/* write a command for sync */
+	writel_relaxed(0xffffffff, pdsp->command);
+	while (readl_relaxed(pdsp->command) != 0xffffffff)
+		cpu_relax();
+
+	/* soft reset the PDSP */
+	val  = readl_relaxed(&pdsp->regs->control);
+	val &= ~(PDSP_CTRL_PC_MASK | PDSP_CTRL_SOFT_RESET);
+	writel_relaxed(val, &pdsp->regs->control);
+
+	/* enable pdsp */
+	val = readl_relaxed(&pdsp->regs->control) | PDSP_CTRL_ENABLE;
+	writel_relaxed(val, &pdsp->regs->control);
+
+	/* wait for command register to clear */
+	ret = knav_queue_pdsp_wait(pdsp->command, timeout, 0);
+	if (ret < 0) {
+		dev_err(kdev->dev,
+			"timed out on pdsp %s command register wait\n",
+			pdsp->name);
+		return ret;
+	}
+	return 0;
+}
+
+static void knav_queue_stop_pdsps(struct knav_device *kdev)
+{
+	struct knav_pdsp_info *pdsp;
+
+	/* disable all pdsps */
+	for_each_pdsp(kdev, pdsp)
+		knav_queue_stop_pdsp(kdev, pdsp);
+}
+
+static int knav_queue_start_pdsps(struct knav_device *kdev)
+{
+	struct knav_pdsp_info *pdsp;
+	int ret;
+
+	knav_queue_stop_pdsps(kdev);
+	/* now load them all */
+	for_each_pdsp(kdev, pdsp) {
+		ret = knav_queue_load_pdsp(kdev, pdsp);
+		if (ret < 0)
+			return ret;
+	}
+
+	for_each_pdsp(kdev, pdsp) {
+		ret = knav_queue_start_pdsp(kdev, pdsp);
+		WARN_ON(ret);
+	}
+	return 0;
+}
+
+static inline struct knav_qmgr_info *knav_find_qmgr(unsigned id)
+{
+	struct knav_qmgr_info *qmgr;
+
+	for_each_qmgr(kdev, qmgr) {
+		if ((id >= qmgr->start_queue) &&
+		    (id < qmgr->start_queue + qmgr->num_queues))
+			return qmgr;
+	}
+	return NULL;
+}
+
+static int knav_queue_init_queue(struct knav_device *kdev,
+					struct knav_range_info *range,
+					struct knav_queue_inst *inst,
+					unsigned id)
+{
+	char irq_name[KNAV_NAME_SIZE];
+	inst->qmgr = knav_find_qmgr(id);
+	if (!inst->qmgr)
+		return -1;
+
+	INIT_LIST_HEAD(&inst->handles);
+	inst->kdev = kdev;
+	inst->range = range;
+	inst->irq_num = -1;
+	inst->id = id;
+	scnprintf(irq_name, sizeof(irq_name), "hwqueue-%d", id);
+	inst->irq_name = kstrndup(irq_name, sizeof(irq_name), GFP_KERNEL);
+
+	if (range->ops && range->ops->init_queue)
+		return range->ops->init_queue(range, inst);
+	else
+		return 0;
+}
+
+static int knav_queue_init_queues(struct knav_device *kdev)
+{
+	struct knav_range_info *range;
+	int size, id, base_idx;
+	int idx = 0, ret = 0;
+
+	/* how much do we need for instance data? */
+	size = sizeof(struct knav_queue_inst);
+
+	/* round this up to a power of 2, keep the index to instance
+	 * arithmetic fast.
+	 * */
+	kdev->inst_shift = order_base_2(size);
+	size = (1 << kdev->inst_shift) * kdev->num_queues_in_use;
+	kdev->instances = devm_kzalloc(kdev->dev, size, GFP_KERNEL);
+	if (!kdev->instances)
+		return -1;
+
+	for_each_queue_range(kdev, range) {
+		if (range->ops && range->ops->init_range)
+			range->ops->init_range(range);
+		base_idx = idx;
+		for (id = range->queue_base;
+		     id < range->queue_base + range->num_queues; id++, idx++) {
+			ret = knav_queue_init_queue(kdev, range,
+					knav_queue_idx_to_inst(kdev, idx), id);
+			if (ret < 0)
+				return ret;
+		}
+		range->queue_base_inst =
+			knav_queue_idx_to_inst(kdev, base_idx);
+	}
+	return 0;
+}
+
+static int knav_queue_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct device_node *qmgrs, *queue_pools, *regions, *pdsps;
+	struct device *dev = &pdev->dev;
+	u32 temp[2];
+	int ret;
+
+	if (!node) {
+		dev_err(dev, "device tree info unavailable\n");
+		return -ENODEV;
+	}
+
+	kdev = devm_kzalloc(dev, sizeof(struct knav_device), GFP_KERNEL);
+	if (!kdev) {
+		dev_err(dev, "memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	platform_set_drvdata(pdev, kdev);
+	kdev->dev = dev;
+	INIT_LIST_HEAD(&kdev->queue_ranges);
+	INIT_LIST_HEAD(&kdev->qmgrs);
+	INIT_LIST_HEAD(&kdev->pools);
+	INIT_LIST_HEAD(&kdev->regions);
+	INIT_LIST_HEAD(&kdev->pdsps);
+
+	pm_runtime_enable(&pdev->dev);
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if (ret < 0) {
+		dev_err(dev, "Failed to enable QMSS\n");
+		return ret;
+	}
+
+	if (of_property_read_u32_array(node, "queue-range", temp, 2)) {
+		dev_err(dev, "queue-range not specified\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	kdev->base_id    = temp[0];
+	kdev->num_queues = temp[1];
+
+	/* Initialize queue managers using device tree configuration */
+	qmgrs =  of_get_child_by_name(node, "qmgrs");
+	if (!qmgrs) {
+		dev_err(dev, "queue manager info not specified\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	ret = knav_queue_init_qmgrs(kdev, qmgrs);
+	of_node_put(qmgrs);
+	if (ret)
+		goto err;
+
+	/* get pdsp configuration values from device tree */
+	pdsps =  of_get_child_by_name(node, "pdsps");
+	if (pdsps) {
+		ret = knav_queue_init_pdsps(kdev, pdsps);
+		if (ret)
+			goto err;
+
+		ret = knav_queue_start_pdsps(kdev);
+		if (ret)
+			goto err;
+	}
+	of_node_put(pdsps);
+
+	/* get usable queue range values from device tree */
+	queue_pools = of_get_child_by_name(node, "queue-pools");
+	if (!queue_pools) {
+		dev_err(dev, "queue-pools not specified\n");
+		ret = -ENODEV;
+		goto err;
+	}
+	ret = knav_setup_queue_pools(kdev, queue_pools);
+	of_node_put(queue_pools);
+	if (ret)
+		goto err;
+
+	ret = knav_get_link_ram(kdev, "linkram0", &kdev->link_rams[0]);
+	if (ret) {
+		dev_err(kdev->dev, "could not setup linking ram\n");
+		goto err;
+	}
+
+	ret = knav_get_link_ram(kdev, "linkram1", &kdev->link_rams[1]);
+	if (ret) {
+		/*
+		 * nothing really, we have one linking ram already, so we just
+		 * live within our means
+		 */
+	}
+
+	ret = knav_queue_setup_link_ram(kdev);
+	if (ret)
+		goto err;
+
+	regions =  of_get_child_by_name(node, "descriptor-regions");
+	if (!regions) {
+		dev_err(dev, "descriptor-regions not specified\n");
+		goto err;
+	}
+	ret = knav_queue_setup_regions(kdev, regions);
+	of_node_put(regions);
+	if (ret)
+		goto err;
+
+	ret = knav_queue_init_queues(kdev);
+	if (ret < 0) {
+		dev_err(dev, "hwqueue initialization failed\n");
+		goto err;
+	}
+
+	debugfs_create_file("qmss", S_IFREG | S_IRUGO, NULL, NULL,
+			    &knav_queue_debug_ops);
+	return 0;
+
+err:
+	knav_queue_stop_pdsps(kdev);
+	knav_queue_free_regions(kdev);
+	knav_free_queue_ranges(kdev);
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	return ret;
+}
+
+static int knav_queue_remove(struct platform_device *pdev)
+{
+	/* TODO: Free resources */
+	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	return 0;
+}
+
+/* Match table for of_platform binding */
+static struct of_device_id keystone_qmss_of_match[] = {
+	{ .compatible = "ti,keystone-navigator-qmss", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, keystone_qmss_of_match);
+
+static struct platform_driver keystone_qmss_driver = {
+	.probe		= knav_queue_probe,
+	.remove		= knav_queue_remove,
+	.driver		= {
+		.name	= "keystone-navigator-qmss",
+		.owner	= THIS_MODULE,
+		.of_match_table = keystone_qmss_of_match,
+	},
+};
+module_platform_driver(keystone_qmss_driver);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("TI QMSS driver for Keystone SOCs");
diff --git a/include/linux/soc/ti/knav_qmss.h b/include/linux/soc/ti/knav_qmss.h
new file mode 100644
index 0000000..9f0ebb3b
--- /dev/null
+++ b/include/linux/soc/ti/knav_qmss.h
@@ -0,0 +1,90 @@
+/*
+ * Keystone Navigator Queue Management Sub-System header
+ *
+ * Copyright (C) 2014 Texas Instruments Incorporated - http://www.ti.com
+ * Author:	Sandeep Nair <sandeep_n@ti.com>
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
+#ifndef __SOC_TI_KNAV_QMSS_H__
+#define __SOC_TI_KNAV_QMSS_H__
+
+#include <linux/err.h>
+#include <linux/time.h>
+#include <linux/atomic.h>
+#include <linux/device.h>
+#include <linux/fcntl.h>
+#include <linux/dma-mapping.h>
+
+/* queue types */
+#define KNAV_QUEUE_QPEND	((unsigned)-2) /* interruptible qpend queue */
+#define KNAV_QUEUE_ACC		((unsigned)-3) /* Accumulated queue */
+#define KNAV_QUEUE_GP		((unsigned)-4) /* General purpose queue */
+
+/* queue flags */
+#define KNAV_QUEUE_SHARED	0x0001		/* Queue can be shared */
+
+/**
+ * enum knav_queue_ctrl_cmd -	queue operations.
+ * @KNAV_QUEUE_GET_ID:		Get the ID number for an open queue
+ * @KNAV_QUEUE_FLUSH:		forcibly empty a queue if possible
+ * @KNAV_QUEUE_SET_NOTIFIER:	Set a notifier callback to a queue handle.
+ * @KNAV_QUEUE_ENABLE_NOTIFY:	Enable notifier callback for a queue handle.
+ * @KNAV_QUEUE_DISABLE_NOTIFY:	Disable notifier callback for a queue handle.
+ * @KNAV_QUEUE_GET_COUNT:	Get number of queues.
+ */
+enum knav_queue_ctrl_cmd {
+	KNAV_QUEUE_GET_ID,
+	KNAV_QUEUE_FLUSH,
+	KNAV_QUEUE_SET_NOTIFIER,
+	KNAV_QUEUE_ENABLE_NOTIFY,
+	KNAV_QUEUE_DISABLE_NOTIFY,
+	KNAV_QUEUE_GET_COUNT
+};
+
+/* Queue notifier callback prototype */
+typedef void (*knav_queue_notify_fn)(void *arg);
+
+/**
+ * struct knav_queue_notify_config:	Notifier configuration
+ * @fn:					Notifier function
+ * @fn_arg:				Notifier function arguments
+ */
+struct knav_queue_notify_config {
+	knav_queue_notify_fn fn;
+	void *fn_arg;
+};
+
+void *knav_queue_open(const char *name, unsigned id,
+					unsigned flags);
+void knav_queue_close(void *qhandle);
+int knav_queue_device_control(void *qhandle,
+				enum knav_queue_ctrl_cmd cmd,
+				unsigned long arg);
+dma_addr_t knav_queue_pop(void *qhandle, unsigned *size);
+int knav_queue_push(void *qhandle, dma_addr_t dma,
+				unsigned size, unsigned flags);
+
+void *knav_pool_create(const char *name,
+				int num_desc, int region_id);
+void knav_pool_destroy(void *ph);
+int knav_pool_count(void *ph);
+void *knav_pool_desc_get(void *ph);
+void knav_pool_desc_put(void *ph, void *desc);
+int knav_pool_desc_map(void *ph, void *desc, unsigned size,
+					dma_addr_t *dma, unsigned *dma_sz);
+void *knav_pool_desc_unmap(void *ph, dma_addr_t dma, unsigned dma_sz);
+dma_addr_t knav_pool_desc_virt_to_dma(void *ph, void *virt);
+void *knav_pool_desc_dma_to_virt(void *ph, dma_addr_t dma);
+
+#endif /* __SOC_TI_KNAV_QMSS_H__ */
-- 
1.7.9.5

