Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbaBVSC6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 13:02:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbaBVSCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 13:02:55 -0500
Date: Sat, 22 Feb 2014 10:02:27 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-d6b1e9119787fd2e31dcf0f0ce90b71197604206@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, bigeasy@linutronix.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1391803122-4425-5-git-send-email-bigeasy@linutronix.de>
References: <1391803122-4425-5-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Adjust p->
 sched_reset_on_fork when nothing else changes
Git-Commit-ID: d6b1e9119787fd2e31dcf0f0ce90b71197604206
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

Commit-ID:  d6b1e9119787fd2e31dcf0f0ce90b71197604206
Gitweb:     http://git.kernel.org/tip/d6b1e9119787fd2e31dcf0f0ce90b71197604206
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 7 Feb 2014 20:58:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 22 Feb 2014 18:08:43 +0100

sched: Adjust p->sched_reset_on_fork when nothing else changes

If the policy and priority remain unchanged a possible modification of
p->sched_reset_on_fork gets lost in the early exit path.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[ Rebase ontop of v3.14-rc1. ]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1391803122-4425-5-git-send-email-bigeasy@linutronix.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c94e851..771eb87 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3362,7 +3362,8 @@ recheck:
 	}
 
 	/*
-	 * If not changing anything there's no need to proceed further:
+	 * If not changing anything there's no need to proceed further,
+	 * but store a possible modification of reset_on_fork.
 	 */
 	if (unlikely(policy == p->policy)) {
 		if (fair_policy(policy) && attr->sched_nice != task_nice(p))
@@ -3372,6 +3373,7 @@ recheck:
 		if (dl_policy(policy))
 			goto change;
 
+		p->sched_reset_on_fork = reset_on_fork;
 		task_rq_unlock(rq, p, &flags);
 		return 0;
 	}
