Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaGZT2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:28:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaGZTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:23:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Robert Elliot <Elliott@hp.com>, Benjamin LaHaise <bcrl@kvack.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3.15 104/109] aio: protect reqs_available updates from changes in interrupt handlers
Date: Sat, 26 Jul 2014 12:03:06 -0700
Message-Id: <20140726190226.982021499@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |    7 +++++++
 1 file changed, 7 insertions(+)

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
 
@@ -847,10 +851,12 @@ static bool get_reqs_available(struct ki
 {
 	struct kioctx_cpu *kcpu;
 	bool ret = false;
+	unsigned long flags;
 
 	preempt_disable();
 	kcpu = this_cpu_ptr(ctx->cpu);
 
+	local_irq_save(flags);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -869,6 +875,7 @@ static bool get_reqs_available(struct ki
 	ret = true;
 	kcpu->reqs_available--;
 out:
+	local_irq_restore(flags);
 	preempt_enable();
 	return ret;
 }


