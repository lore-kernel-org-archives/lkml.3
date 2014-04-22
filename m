Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbaDVOvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836AbaDVOvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:51:10 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH RESEND 1/2] percpu_ida: Move waking up waiters out of atomic contexts
Date: Tue, 22 Apr 2014 16:51:55 +0200
Message-Id: <832ad160896bbd216b850bdaaf08f841d9e3cc90.1398178132.git.agordeev@redhat.com>
In-Reply-To: <cover.1398178132.git.agordeev@redhat.com>
References: <cover.1398178132.git.agordeev@redhat.com>
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

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 lib/percpu_ida.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 93d145e..472ff08 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -221,6 +221,7 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	struct percpu_ida_cpu *tags;
 	unsigned long flags;
 	unsigned nr_free;
+	bool wake_up = false;
 
 	BUG_ON(tag >= pool->nr_tags);
 
@@ -234,9 +235,8 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	spin_unlock(&tags->lock);
 
 	if (nr_free == 1) {
-		cpumask_set_cpu(smp_processor_id(),
-				&pool->cpus_have_tags);
-		wake_up(&pool->wait);
+		cpumask_set_cpu(smp_processor_id(), &pool->cpus_have_tags);
+		wake_up = true;
 	}
 
 	if (nr_free == pool->percpu_max_size) {
@@ -250,13 +250,15 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
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

