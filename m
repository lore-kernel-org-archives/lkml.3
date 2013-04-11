Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3DKTtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:49:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62473 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab3DKTtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:49:49 -0400
Date: Thu, 11 Apr 2013 15:49:20 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Tejun Heo <tj@kernel.org>
cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>,
        "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH v2] make dm and dm-crypt forward cgroup context (was:
 dm-crypt parallelization patches)
In-Reply-To: <20130410235009.GI17641@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304111544050.32536@file.rdu.redhat.com>
References: <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091450410.26327@file.rdu.redhat.com>
 <20130409195259.GL6186@mtj.dyndns.org> <Pine.LNX.4.64.1304091624110.19672@file.rdu.redhat.com>
 <20130409210735.GR6320@redhat.com> <Pine.LNX.4.64.1304091710150.24735@file.rdu.redhat.com>
 <20130410192427.GA14911@redhat.com> <Pine.LNX.4.64.1304101938280.24258@file.rdu.redhat.com>
 <20130410235009.GI17641@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Apr 2013, Tejun Heo wrote:

> On Wed, Apr 10, 2013 at 07:42:59PM -0400, Mikulas Patocka wrote:
> >  /*
> > + * bio_clone_context copies cgroup context from the original bio to the new bio.
> > + * It is used by bio midlayer drivers that create new bio based on an original
> > + * bio and forward it to the lower layer.
> > + *
> > + * No reference counts are incremented - it is assumed that the lifestime of the
> > + * new bio is shorter than the lifetime of the original bio. If the new bio can
> > + * outlive the old bio, the caller must increment the reference counts.
> > + *
> > + * Before freeing the new bio, the caller must clear the context with
> > + * bio_clear_context function. If bio_clear_context were not called, the
> > + * reference counts would be decremented on both new and original bio, resulting
> > + * in crash due to reference count underflow.
> > + */
> > +static inline void bio_clone_context(struct bio *orig, struct bio *new)
> > +{
> > +#ifdef CONFIG_BLK_CGROUP
> > +	new->bi_ioc = orig->bi_ioc;
> > +	new->bi_css = orig->bi_css;
> 
> Hmmm... Let's not do this.  Sure, you'd be saving several instructions
> but the gain is unlikely to be significant given that those cachelines
> are likely to be hot anyway.  Also, please name it
> bio_copy_association().
> 
> Thanks.
> 
> -- 
> tejun

If the bi_css pointer points to a structure that is shared between 
processes, using atomic instruction causes cache line boucing - it doesn't 
cost a few instructions, it costs 2-3 hundreds cycles.

I modified the patch to use new flag BIO_DROP_CGROUP_REFCOUNT to note that 
the refcount must be decremented - if the flag is set, refcounts must be 
decremented when bio is destroyed, if it is not set, references are 
borrowed from upper layer bio.

It is less bug-prone than the previous patch.

Mikulas

---

dm: retain cgroup context

This patch makes dm and dm-crypt target retain cgroup context.
 
New function bio_clone_context is introduced. It copies cgroup context
from one bio to another without incrementing the reference count. A new
bio flag BIO_DROP_CGROUP_REFCOUNT specifies that cgroup refcounts should
be decremented when the bio is freed.

bio_associate_current and bio_disassociate_task are exported to modules.

dm core is changed so that it copies the context to cloned bio. dm
associates the bio with current process if it is going to offload bio to a
thread.

dm-crypt associates the bio with the current process and copies the
context to outgoing bios.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-crypt.c     |    4 ++++
 drivers/md/dm.c           |    7 +++++--
 fs/bio.c                  |   11 +++++++++--
 include/linux/bio.h       |   27 +++++++++++++++++++++++++++
 include/linux/blk_types.h |    3 +++
 5 files changed, 48 insertions(+), 4 deletions(-)

Index: linux-3.8.6-fast/drivers/md/dm.c
===================================================================
--- linux-3.8.6-fast.orig/drivers/md/dm.c	2013-04-11 17:29:09.000000000 +0200
+++ linux-3.8.6-fast/drivers/md/dm.c	2013-04-11 19:33:47.000000000 +0200
@@ -1124,6 +1124,8 @@ static struct dm_target_io *alloc_tio(st
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, ci->md->bs);
 	tio = container_of(clone, struct dm_target_io, clone);
 
+	bio_clone_context(&tio->clone, ci->bio);
+
 	tio->io = ci->io;
 	tio->ti = ti;
 	memset(&tio->info, 0, sizeof(tio->info));
@@ -1469,9 +1471,10 @@ static void _dm_request(struct request_q
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
 		dm_put_live_table(md, srcu_idx);
 
-		if (bio_rw(bio) != READA)
+		if (bio_rw(bio) != READA) {
+			bio_associate_current(bio);
 			queue_io(md, bio);
-		else
+		} else
 			bio_io_error(bio);
 		return;
 	}
Index: linux-3.8.6-fast/include/linux/bio.h
===================================================================
--- linux-3.8.6-fast.orig/include/linux/bio.h	2013-04-11 17:29:07.000000000 +0200
+++ linux-3.8.6-fast/include/linux/bio.h	2013-04-11 19:34:11.000000000 +0200
@@ -291,6 +291,15 @@ extern void bvec_free_bs(struct bio_set
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
 #ifdef CONFIG_BLK_CGROUP
+/*
+ * bio_associate_current associates the bio with the current process. It should
+ * be called by any block device driver that passes the bio to a different
+ * process to be processed. It must be called in the original process.
+ * bio_associate_current does nothing if the bio is already associated.
+ *
+ * bio_dissociate_task dissociates the bio from the task. It is called
+ * automatically at bio destruction.
+ */
 int bio_associate_current(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 #else	/* CONFIG_BLK_CGROUP */
@@ -299,6 +308,24 @@ static inline void bio_disassociate_task
 #endif	/* CONFIG_BLK_CGROUP */
 
 /*
+ * bio_clone_context copies cgroup context from the original bio to the new bio.
+ * It is used by bio midlayer drivers that create new bio based on an original
+ * bio and forward it to the lower layer.
+ *
+ * No reference counts are incremented - it is assumed that the lifestime of the
+ * new bio is shorter than the lifetime of the original bio. If the new bio can
+ * outlive the old bio, the caller must increment the reference counts.
+ */
+static inline void bio_clone_context(struct bio *bio, struct bio *bio_src)
+{
+#ifdef CONFIG_BLK_CGROUP
+	BUG_ON(bio->bi_ioc != NULL);
+	bio->bi_ioc = bio_src->bi_ioc;
+	bio->bi_css = bio_src->bi_css;
+#endif
+}
+
+/*
  * bio_set is used to allow other portions of the IO system to
  * allocate their own private memory pools for bio and iovec structures.
  * These memory pools in turn all allocate from the bio_slab
Index: linux-3.8.6-fast/drivers/md/dm-crypt.c
===================================================================
--- linux-3.8.6-fast.orig/drivers/md/dm-crypt.c	2013-04-11 17:29:07.000000000 +0200
+++ linux-3.8.6-fast/drivers/md/dm-crypt.c	2013-04-11 19:33:48.000000000 +0200
@@ -966,6 +966,8 @@ static void clone_init(struct dm_crypt_i
 	clone->bi_end_io  = crypt_endio;
 	clone->bi_bdev    = cc->dev->bdev;
 	clone->bi_rw      = io->base_bio->bi_rw;
+
+	bio_clone_context(clone, io->base_bio);
 }
 
 static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
@@ -1692,6 +1694,8 @@ static int crypt_map(struct dm_target *t
 		return DM_MAPIO_REMAPPED;
 	}
 
+	bio_associate_current(bio);
+
 	io = crypt_io_alloc(cc, bio, dm_target_offset(ti, bio->bi_sector));
 
 	if (bio_data_dir(io->base_bio) == READ) {
Index: linux-3.8.6-fast/fs/bio.c
===================================================================
--- linux-3.8.6-fast.orig/fs/bio.c	2013-04-11 17:29:07.000000000 +0200
+++ linux-3.8.6-fast/fs/bio.c	2013-04-11 19:30:58.000000000 +0200
@@ -1690,6 +1690,8 @@ int bio_associate_current(struct bio *bi
 	if (!ioc)
 		return -ENOENT;
 
+	bio->bi_flags |= 1UL << BIO_DROP_CGROUP_REFCOUNT;
+
 	/* acquire active ref on @ioc and associate */
 	get_io_context_active(ioc);
 	bio->bi_ioc = ioc;
@@ -1703,6 +1705,7 @@ int bio_associate_current(struct bio *bi
 
 	return 0;
 }
+EXPORT_SYMBOL(bio_associate_current);
 
 /**
  * bio_disassociate_task - undo bio_associate_current()
@@ -1711,14 +1714,18 @@ int bio_associate_current(struct bio *bi
 void bio_disassociate_task(struct bio *bio)
 {
 	if (bio->bi_ioc) {
-		put_io_context(bio->bi_ioc);
+		if (bio_flagged(bio, BIO_DROP_CGROUP_REFCOUNT))
+			put_io_context(bio->bi_ioc);
 		bio->bi_ioc = NULL;
 	}
 	if (bio->bi_css) {
-		css_put(bio->bi_css);
+		if (bio_flagged(bio, BIO_DROP_CGROUP_REFCOUNT))
+			css_put(bio->bi_css);
 		bio->bi_css = NULL;
 	}
+	bio->bi_flags &= ~(1UL << BIO_DROP_CGROUP_REFCOUNT);
 }
+EXPORT_SYMBOL(bio_disassociate_task);
 
 #endif /* CONFIG_BLK_CGROUP */
 
Index: linux-3.8.6-fast/include/linux/blk_types.h
===================================================================
--- linux-3.8.6-fast.orig/include/linux/blk_types.h	2013-04-11 17:29:07.000000000 +0200
+++ linux-3.8.6-fast/include/linux/blk_types.h	2013-04-11 17:29:10.000000000 +0200
@@ -114,6 +114,9 @@ struct bio {
 #define BIO_FS_INTEGRITY 9	/* fs owns integrity data, not block layer */
 #define BIO_QUIET	10	/* Make BIO Quiet */
 #define BIO_MAPPED_INTEGRITY 11/* integrity metadata has been remapped */
+#ifdef CONFIG_BLK_CGROUP
+#define BIO_DROP_CGROUP_REFCOUNT 12 /* decrement cgroup context refcount */
+#endif
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
