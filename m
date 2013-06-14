Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3FNXtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:49:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47712 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3FNXty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:49:54 -0400
Date: Fri, 14 Jun 2013 16:49:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Lai Jiangshan <eag0628@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org, walken@google.com, waiman.long@hp.com,
        davidlohr.bueso@hp.com
Subject: Re: [PATCH RFC ticketlock] v3 Auto-queued ticketlock
Message-ID: <20130614234947.GS5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <20130611170249.GA1091@linux.vnet.ibm.com>
 <20130612154008.GA9714@linux.vnet.ibm.com>
 <51B934AD.1070807@cn.fujitsu.com>
 <20130613152238.GB5146@linux.vnet.ibm.com>
 <CACvQF52F57Ac17oNjfD0wMoV26csbRDPRWSQd5OYRXFUQSs01Q@mail.gmail.com>
 <20130613235741.GI5146@linux.vnet.ibm.com>
 <51BA71B0.2070609@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA71B0.2070609@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061423-4834-0000-0000-000008149939
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 09:28:16AM +0800, Lai Jiangshan wrote:
> On 06/14/2013 07:57 AM, Paul E. McKenney wrote:
> > On Fri, Jun 14, 2013 at 07:25:57AM +0800, Lai Jiangshan wrote:
> >> On Thu, Jun 13, 2013 at 11:22 PM, Paul E. McKenney
> >> <paulmck@linux.vnet.ibm.com> wrote:
> >>> On Thu, Jun 13, 2013 at 10:55:41AM +0800, Lai Jiangshan wrote:
> >>>> On 06/12/2013 11:40 PM, Paul E. McKenney wrote:
> >>>>> Breaking up locks is better than implementing high-contention locks, but
> >>>>> if we must have high-contention locks, why not make them automatically
> >>>>> switch between light-weight ticket locks at low contention and queued
> >>>>> locks at high contention?  After all, this would remove the need for
> >>>>> the developer to predict which locks will be highly contended.
> >>>>>
> >>>>> This commit allows ticket locks to automatically switch between pure
> >>>>> ticketlock and queued-lock operation as needed.  If too many CPUs are
> >>>>> spinning on a given ticket lock, a queue structure will be allocated
> >>>>> and the lock will switch to queued-lock operation.  When the lock becomes
> >>>>> free, it will switch back into ticketlock operation.  The low-order bit
> >>>>> of the head counter is used to indicate that the lock is in queued mode,
> >>>>> which forces an unconditional mismatch between the head and tail counters.
> >>>>> This approach means that the common-case code path under conditions of
> >>>>> low contention is very nearly that of a plain ticket lock.
> >>>>>
> >>>>> A fixed number of queueing structures is statically allocated in an
> >>>>> array.  The ticket-lock address is used to hash into an initial element,
> >>>>> but if that element is already in use, it moves to the next element.  If
> >>>>> the entire array is already in use, continue to spin in ticket mode.
> >>>>>
> >>>>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>>>> [ paulmck: Eliminate duplicate code and update comments (Steven Rostedt). ]
> >>>>> [ paulmck: Address Eric Dumazet review feedback. ]
> >>>>> [ paulmck: Use Lai Jiangshan idea to eliminate smp_mb(). ]
> >>>>> [ paulmck: Expand ->head_tkt from s32 to s64 (Waiman Long). ]
> >>>>> [ paulmck: Move cpu_relax() to main spin loop (Steven Rostedt). ]
> >>>>> [ paulmck: Reduce queue-switch contention (Waiman Long). ]
> >>>>> [ paulmck: __TKT_SPIN_INC for __ticket_spin_trylock() (Steffen Persvold). ]
> >>>>> [ paulmck: Type safety fixes (Steven Rostedt). ]
> >>>>> [ paulmck: Pre-check cmpxchg() value (Waiman Long). ]
> >>>>> [ paulmck: smp_mb() downgrade to smp_wmb() (Lai Jiangshan). ]
> >>>>
> >>>>
> >>>> Hi, Paul,
> >>>>
> >>>> I simplify the code and remove the search by encoding the index of struct tkt_q_head
> >>>> into lock->tickets.head.
> >>>>
> >>>> A) lock->tickets.head(when queued-lock):
> >>>> ---------------------------------
> >>>>  index of struct tkt_q_head |0|1|
> >>>> ---------------------------------
> >>>
> >>> Interesting approach!  It might reduce queued-mode overhead a bit in
> >>> some cases, though I bet that in the common case the first queue element
> >>> examined is the right one.  More on this below.
> >>>
> >>>> The bit0 = 1 for queued, and the bit1 = 0 is reserved for __ticket_spin_unlock(),
> >>>> thus __ticket_spin_unlock() will not change the higher bits of lock->tickets.head.
> >>>>
> >>>> B) tqhp->head is for the real value of lock->tickets.head.
> >>>> if the last bit of tqhp->head is 1, it means it is the head ticket when started queuing.
> >>>
> >>> But don't you also need the xadd() in __ticket_spin_unlock() to become
> >>> a cmpxchg() for this to work?  Or is your patch missing your changes to
> >>> arch/x86/include/asm/spinlock.h?  Either way, this is likely to increase
> >>> the no-contention overhead, which might be counterproductive.  Wouldn't
> >>> hurt to get measurements, though.
> >>
> >> No, don't need to change __ticket_spin_unlock() in my idea.
> >> bit1 in the  tickets.head is reserved for __ticket_spin_unlock(),
> >> __ticket_spin_unlock() only changes the bit1, it will not change
> >> the higher bits. tkt_q_do_wake() will restore the tickets.head.
> >>
> >> This approach avoids cmpxchg in __ticket_spin_unlock().
> > 
> > Ah, I did miss that.  But doesn't the adjustment in __ticket_spin_lock()
> > need to be atomic in order to handle concurrent invocations of
> > __ticket_spin_lock()?
> 
> I don't understand, do we just discuss about __ticket_spin_unlock() only?
> Or does my suggestion hurt __ticket_spin_lock()?

On many architectures, it is harmless.  But my concern is that
__ticket_spin_lock() is atomically incrementing the full value
(both head and tail), but in such a way as to never change the
value of head.  So in theory, a concurrent non-atomic store to
head should be OK, but it does make me quite nervous.

At the very least, it needs a comment saying why it is safe.

							Thanx, Paul

> > Either way, it would be good to see the performance effects of this.
> > 
> > 							Thanx, Paul
> 

