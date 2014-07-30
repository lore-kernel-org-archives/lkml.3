Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaG3MUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:23 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36793 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753023AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 73/94] aio: protect reqs_available updates from changes in interrupt handlers
Date: Wed, 30 Jul 2014 14:15:02 +0200
Message-Id: <60714352c491ab477ae767582d18059e2534c5a7.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin LaHaise <bcrl@kvack.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/aio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/aio.c b/fs/aio.c
index e609e15f36b9..6d68e01dc7ca 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -830,16 +830,20 @@ void exit_aio(struct mm_struct *mm)
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
 
@@ -847,10 +851,12 @@ static bool get_reqs_available(struct kioctx *ctx)
 {
 	struct kioctx_cpu *kcpu;
 	bool ret = false;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -869,6 +875,7 @@ static bool get_reqs_available(struct kioctx *ctx)
 	ret = true;
 	kcpu->reqs_available--;
 out:
+	local_irq_restore(flags);
 	preempt_enable();
 	return ret;
 }
-- 
2.0.1

