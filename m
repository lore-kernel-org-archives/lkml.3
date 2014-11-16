Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaKPJu4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:50:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34395 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaKPJuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:50:52 -0500
Date: Sun, 16 Nov 2014 01:50:16 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-7af683350cb0ddd0e9d3819b4eb7abe9e2d3e709@git.kernel.org>
Cc: peterz@infradead.org, hpa@zytor.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@kernel.org, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org
Reply-To: tglx@linutronix.de, peterz@infradead.org, hpa@zytor.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        mingo@kernel.org, sasha.levin@oracle.com
In-Reply-To: <20141110100328.GF29390@twins.programming.kicks-ass.net>
References: <20141110100328.GF29390@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/numa:
  Avoid selecting oneself as swap target
Git-Commit-ID: 7af683350cb0ddd0e9d3819b4eb7abe9e2d3e709
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

Commit-ID:  7af683350cb0ddd0e9d3819b4eb7abe9e2d3e709
Gitweb:     http://git.kernel.org/tip/7af683350cb0ddd0e9d3819b4eb7abe9e2d3e709
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 10 Nov 2014 10:54:35 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:04:17 +0100

sched/numa: Avoid selecting oneself as swap target

Because the whole numa task selection stuff runs with preemption
enabled (its long and expensive) we can end up migrating and selecting
oneself as a swap target. This doesn't really work out well -- we end
up trying to acquire the same lock twice for the swap migrate -- so
avoid this.

Reported-and-Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20141110100328.GF29390@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 34baa60..3af3d1e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1180,6 +1180,13 @@ static void task_numa_compare(struct task_numa_env *env,
 	raw_spin_unlock_irq(&dst_rq->lock);
 
 	/*
+	 * Because we have preemption enabled we can get migrated around and
+	 * end try selecting ourselves (current == env->p) as a swap candidate.
+	 */
+	if (cur == env->p)
+		goto unlock;
+
+	/*
 	 * "imp" is the fault differential for the source task between the
 	 * source and destination node. Calculate the total differential for
 	 * the source task and potential destination task. The more negative
