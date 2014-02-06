Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaBFMYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:24:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756078AbaBFMYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:24:07 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH RESEND 2/3] percpu_ida: Move waking up waiters out of atomic contexts
Date: Thu,  6 Feb 2014 13:24:54 +0100
Message-Id: <df714a474d1358bf594f3f6dc02cdcf296cef40d.1391688720.git.agordeev@redhat.com>
In-Reply-To: <cover.1391688720.git.agordeev@redhat.com>
References: <cover.1391688720.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently percpu_ida_free() waikes up waiters always with local
interrupts disabled and sometimes with pool->lock held. Yet, it
does not appear there is any reason why it could not be done out
of these atomic contexts.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Acked-by: Kent Overstreet <kmo@daterainc.com>
---
 lib/percpu_ida.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index fccfb28..c2fa3dc 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -229,6 +229,7 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	struct percpu_ida_cpu *tags;
 	unsigned long flags;
 	unsigned nr_free;
+	bool wake_up = false;
 
 	BUG_ON(tag >= pool->nr_tags);
 
@@ -247,7 +248,7 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 		 * Pairs with smp_rmb() in steal_tags()
 		 */
 		smp_wmb();
-		wake_up(&pool->wait);
+		wake_up = true;
 	}
 
 	if (nr_free == pool->percpu_max_size) {
@@ -261,13 +262,15 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
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

