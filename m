Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422637Ab3AXUQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:16:23 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34435 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161002Ab3AXUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:16:10 -0500
Date: Thu, 24 Jan 2013 12:15:35 -0800
From: tip-bot for Zhu Yanhai <gaoyang.zyh@taobao.com>
Message-ID: <tip-a59f4e079d19464eebb9b06513a1d4f55fdae5ba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, pjt@google.com, peterz@infradead.org,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        gaoyang.zyh@taobao.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, pjt@google.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de,
        gaoyang.zyh@taobao.com
In-Reply-To: <1357621012-15039-1-git-send-email-gaoyang.zyh@taobao.com>
References: <1357621012-15039-1-git-send-email-gaoyang.zyh@taobao.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix the broken sched_rr_get_interval()
Git-Commit-ID: a59f4e079d19464eebb9b06513a1d4f55fdae5ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:15:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a59f4e079d19464eebb9b06513a1d4f55fdae5ba
Gitweb:     http://git.kernel.org/tip/a59f4e079d19464eebb9b06513a1d4f55fdae5ba
Author:     Zhu Yanhai <gaoyang.zyh@taobao.com>
AuthorDate: Tue, 8 Jan 2013 12:56:52 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 14:41:00 +0100

sched: Fix the broken sched_rr_get_interval()

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
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 5eea870..a7a19ff 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6101,7 +6101,7 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 	 * idle runqueue:
 	 */
 	if (rq->cfs.load.weight)
-		rr_interval = NS_TO_JIFFIES(sched_slice(&rq->cfs, se));
+		rr_interval = NS_TO_JIFFIES(sched_slice(cfs_rq_of(se), se));
 
 	return rr_interval;
 }
