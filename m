Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3GRKWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:22:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:41862 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab3GRKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:22:21 -0400
Date: Thu, 18 Jul 2013 12:22:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock
 implementation
In-Reply-To: <51E49FA3.4030202@hp.com>
Message-ID: <alpine.DEB.2.02.1307181210330.4089@ionos.tec.linutronix.de>
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com> <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de> <51E49FA3.4030202@hp.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiman,

On Mon, 15 Jul 2013, Waiman Long wrote:
> On 07/15/2013 06:31 PM, Thomas Gleixner wrote:
> > On Fri, 12 Jul 2013, Waiman Long wrote:
> > > Apparently, the regular read/write lock performs even better than
> > > the queue read/write lock in some cases.  This is probably due to the
> > The regular rwlock performs better in most cases. This is the full
> > list comparing both against the ticket lock.
> > 
> >      qrlock  	   rwlock
> >      +20.7  	   +44.4
> >      +30.1  	   +42.9
> > 
> >      +56.3  	   +63.3
> >      +52.9  	   +48.8
> > 
> >      +54.4  	   +65.1
> >      +49.2  	   +26.5
> > 
> > So you try to sell that qrwlock as a replacement for ticket spinlocks,
> > while at the same time you omit the fact that we have an even better
> > implementation (except for the last test case) already in the
> > kernel. What's the point of this exercise?
> 
> The main point is that the regular rwlock is not fair while the
> queue rwlock is close to as fair as the ticket spinlock. The LWN
> article http://lwn.net/Articles/364583/ mentioned about eliminating
> rwlock altogether precisely because of this unfairness as it can
> cause livelock in certain scenerio. I also saw slides to advise
> again using rwlock because of this.

I'm well aware of this. But that does not explain anything of what I
asked.

> > > + * has the following advantages:
> > > + * 1. It is more deterministic. Even though there is a slight chance
> > > of
> > Why is it more deterministic than the existing implementation?
> 
> Deterministic means that that a process can acquire a lock within a
> reasonable time period without being starved for a long time. The qrwlock
> grants lock in FIFO order in most cases. That is what I mean by being more
> deterministic.

That's exactly the kind of explanation we want to have in the code and
the changelog.

> > 
> > > + *    stealing the lock if come at the right moment, the granting of
> > > the
> > > + *    lock is mostly in FIFO order.
> > > + * 2. It is faster in high contention situation.
> > Again, why is it faster?
> 
> The current rwlock implementation suffers from a thundering herd problem.
> When many readers are waiting for the lock hold by a writer, they will all
> jump in more or less at the same time when the writer releases the lock.
> That is not the case with qrwlock. It has been shown in many cases that
> avoiding this thundering herd problem can lead to better performance.

That makes sense and wants to be documented as well. You could have
avoided a lot of the discussion if you had included these details
right away.

> > > + * an increase in lock size is not an issue.
> > So is it faster in the general case or only for the high contention or
> > single thread operation cases?
> > 
> > And you still miss to explain WHY it is faster. Can you please explain
> > proper WHY it is faster and WHY we can't apply that technique you
> > implemented for qrwlocks to writer only locks (aka spinlocks) with a
> > smaller lock size?
> 
> I will try to collect more data to justify the usefulness of qrwlock.

And please provide a proper argument why we can't use the same
technique for spinlocks.

> > Aside of that, you are replacing all RW locks unconditionally by this
> > new fangled thing, but did you actually run tests which look at other
> > rwlock usage sites than the particular one you care about?
> 
> Users have the choice of using the old rwlock or the queue rwlock by
> selecting or unselecting the QUEUE_RWLOCK config parameter. I am not
> forcing the unconditional replacement of rwlock by qrwlock.

Looking at patch 2/2:

+config ARCH_QUEUE_RWLOCK
+       def_bool y

What's conditional about that? Where is the choice?

> > You are optimizing for the high frequency writer case. And that's not
> > the primary use case for rwlocks. That's the special use case for the
> > jbd2 journal_state_lock which CANNOT be generalized for all other
> > rwlock usage sites.
> 
> It is true that this lock is kind of optimized for writers. For
> reader heavy code, the performance may not be as good as the rwlock
> for uncontended cases. However, I do believe that the fairness
> attribute of the qrwlock far outweigh the slight performance
> overhead of read lock/unlock.  Furthermore, the lock/unlock sequence
> contributes only a very tiny percentage of total CPU time in
> uncontended cases. A slight increase may not really have a material
> impact on performance. Again, as promised, I will try to collect
> some more performance data for reader heavy usage cases.

Yes, please. We really need this information and if it turns out, that
it does not affect reader heavy sides, I have no objections against
the technology itself.

Thanks,

	tglx
