Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbaJ1LHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:07:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51065 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaJ1LHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:07:03 -0400
Date: Tue, 28 Oct 2014 04:05:45 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-8f9fbf092cd0ae31722b42c9abb427a87d55c18a@git.kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, akpm@linux-foundation.org,
        oleg@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, mgorman@suse.de,
        tglx@linutronix.de, luto@amacapital.net
Reply-To: hpa@zytor.com, mingo@kernel.org, oleg@redhat.com,
        rostedt@goodmis.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org, luto@amacapital.net, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <20141007195108.GB28002@redhat.com>
References: <20141007195108.GB28002@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix the PREEMPT_ACTIVE check in __trace_sched_switch_state()
Git-Commit-ID: 8f9fbf092cd0ae31722b42c9abb427a87d55c18a
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

Commit-ID:  8f9fbf092cd0ae31722b42c9abb427a87d55c18a
Gitweb:     http://git.kernel.org/tip/8f9fbf092cd0ae31722b42c9abb427a87d55c18a
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 7 Oct 2014 21:51:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:53 +0100

sched: Fix the PREEMPT_ACTIVE check in __trace_sched_switch_state()

task_preempt_count() has nothing to do with the actual preempt counter,
thread_info->saved_preempt_count is only valid right after switch_to().

__trace_sched_switch_state() can use preempt_count(), prev is still the
current task when trace_sched_switch() is called.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
[ Added BUG_ON(). ]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20141007195108.GB28002@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/trace/events/sched.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5a..30fedaf 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -97,16 +97,19 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	long state = p->state;
 
 #ifdef CONFIG_PREEMPT
+#ifdef CONFIG_SCHED_DEBUG
+	BUG_ON(p != current);
+#endif /* CONFIG_SCHED_DEBUG */
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
-#endif
+#endif /* CONFIG_PREEMPT */
 
 	return state;
 }
-#endif
+#endif /* CREATE_TRACE_POINTS */
 
 /*
  * Tracepoint for task switches, performed by the scheduler:
