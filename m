Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbaGNRis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:38:48 -0400
Received: from kanga.kvack.org ([205.233.56.17]:43128 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148AbaGNRil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:38:41 -0400
Date: Mon, 14 Jul 2014 13:38:39 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Robert Elliot <Elliott@hp.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] aio: protect reqs_available updates from changes in interrupt handlers
Message-ID: <20140714173839.GE11326@kvack.org>
References: <20140714171227.GC11326@kvack.org> <53C413C3.7050308@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C413C3.7050308@kernel.dk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 07:30:43PM +0200, Jens Axboe wrote:
> Why not just makes this:
> 
> 	local_irq_save(flags);
> 	kcpu = this_put_ptr(...);
> 	...
> 
> and get rid of the preemption bits, it's a bit redundant now you need to 
> kill local interrupts anyway.

*nod*.  I'll add the following cleanup patch, as the first version already 
got merged into another tree.

		-ben

diff --git a/fs/aio.c b/fs/aio.c
index 1c9c5f0..104da62 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -832,10 +832,8 @@ static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 	struct kioctx_cpu *kcpu;
 	unsigned long flags;
 
-	preempt_disable();
-	kcpu = this_cpu_ptr(ctx->cpu);
-
 	local_irq_save(flags);
+	kcpu = this_cpu_ptr(ctx->cpu);
 	kcpu->reqs_available += nr;
 
 	while (kcpu->reqs_available >= ctx->req_batch * 2) {
@@ -844,7 +842,6 @@ static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 	}
 
 	local_irq_restore(flags);
-	preempt_enable();
 }
 
 static bool get_reqs_available(struct kioctx *ctx)
@@ -853,10 +850,8 @@ static bool get_reqs_available(struct kioctx *ctx)
 	bool ret = false;
 	unsigned long flags;
 
-	preempt_disable();
-	kcpu = this_cpu_ptr(ctx->cpu);
-
 	local_irq_save(flags);
+	kcpu = this_cpu_ptr(ctx->cpu);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -876,7 +871,6 @@ static bool get_reqs_available(struct kioctx *ctx)
 	kcpu->reqs_available--;
 out:
 	local_irq_restore(flags);
-	preempt_enable();
 	return ret;
 }
 

		-ben
-- 
"Thought is the essence of where you are now."
