Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaA3Tbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:31:50 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55394 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3Tbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:31:48 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2 1/2] zram: introduce compressing backend abstraction
Date: Thu, 30 Jan 2014 22:28:07 +0300
Message-Id: <1391110088-14830-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.rc1.183.g614c158
In-Reply-To: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZRAM performs direct LZO compression algorithm calls, making it the one
and only option. Introduce struct zram_comp in order to support multiple
compression algorithms. struct zram_comp defines the following set of
compressing backend operations:
	.create
	.destroy
	.compress
	.decompress
	.workmem_get
	.workmem_put

Schematically zram write() usually contains the following steps:
0) preparation (decompression of partioal IO, etc.)
1) lock buffer_lock mutex (protects meta compress buffers)
2) compress (using meta compress buffers)
3) alloc and map zs_pool object
4) copy compressed data (from meta compress buffers) to new object
5) free previous pool page, assign a new one
6) unlock buffer_lock mutex

As we can see, compressing buffers must remain untouched from 1) to 4),
because, otherwise, concurrent write() will overwrite data. At the same
time, zram_meta must be aware of a) specific compression algorithm
memory requirements and b) necessary locking to protect compression
buffers. Besides, zram holds buffer_lock almost through the whole write()
function, making parallel compression impossible. To remove requirement
a) new struct zcomp_workmem (workmem is a common term used by lzo, lz4
and zlib) contains buffers required by compression algorithm, while new
struct zcomp_wm_policy implements workmem handling and locking by means
of get() and put() semantics and removes requirement b) from zram meta.
In general, workmem_get() turns caller into exclusive user of workmem
and workem_put() makes a particular workmem available.

Each compressing backend may use a default workmem policy or provide
custom implementation. Default workmem policy (struct zcomp_wm_policy)
has a list of idle workmem buffers (at least 1 workmem), spinlock to
protect idle list and wait queue, making it possible to have parallel
compressions. Each time zram issues a workmem_get() call, the following
set of operations performed:
- spin lock buffer_lock
- if idle list is not empty, remove workmem from idle list, spin
  unlock and return workmem pointer
- if idle list is empty, current adds itself to wait queue. it will be
  awaken by workmem_put() caller.

workmem_put():
- spin lock buffer_lock
- add workmem to idle list
- spin unlock, wake up sleeper (if any)

zram_comp file contains array of supported compressing backends, which
can be altered according to user selection.

Usage examples. To initialize compressing backend:
	comp = zcomp_create(NAME) /* NAME e.g. lzo, lz4 */

which performs NAME lookup in array of supported compressing backends
and initialises compressing backend if requested algorithm is supported.
Compressing:
	wm = comp->workmem_get(comp)
	comp->compress(...)
	[..] /* copy compressed data */
	comp->workmem_put(comp, wm)

Free compessing backend and all ot its workmem buffers:
	zcomp_destroy(comp)

The patch implements LZO and LZ4 backends. At this point zcomp_wm_policy
keeps only one workmem in the idle list, support for multi workmem buffers
will be introduced later.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp_lz4.c |  49 ++++++++++
 drivers/block/zram/zcomp_lz4.h |  18 ++++
 drivers/block/zram/zcomp_lzo.c |  49 ++++++++++
 drivers/block/zram/zcomp_lzo.h |  18 ++++
 drivers/block/zram/zram_comp.c | 204 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_comp.h |  64 +++++++++++++
 6 files changed, 402 insertions(+)
 create mode 100644 drivers/block/zram/zcomp_lz4.c
 create mode 100644 drivers/block/zram/zcomp_lz4.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c
 create mode 100644 drivers/block/zram/zcomp_lzo.h
 create mode 100644 drivers/block/zram/zram_comp.c
 create mode 100644 drivers/block/zram/zram_comp.h

diff --git a/drivers/block/zram/zcomp_lz4.c b/drivers/block/zram/zcomp_lz4.c
new file mode 100644
index 0000000..0987e70
--- /dev/null
+++ b/drivers/block/zram/zcomp_lz4.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/lz4.h>
+
+#include "zcomp_lz4.h"
+
+static struct zcomp_workmem *workmem_get(struct zram_comp *comp)
+{
+	struct zcomp_wm_policy *policy = comp->private;
+	return wm_policy_workmem_get(policy);
+}
+
+static void workmem_put(struct zram_comp *comp, struct zcomp_workmem *workmem)
+{
+	struct zcomp_wm_policy *policy = comp->private;
+	return wm_policy_workmem_put(policy, workmem);
+}
+
+int zcomp_lz4_create(struct zram_comp *comp)
+{
+	comp->compress = lz4_compress;
+	comp->decompress = lz4_decompress_unknownoutputsize;
+	comp->workmem_get = workmem_get;
+	comp->workmem_put = workmem_put;
+
+	/* lz4 backend uses default wm policy and calls default policy
+	 * workmem get() and put() functions */
+	comp->private = kzalloc(sizeof(struct zcomp_wm_policy), GFP_KERNEL);
+	if (!comp->private)
+		return -ENOMEM;
+	if (wm_policy_init(comp->private, LZ4_MEM_COMPRESS))
+		return -EINVAL;
+	return 0;
+}
+
+void zcomp_lz4_destroy(struct zram_comp *comp)
+{
+	wm_policy_free(comp->private);
+	kfree(comp->private);
+}
diff --git a/drivers/block/zram/zcomp_lz4.h b/drivers/block/zram/zcomp_lz4.h
new file mode 100644
index 0000000..7988492
--- /dev/null
+++ b/drivers/block/zram/zcomp_lz4.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_LZ4_H_
+#define _ZCOMP_LZ4_H_
+
+#include "zram_comp.h"
+
+int zcomp_lz4_create(struct zram_comp *comp);
+void zcomp_lz4_destroy(struct zram_comp *comp);
+
+#endif /* _ZCOMP_LZ4_H_ */
diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
new file mode 100644
index 0000000..b2f46d1
--- /dev/null
+++ b/drivers/block/zram/zcomp_lzo.c
@@ -0,0 +1,49 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/lzo.h>
+
+#include "zcomp_lzo.h"
+
+static struct zcomp_workmem *workmem_get(struct zram_comp *comp)
+{
+	struct zcomp_wm_policy *policy = comp->private;
+	return wm_policy_workmem_get(policy);
+}
+
+static void workmem_put(struct zram_comp *comp, struct zcomp_workmem *workmem)
+{
+	struct zcomp_wm_policy *policy = comp->private;
+	return wm_policy_workmem_put(policy, workmem);
+}
+
+int zcomp_lzo_create(struct zram_comp *comp)
+{
+	comp->compress = lzo1x_1_compress;
+	comp->decompress = lzo1x_decompress_safe;
+	comp->workmem_get = workmem_get;
+	comp->workmem_put = workmem_put;
+
+	/* lzo backend uses default wm policy and calls default policy
+	 * workmem get() and put() functions */
+	comp->private = kzalloc(sizeof(struct zcomp_wm_policy), GFP_KERNEL);
+	if (!comp->private)
+		return -ENOMEM;
+	if (wm_policy_init(comp->private, LZO1X_MEM_COMPRESS))
+		return -EINVAL;
+	return 0;
+}
+
+void zcomp_lzo_destroy(struct zram_comp *comp)
+{
+	wm_policy_free(comp->private);
+	kfree(comp->private);
+}
diff --git a/drivers/block/zram/zcomp_lzo.h b/drivers/block/zram/zcomp_lzo.h
new file mode 100644
index 0000000..18c174e
--- /dev/null
+++ b/drivers/block/zram/zcomp_lzo.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_LZO_H_
+#define _ZCOMP_LZO_H_
+
+#include "zram_comp.h"
+
+int zcomp_lzo_create(struct zram_comp *comp);
+void zcomp_lzo_destroy(struct zram_comp *comp);
+
+#endif /* _ZCOMP_LZO_H_ */
diff --git a/drivers/block/zram/zram_comp.c b/drivers/block/zram/zram_comp.c
new file mode 100644
index 0000000..f751394
--- /dev/null
+++ b/drivers/block/zram/zram_comp.c
@@ -0,0 +1,204 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+#include "zram_comp.h"
+
+#ifdef CONFIG_ZRAM_LZO_COMPRESS
+#include "zcomp_lzo.h"
+#endif
+
+#ifdef CONFIG_ZRAM_LZ4_COMPRESS
+#include "zcomp_lz4.h"
+#endif
+
+struct zcomp {
+	const char *name;
+	int (*create)(struct zram_comp *comp);
+	void (*destroy)(struct zram_comp *comp);
+};
+
+static struct zcomp compressors[] = {
+#ifdef CONFIG_ZRAM_LZO_COMPRESS
+	{
+		.name = "lzo",
+		.create = zcomp_lzo_create,
+		.destroy = zcomp_lzo_destroy
+	},
+#endif
+#ifdef CONFIG_ZRAM_LZ4_COMPRESS
+	{
+		.name = "lz4",
+		.create = zcomp_lz4_create,
+		.destroy = zcomp_lz4_destroy
+	},
+#endif
+	{}
+};
+
+static void workmem_free(struct zcomp_workmem *workmem)
+{
+	vfree(workmem->buf);
+	vfree(workmem->mem);
+	kfree(workmem);
+}
+
+/* allocate new workmem structure with ->mem of requested size,
+ * return NULL on error */
+static struct zcomp_workmem *workmem_alloc(size_t sz)
+{
+	struct zcomp_workmem *workmem = kmalloc(sizeof(*workmem), GFP_NOFS);
+	if (!workmem)
+		return NULL;
+
+	INIT_LIST_HEAD(&workmem->list);
+	/* algorithm specific working memory buffer */
+	workmem->mem = vmalloc(sz);
+	/* allocate 2 pages. 1 for compressed data, plus 1 extra for the
+	 * case when compressed size is larger than the original one. */
+	workmem->buf = vmalloc(2 * PAGE_SIZE);
+	if (!workmem->mem || !workmem->buf)
+		goto fail;
+
+	return workmem;
+fail:
+	workmem_free(workmem);
+	return NULL;
+}
+
+/* get existing idle workmem or wait until other process release
+ * (workmem_put()) one for us */
+struct zcomp_workmem *wm_policy_workmem_get(struct zcomp_wm_policy *policy)
+{
+	struct zcomp_workmem *wm;
+retry:
+	spin_lock(&policy->buffer_lock);
+	if (!list_empty(&policy->idle_workmem)) {
+		wm = list_entry(policy->idle_workmem.next,
+				struct zcomp_workmem, list);
+		list_del(&wm->list);
+		spin_unlock(&policy->buffer_lock);
+		return wm;
+	} else {
+		DEFINE_WAIT(wait);
+
+		spin_unlock(&policy->buffer_lock);
+		prepare_to_wait_exclusive(&policy->workmem_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (list_empty(&policy->idle_workmem))
+			schedule();
+		finish_wait(&policy->workmem_wait, &wait);
+		goto retry;
+	}
+	/* should never happen */
+	return NULL;
+}
+
+/* add workmem back to idle list and wake up waiter (if any) */
+void wm_policy_workmem_put(struct zcomp_wm_policy *policy,
+		struct zcomp_workmem *workmem)
+{
+	spin_lock(&policy->buffer_lock);
+	list_add_tail(&workmem->list, &policy->idle_workmem);
+	spin_unlock(&policy->buffer_lock);
+
+	if (waitqueue_active(&policy->workmem_wait))
+		wake_up(&policy->workmem_wait);
+}
+
+int wm_policy_init(struct zcomp_wm_policy *policy, size_t sz)
+{
+	struct zcomp_workmem *wm;
+
+	spin_lock_init(&policy->buffer_lock);
+	INIT_LIST_HEAD(&policy->idle_workmem);
+	init_waitqueue_head(&policy->workmem_wait);
+
+	/* allocate at least one workmem during initialisation,
+	 * so zram write() will not get into trouble in case of
+	 * low memory */
+	wm = workmem_alloc(sz);
+	if (!wm)
+		return -EINVAL;
+	list_add_tail(&wm->list, &policy->idle_workmem);
+	return 0;
+}
+
+void wm_policy_free(struct zcomp_wm_policy *policy)
+{
+	struct zcomp_workmem *wm;
+	while (!list_empty(&policy->idle_workmem)) {
+		wm = list_entry(policy->idle_workmem.next,
+				struct zcomp_workmem, list);
+		list_del(&wm->list);
+		workmem_free(wm);
+	}
+}
+
+/* free allocated workmem buffers and zram_comp */
+void zcomp_destroy(struct zram_comp *comp)
+{
+	comp->destroy(comp);
+	kfree(comp);
+}
+
+/* search available compressors for requested algorithm.
+ * allocate new zram_comp and initialize it. return NULL
+ * if requested algorithm is not supported or in case
+ * of init error */
+struct zram_comp *zcomp_create(const char *compress)
+{
+	struct zram_comp *comp;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(compressors) == 1);
+
+	for (i = 0; i < ARRAY_SIZE(compressors) - 1; i++) {
+		if (sysfs_streq(compress, compressors[i].name))
+			break;
+	}
+	/* nothing found */
+	if (i == ARRAY_SIZE(compressors) - 1)
+		return NULL;
+
+	comp = kzalloc(sizeof(struct zram_comp), GFP_KERNEL);
+	if (!comp)
+		return NULL;
+
+	comp->name = compressors[i].name;
+	comp->create = compressors[i].create;
+	comp->destroy = compressors[i].destroy;
+
+	if (comp->create(comp)) {
+		zcomp_destroy(comp);
+		return NULL;
+	}
+	return comp;
+}
+
+/* show available compressors */
+ssize_t zcomp_available_show(struct zram_comp *comp, char *buf)
+{
+	ssize_t sz = 0;
+	int i;
+	for (i = 0; i < ARRAY_SIZE(compressors) - 1; i++) {
+		if (comp && !strcmp(comp->name, compressors[i].name))
+			sz += sprintf(buf + sz, "<%s> ", compressors[i].name);
+		else
+			sz += sprintf(buf + sz, "%s ", compressors[i].name);
+	}
+	sz += sprintf(buf + sz, "\n");
+	return sz;
+}
diff --git a/drivers/block/zram/zram_comp.h b/drivers/block/zram/zram_comp.h
new file mode 100644
index 0000000..3446a63
--- /dev/null
+++ b/drivers/block/zram/zram_comp.h
@@ -0,0 +1,64 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZRAM_COMP_H_
+#define _ZRAM_COMP_H_
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+
+struct zcomp_workmem {
+	void *mem;      /* algorithm workmem */
+	void *buf;     /* compression/decompression buffer */
+	struct list_head list;
+};
+
+/* default device's compressing backend workmem control
+ * policy (usually device ->private)*/
+struct zcomp_wm_policy {
+	/* protect workmem list */
+	spinlock_t buffer_lock;
+	/* list of available workmems */
+	struct list_head idle_workmem;
+	wait_queue_head_t workmem_wait;
+};
+
+/* workmem get() and put() for default zcomp_wm_policy. compressing backend
+ * may define its own wm policy and call custom get() and put() */
+struct zcomp_workmem *wm_policy_workmem_get(struct zcomp_wm_policy *policy);
+void wm_policy_workmem_put(struct zcomp_wm_policy *policy,
+			struct zcomp_workmem *workmem);
+
+int wm_policy_init(struct zcomp_wm_policy *policy, size_t sz);
+void wm_policy_free(struct zcomp_wm_policy *policy);
+
+/* per-device compression frontend */
+struct zram_comp {
+	int (*compress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len, void *wrkmem);
+
+	int (*decompress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len);
+
+	struct zcomp_workmem *(*workmem_get)(struct zram_comp *comp);
+	void (*workmem_put)(struct zram_comp *comp,
+			struct zcomp_workmem *workmem);
+
+	int (*create)(struct zram_comp *);
+	void (*destroy)(struct zram_comp *);
+
+	void *private;
+	const char *name;
+};
+
+struct zram_comp *zcomp_create(const char *comp);
+void zcomp_destroy(struct zram_comp *comp);
+
+ssize_t zcomp_available_show(struct zram_comp *comp, char *buf);
+#endif /* _ZRAM_COMP_H_ */
-- 
1.9.rc1.183.g614c158

