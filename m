Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3JDNud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 09:50:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53084 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab3JDNuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 09:50:22 -0400
Message-Id: <20131004135014.326501839@bombadil.infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 04 Oct 2013 06:49:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] [PATCH 1/5] percpu_counter: fix irq restore in __percpu_counter_add
References: <20131004134908.231874670@bombadil.infradead.org>
Content-Disposition: inline; filename=0001-percpu_counter-fix-irq-restore-in-__percpu_counter_a.patch
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version of "percpu_counter: make APIs irq safe" in the blk-mq
tree doesn't properly restore irqs, thus causing the boot of the blk-multique
tree to fail with various irqs_disabled() BUGs and related issues.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/percpu_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 1ae43a7..7473ee3 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -82,7 +82,7 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 		unsigned long flags;
 		raw_spin_lock_irqsave(&fbc->lock, flags);
 		fbc->count += count;
-		raw_spin_unlock(&fbc->lock);
+		raw_spin_unlock_irqrestore(&fbc->lock, flags);
 		__this_cpu_write(*fbc->counters, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
-- 
1.7.10.4


