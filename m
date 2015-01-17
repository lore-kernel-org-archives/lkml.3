Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbbAQEOG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 23:14:06 -0500
Received: from www.osadl.org ([62.245.132.105]:55578 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbbAQEOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 23:14:04 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] locks should not be needed for reading completion state
Date: Sat, 17 Jan 2015 05:05:34 +0100
Message-Id: <1421467534-22834-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---

Should that not be enough to wrap it into ACCESS_ONCE() here ?

Not a wild performance benefit - but might be worth it anyway

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

