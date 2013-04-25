Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab3DYSYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 14:24:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab3DYSYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 14:24:18 -0400
Date: Thu, 25 Apr 2013 13:40:02 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Print out additional debugging advice when we hit lockdep BUGs
Message-ID: <20130425174002.GA26769@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Ingo Molnar <mingo@elte.hu>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130423163403.GA12839@redhat.com>
 <20130424064813.GB27551@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130424064813.GB27551@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 08:48:13AM +0200, Ingo Molnar wrote:

 > These patterns repeated in 4 places really call for a common helper 
 > defined as print_lockdep_off(fmt...) or so?
 > 
 > (Can be a followup patch if that's easier for you.)

Given there was only one case which was really different, I opted not
to bother with varargs, and just pass the one string that changes
and add an extra printk for that special case (MAX_LOCK_DEPTH)

-- 

Consolidate the lockdep "too low" messages into one function.
Also add some missing printk levels.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index e4c001f..be52e6d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -380,6 +380,13 @@ static int verbose(struct lock_class *class)
 unsigned long nr_stack_trace_entries;
 static unsigned long stack_trace[MAX_STACK_TRACE_ENTRIES];
 
+static void print_lockdep_off(const char *which)
+{
+	printk(KERN_DEBUG "BUG: %s too low!\n", which);
+	printk(KERN_DEBUG "turning off the locking correctness validator.\n");
+	printk(KERN_DEBUG "Attach output of /proc/lock_stat to bug report\n");
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
+		print_lockdep_off("MAX_STACK_TRACE_ENTRIES");
 		dump_stack();
 
 		return 0;
@@ -777,9 +782,7 @@ register_lock_class(struct lockdep_map *lock, unsigned int subclass, int force)
 		}
 		raw_local_irq_restore(flags);
 
-		printk("BUG: MAX_LOCKDEP_KEYS too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("MAX_LOCKDEP_KEYS");
 		dump_stack();
 		return NULL;
 	}
@@ -849,9 +852,7 @@ static struct lock_list *alloc_list_entry(void)
 		if (!debug_locks_off_graph_unlock())
 			return NULL;
 
-		printk("BUG: MAX_LOCKDEP_ENTRIES too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("MAX_LOCKDEP_ENTRIES");
 		dump_stack();
 		return NULL;
 	}
@@ -2064,9 +2065,7 @@ cache_hit:
 		if (!debug_locks_off_graph_unlock())
 			return 0;
 
-		printk("BUG: MAX_LOCKDEP_CHAINS too low!\n");
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
+		print_lockdep_off("MAX_LOCKDEP_CHAINS");
 		dump_stack();
 		return 0;
 	}
@@ -3208,10 +3207,9 @@ static int __lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 #endif
 	if (unlikely(curr->lockdep_depth >= MAX_LOCK_DEPTH)) {
 		debug_locks_off();
-		printk("BUG: MAX_LOCK_DEPTH too low, depth: %i  max: %lu!\n",
+		print_lockdep_off("MAX_LOCK_DEPTH");
+		printk(KERN_DEBUG "depth: %i  max: %lu!\n",
 		       curr->lockdep_depth, MAX_LOCK_DEPTH);
-		printk("turning off the locking correctness validator.\n");
-		printk("Attach output of /proc/lock_stat to bug report\n");
 
 		lockdep_print_held_locks(current);
 		debug_show_all_locks();
