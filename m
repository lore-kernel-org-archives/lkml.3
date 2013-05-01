Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759265Ab3EAKGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:06:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab3EAKGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:06:37 -0400
Date: Wed, 1 May 2013 03:06:02 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-68aa8efcd1ab961e4684ef5af32f72a6ec1911de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, dave@sr71.net,
        fweisbec@gmail.com, tglx@linutronix.de, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, dave@sr71.net,
        fweisbec@gmail.com, tglx@linutronix.de, sgruszka@redhat.com
In-Reply-To: <1367314507-9728-3-git-send-email-sgruszka@redhat.com>
References: <1367314507-9728-3-git-send-email-sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Avoid prev->stime underflow
Git-Commit-ID: 68aa8efcd1ab961e4684ef5af32f72a6ec1911de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68aa8efcd1ab961e4684ef5af32f72a6ec1911de
Gitweb:     http://git.kernel.org/tip/68aa8efcd1ab961e4684ef5af32f72a6ec1911de
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 30 Apr 2013 11:35:06 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 19:13:05 +0200

sched: Avoid prev->stime underflow

Dave Hansen reported strange utime/stime values on his system:
https://lkml.org/lkml/2013/4/4/435

This happens because prev->stime value is bigger than rtime
value. Root of the problem are non-monotonic rtime values (i.e.
current rtime is smaller than previous rtime) and that should be
debugged and fixed.

But since problem did not manifest itself before commit
62188451f0d63add7ad0cd2a1ae269d600c1663d "cputime: Avoid
multiplication overflow on utime scaling", it should be threated
as regression, which we can easily fixed on cputime_adjust()
function.

For now, let's apply this fix, but further work is needed to fix
root of the problem.

Reported-and-tested-by: Dave Hansen <dave@sr71.net>
Cc: <stable@vger.kernel.org> # 3.9+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1367314507-9728-3-git-send-email-sgruszka@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cputime.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index 1b7c216..337a367 100644
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
