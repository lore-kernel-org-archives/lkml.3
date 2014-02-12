Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbaBLToo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:44:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53611 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbaBLTnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:43:23 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv4 1/4] zram: introduce compressing backend abstraction
Date: Wed, 12 Feb 2014 22:39:33 +0300
Message-Id: <1392233976-26473-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.256.g4af3ebd
In-Reply-To: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392233976-26473-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ZRAM performs direct LZO compression algorithm calls, making it the one and
only option. Introduce compressing backend abstraction zcomp in order to
support multiple compression algorithms with the following set of operations:
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
a) new struct zcomp_strm introduced, which contain buffers required by
compression algorithm. While struct zcomp implements zcomp_strm stream
handling and locking by means of get() and put() semantics and removes
requirement b) from zram meta. zcomp ->create() and ->destroy(), respectively,
allocate and deallocate algorithm specific zcomp_strm `private' buffer.

Every zcomp has a list of idle zcomp_strm buffers, spinlock to protect idle
list and wait queue, making it possible to perform parallel compressions.
Each time zram issues a zcomp_strm_get() call, the following set of operations
performed:
- spin lock buffer_lock
- if idle list is not empty, remove zcomp_strm from idle list, spin
  unlock and return zcomp stream pointer to caller
- if idle list is empty, current adds itself to wait queue. it will be
  awaken by zcomp_strm_put() caller.

zcomp_strm_put():
- spin lock buffer_lock
- add zcomp stream to idle list
- spin unlock, wake up sleeper

In other words, zcomp_strm_get() turns caller into exclusive user of a stream
and zcomp_strm_put() makes a particular zcomp stream available.

Usage examples.

To initialize compressing backend:
	comp = zcomp_create(NAME) /* NAME e.g. "lzo" */

which initialises compressing backend if requested algorithm is supported.

Compress:
	zstrm = zcomp_strm_get(comp)
	zcomp_compress(comp, zstrm, src, src_len, &dst_len)
	[..] /* copy compressed data */
	zcomp_strm_put(comp, zstrm)

Decompress:
	zcomp_decompress(comp, src, src_len, dst, &dst_len);

Free compessing backend and its zcomp stream:
	zcomp_destroy(comp)

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c     | 153 +++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zcomp.h     |  57 +++++++++++++++
 drivers/block/zram/zcomp_lzo.c |  33 +++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 drivers/block/zram/zcomp.c
 create mode 100644 drivers/block/zram/zcomp.h
 create mode 100644 drivers/block/zram/zcomp_lzo.c

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
new file mode 100644
index 0000000..3b4920f
--- /dev/null
+++ b/drivers/block/zram/zcomp.c
@@ -0,0 +1,153 @@
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
+#include "zcomp.h"
+
+extern struct zcomp_backend zcomp_lzo;
+
+static void zcomp_strm_free(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	comp->backend->destroy(zstrm->private);
+	free_pages((unsigned long)zstrm->buffer, 1);
+	kfree(zstrm);
+}
+
+/*
+ * allocate new zcomp_strm structure with ->private initialized by
+ * backend, return NULL on error
+ */
+static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
+{
+	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_KERNEL);
+	if (!zstrm)
+		return NULL;
+
+	INIT_LIST_HEAD(&zstrm->list);
+	/* algorithm specific working memory buffer */
+	zstrm->private = comp->backend->create();
+	/*
+	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
+	 * case when compressed size is larger than the original one
+	 */
+	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!zstrm->private || !zstrm->buffer)
+		goto fail;
+
+	return zstrm;
+fail:
+	zcomp_strm_free(comp, zstrm);
+	return NULL;
+}
+
+/*
+ * get existing idle zcomp_strm or wait until other process release
+ * (zcomp_strm_put()) one for us
+ */
+struct zcomp_strm *zcomp_strm_get(struct zcomp *comp)
+{
+	struct zcomp_strm *zstrm;
+retry:
+	spin_lock(&comp->buffer_lock);
+	if (list_empty(&comp->idle_strm)) {
+		spin_unlock(&comp->buffer_lock);
+		wait_event(comp->strm_wait,
+				!list_empty(&comp->idle_strm));
+		goto retry;
+	}
+
+	zstrm = list_entry(comp->idle_strm.next,
+			struct zcomp_strm, list);
+	list_del(&zstrm->list);
+	spin_unlock(&comp->buffer_lock);
+	return zstrm;
+}
+
+/* add zcomp_strm back to idle list and wake up waiter (if any) */
+void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	spin_lock(&comp->buffer_lock);
+	list_add_tail(&zstrm->list, &comp->idle_strm);
+	spin_unlock(&comp->buffer_lock);
+
+	wake_up(&comp->strm_wait);
+}
+
+int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src, size_t src_len, size_t *dst_len)
+{
+	return comp->backend->compress(src, src_len, zstrm->buffer,
+			dst_len, zstrm->private);
+}
+
+int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+		size_t src_len, unsigned char *dst, size_t *dst_len)
+{
+	return comp->backend->decompress(src, src_len, dst, dst_len);
+}
+
+/* free allocated zcomp_strm buffers and zcomp */
+void zcomp_destroy(struct zcomp *comp)
+{
+	struct zcomp_strm *zstrm;
+	while (!list_empty(&comp->idle_strm)) {
+		zstrm = list_entry(comp->idle_strm.next,
+				struct zcomp_strm, list);
+		list_del(&zstrm->list);
+		zcomp_strm_free(comp, zstrm);
+	}
+	kfree(comp);
+}
+
+static struct zcomp_backend *find_backend(const char *compress)
+{
+	if (sysfs_streq(compress, "lzo"))
+		return &zcomp_lzo;
+	return NULL;
+}
+
+/*
+ * search available compressors for requested algorithm.
+ * allocate new zcomp and initialize it. return NULL
+ * if requested algorithm is not supported or in case
+ * of init error
+ */
+struct zcomp *zcomp_create(const char *compress)
+{
+	struct zcomp *comp;
+	struct zcomp_backend *backend;
+	struct zcomp_strm *zstrm;
+
+	backend = find_backend(compress);
+	if (!backend)
+		return NULL;
+
+	comp = kmalloc(sizeof(struct zcomp), GFP_KERNEL);
+	if (!comp)
+		return NULL;
+
+	comp->backend = backend;
+	spin_lock_init(&comp->buffer_lock);
+	INIT_LIST_HEAD(&comp->idle_strm);
+	init_waitqueue_head(&comp->strm_wait);
+
+	zstrm = zcomp_strm_alloc(comp);
+	if (!zstrm) {
+		zcomp_destroy(comp);
+		return NULL;
+	}
+	list_add_tail(&zstrm->list, &comp->idle_strm);
+	return comp;
+}
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
new file mode 100644
index 0000000..213e503
--- /dev/null
+++ b/drivers/block/zram/zcomp.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (C) 2014 Sergey Senozhatsky.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _ZCOMP_H_
+#define _ZCOMP_H_
+
+#include <linux/types.h>
+#include <linux/spinlock.h>
+
+struct zcomp_strm {
+	void *buffer;     /* compression/decompression buffer */
+	void *private;      /* algorithm workmem */
+	struct list_head list;
+};
+
+/* static compression backend */
+struct zcomp_backend {
+	int (*compress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len, void *wrkmem);
+
+	int (*decompress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len);
+
+	void * (*create)(void);
+	void (*destroy)(void *private);
+
+	const char *name;
+};
+
+/* dynamic per-device compression frontend */
+struct zcomp {
+	/* protect strm list */
+	spinlock_t buffer_lock;
+	/* list of available strms */
+	struct list_head idle_strm;
+	wait_queue_head_t strm_wait;
+	struct zcomp_backend *backend;
+};
+
+struct zcomp *zcomp_create(const char *comp);
+void zcomp_destroy(struct zcomp *comp);
+
+struct zcomp_strm *zcomp_strm_get(struct zcomp *comp);
+void zcomp_strm_put(struct zcomp *comp, struct zcomp_strm *zsrtm);
+
+int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src, size_t src_len, size_t *dst_len);
+
+int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+		size_t src_len, unsigned char *dst, size_t *dst_len);
+#endif /* _ZCOMP_H_ */
diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
new file mode 100644
index 0000000..2b23771
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
+#include "zcomp.h"
+
+static void * lzo_create(void)
+{
+	return kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+}
+
+static void lzo_destroy(void *private)
+{
+	kfree(private);
+}
+
+extern struct zcomp_backend zcomp_lzo;
+struct zcomp_backend zcomp_lzo = {
+	.compress = lzo1x_1_compress,
+	.decompress = lzo1x_decompress_safe,
+	.create = lzo_create,
+	.destroy = lzo_destroy,
+	.name = "lzo",
+};
-- 
1.9.0.rc3.256.g4af3ebd

