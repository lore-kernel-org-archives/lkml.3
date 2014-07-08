Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbaGHQog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:44:36 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:26413 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaGHQof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:44:35 -0400
Message-ID: <1404837870.2448.9.camel@j-VirtualBox>
Subject: Re: [PATCH 2/4] MCS spinlocks: Convert osq lock to atomic_t to
 reduce overhead
From: Jason Low <jason.low2@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: peterz@infradead.org, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, Waiman.Long@hp.com,
        davidlohr@hp.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        riel@redhat.com, akpm@linux-foundation.org, hpa@zytor.com,
        tim.c.chen@linux.intel.com, konrad.wilk@oracle.com, aswin@hp.com,
        scott.norton@hp.com, chegu_vinod@hp.com
Date: Tue, 08 Jul 2014 09:44:30 -0700
In-Reply-To: <20140708093826.32a734f3@gandalf.local.home>
References: <1404759019-4268-1-git-send-email-jason.low2@hp.com>
	 <1404759019-4268-3-git-send-email-jason.low2@hp.com>
	 <20140708093826.32a734f3@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-08 at 09:38 -0400, Steven Rostedt wrote:
> On Mon,  7 Jul 2014 11:50:17 -0700
> Jason Low <jason.low2@hp.com> wrote:

> >  #ifdef CONFIG_RWSEM_GENERIC_SPINLOCK
> > @@ -33,7 +32,7 @@ struct rw_semaphore {
> >  	 * if the owner is running on the cpu.
> >  	 */
> >  	struct task_struct *owner;
> > -	struct optimistic_spin_node *osq; /* spinner MCS lock */
> > +	struct optimistic_spin_queue osq; /* spinner MCS lock */
> >  #endif
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  	struct lockdep_map	dep_map;
> > @@ -70,7 +69,7 @@ static inline int rwsem_is_locked(struct rw_semaphore *sem)
> >  	  __RAW_SPIN_LOCK_UNLOCKED(name.wait_lock),	\
> >  	  LIST_HEAD_INIT((name).wait_list),		\
> >  	  NULL, /* owner */				\
> > -	  NULL /* mcs lock */                           \
> > +	  { ATOMIC_INIT(OSQ_UNLOCKED_VAL) } /* osq */   \
> 
> This should probably be a macro, similar to the __RWSEM_DEP_MAP_INIT()
> below.  Open coded inits are evil.
> 
>   OSQ_LOCK_INIT() ?

I agree that we should use a macro here for the lock instead of directly
initializing it. Same with using a macro instead of directly calling the
atomic_sets in the later parts of this patch.

> 
> >  	  __RWSEM_DEP_MAP_INIT(name) }
> >  #else
> >  #define __RWSEM_INITIALIZER(name)			\
> > diff --git a/kernel/locking/mcs_spinlock.c b/kernel/locking/mcs_spinlock.c
> > index e9866f7..124a3bb 100644
> > --- a/kernel/locking/mcs_spinlock.c
> > +++ b/kernel/locking/mcs_spinlock.c
> > @@ -17,18 +17,43 @@
> >  static DEFINE_PER_CPU_SHARED_ALIGNED(struct optimistic_spin_node, osq_node);
> >  
> >  /*
> > + * We use the value 0 to represent "no CPU", thus the encoded value
> > + * will be the CPU number incremented by 1.
> > + */
> > +static inline int encode_cpu(int cpu_nr)
> > +{
> > +	return (cpu_nr + 1);
> 
> return is not a function, remove the parenthesis (checkpatch should
> point that out to you too).

I ran checkpatch and it didn't seem to be an issue. I was using the
parenthesis as "operator precedence" rather than a function call.
However, those parenthesis aren't necessary so we can delete them
anyway.

> > +}
> > +
> > +static inline struct optimistic_spin_node *decode_cpu(int encoded_cpu_val)
> > +{
> > +	int cpu_nr = encoded_cpu_val - 1;
> > +
> > +	return per_cpu_ptr(&osq_node, cpu_nr);
> > +}
> > +
> > +/*
> >   * Get a stable @node->next pointer, either for unlock() or unqueue() purposes.
> >   * Can return NULL in case we were the last queued and we updated @lock instead.
> >   */
> >  static inline struct optimistic_spin_node *
> > -osq_wait_next(struct optimistic_spin_node **lock,
> > +osq_wait_next(struct optimistic_spin_queue *lock,
> >  	      struct optimistic_spin_node *node,
> >  	      struct optimistic_spin_node *prev)
> >  {
> >  	struct optimistic_spin_node *next = NULL;
> > +	int curr = encode_cpu(smp_processor_id()), old;
> 
> Add a second line for "int old". Having it after an initialization is
> weird and confusing.

Sure. Thanks!

