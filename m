Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaJ1LHm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:07:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaJ1LHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:07:39 -0400
Date: Tue, 28 Oct 2014 04:06:34 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-e2336f6e51edda875a49770b616ed5b02a74665b@git.kernel.org>
Cc: mingo@kernel.org, arnd@arndb.de, hpa@zytor.com, rostedt@goodmis.org,
        peterz@infradead.org, tglx@linutronix.de, cl@linux.com,
        torvalds@linux-foundation.org, tkhai@yandex.ru,
        akpm@linux-foundation.org, agraf@suse.de, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Reply-To: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tkhai@yandex.ru, cl@linux.com, tglx@linutronix.de,
        peterz@infradead.org, arnd@arndb.de, mingo@kernel.org,
        rostedt@goodmis.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        oleg@redhat.com, agraf@suse.de
In-Reply-To: <20141008183348.GC17495@redhat.com>
References: <20141008183348.GC17495@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Kill task_preempt_count()
Git-Commit-ID: e2336f6e51edda875a49770b616ed5b02a74665b
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

Commit-ID:  e2336f6e51edda875a49770b616ed5b02a74665b
Gitweb:     http://git.kernel.org/tip/e2336f6e51edda875a49770b616ed5b02a74665b
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Wed, 8 Oct 2014 20:33:48 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:47:56 +0100

sched: Kill task_preempt_count()

task_preempt_count() is pointless if preemption counter is per-cpu,
currently this is x86 only. It is only valid if the task is not
running, and even in this case the only info it can provide is the
state of PREEMPT_ACTIVE bit.

Change its single caller to check p->on_rq instead, this should be
the same if p->state != TASK_RUNNING, and kill this helper.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>
Cc: Alexander Graf <agraf@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arch@vger.kernel.org
Link: http://lkml.kernel.org/r/20141008183348.GC17495@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/preempt.h | 3 ---
 include/asm-generic/preempt.h  | 3 ---
 kernel/sched/core.c            | 2 +-
 3 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/preempt.h b/arch/x86/include/asm/preempt.h
index 4008734..8f327184 100644
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
index 1b69603..5c067fd 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1054,7 +1054,7 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
 	 * ttwu() will sort out the placement.
 	 */
 	WARN_ON_ONCE(p->state != TASK_RUNNING && p->state != TASK_WAKING &&
-			!(task_preempt_count(p) & PREEMPT_ACTIVE));
+			!p->on_rq);
 
 #ifdef CONFIG_LOCKDEP
 	/*
