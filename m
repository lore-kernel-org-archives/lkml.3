Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab3DZOTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 10:19:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39951 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3DZOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 10:19:53 -0400
Date: Fri, 26 Apr 2013 07:19:34 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-2c522836627c6e78660f8bd52cdb4cdcb75e3e3c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20130425174002.GA26769@redhat.com>
References: <20130425174002.GA26769@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep:
  Consolidate bug messages into a single print_lockdep_off() function
Git-Commit-ID: 2c522836627c6e78660f8bd52cdb4cdcb75e3e3c
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

Commit-ID:  2c522836627c6e78660f8bd52cdb4cdcb75e3e3c
Gitweb:     http://git.kernel.org/tip/2c522836627c6e78660f8bd52cdb4cdcb75e3e3c
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Thu, 25 Apr 2013 13:40:02 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 26 Apr 2013 08:37:22 +0200

lockdep: Consolidate bug messages into a single print_lockdep_off() function

Also add some missing printk levels.

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20130425174002.GA26769@redhat.com
[ Tweaked the messages a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/lockdep.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c5d1e6b..6a3bccb 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -380,6 +380,13 @@ static int verbose(struct lock_class *class)
 unsigned long nr_stack_trace_entries;
 static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
+static void print_lockdep_off(const char *bug_msg)
+{
+	printk(KERN_DEBUG "%s\n", bug_msg);
+	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
+	printk(KERN_DEBUG "Please attach the output of /proc/lock_stat to the bug report\n");
+}
+
 static int save_trace(struct stack_trace *trace)
 {
 	trace->nr_entries = 0;
@@ -409,9 +416,7 @@ static int save_trace(struct stack_trace *trace)
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_STACK_TRACE_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("BUG: MAX_STACK_TRACE_ENTRIES too low!");
 		dump_stack();
 
 		return 0;
@@ -764,9 +769,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		}
 		raw_local_irq_restore(flags);
 
-		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("BUG: MAX_LOCKDEP_KEYS too low!");
 		dump_stack();
 		return NULL;
 	}
@@ -836,9 +839,7 @@ static struct lock_list *alloc_list_entry(void)
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
-		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("BUG: MAX_LOCKDEP_ENTRIES too low!");
 		dump_stack();
 		return NULL;
 	}
@@ -2051,9 +2052,7 @@ cache_hit:
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("BUG: MAX_LOCKDEP_CHAINS too low!");
 		dump_stack();
 		return 0;
 	}
@@ -3192,10 +3191,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 #endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
-		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
+		print_lockdep_off("BUG: MAX_LOCK_DEPTH too low!");
+		printk(KERN_DEBUG "depth: %i  max: %lu!\n",
 		       curr->lockdep_depth, MAX_LOCK_DEPTH);
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
 
 		lockdep_print_held_locks(current);
 		debug_show_all_locks();
