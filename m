Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbaJ1L1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:27:33 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:43612 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbaJ1L1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:30 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH 05/11] drivers: char: axd: add buffers manipulation files
Date: Tue, 28 Oct 2014 11:26:23 +0000
Message-ID: <1414495589-8579-6-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these files support initilising and managing access to the shared
buffers area in memory that is used to exchange data between AXD
and linux

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <alsa-devel@alsa-project.org>
---
 drivers/char/axd/axd_buffers.c | 245 +++++++++++++++++++++++++++++++++++++++++
 drivers/char/axd/axd_buffers.h |  70 ++++++++++++
 2 files changed, 315 insertions(+)
 create mode 100644 drivers/char/axd/axd_buffers.c
 create mode 100644 drivers/char/axd/axd_buffers.h

diff --git a/drivers/char/axd/axd_buffers.c b/drivers/char/axd/axd_buffers.c
new file mode 100644
index 000000000000..fefa7f85f4db
--- /dev/null
+++ b/drivers/char/axd/axd_buffers.c
@@ -0,0 +1,245 @@
+/*
+ * Copyright (C) 2011-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * AXD generic buffer management API.
+ */
+#include <linux/err.h>
+#include <linux/slab.h>
+
+#include "axd_buffers.h"
+
+#ifdef DEBUG_BUFFERS
+#define debugbuf	printk
+#else
+#define debugbuf(format, ...)
+#endif
+
+/**
+ * axd_buffer_init - sets up axd buffer as a pool of fixed sized buffers.
+ * @address: starting address of the buffer as set up in the system
+ * @total_size: total size of available buffer
+ * @element_size: size of each buffer element
+ *
+ * axd_buffer_t *buffer is a memory pool of size @element_size and starting at
+ * address @address and of @total_size size.
+ */
+static int bufferq_init(struct axd_bufferq *bufferq, const char *name,
+			char *address, unsigned int num_elements,
+			unsigned int element_size, unsigned int nonblock)
+{
+	int i;
+	char **queue;
+	unsigned int *size;
+
+	strncpy(bufferq->name, name, 16);
+	bufferq->stride = element_size;
+	bufferq->max = num_elements;
+	bufferq->rd_idx = 0;
+	bufferq->wr_idx = 0;
+	bufferq->nonblock = nonblock;
+	queue = kcalloc(num_elements, sizeof(char *), GFP_KERNEL);
+	if (!queue)
+		return -ENOMEM;
+	bufferq->queue = queue;
+	size = kcalloc(num_elements, sizeof(unsigned int), GFP_KERNEL);
+	if (!size) {
+		kfree(queue);
+		bufferq->queue = NULL;
+		return -ENOMEM;
+	}
+	bufferq->size = size;
+	/*
+	 * setup the queue with all available buffer addresses if the base
+	 * address is passed. Set it up as emptry if base address is NULL.
+	 */
+	if (address) {
+		for (i = 0; i < num_elements; i++) {
+			queue[i] = address + (element_size * i);
+			size[i] = element_size;
+		}
+		sema_init(&bufferq->rd_sem, num_elements);
+		sema_init(&bufferq->wr_sem, 0);
+	} else {
+		for (i = 0; i < num_elements; i++) {
+			queue[i] = NULL;
+			size[i] = element_size;
+		}
+		sema_init(&bufferq->rd_sem, 0);
+		sema_init(&bufferq->wr_sem, num_elements);
+	}
+	spin_lock_init(&bufferq->q_rdlock);
+	spin_lock_init(&bufferq->q_wrlock);
+	debugbuf("Initialized %s of %d elements of size %d bytes\n",
+					name, num_elements, element_size);
+	debugbuf("Address of %s: 0x%08X\n", name, (unsigned int)bufferq);
+	return 0;
+}
+
+int axd_bufferq_init(struct axd_bufferq *bufferq, const char *name,
+			char *address, unsigned int num_elements,
+			unsigned int element_size, unsigned int nonblock)
+{
+	return bufferq_init(bufferq,
+			name, address, num_elements, element_size, nonblock);
+}
+
+int axd_bufferq_init_empty(struct axd_bufferq *bufferq, const char *name,
+			unsigned int num_elements, unsigned int element_size,
+			unsigned int nonblock)
+{
+	return bufferq_init(bufferq,
+			name, NULL, num_elements, element_size, nonblock);
+}
+
+void axd_bufferq_clear(struct axd_bufferq *bufferq)
+{
+	kfree(bufferq->queue);
+	kfree(bufferq->size);
+	bufferq->queue = NULL;
+	bufferq->size = NULL;
+}
+
+/**
+ * axd_buffer_take - returns a valid buffer pointer
+ * @buffer: the buffers pool to be accessed
+ *
+ * This function will go into interruptible sleep if the pool is empty.
+ */
+char *axd_bufferq_take(struct axd_bufferq *bufferq, int *buf_size)
+{
+	char *buf;
+	int ret;
+
+	if (!bufferq->queue)
+		return NULL;
+
+	debugbuf("--(%s)-- taking new buffer\n", bufferq->name);
+	if (bufferq->nonblock) {
+		ret = down_trylock(&bufferq->rd_sem);
+		if (ret)
+			return ERR_PTR(-EAGAIN);
+
+	} else {
+		ret = down_interruptible(&bufferq->rd_sem);
+		if (ret)
+			return ERR_PTR(-ERESTARTSYS);
+		if (bufferq->abort_take) {
+			bufferq->abort_take = 0;
+			return ERR_PTR(-ERESTARTSYS);
+		}
+	}
+	/*
+	 * must ensure we have one access at a time to the queue and rd_idx
+	 * to be preemption and SMP safe
+	 * Sempahores will ensure that we will only read after a complete write
+	 * has finished, so we will never read and write from the same location.
+	 */
+	spin_lock(&bufferq->q_rdlock);
+	buf = bufferq->queue[bufferq->rd_idx];
+	if (buf_size)
+		*buf_size = bufferq->size[bufferq->rd_idx];
+	bufferq->rd_idx++;
+	if (bufferq->rd_idx >= bufferq->max)
+		bufferq->rd_idx = 0;
+	spin_unlock(&bufferq->q_rdlock);
+	up(&bufferq->wr_sem);
+	debugbuf("--(%s)-- took buffer <0x%08X>\n", bufferq->name,
+							(unsigned int)buf);
+	return buf;
+}
+
+/**
+ * axd_buffer_put - returns a buffer to the pool.
+ * @buffer: the buffers pool to be accessed
+ * @buf: the buffer to be returned.
+ *
+ * This function will go into interruptible sleep if the pool is full.
+ */
+int axd_bufferq_put(struct axd_bufferq *bufferq, char *buf, int buf_size)
+{
+	int ret;
+
+	if (!bufferq->queue)
+		return 0;
+
+	if (buf_size < 0)
+		buf_size = bufferq->stride;
+
+	debugbuf("++(%s)++ returning buffer\n", bufferq->name);
+	if (bufferq->nonblock) {
+		ret = down_trylock(&bufferq->wr_sem);
+		if (ret)
+			return -EAGAIN;
+
+	} else {
+		ret = down_interruptible(&bufferq->wr_sem);
+		if (ret)
+			return -ERESTARTSYS;
+		if (bufferq->abort_put) {
+			bufferq->abort_put = 0;
+			return -ERESTARTSYS;
+		}
+	}
+	/*
+	 * must ensure we have one access at a time to the queue and wr_idx
+	 * to be preemption and SMP safe.
+	 * Semaphores will ensure that we only write after a complete read has
+	 * finished, so we will never write and read from the same location.
+	 */
+	spin_lock(&bufferq->q_wrlock);
+	bufferq->queue[bufferq->wr_idx] = buf;
+	bufferq->size[bufferq->wr_idx] = buf_size;
+	bufferq->wr_idx++;
+	if (bufferq->wr_idx >= bufferq->max)
+		bufferq->wr_idx = 0;
+	spin_unlock(&bufferq->q_wrlock);
+	up(&bufferq->rd_sem);
+	debugbuf("++(%s)++ returned buffer <0x%08X>\n", bufferq->name,
+							(unsigned int)buf);
+	return 0;
+}
+
+int axd_bufferq_is_full(struct axd_bufferq *bufferq)
+{
+	int ret;
+	/*
+	 * if we can't put a buffer, then we're full.
+	 */
+	ret = down_trylock(&bufferq->wr_sem);
+	if (!ret)
+		up(&bufferq->wr_sem);
+	return ret;
+}
+
+int axd_bufferq_is_empty(struct axd_bufferq *bufferq)
+{
+	int ret;
+	/*
+	 * if we can't take more buffers, then its empty.
+	 */
+	ret = down_trylock(&bufferq->rd_sem);
+	if (!ret)
+		up(&bufferq->rd_sem);
+	return ret;
+}
+
+void axd_bufferq_abort_take(struct axd_bufferq *bufferq)
+{
+	if (axd_bufferq_is_empty(bufferq)) {
+		bufferq->abort_take = 1;
+		up(&bufferq->rd_sem);
+	}
+}
+
+void axd_bufferq_abort_put(struct axd_bufferq *bufferq)
+{
+	if (axd_bufferq_is_full(bufferq)) {
+		bufferq->abort_put = 1;
+		up(&bufferq->wr_sem);
+	}
+}
diff --git a/drivers/char/axd/axd_buffers.h b/drivers/char/axd/axd_buffers.h
new file mode 100644
index 000000000000..745a5e28b36f
--- /dev/null
+++ b/drivers/char/axd/axd_buffers.h
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2011-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * AXD generic buffer management API.
+ */
+#ifndef AXD_BUFFERS_H_
+#define AXD_BUFFERS_H_
+
+#include <linux/semaphore.h>
+#include <linux/spinlock.h>
+
+/**
+ * struct axd_bufferq - axd buffer management structure
+ * @name:	name of the buffer queue
+ * @stride:	the space between buffers in memory
+ * @max:	total number of buffers this queue can handle
+ * @rd_idx:	read index of the circular buffer
+ * @wr_idx:	write index of the circular buffer
+ * @rd_sem:	semaphore to block when full
+ * @wr_sem:	semaphore to block when empty
+ * @q_rdlock:	smp critical section protection for reads
+ * @q_wrlock:	smp critical section protection for writes
+ * @queue:	array of pointers to buffer addresses
+ * @size:	array of buffer's actual amount of data it has inside or it can
+ *		store.
+ * @nonblock:	return an error instead of block when empty/full
+ * @abort_take:	abort any pending blocked take operation
+ * @abort_put:	abort any pending blocked put operation
+ *
+ * axd_bufferq takes a contiguous memory region and divides it into smaller
+ * buffers regions of equal size and represents it as a queue. To avoid
+ * excessive locking it's done as a circular buffer queue.
+ */
+struct axd_bufferq {
+	char name[16];
+	unsigned int stride;
+	unsigned int max;
+	unsigned int rd_idx;
+	unsigned int wr_idx;
+	struct semaphore rd_sem;
+	struct semaphore wr_sem;
+	spinlock_t q_rdlock;
+	spinlock_t q_wrlock;
+	char **queue;
+	unsigned int *size;
+	unsigned int nonblock;
+	unsigned int abort_take;
+	unsigned int abort_put;
+};
+
+int axd_bufferq_init(struct axd_bufferq *bufferq, const char *name,
+			char *address, unsigned int num_elements,
+			unsigned int element_size, unsigned int nonblock);
+int axd_bufferq_init_empty(struct axd_bufferq *bufferq, const char *name,
+			unsigned int num_elements, unsigned int element_size,
+			unsigned int nonblock);
+void axd_bufferq_clear(struct axd_bufferq *bufferq);
+char *axd_bufferq_take(struct axd_bufferq *bufferq, int *buf_size);
+int axd_bufferq_put(struct axd_bufferq *bufferq, char *buf, int buf_size);
+int axd_bufferq_is_full(struct axd_bufferq *bufferq);
+int axd_bufferq_is_empty(struct axd_bufferq *bufferq);
+void axd_bufferq_abort_take(struct axd_bufferq *bufferq);
+void axd_bufferq_abort_put(struct axd_bufferq *bufferq);
+
+#endif /* AXD_BUFFERS_H_ */
-- 
2.1.0

