Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3AOLjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:39:11 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11713 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3AOLjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:39:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 15 Jan 2013 03:38:12 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <amerilainen@nvidia.com>, <airlied@linux.ie>,
        <thierry.reding@avionic-design.de>
CC: <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [PATCHv5,RESEND 4/8] gpu: host1x: Add debug support
Date: Tue, 15 Jan 2013 13:44:00 +0200
Message-ID: <1358250244-9678-5-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for host1x debugging. Adds debugfs entries, and dumps
channel state to UART in case of stuck job.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Makefile                 |    1 +
 drivers/gpu/host1x/cdma.c                   |   34 +++
 drivers/gpu/host1x/debug.c                  |  215 ++++++++++++++
 drivers/gpu/host1x/debug.h                  |   50 ++++
 drivers/gpu/host1x/dev.c                    |    3 +
 drivers/gpu/host1x/dev.h                    |   17 ++
 drivers/gpu/host1x/hw/cdma_hw.c             |    3 +
 drivers/gpu/host1x/hw/debug_hw.c            |  400 +++++++++++++++++++++++++++
 drivers/gpu/host1x/hw/host1x01.c            |    2 +
 drivers/gpu/host1x/hw/hw_host1x01_channel.h |   18 ++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h    |  115 ++++++++
 drivers/gpu/host1x/hw/syncpt_hw.c           |    1 +
 drivers/gpu/host1x/syncpt.c                 |    3 +
 13 files changed, 862 insertions(+)
 create mode 100644 drivers/gpu/host1x/debug.c
 create mode 100644 drivers/gpu/host1x/debug.h
 create mode 100644 drivers/gpu/host1x/hw/debug_hw.c

diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index cdd87c8..697d49a 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -7,6 +7,7 @@ host1x-y = \
 	cdma.o \
 	channel.o \
 	job.o \
+	debug.o \
 	memmgr.o \
 	hw/host1x01.o
 
diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
index d6a38d2..12dd46c 100644
--- a/drivers/gpu/host1x/cdma.c
+++ b/drivers/gpu/host1x/cdma.c
@@ -19,6 +19,7 @@
 #include "cdma.h"
 #include "channel.h"
 #include "dev.h"
+#include "debug.h"
 #include "memmgr.h"
 #include "job.h"
 #include <asm/cacheflush.h>
@@ -370,12 +371,42 @@ int host1x_cdma_begin(struct host1x_cdma *cdma, struct host1x_job *job)
 	return 0;
 }
 
+static void trace_write_gather(struct host1x_cdma *cdma,
+		struct mem_handle *ref,
+		u32 offset, u32 words)
+{
+	void *mem = NULL;
+
+	if (host1x_debug_trace_cmdbuf)
+		mem = host1x_memmgr_mmap(ref);
+
+	if (mem) {
+		u32 i;
+		/*
+		 * Write in batches of 128 as there seems to be a limit
+		 * of how much you can output to ftrace at once.
+		 */
+		for (i = 0; i < words; i += TRACE_MAX_LENGTH) {
+			trace_host1x_cdma_push_gather(
+				cdma_to_channel(cdma)->dev->name,
+				(u32)ref,
+				min(words - i, TRACE_MAX_LENGTH),
+				offset + i * sizeof(u32),
+				mem);
+		}
+		host1x_memmgr_munmap(ref, mem);
+	}
+}
+
 /*
  * Push two words into a push buffer slot
  * Blocks as necessary if the push buffer is full.
  */
 void host1x_cdma_push(struct host1x_cdma *cdma, u32 op1, u32 op2)
 {
+	if (host1x_debug_trace_cmdbuf)
+		trace_host1x_cdma_push(cdma_to_channel(cdma)->dev->name,
+				op1, op2);
 	host1x_cdma_push_gather(cdma, NULL, 0, op1, op2);
 }
 
@@ -391,6 +422,9 @@ void host1x_cdma_push_gather(struct host1x_cdma *cdma,
 	u32 slots_free = cdma->slots_free;
 	struct push_buffer *pb = &cdma->push_buffer;
 
+	if (handle)
+		trace_write_gather(cdma, handle, offset, op1 & 0xffff);
+
 	if (slots_free == 0) {
 		host1x->cdma_op.kick(cdma);
 		slots_free = host1x_cdma_wait_locked(cdma,
diff --git a/drivers/gpu/host1x/debug.c b/drivers/gpu/host1x/debug.c
new file mode 100644
index 0000000..29cbe93
--- /dev/null
+++ b/drivers/gpu/host1x/debug.c
@@ -0,0 +1,215 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Erik Gilling <konkers@android.com>
+ *
+ * Copyright (C) 2011-2012 NVIDIA Corporation
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
+static pid_t host1x_debug_null_kickoff_pid;
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
+static int show_channels(struct host1x_channel *ch, void *data)
+{
+	struct host1x *m = host1x_get_host(ch->dev);
+	struct output *o = data;
+
+	mutex_lock(&ch->reflock);
+	if (ch->refcount) {
+		mutex_lock(&ch->cdma.lock);
+		m->debug_op.show_channel_fifo(m, ch, o, ch->chid);
+		m->debug_op.show_channel_cdma(m, ch, o, ch->chid);
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
+		u32 min = host1x_syncpt_load_min(m->syncpt + i);
+		if (!min && !max)
+			continue;
+		host1x_debug_output(o, "id %d (%s) min %d max %d\n",
+			i, m->syncpt[i].name,
+			min, max);
+	}
+
+	for (i = 0; i < host1x_syncpt_nb_bases(m); i++) {
+		u32 base_val;
+		base_val = host1x_syncpt_read_wait_base(m->syncpt + i);
+		if (base_val)
+			host1x_debug_output(o, "waitbase id %d val %d\n",
+					i, base_val);
+	}
+
+	host1x_debug_output(o, "\n");
+}
+
+static void show_all(struct host1x *m, struct output *o)
+{
+	m->debug_op.show_mlocks(m, o);
+	show_syncpts(m, o);
+	host1x_debug_output(o, "---- channels ----\n");
+	host1x_channel_for_all(m, o, show_channels);
+}
+
+#ifdef CONFIG_DEBUG_FS
+static int show_channels_no_fifo(struct host1x_channel *ch, void *data)
+{
+	struct host1x *host1x = host1x_get_host(ch->dev);
+	struct output *o = data;
+
+	mutex_lock(&ch->reflock);
+	if (ch->refcount) {
+		mutex_lock(&ch->cdma.lock);
+		host1x->debug_op.show_channel_cdma(host1x, ch, o, ch->chid);
+		mutex_unlock(&ch->cdma.lock);
+	}
+	mutex_unlock(&ch->reflock);
+
+	return 0;
+}
+
+static void show_all_no_fifo(struct host1x *host1x, struct output *o)
+{
+	host1x->debug_op.show_mlocks(host1x, o);
+	show_syncpts(host1x, o);
+	host1x_debug_output(o, "---- channels ----\n");
+	host1x_channel_for_all(host1x, o, show_channels_no_fifo);
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
+	debugfs_create_file("status", S_IRUGO, de,
+			host1x, &host1x_debug_fops);
+	debugfs_create_file("status_all", S_IRUGO, de,
+			host1x, &host1x_debug_all_fops);
+
+	debugfs_create_u32("null_kickoff_pid", S_IRUGO|S_IWUSR, de,
+			&host1x_debug_null_kickoff_pid);
+	debugfs_create_u32("trace_cmdbuf", S_IRUGO|S_IWUSR, de,
+			&host1x_debug_trace_cmdbuf);
+
+	if (host1x->debug_op.debug_init)
+		host1x->debug_op.debug_init(de);
+
+	debugfs_create_u32("force_timeout_pid", S_IRUGO|S_IWUSR, de,
+			&host1x_debug_force_timeout_pid);
+	debugfs_create_u32("force_timeout_val", S_IRUGO|S_IWUSR, de,
+			&host1x_debug_force_timeout_val);
+	debugfs_create_u32("force_timeout_channel", S_IRUGO|S_IWUSR, de,
+			&host1x_debug_force_timeout_channel);
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
diff --git a/drivers/gpu/host1x/debug.h b/drivers/gpu/host1x/debug.h
new file mode 100644
index 0000000..fd3560b
--- /dev/null
+++ b/drivers/gpu/host1x/debug.h
@@ -0,0 +1,50 @@
+/*
+ * Tegra host1x Debug
+ *
+ * Copyright (c) 2011-2012 NVIDIA Corporation.
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
+#ifndef __NVHOST_DEBUG_H
+#define __NVHOST_DEBUG_H
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
+void host1x_debug_init(struct host1x *master);
+void host1x_debug_deinit(struct host1x *master);
+void host1x_debug_dump(struct host1x *master);
+
+#endif /*__NVHOST_DEBUG_H */
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 80311ca..5aa7d28 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -26,6 +26,7 @@
 #include "dev.h"
 #include "intr.h"
 #include "channel.h"
+#include "debug.h"
 #include "hw/host1x01.h"
 
 #define CREATE_TRACE_POINTS
@@ -150,6 +151,8 @@ static int host1x_probe(struct platform_device *dev)
 
 	host1x_intr_start(&host->intr, clk_get_rate(host->clk));
 
+	host1x_debug_init(host);
+
 	dev_info(&dev->dev, "initialized\n");
 
 	return 0;
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index 2fefa78..467a92e 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -33,6 +33,7 @@ struct push_buffer;
 struct dentry;
 struct mem_handle;
 struct platform_device;
+struct output;
 
 struct host1x_channel_ops {
 	int (*init)(struct host1x_channel *,
@@ -71,6 +72,21 @@ struct host1x_pushbuffer_ops {
 	u32 (*putptr)(struct push_buffer *);
 };
 
+struct host1x_debug_ops {
+	void (*debug_init)(struct dentry *de);
+	void (*show_channel_cdma)(struct host1x *,
+				  struct host1x_channel *,
+				  struct output *,
+				  int chid);
+	void (*show_channel_fifo)(struct host1x *,
+				  struct host1x_channel *,
+				  struct output *,
+				  int chid);
+	void (*show_mlocks)(struct host1x *m,
+			    struct output *o);
+
+};
+
 struct host1x_syncpt_ops {
 	void (*reset)(struct host1x_syncpt *);
 	void (*reset_wait_base)(struct host1x_syncpt *);
@@ -117,6 +133,7 @@ struct host1x {
 	struct host1x_channel_ops channel_op;
 	struct host1x_cdma_ops cdma_op;
 	struct host1x_pushbuffer_ops cdma_pb_op;
+	struct host1x_debug_ops debug_op;
 	struct host1x_syncpt_ops syncpt_op;
 	struct host1x_intr_ops intr_op;
 
diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 7a44418..2228246 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -22,6 +22,7 @@
 #include "cdma.h"
 #include "channel.h"
 #include "dev.h"
+#include "debug.h"
 #include "memmgr.h"
 
 #include "cdma_hw.h"
@@ -407,6 +408,8 @@ static void cdma_timeout_handler(struct work_struct *work)
 	host1x = cdma_to_host1x(cdma);
 	ch = cdma_to_channel(cdma);
 
+	host1x_debug_dump(cdma_to_host1x(cdma));
+
 	mutex_lock(&cdma->lock);
 
 	if (!cdma->timeout.clientid) {
diff --git a/drivers/gpu/host1x/hw/debug_hw.c b/drivers/gpu/host1x/hw/debug_hw.c
new file mode 100644
index 0000000..0b8d466
--- /dev/null
+++ b/drivers/gpu/host1x/hw/debug_hw.c
@@ -0,0 +1,400 @@
+/*
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Erik Gilling <konkers@android.com>
+ *
+ * Copyright (C) 2011 NVIDIA Corporation
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
+#include "memmgr.h"
+
+#define NVHOST_DEBUG_MAX_PAGE_OFFSET 102400
+
+enum {
+	NVHOST_DBG_STATE_CMD = 0,
+	NVHOST_DBG_STATE_DATA = 1,
+	NVHOST_DBG_STATE_GATHER = 2
+};
+
+static int show_channel_command(struct output *o, u32 addr, u32 val, int *count)
+{
+	unsigned mask;
+	unsigned subop;
+
+	switch (val >> 28) {
+	case 0x0:
+		mask = val & 0x3f;
+		if (mask) {
+			host1x_debug_output(o,
+				"SETCL(class=%03x, offset=%03x, mask=%02x, [",
+				val >> 6 & 0x3ff, val >> 16 & 0xfff, mask);
+			*count = hweight8(mask);
+			return NVHOST_DBG_STATE_DATA;
+		} else {
+			host1x_debug_output(o, "SETCL(class=%03x)\n",
+				val >> 6 & 0x3ff);
+			return NVHOST_DBG_STATE_CMD;
+		}
+
+	case 0x1:
+		host1x_debug_output(o, "INCR(offset=%03x, [",
+			val >> 16 & 0xfff);
+		*count = val & 0xffff;
+		return NVHOST_DBG_STATE_DATA;
+
+	case 0x2:
+		host1x_debug_output(o, "NONINCR(offset=%03x, [",
+			val >> 16 & 0xfff);
+		*count = val & 0xffff;
+		return NVHOST_DBG_STATE_DATA;
+
+	case 0x3:
+		mask = val & 0xffff;
+		host1x_debug_output(o, "MASK(offset=%03x, mask=%03x, [",
+			   val >> 16 & 0xfff, mask);
+		*count = hweight16(mask);
+		return NVHOST_DBG_STATE_DATA;
+
+	case 0x4:
+		host1x_debug_output(o, "IMM(offset=%03x, data=%03x)\n",
+			   val >> 16 & 0xfff, val & 0xffff);
+		return NVHOST_DBG_STATE_CMD;
+
+	case 0x5:
+		host1x_debug_output(o, "RESTART(offset=%08x)\n", val << 4);
+		return NVHOST_DBG_STATE_CMD;
+
+	case 0x6:
+		host1x_debug_output(o,
+			"GATHER(offset=%03x, insert=%d, type=%d, count=%04x, addr=[",
+			val >> 16 & 0xfff, val >> 15 & 0x1, val >> 14 & 0x1,
+			val & 0x3fff);
+		*count = val & 0x3fff; /* TODO: insert */
+		return NVHOST_DBG_STATE_GATHER;
+
+	case 0xe:
+		subop = val >> 24 & 0xf;
+		if (subop == 0)
+			host1x_debug_output(o, "ACQUIRE_MLOCK(index=%d)\n",
+				val & 0xff);
+		else if (subop == 1)
+			host1x_debug_output(o, "RELEASE_MLOCK(index=%d)\n",
+				val & 0xff);
+		else
+			host1x_debug_output(o, "EXTEND_UNKNOWN(%08x)\n", val);
+		return NVHOST_DBG_STATE_CMD;
+
+	default:
+		return NVHOST_DBG_STATE_CMD;
+	}
+}
+
+static void show_channel_gather(struct output *o, u32 addr,
+		phys_addr_t phys_addr, u32 words, struct host1x_cdma *cdma);
+
+static void show_channel_word(struct output *o, int *state, int *count,
+		u32 addr, u32 val, struct host1x_cdma *cdma)
+{
+	static int start_count, dont_print;
+
+	switch (*state) {
+	case NVHOST_DBG_STATE_CMD:
+		if (addr)
+			host1x_debug_output(o, "%08x: %08x:", addr, val);
+		else
+			host1x_debug_output(o, "%08x:", val);
+
+		*state = show_channel_command(o, addr, val, count);
+		dont_print = 0;
+		start_count = *count;
+		if (*state == NVHOST_DBG_STATE_DATA && *count == 0) {
+			*state = NVHOST_DBG_STATE_CMD;
+			host1x_debug_output(o, "])\n");
+		}
+		break;
+
+	case NVHOST_DBG_STATE_DATA:
+		(*count)--;
+		if (start_count - *count < 64)
+			host1x_debug_output(o, "%08x%s",
+				val, *count > 0 ? ", " : "])\n");
+		else if (!dont_print && (*count > 0)) {
+			host1x_debug_output(o, "[truncated; %d more words]\n",
+				*count);
+			dont_print = 1;
+		}
+		if (*count == 0)
+			*state = NVHOST_DBG_STATE_CMD;
+		break;
+
+	case NVHOST_DBG_STATE_GATHER:
+		*state = NVHOST_DBG_STATE_CMD;
+		host1x_debug_output(o, "%08x]):\n", val);
+		if (cdma) {
+			show_channel_gather(o, addr, val,
+					*count, cdma);
+		}
+		break;
+	}
+}
+
+static void do_show_channel_gather(struct output *o,
+		phys_addr_t phys_addr,
+		u32 words, struct host1x_cdma *cdma,
+		phys_addr_t pin_addr, u32 *map_addr)
+{
+	/* Map dmaget cursor to corresponding mem handle */
+	u32 offset;
+	int state, count, i;
+
+	offset = phys_addr - pin_addr;
+	/*
+	 * Sometimes we're given different hardware address to the same
+	 * page - in these cases the offset will get an invalid number and
+	 * we just have to bail out.
+	 */
+	if (offset > NVHOST_DEBUG_MAX_PAGE_OFFSET) {
+		host1x_debug_output(o, "[address mismatch]\n");
+	} else {
+		/* GATHER buffer starts always with commands */
+		state = NVHOST_DBG_STATE_CMD;
+		for (i = 0; i < words; i++)
+			show_channel_word(o, &state, &count,
+					phys_addr + i * 4,
+					*(map_addr + offset/4 + i),
+					cdma);
+	}
+}
+
+static void show_channel_gather(struct output *o, u32 addr,
+		phys_addr_t phys_addr,
+		u32 words, struct host1x_cdma *cdma)
+{
+	/* Map dmaget cursor to corresponding mem handle */
+	struct push_buffer *pb = &cdma->push_buffer;
+	u32 cur = addr - pb->phys;
+	struct mem_handle *mem = pb->handle[cur/8];
+	u32 *map_addr, offset;
+	struct sg_table *sgt;
+
+	if (!mem) {
+		host1x_debug_output(o, "[already deallocated]\n");
+		return;
+	}
+
+	map_addr = host1x_memmgr_mmap(mem);
+	if (!map_addr) {
+		host1x_debug_output(o, "[could not mmap]\n");
+		return;
+	}
+
+	/* Get base address from mem */
+	sgt = host1x_memmgr_pin(mem);
+	if (IS_ERR(sgt)) {
+		host1x_debug_output(o, "[couldn't pin]\n");
+		host1x_memmgr_munmap(mem, map_addr);
+		return;
+	}
+
+	offset = phys_addr - sg_dma_address(sgt->sgl);
+	do_show_channel_gather(o, phys_addr, words, cdma,
+			sg_dma_address(sgt->sgl), map_addr);
+	host1x_memmgr_unpin(mem, sgt);
+	host1x_memmgr_munmap(mem, map_addr);
+}
+
+static void show_channel_gathers(struct output *o, struct host1x_cdma *cdma)
+{
+	struct host1x_job *job;
+
+	list_for_each_entry(job, &cdma->sync_queue, list) {
+		int i;
+		host1x_debug_output(o,
+				"\n%p: JOB, syncpt_id=%d, syncpt_val=%d,"
+				" first_get=%08x, timeout=%d"
+				" num_slots=%d, num_handles=%d\n",
+				job,
+				job->syncpt_id,
+				job->syncpt_end,
+				job->first_get,
+				job->timeout,
+				job->num_slots,
+				job->num_unpins);
+
+		for (i = 0; i < job->num_gathers; i++) {
+			struct host1x_job_gather *g = &job->gathers[i];
+			u32 *mapped = host1x_memmgr_mmap(g->ref);
+			if (!mapped) {
+				host1x_debug_output(o, "[could not mmap]\n");
+				continue;
+			}
+
+			host1x_debug_output(o,
+				"    GATHER at %08x+%04x, %d words\n",
+				g->mem_base, g->offset, g->words);
+
+			do_show_channel_gather(o, g->mem_base + g->offset,
+					g->words, cdma, g->mem_base, mapped);
+			host1x_memmgr_munmap(g->ref, mapped);
+		}
+	}
+}
+
+static void host1x_debug_show_channel_cdma(struct host1x *m,
+	struct host1x_channel *ch, struct output *o, int chid)
+{
+	struct host1x_channel *channel = ch;
+	struct host1x_cdma *cdma = &channel->cdma;
+	u32 dmaput, dmaget, dmactrl;
+	u32 cbstat, cbread;
+	u32 val, base, baseval;
+
+	dmaput = host1x_ch_readl(channel, HOST1X_CHANNEL_DMAPUT);
+	dmaget = host1x_ch_readl(channel, HOST1X_CHANNEL_DMAGET);
+	dmactrl = host1x_ch_readl(channel, HOST1X_CHANNEL_DMACTRL);
+	cbread = host1x_sync_readl(m, HOST1X_SYNC_CBREAD0 + 4 * chid);
+	cbstat = host1x_sync_readl(m, HOST1X_SYNC_CBSTAT_0 + 4 * chid);
+
+	host1x_debug_output(o, "%d-%s: ", chid,
+			    channel->dev->name);
+
+	if (HOST1X_CHANNEL_DMACTRL_DMASTOP_V(dmactrl)
+		|| !channel->cdma.push_buffer.mapped) {
+		host1x_debug_output(o, "inactive\n\n");
+		return;
+	}
+
+	switch (cbstat) {
+	case 0x00010008:
+		host1x_debug_output(o, "waiting on syncpt %d val %d\n",
+			cbread >> 24, cbread & 0xffffff);
+		break;
+
+	case 0x00010009:
+		base = (cbread >> 16) & 0xff;
+		baseval = host1x_sync_readl(m,
+				HOST1X_SYNC_SYNCPT_BASE_0 + 4 * base);
+		val = cbread & 0xffff;
+		host1x_debug_output(o, "waiting on syncpt %d val %d "
+			  "(base %d = %d; offset = %d)\n",
+			cbread >> 24, baseval + val,
+			base, baseval, val);
+		break;
+
+	default:
+		host1x_debug_output(o,
+				"active class %02x, offset %04x, val %08x\n",
+				HOST1X_SYNC_CBSTAT_0_CBCLASS0_V(cbstat),
+				HOST1X_SYNC_CBSTAT_0_CBOFFSET0_V(cbstat),
+				cbread);
+		break;
+	}
+
+	host1x_debug_output(o, "DMAPUT %08x, DMAGET %08x, DMACTL %08x\n",
+		dmaput, dmaget, dmactrl);
+	host1x_debug_output(o, "CBREAD %08x, CBSTAT %08x\n", cbread, cbstat);
+
+	show_channel_gathers(o, cdma);
+	host1x_debug_output(o, "\n");
+}
+
+static void host1x_debug_show_channel_fifo(struct host1x *m,
+	struct host1x_channel *ch, struct output *o, int chid)
+{
+	u32 val, rd_ptr, wr_ptr, start, end;
+	struct host1x_channel *channel = ch;
+	int state, count;
+
+	host1x_debug_output(o, "%d: fifo:\n", chid);
+
+	val = host1x_ch_readl(channel, HOST1X_CHANNEL_FIFOSTAT);
+	host1x_debug_output(o, "FIFOSTAT %08x\n", val);
+	if (HOST1X_CHANNEL_FIFOSTAT_CFEMPTY_V(val)) {
+		host1x_debug_output(o, "[empty]\n");
+		return;
+	}
+
+	host1x_sync_writel(m, 0x0, HOST1X_SYNC_CFPEEK_CTRL);
+	host1x_sync_writel(m, HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_ENA_F(1)
+			| HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_CHANNR_F(chid),
+		HOST1X_SYNC_CFPEEK_CTRL);
+
+	val = host1x_sync_readl(m, HOST1X_SYNC_CFPEEK_PTRS);
+	rd_ptr = HOST1X_SYNC_CFPEEK_PTRS_CF_RD_PTR_V(val);
+	wr_ptr = HOST1X_SYNC_CFPEEK_PTRS_CF_WR_PTR_V(val);
+
+	val = host1x_sync_readl(m, HOST1X_SYNC_CF0_SETUP + 4 * chid);
+	start = HOST1X_SYNC_CF0_SETUP_CF0_BASE_V(val);
+	end = HOST1X_SYNC_CF0_SETUP_CF0_LIMIT_V(val);
+
+	state = NVHOST_DBG_STATE_CMD;
+
+	do {
+		host1x_sync_writel(m, 0x0, HOST1X_SYNC_CFPEEK_CTRL);
+		host1x_sync_writel(m, HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_ENA_F(1)
+				| HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_CHANNR_F(chid)
+				| HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_ADDR_F(rd_ptr),
+			HOST1X_SYNC_CFPEEK_CTRL);
+		val = host1x_sync_readl(m, HOST1X_SYNC_CFPEEK_READ);
+
+		show_channel_word(o, &state, &count, 0, val, NULL);
+
+		if (rd_ptr == end)
+			rd_ptr = start;
+		else
+			rd_ptr++;
+	} while (rd_ptr != wr_ptr);
+
+	if (state == NVHOST_DBG_STATE_DATA)
+		host1x_debug_output(o, ", ...])\n");
+	host1x_debug_output(o, "\n");
+
+	host1x_sync_writel(m, 0x0, HOST1X_SYNC_CFPEEK_CTRL);
+}
+
+static void host1x_debug_show_mlocks(struct host1x *m, struct output *o)
+{
+	int i;
+
+	host1x_debug_output(o, "---- mlocks ----\n");
+	for (i = 0; i < host1x_syncpt_nb_mlocks(m); i++) {
+		u32 owner = host1x_sync_readl(m,
+				HOST1X_SYNC_MLOCK_OWNER_0 + i);
+		if (HOST1X_SYNC_MLOCK_OWNER_0_MLOCK_CH_OWNS_0_V(owner))
+			host1x_debug_output(o, "%d: locked by channel %d\n",
+				i,
+				HOST1X_SYNC_MLOCK_OWNER_0_MLOCK_OWNER_CHID_0_F(
+					owner));
+		else if (HOST1X_SYNC_MLOCK_OWNER_0_MLOCK_CPU_OWNS_0_V(owner))
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
index 7569a1e..1bc1552 100644
--- a/drivers/gpu/host1x/hw/host1x01.c
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -28,6 +28,7 @@
 
 #include "hw/channel_hw.c"
 #include "hw/cdma_hw.c"
+#include "hw/debug_hw.c"
 #include "hw/syncpt_hw.c"
 #include "hw/intr_hw.c"
 
@@ -36,6 +37,7 @@ int host1x01_init(struct host1x *host)
 	host->channel_op = host1x_channel_ops;
 	host->cdma_op = host1x_cdma_ops;
 	host->cdma_pb_op = host1x_pushbuffer_ops;
+	host->debug_op = host1x_debug_ops;
 	host->syncpt_op = host1x_syncpt_ops;
 	host->intr_op = host1x_intr_ops;
 
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_channel.h b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
index dad4fee..79bcd5a 100644
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
@@ -87,6 +99,12 @@ static inline u32 host1x_channel_dmactrl_dmastop_f(u32 v)
 }
 #define HOST1X_CHANNEL_DMACTRL_DMASTOP_F(v) \
 	host1x_channel_dmactrl_dmastop_f(v)
+static inline u32 host1x_channel_dmactrl_dmastop_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+#define HOST1X_CHANNEL_DMACTRL_DMASTOP_V(r) \
+	host1x_channel_dmactrl_dmastop_v(r)
 static inline u32 host1x_channel_dmactrl_dmagetrst_f(u32 v)
 {
 	return (v & 0x1) << 1;
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
index 3073d37..22daa3f 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_sync.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -69,6 +69,24 @@ static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(void)
 }
 #define HOST1X_SYNC_SYNCPT_THRESH_INT_ENABLE_CPU0 \
 	host1x_sync_syncpt_thresh_int_enable_cpu0_r()
+static inline u32 host1x_sync_cf0_setup_r(void)
+{
+	return 0x80;
+}
+#define HOST1X_SYNC_CF0_SETUP \
+	host1x_sync_cf0_setup_r()
+static inline u32 host1x_sync_cf0_setup_cf0_base_v(u32 r)
+{
+	return (r >> 0) & 0x1ff;
+}
+#define HOST1X_SYNC_CF0_SETUP_CF0_BASE_V(r) \
+	host1x_sync_cf0_setup_cf0_base_v(r)
+static inline u32 host1x_sync_cf0_setup_cf0_limit_v(u32 r)
+{
+	return (r >> 16) & 0x1ff;
+}
+#define HOST1X_SYNC_CF0_SETUP_CF0_LIMIT_V(r) \
+	host1x_sync_cf0_setup_cf0_limit_v(r)
 static inline u32 host1x_sync_cmdproc_stop_r(void)
 {
 	return 0xac;
@@ -99,6 +117,30 @@ static inline u32 host1x_sync_ip_busy_timeout_r(void)
 }
 #define HOST1X_SYNC_IP_BUSY_TIMEOUT \
 	host1x_sync_ip_busy_timeout_r()
+static inline u32 host1x_sync_mlock_owner_0_r(void)
+{
+	return 0x340;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_0 \
+	host1x_sync_mlock_owner_0_r()
+static inline u32 host1x_sync_mlock_owner_0_mlock_owner_chid_0_f(u32 v)
+{
+	return (v & 0xf) << 8;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_0_MLOCK_OWNER_CHID_0_F(v) \
+	host1x_sync_mlock_owner_0_mlock_owner_chid_0_f(v)
+static inline u32 host1x_sync_mlock_owner_0_mlock_cpu_owns_0_v(u32 r)
+{
+	return (r >> 1) & 0x1;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_0_MLOCK_CPU_OWNS_0_V(r) \
+	host1x_sync_mlock_owner_0_mlock_cpu_owns_0_v(r)
+static inline u32 host1x_sync_mlock_owner_0_mlock_ch_owns_0_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+#define HOST1X_SYNC_MLOCK_OWNER_0_MLOCK_CH_OWNS_0_V(r) \
+	host1x_sync_mlock_owner_0_mlock_ch_owns_0_v(r)
 static inline u32 host1x_sync_syncpt_0_r(void)
 {
 	return 0x400;
@@ -123,4 +165,77 @@ static inline u32 host1x_sync_syncpt_cpu_incr_r(void)
 }
 #define HOST1X_SYNC_SYNCPT_CPU_INCR \
 	host1x_sync_syncpt_cpu_incr_r()
+static inline u32 host1x_sync_cbread0_r(void)
+{
+	return 0x720;
+}
+#define HOST1X_SYNC_CBREAD0 \
+	host1x_sync_cbread0_r()
+static inline u32 host1x_sync_cfpeek_ctrl_r(void)
+{
+	return 0x74c;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL \
+	host1x_sync_cfpeek_ctrl_r()
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_addr_f(u32 v)
+{
+	return (v & 0x1ff) << 0;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_ADDR_F(v) \
+	host1x_sync_cfpeek_ctrl_cfpeek_addr_f(v)
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_channr_f(u32 v)
+{
+	return (v & 0x7) << 16;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_CHANNR_F(v) \
+	host1x_sync_cfpeek_ctrl_cfpeek_channr_f(v)
+static inline u32 host1x_sync_cfpeek_ctrl_cfpeek_ena_f(u32 v)
+{
+	return (v & 0x1) << 31;
+}
+#define HOST1X_SYNC_CFPEEK_CTRL_CFPEEK_ENA_F(v) \
+	host1x_sync_cfpeek_ctrl_cfpeek_ena_f(v)
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
+static inline u32 host1x_sync_cbstat_0_r(void)
+{
+	return 0x758;
+}
+#define HOST1X_SYNC_CBSTAT_0 \
+	host1x_sync_cbstat_0_r()
+static inline u32 host1x_sync_cbstat_0_cboffset0_v(u32 r)
+{
+	return (r >> 0) & 0xffff;
+}
+#define HOST1X_SYNC_CBSTAT_0_CBOFFSET0_V(r) \
+	host1x_sync_cbstat_0_cboffset0_v(r)
+static inline u32 host1x_sync_cbstat_0_cbclass0_v(u32 r)
+{
+	return (r >> 16) & 0x3ff;
+}
+#define HOST1X_SYNC_CBSTAT_0_CBCLASS0_V(r) \
+	host1x_sync_cbstat_0_cbclass0_v(r)
+
 #endif /* __hw_host1x01_sync_h__ */
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index ba48cee..c64c3b0 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -90,6 +90,7 @@ static void syncpt_cpu_incr(struct host1x_syncpt *sp)
 		dev_err(&dev->dev->dev,
 			"Trying to increment syncpoint id %d beyond max\n",
 			sp->id);
+		host1x_debug_dump(sp->dev);
 		return;
 	}
 	host1x_sync_writel(dev, BIT_MASK(sp->id),
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index f21c688..191f65f 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -23,6 +23,7 @@
 #include "syncpt.h"
 #include "dev.h"
 #include "intr.h"
+#include "debug.h"
 #include <trace/events/host1x.h>
 
 #define MAX_SYNCPT_LENGTH	5
@@ -211,6 +212,8 @@ int host1x_syncpt_wait(struct host1x_syncpt *sp,
 				 current->comm, sp->id, sp->name,
 				 thresh, timeout);
 			sp->dev->syncpt_op.debug(sp);
+			if (check_count == MAX_STUCK_CHECK_COUNT)
+				host1x_debug_dump(sp->dev);
 			check_count++;
 		}
 	}
-- 
1.7.9.5

