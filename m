Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaBZP04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 10:26:56 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46782 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaBZP0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 10:26:52 -0500
Date: Wed, 26 Feb 2014 07:26:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: akpm@linux-foundation.org, joe@perches.com, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Change task_struct->comm to use RCU.
Message-ID: <20140226152646.GI8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140207180647.5944fe3d.akpm@linux-foundation.org>
 <201402092327.JAD12489.QOLSFVMHJtFOOF@I-love.SAKURA.ne.jp>
 <201402102243.IEJ52676.JOFVMOQFOFSLtH@I-love.SAKURA.ne.jp>
 <201402172027.BFH81210.FJtOQOMLHFSVOF@I-love.SAKURA.ne.jp>
 <20140224235139.GH8264@linux.vnet.ibm.com>
 <201402262244.GDF65182.VOtFOHFJLOFSMQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201402262244.GDF65182.VOtFOHFJLOFSMQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022615-9332-0000-0000-0000033AF1E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 10:44:32PM +0900, Tetsuo Handa wrote:
> Thank you for reviewing, Paul.

No problem, but you do also need to address Lai Jiangshan's and
Peter Zijlstra's questions about the purpose of this patch.  I was
looking at it only from a "does it work?" viewpoint.

> Paul E. McKenney wrote:
> > > +/**
> > > + * set_task_comm - Change task_struct->comm with tracer and perf hooks called.
> > > + *
> > > + * @tsk: Pointer to "struct task_struct".
> > > + * @buf: New comm name.
> > > + *
> > > + * Returns nothing.
> > > + */
> > > +void set_task_comm(struct task_struct *tsk, char *buf)
> > > +{
> > > +	/*
> > > +	 * Question: Do we need to use task_lock()/task_unlock() ?
> > 
> > The have-memory path through do_set_task_comm() does tolerate multiple
> > CPUs concurrently setting the comm of a given task, but the no-memory
> > path does not.  I advise keeping the locking, at least unless/until
> > some workload is having lots of CPUs concurrently changing a given
> > task's comm.  For some good reason, I hasten to add!  ;-)
> > 
> That question meant whether trace_task_rename(tsk, buf) needs to be serialized
> by tsk->alloc_lock. If trace_task_rename(tsk, buf) doesn't need to be
> serialized by tsk->alloc_lock, we can remove task_lock()/task_unlock().

I was attempting ot answer that question.  ;-)

> > Another reason to get rid of the lock is to allow do_set_task_comm()
> > to sleep waiting for memory to become available, but not sure that
> > this is a good approach.
> 
> I used GFP_ATOMIC because I don't know whether there are callers that depend on
> "changing task->comm does not sleep", for until today "changing task->comm did
> not sleep".

OK...

> > > +void do_set_task_comm(struct task_struct *tsk, const char *buf)
> > > +{
> > > +	struct rcu_comm *comm;
> > > +
> > > +	comm = kmem_cache_zalloc(commname_cachep, GFP_ATOMIC | __GFP_NOWARN);
> > > +	if (likely(comm)) {
> > > +		atomic_set(&comm->usage, 1);
> > > +		strncpy(comm->name, buf, TASK_COMM_LEN - 1);
> > > +		smp_wmb(); /* Behave like rcu_assign_pointer(). */
> > > +		comm = xchg(&tsk->rcu_comm, comm);
> > 
> > The value-returning xchg() implies a full memory barrier, so the
> > smp_wmb() is not needed.
> > 
> I see.
> 
> > > +		put_commname(comm);
> > > +	} else {
> > > +		/*
> > > +		 * Memory allocation failed. We have to tolerate loss of
> > > +		 * consistency.
> > > +		 *
> > > +		 * Question 1: Do we want to reserve some amount of static
> > > +		 * "struct rcu_comm" arrays for use upon allocation failures?
> > > +		 *
> > > +		 * Question 2: Do we perfer unchanged comm name over
> > > +		 * overwritten comm name because comm name is copy-on-write ?
> > > +		 */
> > > +		WARN_ONCE(1, "Failed to allocate memory for comm name.\n");
> > > +		rcu_read_lock();
> > > +		do {
> > > +			comm = rcu_dereference(tsk->rcu_comm);
> > > +		} while (!atomic_read(&comm->usage));
> > 
> > So the idea here is to avoid races with someone who might be freeing
> > this same ->rcu_comm structure, right?  If we see a non-zero reference,
> > they might still free it, but that would be OK because we are in an
> > RCU read-side critical section, so it won't actually be freed until
> > we get done.  And our change is being overwritten by someone else's
> > in that case, but that is OK because it could happen anyway.
> > 
> Right.
> 
> > So the loop shouldn't go through many cycles, especially if memory
> > remains low.
> > 
> > If I am correct, might be worth a comment.  Doubly so if I am wrong.  ;-)
> > 
> You are correct.
> 
> What about Q1 and Q2, like below ?

I suggest reviewing the LKML thread that Peter Zijlstra pointed you at
before digging too much further into this.  Especially this one:

	https://lkml.org/lkml/2011/5/18/408

							Thanx, Paul

>   /* Usage is initialized with ATOMIC_INIT(-1). */
>   static struct rcu_comm static_rcu_comm[CONFIG_RESERVED_COMMBUFFER];
> 
>   static void free_commname(struct rcu_head *rcu)
>   {
>   	struct rcu_comm *comm = container_of(rcu, struct rcu_comm, rcu);
>   	if (comm < &static_rcu_comm[0] ||
>   	    comm >= &static_rcu_comm[CONFIG_RESERVED_COMMBUFFER])
>   		kmem_cache_free(commname_cachep, comm);
>   	else
>   		atomic_set(&comm->usage, -1);
>   }
> 
>   void do_set_task_comm(struct task_struct *tsk, const char *buf)
>   {
>   	struct rcu_comm *comm;
>   
>   	comm = kmem_cache_zalloc(commname_cachep, GFP_ATOMIC | __GFP_NOWARN);
>   	if (likely(comm))
>   		atomic_set(&comm->usage, 1);
>   	else {
>   		int i;
>   
>   		/* Memory allocation failed. Try static comm name buffer. */
>   		for (i = 0; i < CONFIG_RESERVED_COMMBUFFER; i++) {
>   			comm = &static_rcu_comm[i];
>   			if (atomic_read(&comm->usage) != -1)
>   				continue;
>   			if (atomic_add_return(&comm->usage, 2) == 1)
>   				goto found;
>   		  	put_commname(comm);
>   		  	put_commname(comm);
>   		}
>   		/* No comm name buffer available. Keep current comm name. */
>   		WARN_ONCE(1, "Failed to allocate memory for comm name.\n");
>   		return;
>   	}
>   found:
>   	strncpy(comm->name, buf, TASK_COMM_LEN - 1);
>   	comm = xchg(&tsk->rcu_comm, comm);
>   	put_commname(comm);
>   }
> 
> Since we can preallocate rcu_comm using GFP_KERNEL and return -ENOMEM (e.g.
> prepare_bprm_creds() for execve() case, copy_from_user() for prctl(PR_SET_NAME)
> and comm_write() (i.e. /proc/$pid/comm ) cases), there will be little users of
> static_rcu_comm[] (e.g. kthreadd()).
> 
> 
> > > @@ -1191,6 +1195,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
> > >  	p = dup_task_struct(current);
> > >  	if (!p)
> > >  		goto fork_out;
> > > +	rcu_read_lock();
> > > +	do {
> > > +		p->rcu_comm = rcu_dereference(current->rcu_comm);
> > > +	} while (!atomic_inc_not_zero(&p->rcu_comm->usage));
> > 
> > OK, loop until we get the sole reference on the comm...  But
> > I suggest an rcu_read_unlock() followed by an rcu_read_lock() as the
> > first thing in the loop.  Just to prevent adding an RCU CPU stall to
> > our woes if we cannot get a reference.
> > 
> I see. I will use
> 
>   p->rcu_comm = NULL;
>   do {
>   	struct rcu_comm *comm;
>   	rcu_read_lock();
>   	comm = rcu_dereference(current->rcu_comm);
>   	if (atomic_inc_not_zero(&comm->usage))
>   		p->rcu_comm = comm;
>   	rcu_read_unlock();
>   } while (!p->rcu_comm);
> 
> in the next version (if we use RCU approach).
> 
> > And here the two tasks (parent and child) share the name until one
> > or the other either changes its name or exits.  OK.
> > 
> Yes, this is copy on write approach.
> 
> Another approach could use heuristic atomicity; change from "char comm[16]"
> to "long comm[16/sizeof(long)]" and read/write using "long". By using "long",
> we can reduce the possibility of getting the mixture of current comm name and
> comm name to update to, for reading/writing of "long" is atomic.
> 
> The horizontal axis of below map is the strlen() of current comm name and the
> vertical axis is the strlen() of comm name to update to. If sizeof(long) == 8,
> 193 out of 256 patterns can be atomically updated without any locks. Moreover,
> since strlen() of at least one of current comm name and new comm name tends to
> be shorter than sizeof(long) (e.g. "bash" -> "ls", "rc.sysinit" -> "cat",
> "bash" -> "avahi-daemon" ), update of comm name will more likely be atomic
> without any locks.
> 
>     | 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
>   --+-----------------------------------------------
>    0| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    1| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    2| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    3| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    4| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    5| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    6| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    7| o  o  o  o  o  o  o  o  o  o  o  o  o  o  o  o
>    8| o  o  o  o  o  o  o  o  o  x  x  x  x  x  x  x
>    9| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
>   10| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
>   11| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
>   12| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
>   13| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
>   14| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
>   15| o  o  o  o  o  o  o  o  x  x  x  x  x  x  x  x
> 
> > > +	rcu_read_unlock();
> > > 
> > >  	ftrace_graph_init_task(p);
> > >  	get_seccomp_filter(p);
> 

