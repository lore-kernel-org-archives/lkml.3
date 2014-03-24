Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaCXLIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 07:08:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42508 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbaCXLIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 07:08:43 -0400
X-IronPort-AV: E=Sophos;i="4.97,719,1389715200"; 
   d="scan'208";a="9756494"
Message-ID: <53301016.40902@cn.fujitsu.com>
Date: Mon, 24 Mar 2014 18:59:34 +0800
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
Subject: [V2 PATCH 2/2] aio: fix the confliction of aio read events and aio
 migrate page
References: <532A80B1.5010002@cn.fujitsu.com> <20140320143207.GA3760@redhat.com> <20140320163004.GE28970@kvack.org> <532B9C54.80705@cn.fujitsu.com> <20140321183509.GC23173@kvack.org>
In-Reply-To: <20140321183509.GC23173@kvack.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/24 19:05:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/24 19:05:37,
	Serialize complete at 2014/03/24 19:05:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we do not have additional protection on the page at the read events
side, so it is possible that the read of the page takes place after the
page has been freed and allocated to another part of the kernel. This
would result in the read returning invalid information.
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
the ring_lock mutex and completion_lock during page migration and where
otherwise applicable.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
v2:
Merged Tang Chen's patch to use the spin_lock to protect the ring buffer update.
Use ring_lock rather than the additional spin_lock as Benjamin LaHaise suggested.
---
 fs/aio.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 6453c12..ee74704 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -298,6 +298,9 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 	/* Extra ref cnt for rind_pages[] array */
 	get_page(new);
 
+	/* Ensure no aio read events is going when migrating page */
+	mutex_lock(&ctx->ring_lock);
+
 	rc = migrate_page_move_mapping(mapping, new, old, NULL, mode, 1);
 	if (rc != MIGRATEPAGE_SUCCESS) {
 		put_page(new);
@@ -312,6 +315,8 @@ static int aio_migratepage(struct address_space *mapping, struct page *new,
 
 	put_page(old);
 
+	mutex_unlock(&ctx->ring_lock);
+
 	return rc;
 }
 #endif
@@ -523,9 +528,18 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 					rcu_read_unlock();
 					spin_unlock(&mm->ioctx_lock);
 
+					/*
+					* Accessing ring pages must be done
+					* holding ctx->completion_lock to
+					* prevent aio ring page migration
+					* procedure from migrating ring pages.
+					*/
+					spin_lock_irq(&ctx->completion_lock);
 					ring = kmap_atomic(ctx->ring_pages[0]);
 					ring->id = ctx->id;
 					kunmap_atomic(ring);
+					spin_unlock_irq(&ctx->completion_lock);
+
 					return 0;
 				}
 
@@ -624,7 +638,14 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	if (!ctx->cpu)
 		goto err;
 
-	if (aio_setup_ring(ctx) < 0)
+	/*
+	 * Prevent races with page migration in aio_setup_ring() by holding
+	 * the ring_lock mutex.
+	 */
+	mutex_lock(&ctx->ring_lock);
+	err = aio_setup_ring(ctx);
+	mutex_unlock(&ctx->ring_lock);
+	if (err < 0)
 		goto err;
 
 	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
-- 
1.7.7

