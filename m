Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbaHORYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 13:24:50 -0400
Received: from kanga.kvack.org ([205.233.56.17]:34723 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbaHORYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 13:24:49 -0400
Date: Fri, 15 Aug 2014 13:24:49 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] aio: remove no longer needed preempt_disable()
Message-ID: <be6fb451a24582732c66e28cb0beb3f19c4289fd.1408122224.git.bcrl@kvack.org>
References: <cover.1408122224.git.bcrl@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408122224.git.bcrl@kvack.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on feedback from Jens Axboe on 263782c1c95bbddbb022dc092fd89a36bb8d5577,
clean up get/put_reqs_available() to remove the no longer needed preempt_disable()
and preempt_enable() pair.

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jens Axboe <axboe@kernel.dk>
---
 fs/aio.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 8216aa0..9ce9e8e 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -814,10 +814,8 @@ static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 	struct kioctx_cpu *kcpu;
 	unsigned long flags;
 
-	preempt_disable();
-	kcpu = this_cpu_ptr(ctx->cpu);
-
 	local_irq_save(flags);
+	kcpu = this_cpu_ptr(ctx->cpu);
 	kcpu->reqs_available += nr;
 
 	while (kcpu->reqs_available >= ctx->req_batch * 2) {
@@ -826,7 +824,6 @@ static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 	}
 
 	local_irq_restore(flags);
-	preempt_enable();
 }
 
 static bool get_reqs_available(struct kioctx *ctx)
@@ -835,10 +832,8 @@ static bool get_reqs_available(struct kioctx *ctx)
 	bool ret = false;
 	unsigned long flags;
 
-	preempt_disable();
-	kcpu = this_cpu_ptr(ctx->cpu);
-
 	local_irq_save(flags);
+	kcpu = this_cpu_ptr(ctx->cpu);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -858,7 +853,6 @@ static bool get_reqs_available(struct kioctx *ctx)
 	kcpu->reqs_available--;
 out:
 	local_irq_restore(flags);
-	preempt_enable();
 	return ret;
 }
 
-- 
1.8.2.1


-- 
"Thought is the essence of where you are now."
