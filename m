Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3IZDnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 23:43:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34371 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102Ab3IZDnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 23:43:50 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-74-5243ad74fe76
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        d.j.shin@samsung.com, heesub.shin@samsung.com,
        kyungmin.park@samsung.com, hau.chen@samsung.com,
        bifeng.tong@samsung.com, rui.xie@samsung.com
References: <000201ceb836$4c549740$e4fdc5c0$%yang@samsung.com>
 <20130924010308.GG17725@bbox>
In-reply-to: <20130924010308.GG17725@bbox>
Subject: RE: [PATCH v3 2/3] mm/zswap: bugfix: memory leak when invalidate and
 reclaim occur concurrently
Date: Thu, 26 Sep 2013 11:42:17 +0800
Message-id: <000001ceba6a$997d0490$cc770db0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac64wcTI2YPuI5eaTz2NjnlD1eDU5QBordBQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t9jQd2Stc5BBl8+yFvMWb+GzeJN6202
	i65TU1ksTlystbh6eRmjxcHZS5gszja9Ybe4vGsOm8W9Nf9ZLZZ9fc9u8fDpdXaLQ/tWsVss
	2PiI0eLJif8sDnweO2fdZffYtKqTzWPTp0nsHidm/GbxeHBoM4vHx6e3WDz6tqxi9Pi8SS6A
	I4rLJiU1J7MstUjfLoErY+mWU4wFU5wrHl9YxtTAeMG0i5GTQ0LARGLazW9MELaYxIV769m6
	GLk4hASmM0r0NK9mh3D+MEp8ffuOEaSKTUBb4m7/RlYQW0RATWLdwRcsIEXMAieYJM5u2cEG
	khASiJN4OucxWBGngJZE1/5jYHFhgSyJpU2NQOs4OFgEVCXOHwkGCfMK2ElM27edDcIWlPgx
	+R4LiM0soCfx8c9tRghbXmLzmrfMIK0SAuoSj/7qQpxgJPHy5xlmiBJxiY1HbrFMYBSahWTS
	LCSTZiGZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwfH4TGoH48oGi0OMAhyM
	Sjy8F5idg4RYE8uKK3MPMUpwMCuJ8H4zAgrxpiRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgk
	kJ5YkpqdmlqQWgSTZeLglGpgjNY+Ordy52yb0imJd+K332lkbU4zn350qaoVz+oNayLtjFW8
	Hp4XKy7I2b1S0+PTdsGEe7+U++dHH+st3v9CzOOaYe2BxF07gpY9F7hnJhuwqHIOZ5T9pq/3
	j70SLNvZI8sb/t8p4+L+9X41pV7zDz36cSFr/s2V+Vs47cw5z1wWl12oqiy6VYmlOCPRUIu5
	qDgRAPtTEQHDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 9:03 AM, Minchan Kim <minchan@kernel.org> wrote: 
> On Mon, Sep 23, 2013 at 04:21:49PM +0800, Weijie Yang wrote:
> >
> > Modify:
> >  - check the refcount in fail path, free memory if it is not referenced.
> 
> Hmm, I don't like this because zswap refcount routine is already mess for me.
> I'm not sure why it was designed from the beginning. I hope we should fix it first.
> 
> 1. zswap_rb_serach could include zswap_entry_get semantic if it founds a entry from
>    the tree. Of course, we should ranme it as find_get_zswap_entry like find_get_page.
> 2. zswap_entry_put could hide resource free function like zswap_free_entry so that
>    all of caller can use it easily following pattern.
> 
>   find_get_zswap_entry
>   ...
>   ...
>   zswap_entry_put
> 
> Of course, zswap_entry_put have to check the entry is in the tree or not
> so if someone already removes it from the tree, it should avoid double remove.
> 
> One of the concern I can think is that approach extends critical section
> but I think it would be no problem because more bottleneck would be [de]compress
> functions. If it were really problem, we can mitigate a problem with moving
> unnecessary functions out of zswap_free_entry because it seem to be rather
> over-enginnering.

I refactor the zswap refcount routine according to Minchan's idea.
Here is the new patch, Any suggestion is welcomed.

To Seth and Bob, would you please review it again?

mm/zswap.c |  116
++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------------------------
 1 file changed, 52 insertions(+), 64 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
old mode 100644
new mode 100755
index deda2b6..bd04910
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -217,6 +217,7 @@ static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp)
 	if (!entry)
 		return NULL;
 	entry->refcount = 1;
+	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
 
@@ -232,10 +233,20 @@ static void zswap_entry_get(struct zswap_entry *entry)
 }
 
 /* caller must hold the tree lock */
-static int zswap_entry_put(struct zswap_entry *entry)
+static int zswap_entry_put(struct zswap_tree *tree, struct zswap_entry *entry)
 {
-	entry->refcount--;
-	return entry->refcount;
+	int refcount = --entry->refcount;
+
+	if (refcount <= 0) {
+		if (!RB_EMPTY_NODE(&entry->rbnode)) {
+			rb_erase(&entry->rbnode, &tree->rbroot);
+			RB_CLEAR_NODE(&entry->rbnode);
+		}
+
+		zswap_free_entry(tree, entry);
+	}
+
+	return refcount;
 }
 
 /*********************************
@@ -258,6 +269,17 @@ static struct zswap_entry *zswap_rb_search(struct rb_root *root, pgoff_t offset)
 	return NULL;
 }
 
+static struct zswap_entry *zswap_entry_find_get(struct rb_root *root, pgoff_t offset)
+{
+	struct zswap_entry *entry = NULL;
+
+	entry = zswap_rb_search(root, offset);
+	if (entry)
+		zswap_entry_get(entry);
+
+	return entry;
+}
+
 /*
  * In the case that a entry with the same offset is found, a pointer to
  * the existing entry is stored in dupentry and the function returns -EEXIST
@@ -387,7 +409,7 @@ static void zswap_free_entry(struct zswap_tree *tree, struct zswap_entry *entry)
 enum zswap_get_swap_ret {
 	ZSWAP_SWAPCACHE_NEW,
 	ZSWAP_SWAPCACHE_EXIST,
-	ZSWAP_SWAPCACHE_NOMEM
+	ZSWAP_SWAPCACHE_FAIL,
 };
 
 /*
@@ -401,9 +423,9 @@ enum zswap_get_swap_ret {
  * added to the swap cache, and returned in retpage.
  *
  * If success, the swap cache page is returned in retpage
- * Returns 0 if page was already in the swap cache, page is not locked
- * Returns 1 if the new page needs to be populated, page is locked
- * Returns <0 on error
+ * Returns ZSWAP_SWAPCACHE_EXIST if page was already in the swap cache
+ * Returns ZSWAP_SWAPCACHE_NEW if the new page needs to be populated, page is locked
+ * Returns ZSWAP_SWAPCACHE_FAIL on error
  */
 static int zswap_get_swap_cache_page(swp_entry_t entry,
 				struct page **retpage)
@@ -475,7 +497,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 	if (new_page)
 		page_cache_release(new_page);
 	if (!found_page)
-		return ZSWAP_SWAPCACHE_NOMEM;
+		return ZSWAP_SWAPCACHE_FAIL;
 	*retpage = found_page;
 	return ZSWAP_SWAPCACHE_EXIST;
 }
@@ -517,23 +539,22 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
 	/* find and ref zswap entry */
 	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
 		return 0;
 	}
-	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 	BUG_ON(offset != entry->offset);
 
 	/* try to allocate swap cache page */
 	switch (zswap_get_swap_cache_page(swpentry, &page)) {
-	case ZSWAP_SWAPCACHE_NOMEM: /* no memory */
+	case ZSWAP_SWAPCACHE_FAIL: /* no memory or invalidate happened */
 		ret = -ENOMEM;
 		goto fail;
 
-	case ZSWAP_SWAPCACHE_EXIST: /* page is unlocked */
+	case ZSWAP_SWAPCACHE_EXIST:
 		/* page is already in the swap cache, ignore for now */
 		page_cache_release(page);
 		ret = -EEXIST;
@@ -562,38 +583,28 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	zswap_written_back_pages++;
 
 	spin_lock(&tree->lock);
-
 	/* drop local reference */
-	zswap_entry_put(entry);
+	refcount = zswap_entry_put(tree, entry);
 	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
-
-	/*
-	 * There are three possible values for refcount here:
-	 * (1) refcount is 1, load is in progress, unlink from rbtree,
-	 *     load will free
-	 * (2) refcount is 0, (normal case) entry is valid,
-	 *     remove from rbtree and free entry
-	 * (3) refcount is -1, invalidate happened during writeback,
-	 *     free entry
-	 */
-	if (refcount >= 0) {
-		/* no invalidate yet, remove from rbtree */
+	if (refcount > 0) {
 		rb_erase(&entry->rbnode, &tree->rbroot);
+		RB_CLEAR_NODE(&entry->rbnode);
+		refcount = zswap_entry_put(tree, entry);
 	}
 	spin_unlock(&tree->lock);
-	if (refcount <= 0) {
-		/* free the entry */
-		zswap_free_entry(tree, entry);
-		return 0;
-	}
-	return -EAGAIN;
+
+	goto end;
 
 fail:
 	spin_lock(&tree->lock);
-	zswap_entry_put(entry);
+	refcount = zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
-	return ret;
+
+end:
+	if (refcount <= 0)
+		return 0;
+	else
+		return -EAGAIN;
 }
 
 /*********************************
@@ -677,10 +688,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 			zswap_duplicate_entry++;
 			/* remove from rbtree */
 			rb_erase(&dupentry->rbnode, &tree->rbroot);
-			if (!zswap_entry_put(dupentry)) {
-				/* free */
-				zswap_free_entry(tree, dupentry);
-			}
+			RB_CLEAR_NODE(&dupentry->rbnode);
+			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
 	spin_unlock(&tree->lock);
@@ -713,13 +722,12 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 
 	/* find */
 	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was written back */
 		spin_unlock(&tree->lock);
 		return -1;
 	}
-	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
 	/* decompress */
@@ -734,22 +742,9 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 	BUG_ON(ret);
 
 	spin_lock(&tree->lock);
-	refcount = zswap_entry_put(entry);
-	if (likely(refcount)) {
-		spin_unlock(&tree->lock);
-		return 0;
-	}
+	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	/*
-	 * We don't have to unlink from the rbtree because
-	 * zswap_writeback_entry() or zswap_frontswap_invalidate page()
-	 * has already done this for us if we are the last reference.
-	 */
-	/* free */
-
-	zswap_free_entry(tree, entry);
-
 	return 0;
 }
 
@@ -771,19 +766,12 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 
 	/* remove from rbtree */
 	rb_erase(&entry->rbnode, &tree->rbroot);
+	RB_CLEAR_NODE(&entry->rbnode);
 
 	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
+	zswap_entry_put(tree, entry);
 
 	spin_unlock(&tree->lock);
-
-	if (refcount) {
-		/* writeback in progress, writeback will free */
-		return;
-	}
-
-	/* free */
-	zswap_free_entry(tree, entry);
 }
 
 /* frees all zswap entries for the given swap type */

