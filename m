Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbbAWLy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:54:59 -0500
Received: from www.osadl.org ([62.245.132.105]:52593 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755280AbbAWLyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:54:50 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH RFC v2] sched: completion: locks should not be needed for reading completion state
Date: Fri, 23 Jan 2015 12:46:40 +0100
Message-Id: <1422013600-13252-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

v2: proper subsystem tag in subject line

The ACCESS_ONCE is needed for calls in a loop that, if inlined, could
optimize out the re-fetching of x->done. An explicit memory barrier is 
not needed as complete() and complete_all() imply a barrier.

 kernel/sched/completion.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/kernel/sched/completion.c b/kernel/sched/completion.c
index 607f852..7c5cd70 100644
--- a/kernel/sched/completion.c
+++ b/kernel/sched/completion.c
@@ -288,13 +288,6 @@ EXPORT_SYMBOL(try_wait_for_completion);
  */
 bool completion_done(struct completion *x)
 {
-	unsigned long flags;
-	int ret = 1;
-
-	spin_lock_irqsave(&x->wait.lock, flags);
-	if (!x->done)
-		ret = 0;
-	spin_unlock_irqrestore(&x->wait.lock, flags);
-	return ret;
+	return !ACCESS_ONCE(x->done);
 }
 EXPORT_SYMBOL(completion_done);
-- 
1.7.10.4

