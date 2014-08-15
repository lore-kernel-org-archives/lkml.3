Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbaHOUHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 16:07:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaHOUHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 16:07:18 -0400
From: riel@redhat.com
To: linux-kernel@vger.kernel.org
Cc: oleg@redhat.com, peterz@infradead.org, umgwanakikbuti@gmail.com,
        fweisbec@gmail.com, akpm@linux-foundation.org, srao@redhat.com,
        lwoodman@redhat.com, atheurer@redhat.com
Subject: [PATCH 3/3] sched,time: atomically increment stime & utime
Date: Fri, 15 Aug 2014 16:05:38 -0400
Message-Id: <1408133138-22048-4-git-send-email-riel@redhat.com>
In-Reply-To: <1408133138-22048-1-git-send-email-riel@redhat.com>
References: <1408133138-22048-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rik van Riel <riel@redhat.com>

The functions task_cputime_adjusted and thread_group_cputime_adjusted
can be called locklessly, as well as concurrently on many different CPUs.

This can occasionally lead to the utime and stime reported by times(), and
other syscalls like it, going backward. The cause for this appears to be
multiple threads racing in cputime_adjust, both with values for utime or
stime that is larger than the original, but each with a different value.

Sometimes the larger value gets saved first, only to be immediately
overwritten with a smaller value by another thread.

Using atomic exchange prevents that problem, and ensures time
progresses monotonically.

Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/cputime.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index b5f1c58..ab84270 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -605,9 +605,12 @@ static void cputime_adjust(struct task_cputime *curr,
 	 * If the tick based count grows faster than the scheduler one,
 	 * the result of the scaling may go backward.
 	 * Let's enforce monotonicity.
+	 * Atomic exchange protects against concurrent cputime_adjust.
 	 */
-	prev->stime = max(prev->stime, stime);
-	prev->utime = max(prev->utime, utime);
+	while (stime > (rtime = ACCESS_ONCE(prev->stime)))
+		cmpxchg(&prev->stime, rtime, stime);
+	while (utime > (rtime = ACCESS_ONCE(prev->utime)))
+		cmpxchg(&prev->utime, rtime, utime);
 
 out:
 	*ut = prev->utime;
-- 
1.8.3.1

