Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaCUSfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 14:35:12 -0400
Received: from kanga.kvack.org ([205.233.56.17]:45412 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaCUSfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 14:35:10 -0400
Date: Fri, 21 Mar 2014 14:35:09 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>
Cc: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        jmoyer@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>, miaox@cn.fujitsu.com,
        linux-aio@kvack.org, fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] aio: ensure access to ctx->ring_pages is correctly serialised
Message-ID: <20140321183509.GC23173@kvack.org>
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532B9C54.80705@cn.fujitsu.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Based on the issues reported by Tang and Gu, I've come up with the an 
alternative fix that avoids adding additional locking in the event read 
code path.  The fix is to take the ring_lock mutex during page migration, 
which is already used to syncronize event readers and thus does not add 
any new locking requirements in aio_read_events_ring().  I've dropped 
the patches from Tang and Gu as a result.  This patch is now in my 
git://git.kvack.org/~bcrl/aio-next.git tree and will be sent to Linus 
once a few other people chime in with their reviews of this change.  
Please review Tang, Gu.  Thanks!

		-ben
-- 
"Thought is the essence of where you are now."

>From e52ddd946ab1def55c8282c8b3d0e80403abae12 Mon Sep 17 00:00:00 2001
From: Benjamin LaHaise <bcrl@kvack.org>
Date: Fri, 21 Mar 2014 14:26:43 -0400
Subject: [PATCH] aio: ensure access to ctx->ring_pages is correctly serialised

As reported by Tang Chen and Gu Zheng, the following issues exist in the
aio ring page migration support.

Tang Chen reported:

As a result, for example, we have the following problem:

            thread 1                      |              thread 2
                                          |
aio_migratepage()                         |
 |-> take ctx->completion_lock            |
 |-> migrate_page_copy(new, old)          |
 |   *NOW*, ctx->ring_pages[idx] == old   |
                                          |
                                          |    *NOW*, ctx->ring_pages[idx] == old
                                          |    aio_read_events_ring()
                                          |     |-> ring = kmap_atomic(ctx->ring_pages[0])
                                          |     |-> ring->head = head;          *HERE, write to the old ring page*
                                          |     |-> kunmap_atomic(ring);
                                          |
 |-> ctx->ring_pages[idx] = new           |
 |   *BUT NOW*, the content of            |
 |    ring_pages[idx] is old.             |
 |-> release ctx->completion_lock         |

As above, the new ring page will not be updated.

Fix this issue, as well as prevent races in aio_ring_setup() by taking
the ring_lock mutex during page migration and where otherwise applicable.
This avoids the overhead of taking another spinlock in
aio_read_events_ring() as Tang's and Gu's original fix did, pushing the
overhead into the migration code.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 fs/aio.c | 40 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 4 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..c97cee8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -241,8 +241,10 @@ static void put_aio_ring_file(struct kioctx *ctx)
 
 static void aio_free_ring(struct kioctx *ctx)
 {
+	unsigned long flags;
 	int i;
 
+	spin_lock_irqsave(&ctx->completion_lock, flags);
 	for (i = 0; i < ctx->nr_pages; i++) {
 		struct page *page;
 		pr_debug("pid(%d) [%d] page->count=%d\n", current->pid, i,
@@ -253,6 +255,7 @@ static void aio_free_ring(struct kioctx *ctx)
 		ctx->ring_pages[i] = NULL;
 		put_page(page);
 	}
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	put_aio_ring_file(ctx);
 
@@ -287,9 +290,20 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 
 	rc = 0;
 
-	/* Make sure the old page hasn't already been changed */
+	/* Get a reference on the ioctx so we can take the ring_lock mutex. */
 	spin_lock(&mapping->private_lock);
 	ctx = mapping->private_data;
+	if (ctx)
+		percpu_ref_get(&ctx->users);
+	spin_unlock(&mapping->private_lock);
+
+	if (!ctx)
+		return -EINVAL;
+
+	mutex_lock(&ctx->ring_lock);
+
+	/* Make sure the old page hasn't already been changed */
+	spin_lock(&mapping->private_lock);
 	if (ctx) {
 		pgoff_t idx;
 		spin_lock_irqsave(&ctx->completion_lock, flags);
@@ -305,7 +319,7 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	spin_unlock(&mapping->private_lock);
 
 	if (rc != 0)
-		return rc;
+		goto out_unlock;
 
 	/* Writeback must be complete */
 	BUG_ON(PageWriteback(old));
@@ -314,7 +328,7 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	rc = migrate_page_move_mapping(mapping, new, old, NULL, mode, 1);
 	if (rc != MIGRATEPAGE_SUCCESS) {
 		put_page(new);
-		return rc;
+		goto out_unlock;
 	}
 
 	/* We can potentially race against kioctx teardown here.  Use the
@@ -346,6 +360,9 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	else
 		put_page(new);
 
+out_unlock:
+	mutex_unlock(&ctx->ring_lock);
+	percpu_ref_put(&ctx->users);
 	return rc;
 }
 #endif
@@ -556,9 +573,17 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 					rcu_read_unlock();
 					spin_unlock(&mm->ioctx_lock);
 
+					/*
+					 * Accessing ring pages must be done
+					 * holding ctx->completion_lock to
+					 * prevent aio ring page migration
+					 * procedure from migrating ring pages.
+					 */
+					spin_lock_irq(&ctx->completion_lock);
 					ring = kmap_atomic(ctx->ring_pages[0]);
 					ring->id = ctx->id;
 					kunmap_atomic(ring);
+					spin_unlock_irq(&ctx->completion_lock);
 					return 0;
 				}
 
@@ -657,7 +682,13 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	if (!ctx->cpu)
 		goto err;
 
-	if (aio_setup_ring(ctx) < 0)
+	/* Prevent races with page migration in aio_setup_ring() by holding
+	 * the ring_lock mutex.
+	 */
+	mutex_lock(&ctx->ring_lock);
+	err = aio_setup_ring(ctx);
+	mutex_unlock(&ctx->ring_lock);
+	if (err < 0)
 		goto err;
 
 	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
@@ -1024,6 +1055,7 @@ static long aio_read_events_ring(struct kioctx *ctx,
 
 	mutex_lock(&ctx->ring_lock);
 
+	/* Access to ->ring_pages here is protected by ctx->ring_lock. */
 	ring = kmap_atomic(ctx->ring_pages[0]);
 	head = ring->head;
 	tail = ring->tail;
-- 
1.8.2.1

