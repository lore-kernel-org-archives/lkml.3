Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbbA2JAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:00:21 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754970AbbA2JAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:18 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 171/176] mm: get rid of radix tree gfp mask for pagecache_get_page
Date: Wed, 28 Jan 2015 15:30:01 +0100
Message-Id: <fd327feeb37ff323541b2ed2a663074a4ab3612a.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Hocko <mhocko@suse.cz>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 45f87de57f8fad59302fd263dd81ffa4843b5b24 upstream.

Commit 2457aec63745 ("mm: non-atomically mark page accessed during page
cache allocation where possible") has added a separate parameter for
specifying gfp mask for radix tree allocations.

Not only this is less than optimal from the API point of view because it
is error prone, it is also buggy currently because
grab_cache_page_write_begin is using GFP_KERNEL for radix tree and if
fgp_flags doesn't contain FGP_NOFS (mostly controlled by fs by
AOP_FLAG_NOFS flag) but the mapping_gfp_mask has __GFP_FS cleared then
the radix tree allocation wouldn't obey the restriction and might
recurse into filesystem and cause deadlocks.  This is the case for most
filesystems unfortunately because only ext4 and gfs2 are using
AOP_FLAG_NOFS.

Let's simply remove radix_gfp_mask parameter because the allocation
context is same for both page cache and for the radix tree.  Just make
sure that the radix tree gets only the sane subset of the mask (e.g.  do
not pass __GFP_WRITE).

Long term it is more preferable to convert remaining users of
AOP_FLAG_NOFS to use mapping_gfp_mask instead and simplify this
interface even further.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/pagemap.h | 13 ++++++-------
 mm/filemap.c            | 20 +++++++++-----------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d57a02a9747b..bf944e86895b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -256,7 +256,7 @@ pgoff_t page_cache_prev_hole(struct address_space *mapping,
 #define FGP_NOWAIT		0x00000020
 
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
-		int fgp_flags, gfp_t cache_gfp_mask, gfp_t radix_gfp_mask);
+		int fgp_flags, gfp_t cache_gfp_mask);
 
 /**
  * find_get_page - find and get a page reference
@@ -271,13 +271,13 @@ struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
 static inline struct page *find_get_page(struct address_space *mapping,
 					pgoff_t offset)
 {
-	return pagecache_get_page(mapping, offset, 0, 0, 0);
+	return pagecache_get_page(mapping, offset, 0, 0);
 }
 
 static inline struct page *find_get_page_flags(struct address_space *mapping,
 					pgoff_t offset, int fgp_flags)
 {
-	return pagecache_get_page(mapping, offset, fgp_flags, 0, 0);
+	return pagecache_get_page(mapping, offset, fgp_flags, 0);
 }
 
 /**
@@ -297,7 +297,7 @@ static inline struct page *find_get_page_flags(struct address_space *mapping,
 static inline struct page *find_lock_page(struct address_space *mapping,
 					pgoff_t offset)
 {
-	return pagecache_get_page(mapping, offset, FGP_LOCK, 0, 0);
+	return pagecache_get_page(mapping, offset, FGP_LOCK, 0);
 }
 
 /**
@@ -324,7 +324,7 @@ static inline struct page *find_or_create_page(struct address_space *mapping,
 {
 	return pagecache_get_page(mapping, offset,
 					FGP_LOCK|FGP_ACCESSED|FGP_CREAT,
-					gfp_mask, gfp_mask & GFP_RECLAIM_MASK);
+					gfp_mask);
 }
 
 /**
@@ -345,8 +345,7 @@ static inline struct page *grab_cache_page_nowait(struct address_space *mapping,
 {
 	return pagecache_get_page(mapping, index,
 			FGP_LOCK|FGP_CREAT|FGP_NOFS|FGP_NOWAIT,
-			mapping_gfp_mask(mapping),
-			GFP_NOFS);
+			mapping_gfp_mask(mapping));
 }
 
 struct page *find_get_entry(struct address_space *mapping, pgoff_t offset);
diff --git a/mm/filemap.c b/mm/filemap.c
index e94c70380deb..bd08e9bbf347 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -897,7 +897,7 @@ EXPORT_SYMBOL(find_lock_entry);
  * @mapping: the address_space to search
  * @offset: the page index
  * @fgp_flags: PCG flags
- * @gfp_mask: gfp mask to use if a page is to be allocated
+ * @gfp_mask: gfp mask to use for the page cache data page allocation
  *
  * Looks up the page cache slot at @mapping & @offset.
  *
@@ -916,7 +916,7 @@ EXPORT_SYMBOL(find_lock_entry);
  * If there is a page cache page, it is returned with an increased refcount.
  */
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t offset,
-	int fgp_flags, gfp_t cache_gfp_mask, gfp_t radix_gfp_mask)
+	int fgp_flags, gfp_t gfp_mask)
 {
 	struct page *page;
 
@@ -953,13 +953,11 @@ no_page:
 	if (!page && (fgp_flags & FGP_CREAT)) {
 		int err;
 		if ((fgp_flags & FGP_WRITE) && mapping_cap_account_dirty(mapping))
-			cache_gfp_mask |= __GFP_WRITE;
-		if (fgp_flags & FGP_NOFS) {
-			cache_gfp_mask &= ~__GFP_FS;
-			radix_gfp_mask &= ~__GFP_FS;
-		}
+			gfp_mask |= __GFP_WRITE;
+		if (fgp_flags & FGP_NOFS)
+			gfp_mask &= ~__GFP_FS;
 
-		page = __page_cache_alloc(cache_gfp_mask);
+		page = __page_cache_alloc(gfp_mask);
 		if (!page)
 			return NULL;
 
@@ -970,7 +968,8 @@ no_page:
 		if (fgp_flags & FGP_ACCESSED)
 			init_page_accessed(page);
 
-		err = add_to_page_cache_lru(page, mapping, offset, radix_gfp_mask);
+		err = add_to_page_cache_lru(page, mapping, offset,
+				gfp_mask & GFP_RECLAIM_MASK);
 		if (unlikely(err)) {
 			page_cache_release(page);
 			page = NULL;
@@ -2462,8 +2461,7 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 		fgp_flags |= FGP_NOFS;
 
 	page = pagecache_get_page(mapping, index, fgp_flags,
-			mapping_gfp_mask(mapping),
-			GFP_KERNEL);
+			mapping_gfp_mask(mapping));
 	if (page)
 		wait_for_stable_page(page);
 
-- 
2.2.2

