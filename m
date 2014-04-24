Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbaDXRwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:52:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:34478 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757450AbaDXRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:52:26 -0400
Date: Thu, 24 Apr 2014 13:52:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
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
Message-ID: <20140424135223.5fb6b21e@gandalf.local.home>
In-Reply-To: <20140418081926.GC14560@gmail.com>
References: <20140409151922.5fa5d999@gandalf.local.home>
	<20140410134217.38cd6db7@gandalf.local.home>
	<20140410223508.6d0fc135@gandalf.local.home>
	<5347E475.4020009@osadl.org>
	<20140411092524.1f242e25@gandalf.local.home>
	<20140417192603.6e379157@gandalf.local.home>
	<20140418081926.GC14560@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014 10:19:26 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Changes since v3:
> > 
> > Clark reported that he was seeing a large latency when he added this
> > patch. I tested it out on a 8 logical CPU box, and sure enough I was
> > seeing it too. After spending the day debugging why, I found that I had
> > a bug in rt_mutex_getprio(), where I could do:
> > 
> >   min(task_top_pi_waiter(task)->pi_list_entry.prio, prio)
> > 
> > when there was no "top_pi_waiter", which would give garbage as a
> > result. This would let some tasks have higher priority than they
> > should, and cause other tasks that should have high priority not run.
> 
> Would a sanity check like the one below have helped? (untested and 
> such)

Actually, if I had run this with CONFIG_DEBUG_PI_LIST then this would
have triggered:

#ifdef CONFIG_DEBUG_PI_LIST
# define plist_first_entry(head, type, member)	\
({ \
	WARN_ON(plist_head_empty(head)); \
	container_of(plist_first(head), type, member); \
})
#else
# define plist_first_entry(head, type, member)	\
	container_of(plist_first(head), type, member)
#endif

-- Steve

> 
> Thanks,
> 
> 	Ingo
> 
> ==========>
>  kernel/locking/rtmutex_common.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/locking/rtmutex_common.h b/kernel/locking/rtmutex_common.h
> index 7431a9c..36b1ce8 100644
> --- a/kernel/locking/rtmutex_common.h
> +++ b/kernel/locking/rtmutex_common.h
> @@ -85,6 +85,7 @@ static inline int task_has_pi_waiters(struct task_struct *p)
>  static inline struct rt_mutex_waiter *
>  task_top_pi_waiter(struct task_struct *p)
>  {
> +	WARN_ON_ONCE(!p->pi_waiters_leftmost);
>  	return rb_entry(p->pi_waiters_leftmost, struct rt_mutex_waiter,
>  			pi_tree_entry);
>  }

