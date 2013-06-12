Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab3FLSYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:24:34 -0400
Received: from kanga.kvack.org ([205.233.56.17]:49762 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755994Ab3FLSYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:24:33 -0400
Date: Wed, 12 Jun 2013 14:24:30 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Octavian Purdila <octavian.purdila@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, schwidefsky@de.ibm.com,
        kirill.shutemov@linux.intel.com, zab@redhat.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
Message-ID: <20130612182430.GE14404@kvack.org>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com> <20130612181440.GC6151@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612181440.GC6151@google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 11:14:40AM -0700, Kent Overstreet wrote:
> On Mon, Apr 15, 2013 at 02:40:55PM +0300, Octavian Purdila wrote:
> > When using a large number of threads performing AIO operations the
> > IOCTX list may get a significant number of entries which will cause
> > significant overhead. For example, when running this fio script:
> > 
> > rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
> > blocksize=1024; numjobs=512; thread; loops=100
> > 
> > on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
> > 30% CPU time spent by lookup_ioctx:
> > 
> >  32.51%  [guest.kernel]  [g] lookup_ioctx
> >   9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
> >   4.40%  [guest.kernel]  [g] lock_release
> >   4.19%  [guest.kernel]  [g] sched_clock_local
> >   3.86%  [guest.kernel]  [g] local_clock
> >   3.68%  [guest.kernel]  [g] native_sched_clock
> >   3.08%  [guest.kernel]  [g] sched_clock_cpu
> >   2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
> >   2.60%  [guest.kernel]  [g] memcpy
> >   2.33%  [guest.kernel]  [g] lock_acquired
> >   2.25%  [guest.kernel]  [g] lock_acquire
> >   1.84%  [guest.kernel]  [g] do_io_submit
> > 
> > This patchs converts the ioctx list to a radix tree. For a performance
> > comparison the above FIO script was run on a 2 sockets 8 core
> > machine. This are the results (average and %rsd of 10 runs) for the
> > original list based implementation and for the radix tree based
> > implementation:
> > 
> > cores         1         2         4         8         16        32
> > list       109376 ms  69119 ms  35682 ms  22671 ms  19724 ms  16408 ms
> > %rsd         0.69%      1.15%     1.17%     1.21%     1.71%     1.43%
> > radix       73651 ms  41748 ms  23028 ms  16766 ms  15232 ms   13787 ms
> > %rsd         1.19%      0.98%     0.69%     1.13%    0.72%      0.75%
> > % of radix
> > relative    66.12%     65.59%    66.63%    72.31%   77.26%     83.66%
> > to list
> > 
> > To consider the impact of the patch on the typical case of having
> > only one ctx per process the following FIO script was run:
> > 
> > rw=randrw; size=100m ;directory=/mnt/fio; ioengine=libaio; iodepth=1
> > blocksize=1024; numjobs=1; thread; loops=100
> > 
> > on the same system and the results are the following:
> > 
> > list        58892 ms
> > %rsd         0.91%
> > radix       59404 ms
> > %rsd         0.81%
> > % of radix
> > relative    100.87%
> > to list
> 
> So, I was just doing some benchmarking/profiling to get ready to send
> out the aio patches I've got for 3.11 - and it looks like your patch is
> causing a ~1.5% throughput regression in my testing :/
... <snip>

I've got an alternate approach for fixing this wart in lookup_ioctx()...  
Instead of using an rbtree, just use the reserved id in the ring buffer 
header to index an array pointing the ioctx.  It's not finished yet, and 
it needs to be tidied up, but is most of the way there.

		-ben
-- 
"Thought is the essence of where you are now."

 fs/aio.c                 |   80 ++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/mm_types.h |    5 ++
 kernel/fork.c            |    4 ++
 3 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 7fe5bde..96665db 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -108,6 +108,8 @@ struct kioctx {
 	} ____cacheline_aligned_in_smp;
 
 	struct page		*internal_pages[AIO_RING_PAGES];
+
+	unsigned		id;
 };
 
 /*------ sysctl variables----*/
@@ -207,7 +209,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
-	ring->id = ctx->user_id;
+	ring->id = ~0U;
 	ring->head = ring->tail = 0;
 	ring->magic = AIO_RING_MAGIC;
 	ring->compat_features = AIO_RING_COMPAT_FEATURES;
@@ -351,6 +353,7 @@ static void put_ioctx(struct kioctx *ctx)
 static struct kioctx *ioctx_alloc(unsigned nr_events)
 {
 	struct mm_struct *mm = current->mm;
+	struct aio_ring *ring;
 	struct kioctx *ctx;
 	int err = -ENOMEM;
 
@@ -394,15 +397,61 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 
 	/* now link into global list. */
 	spin_lock(&mm->ioctx_lock);
+	if (mm->ioctx_nr == 0) {
+		mm->ioctx_nr++;
+		mm->ioctx_table[0] = ctx;
+		ctx->id = 0;
+	} else {
+		unsigned i;
+		if (mm->ioctx_nr == mm->ioctx_max) {
+			unsigned new_nr;
+			struct kioctx **table;
+again:
+			new_nr = mm->ioctx_max * 4;
+			spin_unlock(&mm->ioctx_lock);
+			table = kcalloc(new_nr, sizeof(*table), GFP_KERNEL);
+			if (!table) {
+				err = -ENOMEM;
+				goto out_cleanup_noerr;
+			}
+			spin_lock(&mm->ioctx_lock);
+			if (mm->ioctx_max < new_nr) {
+				struct kioctx **old = mm->ioctx_table;
+				memcpy(table, mm->ioctx_table,
+				       mm->ioctx_max * sizeof(struct kioctx *));
+				smp_wmb();
+				mm->ioctx_table = table;
+				smp_wmb();
+				mm->ioctx_max = new_nr;
+				//FIXME: kfree_rcu(old, old);
+			} else
+				kfree(table);
+			if (mm->ioctx_nr == mm->ioctx_max)
+				goto again;
+		}
+		for (i=0; i<mm->ioctx_max; i++) {
+			if (!mm->ioctx_table[i]) {
+				ctx->id = i;
+				mm->ioctx_table[i] = ctx;
+				break;
+			}
+		}
+		WARN_ON(1);
+	}
 	hlist_add_head_rcu(&ctx->list, &mm->ioctx_list);
 	spin_unlock(&mm->ioctx_lock);
 
+	ring = kmap_atomic(ctx->ring_pages[0]);
+	ring->id = ctx->id;
+	kunmap_atomic(ring);
+
 	pr_debug("allocated ioctx %p[%ld]: mm=%p mask=0x%x\n",
 		 ctx, ctx->user_id, mm, ctx->nr_events);
 	return ctx;
 
 out_cleanup:
 	err = -EAGAIN;
+out_cleanup_noerr:
 	aio_free_ring(ctx);
 out_freectx:
 	kmem_cache_free(kioctx_cachep, ctx);
@@ -434,7 +483,14 @@ static void kill_ioctx_rcu(struct rcu_head *head)
 static void kill_ioctx(struct kioctx *ctx)
 {
 	if (!atomic_xchg(&ctx->dead, 1)) {
+		struct mm_struct *mm = current->mm;
+
+		spin_lock(&mm->ioctx_lock);
+		WARN_ON(ctx != mm->ioctx_table[ctx->id]);
+		mm->ioctx_table[ctx->id] = NULL;
 		hlist_del_rcu(&ctx->list);
+		spin_unlock(&mm->ioctx_lock);
+
 		/* Between hlist_del_rcu() and dropping the initial ref */
 		synchronize_rcu();
 
@@ -496,6 +552,8 @@ void exit_aio(struct mm_struct *mm)
 		ctx->mmap_size = 0;
 
 		if (!atomic_xchg(&ctx->dead, 1)) {
+			WARN_ON(ctx != mm->ioctx_table[ctx->id]);
+			mm->ioctx_table[ctx->id] = NULL;
 			hlist_del_rcu(&ctx->list);
 			call_rcu(&ctx->rcu_head, kill_ioctx_rcu);
 		}
@@ -557,19 +615,25 @@ EXPORT_SYMBOL(aio_put_req);
 
 static struct kioctx *lookup_ioctx(unsigned long ctx_id)
 {
+	struct aio_ring __user *ring  = (void __user *)ctx_id;
 	struct mm_struct *mm = current->mm;
 	struct kioctx *ctx, *ret = NULL;
+	unsigned id;
+
+	if (get_user(id, &ring->id))
+		return NULL;
 
 	rcu_read_lock();
 
-	hlist_for_each_entry_rcu(ctx, &mm->ioctx_list, list) {
-		if (ctx->user_id == ctx_id) {
-			atomic_inc(&ctx->users);
-			ret = ctx;
-			break;
-		}
-	}
+	if (id >= mm->ioctx_max)
+		goto out;
 
+	ctx = mm->ioctx_table[id];
+	if (ctx->user_id == ctx_id) {
+		atomic_inc(&ctx->users);
+		ret = ctx;
+	}
+out:
 	rcu_read_unlock();
 	return ret;
 }
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index ace9a5f..6958e55 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -322,6 +322,7 @@ struct mm_rss_stat {
 	atomic_long_t count[NR_MM_COUNTERS];
 };
 
+struct kioctx;
 struct mm_struct {
 	struct vm_area_struct * mmap;		/* list of VMAs */
 	struct rb_root mm_rb;
@@ -387,6 +388,10 @@ struct mm_struct {
 #ifdef CONFIG_AIO
 	spinlock_t		ioctx_lock;
 	struct hlist_head	ioctx_list;
+	unsigned		ioctx_nr;
+	unsigned		ioctx_max;
+	struct kioctx		**ioctx_table;
+	struct kioctx		*ioctx_table_inline[1];
 #endif
 #ifdef CONFIG_MM_OWNER
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 987b28a..5ef351c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -525,6 +525,10 @@ static void mm_init_aio(struct mm_struct *mm)
 #ifdef CONFIG_AIO
 	spin_lock_init(&mm->ioctx_lock);
 	INIT_HLIST_HEAD(&mm->ioctx_list);
+	mm->ioctx_nr = 0;
+	mm->ioctx_max = 1;
+	mm->ioctx_table = mm->ioctx_table_inline;
+	mm->ioctx_table_inline[0] = NULL;
 #endif
 }
 
