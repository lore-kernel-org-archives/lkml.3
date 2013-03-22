Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab3CVIa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:30:57 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19339 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3CVIaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:30:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 22 Mar 2013 01:30:36 -0700
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <airlied@linux.ie>, <thierry.reding@avionic-design.de>,
        <linux-tegra@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, <amerilainen@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv8 4/9] gpu: host1x: Add debug support
Date: Fri, 22 Mar 2013 10:30:01 +0200
Message-ID: <1363941006-14204-5-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363941006-14204-1-git-send-email-tbergstrom@nvidia.com>
References: <1363941006-14204-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for host1x debugging. Adds debugfs entries, and dumps
channel state to UART in case of stuck job.

Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile                 |    1 +
 drivers/gpu/host1x/cdma.c                   |    4 +
 drivers/gpu/host1x/debug.c                  |  210 +++++++++++++++++
 drivers/gpu/host1x/debug.h                  |   51 +++++
 drivers/gpu/host1x/dev.c                    |    3 +
 drivers/gpu/host1x/dev.h                    |   42 ++++
 drivers/gpu/host1x/hw/cdma_hw.c             |    2 +
 drivers/gpu/host1x/hw/channel_hw.c          |   25 +++
 drivers/gpu/host1x/hw/debug_hw.c            |  322 +++++++++++++++++++++++++++
 drivers/gpu/host1x/hw/host1x01.c            |    2 +
 drivers/gpu/host1x/hw/hw_host1x01_channel.h |   18 ++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h    |  115 ++++++++++
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h  |    6 +
 drivers/gpu/host1x/hw/syncpt_hw.c           |    1 +
 drivers/gpu/host1x/syncpt.c                 |    5 +
 15 files changed, 807 insertions(+)
 create mode 100644 drivers/gpu/host1x/debug.c
 create mode 100644 drivers/gpu/host1x/debug.h
 create mode 100644 drivers/gpu/host1x/hw/debug_hw.c

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 06a995b..49fd580 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -7,6 +7,7 @@ host1x-y = \
 	cdma.o \
 	channel.o \
 	job.o \
+	debug.o \
 	hw/host1x01.o
 
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
index 33935de..de72172 100644
--- a/drivers/gpu/host1x/cdma.c
+++ b/drivers/gpu/host1x/cdma.c
@@ -439,6 +439,10 @@ void host1x_cdma_push(struct host1x_cdma *cdma, u32 op1, u32 op2)
 	struct push_buffer *pb = &cdma->push_buffer;
 	u32 slots_free = cdma->slots_free;
 
+	if (host1x_debug_trace_cmdbuf)
+		trace_host1x_cdma_push(dev_name(cdma_to_channel(cdma)->dev),
+				       op1, op2);
+
 	if (slots_free == 0) {
 		host1x_hw_cdma_flush(host1x, cdma);
 		slots_free = host1x_cdma_wait_locked(cdma,
diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
new file mode 100644
index 0000000..3ec7d77
--- /dev/null
+++ b/drivers/gpu/host1x/debug.c
@@ -0,0 +1,210 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Erik Gilling <konkers@android.com>
+ *
+ * Copyright (C) 2011-2013 NVIDIA Corporation
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/uaccess.h>
+
+#include <linux/io.h>
+
+#include "dev.h"
+#include "debug.h"
+#include "channel.h"
+
+unsigned int host1x_debug_trace_cmdbuf;
+
+static pid_t host1x_debug_force_timeout_pid;
+static u32 host1x_debug_force_timeout_val;
+static u32 host1x_debug_force_timeout_channel;
+
+void host1x_debug_output(struct output *o, const char *fmt, ...)
+{
+	va_list args;
+	int len;
+
+	va_start(args, fmt);
+	len = vsnprintf(o->buf, sizeof(o->buf), fmt, args);
+	va_end(args);
+	o->fn(o->ctx, o->buf, len);
+}
+
+static int show_channels(struct host1x_channel *ch, void *data, bool show_fifo)
+{
+	struct host1x *m = dev_get_drvdata(ch->dev->parent);
+	struct output *o = data;
+
+	mutex_lock(&ch->reflock);
+	if (ch->refcount) {
+		mutex_lock(&ch->cdma.lock);
+		if (show_fifo)
+			host1x_hw_show_channel_fifo(m, ch, o);
+		host1x_hw_show_channel_cdma(m, ch, o);
+		mutex_unlock(&ch->cdma.lock);
+	}
+	mutex_unlock(&ch->reflock);
+
+	return 0;
+}
+
+static void show_syncpts(struct host1x *m, struct output *o)
+{
+	int i;
+	host1x_debug_output(o, "---- syncpts ----\n");
+	for (i = 0; i < host1x_syncpt_nb_pts(m); i++) {
+		u32 max = host1x_syncpt_read_max(m->syncpt + i);
+		u32 min = host1x_syncpt_load(m->syncpt + i);
+		if (!min && !max)
+			continue;
+		host1x_debug_output(o, "id %d (%s) min %d max %d\n",
+				    i, m->syncpt[i].name, min, max);
+	}
+
+	for (i = 0; i < host1x_syncpt_nb_bases(m); i++) {
+		u32 base_val;
+		base_val = host1x_syncpt_load_wait_base(m->syncpt + i);
+		if (base_val)
+			host1x_debug_output(o, "waitbase id %d val %d\n", i,
+					    base_val);
+	}
+
+	host1x_debug_output(o, "\n");
+}
+
+static void show_all(struct host1x *m, struct output *o)
+{
+	struct host1x_channel *ch;
+
+	host1x_hw_show_mlocks(m, o);
+	show_syncpts(m, o);
+	host1x_debug_output(o, "---- channels ----\n");
+
+	host1x_for_each_channel(m, ch)
+		show_channels(ch, o, true);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static void show_all_no_fifo(struct host1x *host1x, struct output *o)
+{
+	struct host1x_channel *ch;
+
+	host1x_hw_show_mlocks(host1x, o);
+	show_syncpts(host1x, o);
+	host1x_debug_output(o, "---- channels ----\n");
+
+	host1x_for_each_channel(host1x, ch)
+		show_channels(ch, o, false);
+}
+
+static int host1x_debug_show_all(struct seq_file *s, void *unused)
+{
+	struct output o = {
+		.fn = write_to_seqfile,
+		.ctx = s
+	};
+	show_all(s->private, &o);
+	return 0;
+}
+
+static int host1x_debug_show(struct seq_file *s, void *unused)
+{
+	struct output o = {
+		.fn = write_to_seqfile,
+		.ctx = s
+	};
+	show_all_no_fifo(s->private, &o);
+	return 0;
+}
+
+static int host1x_debug_open_all(struct inode *inode, struct file *file)
+{
+	return single_open(file, host1x_debug_show_all, inode->i_private);
+}
+
+static const struct file_operations host1x_debug_all_fops = {
+	.open		= host1x_debug_open_all,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int host1x_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, host1x_debug_show, inode->i_private);
+}
+
+static const struct file_operations host1x_debug_fops = {
+	.open		= host1x_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+void host1x_debug_init(struct host1x *host1x)
+{
+	struct dentry *de = debugfs_create_dir("tegra-host1x", NULL);
+
+	if (!de)
+		return;
+
+	/* Store the created entry */
+	host1x->debugfs = de;
+
+	debugfs_create_file("status", S_IRUGO, de, host1x, &host1x_debug_fops);
+	debugfs_create_file("status_all", S_IRUGO, de, host1x,
+			    &host1x_debug_all_fops);
+
+	debugfs_create_u32("trace_cmdbuf", S_IRUGO|S_IWUSR, de,
+			   &host1x_debug_trace_cmdbuf);
+
+	host1x_hw_debug_init(host1x, de);
+
+	debugfs_create_u32("force_timeout_pid", S_IRUGO|S_IWUSR, de,
+			   &host1x_debug_force_timeout_pid);
+	debugfs_create_u32("force_timeout_val", S_IRUGO|S_IWUSR, de,
+			   &host1x_debug_force_timeout_val);
+	debugfs_create_u32("force_timeout_channel", S_IRUGO|S_IWUSR, de,
+			   &host1x_debug_force_timeout_channel);
+}
+
+void host1x_debug_deinit(struct host1x *host1x)
+{
+	debugfs_remove_recursive(host1x->debugfs);
+}
+#else
+void host1x_debug_init(struct host1x *host1x)
+{
+}
+void host1x_debug_deinit(struct host1x *host1x)
+{
+}
+#endif
+
+void host1x_debug_dump(struct host1x *host1x)
+{
+	struct output o = {
+		.fn = write_to_printk
+	};
+	show_all(host1x, &o);
+}
+
+void host1x_debug_dump_syncpts(struct host1x *host1x)
+{
+	struct output o = {
+		.fn = write_to_printk
+	};
+	show_syncpts(host1x, &o);
+}
diff --git a/drivers/gpu/host1x/debug.h b/drivers/gpu/host1x/debug.h
new file mode 100644
index 0000000..4595b2e
--- /dev/null
+++ b/drivers/gpu/host1x/debug.h
@@ -0,0 +1,51 @@
+/*
+ * Tegra host1x Debug
+ *
+ * Copyright (c) 2011-2013 NVIDIA Corporation.
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
+#ifndef __HOST1X_DEBUG_H
+#define __HOST1X_DEBUG_H
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+struct host1x;
+
+struct output {
+	void (*fn)(void *ctx, const char *str, size_t len);
+	void *ctx;
+	char buf[256];
+};
+
+static inline void write_to_seqfile(void *ctx, const char *str, size_t len)
+{
+	seq_write((struct seq_file *)ctx, str, len);
+}
+
+static inline void write_to_printk(void *ctx, const char *str, size_t len)
+{
+	pr_info("%s", str);
+}
+
+void __printf(2, 3) host1x_debug_output(struct output *o, const char *fmt, ...);
+
+extern unsigned int host1x_debug_trace_cmdbuf;
+
+void host1x_debug_init(struct host1x *host1x);
+void host1x_debug_deinit(struct host1x *host1x);
+void host1x_debug_dump(struct host1x *host1x);
+void host1x_debug_dump_syncpts(struct host1x *host1x);
+
+#endif
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 4e522c5..9689724 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -30,6 +30,7 @@
 #include "dev.h"
 #include "intr.h"
 #include "channel.h"
+#include "debug.h"
 #include "hw/host1x01.h"
 
 void host1x_sync_writel(struct host1x *host1x, u32 v, u32 r)
@@ -147,6 +148,8 @@ static int host1x_probe(struct platform_device *pdev)
 		goto fail_deinit_syncpt;
 	}
 
+	host1x_debug_init(host);
+
 	return 0;
 
 fail_deinit_syncpt:
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 1a9b438..4d16fe9 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -31,6 +31,8 @@ struct host1x_channel;
 struct host1x_cdma;
 struct host1x_job;
 struct push_buffer;
+struct output;
+struct dentry;
 
 struct host1x_channel_ops {
 	int (*init)(struct host1x_channel *channel, struct host1x *host,
@@ -54,6 +56,18 @@ struct host1x_pushbuffer_ops {
 	void (*init)(struct push_buffer *pb);
 };
 
+struct host1x_debug_ops {
+	void (*debug_init)(struct dentry *de);
+	void (*show_channel_cdma)(struct host1x *host,
+				  struct host1x_channel *ch,
+				  struct output *o);
+	void (*show_channel_fifo)(struct host1x *host,
+				  struct host1x_channel *ch,
+				  struct output *o);
+	void (*show_mlocks)(struct host1x *host, struct output *output);
+
+};
+
 struct host1x_syncpt_ops {
 	void (*restore)(struct host1x_syncpt *syncpt);
 	void (*restore_wait_base)(struct host1x_syncpt *syncpt);
@@ -100,6 +114,7 @@ struct host1x {
 	const struct host1x_channel_ops *channel_op;
 	const struct host1x_cdma_ops *cdma_op;
 	const struct host1x_pushbuffer_ops *cdma_pb_op;
+	const struct host1x_debug_ops *debug_op;
 
 	struct host1x_syncpt *nop_sp;
 
@@ -107,6 +122,8 @@ struct host1x {
 	struct host1x_channel chlist;
 	unsigned long allocated_channels;
 	unsigned int num_allocated_channels;
+
+	struct dentry *debugfs;
 };
 
 void host1x_sync_writel(struct host1x *host1x, u32 r, u32 v);
@@ -257,4 +274,29 @@ static inline void host1x_hw_pushbuffer_init(struct host1x *host,
 	host->cdma_pb_op->init(pb);
 }
 
+static inline void host1x_hw_debug_init(struct host1x *host, struct dentry *de)
+{
+	if (host->debug_op && host->debug_op->debug_init)
+		host->debug_op->debug_init(de);
+}
+
+static inline void host1x_hw_show_channel_cdma(struct host1x *host,
+					       struct host1x_channel *channel,
+					       struct output *o)
+{
+	host->debug_op->show_channel_cdma(host, channel, o);
+}
+
+static inline void host1x_hw_show_channel_fifo(struct host1x *host,
+					       struct host1x_channel *channel,
+					       struct output *o)
+{
+	host->debug_op->show_channel_fifo(host, channel, o);
+}
+
+static inline void host1x_hw_show_mlocks(struct host1x *host, struct output *o)
+{
+	host->debug_op->show_mlocks(host, o);
+}
+
 #endif
diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 4eb22ef..590b69d 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -244,6 +244,8 @@ static void cdma_timeout_handler(struct work_struct *work)
 	host1x = cdma_to_host1x(cdma);
 	ch = cdma_to_channel(cdma);
 
+	host1x_debug_dump(cdma_to_host1x(cdma));
+
 	mutex_lock(&cdma->lock);
 
 	if (!cdma->timeout.client) {
diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
index 5137a56..ee19962 100644
--- a/drivers/gpu/host1x/hw/channel_hw.c
+++ b/drivers/gpu/host1x/hw/channel_hw.c
@@ -29,6 +29,30 @@
 #define HOST1X_CHANNEL_SIZE 16384
 #define TRACE_MAX_LENGTH 128U
 
+static void trace_write_gather(struct host1x_cdma *cdma, struct host1x_bo *bo,
+			       u32 offset, u32 words)
+{
+	void *mem = NULL;
+
+	if (host1x_debug_trace_cmdbuf)
+		mem = host1x_bo_mmap(bo);
+
+	if (mem) {
+		u32 i;
+		/*
+		 * Write in batches of 128 as there seems to be a limit
+		 * of how much you can output to ftrace at once.
+		 */
+		for (i = 0; i < words; i += TRACE_MAX_LENGTH) {
+			trace_host1x_cdma_push_gather(
+				dev_name(cdma_to_channel(cdma)->dev),
+				(u32)bo, min(words - i, TRACE_MAX_LENGTH),
+				offset + i * sizeof(u32), mem);
+		}
+		host1x_bo_munmap(bo, mem);
+	}
+}
+
 static void submit_gathers(struct host1x_job *job)
 {
 	struct host1x_cdma *cdma = &job->channel->cdma;
@@ -38,6 +62,7 @@ static void submit_gathers(struct host1x_job *job)
 		struct host1x_job_gather *g = &job->gathers[i];
 		u32 op1 = host1x_opcode_gather(g->words);
 		u32 op2 = g->base + g->offset;
+		trace_write_gather(cdma, g->bo, g->offset, op1 & 0xffff);
 		host1x_cdma_push(cdma, op1, op2);
 	}
 }
diff --git a/drivers/gpu/host1x/hw/debug_hw.c b/drivers/gpu/host1x/hw/debug_hw.c
new file mode 100644
index 0000000..8e6b313
--- /dev/null
+++ b/drivers/gpu/host1x/hw/debug_hw.c
@@ -0,0 +1,322 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Erik Gilling <konkers@android.com>
+ *
+ * Copyright (C) 2011-2013 NVIDIA Corporation
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <linux/mm.h>
+#include <linux/scatterlist.h>
+
+#include <linux/io.h>
+
+#include "dev.h"
+#include "debug.h"
+#include "cdma.h"
+#include "channel.h"
+#include "host1x_bo.h"
+
+#define HOST1X_DEBUG_MAX_PAGE_OFFSET 102400
+
+enum {
+	HOST1X_OPCODE_SETCLASS	= 0x00,
+	HOST1X_OPCODE_INCR	= 0x01,
+	HOST1X_OPCODE_NONINCR	= 0x02,
+	HOST1X_OPCODE_MASK	= 0x03,
+	HOST1X_OPCODE_IMM	= 0x04,
+	HOST1X_OPCODE_RESTART	= 0x05,
+	HOST1X_OPCODE_GATHER	= 0x06,
+	HOST1X_OPCODE_EXTEND	= 0x0e,
+};
+
+enum {
+	HOST1X_OPCODE_EXTEND_ACQUIRE_MLOCK	= 0x00,
+	HOST1X_OPCODE_EXTEND_RELEASE_MLOCK	= 0x01,
+};
+
+static unsigned int show_channel_command(struct output *o, u32 val)
+{
+	unsigned mask;
+	unsigned subop;
+
+	switch (val >> 28) {
+	case HOST1X_OPCODE_SETCLASS:
+		mask = val & 0x3f;
+		if (mask) {
+			host1x_debug_output(o, "SETCL(class=%03x, offset=%03x, mask=%02x, [",
+					    val >> 6 & 0x3ff,
+					    val >> 16 & 0xfff, mask);
+			return hweight8(mask);
+		} else {
+			host1x_debug_output(o, "SETCL(class=%03x)\n",
+					    val >> 6 & 0x3ff);
+			return 0;
+		}
+
+	case HOST1X_OPCODE_INCR:
+		host1x_debug_output(o, "INCR(offset=%03x, [",
+				    val >> 16 & 0xfff);
+		return val & 0xffff;
+
+	case HOST1X_OPCODE_NONINCR:
+		host1x_debug_output(o, "NONINCR(offset=%03x, [",
+				    val >> 16 & 0xfff);
+		return val & 0xffff;
+
+	case HOST1X_OPCODE_MASK:
+		mask = val & 0xffff;
+		host1x_debug_output(o, "MASK(offset=%03x, mask=%03x, [",
+				    val >> 16 & 0xfff, mask);
+		return hweight16(mask);
+
+	case HOST1X_OPCODE_IMM:
+		host1x_debug_output(o, "IMM(offset=%03x, data=%03x)\n",
+				    val >> 16 & 0xfff, val & 0xffff);
+		return 0;
+
+	case HOST1X_OPCODE_RESTART:
+		host1x_debug_output(o, "RESTART(offset=%08x)\n", val << 4);
+		return 0;
+
+	case HOST1X_OPCODE_GATHER:
+		host1x_debug_output(o, "GATHER(offset=%03x, insert=%d, type=%d, count=%04x, addr=[",
+				    val >> 16 & 0xfff, val >> 15 & 0x1,
+				    val >> 14 & 0x1, val & 0x3fff);
+		return 1;
+
+	case HOST1X_OPCODE_EXTEND:
+		subop = val >> 24 & 0xf;
+		if (subop == HOST1X_OPCODE_EXTEND_ACQUIRE_MLOCK)
+			host1x_debug_output(o, "ACQUIRE_MLOCK(index=%d)\n",
+					    val & 0xff);
+		else if (subop == HOST1X_OPCODE_EXTEND_RELEASE_MLOCK)
+			host1x_debug_output(o, "RELEASE_MLOCK(index=%d)\n",
+					    val & 0xff);
+		else
+			host1x_debug_output(o, "EXTEND_UNKNOWN(%08x)\n", val);
+		return 0;
+
+	default:
+		return 0;
+	}
+}
+
+static void show_gather(struct output *o, phys_addr_t phys_addr,
+			unsigned int words, struct host1x_cdma *cdma,
+			phys_addr_t pin_addr, u32 *map_addr)
+{
+	/* Map dmaget cursor to corresponding mem handle */
+	u32 offset = phys_addr - pin_addr;
+	unsigned int data_count = 0, i;
+
+	/*
+	 * Sometimes we're given different hardware address to the same
+	 * page - in these cases the offset will get an invalid number and
+	 * we just have to bail out.
+	 */
+	if (offset > HOST1X_DEBUG_MAX_PAGE_OFFSET) {
+		host1x_debug_output(o, "[address mismatch]\n");
+		return;
+	}
+
+	for (i = 0; i < words; i++) {
+		u32 addr = phys_addr + i * 4;
+		u32 val = *(map_addr + offset / 4 + i);
+
+		if (!data_count) {
+			host1x_debug_output(o, "%08x: %08x:", addr, val);
+			data_count = show_channel_command(o, val);
+		} else {
+			host1x_debug_output(o, "%08x%s", val,
+					    data_count > 0 ? ", " : "])\n");
+			data_count--;
+		}
+	}
+}
+
+static void show_channel_gathers(struct output *o, struct host1x_cdma *cdma)
+{
+	struct host1x_job *job;
+
+	list_for_each_entry(job, &cdma->sync_queue, list) {
+		int i;
+		host1x_debug_output(o, "\n%p: JOB, syncpt_id=%d, syncpt_val=%d, first_get=%08x, timeout=%d num_slots=%d, num_handles=%d\n",
+				    job, job->syncpt_id, job->syncpt_end,
+				    job->first_get, job->timeout,
+				    job->num_slots, job->num_unpins);
+
+		for (i = 0; i < job->num_gathers; i++) {
+			struct host1x_job_gather *g = &job->gathers[i];
+			u32 *mapped;
+
+			if (job->gather_copy_mapped)
+				mapped = (u32 *)job->gather_copy_mapped;
+			else
+				mapped = host1x_bo_mmap(g->bo);
+
+			if (!mapped) {
+				host1x_debug_output(o, "[could not mmap]\n");
+				continue;
+			}
+
+			host1x_debug_output(o, "    GATHER at %08x+%04x, %d words\n",
+					   g->base, g->offset, g->words);
+
+			show_gather(o, g->base + g->offset, g->words, cdma,
+				   g->base, mapped);
+
+			if (!job->gather_copy_mapped)
+				host1x_bo_munmap(g->bo, mapped);
+		}
+	}
+}
+
+static void host1x_debug_show_channel_cdma(struct host1x *host,
+					   struct host1x_channel *ch,
+					   struct output *o)
+{
+	struct host1x_cdma *cdma = &ch->cdma;
+	u32 dmaput, dmaget, dmactrl;
+	u32 cbstat, cbread;
+	u32 val, base, baseval;
+
+	dmaput = host1x_ch_readl(ch, HOST1X_CHANNEL_DMAPUT);
+	dmaget = host1x_ch_readl(ch, HOST1X_CHANNEL_DMAGET);
+	dmactrl = host1x_ch_readl(ch, HOST1X_CHANNEL_DMACTRL);
+	cbread = host1x_sync_readl(host, HOST1X_SYNC_CBREAD(ch->id));
+	cbstat = host1x_sync_readl(host, HOST1X_SYNC_CBSTAT(ch->id));
+
+	host1x_debug_output(o, "%d-%s: ", ch->id, dev_name(ch->dev));
+
+	if (HOST1X_CHANNEL_DMACTRL_DMASTOP_V(dmactrl) ||
+	    !ch->cdma.push_buffer.mapped) {
+		host1x_debug_output(o, "inactive\n\n");
+		return;
+	}
+
+	if (HOST1X_SYNC_CBSTAT_CBCLASS_V(cbstat) == HOST1X_CLASS_HOST1X &&
+	    HOST1X_SYNC_CBSTAT_CBOFFSET_V(cbstat) ==
+	    HOST1X_UCLASS_WAIT_SYNCPT)
+		host1x_debug_output(o, "waiting on syncpt %d val %d\n",
+				    cbread >> 24, cbread & 0xffffff);
+	else if (HOST1X_SYNC_CBSTAT_CBCLASS_V(cbstat) ==
+	   HOST1X_CLASS_HOST1X &&
+	   HOST1X_SYNC_CBSTAT_CBOFFSET_V(cbstat) ==
+	   HOST1X_UCLASS_WAIT_SYNCPT_BASE) {
+
+		base = (cbread >> 16) & 0xff;
+		baseval =
+			host1x_sync_readl(host, HOST1X_SYNC_SYNCPT_BASE(base));
+		val = cbread & 0xffff;
+		host1x_debug_output(o, "waiting on syncpt %d val %d (base %d = %d; offset = %d)\n",
+				    cbread >> 24, baseval + val, base,
+				    baseval, val);
+	} else
+		host1x_debug_output(o, "active class %02x, offset %04x, val %08x\n",
+				    HOST1X_SYNC_CBSTAT_CBCLASS_V(cbstat),
+				    HOST1X_SYNC_CBSTAT_CBOFFSET_V(cbstat),
+				    cbread);
+
+	host1x_debug_output(o, "DMAPUT %08x, DMAGET %08x, DMACTL %08x\n",
+			    dmaput, dmaget, dmactrl);
+	host1x_debug_output(o, "CBREAD %08x, CBSTAT %08x\n", cbread, cbstat);
+
+	show_channel_gathers(o, cdma);
+	host1x_debug_output(o, "\n");
+}
+
+static void host1x_debug_show_channel_fifo(struct host1x *host,
+					   struct host1x_channel *ch,
+					   struct output *o)
+{
+	u32 val, rd_ptr, wr_ptr, start, end;
+	unsigned int data_count = 0;
+
+	host1x_debug_output(o, "%d: fifo:\n", ch->id);
+
+	val = host1x_ch_readl(ch, HOST1X_CHANNEL_FIFOSTAT);
+	host1x_debug_output(o, "FIFOSTAT %08x\n", val);
+	if (HOST1X_CHANNEL_FIFOSTAT_CFEMPTY_V(val)) {
+		host1x_debug_output(o, "[empty]\n");
+		return;
+	}
+
+	host1x_sync_writel(host, 0x0, HOST1X_SYNC_CFPEEK_CTRL);
+	host1x_sync_writel(host, HOST1X_SYNC_CFPEEK_CTRL_ENA_F(1) |
+			   HOST1X_SYNC_CFPEEK_CTRL_CHANNR_F(ch->id),
+			   HOST1X_SYNC_CFPEEK_CTRL);
+
+	val = host1x_sync_readl(host, HOST1X_SYNC_CFPEEK_PTRS);
+	rd_ptr = HOST1X_SYNC_CFPEEK_PTRS_CF_RD_PTR_V(val);
+	wr_ptr = HOST1X_SYNC_CFPEEK_PTRS_CF_WR_PTR_V(val);
+
+	val = host1x_sync_readl(host, HOST1X_SYNC_CF_SETUP(ch->id));
+	start = HOST1X_SYNC_CF_SETUP_BASE_V(val);
+	end = HOST1X_SYNC_CF_SETUP_LIMIT_V(val);
+
+	do {
+		host1x_sync_writel(host, 0x0, HOST1X_SYNC_CFPEEK_CTRL);
+		host1x_sync_writel(host, HOST1X_SYNC_CFPEEK_CTRL_ENA_F(1) |
+				   HOST1X_SYNC_CFPEEK_CTRL_CHANNR_F(ch->id) |
+				   HOST1X_SYNC_CFPEEK_CTRL_ADDR_F(rd_ptr),
+				   HOST1X_SYNC_CFPEEK_CTRL);
+		val = host1x_sync_readl(host, HOST1X_SYNC_CFPEEK_READ);
+
+		if (!data_count) {
+			host1x_debug_output(o, "%08x:", val);
+			data_count = show_channel_command(o, val);
+		} else {
+			host1x_debug_output(o, "%08x%s", val,
+					    data_count > 0 ? ", " : "])\n");
+			data_count--;
+		}
+
+		if (rd_ptr == end)
+			rd_ptr = start;
+		else
+			rd_ptr++;
+	} while (rd_ptr != wr_ptr);
+
+	if (data_count)
+		host1x_debug_output(o, ", ...])\n");
+	host1x_debug_output(o, "\n");
+
+	host1x_sync_writel(host, 0x0, HOST1X_SYNC_CFPEEK_CTRL);
+}
+
+static void host1x_debug_show_mlocks(struct host1x *host, struct output *o)
+{
+	int i;
+
+	host1x_debug_output(o, "---- mlocks ----\n");
+	for (i = 0; i < host1x_syncpt_nb_mlocks(host); i++) {
+		u32 owner =
+			host1x_sync_readl(host, HOST1X_SYNC_MLOCK_OWNER(i));
+		if (HOST1X_SYNC_MLOCK_OWNER_CH_OWNS_V(owner))
+			host1x_debug_output(o, "%d: locked by channel %d\n",
+				i, HOST1X_SYNC_MLOCK_OWNER_CHID_F(owner));
+		else if (HOST1X_SYNC_MLOCK_OWNER_CPU_OWNS_V(owner))
+			host1x_debug_output(o, "%d: locked by cpu\n", i);
+		else
+			host1x_debug_output(o, "%d: unlocked\n", i);
+	}
+	host1x_debug_output(o, "\n");
+}
+
+static const struct host1x_debug_ops host1x_debug_ops = {
+	.show_channel_cdma = host1x_debug_show_channel_cdma,
+	.show_channel_fifo = host1x_debug_show_channel_fifo,
+	.show_mlocks = host1x_debug_show_mlocks,
+};
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
index 013ff38..a14e91c 100644
--- a/drivers/gpu/host1x/hw/host1x01.c
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -23,6 +23,7 @@
 /* include code */
 #include "hw/cdma_hw.c"
 #include "hw/channel_hw.c"
+#include "hw/debug_hw.c"
 #include "hw/intr_hw.c"
 #include "hw/syncpt_hw.c"
 
@@ -35,6 +36,7 @@ int host1x01_init(struct host1x *host)
 	host->cdma_pb_op = &host1x_pushbuffer_ops;
 	host->syncpt_op = &host1x_syncpt_ops;
 	host->intr_op = &host1x_intr_ops;
+	host->debug_op = &host1x_debug_ops;
 
 	return 0;
 }
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_channel.h b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
index 9ba1332..b4bc7ca 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_channel.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
@@ -51,6 +51,18 @@
 #ifndef __hw_host1x_channel_host1x_h__
 #define __hw_host1x_channel_host1x_h__
 
+static inline u32 host1x_channel_fifostat_r(void)
+{
+	return 0x0;
+}
+#define HOST1X_CHANNEL_FIFOSTAT \
+	host1x_channel_fifostat_r()
+static inline u32 host1x_channel_fifostat_cfempty_v(u32 r)
+{
+	return (r >> 10) & 0x1;
+}
+#define HOST1X_CHANNEL_FIFOSTAT_CFEMPTY_V(r) \
+	host1x_channel_fifostat_cfempty_v(r)
 static inline u32 host1x_channel_dmastart_r(void)
 {
 	return 0x14;
@@ -87,6 +99,12 @@ static inline u32 host1x_channel_dmactrl_dmastop(void)
 }
 #define HOST1X_CHANNEL_DMACTRL_DMASTOP \
 	host1x_channel_dmactrl_dmastop()
+static inline u32 host1x_channel_dmactrl_dmastop_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+#define HOST1X_CHANNEL_DMACTRL_DMASTOP_V(r) \
+	host1x_channel_dmactrl_dmastop_v(r)
 static inline u32 host1x_channel_dmactrl_dmagetrst(void)
 {
 	return 1 << 1;
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
index 8f2a246..ac704e5 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_sync.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -77,6 +77,24 @@ static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(unsigned int id)
 }
 #define HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0(id) \
 	host1x_sync_syncpt_thresh_int_enable_cpu0_r(id)
+static inline u32 host1x_sync_cf_setup_r(unsigned int channel)
+{
+	return 0x80 + channel * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_CF_SETUP(channel) \
+	host1x_sync_cf_setup_r(channel)
+static inline u32 host1x_sync_cf_setup_base_v(u32 r)
+{
+	return (r >> 0) & 0x1ff;
+}
+#define HOST1X_SYNC_CF_SETUP_BASE_V(r) \
+	host1x_sync_cf_setup_base_v(r)
+static inline u32 host1x_sync_cf_setup_limit_v(u32 r)
+{
+	return (r >> 16) & 0x1ff;
+}
+#define HOST1X_SYNC_CF_SETUP_LIMIT_V(r) \
+	host1x_sync_cf_setup_limit_v(r)
 static inline u32 host1x_sync_cmdproc_stop_r(void)
 {
 	return 0xac;
@@ -107,6 +125,30 @@ static inline u32 host1x_sync_ip_busy_timeout_r(void)
 }
 #define HOST1X_SYNC_IP_BUSY_TIMEOUT \
 	host1x_sync_ip_busy_timeout_r()
+static inline u32 host1x_sync_mlock_owner_r(unsigned int id)
+{
+	return 0x340 + id * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_MLOCK_OWNER(id) \
+	host1x_sync_mlock_owner_r(id)
+static inline u32 host1x_sync_mlock_owner_chid_f(u32 v)
+{
+	return (v & 0xf) << 8;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_CHID_F(v) \
+	host1x_sync_mlock_owner_chid_f(v)
+static inline u32 host1x_sync_mlock_owner_cpu_owns_v(u32 r)
+{
+	return (r >> 1) & 0x1;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_CPU_OWNS_V(r) \
+	host1x_sync_mlock_owner_cpu_owns_v(r)
+static inline u32 host1x_sync_mlock_owner_ch_owns_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_CH_OWNS_V(r) \
+	host1x_sync_mlock_owner_ch_owns_v(r)
 static inline u32 host1x_sync_syncpt_int_thresh_r(unsigned int id)
 {
 	return 0x500 + id * REGISTER_STRIDE;
@@ -125,4 +167,77 @@ static inline u32 host1x_sync_syncpt_cpu_incr_r(unsigned int id)
 }
 #define HOST1X_SYNC_SYNCPT_CPU_INCR(id) \
 	host1x_sync_syncpt_cpu_incr_r(id)
+static inline u32 host1x_sync_cbread_r(unsigned int channel)
+{
+	return 0x720 + channel * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_CBREAD(channel) \
+	host1x_sync_cbread_r(channel)
+static inline u32 host1x_sync_cfpeek_ctrl_r(void)
+{
+	return 0x74c;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL \
+	host1x_sync_cfpeek_ctrl_r()
+static inline u32 host1x_sync_cfpeek_ctrl_addr_f(u32 v)
+{
+	return (v & 0x1ff) << 0;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL_ADDR_F(v) \
+	host1x_sync_cfpeek_ctrl_addr_f(v)
+static inline u32 host1x_sync_cfpeek_ctrl_channr_f(u32 v)
+{
+	return (v & 0x7) << 16;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL_CHANNR_F(v) \
+	host1x_sync_cfpeek_ctrl_channr_f(v)
+static inline u32 host1x_sync_cfpeek_ctrl_ena_f(u32 v)
+{
+	return (v & 0x1) << 31;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL_ENA_F(v) \
+	host1x_sync_cfpeek_ctrl_ena_f(v)
+static inline u32 host1x_sync_cfpeek_read_r(void)
+{
+	return 0x750;
+}
+#define HOST1X_SYNC_CFPEEK_READ \
+	host1x_sync_cfpeek_read_r()
+static inline u32 host1x_sync_cfpeek_ptrs_r(void)
+{
+	return 0x754;
+}
+#define HOST1X_SYNC_CFPEEK_PTRS \
+	host1x_sync_cfpeek_ptrs_r()
+static inline u32 host1x_sync_cfpeek_ptrs_cf_rd_ptr_v(u32 r)
+{
+	return (r >> 0) & 0x1ff;
+}
+#define HOST1X_SYNC_CFPEEK_PTRS_CF_RD_PTR_V(r) \
+	host1x_sync_cfpeek_ptrs_cf_rd_ptr_v(r)
+static inline u32 host1x_sync_cfpeek_ptrs_cf_wr_ptr_v(u32 r)
+{
+	return (r >> 16) & 0x1ff;
+}
+#define HOST1X_SYNC_CFPEEK_PTRS_CF_WR_PTR_V(r) \
+	host1x_sync_cfpeek_ptrs_cf_wr_ptr_v(r)
+static inline u32 host1x_sync_cbstat_r(unsigned int channel)
+{
+	return 0x758 + channel * REGISTER_STRIDE;
+}
+#define HOST1X_SYNC_CBSTAT(channel) \
+	host1x_sync_cbstat_r(channel)
+static inline u32 host1x_sync_cbstat_cboffset_v(u32 r)
+{
+	return (r >> 0) & 0xffff;
+}
+#define HOST1X_SYNC_CBSTAT_CBOFFSET_V(r) \
+	host1x_sync_cbstat_cboffset_v(r)
+static inline u32 host1x_sync_cbstat_cbclass_v(u32 r)
+{
+	return (r >> 16) & 0x3ff;
+}
+#define HOST1X_SYNC_CBSTAT_CBCLASS_V(r) \
+	host1x_sync_cbstat_cbclass_v(r)
+
 #endif /* __hw_host1x01_sync_h__ */
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
index 7af6609..42f3ce1 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
@@ -87,6 +87,12 @@ static inline u32 host1x_uclass_wait_syncpt_thresh_f(u32 v)
 }
 #define HOST1X_UCLASS_WAIT_SYNCPT_THRESH_F(v) \
 	host1x_uclass_wait_syncpt_thresh_f(v)
+static inline u32 host1x_uclass_wait_syncpt_base_r(void)
+{
+	return 0x9;
+}
+#define HOST1X_UCLASS_WAIT_SYNCPT_BASE \
+	host1x_uclass_wait_syncpt_base_r()
 static inline u32 host1x_uclass_wait_syncpt_base_indx_f(u32 v)
 {
 	return (v & 0xff) << 24;
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index 2c1f4af..6117499 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -86,6 +86,7 @@ static void syncpt_cpu_incr(struct host1x_syncpt *sp)
 	    host1x_syncpt_idle(sp)) {
 		dev_err(host->dev, "Trying to increment syncpoint id %d beyond max\n",
 			sp->id);
+		host1x_debug_dump(sp->host);
 		return;
 	}
 	host1x_sync_writel(host, BIT_MASK(sp->id),
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 7e77e63..4b49345 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -25,6 +25,7 @@
 #include "syncpt.h"
 #include "dev.h"
 #include "intr.h"
+#include "debug.h"
 
 #define SYNCPT_CHECK_PERIOD (2 * HZ)
 #define MAX_STUCK_CHECK_COUNT 15
@@ -231,6 +232,10 @@ int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh, long timeout,
 				"%s: syncpoint id %d (%s) stuck waiting %d, timeout=%ld\n",
 				 current->comm, sp->id, sp->name,
 				 thresh, timeout);
+
+			host1x_debug_dump_syncpts(sp->host);
+			if (check_count == MAX_STUCK_CHECK_COUNT)
+				host1x_debug_dump(sp->host);
 			check_count++;
 		}
 	}
-- 
1.7.9.5

