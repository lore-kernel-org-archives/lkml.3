Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604Ab3HNKww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:52:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34519 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759874Ab3HNKht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:49 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Zhu Yanhai <gaoyang.zyh@taobao.com>, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 22/75] sched: Fix the broken sched_rr_get_interval()
Date: Wed, 14 Aug 2013 11:36:11 +0100
Message-Id: <1376476624-10011-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhu Yanhai <gaoyang.zyh@taobao.com>

commit a59f4e079d19464eebb9b06513a1d4f55fdae5ba upstream.

The caller of sched_sliced() should pass se.cfs_rq and se as the
arguments, however in sched_rr_get_interval() we gave it
rq.cfs_rq and se, which made the following computation obviously
wrong.

The change was introduced by commit:

  77034937dc45 sched: fix crash in sys_sched_rr_get_interval()

... 5 years ago, while it had been the correct 'cfs_rq_of' before
the commit. The change seems to be irrelevant to the commit
msg, which was to return a 0 timeslice for tasks that are on an
idle runqueue. So I believe that was just a plain typo.

Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1357621012-15039-1-git-send-email-gaoyang.zyh@taobao.com
[ Since this is an ABI and an old bug, we'll test this via a
  slow upstream route, to hopefully discover any app breakage. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c099cc6..eb12b9e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5250,7 +5250,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }
-- 
1.8.3.2

