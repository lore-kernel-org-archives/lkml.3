Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3D3JfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:35:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab3D3JfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:35:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, hpa@zytor.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH -tip 2/4] sched: Do not account bogus utime
Date: Tue, 30 Apr 2013 11:35:05 +0200
Message-Id: <1367314507-9728-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
References: <1367314507-9728-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to rounding in scale_stime(), for big numbers, scaled stime values
will grow in chunks. Since rtime grow in jiffies and we calculate utime
like below:

	prev->stime = max(prev->stime, stime);
	prev->utime = max(prev->utime, rtime - prev->stime);

we could erroneously account stime values as utime. To prevent that only
update prev->{u,s}time values when they are smaller than current rtime.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/sched/cputime.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index b3dd984..3f192bf 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -581,6 +581,14 @@ static void cputime_adjust(struct task_cputime *curr,
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
+	/*
+	 * Update userspace visible utime/stime values only if actual execution
+	 * time is bigger than already exported. Note that can happen, that we
+	 * provided bigger values due to scaling inaccuracy on big numbers.
+	 */
+	if (prev->stime + prev->utime >= rtime)
+		goto out;
+
 	if (!rtime) {
 		stime = 0;
 	} else if (!total) {
@@ -598,6 +606,7 @@ static void cputime_adjust(struct task_cputime *curr,
 	prev->stime = max(prev->stime, stime);
 	prev->utime = max(prev->utime, rtime - prev->stime);
 
+out:
 	*ut = prev->utime;
 	*st = prev->stime;
 }
-- 
1.7.11.7

