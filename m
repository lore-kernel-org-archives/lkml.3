Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbaJGTy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:54:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbaJGTy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:54:26 -0400
Date: Tue, 7 Oct 2014 21:51:08 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] sched: fix the PREEMPT_ACTIVE check in
	__trace_sched_switch_state()
Message-ID: <20141007195108.GB28002@redhat.com>
References: <20141007195046.GA28002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007195046.GA28002@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_preempt_count() has nothing to do with the actual preempt counter,
thread_info->saved_preempt_count is only valid right after switch_to().

__trace_sched_switch_state() can use preempt_count(), prev is still the
current task when trace_sched_switch() is called.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 include/trace/events/sched.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 0a68d5a..a7d67bc 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -100,7 +100,7 @@ static inline long __trace_sched_switch_state(struct task_struct *p)
 	/*
 	 * For all intents and purposes a preempted task is a running task.
 	 */
-	if (task_preempt_count(p) & PREEMPT_ACTIVE)
+	if (preempt_count() & PREEMPT_ACTIVE)
 		state = TASK_RUNNING | TASK_STATE_MAX;
 #endif
 
-- 
1.5.5.1


