Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaJ2Sgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:36:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:24939 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756619AbaJ2Sgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,278,1413270000"; 
   d="scan'208";a="613606012"
Subject: [RFC PATCH 4/5] block,
 mm: Added the necessary plumbing to take ioprio hints down to block
 layer
From: "Jason B. Akers" <jason.b.akers@intel.com>
To: linux-ide@vger.kernel.org
Cc: axboe@fb.com, kapil.karkra@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 11:24:04 -0700
Message-ID: <20141029182404.4879.92000.stgit@stg-AndroidDev-VirtualBox>
In-Reply-To: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
User-Agent: StGit/0.17.1-4-g4a0c1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kapil Karkra <kapil.karkra@intel.com>

Added the necessary plumbing to take the ioprio hints down to the block
layer from where they further flow down into the libata. For reads or
direct IO, bio_associate_ioprio (invoked from blk_throtl_bio) copies
the ioprio from the current io context into the bio in the submit_bio
context. For lazy writes, 3 bits from the page_flags are used to record
ioprio in every page associated with a particular IO. Since page-flags
are scarce, we do this enabling only on 64 bit platforms. We take the
ioprio from the current io context and store it into each page in
grab_cache_page_write_begin function. the bio_associate_ioprio method
walks through all pages and determines the overall best priority to be
associated to the bio. The bio carries the io priority further down the
IO stack.

Signed-off-by: Kapil Karkra <kapil.karkra@intel.com>
Signed-off-by: Jason B. Akers <jason.b.akers@intel.com>
---
 block/bio.c                |   34 ++++++++++++++++++++++++++++++++++
 block/blk-throttle.c       |    5 +++++
 include/linux/bio.h        |    1 +
 include/linux/page-flags.h |   24 ++++++++++++++++++++++++
 mm/debug.c                 |    5 +++++
 mm/filemap.c               |   18 ++++++++++++++++++
 6 files changed, 87 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index b93ae04..cc5cc64 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1965,6 +1965,40 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 }
 EXPORT_SYMBOL(bioset_create);
 
+int bio_associate_ioprio(struct bio *bio)
+{
+	struct io_context *ioc;
+	struct bio_vec bv;
+	struct bvec_iter iter;
+	int max_ioprio = 0; /* init max_ioprio to 0 (invalid) */
+	int advice, ioprio;
+
+	ioc = current->io_context;
+	if (!ioc)
+		return -ENOENT;
+
+	/* scan the bio_vecs for this bio and get the highest
+	 * ioprio to use for current
+	 */
+	bio_for_each_segment(bv, bio, iter) {
+		advice = PageGetAdvice(bv.bv_page);
+		ioprio = IOPRIO_ADVISE(0, 0, advice);
+		if (ioprio_advice_valid(ioprio))
+			max_ioprio = ioprio_best(ioprio, max_ioprio);
+	}
+
+	/* set max priority found in all bio_vecs */
+	bio_set_prio(bio, max_ioprio);
+
+	/* acquire active ref on @ioc and associate
+	 * also handles the read case
+	 */
+	bio_associate_ioc(bio,ioc);
+	bio_set_prio(bio, ioprio_best(ioc->ioprio, max_ioprio));
+
+	return 0;
+}
+
 /**
  * bioset_create_nobvec  - Create a bio_set without bio_vec mempool
  * @pool_size:	Number of bio to cache in the mempool
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 9273d09..abc33a5 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1484,6 +1484,11 @@ bool blk_throtl_bio(struct request_queue *q, struct bio *bio)
 	struct blkcg *blkcg;
 	bool throttled = false;
 
+	/* associate the best ioprio to the bio */
+	spin_lock_irq(q->queue_lock);
+	bio_associate_ioprio(bio);
+	spin_unlock_irq(q->queue_lock);
+
 	/* see throtl_charge_bio() */
 	if (bio->bi_rw & REQ_THROTTLED)
 		goto out;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8419319..4747c78 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -470,6 +470,7 @@ extern struct bio_vec *bvec_alloc(gfp_t, int, unsigned long *, mempool_t *);
 extern void bvec_free(mempool_t *, struct bio_vec *, unsigned int);
 extern unsigned int bvec_nr_vecs(unsigned short idx);
 
+int bio_associate_ioprio(struct bio *bio);
 int bio_associate_current(struct bio *bio);
 void bio_disassociate_task(struct bio *bio);
 
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index e1f5fcd..8811234 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -109,6 +109,11 @@ enum pageflags {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	PG_compound_lock,
 #endif
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	PG_ioprio_advice_0,	/* 3 flag bits store ioprio advice */
+	PG_ioprio_advice_1,
+	PG_ioprio_advice_2,
+#endif
 	__NR_PAGEFLAGS,
 
 	/* Filesystems */
@@ -370,6 +375,25 @@ static inline void ClearPageCompound(struct page *page)
 
 #define PG_head_mask ((1L << PG_head))
 
+/*
+ * ioprio advise is recorded here
+ */
+static inline void PageSetAdvice(struct page *page, unsigned int advice)
+{
+	page->flags = (page->flags |
+	((((advice >> 0) & 1) << PG_ioprio_advice_0) |
+	(((advice >> 1) & 1) << PG_ioprio_advice_1) |
+	(((advice >> 2) & 1) << PG_ioprio_advice_2)));
+}
+
+static inline int PageGetAdvice(struct page *page)
+{
+	unsigned int advice = (((page->flags >> PG_ioprio_advice_0) & 1) |
+			  (((page->flags >> PG_ioprio_advice_1) & 1) << 1) |
+			  (((page->flags >> PG_ioprio_advice_2) & 1) << 2));
+	return advice;
+}
+
 #else
 /*
  * Reduce page flag use as much as possible by overlapping
diff --git a/mm/debug.c b/mm/debug.c
index 5ce45c9..c785b06 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -48,6 +48,11 @@ static const struct trace_print_flags pageflag_names[] = {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	{1UL << PG_compound_lock,	"compound_lock"	},
 #endif
+#ifdef CONFIG_PAGEFLAGS_EXTENDED
+	{1UL << PG_ioprio_advice_0,	"ioprio_adv0"	},
+	{1UL << PG_ioprio_advice_1,	"ioprio_adv1"	},
+	{1UL << PG_ioprio_advice_2,	"ioprio_adv2"	},
+#endif
 };
 
 static void dump_flags(unsigned long flags,
diff --git a/mm/filemap.c b/mm/filemap.c
index 14b4642..f82529d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2438,6 +2438,9 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 {
 	struct page *page;
 	int fgp_flags = FGP_LOCK|FGP_ACCESSED|FGP_WRITE|FGP_CREAT;
+	struct io_context *ioc;
+	int advice;
+	int ioprio;
 
 	if (flags & AOP_FLAG_NOFS)
 		fgp_flags |= FGP_NOFS;
@@ -2448,6 +2451,21 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 	if (page)
 		wait_for_stable_page(page);
 
+	/* store the ioprio into the page flags */
+	if (current && current->io_context) {
+		ioc = current->io_context;
+		advice = PageGetAdvice(page);
+		ioprio = IOPRIO_ADVISE(0, 0, advice);
+		if (ioprio_advice_valid(ioc->ioprio)) {
+			if (ioprio_advice_valid(ioprio))
+				ioprio = ioprio_best(ioprio, ioc->ioprio);
+			else
+				ioprio = ioc->ioprio;
+
+			PageSetAdvice(page, IOPRIO_ADVICE(ioprio));
+		}
+	}
+
 	return page;
 }
 EXPORT_SYMBOL(grab_cache_page_write_begin);

