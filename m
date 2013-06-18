Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3FRKLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:11:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58067 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab3FRKLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:11:52 -0400
Date: Tue, 18 Jun 2013 11:11:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Yannick Brosseau <yannick.brosseau@gmail.com>,
        Rob van der Heij <rvdheij@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "lttng-dev@lists.lttng.org" <lttng-dev@lists.lttng.org>
Subject: Re: [-stable 3.8.1 performance regression] madvise
 POSIX_FADV_DONTNEED
Message-ID: <20130618101147.GA7436@suse.de>
References: <51BE1828.3060206@gmail.com>
 <20130617141357.GA6034@Krystal>
 <20130617142459.1d563072231ba269cdac8f11@linux-foundation.org>
 <20130618092925.GI1875@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20130618092925.GI1875@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:29:26AM +0100, Mel Gorman wrote:
> On Mon, Jun 17, 2013 at 02:24:59PM -0700, Andrew Morton wrote:
> > On Mon, 17 Jun 2013 10:13:57 -0400 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> > 
> > > Hi,
> > > 
> > > CCing lkml on this,
> > > 
> > > * Yannick Brosseau (yannick.brosseau@gmail.com) wrote:
> > > > Hi all,
> > > > 
> > > > We discovered a performance regression in recent kernels with LTTng
> > > > related to the use of fadvise DONTNEED.
> > > > A call to this syscall is present in the LTTng consumer.
> > > > 
> > > > The following kernel commit cause the call to fadvise to be sometime
> > > > really slower.
> > > > 
> > > > Kernel commit info:
> > > > mm/fadvise.c: drain all pagevecs if POSIX_FADV_DONTNEED fails to discard
> > > > all pages
> > > > main tree: (since 3.9-rc1)
> > > > commit 67d46b296a1ba1477c0df8ff3bc5e0167a0b0732
> > > > stable tree: (since 3.8.1)
> > > > https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit?id=bb01afe62feca1e7cdca60696f8b074416b0910d
> > > > 
> > > > On the workload test, we observe that the call to fadvise takes about
> > > > 4-5 us before this patch is applied. After applying the patch, The
> > > > syscall now takes values from 5 us up to 4 ms (4000 us) sometime. The
> > > > effect on lttng is that the consumer is frozen for this long period
> > > > which leads to dropped event in the trace.
> > 
> > That change wasn't terribly efficient - if there are any unpopulated
> > pages in the range (which is quite likely), fadvise() will now always
> > call invalidate_mapping_pages() a second time.
> > 
> 
> I did not view the path as being performance critical and did not anticipate
> a delay that severe.

Which I should have, schedule_on_each_cpu is documented to be slow.

> The original test case as well was based on
> sequential IO as part of a backup so I was also generally expecting the
> range to be populated. I looked at the other users of lru_add_drain_all()
> but there are fairly few. compaction uses them but only when used via sysfs
> or proc. ksm uses it but it's not likely to be that noticable. mlock uses
> it but it's unlikely it is being called frequently so I'm not going to
> worry performance of lru_add_drain_all() in general. I'll look closer at
> properly detecting when it's necessarily to call in the fadvise case.
> 

This compile-only tested prototype should detect remaining pages in the rage
that were not invalidated. This will at least detect unpopulated pages but
whether it has any impact depends on what lttng is invalidating. If it's
invalidating a range of per-cpu traces then I doubt this will work because
there will always be remaining pages. Similarly I wonder if passing down
the mapping will really help if a large number of cpus are tracing as we
end up scheduling work on every CPU regardless.

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2c28271..e2bb47e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2176,6 +2176,8 @@ extern int invalidate_partition(struct gendisk *, int);
 #endif
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
+unsigned long invalidate_mapping_pages_check(struct address_space *mapping,
+					pgoff_t start, pgoff_t end);
 
 static inline void invalidate_remote_inode(struct inode *inode)
 {
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 7e09268..0579e60 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -122,7 +122,9 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 		end_index = (endbyte >> PAGE_CACHE_SHIFT);
 
 		if (end_index >= start_index) {
-			unsigned long count = invalidate_mapping_pages(mapping,
+			unsigned long nr_remaining;
+
+			nr_remaining = invalidate_mapping_pages_check(mapping,
 						start_index, end_index);
 
 			/*
@@ -131,7 +133,7 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
 			 * a per-cpu pagevec for a remote CPU. Drain all
 			 * pagevecs and try again.
 			 */
-			if (count < (end_index - start_index + 1)) {
+			if (nr_remaining) {
 				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
diff --git a/mm/truncate.c b/mm/truncate.c
index c75b736..86cfc2e 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -312,26 +312,16 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 }
 EXPORT_SYMBOL(truncate_inode_pages);
 
-/**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
- * @start: the offset 'from' which to invalidate
- * @end: the offset 'to' which to invalidate (inclusive)
- *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
- *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
- */
-unsigned long invalidate_mapping_pages(struct address_space *mapping,
-		pgoff_t start, pgoff_t end)
+static void __invalidate_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t end,
+		unsigned long *ret_nr_invalidated,
+		unsigned long *ret_nr_remaining)
 {
 	struct pagevec pvec;
 	pgoff_t index = start;
 	unsigned long ret;
-	unsigned long count = 0;
+	unsigned long nr_invalidated = 0;
+	unsigned long nr_remaining = 0;
 	int i;
 
 	/*
@@ -354,8 +344,10 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 			if (index > end)
 				break;
 
-			if (!trylock_page(page))
+			if (!trylock_page(page)) {
+				nr_remaining++;
 				continue;
+			}
 			WARN_ON(page->index != index);
 			ret = invalidate_inode_page(page);
 			unlock_page(page);
@@ -365,17 +357,73 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
 			 */
 			if (!ret)
 				deactivate_page(page);
-			count += ret;
+			else
+				nr_remaining++;
+			nr_invalidated += ret;
 		}
 		pagevec_release(&pvec);
 		mem_cgroup_uncharge_end();
 		cond_resched();
 		index++;
 	}
-	return count;
+
+	*ret_nr_invalidated = nr_invalidated;
+	*ret_nr_remaining = nr_remaining;
 }
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
+/**
+ * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ *
+ * Returns the number of pages invalidated
+ */
+unsigned long invalidate_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t end)
+{
+	unsigned long nr_invalidated, nr_remaining;
+
+	__invalidate_mapping_pages(mapping, start, end,
+				   &nr_invalidated, &nr_remaining);
+
+	return nr_invalidated;
+}
+
+/**
+ * invalidate_mapping_pages_check - Invalidate all the unlocked pages of one inode and check for remaining pages.
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ *
+ * Returns the number of pages remaining in the invalidated range
+ */
+unsigned long invalidate_mapping_pages_check(struct address_space *mapping,
+		pgoff_t start, pgoff_t end)
+{
+	unsigned long nr_invalidated, nr_remaining;
+
+	__invalidate_mapping_pages(mapping, start, end,
+				   &nr_invalidated, &nr_remaining);
+
+	return nr_remaining;
+}
+
 /*
  * This is like invalidate_complete_page(), except it ignores the page's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
