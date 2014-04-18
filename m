Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaDRIT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 04:19:56 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:55303 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaDRITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 04:19:33 -0400
Date: Fri, 18 Apr 2014 10:19:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH RT V4] rwsem: The return of multi-reader PI rwsems
Message-ID: <20140418081926.GC14560@gmail.com>
References: <20140409151922.5fa5d999@gandalf.local.home>
 <20140410134217.38cd6db7@gandalf.local.home>
 <20140410223508.6d0fc135@gandalf.local.home>
 <5347E475.4020009@osadl.org>
 <20140411092524.1f242e25@gandalf.local.home>
 <20140417192603.6e379157@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417192603.6e379157@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Changes since v3:
> 
> Clark reported that he was seeing a large latency when he added this
> patch. I tested it out on a 8 logical CPU box, and sure enough I was
> seeing it too. After spending the day debugging why, I found that I had
> a bug in rt_mutex_getprio(), where I could do:
> 
>   min(task_top_pi_waiter(task)->pi_list_entry.prio, prio)
> 
> when there was no "top_pi_waiter", which would give garbage as a
> result. This would let some tasks have higher priority than they
> should, and cause other tasks that should have high priority not run.

Would a sanity check like the one below have helped? (untested and 
such)

Thanks,

	Ingo

==========>
 kernel/locking/rtmutex_common.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
index 7431a9c..36b1ce8 100644
--- a/kernel/locking/rtmutex_common.h
+++ b/kernel/locking/rtmutex_common.h
@@ -85,6 +85,7 @@ static inline int task_has_pi_waiters(struct task_struct *p)
 static inline struct rt_mutex_waiter *
 task_top_pi_waiter(struct task_struct *p)
 {
+	WARN_ON_ONCE(!p->pi_waiters_leftmost);
 	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
 			pi_tree_entry);
 }
