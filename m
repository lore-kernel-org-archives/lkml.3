Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaKDQME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:12:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbaKDQL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:11:58 -0500
Date: Tue, 4 Nov 2014 08:11:07 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-804968809c321066cca028d4cbd533a420f964bc@git.kernel.org>
Cc: ktkhai@parallels.com, juri.lelli@arm.com, tglx@linutronix.de,
        wanpeng.li@linux.intel.com, torvalds@linux-foundation.org,
        mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, peterz@infradead.org,
        wanpeng.li@linux.intel.com, torvalds@linux-foundation.org,
        ktkhai@parallels.com, tglx@linutronix.de, juri.lelli@arm.com,
        mingo@kernel.org
In-Reply-To: <1414708776-124078-2-git-send-email-wanpeng.li@linux.intel.com>
References: <1414708776-124078-2-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline:
  Fix artificial overrun introduced by yield_task_dl()
Git-Commit-ID: 804968809c321066cca028d4cbd533a420f964bc
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

Commit-ID:  804968809c321066cca028d4cbd533a420f964bc
Gitweb:     http://git.kernel.org/tip/804968809c321066cca028d4cbd533a420f964bc
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Fri, 31 Oct 2014 06:39:32 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:53 +0100

sched/deadline: Fix artificial overrun introduced by yield_task_dl()

The yield semantic of deadline class is to reduce remaining runtime to
zero, and then update_curr_dl() will stop it. However, comsumed bandwidth
is reduced from the budget of yield task again even if it has already been
set to zero which leads to artificial overrun. This patch fix it by make
sure we don't steal some more time from the task that yielded in update_curr_dl().

Suggested-by: Juri Lelli <juri.lelli@arm.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414708776-124078-2-git-send-email-wanpeng.li@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 9d483e8..c047a94 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -628,7 +628,7 @@ static void update_curr_dl(struct rq *rq)
 
 	sched_rt_avg_update(rq, delta_exec);
 
-	dl_se->runtime -= delta_exec;
+	dl_se->runtime -= dl_se->dl_yielded ? 0 : delta_exec;
 	if (dl_runtime_exceeded(rq, dl_se)) {
 		__dequeue_task_dl(rq, curr, 0);
 		if (likely(start_dl_timer(dl_se, curr->dl.dl_boosted)))
