Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751232AbaBGCBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 21:01:55 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45080 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBGCBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 21:01:54 -0500
X-Original-SENDERIP: 10.177.220.194
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 7 Feb 2014 11:02:04 +0900
From: Minchan Kim <minchan@kernel.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] zram: introduce compressing backend abstraction
Message-ID: <20140207020204.GC18284@bbox>
References: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
 <1391110088-14830-2-git-send-email-sergey.senozhatsky@gmail.com>
 <20140206051628.GC3211@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140206051628.GC3211@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, Feb 06, 2014 at 02:16:28PM +0900, Minchan Kim wrote:
> Hello Sergey,
> 
> Sorry for late response.
> 
> On Thu, Jan 30, 2014 at 10:28:07PM +0300, Sergey Senozhatsky wrote:
> > ZRAM performs direct LZO compression algorithm calls, making it the one
> > and only option. Introduce struct zram_comp in order to support multiple
> > compression algorithms. struct zram_comp defines the following set of
> > compressing backend operations:
> > 	.create
> > 	.destroy
> > 	.compress
> > 	.decompress
> > 	.workmem_get
> > 	.workmem_put
> > 
> > Schematically zram write() usually contains the following steps:
> > 0) preparation (decompression of partioal IO, etc.)
> > 1) lock buffer_lock mutex (protects meta compress buffers)
> > 2) compress (using meta compress buffers)
> > 3) alloc and map zs_pool object
> > 4) copy compressed data (from meta compress buffers) to new object
> 
>                                                           object allocated by 3)
>      
> > 5) free previous pool page, assign a new one
> > 6) unlock buffer_lock mutex
> > 
> > As we can see, compressing buffers must remain untouched from 1) to 4),
> > because, otherwise, concurrent write() will overwrite data. At the same
> > time, zram_meta must be aware of a) specific compression algorithm
> > memory requirements and b) necessary locking to protect compression
> > buffers. Besides, zram holds buffer_lock almost through the whole write()
> > function, making parallel compression impossible. To remove requirement
> > a) new struct zcomp_workmem (workmem is a common term used by lzo, lz4
> > and zlib) contains buffers required by compression algorithm, while new
> > struct zcomp_wm_policy implements workmem handling and locking by means
> > of get() and put() semantics and removes requirement b) from zram meta.
> > In general, workmem_get() turns caller into exclusive user of workmem
> > and workem_put() makes a particular workmem available.
> > 
> > Each compressing backend may use a default workmem policy or provide
> > custom implementation. Default workmem policy (struct zcomp_wm_policy)
> > has a list of idle workmem buffers (at least 1 workmem), spinlock to
> > protect idle list and wait queue, making it possible to have parallel
> > compressions. Each time zram issues a workmem_get() call, the following
> > set of operations performed:
> 
> I'm still really not sure why backend should know workmem policy.
> I think it's matter of upper layer, not backend.
> Yeb, surely, you have a reason but it's very hard for me to know it
> by this patchset so I'd like to divide the patchset.
> (You don't need to explain it in here and I expect it would be clear
> if you separate it like I suggested below).
> Pz, see below.
> 
> > - spin lock buffer_lock
> > - if idle list is not empty, remove workmem from idle list, spin
> >   unlock and return workmem pointer
> > - if idle list is empty, current adds itself to wait queue. it will be
> >   awaken by workmem_put() caller.
> > 
> > workmem_put():
> > - spin lock buffer_lock
> > - add workmem to idle list
> > - spin unlock, wake up sleeper (if any)
> 
> Good.
> 
> > 
> > zram_comp file contains array of supported compressing backends, which
> > can be altered according to user selection.
> > 
> > Usage examples. To initialize compressing backend:
> > 	comp = zcomp_create(NAME) /* NAME e.g. lzo, lz4 */
> > 
> > which performs NAME lookup in array of supported compressing backends
> > and initialises compressing backend if requested algorithm is supported.
> > Compressing:
> > 	wm = comp->workmem_get(comp)
> > 	comp->compress(...)
> > 	[..] /* copy compressed data */
> > 	comp->workmem_put(comp, wm)
> > 
> > Free compessing backend and all ot its workmem buffers:
> > 	zcomp_destroy(comp)
> > 
> > The patch implements LZO and LZ4 backends. At this point zcomp_wm_policy
> > keeps only one workmem in the idle list, support for multi workmem buffers
> > will be introduced later.
> > 
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> >  drivers/block/zram/zcomp_lz4.c |  49 ++++++++++
> >  drivers/block/zram/zcomp_lz4.h |  18 ++++
> 
> Please don't include lz4 in this patch. It should be separated and
> description of the patch surely should include the number to prove
> lz4 is better than lzo in *what* workload so it should make
> everybody easy to convince.
> 
> And let's separate this patchset following as
> 
> 1. abstract compressor with zram_comp.
> 2. Support configurable compressor
> 3. support zcomp multi buffers
> 4. support lz4
> 
> Please don't add workmem policy in patch 1 because we still use only
> a buffer until 3 so patch 1, 2 would be very simple.
> Patch 3 might introduce wm policy. Then, it would be very clear
> why we need it for zomp_multi so that it would make review easy.
> 
> If 1,2,3 have no problem and apparenlty lz4 has a benefit, patch 4
> will be merged easily but If lz4 were rejected by some reason,
> we could support another compression easily since patch 1,2,3 is
> merged.

Hello Sergey,

If I don't show my brain to you, I guess we need more iterations
to discuss and it's really waste our time so I send prototype patch
to show the concept I am thinking.

Surely, It wouldn't work but it's enough to show my concept.

It's really simple.
Backend could just focus comp/decomp with own algorithm buffer.
(ie, backend don't need to know compress_buffer and workmem policy
because it's caller's matter, not compression backed).

I hope you complete this patch to work well with your SOB/Copyright
if you don't object the direction because most of concept and code
are from your idea and implementation.

Thanks.

>From 7f042055a30eb0ab22377634520a39568a7d16ac Mon Sep 17 00:00:00 2001
From: Minchan Kim <minchan@kernel.org>
Date: Tue, 4 Feb 2014 17:27:25 +0900
Subject: [PATCH] introduce zram_comp

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/Makefile    |  5 ++-
 drivers/block/zram/zcomp_lzo.c | 29 +++++++++++++++
 drivers/block/zram/zram_comp.c | 84 ++++++++++++++++++++++++++++++++++++++++++
 drivers/block/zram/zram_comp.h | 36 ++++++++++++++++++
 drivers/block/zram/zram_drv.c  | 45 ++++++++++------------
 drivers/block/zram/zram_drv.h  |  6 +--
 6 files changed, 175 insertions(+), 30 deletions(-)
 create mode 100644 drivers/block/zram/zcomp_lzo.c
 create mode 100644 drivers/block/zram/zram_comp.c
 create mode 100644 drivers/block/zram/zram_comp.h

diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index cb0f9ced6a93..7a4de6cce4e4 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -1,3 +1,4 @@
-zram-y	:=	zram_drv.o
+zram-y := zram_drv.o
+zram-y += zcomp_lzo.o zram_comp.o
 
-obj-$(CONFIG_ZRAM)	+=	zram.o
+obj-$(CONFIG_ZRAM) += zram.o
diff --git a/drivers/block/zram/zcomp_lzo.c b/drivers/block/zram/zcomp_lzo.c
new file mode 100644
index 000000000000..2a58d5392d4d
--- /dev/null
+++ b/drivers/block/zram/zcomp_lzo.c
@@ -0,0 +1,29 @@
+#include "zram_comp.h"
+
+#include <linux/lzo.h>
+
+void *lzo_init(void)
+{
+	void *private = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	return private;
+}
+
+void lzo_free(void *private)
+{
+	kfree(private);
+}
+
+int lzo_compress_page(unsigned char *in, size_t in_len,
+			unsigned char *out, size_t *out_len,
+			void *private)
+{
+	return lzo1x_1_compress(in, in_len, out, out_len, private);
+}
+
+const struct zram_comp zcomp_lzo = {
+	.init = lzo_init,
+	.destroy = lzo_free,
+	.compress_page = lzo_compress_page,
+	.decompress_page = lzo1x_decompress_safe,
+	.name = "lzo",
+};
diff --git a/drivers/block/zram/zram_comp.c b/drivers/block/zram/zram_comp.c
new file mode 100644
index 000000000000..c6af6cda7529
--- /dev/null
+++ b/drivers/block/zram/zram_comp.c
@@ -0,0 +1,84 @@
+#include "zram_comp.h"
+#include <linux/sched.h>
+
+extern struct zram_comp zcomp_lzo;
+
+struct zcomp_strm *zcomp_get_strm(struct zram_comp *comp)
+{
+	struct zcomp_strm *strm;
+again:
+	mutex_lock(&comp->lock);
+	if (list_empty(&comp->strm_list)) {
+		mutex_unlock(&comp->lock);
+		/* wait */
+		wait_event(comp->wait, !list_empty(&comp->strm_list));
+		goto again;
+	}
+
+	strm = list_entry(comp->strm_list.prev,
+			struct zcomp_strm, list);
+	list_del(&strm->list);
+	mutex_unlock(&comp->lock);
+	return strm;
+}
+
+void zcomp_put_strm(struct zram_comp *comp, struct zcomp_strm *strm)
+{
+	mutex_lock(&comp->lock);
+	list_add(&strm->list, &comp->strm_list);
+	mutex_unlock(&comp->lock);
+	wake_up(&comp->wait);
+}
+
+static struct zram_comp *find_comp(char *comp_name)
+{
+	if (!strcmp(comp_name, "lzo"))
+		return &zcomp_lzo;
+
+	return NULL;
+}
+
+int zcomp_compress_page(struct zram_comp *comp, struct zcomp_strm *strm,
+			unsigned char *in, size_t *clen)
+{
+	return comp->compress_page(in, PAGE_SIZE, strm->compress_buffer,
+				clen, strm->private);
+}
+
+struct zram_comp *zcomp_create(char *comp_name, int nr_strm)
+{
+	int i;
+	struct zram_comp *comp;
+	/* Look up supported backend */
+	comp = find_comp(comp_name);
+	if (!comp)
+		return NULL;
+
+	INIT_LIST_HEAD(&comp->strm_list);
+	mutex_init(&comp->lock);
+	init_waitqueue_head(&comp->wait);
+
+	for (i = 0; i < nr_strm; i++) {
+		struct zcomp_strm *strm = kmalloc(sizeof(*strm), GFP_KERNEL);
+		strm->compress_buffer =
+			(void*)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+		strm->private = comp->init();
+		list_add(&strm->list, &comp->strm_list);
+	}
+	
+	return comp;
+}
+
+void zcomp_destroy(struct zram_comp *comp)
+{
+	struct zcomp_strm *strm;
+
+	while (!list_empty(&comp->strm_list)) {
+		strm = list_entry(comp->strm_list.prev,
+			struct zcomp_strm, list);
+		free_pages((unsigned long)strm->compress_buffer, 1);
+		comp->destroy(strm->private);
+		list_del(&strm->list);
+		kfree(strm);
+	}
+}
diff --git a/drivers/block/zram/zram_comp.h b/drivers/block/zram/zram_comp.h
new file mode 100644
index 000000000000..705b8231f4d5
--- /dev/null
+++ b/drivers/block/zram/zram_comp.h
@@ -0,0 +1,36 @@
+#ifndef __ZRAM_COMP_H_
+#define __ZRAM_COMP_H_
+
+#include <linux/slab.h>
+#include "zram_drv.h"
+
+struct zcomp_strm {
+	void *private;
+	void *compress_buffer;
+	struct list_head list;
+};
+
+struct zram_comp {
+
+	struct list_head strm_list;
+	struct mutex lock;
+	wait_queue_head_t wait;
+
+	int (*compress_page)(unsigned char *in, size_t in_len,
+			unsigned char *out, size_t *out_len, void *private);
+	int (*decompress_page)(const unsigned char *in, size_t in_len,
+			  unsigned char *out, size_t *out_len);
+
+	void *(*init)(void);
+	void (*destroy)(void *private);
+	char name[10];
+};
+
+struct zcomp_strm *zcomp_get_strm(struct zram_comp *comp);
+void zcomp_put_strm(struct zram_comp *comp, struct zcomp_strm *strm);
+int zcomp_compress_page(struct zram_comp *comp, struct zcomp_strm *strm,
+			unsigned char *in, size_t *clen);
+struct zram_comp *zcomp_create(char *comp_name, int nr_strm);
+void zcomp_destroy(struct zram_comp *comp);
+
+#endif
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 25bbc59486ff..34a72903f808 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -33,6 +33,7 @@
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
+#include "zram_comp.h"
 #include "zram_drv.h"
 
 /* Globals */
@@ -160,35 +161,29 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 static void zram_meta_free(struct zram_meta *meta)
 {
 	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
-	free_pages((unsigned long)meta->compress_buffer, 1);
 	vfree(meta->table);
 	kfree(meta);
 }
 
-static struct zram_meta *zram_meta_alloc(u64 disksize)
+static struct zram_meta *zram_meta_alloc(u64 disksize, char *comp_name,
+					int nr_comp)
 {
 	size_t num_pages;
+	struct zram_comp *comp;
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
+
 	if (!meta)
 		goto out;
 
-	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!meta->compress_workmem)
+	comp = zcomp_create(comp_name, 1);
+	if (!comp)
 		goto free_meta;
 
-	meta->compress_buffer =
-		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!meta->compress_buffer) {
-		pr_err("Error allocating compressor buffer space\n");
-		goto free_workmem;
-	}
-
 	num_pages = disksize >> PAGE_SHIFT;
 	meta->table = vzalloc(num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
-		goto free_buffer;
+		goto free_comp;
 	}
 
 	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
@@ -198,15 +193,12 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 	}
 
 	rwlock_init(&meta->tb_lock);
-	mutex_init(&meta->buffer_lock);
 	return meta;
 
 free_table:
 	vfree(meta->table);
-free_buffer:
-	free_pages((unsigned long)meta->compress_buffer, 1);
-free_workmem:
-	kfree(meta->compress_workmem);
+free_comp:
+	zcomp_destroy(comp);
 free_meta:
 	kfree(meta);
 	meta = NULL;
@@ -284,6 +276,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
+	struct zram_comp *comp = zram->comp;
 	unsigned long handle;
 	u16 size;
 
@@ -301,7 +294,8 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
+		ret = comp->decompress_page(cmem, size, mem, &clen);
+
 	zs_unmap_object(meta->mem_pool, handle);
 	read_unlock(&meta->tb_lock);
 
@@ -373,10 +367,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	unsigned long handle;
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
+	struct zram_comp *comp = zram->comp;
 	struct zram_meta *meta = zram->meta;
+	struct zcomp_strm *strm;
 
 	page = bvec->bv_page;
-	src = meta->compress_buffer;
 
 	if (is_partial_io(bvec)) {
 		/*
@@ -393,7 +388,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto free_res;
 	}
 
-	mutex_lock(&meta->buffer_lock);
+	strm = zcomp_get_strm(comp);
+	src = strm->compress_buffer;
 	user_mem = kmap_atomic(page);
 
 	if (is_partial_io(bvec)) {
@@ -418,8 +414,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto free_res;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
+	ret = zcomp_compress_page(comp, strm, uncmem, &clen);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
 		user_mem = NULL;
@@ -471,7 +466,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_data_size);
 	atomic64_inc(&zram->stats.pages_stored);
-	mutex_unlock(&meta->buffer_lock);
+	zcomp_put_strm(comp, strm);
 
 free_res:
 	if (is_partial_io(bvec))
@@ -549,7 +544,7 @@ static ssize_t disksize_store(struct device *dev,
 	}
 
 	disksize = PAGE_ALIGN(disksize);
-	zram->meta = zram_meta_alloc(disksize);
+	zram->meta = zram_meta_alloc(disksize, "lzo", 1);
 	if (!zram->meta) {
 		up_write(&zram->init_lock);
 		return -ENOMEM;
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1d5b1f5786a8..57d5a63456e7 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -18,6 +18,8 @@
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
 #include <linux/zsmalloc.h>
+#include <linux/rwsem.h>
+#include <linux/wait.h>
 
 /*
  * Some arbitrary value. This is just to catch
@@ -81,15 +83,13 @@ struct zram_stats {
 
 struct zram_meta {
 	rwlock_t tb_lock;	/* protect table */
-	void *compress_workmem;
-	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
-	struct mutex buffer_lock; /* protect compress buffers */
 };
 
 struct zram {
 	struct zram_meta *meta;
+	struct zram_comp *comp;
 	struct request_queue *queue;
 	struct gendisk *disk;
 	/* Prevent concurrent execution of device init, reset and R/W request */
-- 
1.8.5.2

-- 
Kind regards,
Minchan Kim
