Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbaJHShL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbaJHShH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:37:07 -0400
Date: Wed, 8 Oct 2014 20:33:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org, Kirill Tkhai <tkhai@yandex.ru>
Subject: [PATCH 2/2] sched: kill task_preempt_count()
Message-ID: <20141008183348.GC17495@redhat.com>
References: <20141007195046.GA28002@redhat.com> <20141008080016.GB10832@worktop.programming.kicks-ass.net> <20141008183302.GA17495@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008183302.GA17495@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_preempt_count() is pointless if preemption counter is per-cpu,
currently this is x86 only. It is only valid if the task is not
running, and even in this case the only info it can provide is the
state of PREEMPT_ACTIVE bit.

Change its single caller to check p->on_rq instead, this should be
the same if p->state != TASK_RUNNING, and kill this helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/include/asm/preempt.h |    3 ---
 include/asm-generic/preempt.h  |    3 ---
 kernel/sched/core.c            |    2 +-
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 4008734..8f32718 100644
--- a/arch/x86/include/asm/preempt.h
+++ b/arch/x86/include/asm/preempt.h
@@ -30,9 +30,6 @@ static __always_inline void preempt_count_set(int pc)
 /*
  * must be macros to avoid header recursion hell
  */
-#define task_preempt_count(p) \
-	(task_thread_info(p)->saved_preempt_count & ~PREEMPT_NEED_RESCHED)
-
 #define init_task_preempt_count(p) do { \
 	task_thread_info(p)->saved_preempt_count = PREEMPT_DISABLED; \
 } while (0)
diff --git a/include/asm-generic/preempt.h b/include/asm-generic/preempt.h
index 1cd3f5d..eb6f9e6 100644
--- a/include/asm-generic/preempt.h
+++ b/include/asm-generic/preempt.h
@@ -23,9 +23,6 @@ static __always_inline void preempt_count_set(int pc)
 /*
  * must be macros to avoid header recursion hell
  */
-#define task_preempt_count(p) \
-	(task_thread_info(p)->preempt_count & ~PREEMPT_NEED_RESCHED)
-
 #define init_task_preempt_count(p) do { \
 	task_thread_info(p)->preempt_count = PREEMPT_DISABLED; \
 } while (0)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3f267e8..cfe9905 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1056,7 +1056,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_preempt_count(p) & PREEMPT_ACTIVE));
+			!p->on_rq);
 
 #ifdef CONFIG_LOCKDEP
 	/*
-- 
1.5.5.1


