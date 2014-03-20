Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbaCTFza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:55:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58349 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaCTFz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:55:26 -0400
X-IronPort-AV: E=Sophos;i="4.97,692,1389715200"; 
   d="scan'208";a="9732604"
Message-ID: <532A80AC.5000709@cn.fujitsu.com>
Date: Thu, 20 Mar 2014 13:46:20 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin <bcrl@kvack.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, jmoyer@redhat.com,
        kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] aio: clean up aio_migratepage() and related code much
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 13:52:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 13:52:26,
	Serialize complete at 2014/03/20 13:52:26
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
can not be freed while the page migration are ongoing.

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

ps.It is applied on linux-next(3-18).

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c |   92 ++++++++++++++++++++-----------------------------------------
 1 files changed, 30 insertions(+), 62 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 4133ba9..88ad40c 100644
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
@@ -317,42 +304,22 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
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
+	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-		/*
-		 * Ensure memory copy is finished before updating
-		 * ctx->ring_pages[]. Otherwise other processes may access to
-		 * new ring pages which are not fully initialized.
-		 */
-		smp_wmb();
+	/* Migration should not fail if migrate_page_move_mapping SUCCESS */
+	migrate_page_copy(new, old);
 
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
+	/*
+	 * Ensure memory copy is finished before updating
+	 * ctx->ring_pages[]. Otherwise other processes may access to
+	 * new ring pages which are not fully initialized.
+	 */
+	smp_wmb();
 
-	if (rc == MIGRATEPAGE_SUCCESS)
-		put_page(old);
-	else
-		put_page(new);
+	ctx->ring_pages[old->index] = new;
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
+	put_page(old);
 
 	return rc;
 }
@@ -405,6 +372,8 @@ static int aio_setup_ring(struct kioctx *ctx)
 		}
 	}
 
+	ctx->nr_pages = 0;
+
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
 		page = find_or_create_page(file->f_inode->i_mapping,
@@ -415,13 +384,12 @@ static int aio_setup_ring(struct kioctx *ctx)
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

