Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644Ab3CVOfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 10:35:04 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6537 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933567Ab3CVOeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 10:34:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 07:34:08 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv9 3/9] gpu: host1x: Add channel support
Date: Fri, 22 Mar 2013 16:34:03 +0200
Message-ID: <1363962849-19872-4-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com>
References: <1363962849-19872-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for host1x client modules, and host1x channels to submit
work to the clients.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Kconfig                  |   12 +
 drivers/gpu/host1x/Makefile                 |    3 +
 drivers/gpu/host1x/cdma.c                   |  487 +++++++++++++++++++++
 drivers/gpu/host1x/cdma.h                   |  100 +++++
 drivers/gpu/host1x/channel.c                |  126 ++++++
 drivers/gpu/host1x/channel.h                |   52 +++
 drivers/gpu/host1x/dev.c                    |   17 +
 drivers/gpu/host1x/dev.h                    |  113 +++++
 drivers/gpu/host1x/host1x.h                 |   28 ++
 drivers/gpu/host1x/host1x_bo.h              |   87 ++++
 drivers/gpu/host1x/hw/cdma_hw.c             |  324 ++++++++++++++
 drivers/gpu/host1x/hw/channel_hw.c          |  143 +++++++
 drivers/gpu/host1x/hw/host1x01.c            |    5 +
 drivers/gpu/host1x/hw/host1x01_hardware.h   |  116 ++++++
 drivers/gpu/host1x/hw/hw_host1x01_channel.h |  102 +++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h    |   12 +
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h  |  168 ++++++++
 drivers/gpu/host1x/hw/syncpt_hw.c           |   11 +
 drivers/gpu/host1x/intr.c                   |   28 +-
 drivers/gpu/host1x/intr.h                   |    6 +
 drivers/gpu/host1x/job.c                    |  603 +++++++++++++++++++++++++++
 drivers/gpu/host1x/job.h                    |  162 +++++++
 drivers/gpu/host1x/syncpt.c                 |   11 +
 drivers/gpu/host1x/syncpt.h                 |    6 +
 include/trace/events/host1x.h               |  211 ++++++++++
 25 files changed, 2932 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/host1x/cdma.c
 create mode 100644 drivers/gpu/host1x/cdma.h
 create mode 100644 drivers/gpu/host1x/channel.c
 create mode 100644 drivers/gpu/host1x/channel.h
 create mode 100644 drivers/gpu/host1x/host1x.h
 create mode 100644 drivers/gpu/host1x/host1x_bo.h
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
 create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
 create mode 100644 drivers/gpu/host1x/job.c
 create mode 100644 drivers/gpu/host1x/job.h

diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
index c01c450..00f0859 100644
--- a/drivers/gpu/host1x/Kconfig
+++ b/drivers/gpu/host1x/Kconfig
@@ -7,3 +7,15 @@ config TEGRA_HOST1X
 	  Tegra's graphics- and multimedia-related modules. The modules served
 	  by host1x are referred to as clients. host1x includes some other
 	  functionality, such as synchronization.
+
+if TEGRA_HOST1X
+
+config TEGRA_HOST1X_FIREWALL
+	bool "Enable HOST1X security firewall"
+	default y
+	help
+	  Say yes if kernel should protect command streams from tampering.
+
+	  If unsure, choose Y.
+
+endif
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 5ef47ff..06a995b 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -4,6 +4,9 @@ host1x-y = \
 	syncpt.o \
 	dev.o \
 	intr.o \
+	cdma.o \
+	channel.o \
+	job.o \
 	hw/host1x01.o
 
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
new file mode 100644
index 0000000..33935de
--- /dev/null
+++ b/drivers/gpu/host1x/cdma.c
@@ -0,0 +1,487 @@
+/*
+ * Tegra host1x Command DMA
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
+
+#include <asm/cacheflush.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/kfifo.h>
+#include <linux/slab.h>
+#include <trace/events/host1x.h>
+
+#include "cdma.h"
+#include "channel.h"
+#include "dev.h"
+#include "debug.h"
+#include "host1x_bo.h"
+#include "job.h"
+
+/*
+ * push_buffer
+ *
+ * The push buffer is a circular array of words to be fetched by command DMA.
+ * Note that it works slightly differently to the sync queue; fence == pos
+ * means that the push buffer is full, not empty.
+ */
+
+#define HOST1X_PUSHBUFFER_SLOTS	512
+
+/*
+ * Clean up push buffer resources
+ */
+static void host1x_pushbuffer_destroy(struct push_buffer *pb)
+{
+	struct host1x_cdma *cdma = pb_to_cdma(pb);
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	if (pb->phys != 0)
+		dma_free_writecombine(host1x->dev, pb->size_bytes + 4,
+				      pb->mapped, pb->phys);
+
+	pb->mapped = NULL;
+	pb->phys = 0;
+}
+
+/*
+ * Init push buffer resources
+ */
+static int host1x_pushbuffer_init(struct push_buffer *pb)
+{
+	struct host1x_cdma *cdma = pb_to_cdma(pb);
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	pb->mapped = NULL;
+	pb->phys = 0;
+	pb->size_bytes = HOST1X_PUSHBUFFER_SLOTS * 8;
+
+	/* initialize buffer pointers */
+	pb->fence = pb->size_bytes - 8;
+	pb->pos = 0;
+
+	/* allocate and map pushbuffer memory */
+	pb->mapped = dma_alloc_writecombine(host1x->dev, pb->size_bytes + 4,
+					    &pb->phys, GFP_KERNEL);
+	if (!pb->mapped)
+		goto fail;
+
+	host1x_hw_pushbuffer_init(host1x, pb);
+
+	return 0;
+
+fail:
+	host1x_pushbuffer_destroy(pb);
+	return -ENOMEM;
+}
+
+/*
+ * Push two words to the push buffer
+ * Caller must ensure push buffer is not full
+ */
+static void host1x_pushbuffer_push(struct push_buffer *pb, u32 op1, u32 op2)
+{
+	u32 pos = pb->pos;
+	u32 *p = (u32 *)((u32)pb->mapped + pos);
+	WARN_ON(pos == pb->fence);
+	*(p++) = op1;
+	*(p++) = op2;
+	pb->pos = (pos + 8) & (pb->size_bytes - 1);
+}
+
+/*
+ * Pop a number of two word slots from the push buffer
+ * Caller must ensure push buffer is not empty
+ */
+static void host1x_pushbuffer_pop(struct push_buffer *pb, unsigned int slots)
+{
+	/* Advance the next write position */
+	pb->fence = (pb->fence + slots * 8) & (pb->size_bytes - 1);
+}
+
+/*
+ * Return the number of two word slots free in the push buffer
+ */
+static u32 host1x_pushbuffer_space(struct push_buffer *pb)
+{
+	return ((pb->fence - pb->pos) & (pb->size_bytes - 1)) / 8;
+}
+
+/*
+ * Sleep (if necessary) until the requested event happens
+ *   - CDMA_EVENT_SYNC_QUEUE_EMPTY : sync queue is completely empty.
+ *     - Returns 1
+ *   - CDMA_EVENT_PUSH_BUFFER_SPACE : there is space in the push buffer
+ *     - Return the amount of space (> 0)
+ * Must be called with the cdma lock held.
+ */
+unsigned int host1x_cdma_wait_locked(struct host1x_cdma *cdma,
+				     enum cdma_event event)
+{
+	for (;;) {
+		unsigned int space;
+
+		if (event == CDMA_EVENT_SYNC_QUEUE_EMPTY)
+			space = list_empty(&cdma->sync_queue) ? 1 : 0;
+		else if (event == CDMA_EVENT_PUSH_BUFFER_SPACE) {
+			struct push_buffer *pb = &cdma->push_buffer;
+			space = host1x_pushbuffer_space(pb);
+		} else {
+			WARN_ON(1);
+			return -EINVAL;
+		}
+
+		if (space)
+			return space;
+
+		trace_host1x_wait_cdma(dev_name(cdma_to_channel(cdma)->dev),
+				       event);
+
+		/* If somebody has managed to already start waiting, yield */
+		if (cdma->event != CDMA_EVENT_NONE) {
+			mutex_unlock(&cdma->lock);
+			schedule();
+			mutex_lock(&cdma->lock);
+			continue;
+		}
+		cdma->event = event;
+
+		mutex_unlock(&cdma->lock);
+		down(&cdma->sem);
+		mutex_lock(&cdma->lock);
+	}
+	return 0;
+}
+
+/*
+ * Start timer that tracks the time spent by the job.
+ * Must be called with the cdma lock held.
+ */
+static void cdma_start_timer_locked(struct host1x_cdma *cdma,
+				    struct host1x_job *job)
+{
+	struct host1x *host = cdma_to_host1x(cdma);
+
+	if (cdma->timeout.client) {
+		/* timer already started */
+		return;
+	}
+
+	cdma->timeout.client = job->client;
+	cdma->timeout.syncpt = host1x_syncpt_get(host, job->syncpt_id);
+	cdma->timeout.syncpt_val = job->syncpt_end;
+	cdma->timeout.start_ktime = ktime_get();
+
+	schedule_delayed_work(&cdma->timeout.wq,
+			      msecs_to_jiffies(job->timeout));
+}
+
+/*
+ * Stop timer when a buffer submission completes.
+ * Must be called with the cdma lock held.
+ */
+static void stop_cdma_timer_locked(struct host1x_cdma *cdma)
+{
+	cancel_delayed_work(&cdma->timeout.wq);
+	cdma->timeout.client = 0;
+}
+
+/*
+ * For all sync queue entries that have already finished according to the
+ * current sync point registers:
+ *  - unpin & unref their mems
+ *  - pop their push buffer slots
+ *  - remove them from the sync queue
+ * This is normally called from the host code's worker thread, but can be
+ * called manually if necessary.
+ * Must be called with the cdma lock held.
+ */
+static void update_cdma_locked(struct host1x_cdma *cdma)
+{
+	bool signal = false;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_job *job, *n;
+
+	/* If CDMA is stopped, queue is cleared and we can return */
+	if (!cdma->running)
+		return;
+
+	/*
+	 * Walk the sync queue, reading the sync point registers as necessary,
+	 * to consume as many sync queue entries as possible without blocking
+	 */
+	list_for_each_entry_safe(job, n, &cdma->sync_queue, list) {
+		struct host1x_syncpt *sp =
+			host1x_syncpt_get(host1x, job->syncpt_id);
+
+		/* Check whether this syncpt has completed, and bail if not */
+		if (!host1x_syncpt_is_expired(sp, job->syncpt_end)) {
+			/* Start timer on next pending syncpt */
+			if (job->timeout)
+				cdma_start_timer_locked(cdma, job);
+			break;
+		}
+
+		/* Cancel timeout, when a buffer completes */
+		if (cdma->timeout.client)
+			stop_cdma_timer_locked(cdma);
+
+		/* Unpin the memory */
+		host1x_job_unpin(job);
+
+		/* Pop push buffer slots */
+		if (job->num_slots) {
+			struct push_buffer *pb = &cdma->push_buffer;
+			host1x_pushbuffer_pop(pb, job->num_slots);
+			if (cdma->event == CDMA_EVENT_PUSH_BUFFER_SPACE)
+				signal = true;
+		}
+
+		list_del(&job->list);
+		host1x_job_put(job);
+	}
+
+	if (cdma->event == CDMA_EVENT_SYNC_QUEUE_EMPTY &&
+	    list_empty(&cdma->sync_queue))
+		signal = true;
+
+	if (signal) {
+		cdma->event = CDMA_EVENT_NONE;
+		up(&cdma->sem);
+	}
+}
+
+void host1x_cdma_update_sync_queue(struct host1x_cdma *cdma,
+				   struct device *dev)
+{
+	u32 restart_addr;
+	u32 syncpt_incrs;
+	struct host1x_job *job = NULL;
+	u32 syncpt_val;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	syncpt_val = host1x_syncpt_load(cdma->timeout.syncpt);
+
+	dev_dbg(dev, "%s: starting cleanup (thresh %d)\n",
+		__func__, syncpt_val);
+
+	/*
+	 * Move the sync_queue read pointer to the first entry that hasn't
+	 * completed based on the current HW syncpt value. It's likely there
+	 * won't be any (i.e. we're still at the head), but covers the case
+	 * where a syncpt incr happens just prior/during the teardown.
+	 */
+
+	dev_dbg(dev, "%s: skip completed buffers still in sync_queue\n",
+		__func__);
+
+	list_for_each_entry(job, &cdma->sync_queue, list) {
+		if (syncpt_val < job->syncpt_end)
+			break;
+
+		host1x_job_dump(dev, job);
+	}
+
+	/*
+	 * Walk the sync_queue, first incrementing with the CPU syncpts that
+	 * are partially executed (the first buffer) or fully skipped while
+	 * still in the current context (slots are also NOP-ed).
+	 *
+	 * At the point contexts are interleaved, syncpt increments must be
+	 * done inline with the pushbuffer from a GATHER buffer to maintain
+	 * the order (slots are modified to be a GATHER of syncpt incrs).
+	 *
+	 * Note: save in restart_addr the location where the timed out buffer
+	 * started in the PB, so we can start the refetch from there (with the
+	 * modified NOP-ed PB slots). This lets things appear to have completed
+	 * properly for this buffer and resources are freed.
+	 */
+
+	dev_dbg(dev, "%s: perform CPU incr on pending same ctx buffers\n",
+		__func__);
+
+	if (!list_empty(&cdma->sync_queue))
+		restart_addr = job->first_get;
+	else
+		restart_addr = cdma->last_pos;
+
+	/* do CPU increments as long as this context continues */
+	list_for_each_entry_from(job, &cdma->sync_queue, list) {
+		/* different context, gets us out of this loop */
+		if (job->client != cdma->timeout.client)
+			break;
+
+		/* won't need a timeout when replayed */
+		job->timeout = 0;
+
+		syncpt_incrs = job->syncpt_end - syncpt_val;
+		dev_dbg(dev, "%s: CPU incr (%d)\n", __func__, syncpt_incrs);
+
+		host1x_job_dump(dev, job);
+
+		/* safe to use CPU to incr syncpts */
+		host1x_hw_cdma_timeout_cpu_incr(host1x, cdma, job->first_get,
+						syncpt_incrs, job->syncpt_end,
+						job->num_slots);
+
+		syncpt_val += syncpt_incrs;
+	}
+
+	/* The following sumbits from the same client may be dependent on the
+	 * failed submit and therefore they may fail. Force a small timeout
+	 * to make the queue cleanup faster */
+
+	list_for_each_entry_from(job, &cdma->sync_queue, list)
+		if (job->client == cdma->timeout.client)
+			job->timeout = min_t(unsigned int, job->timeout, 500);
+
+	dev_dbg(dev, "%s: finished sync_queue modification\n", __func__);
+
+	/* roll back DMAGET and start up channel again */
+	host1x_hw_cdma_resume(host1x, cdma, restart_addr);
+}
+
+/*
+ * Create a cdma
+ */
+int host1x_cdma_init(struct host1x_cdma *cdma)
+{
+	int err;
+
+	mutex_init(&cdma->lock);
+	sema_init(&cdma->sem, 0);
+
+	INIT_LIST_HEAD(&cdma->sync_queue);
+
+	cdma->event = CDMA_EVENT_NONE;
+	cdma->running = false;
+	cdma->torndown = false;
+
+	err = host1x_pushbuffer_init(&cdma->push_buffer);
+	if (err)
+		return err;
+	return 0;
+}
+
+/*
+ * Destroy a cdma
+ */
+int host1x_cdma_deinit(struct host1x_cdma *cdma)
+{
+	struct push_buffer *pb = &cdma->push_buffer;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	if (cdma->running) {
+		pr_warn("%s: CDMA still running\n", __func__);
+		return -EBUSY;
+	}
+
+	host1x_pushbuffer_destroy(pb);
+	host1x_hw_cdma_timeout_destroy(host1x, cdma);
+
+	return 0;
+}
+
+/*
+ * Begin a cdma submit
+ */
+int host1x_cdma_begin(struct host1x_cdma *cdma, struct host1x_job *job)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	mutex_lock(&cdma->lock);
+
+	if (job->timeout) {
+		/* init state on first submit with timeout value */
+		if (!cdma->timeout.initialized) {
+			int err;
+			err = host1x_hw_cdma_timeout_init(host1x, cdma,
+							  job->syncpt_id);
+			if (err) {
+				mutex_unlock(&cdma->lock);
+				return err;
+			}
+		}
+	}
+	if (!cdma->running)
+		host1x_hw_cdma_start(host1x, cdma);
+
+	cdma->slots_free = 0;
+	cdma->slots_used = 0;
+	cdma->first_get = cdma->push_buffer.pos;
+
+	trace_host1x_cdma_begin(dev_name(job->channel->dev));
+	return 0;
+}
+
+/*
+ * Push two words into a push buffer slot
+ * Blocks as necessary if the push buffer is full.
+ */
+void host1x_cdma_push(struct host1x_cdma *cdma, u32 op1, u32 op2)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct push_buffer *pb = &cdma->push_buffer;
+	u32 slots_free = cdma->slots_free;
+
+	if (slots_free == 0) {
+		host1x_hw_cdma_flush(host1x, cdma);
+		slots_free = host1x_cdma_wait_locked(cdma,
+						CDMA_EVENT_PUSH_BUFFER_SPACE);
+	}
+	cdma->slots_free = slots_free - 1;
+	cdma->slots_used++;
+	host1x_pushbuffer_push(pb, op1, op2);
+}
+
+/*
+ * End a cdma submit
+ * Kick off DMA, add job to the sync queue, and a number of slots to be freed
+ * from the pushbuffer. The handles for a submit must all be pinned at the same
+ * time, but they can be unpinned in smaller chunks.
+ */
+void host1x_cdma_end(struct host1x_cdma *cdma,
+		     struct host1x_job *job)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	bool idle = list_empty(&cdma->sync_queue);
+
+	host1x_hw_cdma_flush(host1x, cdma);
+
+	job->first_get = cdma->first_get;
+	job->num_slots = cdma->slots_used;
+	host1x_job_get(job);
+	list_add_tail(&job->list, &cdma->sync_queue);
+
+	/* start timer on idle -> active transitions */
+	if (job->timeout && idle)
+		cdma_start_timer_locked(cdma, job);
+
+	trace_host1x_cdma_end(dev_name(job->channel->dev));
+	mutex_unlock(&cdma->lock);
+}
+
+/*
+ * Update cdma state according to current sync point values
+ */
+void host1x_cdma_update(struct host1x_cdma *cdma)
+{
+	mutex_lock(&cdma->lock);
+	update_cdma_locked(cdma);
+	mutex_unlock(&cdma->lock);
+}
diff --git a/drivers/gpu/host1x/cdma.h b/drivers/gpu/host1x/cdma.h
new file mode 100644
index 0000000..313c4b7
--- /dev/null
+++ b/drivers/gpu/host1x/cdma.h
@@ -0,0 +1,100 @@
+/*
+ * Tegra host1x Command DMA
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
+#ifndef __HOST1X_CDMA_H
+#define __HOST1X_CDMA_H
+
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/list.h>
+
+struct host1x_syncpt;
+struct host1x_userctx_timeout;
+struct host1x_job;
+
+/*
+ * cdma
+ *
+ * This is in charge of a host command DMA channel.
+ * Sends ops to a push buffer, and takes responsibility for unpinning
+ * (& possibly freeing) of memory after those ops have completed.
+ * Producer:
+ *	begin
+ *		push - send ops to the push buffer
+ *	end - start command DMA and enqueue handles to be unpinned
+ * Consumer:
+ *	update - call to update sync queue and push buffer, unpin memory
+ */
+
+struct push_buffer {
+	u32 *mapped;			/* mapped pushbuffer memory */
+	dma_addr_t phys;		/* physical address of pushbuffer */
+	u32 fence;			/* index we've written */
+	u32 pos;			/* index to write to */
+	u32 size_bytes;
+};
+
+struct buffer_timeout {
+	struct delayed_work wq;		/* work queue */
+	bool initialized;		/* timer one-time setup flag */
+	struct host1x_syncpt *syncpt;	/* buffer completion syncpt */
+	u32 syncpt_val;			/* syncpt value when completed */
+	ktime_t start_ktime;		/* starting time */
+	/* context timeout information */
+	int client;
+};
+
+enum cdma_event {
+	CDMA_EVENT_NONE,		/* not waiting for any event */
+	CDMA_EVENT_SYNC_QUEUE_EMPTY,	/* wait for empty sync queue */
+	CDMA_EVENT_PUSH_BUFFER_SPACE	/* wait for space in push buffer */
+};
+
+struct host1x_cdma {
+	struct mutex lock;		/* controls access to shared state */
+	struct semaphore sem;		/* signalled when event occurs */
+	enum cdma_event event;		/* event that sem is waiting for */
+	unsigned int slots_used;	/* pb slots used in current submit */
+	unsigned int slots_free;	/* pb slots free in current submit */
+	unsigned int first_get;		/* DMAGET value, where submit begins */
+	unsigned int last_pos;		/* last value written to DMAPUT */
+	struct push_buffer push_buffer;	/* channel's push buffer */
+	struct list_head sync_queue;	/* job queue */
+	struct buffer_timeout timeout;	/* channel's timeout state/wq */
+	bool running;
+	bool torndown;
+};
+
+#define cdma_to_channel(cdma) container_of(cdma, struct host1x_channel, cdma)
+#define cdma_to_host1x(cdma) dev_get_drvdata(cdma_to_channel(cdma)->dev->parent)
+#define pb_to_cdma(pb) container_of(pb, struct host1x_cdma, push_buffer)
+
+int host1x_cdma_init(struct host1x_cdma *cdma);
+int host1x_cdma_deinit(struct host1x_cdma *cdma);
+void host1x_cdma_stop(struct host1x_cdma *cdma);
+int host1x_cdma_begin(struct host1x_cdma *cdma, struct host1x_job *job);
+void host1x_cdma_push(struct host1x_cdma *cdma, u32 op1, u32 op2);
+void host1x_cdma_end(struct host1x_cdma *cdma, struct host1x_job *job);
+void host1x_cdma_update(struct host1x_cdma *cdma);
+void host1x_cdma_peek(struct host1x_cdma *cdma, u32 dmaget, int slot,
+		      u32 *out);
+unsigned int host1x_cdma_wait_locked(struct host1x_cdma *cdma,
+				     enum cdma_event event);
+void host1x_cdma_update_sync_queue(struct host1x_cdma *cdma,
+				   struct device *dev);
+#endif
diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
new file mode 100644
index 0000000..83ea51b
--- /dev/null
+++ b/drivers/gpu/host1x/channel.c
@@ -0,0 +1,126 @@
+/*
+ * Tegra host1x Channel
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
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#include "channel.h"
+#include "dev.h"
+#include "job.h"
+
+/* Constructor for the host1x device list */
+int host1x_channel_list_init(struct host1x *host)
+{
+	INIT_LIST_HEAD(&host->chlist.list);
+	mutex_init(&host->chlist_mutex);
+
+	if (host->info->nb_channels > BITS_PER_LONG) {
+		WARN(1, "host1x hardware has more channels than supported by the driver\n");
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
+int host1x_job_submit(struct host1x_job *job)
+{
+	struct host1x *host = dev_get_drvdata(job->channel->dev->parent);
+
+	return host1x_hw_channel_submit(host, job);
+}
+
+struct host1x_channel *host1x_channel_get(struct host1x_channel *channel)
+{
+	int err = 0;
+
+	mutex_lock(&channel->reflock);
+
+	if (channel->refcount == 0)
+		err = host1x_cdma_init(&channel->cdma);
+
+	if (!err)
+		channel->refcount++;
+
+	mutex_unlock(&channel->reflock);
+
+	return err ? NULL : channel;
+}
+
+void host1x_channel_put(struct host1x_channel *channel)
+{
+	mutex_lock(&channel->reflock);
+
+	if (channel->refcount == 1) {
+		struct host1x *host = dev_get_drvdata(channel->dev->parent);
+
+		host1x_hw_cdma_stop(host, &channel->cdma);
+		host1x_cdma_deinit(&channel->cdma);
+	}
+
+	channel->refcount--;
+
+	mutex_unlock(&channel->reflock);
+}
+
+struct host1x_channel *host1x_channel_request(struct device *dev)
+{
+	struct host1x *host = dev_get_drvdata(dev->parent);
+	int max_channels = host->info->nb_channels;
+	struct host1x_channel *channel = NULL;
+	int index, err;
+
+	mutex_lock(&host->chlist_mutex);
+
+	index = find_first_zero_bit(&host->allocated_channels, max_channels);
+	if (index >= max_channels)
+		goto fail;
+
+	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
+	if (!channel)
+		goto fail;
+
+	err = host1x_hw_channel_init(host, channel, index);
+	if (err < 0)
+		goto fail;
+
+	/* Link device to host1x_channel */
+	channel->dev = dev;
+
+	/* Add to channel list */
+	list_add_tail(&channel->list, &host->chlist.list);
+
+	host->allocated_channels |= BIT(index);
+
+	mutex_unlock(&host->chlist_mutex);
+	return channel;
+
+fail:
+	dev_err(dev, "failed to init channel\n");
+	kfree(channel);
+	mutex_unlock(&host->chlist_mutex);
+	return NULL;
+}
+
+void host1x_channel_free(struct host1x_channel *channel)
+{
+	struct host1x *host = dev_get_drvdata(channel->dev->parent);
+
+	host->allocated_channels &= ~BIT(channel->id);
+	list_del(&channel->list);
+	kfree(channel);
+}
diff --git a/drivers/gpu/host1x/channel.h b/drivers/gpu/host1x/channel.h
new file mode 100644
index 0000000..48723b8
--- /dev/null
+++ b/drivers/gpu/host1x/channel.h
@@ -0,0 +1,52 @@
+/*
+ * Tegra host1x Channel
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
+#ifndef __HOST1X_CHANNEL_H
+#define __HOST1X_CHANNEL_H
+
+#include <linux/io.h>
+
+#include "cdma.h"
+
+struct host1x;
+
+struct host1x_channel {
+	struct list_head list;
+
+	unsigned int refcount;
+	unsigned int id;
+	struct mutex reflock;
+	struct mutex submitlock;
+	void __iomem *regs;
+	struct device *dev;
+	struct host1x_cdma cdma;
+};
+
+/* channel list operations */
+int host1x_channel_list_init(struct host1x *host);
+
+struct host1x_channel *host1x_channel_request(struct device *dev);
+void host1x_channel_free(struct host1x_channel *channel);
+struct host1x_channel *host1x_channel_get(struct host1x_channel *channel);
+void host1x_channel_put(struct host1x_channel *channel);
+int host1x_job_submit(struct host1x_job *job);
+
+#define host1x_for_each_channel(host, channel)				\
+	list_for_each_entry(channel, &host->chlist.list, list)
+
+#endif
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index b967f6e..4e522c5 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -29,6 +29,7 @@
 
 #include "dev.h"
 #include "intr.h"
+#include "channel.h"
 #include "hw/host1x01.h"
 
 void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
@@ -45,6 +46,16 @@ u32 host1x_sync_readl(struct host1x *host1x, u32 r)
 	return readl(sync_regs + r);
 }
 
+void host1x_ch_writel(struct host1x_channel *ch, u32 v, u32 r)
+{
+	writel(v, ch->regs + r);
+}
+
+u32 host1x_ch_readl(struct host1x_channel *ch, u32 r)
+{
+	return readl(ch->regs + r);
+}
+
 static const struct host1x_info host1x01_info = {
 	.nb_channels	= 8,
 	.nb_pts		= 32,
@@ -112,6 +123,12 @@ static int host1x_probe(struct platform_device *pdev)
 		return err;
 	}
 
+	err = host1x_channel_list_init(host);
+	if (err) {
+		dev_err(&pdev->dev, "failed to initialize channel list\n");
+		return err;
+	}
+
 	err = clk_prepare_enable(host->clk);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index caf9cc6..1a9b438 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -20,10 +20,39 @@
 #include <linux/platform_device.h>
 #include <linux/device.h>
 
+#include "channel.h"
 #include "syncpt.h"
 #include "intr.h"
+#include "cdma.h"
+#include "job.h"
 
 struct host1x_syncpt;
+struct host1x_channel;
+struct host1x_cdma;
+struct host1x_job;
+struct push_buffer;
+
+struct host1x_channel_ops {
+	int (*init)(struct host1x_channel *channel, struct host1x *host,
+		    unsigned int id);
+	int (*submit)(struct host1x_job *job);
+};
+
+struct host1x_cdma_ops {
+	void (*start)(struct host1x_cdma *cdma);
+	void (*stop)(struct host1x_cdma *cdma);
+	void (*flush)(struct  host1x_cdma *cdma);
+	int (*timeout_init)(struct host1x_cdma *cdma, u32 syncpt_id);
+	void (*timeout_destroy)(struct host1x_cdma *cdma);
+	void (*freeze)(struct host1x_cdma *cdma);
+	void (*resume)(struct host1x_cdma *cdma, u32 getptr);
+	void (*timeout_cpu_incr)(struct host1x_cdma *cdma, u32 getptr,
+				 u32 syncpt_incrs, u32 syncval, u32 nr_slots);
+};
+
+struct host1x_pushbuffer_ops {
+	void (*init)(struct push_buffer *pb);
+};
 
 struct host1x_syncpt_ops {
 	void (*restore)(struct host1x_syncpt *syncpt);
@@ -68,11 +97,22 @@ struct host1x {
 
 	const struct host1x_syncpt_ops *syncpt_op;
 	const struct host1x_intr_ops *intr_op;
+	const struct host1x_channel_ops *channel_op;
+	const struct host1x_cdma_ops *cdma_op;
+	const struct host1x_pushbuffer_ops *cdma_pb_op;
 
+	struct host1x_syncpt *nop_sp;
+
+	struct mutex chlist_mutex;
+	struct host1x_channel chlist;
+	unsigned long allocated_channels;
+	unsigned int num_allocated_channels;
 };
 
 void host1x_sync_writel(struct host1x *host1x, u32 r, u32 v);
 u32 host1x_sync_readl(struct host1x *host1x, u32 r);
+void host1x_ch_writel(struct host1x_channel *ch, u32 r, u32 v);
+u32 host1x_ch_readl(struct host1x_channel *ch, u32 r);
 
 static inline void host1x_hw_syncpt_restore(struct host1x *host,
 					    struct host1x_syncpt *sp)
@@ -144,4 +184,77 @@ static inline int host1x_hw_intr_free_syncpt_irq(struct host1x *host)
 {
 	return host->intr_op->free_syncpt_irq(host);
 }
+
+static inline int host1x_hw_channel_init(struct host1x *host,
+					 struct host1x_channel *channel,
+					 int chid)
+{
+	return host->channel_op->init(channel, host, chid);
+}
+
+static inline int host1x_hw_channel_submit(struct host1x *host,
+					   struct host1x_job *job)
+{
+	return host->channel_op->submit(job);
+}
+
+static inline void host1x_hw_cdma_start(struct host1x *host,
+					struct host1x_cdma *cdma)
+{
+	host->cdma_op->start(cdma);
+}
+
+static inline void host1x_hw_cdma_stop(struct host1x *host,
+				       struct host1x_cdma *cdma)
+{
+	host->cdma_op->stop(cdma);
+}
+
+static inline void host1x_hw_cdma_flush(struct host1x *host,
+					struct host1x_cdma *cdma)
+{
+	host->cdma_op->flush(cdma);
+}
+
+static inline int host1x_hw_cdma_timeout_init(struct host1x *host,
+					      struct host1x_cdma *cdma,
+					      u32 syncpt_id)
+{
+	return host->cdma_op->timeout_init(cdma, syncpt_id);
+}
+
+static inline void host1x_hw_cdma_timeout_destroy(struct host1x *host,
+						  struct host1x_cdma *cdma)
+{
+	host->cdma_op->timeout_destroy(cdma);
+}
+
+static inline void host1x_hw_cdma_freeze(struct host1x *host,
+					 struct host1x_cdma *cdma)
+{
+	host->cdma_op->freeze(cdma);
+}
+
+static inline void host1x_hw_cdma_resume(struct host1x *host,
+					 struct host1x_cdma *cdma, u32 getptr)
+{
+	host->cdma_op->resume(cdma, getptr);
+}
+
+static inline void host1x_hw_cdma_timeout_cpu_incr(struct host1x *host,
+						   struct host1x_cdma *cdma,
+						   u32 getptr,
+						   u32 syncpt_incrs,
+						   u32 syncval, u32 nr_slots)
+{
+	host->cdma_op->timeout_cpu_incr(cdma, getptr, syncpt_incrs, syncval,
+					nr_slots);
+}
+
+static inline void host1x_hw_pushbuffer_init(struct host1x *host,
+					     struct push_buffer *pb)
+{
+	host->cdma_pb_op->init(pb);
+}
+
 #endif
diff --git a/drivers/gpu/host1x/host1x.h b/drivers/gpu/host1x/host1x.h
new file mode 100644
index 0000000..bca6563
--- /dev/null
+++ b/drivers/gpu/host1x/host1x.h
@@ -0,0 +1,28 @@
+/*
+ * Tegra host1x driver
+ *
+ * Copyright (c) 2009-2013, NVIDIA Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+
+#ifndef __LINUX_HOST1X_H
+#define __LINUX_HOST1X_H
+
+enum host1x_class {
+	HOST1X_CLASS_HOST1X	= 0x1
+};
+
+#endif
diff --git a/drivers/gpu/host1x/host1x_bo.h b/drivers/gpu/host1x/host1x_bo.h
new file mode 100644
index 0000000..4c1f10bd
--- /dev/null
+++ b/drivers/gpu/host1x/host1x_bo.h
@@ -0,0 +1,87 @@
+/*
+ * Tegra host1x Memory Management Abstraction header
+ *
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
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
+#ifndef _HOST1X_BO_H
+#define _HOST1X_BO_H
+
+struct host1x_bo;
+
+struct host1x_bo_ops {
+	struct host1x_bo *(*get)(struct host1x_bo *bo);
+	void (*put)(struct host1x_bo *bo);
+	dma_addr_t (*pin)(struct host1x_bo *bo, struct sg_table **sgt);
+	void (*unpin)(struct host1x_bo *bo, struct sg_table *sgt);
+	void *(*mmap)(struct host1x_bo *bo);
+	void (*munmap)(struct host1x_bo *bo, void *addr);
+	void *(*kmap)(struct host1x_bo *bo, unsigned int pagenum);
+	void (*kunmap)(struct host1x_bo *bo, unsigned int pagenum, void *addr);
+};
+
+struct host1x_bo {
+	const struct host1x_bo_ops *ops;
+};
+
+static inline void host1x_bo_init(struct host1x_bo *bo,
+				  const struct host1x_bo_ops *ops)
+{
+	bo->ops = ops;
+}
+
+static inline struct host1x_bo *host1x_bo_get(struct host1x_bo *bo)
+{
+	return bo->ops->get(bo);
+}
+
+static inline void host1x_bo_put(struct host1x_bo *bo)
+{
+	bo->ops->put(bo);
+}
+
+static inline dma_addr_t host1x_bo_pin(struct host1x_bo *bo,
+				       struct sg_table **sgt)
+{
+	return bo->ops->pin(bo, sgt);
+}
+
+static inline void host1x_bo_unpin(struct host1x_bo *bo, struct sg_table *sgt)
+{
+	bo->ops->unpin(bo, sgt);
+}
+
+static inline void *host1x_bo_mmap(struct host1x_bo *bo)
+{
+	return bo->ops->mmap(bo);
+}
+
+static inline void host1x_bo_munmap(struct host1x_bo *bo, void *addr)
+{
+	bo->ops->munmap(bo, addr);
+}
+
+static inline void *host1x_bo_kmap(struct host1x_bo *bo, unsigned int pagenum)
+{
+	return bo->ops->kmap(bo, pagenum);
+}
+
+static inline void host1x_bo_kunmap(struct host1x_bo *bo,
+				    unsigned int pagenum, void *addr)
+{
+	bo->ops->kunmap(bo, pagenum, addr);
+}
+
+#endif
diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
new file mode 100644
index 0000000..4eb22ef
--- /dev/null
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -0,0 +1,324 @@
+/*
+ * Tegra host1x Command DMA
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
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+
+#include "cdma.h"
+#include "channel.h"
+#include "dev.h"
+#include "debug.h"
+
+/*
+ * Put the restart at the end of pushbuffer memor
+ */
+static void push_buffer_init(struct push_buffer *pb)
+{
+	*(pb->mapped + (pb->size_bytes >> 2)) = host1x_opcode_restart(0);
+}
+
+/*
+ * Increment timedout buffer's syncpt via CPU.
+ */
+static void cdma_timeout_cpu_incr(struct host1x_cdma *cdma, u32 getptr,
+				u32 syncpt_incrs, u32 syncval, u32 nr_slots)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct push_buffer *pb = &cdma->push_buffer;
+	u32 i;
+
+	for (i = 0; i < syncpt_incrs; i++)
+		host1x_syncpt_cpu_incr(cdma->timeout.syncpt);
+
+	/* after CPU incr, ensure shadow is up to date */
+	host1x_syncpt_load(cdma->timeout.syncpt);
+
+	/* NOP all the PB slots */
+	while (nr_slots--) {
+		u32 *p = (u32 *)((u32)pb->mapped + getptr);
+		*(p++) = HOST1X_OPCODE_NOP;
+		*(p++) = HOST1X_OPCODE_NOP;
+		dev_dbg(host1x->dev, "%s: NOP at 0x%x\n", __func__,
+			pb->phys + getptr);
+		getptr = (getptr + 8) & (pb->size_bytes - 1);
+	}
+	wmb();
+}
+
+/*
+ * Start channel DMA
+ */
+static void cdma_start(struct host1x_cdma *cdma)
+{
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+
+	if (cdma->running)
+		return;
+
+	cdma->last_pos = cdma->push_buffer.pos;
+
+	host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP,
+			 HOST1X_CHANNEL_DMACTRL);
+
+	/* set base, put and end pointer */
+	host1x_ch_writel(ch, cdma->push_buffer.phys, HOST1X_CHANNEL_DMASTART);
+	host1x_ch_writel(ch, cdma->push_buffer.pos, HOST1X_CHANNEL_DMAPUT);
+	host1x_ch_writel(ch, cdma->push_buffer.phys +
+			 cdma->push_buffer.size_bytes + 4,
+			 HOST1X_CHANNEL_DMAEND);
+
+	/* reset GET */
+	host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP |
+			 HOST1X_CHANNEL_DMACTRL_DMAGETRST |
+			 HOST1X_CHANNEL_DMACTRL_DMAINITGET,
+			 HOST1X_CHANNEL_DMACTRL);
+
+	/* start the command DMA */
+	host1x_ch_writel(ch, 0, HOST1X_CHANNEL_DMACTRL);
+
+	cdma->running = true;
+}
+
+/*
+ * Similar to cdma_start(), but rather than starting from an idle
+ * state (where DMA GET is set to DMA PUT), on a timeout we restore
+ * DMA GET from an explicit value (so DMA may again be pending).
+ */
+static void cdma_timeout_restart(struct host1x_cdma *cdma, u32 getptr)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+
+	if (cdma->running)
+		return;
+
+	cdma->last_pos = cdma->push_buffer.pos;
+
+	host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP,
+			 HOST1X_CHANNEL_DMACTRL);
+
+	/* set base, end pointer (all of memory) */
+	host1x_ch_writel(ch, cdma->push_buffer.phys, HOST1X_CHANNEL_DMASTART);
+	host1x_ch_writel(ch, cdma->push_buffer.phys +
+			 cdma->push_buffer.size_bytes,
+			 HOST1X_CHANNEL_DMAEND);
+
+	/* set GET, by loading the value in PUT (then reset GET) */
+	host1x_ch_writel(ch, getptr, HOST1X_CHANNEL_DMAPUT);
+	host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP |
+			 HOST1X_CHANNEL_DMACTRL_DMAGETRST |
+			 HOST1X_CHANNEL_DMACTRL_DMAINITGET,
+			 HOST1X_CHANNEL_DMACTRL);
+
+	dev_dbg(host1x->dev,
+		"%s: DMA GET 0x%x, PUT HW 0x%x / shadow 0x%x\n", __func__,
+		host1x_ch_readl(ch, HOST1X_CHANNEL_DMAGET),
+		host1x_ch_readl(ch, HOST1X_CHANNEL_DMAPUT),
+		cdma->last_pos);
+
+	/* deassert GET reset and set PUT */
+	host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP,
+			 HOST1X_CHANNEL_DMACTRL);
+	host1x_ch_writel(ch, cdma->push_buffer.pos, HOST1X_CHANNEL_DMAPUT);
+
+	/* start the command DMA */
+	host1x_ch_writel(ch, 0, HOST1X_CHANNEL_DMACTRL);
+
+	cdma->running = true;
+}
+
+/*
+ * Kick channel DMA into action by writing its PUT offset (if it has changed)
+ */
+static void cdma_flush(struct host1x_cdma *cdma)
+{
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+
+	if (cdma->push_buffer.pos != cdma->last_pos) {
+		host1x_ch_writel(ch, cdma->push_buffer.pos,
+				 HOST1X_CHANNEL_DMAPUT);
+		cdma->last_pos = cdma->push_buffer.pos;
+	}
+}
+
+static void cdma_stop(struct host1x_cdma *cdma)
+{
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+
+	mutex_lock(&cdma->lock);
+	if (cdma->running) {
+		host1x_cdma_wait_locked(cdma, CDMA_EVENT_SYNC_QUEUE_EMPTY);
+		host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP,
+				 HOST1X_CHANNEL_DMACTRL);
+		cdma->running = false;
+	}
+	mutex_unlock(&cdma->lock);
+}
+
+/*
+ * Stops both channel's command processor and CDMA immediately.
+ * Also, tears down the channel and resets corresponding module.
+ */
+static void cdma_freeze(struct host1x_cdma *cdma)
+{
+	struct host1x *host = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+	u32 cmdproc_stop;
+
+	if (cdma->torndown && !cdma->running) {
+		dev_warn(host->dev, "Already torn down\n");
+		return;
+	}
+
+	dev_dbg(host->dev, "freezing channel (id %d)\n", ch->id);
+
+	cmdproc_stop = host1x_sync_readl(host, HOST1X_SYNC_CMDPROC_STOP);
+	cmdproc_stop |= BIT(ch->id);
+	host1x_sync_writel(host, cmdproc_stop, HOST1X_SYNC_CMDPROC_STOP);
+
+	dev_dbg(host->dev, "%s: DMA GET 0x%x, PUT HW 0x%x / shadow 0x%x\n",
+		__func__, host1x_ch_readl(ch, HOST1X_CHANNEL_DMAGET),
+		host1x_ch_readl(ch, HOST1X_CHANNEL_DMAPUT),
+		cdma->last_pos);
+
+	host1x_ch_writel(ch, HOST1X_CHANNEL_DMACTRL_DMASTOP,
+			 HOST1X_CHANNEL_DMACTRL);
+
+	host1x_sync_writel(host, BIT(ch->id), HOST1X_SYNC_CH_TEARDOWN);
+
+	cdma->running = false;
+	cdma->torndown = true;
+}
+
+static void cdma_resume(struct host1x_cdma *cdma, u32 getptr)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+	u32 cmdproc_stop;
+
+	dev_dbg(host1x->dev,
+		"resuming channel (id %d, DMAGET restart = 0x%x)\n",
+		ch->id, getptr);
+
+	cmdproc_stop = host1x_sync_readl(host1x, HOST1X_SYNC_CMDPROC_STOP);
+	cmdproc_stop &= ~(BIT(ch->id));
+	host1x_sync_writel(host1x, cmdproc_stop, HOST1X_SYNC_CMDPROC_STOP);
+
+	cdma->torndown = false;
+	cdma_timeout_restart(cdma, getptr);
+}
+
+/*
+ * If this timeout fires, it indicates the current sync_queue entry has
+ * exceeded its TTL and the userctx should be timed out and remaining
+ * submits already issued cleaned up (future submits return an error).
+ */
+static void cdma_timeout_handler(struct work_struct *work)
+{
+	struct host1x_cdma *cdma;
+	struct host1x *host1x;
+	struct host1x_channel *ch;
+
+	u32 syncpt_val;
+
+	u32 prev_cmdproc, cmdproc_stop;
+
+	cdma = container_of(to_delayed_work(work), struct host1x_cdma,
+			    timeout.wq);
+	host1x = cdma_to_host1x(cdma);
+	ch = cdma_to_channel(cdma);
+
+	mutex_lock(&cdma->lock);
+
+	if (!cdma->timeout.client) {
+		dev_dbg(host1x->dev,
+			"cdma_timeout: expired, but has no clientid\n");
+		mutex_unlock(&cdma->lock);
+		return;
+	}
+
+	/* stop processing to get a clean snapshot */
+	prev_cmdproc = host1x_sync_readl(host1x, HOST1X_SYNC_CMDPROC_STOP);
+	cmdproc_stop = prev_cmdproc | BIT(ch->id);
+	host1x_sync_writel(host1x, cmdproc_stop, HOST1X_SYNC_CMDPROC_STOP);
+
+	dev_dbg(host1x->dev, "cdma_timeout: cmdproc was 0x%x is 0x%x\n",
+		prev_cmdproc, cmdproc_stop);
+
+	syncpt_val = host1x_syncpt_load(cdma->timeout.syncpt);
+
+	/* has buffer actually completed? */
+	if ((s32)(syncpt_val - cdma->timeout.syncpt_val) >= 0) {
+		dev_dbg(host1x->dev,
+			"cdma_timeout: expired, but buffer had completed\n");
+		/* restore */
+		cmdproc_stop = prev_cmdproc & ~(BIT(ch->id));
+		host1x_sync_writel(host1x, cmdproc_stop,
+				   HOST1X_SYNC_CMDPROC_STOP);
+		mutex_unlock(&cdma->lock);
+		return;
+	}
+
+	dev_warn(host1x->dev, "%s: timeout: %d (%s), HW thresh %d, done %d\n",
+		__func__, cdma->timeout.syncpt->id, cdma->timeout.syncpt->name,
+		syncpt_val, cdma->timeout.syncpt_val);
+
+	/* stop HW, resetting channel/module */
+	host1x_hw_cdma_freeze(host1x, cdma);
+
+	host1x_cdma_update_sync_queue(cdma, ch->dev);
+	mutex_unlock(&cdma->lock);
+}
+
+/*
+ * Init timeout resources
+ */
+static int cdma_timeout_init(struct host1x_cdma *cdma, u32 syncpt_id)
+{
+	INIT_DELAYED_WORK(&cdma->timeout.wq, cdma_timeout_handler);
+	cdma->timeout.initialized = true;
+
+	return 0;
+}
+
+/*
+ * Clean up timeout resources
+ */
+static void cdma_timeout_destroy(struct host1x_cdma *cdma)
+{
+	if (cdma->timeout.initialized)
+		cancel_delayed_work(&cdma->timeout.wq);
+	cdma->timeout.initialized = false;
+}
+
+static const struct host1x_cdma_ops host1x_cdma_ops = {
+	.start = cdma_start,
+	.stop = cdma_stop,
+	.flush = cdma_flush,
+
+	.timeout_init = cdma_timeout_init,
+	.timeout_destroy = cdma_timeout_destroy,
+	.freeze = cdma_freeze,
+	.resume = cdma_resume,
+	.timeout_cpu_incr = cdma_timeout_cpu_incr,
+};
+
+static const struct host1x_pushbuffer_ops host1x_pushbuffer_ops = {
+	.init = push_buffer_init,
+};
diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
new file mode 100644
index 0000000..5137a56
--- /dev/null
+++ b/drivers/gpu/host1x/hw/channel_hw.c
@@ -0,0 +1,143 @@
+/*
+ * Tegra host1x Channel
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
+#include <linux/slab.h>
+#include <trace/events/host1x.h>
+
+#include "host1x.h"
+#include "host1x_bo.h"
+#include "channel.h"
+#include "dev.h"
+#include "intr.h"
+#include "job.h"
+
+#define HOST1X_CHANNEL_SIZE 16384
+#define TRACE_MAX_LENGTH 128U
+
+static void submit_gathers(struct host1x_job *job)
+{
+	struct host1x_cdma *cdma = &job->channel->cdma;
+	unsigned int i;
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		u32 op1 = host1x_opcode_gather(g->words);
+		u32 op2 = g->base + g->offset;
+		host1x_cdma_push(cdma, op1, op2);
+	}
+}
+
+static int channel_submit(struct host1x_job *job)
+{
+	struct host1x_channel *ch = job->channel;
+	struct host1x_syncpt *sp;
+	u32 user_syncpt_incrs = job->syncpt_incrs;
+	u32 prev_max = 0;
+	u32 syncval;
+	int err;
+	struct host1x_waitlist *completed_waiter = NULL;
+	struct host1x *host = dev_get_drvdata(ch->dev->parent);
+
+	sp = host->syncpt + job->syncpt_id;
+	trace_host1x_channel_submit(dev_name(ch->dev),
+				    job->num_gathers, job->num_relocs,
+				    job->num_waitchk, job->syncpt_id,
+				    job->syncpt_incrs);
+
+	/* before error checks, return current max */
+	prev_max = job->syncpt_end = host1x_syncpt_read_max(sp);
+
+	/* get submit lock */
+	err = mutex_lock_interruptible(&ch->submitlock);
+	if (err)
+		goto error;
+
+	completed_waiter = kzalloc(sizeof(*completed_waiter), GFP_KERNEL);
+	if (!completed_waiter) {
+		mutex_unlock(&ch->submitlock);
+		err = -ENOMEM;
+		goto error;
+	}
+
+	/* begin a CDMA submit */
+	err = host1x_cdma_begin(&ch->cdma, job);
+	if (err) {
+		mutex_unlock(&ch->submitlock);
+		goto error;
+	}
+
+	if (job->serialize) {
+		/*
+		 * Force serialization by inserting a host wait for the
+		 * previous job to finish before this one can commence.
+		 */
+		host1x_cdma_push(&ch->cdma,
+				 host1x_opcode_setclass(HOST1X_CLASS_HOST1X,
+					host1x_uclass_wait_syncpt_r(), 1),
+				 host1x_class_host_wait_syncpt(job->syncpt_id,
+					host1x_syncpt_read_max(sp)));
+	}
+
+	syncval = host1x_syncpt_incr_max(sp, user_syncpt_incrs);
+
+	job->syncpt_end = syncval;
+
+	/* add a setclass for modules that require it */
+	if (job->class)
+		host1x_cdma_push(&ch->cdma,
+				 host1x_opcode_setclass(job->class, 0, 0),
+				 HOST1X_OPCODE_NOP);
+
+	submit_gathers(job);
+
+	/* end CDMA submit & stash pinned hMems into sync queue */
+	host1x_cdma_end(&ch->cdma, job);
+
+	trace_host1x_channel_submitted(dev_name(ch->dev), prev_max, syncval);
+
+	/* schedule a submit complete interrupt */
+	err = host1x_intr_add_action(host, job->syncpt_id, syncval,
+				     HOST1X_INTR_ACTION_SUBMIT_COMPLETE, ch,
+				     completed_waiter, NULL);
+	completed_waiter = NULL;
+	WARN(err, "Failed to set submit complete interrupt");
+
+	mutex_unlock(&ch->submitlock);
+
+	return 0;
+
+error:
+	kfree(completed_waiter);
+	return err;
+}
+
+static int host1x_channel_init(struct host1x_channel *ch, struct host1x *dev,
+			       unsigned int index)
+{
+	ch->id = index;
+	mutex_init(&ch->reflock);
+	mutex_init(&ch->submitlock);
+
+	ch->regs = dev->regs + index * HOST1X_CHANNEL_SIZE;
+	return 0;
+}
+
+static const struct host1x_channel_ops host1x_channel_ops = {
+	.init = host1x_channel_init,
+	.submit = channel_submit,
+};
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
index f5c35fa..013ff38 100644
--- a/drivers/gpu/host1x/hw/host1x01.c
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -21,6 +21,8 @@
 #include "hw/host1x01_hardware.h"
 
 /* include code */
+#include "hw/cdma_hw.c"
+#include "hw/channel_hw.c"
 #include "hw/intr_hw.c"
 #include "hw/syncpt_hw.c"
 
@@ -28,6 +30,9 @@
 
 int host1x01_init(struct host1x *host)
 {
+	host->channel_op = &host1x_channel_ops;
+	host->cdma_op = &host1x_cdma_ops;
+	host->cdma_pb_op = &host1x_pushbuffer_ops;
 	host->syncpt_op = &host1x_syncpt_ops;
 	host->intr_op = &host1x_intr_ops;
 
diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
index 8cecbee..5f0fb86 100644
--- a/drivers/gpu/host1x/hw/host1x01_hardware.h
+++ b/drivers/gpu/host1x/hw/host1x01_hardware.h
@@ -22,6 +22,122 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 
+#include "hw_host1x01_channel.h"
 #include "hw_host1x01_sync.h"
+#include "hw_host1x01_uclass.h"
+
+static inline u32 host1x_class_host_wait_syncpt(
+	unsigned indx, unsigned threshold)
+{
+	return host1x_uclass_wait_syncpt_indx_f(indx)
+		| host1x_uclass_wait_syncpt_thresh_f(threshold);
+}
+
+static inline u32 host1x_class_host_load_syncpt_base(
+	unsigned indx, unsigned threshold)
+{
+	return host1x_uclass_load_syncpt_base_base_indx_f(indx)
+		| host1x_uclass_load_syncpt_base_value_f(threshold);
+}
+
+static inline u32 host1x_class_host_wait_syncpt_base(
+	unsigned indx, unsigned base_indx, unsigned offset)
+{
+	return host1x_uclass_wait_syncpt_base_indx_f(indx)
+		| host1x_uclass_wait_syncpt_base_base_indx_f(base_indx)
+		| host1x_uclass_wait_syncpt_base_offset_f(offset);
+}
+
+static inline u32 host1x_class_host_incr_syncpt_base(
+	unsigned base_indx, unsigned offset)
+{
+	return host1x_uclass_incr_syncpt_base_base_indx_f(base_indx)
+		| host1x_uclass_incr_syncpt_base_offset_f(offset);
+}
+
+static inline u32 host1x_class_host_incr_syncpt(
+	unsigned cond, unsigned indx)
+{
+	return host1x_uclass_incr_syncpt_cond_f(cond)
+		| host1x_uclass_incr_syncpt_indx_f(indx);
+}
+
+static inline u32 host1x_class_host_indoff_reg_write(
+	unsigned mod_id, unsigned offset, bool auto_inc)
+{
+	u32 v = host1x_uclass_indoff_indbe_f(0xf)
+		| host1x_uclass_indoff_indmodid_f(mod_id)
+		| host1x_uclass_indoff_indroffset_f(offset);
+	if (auto_inc)
+		v |= host1x_uclass_indoff_autoinc_f(1);
+	return v;
+}
+
+static inline u32 host1x_class_host_indoff_reg_read(
+	unsigned mod_id, unsigned offset, bool auto_inc)
+{
+	u32 v = host1x_uclass_indoff_indmodid_f(mod_id)
+		| host1x_uclass_indoff_indroffset_f(offset)
+		| host1x_uclass_indoff_rwn_read_v();
+	if (auto_inc)
+		v |= host1x_uclass_indoff_autoinc_f(1);
+	return v;
+}
+
+
+/* cdma opcodes */
+static inline u32 host1x_opcode_setclass(
+	unsigned class_id, unsigned offset, unsigned mask)
+{
+	return (0 << 28) | (offset << 16) | (class_id << 6) | mask;
+}
+
+static inline u32 host1x_opcode_incr(unsigned offset, unsigned count)
+{
+	return (1 << 28) | (offset << 16) | count;
+}
+
+static inline u32 host1x_opcode_nonincr(unsigned offset, unsigned count)
+{
+	return (2 << 28) | (offset << 16) | count;
+}
+
+static inline u32 host1x_opcode_mask(unsigned offset, unsigned mask)
+{
+	return (3 << 28) | (offset << 16) | mask;
+}
+
+static inline u32 host1x_opcode_imm(unsigned offset, unsigned value)
+{
+	return (4 << 28) | (offset << 16) | value;
+}
+
+static inline u32 host1x_opcode_imm_incr_syncpt(unsigned cond, unsigned indx)
+{
+	return host1x_opcode_imm(host1x_uclass_incr_syncpt_r(),
+		host1x_class_host_incr_syncpt(cond, indx));
+}
+
+static inline u32 host1x_opcode_restart(unsigned address)
+{
+	return (5 << 28) | (address >> 4);
+}
+
+static inline u32 host1x_opcode_gather(unsigned count)
+{
+	return (6 << 28) | count;
+}
+
+static inline u32 host1x_opcode_gather_nonincr(unsigned offset,	unsigned count)
+{
+	return (6 << 28) | (offset << 16) | BIT(15) | count;
+}
+
+static inline u32 host1x_opcode_gather_incr(unsigned offset, unsigned count)
+{
+	return (6 << 28) | (offset << 16) | BIT(15) | BIT(14) | count;
+}
+
+#define HOST1X_OPCODE_NOP host1x_opcode_nonincr(0, 0)
 
 #endif
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_channel.h b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
new file mode 100644
index 0000000..9ba1332
--- /dev/null
+++ b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
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
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_channel_host1x_h__
+#define __hw_host1x_channel_host1x_h__
+
+static inline u32 host1x_channel_dmastart_r(void)
+{
+	return 0x14;
+}
+#define HOST1X_CHANNEL_DMASTART \
+	host1x_channel_dmastart_r()
+static inline u32 host1x_channel_dmaput_r(void)
+{
+	return 0x18;
+}
+#define HOST1X_CHANNEL_DMAPUT \
+	host1x_channel_dmaput_r()
+static inline u32 host1x_channel_dmaget_r(void)
+{
+	return 0x1c;
+}
+#define HOST1X_CHANNEL_DMAGET \
+	host1x_channel_dmaget_r()
+static inline u32 host1x_channel_dmaend_r(void)
+{
+	return 0x20;
+}
+#define HOST1X_CHANNEL_DMAEND \
+	host1x_channel_dmaend_r()
+static inline u32 host1x_channel_dmactrl_r(void)
+{
+	return 0x24;
+}
+#define HOST1X_CHANNEL_DMACTRL \
+	host1x_channel_dmactrl_r()
+static inline u32 host1x_channel_dmactrl_dmastop(void)
+{
+	return 1 << 0;
+}
+#define HOST1X_CHANNEL_DMACTRL_DMASTOP \
+	host1x_channel_dmactrl_dmastop()
+static inline u32 host1x_channel_dmactrl_dmagetrst(void)
+{
+	return 1 << 1;
+}
+#define HOST1X_CHANNEL_DMACTRL_DMAGETRST \
+	host1x_channel_dmactrl_dmagetrst()
+static inline u32 host1x_channel_dmactrl_dmainitget(void)
+{
+	return 1 << 2;
+}
+#define HOST1X_CHANNEL_DMACTRL_DMAINITGET \
+	host1x_channel_dmactrl_dmainitget()
+#endif
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
index eea0bb0..8f2a246 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_sync.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -77,6 +77,18 @@ static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(unsigned int id)
 }
 #define HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0(id) \
 	host1x_sync_syncpt_thresh_int_enable_cpu0_r(id)
+static inline u32 host1x_sync_cmdproc_stop_r(void)
+{
+	return 0xac;
+}
+#define HOST1X_SYNC_CMDPROC_STOP \
+	host1x_sync_cmdproc_stop_r()
+static inline u32 host1x_sync_ch_teardown_r(void)
+{
+	return 0xb0;
+}
+#define HOST1X_SYNC_CH_TEARDOWN \
+	host1x_sync_ch_teardown_r()
 static inline u32 host1x_sync_usec_clk_r(void)
 {
 	return 0x1a4;
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
new file mode 100644
index 0000000..7af6609
--- /dev/null
+++ b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
@@ -0,0 +1,168 @@
+/*
+ * Copyright (c) 2012-2013, NVIDIA Corporation.
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
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_uclass_host1x_h__
+#define __hw_host1x_uclass_host1x_h__
+
+static inline u32 host1x_uclass_incr_syncpt_r(void)
+{
+	return 0x0;
+}
+#define HOST1X_UCLASS_INCR_SYNCPT \
+	host1x_uclass_incr_syncpt_r()
+static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
+{
+	return (v & 0xff) << 8;
+}
+#define HOST1X_UCLASS_INCR_SYNCPT_COND_F(v) \
+	host1x_uclass_incr_syncpt_cond_f(v)
+static inline u32 host1x_uclass_incr_syncpt_indx_f(u32 v)
+{
+	return (v & 0xff) << 0;
+}
+#define HOST1X_UCLASS_INCR_SYNCPT_INDX_F(v) \
+	host1x_uclass_incr_syncpt_indx_f(v)
+static inline u32 host1x_uclass_wait_syncpt_r(void)
+{
+	return 0x8;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT \
+	host1x_uclass_wait_syncpt_r()
+static inline u32 host1x_uclass_wait_syncpt_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT_INDX_F(v) \
+	host1x_uclass_wait_syncpt_indx_f(v)
+static inline u32 host1x_uclass_wait_syncpt_thresh_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT_THRESH_F(v) \
+	host1x_uclass_wait_syncpt_thresh_f(v)
+static inline u32 host1x_uclass_wait_syncpt_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT_BASE_INDX_F(v) \
+	host1x_uclass_wait_syncpt_base_indx_f(v)
+static inline u32 host1x_uclass_wait_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 16;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT_BASE_BASE_INDX_F(v) \
+	host1x_uclass_wait_syncpt_base_base_indx_f(v)
+static inline u32 host1x_uclass_wait_syncpt_base_offset_f(u32 v)
+{
+	return (v & 0xffff) << 0;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT_BASE_OFFSET_F(v) \
+	host1x_uclass_wait_syncpt_base_offset_f(v)
+static inline u32 host1x_uclass_load_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+#define HOST1X_UCLASS_LOAD_SYNCPT_BASE_BASE_INDX_F(v) \
+	host1x_uclass_load_syncpt_base_base_indx_f(v)
+static inline u32 host1x_uclass_load_syncpt_base_value_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+#define HOST1X_UCLASS_LOAD_SYNCPT_BASE_VALUE_F(v) \
+	host1x_uclass_load_syncpt_base_value_f(v)
+static inline u32 host1x_uclass_incr_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+#define HOST1X_UCLASS_INCR_SYNCPT_BASE_BASE_INDX_F(v) \
+	host1x_uclass_incr_syncpt_base_base_indx_f(v)
+static inline u32 host1x_uclass_incr_syncpt_base_offset_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+#define HOST1X_UCLASS_INCR_SYNCPT_BASE_OFFSET_F(v) \
+	host1x_uclass_incr_syncpt_base_offset_f(v)
+static inline u32 host1x_uclass_indoff_r(void)
+{
+	return 0x2d;
+}
+#define HOST1X_UCLASS_INDOFF \
+	host1x_uclass_indoff_r()
+static inline u32 host1x_uclass_indoff_indbe_f(u32 v)
+{
+	return (v & 0xf) << 28;
+}
+#define HOST1X_UCLASS_INDOFF_INDBE_F(v) \
+	host1x_uclass_indoff_indbe_f(v)
+static inline u32 host1x_uclass_indoff_autoinc_f(u32 v)
+{
+	return (v & 0x1) << 27;
+}
+#define HOST1X_UCLASS_INDOFF_AUTOINC_F(v) \
+	host1x_uclass_indoff_autoinc_f(v)
+static inline u32 host1x_uclass_indoff_indmodid_f(u32 v)
+{
+	return (v & 0xff) << 18;
+}
+#define HOST1X_UCLASS_INDOFF_INDMODID_F(v) \
+	host1x_uclass_indoff_indmodid_f(v)
+static inline u32 host1x_uclass_indoff_indroffset_f(u32 v)
+{
+	return (v & 0xffff) << 2;
+}
+#define HOST1X_UCLASS_INDOFF_INDROFFSET_F(v) \
+	host1x_uclass_indoff_indroffset_f(v)
+static inline u32 host1x_uclass_indoff_rwn_read_v(void)
+{
+	return 1;
+}
+#define HOST1X_UCLASS_INDOFF_INDROFFSET_F(v) \
+	host1x_uclass_indoff_indroffset_f(v)
+#endif
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index 885b257..2c1f4af 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -93,10 +93,21 @@ static void syncpt_cpu_incr(struct host1x_syncpt *sp)
 	wmb();
 }
 
+/* remove a wait pointed to by patch_addr */
+static int syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
+{
+	u32 override = host1x_class_host_wait_syncpt(
+		HOST1X_SYNCPT_RESERVED, 0);
+
+	*((u32 *)patch_addr) = override;
+	return 0;
+}
+
 static const struct host1x_syncpt_ops host1x_syncpt_ops = {
 	.restore = syncpt_restore,
 	.restore_wait_base = syncpt_restore_wait_base,
 	.load_wait_base = syncpt_read_wait_base,
 	.load = syncpt_load,
 	.cpu_incr = syncpt_cpu_incr,
+	.patch_wait = syncpt_patch_wait,
 };
diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
index b1b5a80..2491bf8 100644
--- a/drivers/gpu/host1x/intr.c
+++ b/drivers/gpu/host1x/intr.c
@@ -21,6 +21,8 @@
 #include <linux/slab.h>
 #include <linux/irq.h>
 
+#include <trace/events/host1x.h>
+#include "channel.h"
 #include "dev.h"
 #include "intr.h"
 
@@ -66,7 +68,7 @@ static void remove_completed_waiters(struct list_head *head, u32 sync,
 			struct list_head completed[HOST1X_INTR_ACTION_COUNT])
 {
 	struct list_head *dest;
-	struct host1x_waitlist *waiter, *next;
+	struct host1x_waitlist *waiter, *next, *prev;
 
 	list_for_each_entry_safe(waiter, next, head, list) {
 		if ((s32)(waiter->thresh - sync) > 0)
@@ -74,6 +76,17 @@ static void remove_completed_waiters(struct list_head *head, u32 sync,
 
 		dest = completed + waiter->action;
 
+		/* consolidate submit cleanups */
+		if (waiter->action == HOST1X_INTR_ACTION_SUBMIT_COMPLETE &&
+		    !list_empty(dest)) {
+			prev = list_entry(dest->prev,
+					  struct host1x_waitlist, list);
+			if (prev->data == waiter->data) {
+				prev->count++;
+				dest = NULL;
+			}
+		}
+
 		/* PENDING->REMOVED or CANCELLED->HANDLED */
 		if (atomic_inc_return(&waiter->state) == WLS_HANDLED || !dest) {
 			list_del(&waiter->list);
@@ -94,6 +107,18 @@ static void reset_threshold_interrupt(struct host1x *host,
 	host1x_hw_intr_enable_syncpt_intr(host, id);
 }
 
+static void action_submit_complete(struct host1x_waitlist *waiter)
+{
+	struct host1x_channel *channel = waiter->data;
+
+	host1x_cdma_update(&channel->cdma);
+
+	/*  Add nr_completed to trace */
+	trace_host1x_channel_submit_complete(dev_name(channel->dev),
+					     waiter->count, waiter->thresh);
+
+}
+
 static void action_wakeup(struct host1x_waitlist *waiter)
 {
 	wait_queue_head_t *wq = waiter->data;
@@ -109,6 +134,7 @@ static void action_wakeup_interruptible(struct host1x_waitlist *waiter)
 typedef void (*action_handler)(struct host1x_waitlist *waiter);
 
 static action_handler action_handlers[HOST1X_INTR_ACTION_COUNT] = {
+	action_submit_complete,
 	action_wakeup,
 	action_wakeup_interruptible,
 };
diff --git a/drivers/gpu/host1x/intr.h b/drivers/gpu/host1x/intr.h
index a3f06ab..2b8adf0 100644
--- a/drivers/gpu/host1x/intr.h
+++ b/drivers/gpu/host1x/intr.h
@@ -26,6 +26,12 @@ struct host1x;
 
 enum host1x_intr_action {
 	/*
+	 * Perform cleanup after a submit has completed.
+	 * 'data' points to a channel
+	 */
+	HOST1X_INTR_ACTION_SUBMIT_COMPLETE = 0,
+
+	/*
 	 * Wake up a  task.
 	 * 'data' points to a wait_queue_head_t
 	 */
diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
new file mode 100644
index 0000000..f665d67
--- /dev/null
+++ b/drivers/gpu/host1x/job.c
@@ -0,0 +1,603 @@
+/*
+ * Tegra host1x Job
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
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/kref.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <trace/events/host1x.h>
+
+#include "channel.h"
+#include "dev.h"
+#include "host1x_bo.h"
+#include "job.h"
+#include "syncpt.h"
+
+struct host1x_job *host1x_job_alloc(struct host1x_channel *ch,
+				    u32 num_cmdbufs, u32 num_relocs,
+				    u32 num_waitchks)
+{
+	struct host1x_job *job = NULL;
+	unsigned int num_unpins = num_cmdbufs + num_relocs;
+	u64 total;
+	void *mem;
+
+	/* Check that we're not going to overflow */
+	total = sizeof(struct host1x_job) +
+		num_relocs * sizeof(struct host1x_reloc) +
+		num_unpins * sizeof(struct host1x_job_unpin_data) +
+		num_waitchks * sizeof(struct host1x_waitchk) +
+		num_cmdbufs * sizeof(struct host1x_job_gather) +
+		num_unpins * sizeof(dma_addr_t) +
+		num_unpins * sizeof(u32 *);
+	if (total > ULONG_MAX)
+		return NULL;
+
+	mem = job = kzalloc(total, GFP_KERNEL);
+	if (!job)
+		return NULL;
+
+	kref_init(&job->ref);
+	job->channel = ch;
+
+	/* Redistribute memory to the structs  */
+	mem += sizeof(struct host1x_job);
+	job->relocarray = num_relocs ? mem : NULL;
+	mem += num_relocs * sizeof(struct host1x_reloc);
+	job->unpins = num_unpins ? mem : NULL;
+	mem += num_unpins * sizeof(struct host1x_job_unpin_data);
+	job->waitchk = num_waitchks ? mem : NULL;
+	mem += num_waitchks * sizeof(struct host1x_waitchk);
+	job->gathers = num_cmdbufs ? mem : NULL;
+	mem += num_cmdbufs * sizeof(struct host1x_job_gather);
+	job->addr_phys = num_unpins ? mem : NULL;
+
+	job->reloc_addr_phys = job->addr_phys;
+	job->gather_addr_phys = &job->addr_phys[num_relocs];
+
+	return job;
+}
+
+struct host1x_job *host1x_job_get(struct host1x_job *job)
+{
+	kref_get(&job->ref);
+	return job;
+}
+
+static void job_free(struct kref *ref)
+{
+	struct host1x_job *job = container_of(ref, struct host1x_job, ref);
+
+	kfree(job);
+}
+
+void host1x_job_put(struct host1x_job *job)
+{
+	kref_put(&job->ref, job_free);
+}
+
+void host1x_job_add_gather(struct host1x_job *job, struct host1x_bo *bo,
+			   u32 words, u32 offset)
+{
+	struct host1x_job_gather *cur_gather = &job->gathers[job->num_gathers];
+
+	cur_gather->words = words;
+	cur_gather->bo = bo;
+	cur_gather->offset = offset;
+	job->num_gathers++;
+}
+
+/*
+ * NULL an already satisfied WAIT_SYNCPT host method, by patching its
+ * args in the command stream. The method data is changed to reference
+ * a reserved (never given out or incr) HOST1X_SYNCPT_RESERVED syncpt
+ * with a matching threshold value of 0, so is guaranteed to be popped
+ * by the host HW.
+ */
+static void host1x_syncpt_patch_offset(struct host1x_syncpt *sp,
+				       struct host1x_bo *h, u32 offset)
+{
+	void *patch_addr = NULL;
+
+	/* patch the wait */
+	patch_addr = host1x_bo_kmap(h, offset >> PAGE_SHIFT);
+	if (patch_addr) {
+		host1x_syncpt_patch_wait(sp,
+					 patch_addr + (offset & ~PAGE_MASK));
+		host1x_bo_kunmap(h, offset >> PAGE_SHIFT, patch_addr);
+	} else
+		pr_err("Could not map cmdbuf for wait check\n");
+}
+
+/*
+ * Check driver supplied waitchk structs for syncpt thresholds
+ * that have already been satisfied and NULL the comparison (to
+ * avoid a wrap condition in the HW).
+ */
+static int do_waitchks(struct host1x_job *job, struct host1x *host,
+		       struct host1x_bo *patch)
+{
+	int i;
+
+	/* compare syncpt vs wait threshold */
+	for (i = 0; i < job->num_waitchk; i++) {
+		struct host1x_waitchk *wait = &job->waitchk[i];
+		struct host1x_syncpt *sp =
+			host1x_syncpt_get(host, wait->syncpt_id);
+
+		/* validate syncpt id */
+		if (wait->syncpt_id > host1x_syncpt_nb_pts(host))
+			continue;
+
+		/* skip all other gathers */
+		if (patch != wait->bo)
+			continue;
+
+		trace_host1x_syncpt_wait_check(wait->bo, wait->offset,
+					       wait->syncpt_id, wait->thresh,
+					       host1x_syncpt_read_min(sp));
+
+		if (host1x_syncpt_is_expired(sp, wait->thresh)) {
+			dev_dbg(host->dev,
+				"drop WAIT id %d (%s) thresh 0x%x, min 0x%x\n",
+				wait->syncpt_id, sp->name, wait->thresh,
+				host1x_syncpt_read_min(sp));
+
+			host1x_syncpt_patch_offset(sp, patch, wait->offset);
+		}
+
+		wait->bo = NULL;
+	}
+
+	return 0;
+}
+
+static unsigned int pin_job(struct host1x_job *job)
+{
+	unsigned int i;
+
+	job->num_unpins = 0;
+
+	for (i = 0; i < job->num_relocs; i++) {
+		struct host1x_reloc *reloc = &job->relocarray[i];
+		struct sg_table *sgt;
+		dma_addr_t phys_addr;
+
+		reloc->target = host1x_bo_get(reloc->target);
+		if (!reloc->target)
+			goto unpin;
+
+		phys_addr = host1x_bo_pin(reloc->target, &sgt);
+		if (!phys_addr)
+			goto unpin;
+
+		job->addr_phys[job->num_unpins] = phys_addr;
+		job->unpins[job->num_unpins].bo = reloc->target;
+		job->unpins[job->num_unpins].sgt = sgt;
+		job->num_unpins++;
+	}
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		struct sg_table *sgt;
+		dma_addr_t phys_addr;
+
+		g->bo = host1x_bo_get(g->bo);
+		if (!g->bo)
+			goto unpin;
+
+		phys_addr = host1x_bo_pin(g->bo, &sgt);
+		if (!phys_addr)
+			goto unpin;
+
+		job->addr_phys[job->num_unpins] = phys_addr;
+		job->unpins[job->num_unpins].bo = g->bo;
+		job->unpins[job->num_unpins].sgt = sgt;
+		job->num_unpins++;
+	}
+
+	return job->num_unpins;
+
+unpin:
+	host1x_job_unpin(job);
+	return 0;
+}
+
+static unsigned int do_relocs(struct host1x_job *job, struct host1x_bo *cmdbuf)
+{
+	int i = 0;
+	u32 last_page = ~0;
+	void *cmdbuf_page_addr = NULL;
+
+	/* pin & patch the relocs for one gather */
+	while (i < job->num_relocs) {
+		struct host1x_reloc *reloc = &job->relocarray[i];
+		u32 reloc_addr = (job->reloc_addr_phys[i] +
+			reloc->target_offset) >> reloc->shift;
+		u32 *target;
+
+		/* skip all other gathers */
+		if (!(reloc->cmdbuf && cmdbuf == reloc->cmdbuf)) {
+			i++;
+			continue;
+		}
+
+		if (last_page != reloc->cmdbuf_offset >> PAGE_SHIFT) {
+			if (cmdbuf_page_addr)
+				host1x_bo_kunmap(cmdbuf, last_page,
+						 cmdbuf_page_addr);
+
+			cmdbuf_page_addr = host1x_bo_kmap(cmdbuf,
+					reloc->cmdbuf_offset >> PAGE_SHIFT);
+			last_page = reloc->cmdbuf_offset >> PAGE_SHIFT;
+
+			if (unlikely(!cmdbuf_page_addr)) {
+				pr_err("Could not map cmdbuf for relocation\n");
+				return -ENOMEM;
+			}
+		}
+
+		target = cmdbuf_page_addr + (reloc->cmdbuf_offset & ~PAGE_MASK);
+		*target = reloc_addr;
+
+		/* mark this gather as handled */
+		reloc->cmdbuf = 0;
+	}
+
+	if (cmdbuf_page_addr)
+		host1x_bo_kunmap(cmdbuf, last_page, cmdbuf_page_addr);
+
+	return 0;
+}
+
+static int check_reloc(struct host1x_reloc *reloc, struct host1x_bo *cmdbuf,
+		       unsigned int offset)
+{
+	offset *= sizeof(u32);
+
+	if (reloc->cmdbuf != cmdbuf || reloc->cmdbuf_offset != offset)
+		return -EINVAL;
+
+	return 0;
+}
+
+struct host1x_firewall {
+	struct host1x_job *job;
+	struct device *dev;
+
+	unsigned int num_relocs;
+	struct host1x_reloc *reloc;
+
+	struct host1x_bo *cmdbuf_id;
+	unsigned int offset;
+
+	u32 words;
+	u32 class;
+	u32 reg;
+	u32 mask;
+	u32 count;
+};
+
+static int check_mask(struct host1x_firewall *fw)
+{
+	u32 mask = fw->mask;
+	u32 reg = fw->reg;
+
+	while (mask) {
+		if (fw->words == 0)
+			return -EINVAL;
+
+		if (mask & 1) {
+			if (fw->job->is_addr_reg(fw->dev, fw->class, reg)) {
+				bool bad_reloc = check_reloc(fw->reloc,
+							     fw->cmdbuf_id,
+							     fw->offset);
+				if (!fw->num_relocs || bad_reloc)
+					return -EINVAL;
+				fw->reloc++;
+				fw->num_relocs--;
+			}
+			fw->words--;
+			fw->offset++;
+		}
+		mask >>= 1;
+		reg++;
+	}
+
+	return 0;
+}
+
+static int check_incr(struct host1x_firewall *fw)
+{
+	u32 count = fw->count;
+	u32 reg = fw->reg;
+
+	while (fw) {
+		if (fw->words == 0)
+			return -EINVAL;
+
+		if (fw->job->is_addr_reg(fw->dev, fw->class, reg)) {
+			bool bad_reloc = check_reloc(fw->reloc, fw->cmdbuf_id,
+						     fw->offset);
+			if (!fw->num_relocs || bad_reloc)
+				return -EINVAL;
+			fw->reloc++;
+			fw->num_relocs--;
+		}
+		reg++;
+		fw->words--;
+		fw->offset++;
+		count--;
+	}
+
+	return 0;
+}
+
+static int check_nonincr(struct host1x_firewall *fw)
+{
+	int is_addr_reg = fw->job->is_addr_reg(fw->dev, fw->class, fw->reg);
+	u32 count = fw->count;
+
+	while (count) {
+		if (fw->words == 0)
+			return -EINVAL;
+
+		if (is_addr_reg) {
+			bool bad_reloc = check_reloc(fw->reloc, fw->cmdbuf_id,
+						     fw->offset);
+			if (!fw->num_relocs || bad_reloc)
+				return -EINVAL;
+			fw->reloc++;
+			fw->num_relocs--;
+		}
+		fw->words--;
+		fw->offset++;
+		count--;
+	}
+
+	return 0;
+}
+
+static int validate(struct host1x_job *job, struct device *dev,
+		    struct host1x_job_gather *g)
+{
+	u32 *cmdbuf_base;
+	int err = 0;
+	struct host1x_firewall fw;
+
+	fw.job = job;
+	fw.dev = dev;
+	fw.reloc = job->relocarray;
+	fw.num_relocs = job->num_relocs;
+	fw.cmdbuf_id = g->bo;
+
+	fw.offset = 0;
+	fw.class = 0;
+
+	if (!job->is_addr_reg)
+		return 0;
+
+	cmdbuf_base = host1x_bo_mmap(g->bo);
+	if (!cmdbuf_base)
+		return -ENOMEM;
+
+	fw.words = g->words;
+	while (fw.words && !err) {
+		u32 word = cmdbuf_base[fw.offset];
+		u32 opcode = (word & 0xf0000000) >> 28;
+
+		fw.mask = 0;
+		fw.reg = 0;
+		fw.count = 0;
+		fw.words--;
+		fw.offset++;
+
+		switch (opcode) {
+		case 0:
+			fw.class = word >> 6 & 0x3ff;
+			fw.mask = word & 0x3f;
+			fw.reg = word >> 16 & 0xfff;
+			err = check_mask(&fw);
+			if (err)
+				goto out;
+			break;
+		case 1:
+			fw.reg = word >> 16 & 0xfff;
+			fw.count = word & 0xffff;
+			err = check_incr(&fw);
+			if (err)
+				goto out;
+			break;
+
+		case 2:
+			fw.reg = word >> 16 & 0xfff;
+			fw.count = word & 0xffff;
+			err = check_nonincr(&fw);
+			if (err)
+				goto out;
+			break;
+
+		case 3:
+			fw.mask = word & 0xffff;
+			fw.reg = word >> 16 & 0xfff;
+			err = check_mask(&fw);
+			if (err)
+				goto out;
+			break;
+		case 4:
+		case 5:
+		case 14:
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+	}
+
+	/* No relocs should remain at this point */
+	if (fw.num_relocs)
+		err = -EINVAL;
+
+out:
+	host1x_bo_munmap(g->bo, cmdbuf_base);
+
+	return err;
+}
+
+static inline int copy_gathers(struct host1x_job *job, struct device *dev)
+{
+	size_t size = 0;
+	size_t offset = 0;
+	int i;
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		size += g->words * sizeof(u32);
+	}
+
+	job->gather_copy_mapped = dma_alloc_writecombine(dev, size,
+							 &job->gather_copy,
+							 GFP_KERNEL);
+	if (!job->gather_copy_mapped) {
+		int err = PTR_ERR(job->gather_copy_mapped);
+		job->gather_copy_mapped = NULL;
+		return err;
+	}
+
+	job->gather_copy_size = size;
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		void *gather;
+
+		gather = host1x_bo_mmap(g->bo);
+		memcpy(job->gather_copy_mapped + offset, gather + g->offset,
+		       g->words * sizeof(u32));
+		host1x_bo_munmap(g->bo, gather);
+
+		g->base = job->gather_copy;
+		g->offset = offset;
+		g->bo = NULL;
+
+		offset += g->words * sizeof(u32);
+	}
+
+	return 0;
+}
+
+int host1x_job_pin(struct host1x_job *job, struct device *dev)
+{
+	int err;
+	unsigned int i, j;
+	struct host1x *host = dev_get_drvdata(dev->parent);
+	DECLARE_BITMAP(waitchk_mask, host1x_syncpt_nb_pts(host));
+
+	bitmap_zero(waitchk_mask, host1x_syncpt_nb_pts(host));
+	for (i = 0; i < job->num_waitchk; i++) {
+		u32 syncpt_id = job->waitchk[i].syncpt_id;
+		if (syncpt_id < host1x_syncpt_nb_pts(host))
+			set_bit(syncpt_id, waitchk_mask);
+	}
+
+	/* get current syncpt values for waitchk */
+	for_each_set_bit(i, waitchk_mask, host1x_syncpt_nb_pts(host))
+		host1x_syncpt_load(host->syncpt + i);
+
+	/* pin memory */
+	err = pin_job(job);
+	if (!err)
+		goto out;
+
+	/* patch gathers */
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+
+		/* process each gather mem only once */
+		if (g->handled)
+			continue;
+
+		g->base = job->gather_addr_phys[i];
+
+		for (j = 0; j < job->num_gathers; j++)
+			if (job->gathers[j].bo == g->bo)
+				job->gathers[j].handled = true;
+
+		err = 0;
+
+		if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL))
+			err = validate(job, dev, g);
+
+		if (err)
+			dev_err(dev, "Job invalid (err=%d)\n", err);
+
+		if (!err)
+			err = do_relocs(job, g->bo);
+
+		if (!err)
+			err = do_waitchks(job, host, g->bo);
+
+		if (err)
+			break;
+	}
+
+	if (IS_ENABLED(CONFIG_TEGRA_HOST1X_FIREWALL) && !err) {
+		err = copy_gathers(job, dev);
+		if (err) {
+			host1x_job_unpin(job);
+			return err;
+		}
+	}
+
+out:
+	wmb();
+
+	return err;
+}
+
+void host1x_job_unpin(struct host1x_job *job)
+{
+	unsigned int i;
+
+	for (i = 0; i < job->num_unpins; i++) {
+		struct host1x_job_unpin_data *unpin = &job->unpins[i];
+		host1x_bo_unpin(unpin->bo, unpin->sgt);
+		host1x_bo_put(unpin->bo);
+	}
+	job->num_unpins = 0;
+
+	if (job->gather_copy_size)
+		dma_free_writecombine(job->channel->dev, job->gather_copy_size,
+				      job->gather_copy_mapped,
+				      job->gather_copy);
+}
+
+/*
+ * Debug routine used to dump job entries
+ */
+void host1x_job_dump(struct device *dev, struct host1x_job *job)
+{
+	dev_dbg(dev, "    SYNCPT_ID   %d\n", job->syncpt_id);
+	dev_dbg(dev, "    SYNCPT_VAL  %d\n", job->syncpt_end);
+	dev_dbg(dev, "    FIRST_GET   0x%x\n", job->first_get);
+	dev_dbg(dev, "    TIMEOUT     %d\n", job->timeout);
+	dev_dbg(dev, "    NUM_SLOTS   %d\n", job->num_slots);
+	dev_dbg(dev, "    NUM_HANDLES %d\n", job->num_unpins);
+}
diff --git a/drivers/gpu/host1x/job.h b/drivers/gpu/host1x/job.h
new file mode 100644
index 0000000..fba45f2
--- /dev/null
+++ b/drivers/gpu/host1x/job.h
@@ -0,0 +1,162 @@
+/*
+ * Tegra host1x Job
+ *
+ * Copyright (c) 2011-2013, NVIDIA Corporation.
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
+#ifndef __HOST1X_JOB_H
+#define __HOST1X_JOB_H
+
+struct host1x_job_gather {
+	u32 words;
+	dma_addr_t base;
+	struct host1x_bo *bo;
+	int offset;
+	bool handled;
+};
+
+struct host1x_cmdbuf {
+	u32 handle;
+	u32 offset;
+	u32 words;
+	u32 pad;
+};
+
+struct host1x_reloc {
+	struct host1x_bo *cmdbuf;
+	u32 cmdbuf_offset;
+	struct host1x_bo *target;
+	u32 target_offset;
+	u32 shift;
+	u32 pad;
+};
+
+struct host1x_waitchk {
+	struct host1x_bo *bo;
+	u32 offset;
+	u32 syncpt_id;
+	u32 thresh;
+};
+
+struct host1x_job_unpin_data {
+	struct host1x_bo *bo;
+	struct sg_table *sgt;
+};
+
+/*
+ * Each submit is tracked as a host1x_job.
+ */
+struct host1x_job {
+	/* When refcount goes to zero, job can be freed */
+	struct kref ref;
+
+	/* List entry */
+	struct list_head list;
+
+	/* Channel where job is submitted to */
+	struct host1x_channel *channel;
+
+	u32 client;
+
+	/* Gathers and their memory */
+	struct host1x_job_gather *gathers;
+	unsigned int num_gathers;
+
+	/* Wait checks to be processed at submit time */
+	struct host1x_waitchk *waitchk;
+	unsigned int num_waitchk;
+	u32 waitchk_mask;
+
+	/* Array of handles to be pinned & unpinned */
+	struct host1x_reloc *relocarray;
+	unsigned int num_relocs;
+	struct host1x_job_unpin_data *unpins;
+	unsigned int num_unpins;
+
+	dma_addr_t *addr_phys;
+	dma_addr_t *gather_addr_phys;
+	dma_addr_t *reloc_addr_phys;
+
+	/* Sync point id, number of increments and end related to the submit */
+	u32 syncpt_id;
+	u32 syncpt_incrs;
+	u32 syncpt_end;
+
+	/* Maximum time to wait for this job */
+	unsigned int timeout;
+
+	/* Index and number of slots used in the push buffer */
+	unsigned int first_get;
+	unsigned int num_slots;
+
+	/* Copy of gathers */
+	size_t gather_copy_size;
+	dma_addr_t gather_copy;
+	u8 *gather_copy_mapped;
+
+	/* Check if register is marked as an address reg */
+	int (*is_addr_reg)(struct device *dev, u32 reg, u32 class);
+
+	/* Request a SETCLASS to this class */
+	u32 class;
+
+	/* Add a channel wait for previous ops to complete */
+	bool serialize;
+};
+/*
+ * Allocate memory for a job. Just enough memory will be allocated to
+ * accomodate the submit.
+ */
+struct host1x_job *host1x_job_alloc(struct host1x_channel *ch,
+				    u32 num_cmdbufs, u32 num_relocs,
+				    u32 num_waitchks);
+
+/*
+ * Add a gather to a job.
+ */
+void host1x_job_add_gather(struct host1x_job *job, struct host1x_bo *mem_id,
+			   u32 words, u32 offset);
+
+/*
+ * Increment reference going to host1x_job.
+ */
+struct host1x_job *host1x_job_get(struct host1x_job *job);
+
+/*
+ * Decrement reference job, free if goes to zero.
+ */
+void host1x_job_put(struct host1x_job *job);
+
+/*
+ * Pin memory related to job. This handles relocation of addresses to the
+ * host1x address space. Handles both the gather memory and any other memory
+ * referred to from the gather buffers.
+ *
+ * Handles also patching out host waits that would wait for an expired sync
+ * point value.
+ */
+int host1x_job_pin(struct host1x_job *job, struct device *dev);
+
+/*
+ * Unpin memory related to job.
+ */
+void host1x_job_unpin(struct host1x_job *job);
+
+/*
+ * Dump contents of job to debug output.
+ */
+void host1x_job_dump(struct device *dev, struct host1x_job *job);
+
+#endif
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 07fad14..7e77e63 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -300,6 +300,12 @@ bool host1x_syncpt_is_expired(struct host1x_syncpt *sp, u32 thresh)
 		return (s32)(current_val - thresh) >= 0;
 }
 
+/* remove a wait pointed to by patch_addr */
+int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
+{
+	return host1x_hw_syncpt_patch_wait(sp->host, sp, patch_addr);
+}
+
 int host1x_syncpt_init(struct host1x *host)
 {
 	struct host1x_syncpt *syncpt;
@@ -319,6 +325,11 @@ int host1x_syncpt_init(struct host1x *host)
 
 	host1x_syncpt_restore(host);
 
+	/* Allocate sync point to use for clearing waits for expired fences */
+	host->nop_sp = _host1x_syncpt_alloc(host, NULL, 0);
+	if (!host->nop_sp)
+		return -ENOMEM;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index 17c1616..c998061 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -27,6 +27,9 @@
 
 struct host1x;
 
+/* Reserved for replacing an expired wait with a NOP */
+#define HOST1X_SYNCPT_RESERVED			0
+
 struct host1x_syncpt {
 	int id;
 	atomic_t min_val;
@@ -146,6 +149,9 @@ static inline int host1x_syncpt_is_valid(struct host1x_syncpt *sp)
 	return sp->id < host1x_syncpt_nb_pts(sp->host);
 }
 
+/* Patch a wait by replacing it with a wait for syncpt 0 value 0 */
+int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr);
+
 /* Return id of the sync point */
 u32 host1x_syncpt_id(struct host1x_syncpt *sp);
 
diff --git a/include/trace/events/host1x.h b/include/trace/events/host1x.h
index 4bd2b02..0b3944d 100644
--- a/include/trace/events/host1x.h
+++ b/include/trace/events/host1x.h
@@ -37,6 +37,190 @@ DECLARE_EVENT_CLASS(host1x,
 	TP_printk("name=%s", __entry->name)
 );
 
+DEFINE_EVENT(host1x, host1x_channel_open,
+	TP_PROTO(const char *name),
+	TP_ARGS(name)
+);
+
+DEFINE_EVENT(host1x, host1x_channel_release,
+	TP_PROTO(const char *name),
+	TP_ARGS(name)
+);
+
+DEFINE_EVENT(host1x, host1x_cdma_begin,
+	TP_PROTO(const char *name),
+	TP_ARGS(name)
+);
+
+DEFINE_EVENT(host1x, host1x_cdma_end,
+	TP_PROTO(const char *name),
+	TP_ARGS(name)
+);
+
+TRACE_EVENT(host1x,
+	TP_PROTO(const char *name, int timeout),
+
+	TP_ARGS(name, timeout),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(int, timeout)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->timeout = timeout;
+	),
+
+	TP_printk("name=%s, timeout=%d",
+		__entry->name, __entry->timeout)
+);
+
+TRACE_EVENT(host1x_cdma_push,
+	TP_PROTO(const char *name, u32 op1, u32 op2),
+
+	TP_ARGS(name, op1, op2),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, op1)
+		__field(u32, op2)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->op1 = op1;
+		__entry->op2 = op2;
+	),
+
+	TP_printk("name=%s, op1=%08x, op2=%08x",
+		__entry->name, __entry->op1, __entry->op2)
+);
+
+TRACE_EVENT(host1x_cdma_push_gather,
+	TP_PROTO(const char *name, u32 mem_id,
+			u32 words, u32 offset, void *cmdbuf),
+
+	TP_ARGS(name, mem_id, words, offset, cmdbuf),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, mem_id)
+		__field(u32, words)
+		__field(u32, offset)
+		__field(bool, cmdbuf)
+		__dynamic_array(u32, cmdbuf, words)
+	),
+
+	TP_fast_assign(
+		if (cmdbuf) {
+			memcpy(__get_dynamic_array(cmdbuf), cmdbuf+offset,
+					words * sizeof(u32));
+		}
+		__entry->cmdbuf = cmdbuf;
+		__entry->name = name;
+		__entry->mem_id = mem_id;
+		__entry->words = words;
+		__entry->offset = offset;
+	),
+
+	TP_printk("name=%s, mem_id=%08x, words=%u, offset=%d, contents=[%s]",
+	  __entry->name, __entry->mem_id,
+	  __entry->words, __entry->offset,
+	  __print_hex(__get_dynamic_array(cmdbuf),
+		  __entry->cmdbuf ? __entry->words * 4 : 0))
+);
+
+TRACE_EVENT(host1x_channel_submit,
+	TP_PROTO(const char *name, u32 cmdbufs, u32 relocs, u32 waitchks,
+			u32 syncpt_id, u32 syncpt_incrs),
+
+	TP_ARGS(name, cmdbufs, relocs, waitchks, syncpt_id, syncpt_incrs),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, cmdbufs)
+		__field(u32, relocs)
+		__field(u32, waitchks)
+		__field(u32, syncpt_id)
+		__field(u32, syncpt_incrs)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->cmdbufs = cmdbufs;
+		__entry->relocs = relocs;
+		__entry->waitchks = waitchks;
+		__entry->syncpt_id = syncpt_id;
+		__entry->syncpt_incrs = syncpt_incrs;
+	),
+
+	TP_printk("name=%s, cmdbufs=%u, relocs=%u, waitchks=%d,"
+		"syncpt_id=%u, syncpt_incrs=%u",
+	  __entry->name, __entry->cmdbufs, __entry->relocs, __entry->waitchks,
+	  __entry->syncpt_id, __entry->syncpt_incrs)
+);
+
+TRACE_EVENT(host1x_channel_submitted,
+	TP_PROTO(const char *name, u32 syncpt_base, u32 syncpt_max),
+
+	TP_ARGS(name, syncpt_base, syncpt_max),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, syncpt_base)
+		__field(u32, syncpt_max)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->syncpt_base = syncpt_base;
+		__entry->syncpt_max = syncpt_max;
+	),
+
+	TP_printk("name=%s, syncpt_base=%d, syncpt_max=%d",
+		__entry->name, __entry->syncpt_base, __entry->syncpt_max)
+);
+
+TRACE_EVENT(host1x_channel_submit_complete,
+	TP_PROTO(const char *name, int count, u32 thresh),
+
+	TP_ARGS(name, count, thresh),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(int, count)
+		__field(u32, thresh)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->count = count;
+		__entry->thresh = thresh;
+	),
+
+	TP_printk("name=%s, count=%d, thresh=%d",
+		__entry->name, __entry->count, __entry->thresh)
+);
+
+TRACE_EVENT(host1x_wait_cdma,
+	TP_PROTO(const char *name, u32 eventid),
+
+	TP_ARGS(name, eventid),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, eventid)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->eventid = eventid;
+	),
+
+	TP_printk("name=%s, event=%d", __entry->name, __entry->eventid)
+);
+
 TRACE_EVENT(host1x_syncpt_load_min,
 	TP_PROTO(u32 id, u32 val),
 
@@ -55,6 +239,33 @@ TRACE_EVENT(host1x_syncpt_load_min,
 	TP_printk("id=%d, val=%d", __entry->id, __entry->val)
 );
 
+TRACE_EVENT(host1x_syncpt_wait_check,
+	TP_PROTO(void *mem_id, u32 offset, u32 syncpt_id, u32 thresh, u32 min),
+
+	TP_ARGS(mem_id, offset, syncpt_id, thresh, min),
+
+	TP_STRUCT__entry(
+		__field(void *, mem_id)
+		__field(u32, offset)
+		__field(u32, syncpt_id)
+		__field(u32, thresh)
+		__field(u32, min)
+	),
+
+	TP_fast_assign(
+		__entry->mem_id = mem_id;
+		__entry->offset = offset;
+		__entry->syncpt_id = syncpt_id;
+		__entry->thresh = thresh;
+		__entry->min = min;
+	),
+
+	TP_printk("mem_id=%p, offset=%05x, id=%d, thresh=%d, current=%d",
+		__entry->mem_id, __entry->offset,
+		__entry->syncpt_id, __entry->thresh,
+		__entry->min)
+);
+
 #endif /*  _TRACE_HOST1X_H */
 
 /* This part must be outside protection */
-- 
1.7.9.5

