Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3CMMiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 08:38:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11463 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab3CMMfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 08:35:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 05:35:46 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv7 03/10] gpu: host1x: Add syncpoint wait and interrupts
Date: Wed, 13 Mar 2013 14:36:19 +0200
Message-ID: <1363178186-2017-4-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
References: <1363178186-2017-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for sync point interrupts, and sync point wait. Sync
point wait used interrupts for unblocking wait.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile              |    1 +
 drivers/gpu/host1x/dev.c                 |   12 ++
 drivers/gpu/host1x/dev.h                 |   51 +++++
 drivers/gpu/host1x/hw/host1x01.c         |    2 +
 drivers/gpu/host1x/hw/hw_host1x01_sync.h |   42 ++++
 drivers/gpu/host1x/hw/intr_hw.c          |  143 +++++++++++++
 drivers/gpu/host1x/intr.c                |  328 ++++++++++++++++++++++++++++++
 drivers/gpu/host1x/intr.h                |   96 +++++++++
 drivers/gpu/host1x/syncpt.c              |  159 +++++++++++++++
 drivers/gpu/host1x/syncpt.h              |   14 +-
 10 files changed, 847 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/host1x/hw/intr_hw.c
 create mode 100644 drivers/gpu/host1x/intr.c
 create mode 100644 drivers/gpu/host1x/intr.h

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 363e6ab..5ef47ff 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -3,6 +3,7 @@ ccflags-y = -Idrivers/gpu/host1x
 host1x-y = \
 	syncpt.o \
 	dev.o \
+	intr.o \
 	hw/host1x01.o
 
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index d95a9b2..4421e28 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -28,6 +28,7 @@
 #include <trace/events/host1x.h>
 
 #include "dev.h"
+#include "intr.h"
 #include "hw/host1x01.h"
 
 void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
@@ -127,12 +128,23 @@ static int host1x_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	err = host1x_intr_init(host, syncpt_irq);
+	if (err) {
+		dev_err(dev, "failed to init irq");
+		goto fail_deinit_syncpt;
+	}
+
 	return 0;
+
+fail_deinit_syncpt:
+	host1x_syncpt_deinit(host);
+	return err;
 }
 
 static int __exit host1x_remove(struct platform_device *pdev)
 {
 	struct host1x *host = platform_get_drvdata(pdev);
+	host1x_intr_deinit(host);
 	host1x_syncpt_deinit(host);
 	clk_disable_unprepare(host->clk);
 	return 0;
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 750daa3..fb5f842 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -21,6 +21,7 @@
 #include <linux/device.h>
 
 #include "syncpt.h"
+#include "intr.h"
 
 struct host1x_syncpt;
 
@@ -33,6 +34,17 @@ struct host1x_syncpt_ops {
 	int (*patch_wait)(struct host1x_syncpt *syncpt, void *patch_addr);
 };
 
+struct host1x_intr_ops {
+	int (*init_host_sync)(struct host1x *host, u32 cpm,
+		void (*syncpt_thresh_work)(struct work_struct *work));
+	void (*set_syncpt_threshold)(
+		struct host1x *host, u32 id, u32 thresh);
+	void (*enable_syncpt_intr)(struct host1x *host, u32 id);
+	void (*disable_syncpt_intr)(struct host1x *host, u32 id);
+	void (*disable_all_syncpt_intrs)(struct host1x *host);
+	int (*free_syncpt_irq)(struct host1x *host);
+};
+
 struct host1x_info {
 	int	nb_channels;		/* host1x: num channels supported */
 	int	nb_pts;			/* host1x: num syncpoints supported */
@@ -50,7 +62,13 @@ struct host1x {
 	struct device *dev;
 	struct clk *clk;
 
+	struct mutex intr_mutex;
+	struct workqueue_struct *intr_wq;
+	int intr_syncpt_irq;
+
 	const struct host1x_syncpt_ops *syncpt_op;
+	const struct host1x_intr_ops *intr_op;
+
 };
 
 static inline struct host1x *host1x_get_host(struct device *dev)
@@ -101,4 +119,37 @@ static inline int host1x_hw_syncpt_patch_wait(struct host1x *host,
 	return host->syncpt_op->patch_wait(sp, patch_addr);
 }
 
+static inline int host1x_hw_intr_init_host_sync(struct host1x *host, u32 cpm,
+			void (*syncpt_thresh_work)(struct work_struct *))
+{
+	return host->intr_op->init_host_sync(host, cpm, syncpt_thresh_work);
+}
+
+static inline void host1x_hw_intr_set_syncpt_threshold(struct host1x *host,
+						       u32 id, u32 thresh)
+{
+	host->intr_op->set_syncpt_threshold(host, id, thresh);
+}
+
+static inline void host1x_hw_intr_enable_syncpt_intr(struct host1x *host,
+						     u32 id)
+{
+	host->intr_op->enable_syncpt_intr(host, id);
+}
+
+static inline void host1x_hw_intr_disable_syncpt_intr(struct host1x *host,
+						      u32 id)
+{
+	host->intr_op->disable_syncpt_intr(host, id);
+}
+
+static inline void host1x_hw_intr_disable_all_syncpt_intrs(struct host1x *host)
+{
+	host->intr_op->disable_all_syncpt_intrs(host);
+}
+
+static inline int host1x_hw_intr_free_syncpt_irq(struct host1x *host)
+{
+	return host->intr_op->free_syncpt_irq(host);
+}
 #endif
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
index 612b457..f5c35fa 100644
--- a/drivers/gpu/host1x/hw/host1x01.c
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -21,6 +21,7 @@
 #include "hw/host1x01_hardware.h"
 
 /* include code */
+#include "hw/intr_hw.c"
 #include "hw/syncpt_hw.c"
 
 #include "dev.h"
@@ -28,6 +29,7 @@
 int host1x01_init(struct host1x *host)
 {
 	host->syncpt_op = &host1x_syncpt_ops;
+	host->intr_op = &host1x_intr_ops;
 
 	return 0;
 }
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
index 3af258b..eea0bb0 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_sync.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -59,6 +59,48 @@ static inline u32 host1x_sync_syncpt_r(unsigned int id)
 }
 #define HOST1X_SYNC_SYNCPT(id) \
 	host1x_sync_syncpt_r(id)
+static inline u32 host1x_sync_syncpt_thresh_cpu0_int_status_r(unsigned int id)
+{
+	return 0x40 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(id) \
+	host1x_sync_syncpt_thresh_cpu0_int_status_r(id)
+static inline u32 host1x_sync_syncpt_thresh_int_disable_r(unsigned int id)
+{
+	return 0x60 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE(id) \
+	host1x_sync_syncpt_thresh_int_disable_r(id)
+static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(unsigned int id)
+{
+	return 0x68 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0(id) \
+	host1x_sync_syncpt_thresh_int_enable_cpu0_r(id)
+static inline u32 host1x_sync_usec_clk_r(void)
+{
+	return 0x1a4;
+}
+#define HOST1X_SYNC_USEC_CLK \
+	host1x_sync_usec_clk_r()
+static inline u32 host1x_sync_ctxsw_timeout_cfg_r(void)
+{
+	return 0x1a8;
+}
+#define HOST1X_SYNC_CTXSW_TIMEOUT_CFG \
+	host1x_sync_ctxsw_timeout_cfg_r()
+static inline u32 host1x_sync_ip_busy_timeout_r(void)
+{
+	return 0x1bc;
+}
+#define HOST1X_SYNC_IP_BUSY_TIMEOUT \
+	host1x_sync_ip_busy_timeout_r()
+static inline u32 host1x_sync_syncpt_int_thresh_r(unsigned int id)
+{
+	return 0x500 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_SYNCPT_INT_THRESH(id) \
+	host1x_sync_syncpt_int_thresh_r(id)
 static inline u32 host1x_sync_syncpt_base_r(unsigned int id)
 {
 	return 0x600 + id * REGISTER_STRIDE;
diff --git a/drivers/gpu/host1x/hw/intr_hw.c b/drivers/gpu/host1x/hw/intr_hw.c
new file mode 100644
index 0000000..b592eef
--- /dev/null
+++ b/drivers/gpu/host1x/hw/intr_hw.c
@@ -0,0 +1,143 @@
+/*
+ * Tegra host1x Interrupt Management
+ *
+ * Copyright (C) 2010 Google, Inc.
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/irq.h>
+#include <linux/io.h>
+#include <asm/mach/irq.h>
+
+#include "intr.h"
+#include "dev.h"
+
+/*
+ * Sync point threshold interrupt service function
+ * Handles sync point threshold triggers, in interrupt context
+ */
+static void host1x_intr_syncpt_handle(struct host1x_syncpt *syncpt)
+{
+	unsigned int id = syncpt->id;
+	struct host1x *host = syncpt->host;
+
+	host1x_sync_writel(host, BIT_MASK(id),
+		HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE(BIT_WORD(id)));
+	host1x_sync_writel(host, BIT_MASK(id),
+		HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(BIT_WORD(id)));
+
+	queue_work(host->intr_wq, &syncpt->intr.work);
+}
+
+static irqreturn_t syncpt_thresh_isr(int irq, void *dev_id)
+{
+	struct host1x *host = dev_id;
+	unsigned long reg;
+	int i, id;
+
+	for (i = 0; i <= BIT_WORD(host->info->nb_pts); i++) {
+		reg = host1x_sync_readl(host,
+			HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(i));
+		for_each_set_bit(id, &reg, BITS_PER_LONG) {
+			struct host1x_syncpt *syncpt =
+				host->syncpt + (i * BITS_PER_LONG + id);
+			host1x_intr_syncpt_handle(syncpt);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void _host1x_intr_disable_all_syncpt_intrs(struct host1x *host)
+{
+	u32 i;
+
+	for (i = 0; i <= BIT_WORD(host->info->nb_pts); ++i) {
+		host1x_sync_writel(host, 0xffffffffu,
+			HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE(i));
+		host1x_sync_writel(host, 0xffffffffu,
+			HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(i));
+	}
+}
+
+static int _host1x_intr_init_host_sync(struct host1x *host, u32 cpm,
+	void (*syncpt_thresh_work)(struct work_struct *))
+{
+	int i, err;
+
+	host1x_hw_intr_disable_all_syncpt_intrs(host);
+
+	for (i = 0; i < host->info->nb_pts; i++)
+		INIT_WORK(&host->syncpt[i].intr.work, syncpt_thresh_work);
+
+	err = devm_request_irq(host->dev, host->intr_syncpt_irq,
+			       syncpt_thresh_isr, IRQF_SHARED,
+			       "host1x_syncpt", host);
+	if (IS_ERR_VALUE(err)) {
+		WARN_ON(1);
+		return err;
+	}
+
+	/* disable the ip_busy_timeout. this prevents write drops */
+	host1x_sync_writel(host, 0, HOST1X_SYNC_IP_BUSY_TIMEOUT);
+
+	/*
+	 * increase the auto-ack timout to the maximum value. 2d will hang
+	 * otherwise on Tegra2.
+	 */
+	host1x_sync_writel(host, 0xff, HOST1X_SYNC_CTXSW_TIMEOUT_CFG);
+
+	/* update host clocks per usec */
+	host1x_sync_writel(host, cpm, HOST1X_SYNC_USEC_CLK);
+
+	return 0;
+}
+
+static void _host1x_intr_set_syncpt_threshold(struct host1x *host,
+	u32 id, u32 thresh)
+{
+	host1x_sync_writel(host, thresh, HOST1X_SYNC_SYNCPT_INT_THRESH(id));
+}
+
+static void _host1x_intr_enable_syncpt_intr(struct host1x *host, u32 id)
+{
+	host1x_sync_writel(host, BIT_MASK(id),
+		HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0(BIT_WORD(id)));
+}
+
+static void _host1x_intr_disable_syncpt_intr(struct host1x *host, u32 id)
+{
+	host1x_sync_writel(host, BIT_MASK(id),
+		HOST1X_SYNC_SYNCPT_THRESH_INT_DISABLE(BIT_WORD(id)));
+	host1x_sync_writel(host, BIT_MASK(id),
+		HOST1X_SYNC_SYNCPT_THRESH_CPU0_INT_STATUS(BIT_WORD(id)));
+}
+
+static int _host1x_free_syncpt_irq(struct host1x *host)
+{
+	devm_free_irq(host->dev, host->intr_syncpt_irq, host);
+	flush_workqueue(host->intr_wq);
+	return 0;
+}
+
+static const struct host1x_intr_ops host1x_intr_ops = {
+	.init_host_sync = _host1x_intr_init_host_sync,
+	.set_syncpt_threshold = _host1x_intr_set_syncpt_threshold,
+	.enable_syncpt_intr = _host1x_intr_enable_syncpt_intr,
+	.disable_syncpt_intr = _host1x_intr_disable_syncpt_intr,
+	.disable_all_syncpt_intrs = _host1x_intr_disable_all_syncpt_intrs,
+	.free_syncpt_irq = _host1x_free_syncpt_irq,
+};
diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
new file mode 100644
index 0000000..b1b5a80
--- /dev/null
+++ b/drivers/gpu/host1x/intr.c
@@ -0,0 +1,328 @@
+/*
+ * Tegra host1x Interrupt Management
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/irq.h>
+
+#include "dev.h"
+#include "intr.h"
+
+/* Wait list management */
+
+enum waitlist_state {
+	WLS_PENDING,
+	WLS_REMOVED,
+	WLS_CANCELLED,
+	WLS_HANDLED
+};
+
+static void waiter_release(struct kref *kref)
+{
+	kfree(container_of(kref, struct host1x_waitlist, refcount));
+}
+
+/*
+ * add a waiter to a waiter queue, sorted by threshold
+ * returns true if it was added at the head of the queue
+ */
+static bool add_waiter_to_queue(struct host1x_waitlist *waiter,
+				struct list_head *queue)
+{
+	struct host1x_waitlist *pos;
+	u32 thresh = waiter->thresh;
+
+	list_for_each_entry_reverse(pos, queue, list)
+		if ((s32)(pos->thresh - thresh) <= 0) {
+			list_add(&waiter->list, &pos->list);
+			return false;
+		}
+
+	list_add(&waiter->list, queue);
+	return true;
+}
+
+/*
+ * run through a waiter queue for a single sync point ID
+ * and gather all completed waiters into lists by actions
+ */
+static void remove_completed_waiters(struct list_head *head, u32 sync,
+			struct list_head completed[HOST1X_INTR_ACTION_COUNT])
+{
+	struct list_head *dest;
+	struct host1x_waitlist *waiter, *next;
+
+	list_for_each_entry_safe(waiter, next, head, list) {
+		if ((s32)(waiter->thresh - sync) > 0)
+			break;
+
+		dest = completed + waiter->action;
+
+		/* PENDING->REMOVED or CANCELLED->HANDLED */
+		if (atomic_inc_return(&waiter->state) == WLS_HANDLED || !dest) {
+			list_del(&waiter->list);
+			kref_put(&waiter->refcount, waiter_release);
+		} else
+			list_move_tail(&waiter->list, dest);
+	}
+}
+
+static void reset_threshold_interrupt(struct host1x *host,
+				      struct list_head *head,
+				      unsigned int id)
+{
+	u32 thresh =
+		list_first_entry(head, struct host1x_waitlist, list)->thresh;
+
+	host1x_hw_intr_set_syncpt_threshold(host, id, thresh);
+	host1x_hw_intr_enable_syncpt_intr(host, id);
+}
+
+static void action_wakeup(struct host1x_waitlist *waiter)
+{
+	wait_queue_head_t *wq = waiter->data;
+	wake_up(wq);
+}
+
+static void action_wakeup_interruptible(struct host1x_waitlist *waiter)
+{
+	wait_queue_head_t *wq = waiter->data;
+	wake_up_interruptible(wq);
+}
+
+typedef void (*action_handler)(struct host1x_waitlist *waiter);
+
+static action_handler action_handlers[HOST1X_INTR_ACTION_COUNT] = {
+	action_wakeup,
+	action_wakeup_interruptible,
+};
+
+static void run_handlers(struct list_head completed[HOST1X_INTR_ACTION_COUNT])
+{
+	struct list_head *head = completed;
+	int i;
+
+	for (i = 0; i < HOST1X_INTR_ACTION_COUNT; ++i, ++head) {
+		action_handler handler = action_handlers[i];
+		struct host1x_waitlist *waiter, *next;
+
+		list_for_each_entry_safe(waiter, next, head, list) {
+			list_del(&waiter->list);
+			handler(waiter);
+			WARN_ON(atomic_xchg(&waiter->state, WLS_HANDLED) !=
+				WLS_REMOVED);
+			kref_put(&waiter->refcount, waiter_release);
+		}
+	}
+}
+
+/*
+ * Remove & handle all waiters that have completed for the given syncpt
+ */
+static int process_wait_list(struct host1x *host,
+			     struct host1x_syncpt *syncpt,
+			     u32 threshold)
+{
+	struct list_head completed[HOST1X_INTR_ACTION_COUNT];
+	unsigned int i;
+	int empty;
+
+	for (i = 0; i < HOST1X_INTR_ACTION_COUNT; ++i)
+		INIT_LIST_HEAD(completed + i);
+
+	spin_lock(&syncpt->intr.lock);
+
+	remove_completed_waiters(&syncpt->intr.wait_head, threshold,
+				 completed);
+
+	empty = list_empty(&syncpt->intr.wait_head);
+	if (empty)
+		host1x_hw_intr_disable_syncpt_intr(host, syncpt->id);
+	else
+		reset_threshold_interrupt(host, &syncpt->intr.wait_head,
+					  syncpt->id);
+
+	spin_unlock(&syncpt->intr.lock);
+
+	run_handlers(completed);
+
+	return empty;
+}
+
+/*
+ * Sync point threshold interrupt service thread function
+ * Handles sync point threshold triggers, in thread context
+ */
+
+static void syncpt_thresh_work(struct work_struct *work)
+{
+	struct host1x_syncpt_intr *syncpt_intr =
+		container_of(work, struct host1x_syncpt_intr, work);
+	struct host1x_syncpt *syncpt =
+		container_of(syncpt_intr, struct host1x_syncpt, intr);
+	unsigned int id = syncpt->id;
+	struct host1x *host = syncpt->host;
+
+	(void)process_wait_list(host, syncpt,
+				host1x_syncpt_load(host->syncpt + id));
+}
+
+int host1x_intr_add_action(struct host1x *host, u32 id, u32 thresh,
+			   enum host1x_intr_action action, void *data,
+			   struct host1x_waitlist *waiter, void **ref)
+{
+	struct host1x_syncpt *syncpt;
+	int queue_was_empty;
+
+	if (waiter == NULL) {
+		pr_warn("%s: NULL waiter\n", __func__);
+		return -EINVAL;
+	}
+
+	/* initialize a new waiter */
+	INIT_LIST_HEAD(&waiter->list);
+	kref_init(&waiter->refcount);
+	if (ref)
+		kref_get(&waiter->refcount);
+	waiter->thresh = thresh;
+	waiter->action = action;
+	atomic_set(&waiter->state, WLS_PENDING);
+	waiter->data = data;
+	waiter->count = 1;
+
+	syncpt = host->syncpt + id;
+
+	spin_lock(&syncpt->intr.lock);
+
+	queue_was_empty = list_empty(&syncpt->intr.wait_head);
+
+	if (add_waiter_to_queue(waiter, &syncpt->intr.wait_head)) {
+		/* added at head of list - new threshold value */
+		host1x_hw_intr_set_syncpt_threshold(host, id, thresh);
+
+		/* added as first waiter - enable interrupt */
+		if (queue_was_empty)
+			host1x_hw_intr_enable_syncpt_intr(host, id);
+	}
+
+	spin_unlock(&syncpt->intr.lock);
+
+	if (ref)
+		*ref = waiter;
+	return 0;
+}
+
+void host1x_intr_put_ref(struct host1x *host, u32 id, void *ref)
+{
+	struct host1x_waitlist *waiter = ref;
+	struct host1x_syncpt *syncpt;
+
+	while (atomic_cmpxchg(&waiter->state, WLS_PENDING, WLS_CANCELLED) ==
+	       WLS_REMOVED)
+		schedule();
+
+	syncpt = host->syncpt + id;
+	(void)process_wait_list(host, syncpt,
+				host1x_syncpt_load(host->syncpt + id));
+
+	kref_put(&waiter->refcount, waiter_release);
+}
+
+int host1x_intr_init(struct host1x *host, unsigned int irq_sync)
+{
+	unsigned int id;
+	u32 nb_pts = host1x_syncpt_nb_pts(host);
+
+	mutex_init(&host->intr_mutex);
+	host->intr_syncpt_irq = irq_sync;
+	host->intr_wq = create_workqueue("host_syncpt");
+	if (!host->intr_wq)
+		return -ENOMEM;
+
+	for (id = 0; id < nb_pts; ++id) {
+		struct host1x_syncpt *syncpt = host->syncpt + id;
+
+		spin_lock_init(&syncpt->intr.lock);
+		INIT_LIST_HEAD(&syncpt->intr.wait_head);
+		snprintf(syncpt->intr.thresh_irq_name,
+			 sizeof(syncpt->intr.thresh_irq_name),
+			 "host1x_sp_%02d", id);
+	}
+
+	host1x_intr_start(host);
+
+	return 0;
+}
+
+void host1x_intr_deinit(struct host1x *host)
+{
+	host1x_intr_stop(host);
+	destroy_workqueue(host->intr_wq);
+}
+
+void host1x_intr_start(struct host1x *host)
+{
+	u32 hz = clk_get_rate(host->clk);
+	int err;
+
+	mutex_lock(&host->intr_mutex);
+	err = host1x_hw_intr_init_host_sync(host, DIV_ROUND_UP(hz, 1000000),
+					    syncpt_thresh_work);
+	if (err) {
+		mutex_unlock(&host->intr_mutex);
+		return;
+	}
+	mutex_unlock(&host->intr_mutex);
+}
+
+void host1x_intr_stop(struct host1x *host)
+{
+	unsigned int id;
+	struct host1x_syncpt *syncpt = host->syncpt;
+	u32 nb_pts = host1x_syncpt_nb_pts(host);
+
+	mutex_lock(&host->intr_mutex);
+
+	host1x_hw_intr_disable_all_syncpt_intrs(host);
+
+	for (id = 0; id < nb_pts; ++id) {
+		struct host1x_waitlist *waiter, *next;
+
+		list_for_each_entry_safe(waiter, next,
+			&syncpt[id].intr.wait_head, list) {
+			if (atomic_cmpxchg(&waiter->state,
+			    WLS_CANCELLED, WLS_HANDLED) == WLS_CANCELLED) {
+				list_del(&waiter->list);
+				kref_put(&waiter->refcount, waiter_release);
+			}
+		}
+
+		if (!list_empty(&syncpt[id].intr.wait_head)) {
+			/* output diagnostics */
+			mutex_unlock(&host->intr_mutex);
+			pr_warn("%s cannot stop syncpt intr id=%d\n",
+				__func__, id);
+			return;
+		}
+	}
+
+	host1x_hw_intr_free_syncpt_irq(host);
+
+	mutex_unlock(&host->intr_mutex);
+}
diff --git a/drivers/gpu/host1x/intr.h b/drivers/gpu/host1x/intr.h
new file mode 100644
index 0000000..a3f06ab
--- /dev/null
+++ b/drivers/gpu/host1x/intr.h
@@ -0,0 +1,96 @@
+/*
+ * Tegra host1x Interrupt Management
+ *
+ * Copyright (c) 2010-2013, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __HOST1X_INTR_H
+#define __HOST1X_INTR_H
+
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+
+struct host1x;
+
+enum host1x_intr_action {
+	/*
+	 * Wake up a  task.
+	 * 'data' points to a wait_queue_head_t
+	 */
+	HOST1X_INTR_ACTION_WAKEUP,
+
+	/*
+	 * Wake up a interruptible task.
+	 * 'data' points to a wait_queue_head_t
+	 */
+	HOST1X_INTR_ACTION_WAKEUP_INTERRUPTIBLE,
+
+	HOST1X_INTR_ACTION_COUNT
+};
+
+struct host1x_syncpt_intr {
+	spinlock_t lock;
+	struct list_head wait_head;
+	char thresh_irq_name[12];
+	struct work_struct work;
+};
+
+struct host1x_waitlist {
+	struct list_head list;
+	struct kref refcount;
+	u32 thresh;
+	enum host1x_intr_action action;
+	atomic_t state;
+	void *data;
+	int count;
+};
+
+/*
+ * Schedule an action to be taken when a sync point reaches the given threshold.
+ *
+ * @id the sync point
+ * @thresh the threshold
+ * @action the action to take
+ * @data a pointer to extra data depending on action, see above
+ * @waiter waiter structure - assumes ownership
+ * @ref must be passed if cancellation is possible, else NULL
+ *
+ * This is a non-blocking api.
+ */
+int host1x_intr_add_action(struct host1x *host, u32 id, u32 thresh,
+	enum host1x_intr_action action, void *data,
+	struct host1x_waitlist *waiter, void **ref);
+
+/*
+ * Unreference an action submitted to host1x_intr_add_action().
+ * You must call this if you passed non-NULL as ref.
+ * @ref the ref returned from host1x_intr_add_action()
+ */
+void host1x_intr_put_ref(struct host1x *host, u32 id, void *ref);
+
+/* Initialize host1x sync point interrupt */
+int host1x_intr_init(struct host1x *host, unsigned int irq_sync);
+
+/* Deinitialize host1x sync point interrupt */
+void host1x_intr_deinit(struct host1x *host);
+
+/* Enable host1x sync point interrupt */
+void host1x_intr_start(struct host1x *host);
+
+/* Disable host1x sync point interrupt */
+void host1x_intr_stop(struct host1x *host);
+
+irqreturn_t host1x_syncpt_thresh_fn(void *dev_id);
+#endif
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 9df962c..a8613eb 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -24,6 +24,10 @@
 
 #include "syncpt.h"
 #include "dev.h"
+#include "intr.h"
+
+#define SYNCPT_CHECK_PERIOD (2 * HZ)
+#define MAX_STUCK_CHECK_COUNT 15
 
 static struct host1x_syncpt *_host1x_syncpt_alloc(struct host1x *host,
 						  struct device *dev,
@@ -141,6 +145,161 @@ void host1x_syncpt_incr(struct host1x_syncpt *sp)
 	host1x_syncpt_cpu_incr(sp);
 }
 
+/*
+ * Updated sync point form hardware, and returns true if syncpoint is expired,
+ * false if we may need to wait
+ */
+static bool syncpt_load_min_is_expired(struct host1x_syncpt *sp, u32 thresh)
+{
+	host1x_hw_syncpt_load(sp->host, sp);
+	return host1x_syncpt_is_expired(sp, thresh);
+}
+
+/*
+ * Main entrypoint for syncpoint value waits.
+ */
+int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh, long timeout,
+			u32 *value)
+{
+	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
+	void *ref;
+	struct host1x_waitlist *waiter;
+	int err = 0, check_count = 0;
+	u32 val;
+
+	if (value)
+		*value = 0;
+
+	/* first check cache */
+	if (host1x_syncpt_is_expired(sp, thresh)) {
+		if (value)
+			*value = host1x_syncpt_load(sp);
+		return 0;
+	}
+
+	/* try to read from register */
+	val = host1x_hw_syncpt_load(sp->host, sp);
+	if (host1x_syncpt_is_expired(sp, thresh)) {
+		if (value)
+			*value = val;
+		goto done;
+	}
+
+	if (!timeout) {
+		err = -EAGAIN;
+		goto done;
+	}
+
+	/* allocate a waiter */
+	waiter = kzalloc(sizeof(*waiter), GFP_KERNEL);
+	if (!waiter) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	/* schedule a wakeup when the syncpoint value is reached */
+	err = host1x_intr_add_action(sp->host, sp->id, thresh,
+				     HOST1X_INTR_ACTION_WAKEUP_INTERRUPTIBLE,
+				     &wq, waiter, &ref);
+	if (err)
+		goto done;
+
+	err = -EAGAIN;
+	/* Caller-specified timeout may be impractically low */
+	if (timeout < 0)
+		timeout = LONG_MAX;
+
+	/* wait for the syncpoint, or timeout, or signal */
+	while (timeout) {
+		long check = min_t(long, SYNCPT_CHECK_PERIOD, timeout);
+		int remain = wait_event_interruptible_timeout(wq,
+				syncpt_load_min_is_expired(sp, thresh),
+				check);
+		if (remain > 0 || host1x_syncpt_is_expired(sp, thresh)) {
+			if (value)
+				*value = host1x_syncpt_load(sp);
+			err = 0;
+			break;
+		}
+		if (remain < 0) {
+			err = remain;
+			break;
+		}
+		timeout -= check;
+		if (timeout && check_count <= MAX_STUCK_CHECK_COUNT) {
+			dev_warn(sp->host->dev,
+				"%s: syncpoint id %d (%s) stuck waiting %d, timeout=%ld\n",
+				 current->comm, sp->id, sp->name,
+				 thresh, timeout);
+			check_count++;
+		}
+	}
+	host1x_intr_put_ref(sp->host, sp->id, ref);
+
+done:
+	return err;
+}
+EXPORT_SYMBOL(host1x_syncpt_wait);
+
+/*
+ * Returns true if syncpoint is expired, false if we may need to wait
+ */
+bool host1x_syncpt_is_expired(struct host1x_syncpt *sp, u32 thresh)
+{
+	u32 current_val;
+	u32 future_val;
+	smp_rmb();
+	current_val = (u32)atomic_read(&sp->min_val);
+	future_val = (u32)atomic_read(&sp->max_val);
+
+	/* Note the use of unsigned arithmetic here (mod 1<<32).
+	 *
+	 * c = current_val = min_val	= the current value of the syncpoint.
+	 * t = thresh			= the value we are checking
+	 * f = future_val  = max_val	= the value c will reach when all
+	 *				  outstanding increments have completed.
+	 *
+	 * Note that c always chases f until it reaches f.
+	 *
+	 * Dtf = (f - t)
+	 * Dtc = (c - t)
+	 *
+	 *  Consider all cases:
+	 *
+	 *	A) .....c..t..f.....	Dtf < Dtc	need to wait
+	 *	B) .....c.....f..t..	Dtf > Dtc	expired
+	 *	C) ..t..c.....f.....	Dtf > Dtc	expired	   (Dct very large)
+	 *
+	 *  Any case where f==c: always expired (for any t).	Dtf == Dcf
+	 *  Any case where t==c: always expired (for any f).	Dtf >= Dtc (because Dtc==0)
+	 *  Any case where t==f!=c: always wait.		Dtf <  Dtc (because Dtf==0,
+	 *							Dtc!=0)
+	 *
+	 *  Other cases:
+	 *
+	 *	A) .....t..f..c.....	Dtf < Dtc	need to wait
+	 *	A) .....f..c..t.....	Dtf < Dtc	need to wait
+	 *	A) .....f..t..c.....	Dtf > Dtc	expired
+	 *
+	 *   So:
+	 *	   Dtf >= Dtc implies EXPIRED	(return true)
+	 *	   Dtf <  Dtc implies WAIT	(return false)
+	 *
+	 * Note: If t is expired then we *cannot* wait on it. We would wait
+	 * forever (hang the system).
+	 *
+	 * Note: do NOT get clever and remove the -thresh from both sides. It
+	 * is NOT the same.
+	 *
+	 * If future valueis zero, we have a client managed sync point. In that
+	 * case we do a direct comparison.
+	 */
+	if (!host1x_syncpt_client_managed(sp))
+		return future_val - thresh >= current_val - thresh;
+	else
+		return (s32)(current_val - thresh) >= 0;
+}
+
 int host1x_syncpt_init(struct host1x *host)
 {
 	struct host1x_syncpt *syncpt;
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 119ccd5..17c1616 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -19,9 +19,11 @@
 #ifndef __HOST1X_SYNCPT_H
 #define __HOST1X_SYNCPT_H
 
+#include <linux/atomic.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
-#include <linux/atomic.h>
+
+#include "intr.h"
 
 struct host1x;
 
@@ -34,6 +36,9 @@ struct host1x_syncpt {
 	int client_managed;
 	struct host1x *host;
 	struct device *dev;
+
+	/* interrupt data */
+	struct host1x_syncpt_intr intr;
 };
 
 /* Initialize sync point array  */
@@ -113,6 +118,9 @@ void host1x_syncpt_cpu_incr(struct host1x_syncpt *sp);
 /* Load current value from hardware to the shadow register. */
 u32 host1x_syncpt_load(struct host1x_syncpt *sp);
 
+/* Check if the given syncpoint value has already passed */
+bool host1x_syncpt_is_expired(struct host1x_syncpt *sp, u32 thresh);
+
 /* Save host1x sync point state into shadow registers. */
 void host1x_syncpt_save(struct host1x *host);
 
@@ -128,6 +136,10 @@ void host1x_syncpt_incr(struct host1x_syncpt *sp);
 /* Indicate future operations by incrementing the sync point max. */
 u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs);
 
+/* Wait until sync point reaches a threshold value, or a timeout. */
+int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh,
+			long timeout, u32 *value);
+
 /* Check if sync point id is valid. */
 static inline int host1x_syncpt_is_valid(struct host1x_syncpt *sp)
 {
-- 
1.7.9.5

