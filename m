Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab3JCKPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 06:15:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47667 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCKPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:15:23 -0400
Date: Thu, 3 Oct 2013 03:15:18 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Shaohua Li <shli@fusionio.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] percpu_counter: fix irq restore in __percpu_counter_add
Message-ID: <20131003101518.GA16562@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version of "percpu_counter: make APIs irq safe" in the blk-mq
tree doesn't properly restore irqs, thus causing the boot of the blk-multique
tree to fail with various irqs_disabled() BUGs and related issues.
     
Signed-off-by: Christoph Hellwig <hch@lst.de>

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
