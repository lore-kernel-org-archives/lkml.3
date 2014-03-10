Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaCJF20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:28:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36235 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753169AbaCJF2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:28:15 -0400
X-IronPort-AV: E=Sophos;i="4.97,622,1389715200"; 
   d="scan'208";a="9669951"
Message-ID: <531D4E0F.8060907@cn.fujitsu.com>
Date: Mon, 10 Mar 2014 13:30:55 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: viro@zeniv.linux.org.uk, bcrl@kvack.org, jmoyer@redhat.com,
        kosaki.motohiro@gmail.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, guz.fnst@cn.fujitsu.com
CC: linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>
Subject: [V2 PATCH 1/2] aio, memory-hotplug: Fix confliction when migrating
 and, accessing ring pages
References: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1393403919-1178-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:25:24,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/10 13:25:29,
	Serialize complete at 2014/03/10 13:25:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AIO ring page migration has been implemented by the following patch:


https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/fs/aio.c?id=36bc08cc01709b4a9bb563b35aa530241ddc63e3

In this patch, ctx->completion_lock is used to prevent other processes
from accessing the ring page being migrated.

But in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring(),
when writing to the ring page, they didn't take ctx->completion_lock.

As a result, for example, we have the following problem:

             thread 1                      |              thread 2
                                           |
aio_migratepage()                         |
  |-> take ctx->completion_lock            |
  |-> migrate_page_copy(new, old)          |
  |   *NOW*, ctx->ring_pages[idx] == old   |
                                           |
                                           |    *NOW*, 
ctx->ring_pages[idx] == old
                                           |    aio_read_events_ring()
                                           |     |-> ring = 
kmap_atomic(ctx->ring_pages[0])
                                           |     |-> ring->head = head; 
          *HERE, write to the old ring page*
                                           |     |-> kunmap_atomic(ring);
                                           |
  |-> ctx->ring_pages[idx] = new           |
  |   *BUT NOW*, the content of            |
  |    ring_pages[idx] is old.             |
  |-> release ctx->completion_lock         |

As above, the new ring page will not be updated.

The solution is taking ctx->completion_lock in thread 2, which means,
in aio_setup_ring(), ioctx_add_table() and aio_read_events_ring() when
writing to ring pages.

v2:
   Use spin_lock_irq rather than spin_lock_irqsave as Jeff suggested.

Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
  fs/aio.c |   28 ++++++++++++++++++++++++++++
  1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 062a5f6..dc70246 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -437,6 +437,14 @@ static int aio_setup_ring(struct kioctx *ctx)
  	ctx->user_id = ctx->mmap_base;
  	ctx->nr_events = nr_events; /* trusted copy */

+	/*
+	 * The aio ring pages are user space pages, so they can be migrated.
+	 * When writing to an aio ring page, we should ensure the page is not
+	 * being migrated. Aio page migration procedure is protected by
+	 * ctx->completion_lock, so we add this lock here.
+	 */
+	spin_lock_irq(&ctx->completion_lock);
+
  	ring = kmap_atomic(ctx->ring_pages[0]);
  	ring->nr = nr_events;	/* user copy */
  	ring->id = ~0U;
@@ -448,6 +456,8 @@ static int aio_setup_ring(struct kioctx *ctx)
  	kunmap_atomic(ring);
  	flush_dcache_page(ctx->ring_pages[0]);

+	spin_unlock_irq(&ctx->completion_lock);
+
  	return 0;
  }

@@ -556,9 +566,17 @@ static int ioctx_add_table(struct kioctx *ctx, 
struct mm_struct *mm)
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

@@ -1066,11 +1084,21 @@ static long aio_read_events_ring(struct kioctx *ctx,
  		head %= ctx->nr_events;
  	}

+	/*
+	 * The aio ring pages are user space pages, so they can be migrated.
+	 * When writing to an aio ring page, we should ensure the page is not
+	 * being migrated. Aio page migration procedure is protected by
+	 * ctx->completion_lock, so we add this lock here.
+	 */
+	spin_lock_irq(&ctx->completion_lock);
+
  	ring = kmap_atomic(ctx->ring_pages[0]);
  	ring->head = head;
  	kunmap_atomic(ring);
  	flush_dcache_page(ctx->ring_pages[0]);

+	spin_unlock_irq(&ctx->completion_lock);
+
  	pr_debug("%li  h%u t%u\n", ret, head, tail);

  	put_reqs_available(ctx, ret);
-- 
1.7.7


