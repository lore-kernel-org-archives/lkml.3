Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3JXJ0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:26:17 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36716 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3JXJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:26:15 -0400
From: Jens Axboe <axboe@kernel.dk>
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, Jens Axboe <axboe@kernel.dk>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 02/11] smp: don't warn about csd->flags having CSD_FLAG_LOCK cleared for !wait
Date: Thu, 24 Oct 2013 10:25:55 +0100
Message-Id: <1382606764-8309-3-git-send-email-axboe@kernel.dk>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk-mq reuses the request potentially immediately, since the most
cache hot is always given out first. This means that rq->csd could
be reused between csd->func() being called and csd_unlock() being
called. This isn't a problem, since we never use wait == 1 for
the smp call function. Add CSD_FLAG_WAIT to be able to tell the
difference, retaining the warning for other cases.

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/smp.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 9de461e..069d20b 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -18,6 +18,7 @@
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 enum {
 	CSD_FLAG_LOCK		= 0x01,
+	CSD_FLAG_WAIT		= 0x02,
 };
 
 struct call_function_data {
@@ -124,7 +125,7 @@ static void csd_lock(struct call_single_data *csd)
 
 static void csd_unlock(struct call_single_data *csd)
 {
-	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
+	WARN_ON((csd->flags & CSD_FLAG_WAIT) && !(csd->flags & CSD_FLAG_LOCK));
 
 	/*
 	 * ensure we're all done before releasing data:
@@ -146,6 +147,9 @@ void generic_exec_single(int cpu, struct call_single_data *csd, int wait)
 	unsigned long flags;
 	int ipi;
 
+	if (wait)
+		csd->flags |= CSD_FLAG_WAIT;
+
 	raw_spin_lock_irqsave(&dst->lock, flags);
 	ipi = list_empty(&dst->list);
 	list_add_tail(&csd->list, &dst->list);
-- 
1.8.1.2

