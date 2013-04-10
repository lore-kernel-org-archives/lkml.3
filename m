Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936140Ab3DJXnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765171Ab3DJXnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:43:33 -0400
Date: Wed, 10 Apr 2013 19:42:59 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Vivek Goyal <vgoyal@redhat.com>
cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: [PATCH] make dm and dm-crypt forward cgroup context (was: dm-crypt
 parallelization patches)
In-Reply-To: <20130410192427.GA14911@redhat.com>
Message-ID: <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
References: <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Apr 2013, Vivek Goyal wrote:

> On Tue, Apr 09, 2013 at 05:18:25PM -0400, Mikulas Patocka wrote:
> 
> [..]
> > > bio_associate_current() return -EBUSY if bio has already been associated
> > > with an io context.
> > > 
> > > So in a stack if every driver calls bio_associate_current(), upon bio
> > > submission, it will automatically amke sure bio gets associated with
> > > submitter task in top level device and calls by lower level device
> > > will be ignored.
> > 
> > The stacking drivers do not pass the same bio to each other.
> > 
> > The stacking driver receives a bio, allocates zero or more new bios and 
> > sends these new bios to the lower layer. So you need to propagate 
> > ownership from the received bio to newly allocated bios, you don't want to 
> > associate newly allocated bio with "current" process.
> 
> Actually I was asking to call bio_associate_current() for the incoming
> bio in the driver and not for the newly created bios by the driver.

Yes, I think it's better to call it in the driver than in the upper layer, 
because if the driver doesn't forward the bio to a worker thread, we don't 
have to call bio_associate_current() and we save a few atomic 
instructions.

> For any newly created bios on behalf of this incoming bio, we need to
> copy the context so that this context info can be propogated down the
> stack.

See this patch. It implements cgroup associations for dm core and dm-crypt 
target.

Do you think the interface is correct? (i.e. can I start modifying more dm 
dm-targets to use it?)

> > We only need to increment reference if we copy ownership to a new bio that 
> > has could have longer lifetime than the original bio. But this situation 
> > is very rare - in most stacking drivers the newly allocated bio has 
> > shorter lifetime than the original one.
> 
> I think it is not a good idea to rely on the fact that cloned bios or
> newly created bios will have shorter lifetime than the original bio. In fact
> when the bio completes and you free it up bio_disassociate_task() will try
> to put io context and blkcg reference. So it is important to take
> reference if you are copying context info in any newly created bio.

We clear the associate with bio_clear_context before freeing the bio.

> Thanks
> Vivek


---

dm: retain cgroup context

This patch makes dm and dm-crypt target retain cgroup context.

New functions bio_clone_context and bio_clear_context are introduced.
bio_associate_current and bio_disassociate_task are exported to modules.

dm core is changed so that it copies the context to cloned bio. dm
associates the bio with current process if it is going to offload bio to a
thread.

dm-crypt copies the context to outgoing bios and associates the bio with
current process.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c |   17 ++++++++++++++---
 drivers/md/dm.c       |    5 +++++
 fs/bio.c              |    2 ++
 include/linux/bio.h   |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 3 deletions(-)

Index: linux-3.8.6-fast/drivers/md/dm.c
===================================================================
--- linux-3.8.6-fast.orig/drivers/md/dm.c	2013-04-10 14:39:28.000000000 +0200
+++ linux-3.8.6-fast/drivers/md/dm.c	2013-04-10 20:09:52.000000000 +0200
@@ -453,6 +453,7 @@ static void free_io(struct mapped_device
 
 static void free_tio(struct mapped_device *md, struct dm_target_io *tio)
 {
+	bio_clear_context(&tio->clone);
 	bio_put(&tio->clone);
 }
 
@@ -521,6 +522,8 @@ static void queue_io(struct mapped_devic
 {
 	unsigned long flags;
 
+	bio_associate_current(bio);
+
 	spin_lock_irqsave(&md->deferred_lock, flags);
 	bio_list_add(&md->deferred, bio);
 	spin_unlock_irqrestore(&md->deferred_lock, flags);
@@ -1124,6 +1127,8 @@ static struct dm_target_io *alloc_tio(st
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, ci->md->bs);
 	tio = container_of(clone, struct dm_target_io, clone);
 
+	bio_clone_context(ci->bio, &tio->clone);
+
 	tio->io = ci->io;
 	tio->ti = ti;
 	memset(&tio->info, 0, sizeof(tio->info));
Index: linux-3.8.6-fast/include/linux/bio.h
===================================================================
--- linux-3.8.6-fast.orig/include/linux/bio.h	2013-04-10 14:38:56.000000000 +0200
+++ linux-3.8.6-fast/include/linux/bio.h	2013-04-10 20:14:08.000000000 +0200
@@ -291,6 +291,15 @@ extern void bvec_free_bs(struct bio_set
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
 #ifdef CONFIG_BLK_CGROUP
+/*
+ * bio_associate_current associates the bio with the current process. It must be
+ * called by any block device driver that passes the bio to a different process
+ * to be processed. It must be called in the original process.
+ * bio_associate_current does nothing if the bio is already associated.
+ *
+ * bio_dissociate_task dissociates the bio from the task. It is called
+ * automatically at bio destruction.
+ */
 int bio_associate_current(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
@@ -299,6 +308,36 @@ static inline void bio_disassociate_task
 #endif	/* CONFIG_BLK_CGROUP */
 
 /*
+ * bio_clone_context copies cgroup context from the original bio to the new bio.
+ * It is used by bio midlayer drivers that create new bio based on an original
+ * bio and forward it to the lower layer.
+ *
+ * No reference counts are incremented - it is assumed that the lifestime of the
+ * new bio is shorter than the lifetime of the original bio. If the new bio can
+ * outlive the old bio, the caller must increment the reference counts.
+ *
+ * Before freeing the new bio, the caller must clear the context with
+ * bio_clear_context function. If bio_clear_context were not called, the
+ * reference counts would be decremented on both new and original bio, resulting
+ * in crash due to reference count underflow.
+ */
+static inline void bio_clone_context(struct bio *orig, struct bio *new)
+{
+#ifdef CONFIG_BLK_CGROUP
+	new->bi_ioc = orig->bi_ioc;
+	new->bi_css = orig->bi_css;
+#endif
+}
+
+static inline void bio_clear_context(struct bio *bio)
+{
+#ifdef CONFIG_BLK_CGROUP
+	bio->bi_ioc = NULL;
+	bio->bi_css = NULL;
+#endif
+}
+
+/*
  * bio_set is used to allow other portions of the IO system to
  * allocate their own private memory pools for bio and iovec structures.
  * These memory pools in turn all allocate from the bio_slab
Index: linux-3.8.6-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.8.6-fast.orig/drivers/md/dm-crypt.c	2013-04-10 14:38:56.000000000 +0200
+++ linux-3.8.6-fast/drivers/md/dm-crypt.c	2013-04-10 19:52:56.000000000 +0200
@@ -181,6 +181,7 @@ struct crypt_config {
 static struct kmem_cache *_crypt_io_pool;
 
 static void clone_init(struct dm_crypt_io *, struct bio *);
+static void clone_free(struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
 
@@ -846,7 +847,7 @@ static struct bio *crypt_alloc_buffer(st
 	}
 
 	if (!clone->bi_size) {
-		bio_put(clone);
+		clone_free(clone);
 		return NULL;
 	}
 
@@ -945,7 +946,7 @@ static void crypt_endio(struct bio *clon
 	if (rw == WRITE)
 		crypt_free_buffer_pages(cc, clone);
 
-	bio_put(clone);
+	clone_free(clone);
 
 	if (rw == READ && !error) {
 		kcryptd_queue_crypt(io);
@@ -966,6 +967,14 @@ static void clone_init(struct dm_crypt_i
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+
+	bio_clone_context(io->base_bio, clone);
+}
+
+static void clone_free(struct bio *clone)
+{
+	bio_clear_context(clone);
+	bio_put(clone);
 }
 
 static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
@@ -1026,7 +1035,7 @@ static void kcryptd_crypt_write_io_submi
 
 	if (unlikely(io->error < 0)) {
 		crypt_free_buffer_pages(cc, clone);
-		bio_put(clone);
+		clone_free(clone);
 		crypt_dec_pending(io);
 		return;
 	}
@@ -1692,6 +1701,8 @@ static int crypt_map(struct dm_target *t
 		return DM_MAPIO_REMAPPED;
 	}
 
+	bio_associate_current(bio);
+
 	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ) {
Index: linux-3.8.6-fast/fs/bio.c
===================================================================
--- linux-3.8.6-fast.orig/fs/bio.c	2013-04-10 19:49:13.000000000 +0200
+++ linux-3.8.6-fast/fs/bio.c	2013-04-10 19:50:10.000000000 +0200
@@ -1703,6 +1703,7 @@ int bio_associate_current(struct bio *bi
 
 	return 0;
 }
+EXPORT_SYMBOL(bio_associate_current);
 
 /**
  * bio_disassociate_task - undo bio_associate_current()
@@ -1719,6 +1720,7 @@ void bio_disassociate_task(struct bio *b
 		bio->bi_css = NULL;
 	}
 }
+EXPORT_SYMBOL(bio_disassociate_task);
 
 #endif /* CONFIG_BLK_CGROUP */
 
