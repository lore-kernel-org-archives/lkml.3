Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587Ab3HPMKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:10:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753247Ab3HPMKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:10:48 -0400
Date: Fri, 16 Aug 2013 08:09:37 -0400
From: Jeff Layton <jlayton@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: David Howells <dhowells@redhat.com>, Bruce Fields <bfields@fieldses.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: memory barriers in flock (Re: [PATCH v3] locks: close potential
 race between setlease and open)
Message-ID: <20130816080937.3c7aef60@tlielax.poochiereds.net>
In-Reply-To: <20130815213106.GP29406@linux.vnet.ibm.com>
References: <20130815193203.GT17781@fieldses.org>
	<1373310444-25862-1-git-send-email-jlayton@redhat.com>
	<1376482310-7348-1-git-send-email-jlayton@redhat.com>
	<23198.1376599465@warthog.procyon.org.uk>
	<20130815213106.GP29406@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 14:31:06 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Thu, Aug 15, 2013 at 09:44:25PM +0100, David Howells wrote:
> > Bruce Fields <bfields@fieldses.org> wrote:
> > 
> > (Adding Paul McKenney who's good at this stuff)
> 
> Well, I should be able to provide a more refined form of confusion...
> 
> > > > v2:
> > > > - fix potential double-free of lease if second check finds conflict
> > > > - add smp_mb's to ensure that other CPUs see i_flock changes
> > > > 
> > > > v3:
> > > > - remove smp_mb calls. Partial ordering is unlikely to help here.
> > > 
> > > Forgive me here, I still don't understand.  So to simplify massively,
> > > the situation looks like:
> > >
> > > 	setlease		open
> > > 	------------		------
> > > 
> > > 	atomic_read		atomic_inc
> > > 	write i_flock		read i_flock
> > > 	atomic_read
> > 
> > Are the three atomic ops reading the same value?  If so, you can have smp_mb()
> > calls here:
> > 
> > 	atomic_read		atomic_inc
> > 				smp_mb()
> > 	write i_flock		read i_flock
> > 	smp_mb()
> >  	atomic_read
> 
> Yes, you need memory barrier of some form or another.  You can use
> smp_mb__after_atomic_inc() after the atomic_inc, which is lighter
> weight on x86.  Note that atomic_inc() does not return a value, and
> thus does not guarantee ordering of any sort.
> 
> > I *think* that memory accesses in one place need to be reverse-ordered wrt to
> > those in the other place, so:
> > 
> > 	atomic_read		atomic_inc
> > 	smp_mb()		smp_mb()
> > 	write i_flock		read i_flock
> >  	atomic_read
> > 
> > doesn't achieve anything.
> 
> The only thing that this arrangement could achive would be if the
> atomic_ operations are all accessing the same variable, in which case
> if the first CPU's last atomic_read preceded the atomic_inc, then
> we would know that the first CPU's first atomic_inc also preceded
> that same atomic_inc.
> 
> Let's add values and look at it a slightly different way:
> 
> 	CPU 0			CPU 1
> 
> 	r1 = atomic_read(&x);	atomic_inc(&x);
> 	smp_mb();		smp_mb__after_atomic_inc()
> 	i_flock = 1;		r3 = i_flock;
> 	r2 = atomic_read(&x);
> 
> Assume that the initial values of x and i_flock are zero.  (This might not
> make sense in the code, but you can substitute different values without
> changing the way this works.)
> 
> Then if r2==0, we know that r1==0 as well.  Of course, if there were other
> atomic_inc(&x) operations in flight, it might be that r1!=r2, but we
> would know that r1 got an earlier value of x than r2.  If x is 64 bits,
> then we know that r1<r2.
> 
> But as Dave points out, the placement of the memory barriers prevents
> us from drawing any similar conclusions about the accesses to i_flock.
> 
> So let's take a similar look at the initial arrangement:
> 
> 	CPU 0			CPU 1
> 
> 	r1 = atomic_read(&x);	atomic_inc(&x);
> 	i_flock = 1;		smp_mb__after_atomic_inc()
> 	smp_mb();		r3 = i_flock;
> 	r2 = atomic_read(&x);
> 
> Again, assume that the initial values of x and of i_flock are zero.
> Assume also that this is the only code that executes.  Then if r3==0, we
> know that r2>=1.  In fact, if r3==0, we know that r2==1.  The load from
> i_flock() had to have come before the store, and so the memory barriers
> guarantee that the load into r2 must see the results of the atomic_inc().
> 
> Similarly, if r2==0, we know that CPU 0's load into r2 came before
> CPU 1's atomic_inc().  The memory barriers then guarantee that CPU 0's
> store into i_flock precedes CPU 1's load from i_flock, so that r3==1.
> Cache coherence gives us another fact.  Both of CPU 0's atomic_read()s
> do volatile loads from the same variable, so they must happen in order
> (if they were not volatile, the compiler would be within its rights
> to interchange them).  Therefore, because CPU 0's atomic_read() into
> r2 precedes CPU 1's atomic_inc() -- recall that r2==0 -- we know that
> CPU 0's atomic_read() into r1 must also precede CPU 1's atomic_inc(),
> meaning that we know r1==0.
> 
> Reasoning about memory barriers takes this same form.  If something after
> memory barrier A can be proven to have happened before something that
> came before memory barrier B, then everything before memory barrier A
> must happen before everything after memory barrier B.  You carry out
> the proof by looking at loads and stores to a given variable.
> 
> This is a key point.  Memory barriers do nothing except for conditionally
> enforcing ordering.  They are not guaranteed to commit values to memory,
> to caches, or much of anything else.  Again, if you know that something
> following memory barrier A happened before something preceding memory
> barrier B, then you know that memory access preceding memory barrier A
> will be seen by a corresponding memory access following memory barrier B.
> 
> > > And we want to be sure that either the setlease caller sees the result
> > > of the atomic_inc, or the opener sees the result of the write to
> > > i_flock.
> > > 
> > > As an example, suppose the above steps happen in the order:
> > > 
> > > 	atomic_read [A]
> > > 	write i_flock [B]
> > > 	atomic_read [C]
> > > 				atomic_inc [X]
> > > 				read i_flock [Y]
> > 
> > (I've labelled the operations for convenience)
> > 
> > > How do we know that the read of i_flock [Y] at the last step reflects the
> > > latest value of i_flock?  For example, couldn't the write still be stuck in
> > > first CPU's cache?
> > 
> > Putting in memory barriers doesn't help here.  If A, B and C are all performed
> > and committed to memory by the time X happens, then Y will see B, but C will
> > not see X.
> 
> Indeed, you don't get both of these at once, except by accident.
> 
> > The thing to remember is that smp_mb() is not a commit operation: it doesn't
> > cause a modification to be committed to memory.  The reason you use it is to
> > make sure the CPU actually does preceding memory ops - eg. makes the
> > modification in question - before it goes and does any following memory ops.
> > 
> > Linux requires the system to be cache-coherent, so if the write is actually
> > performed by a CPU then the result will be obtained by any other CPU, no
> > matter whether it's still lingering in the first CPU's caches or whether it's
> > been passed on.
> 
> Or some later result, but yes.  Again, these accesses must be volatile
> (as in either atomic_read() or ACCESS_ONCE()), or the compiler is within
> its rights to do all sorts of mischief.
> 
> > -*-
> > 
> > However, I could be wrong.  Memory barriers are mind-bending to try and think
> > through, especially when it's the operations being ordered are R-W vs R-W
> > rather than having W-W on at least one side.
> 
> There are 16 combinations, all of which do something.  Some cases require
> an external store to prove anything, though.  For example:
> 
> 	CPU 0: r1 = ACCESS_ONCE(x); smp_mb(); r2 = ACCESS_ONCE(y);
> 	CPU 1: r3 = ACCESS_ONCE(y); smp_mb(); r4 = ACCESS_ONCE(x);
> 	CPU 2: ACCESS_ONCE(x) = 1;
> 	CPU 3: ACCESS_ONCE(y) = 1;
> 
> Here, we know that if r2==0&&r3==1, then it is impossible to also have
> r4==0&&r1==1.  Similarly, if r4==0&&r1==1, then it is impossible to also
> have r2==0&&r3==1.  If there were no stores, then of course the reads
> could not tell you anything about the ordering.
> 
> > Hopefully Paul will be able to chime in
> 
> Careful what you wish for!  ;-)
> 
> 							Thanx, Paul
> 

Wow! Thanks for the excellent writeup. I think I'm starting to get it...

In this case the issue is the manipulation of the inode->i_flock list
(which is a simple single-pointer linked list) vs. manipulation of
various refcounts on dentries and inodes.

The most problematic refcount is probably the inode->i_writecount,
which is an atomic_t. The others involve incrementing the
dentry->d_count somewhere, and that's always done under a spinlock
which should imply a memory barrier.

In the open codepath, the i_writecount is incremented by
__get_file_write_access. We need to ensure that that increment is done
prior to checking !inode->i_flock. do_dentry_open does take at least
one spinlock in between those points in file_sb_list_add(). That should
be enough to enforce ordering there.

In the setlease codepath, we need to ensure that the inode->i_flock
store is done before checking the refcounts a second time. That store
is done prior to locks_insert_global_locks, which takes a spinlock too,
so that should enforce the ordering there.

So, I think this patch should close the race. That said, it might not
hurt to add back in some explicit memory barriers in the event that
later code changes remove or move around the implicit ones.

I'll spin up a v4 patch that does that, but it'll probably look very
similar to the v2 one.

Thanks for all the help!
-- 
Jeff Layton <jlayton@redhat.com>
