Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689AbaDJQUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 12:20:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50105 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbaDJQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 12:20:02 -0400
Date: Thu, 10 Apr 2014 18:19:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/5] sched: Convert thread_group_cputime() to use
 for_each_thread()
Message-ID: <20140410161955.GG13658@twins.programming.kicks-ass.net>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com>
 <1397059882-23063-2-git-send-email-fweisbec@gmail.com>
 <20140409171607.GA13498@dyad.arnhem.chello.nl>
 <20140409173233.GA28615@redhat.com>
 <20140409183017.GF10526@twins.programming.kicks-ass.net>
 <20140409194603.GB5854@redhat.com>
 <20140409194957.GD26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409194957.GD26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 09:49:57PM +0200, Peter Zijlstra wrote:
> Anyway, I'll look over the stuff tomorrow.

That patch was missing useful clues..

Also, I shot __for_each_thread in the head, it seemed useless.

---
 include/linux/sched.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7cb07fd26680..6f995bef45d3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2377,6 +2377,9 @@ extern bool current_is_single_threaded(void);
 /*
  * Careful: do_each_thread/while_each_thread is a double loop so
  *          'break' will not work as expected - use goto instead.
+ *
+ * Deprecated; use for_each_thread() instead; this has serious issues with
+ * g != current and RCU.
  */
 #define do_each_thread(g, t) \
 	for (g = t = &init_task ; (g = t = next_task(g)) != &init_task ; ) do
@@ -2384,11 +2387,8 @@ extern bool current_is_single_threaded(void);
 #define while_each_thread(g, t) \
 	while ((t = next_thread(t)) != g)
 
-#define __for_each_thread(signal, t)	\
-	list_for_each_entry_rcu(t, &(signal)->thread_head, thread_node)
-
 #define for_each_thread(p, t)		\
-	__for_each_thread((p)->signal, t)
+	list_for_each_entry_rcu(t, &(p)->signal->thread_head, thread_node)
 
 /* Careful: this is a double loop, 'break' won't work as expected. */
 #define for_each_process_thread(p, t)	\
@@ -2421,7 +2421,8 @@ bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
 	return p1->signal == p2->signal;
 }
 
-static inline struct task_struct *next_thread(const struct task_struct *p)
+static inline __deprecated
+struct task_struct *next_thread(const struct task_struct *p)
 {
 	return list_entry_rcu(p->thread_group.next,
 			      struct task_struct, thread_group);
