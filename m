Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbbAWLuW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:50:22 -0500
Received: from www.osadl.org ([62.245.132.105]:52574 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbbAWLuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:50:20 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC] sched: completion: lock-free checking of the blocking case
Date: Fri, 23 Jan 2015 12:41:47 +0100
Message-Id: <1422013307-13200-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "thread would block" case can be checked without grabbing the lock

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

If the check does not return early then grab the lock and recheck.
A memory barrier is not needed as complete() and complete_all() imply
a barrier.

The ACCESS_ONCE is needed for calls in a loop that, if inlined, could
optimize out the re-fetching of x->done.

 kernel/sched/completion.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 7c5cd70..5f7cf31 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -268,6 +268,15 @@ bool try_wait_for_completion(struct completion *x)
 	unsigned long flags;
 	int ret = 1;
 
+	/*
+	 * Since x->done will need to be locked only
+	 * in the non-blocking case, we check x->done
+	 * first without taking the lock so we can
+	 * return early in the blocking case.
+	 */
+	if (!ACCESS_ONCE(x->done))
+		return 0;
+
 	spin_lock_irqsave(&x->wait.lock, flags);
 	if (!x->done)
 		ret = 0;
-- 
1.7.10.4

