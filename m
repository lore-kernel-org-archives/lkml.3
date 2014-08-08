Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbaHHUl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:41:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40137 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbaHHUlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 131/259] aio: protect reqs_available updates from changes in interrupt handlers
Date: Fri,  8 Aug 2014 13:39:14 -0700
Message-Id: <1407530482-4483-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin LaHaise <bcrl@kvack.org>

commit 263782c1c95bbddbb022dc092fd89a36bb8d5577 upstream.

As of commit f8567a3845ac05bb28f3c1b478ef752762bd39ef it is now possible to
have put_reqs_available() called from irq context.  While put_reqs_available()
is per cpu, it did not protect itself from interrupts on the same CPU.  This
lead to aio_complete() corrupting the available io requests count when run
under a heavy O_DIRECT workloads as reported by Robert Elliott.  Fix this by
disabling irq updates around the per cpu batch updates of reqs_available.

Many thanks to Robert and folks for testing and tracking this down.

Reported-by: Robert Elliot <Elliott@hp.com>
Tested-by: Robert Elliot <Elliott@hp.com>
Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/aio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index 19e7d95..a0d9e43 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -816,16 +816,20 @@ void exit_aio(struct mm_struct *mm)
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 {
 	struct kioctx_cpu *kcpu;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	kcpu->reqs_available += nr;
+
 	while (kcpu->reqs_available >= ctx->req_batch * 2) {
 		kcpu->reqs_available -= ctx->req_batch;
 		atomic_add(ctx->req_batch, &ctx->reqs_available);
 	}
 
+	local_irq_restore(flags);
 	preempt_enable();
 }
 
@@ -833,10 +837,12 @@ static bool get_reqs_available(struct kioctx *ctx)
 {
 	struct kioctx_cpu *kcpu;
 	bool ret = false;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -855,6 +861,7 @@ static bool get_reqs_available(struct kioctx *ctx)
 	ret = true;
 	kcpu->reqs_available--;
 out:
+	local_irq_restore(flags);
 	preempt_enable();
 	return ret;
 }
-- 
1.9.1

