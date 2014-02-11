Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaBKWYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:24:47 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34856 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBKWYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:24:45 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 1/4] zram: introduce compressing backend abstraction
Date: Wed, 12 Feb 2014 01:21:03 +0300
Message-Id: <1392157266-13488-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.244.g3497008
In-Reply-To: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZRAM performs direct LZO compression algorithm calls, making it the one
and only option. Introduce abstract struct zram_comp in order to support
multiple compression algorithms. struct zram_comp defines the following
set of compressing backend operations:
        .create
        .destroy
        .compress
        .decompress

Schematically zram write() usually contains the following steps:
0) preparation (decompression of partioal IO, etc.)
1) lock buffer_lock mutex (protects meta compress buffers)
2) compress (using meta compress buffers)
3) alloc and map zs_pool object
4) copy compressed data (from meta compress buffers) to object allocated by 3)
5) free previous pool page, assign a new one
6) unlock buffer_lock mutex

As we can see, compressing buffers must remain untouched from 1) to 4),
because, otherwise, concurrent write() can overwrite data. At the same
time, zram_meta must be aware of a) specific compression algorithm
memory requirements and b) necessary locking to protect compression
buffers. Besides, zram holds buffer_lock almost through the whole write()
function, making parallel compression impossible. To remove requirement
a) new struct zcomp_workmem introduced, which contain buffers required by
compression algorithm. While struct zram_comp implements workmem handling
and locking by means of get() and put() semantics and removes requirement
b) from zram meta. zram_comp ->create() and ->destroy(), respectively,
allocate and deallocate algorithm specific zcomp_workmem `private' buffer.

Every zram_comp has a list of idle workmem buffers (at least 1 workmem),
spinlock to protect idle list and wait queue, making it possible to perform
parallel compressions. Each time zram issues a zcomp_workmem_get() call, the
following set of operations performed:
- spin lock buffer_lock
- if idle list is not empty, remove workmem from idle list, spin
  unlock and return workmem pointer
- if idle list is empty, current adds itself to wait queue. it will be
  awaken by zcomp_workmem_put() caller.

zcomp_workmem_put():
- spin lock buffer_lock
- add workmem to idle list
- spin unlock, wake up sleeper (if any)

In other words, zcomp_workmem_get() turns caller into exclusive user of workmem
and zcomp_workem_put() makes a particular workmem available.

Usage examples.

To initialize compressing backend:
	comp = zcomp_create(NAME) /* NAME e.g. lzo */

which initialises compressing backend if requested algorithm is supported.

Compress:
	wm = zcomp_workmem_get(comp)
	zcomp_compress(comp, wm, src, src_len, &dst_len)
	[..] /* copy compressed data */
	zcomp_workmem_put(comp, wm)

Decompress:
	zcomp_decompress(comp, src, src_len, dst, &dst_len);

Free compessing backend and its workmem:
	zcomp_destroy(comp)

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp_lzo.c |  33 +++++++++
 drivers/block/zram/zram_comp.c | 147 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_comp.h |  58 ++++++++++++++++
 3 files changed, 238 insertions(+)
 create mode 100644 drivers/block/zram/zcomp_lzo.c
 create mode 100644 drivers/block/zram/zram_comp.c
 create mode 100644 drivers/block/zram/zram_comp.h

diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
new file mode 100644
index 0000000..bbde74e
--- /dev/null
+++ b/drivers/block/zram/zcomp_lzo.c
@@ -0,0 +1,33 @@
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
+#include "zram_comp.h"
+
+static void * lzo_create(void)
+{
+	return kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void lzo_destroy(void *workmem)
+{
+	kfree(workmem);
+}
+
+extern struct zram_comp_backend zcomp_lzo;
+struct zram_comp_backend zcomp_lzo = {
+	.compress = lzo1x_1_compress,
+	.decompress = lzo1x_decompress_safe,
+	.create = lzo_create,
+	.destroy = lzo_destroy,
+	.name = "lzo",
+};
diff --git a/drivers/block/zram/zram_comp.c b/drivers/block/zram/zram_comp.c
new file mode 100644
index 0000000..139a468
--- /dev/null
+++ b/drivers/block/zram/zram_comp.c
@@ -0,0 +1,147 @@
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
+extern struct zram_comp_backend zcomp_lzo;
+
+static void workmem_free(struct zram_comp *comp, struct zcomp_workmem *workmem)
+{
+	comp->backend->destroy(workmem->private);
+	free_pages((unsigned long)workmem->buffer, 1);
+	kfree(workmem);
+}
+
+/* allocate new workmem structure with ->mem of requested size,
+ * return NULL on error */
+static struct zcomp_workmem *workmem_alloc(struct zram_comp *comp)
+{
+	struct zcomp_workmem *workmem = kmalloc(sizeof(*workmem), GFP_NOFS);
+	if (!workmem)
+		return NULL;
+
+	INIT_LIST_HEAD(&workmem->list);
+	/* algorithm specific working memory buffer */
+	workmem->private = comp->backend->create();
+	/* allocate 2 pages. 1 for compressed data, plus 1 extra for the
+	 * case when compressed size is larger than the original one. */
+	workmem->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!workmem->private || !workmem->buffer)
+		goto fail;
+
+	return workmem;
+fail:
+	workmem_free(comp, workmem);
+	return NULL;
+}
+
+/* get existing idle workmem or wait until other process release
+ * (workmem_put()) one for us */
+struct zcomp_workmem *zcomp_workmem_get(struct zram_comp *comp)
+{
+	struct zcomp_workmem *wm;
+retry:
+	spin_lock(&comp->buffer_lock);
+	if (list_empty(&comp->idle_workmem)) {
+		spin_unlock(&comp->buffer_lock);
+		wait_event(comp->workmem_wait,
+				!list_empty(&comp->idle_workmem));
+		goto retry;
+	}
+
+	wm = list_entry(comp->idle_workmem.next,
+			struct zcomp_workmem, list);
+	list_del(&wm->list);
+	spin_unlock(&comp->buffer_lock);
+	return wm;
+}
+
+/* add workmem back to idle list and wake up waiter (if any) */
+void zcomp_workmem_put(struct zram_comp *comp,
+		struct zcomp_workmem *workmem)
+{
+	spin_lock(&comp->buffer_lock);
+	list_add_tail(&workmem->list, &comp->idle_workmem);
+	spin_unlock(&comp->buffer_lock);
+
+	if (waitqueue_active(&comp->workmem_wait))
+		wake_up(&comp->workmem_wait);
+}
+
+int zcomp_compress(struct zram_comp *comp, struct zcomp_workmem *workmem,
+		const unsigned char *src, size_t src_len, size_t *dst_len)
+{
+	return comp->backend->compress(src, src_len, workmem->buffer,
+			dst_len, workmem->private);
+}
+
+int zcomp_decompress(struct zram_comp *comp, const unsigned char *src,
+		size_t src_len, unsigned char *dst, size_t *dst_len)
+{
+	return comp->backend->decompress(src, src_len, dst, dst_len);
+}
+
+/* free allocated workmem buffers and zram_comp */
+void zcomp_destroy(struct zram_comp *comp)
+{
+	struct zcomp_workmem *wm;
+	while (!list_empty(&comp->idle_workmem)) {
+		wm = list_entry(comp->idle_workmem.next,
+				struct zcomp_workmem, list);
+		list_del(&wm->list);
+		workmem_free(comp, wm);
+	}
+	kfree(comp);
+}
+
+static struct zram_comp_backend *find_backend(const char *compress)
+{
+	if (sysfs_streq(compress, "lzo"))
+		return &zcomp_lzo;
+	return NULL;
+}
+
+/* search available compressors for requested algorithm.
+ * allocate new zram_comp and initialize it. return NULL
+ * if requested algorithm is not supported or in case
+ * of init error */
+struct zram_comp *zcomp_create(const char *compress)
+{
+	struct zram_comp *comp;
+	struct zram_comp_backend *backend;
+	struct zcomp_workmem *wm;
+
+	backend = find_backend(compress);
+	if (!backend)
+		return NULL;
+
+	comp = kzalloc(sizeof(struct zram_comp), GFP_KERNEL);
+	if (!comp)
+		return NULL;
+
+	comp->backend = backend;
+	spin_lock_init(&comp->buffer_lock);
+	INIT_LIST_HEAD(&comp->idle_workmem);
+	init_waitqueue_head(&comp->workmem_wait);
+
+	wm = workmem_alloc(comp);
+	if (!wm) {
+		zcomp_destroy(comp);
+		return NULL;
+	}
+	list_add_tail(&wm->list, &comp->idle_workmem);
+	return comp;
+}
diff --git a/drivers/block/zram/zram_comp.h b/drivers/block/zram/zram_comp.h
new file mode 100644
index 0000000..90355e8
--- /dev/null
+++ b/drivers/block/zram/zram_comp.h
@@ -0,0 +1,58 @@
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
+	void *buffer;     /* compression/decompression buffer */
+	void *private;      /* algorithm workmem */
+	struct list_head list;
+};
+
+/* static compression backend */
+struct zram_comp_backend {
+	int (*compress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len, void *wrkmem);
+
+	int (*decompress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len);
+
+	void *(*create)(void);
+	void (*destroy)(void *workmem);
+
+	const char *name;
+};
+
+/* dynamic per-device compression frontend */
+struct zram_comp {
+	/* protect workmem list */
+	spinlock_t buffer_lock;
+	/* list of available workmems */
+	struct list_head idle_workmem;
+	wait_queue_head_t workmem_wait;
+	struct zram_comp_backend *backend;
+};
+
+struct zram_comp *zcomp_create(const char *comp);
+void zcomp_destroy(struct zram_comp *comp);
+
+struct zcomp_workmem *zcomp_workmem_get(struct zram_comp *comp);
+void zcomp_workmem_put(struct zram_comp *comp,
+		struct zcomp_workmem *workmem);
+
+int zcomp_compress(struct zram_comp *comp, struct zcomp_workmem *workmem,
+		const unsigned char *src, size_t src_len, size_t *dst_len);
+
+int zcomp_decompress(struct zram_comp *comp, const unsigned char *src,
+		size_t src_len, unsigned char *dst, size_t *dst_len);
+#endif /* _ZRAM_COMP_H_ */
-- 
1.9.0.rc3.244.g3497008

