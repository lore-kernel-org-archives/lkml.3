Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865AbaCXLIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:08:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752087AbaCXLIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:08:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,719,1389715200"; 
   d="scan'208";a="9756493"
Message-ID: <53301012.7040306@cn.fujitsu.com>
Date: Mon, 24 Mar 2014 18:59:30 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        miaox@cn.fujitsu.com, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [V2 PATCH 1/2] aio: clean up aio_migratepage() and related code much
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com> <20140321183509.GC23173@kvack.org>
In-Reply-To: <20140321183509.GC23173@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/24 19:05:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/24 19:05:34,
	Serialize complete at 2014/03/24 19:05:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the page migration framework holds lock_page() to protect the pages
(both old and new) while migrating, so while the page migrating, both
of old page and new page are locked. And the aio context teardown
routine will call *truncate*(in put_aio_ring_file()) to truncate
pagecache which needs to acquire page_lock() for each page one by one.
So there is a native mutual exclusion between *migrate page* v.s. truncate().

If put_aio_ring_file() is called at first of the context teardown flow
(aio_free_ring). Then, page migration and ctx freeing will have mutual
execution guarded by lock_page() v.s. truncate(). Once a page is removed
from radix-tree, it will not be migrated. On the other hand, the context
can not be freed while the page migraiton are ongoing.

aio_free_ring
-put_aio_ring_file()		  |
 |-truncate_setsize()             |migrate_pages()
 | |-truncate_inode_pages_range() | |-__unmap_and_move()
 |  |-trylock_page(page)          |  |-lock_page(old)
 |-i_mapping->private_data = NULL |  ...
 |-ctx->aio_ring_file=NULL        |   |-move_to_new_page()
 |                                |    |-trylock_page(newpage)
			          |     |-aio_migratepage()
So that, the additional spinlock(address_space's private_lock) used to
protect use and updates of the mapping's private_data, and the sane check
of context is needless, so remove it here.

Besides, we also move filling ring_pages[] array and ctx->nr_pages into the
page_lock protection in aio_setup_ring to keep the semantic unanimous.

Moreover, after migrate_page_move_mapping() success, page migration should
never fail, so here we merge the flow in one routine.

Thanks KAMEZAWA Hiroyuki very much for giving directions on this.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
v2: Rebased on latest linus' tree.
---
 fs/aio.c |   79 ++++++++++++++++++--------------------------------------------
 1 files changed, 23 insertions(+), 56 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..6453c12 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -229,11 +229,8 @@ static void put_aio_ring_file(struct kioctx *ctx)
 	if (aio_ring_file) {
 		truncate_setsize(aio_ring_file->f_inode, 0);
 
-		/* Prevent further access to the kioctx from migratepages */
-		spin_lock(&aio_ring_file->f_inode->i_mapping->private_lock);
 		aio_ring_file->f_inode->i_mapping->private_data = NULL;
 		ctx->aio_ring_file = NULL;
-		spin_unlock(&aio_ring_file->f_inode->i_mapping->private_lock);
 
 		fput(aio_ring_file);
 	}
@@ -243,6 +240,8 @@ static void aio_free_ring(struct kioctx *ctx)
 {
 	int i;
 
+	put_aio_ring_file(ctx);
+
 	for (i = 0; i < ctx->nr_pages; i++) {
 		struct page *page;
 		pr_debug("pid(%d) [%d] page->count=%d\n", current->pid, i,
@@ -254,8 +253,6 @@ static void aio_free_ring(struct kioctx *ctx)
 		put_page(page);
 	}
 
-	put_aio_ring_file(ctx);
-
 	if (ctx->ring_pages && ctx->ring_pages != ctx->internal_pages) {
 		kfree(ctx->ring_pages);
 		ctx->ring_pages = NULL;
@@ -283,32 +280,22 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 {
 	struct kioctx *ctx;
 	unsigned long flags;
-	int rc;
-
-	rc = 0;
+	pgoff_t index;
+	int rc = MIGRATEPAGE_SUCCESS;
 
-	/* Make sure the old page hasn't already been changed */
-	spin_lock(&mapping->private_lock);
+	/*
+	 * Because old page is *locked*, if we see mapping, the page isn't
+	 * truncated, andmapping , mapping->private_data etc...are all valid.
+	 */
 	ctx = mapping->private_data;
-	if (ctx) {
-		pgoff_t idx;
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		idx = old->index;
-		if (idx < (pgoff_t)ctx->nr_pages) {
-			if (ctx->ring_pages[idx] != old)
-				rc = -EAGAIN;
-		} else
-			rc = -EINVAL;
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else
-		rc = -EINVAL;
-	spin_unlock(&mapping->private_lock);
 
-	if (rc != 0)
-		return rc;
+	index = old->index;
+	BUG_ON(index >= (pgoff_t)ctx->nr_pages);
+	VM_BUG_ON(ctx->ring_pages[index] != old);
 
 	/* Writeback must be complete */
 	BUG_ON(PageWriteback(old));
+	/* Extra ref cnt for rind_pages[] array */
 	get_page(new);
 
 	rc = migrate_page_move_mapping(mapping, new, old, NULL, mode, 1);
@@ -317,34 +304,13 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 		return rc;
 	}
 
-	/* We can potentially race against kioctx teardown here.  Use the
-	 * address_space's private data lock to protect the mapping's
-	 * private_data.
-	 */
-	spin_lock(&mapping->private_lock);
-	ctx = mapping->private_data;
-	if (ctx) {
-		pgoff_t idx;
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		migrate_page_copy(new, old);
-		idx = old->index;
-		if (idx < (pgoff_t)ctx->nr_pages) {
-			/* And only do the move if things haven't changed */
-			if (ctx->ring_pages[idx] == old)
-				ctx->ring_pages[idx] = new;
-			else
-				rc = -EAGAIN;
-		} else
-			rc = -EINVAL;
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else
-		rc = -EBUSY;
-	spin_unlock(&mapping->private_lock);
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	/* Migration should not fail if migrate_page_move_mapping SUCCESS */
+	migrate_page_copy(new, old);
+	ctx->ring_pages[old->index] = new;
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
-	if (rc == MIGRATEPAGE_SUCCESS)
-		put_page(old);
-	else
-		put_page(new);
+	put_page(old);
 
 	return rc;
 }
@@ -397,6 +363,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 		}
 	}
 
+	ctx->nr_pages = 0;
+
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 		page = find_or_create_page(file->f_inode->i_mapping,
@@ -407,13 +375,12 @@ static int aio_setup_ring(struct kioctx *ctx)
 			 current->pid, i, page_count(page));
 		SetPageUptodate(page);
 		SetPageDirty(page);
-		unlock_page(page);
-
 		ctx->ring_pages[i] = page;
+		ctx->nr_pages++;
+		unlock_page(page);
 	}
-	ctx->nr_pages = i;
 
-	if (unlikely(i != nr_pages)) {
+	if (unlikely(ctx->nr_pages != nr_pages)) {
 		aio_free_ring(ctx);
 		return -EAGAIN;
 	}
-- 
1.7.7


