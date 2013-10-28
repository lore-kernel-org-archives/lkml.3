Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab3J1KDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:03:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376Ab3J1KDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:03:17 -0400
Date: Mon, 28 Oct 2013 11:05:25 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] percpu_ida: Move waking up waiters out of atomic contexts
Message-ID: <20131028100522.GC5744@dhcp-26-207.brq.redhat.com>
References: <cover.1382950629.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1382950629.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently percpu_ida_free() waikes up waiters always with local
interrupts disabled and sometimes with pool->lock held. Yet, it
does not appear there is any reason why it could not be done out
of these atomic contexts.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 lib/percpu_ida.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 96cfacf..9dd8741 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -223,6 +223,7 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	struct percpu_ida_cpu *tags;
 	unsigned long flags;
 	unsigned nr_free;
+	bool wake_up = false;
 
 	BUG_ON(tag >= pool->nr_tags);
 
@@ -241,8 +242,8 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 		 * Pairs with smp_rmb() in steal_tags()
 		 */
 		smp_wmb();
-		wake_up(&pool->wait);
-	}
+		wake_up = true;
+	} 
 
 	if (nr_free == pool->percpu_max_size) {
 		spin_lock(&pool->lock);
@@ -255,13 +256,15 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 			move_tags(pool->freelist, &pool->nr_free,
 				  tags->freelist, &tags->nr_free,
 				  pool->percpu_batch_size);
-
-			wake_up(&pool->wait);
+			wake_up = true;
 		}
 		spin_unlock(&pool->lock);
 	}
 
 	local_irq_restore(flags);
+
+	if (wake_up)
+		wake_up(&pool->wait);
 }
 EXPORT_SYMBOL_GPL(percpu_ida_free);
 
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
