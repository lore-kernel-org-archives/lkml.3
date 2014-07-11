Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaGKJw1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:52:27 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51601 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaGKJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:52:24 -0400
Date: Fri, 11 Jul 2014 02:43:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/1] rcu: use atomic_read(v) instead of
 atomic_add_return(0, v)
Message-ID: <20140711094333.GG16041@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1404860145-16450-1-git-send-email-bobby.prani@gmail.com>
 <20140709000701.GJ4603@linux.vnet.ibm.com>
 <CAJhHMCBS2y_f28UO6SOp7LjnX3owm+C5_qCjzYANEaU__8jxng@mail.gmail.com>
 <20140709195650.GZ4603@linux.vnet.ibm.com>
 <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCCO9aR6YvVHnc7XFXGv1REW5tGtNqSEosf+x+8O=tVy3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071109-6688-0000-0000-00000336EAA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 09:17:33PM -0400, Pranith Kumar wrote:
> On Wed, Jul 9, 2014 at 3:56 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> <snip>
> > OK, so ->dynticks_snap is accessed by only one task, namely the
> > corresponding RCU grace-period kthread.  So it can be accessed without
> > any atomic instructions or memory barriers, since all accesses to it are
> > single-threaded.  On the other hand, ->dynticks is written by one CPU
> > and potentially accessed from any CPU.  Therefore, accesses to it must
> > take concurrency into account.  Especially given that any confusion can
> > fool RCU into thinking that a CPU is idle when it really is not, which
> > could result in too-short grace periods, which could in turn result in
> > random memory corruption.
> 
> Yes, I missed reading the call-chain for accessing dynticks_snap. It
> does not need any synchronization/barriers.
> 
> Here since we are reading ->dynticks, doesn't having one barrier
> before reading make sense? like
> 
> smp_mb();
> dynticks_snap = atomic_read(...->dynticks);
> 
> instead of having two barriers with atomic_add_return()? i.e.,
> why is the second barrier necessary?

I suggest looking at the docbook comment headers for call_rcu() and
synchronize_rcu() and thinking about the memory-barrier guarantees.
Those guarantees are quite strong, and so if you remove any one of a
large number of memory barriers (either explicit or, as in this case,
implicit in some other operation), you will break RCU.

Now, there might well be some redundant memory barriers somewhere in
RCU, but the second memory barrier implied by this atomic_add_return()
most certainly is not one of them.

> On a related note, I see that dynticks is a per-cpu variable _and_
> atomic. Is there such a need for that?
> 
> Digging into history I see that the change to an atomic variable was
> made in the commit 23b5c8fa01b723c70a which says:
> 
> <quote>
> 
> In addition, the old dyntick-idle synchronization depended on the fact
> that grace periods were many milliseconds in duration, so that it could
> be assumed that no dyntick-idle CPU could reorder a memory reference
> across an entire grace period.  Unfortunately for this design, the
> addition of expedited grace periods breaks this assumption, which has
> the unfortunate side-effect of requiring atomic operations in the
> functions that track dyntick-idle state for RCU.
> 
> </quote>
> 
> Sorry to ask you about such an old change. But I am not able to see
> why we need atomic_t for dynticks here since per-cpu operations are
> guaranteed to be atomic.

Per-CPU operations are guaranteed to be atomic?  When one CPU is accessing
another CPU's per-CPU variable, as is the case here?  Can't say that I
believe you.  ;-)

> It gets twisted pretty fast trying to understand the RCU code. No
> wonder people say that rcu is scary black magic :)

Well, let's just say that this isn't one of the parts of the RCU code
that should be randomly hacked.  Lots and lots of ways to get it wrong,
and very few ways to get it right.  And most of the ways of getting it
right are too slow or too non-scalable to be useful.

Speaking of portions of RCU that are more susceptible to local-knowledge
hacking, how are things going on that rcutorture printing fixup?

							Thanx, Paul

