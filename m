Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992Ab3D3JfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:35:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758972Ab3D3JfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:35:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 3/4] sched: Avoid prev->stime underflow
Date: Tue, 30 Apr 2013 11:35:06 +0200
Message-Id: <1367314507-9728-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
References: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen reported strange utime/stime values on his system:
https://lkml.org/lkml/2013/4/4/435

This happens because prev->stime value is bigger than rtime value.
Root of the problem are non-monotonic rtime values (i.e. current rtime
is smaller than previous rtime) and that should be debugged and fixed.

But since problem did not manifest itself before commit
62188451f0d63add7ad0cd2a1ae269d600c1663d "cputime: Avoid multiplication
overflow on utime scaling", it should be threated as regression, which
we can easily fixed on cputime_adjust() function.

For now, let's apply this fix, but further work is needed to fix root of
the problem.

Reported-and-tested-by: Dave Hansen <dave@sr71.net>
Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched/cputime.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 3f192bf..cc2dc3e 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -558,7 +558,7 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, stime, total;
+	cputime_t rtime, stime, utime, total;
 
 	if (vtime_accounting_enabled()) {
 		*ut = curr->utime;
@@ -589,13 +589,13 @@ static void cputime_adjust(struct task_cputime *curr,
 	if (prev->stime + prev->utime >= rtime)
 		goto out;
 
-	if (!rtime) {
-		stime = 0;
-	} else if (!total) {
-		stime = rtime;
-	} else {
+	if (total) {
 		stime = scale_stime((__force u64)stime,
 				    (__force u64)rtime, (__force u64)total);
+		utime = rtime - stime;
+	} else {
+		stime = rtime;
+		utime = 0;
 	}
 
 	/*
@@ -604,7 +604,7 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * Let's enforce monotonicity.
 	 */
 	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, rtime - prev->stime);
+	prev->utime = max(prev->utime, utime);
 
 out:
 	*ut = prev->utime;
-- 
1.7.11.7

