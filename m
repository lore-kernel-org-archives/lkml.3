Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbaGVHr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:47:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:58947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:47:25 -0400
Date: Tue, 22 Jul 2014 09:47:19 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Robert Haas <robertmhaas@gmail.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
Message-ID: <20140722074719.GV3935@laptop>
References: <871tte3bjw.fsf@tassilo.jf.intel.com>
 <CFF29A00.9D44A%dvhart@linux.intel.com>
 <CFF29E4A.9D44E%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407212025130.20847@nanos>
 <20140721212740.GS3935@laptop>
 <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com>
 <alpine.DEB.2.10.1407212344130.20847@nanos>
 <CFF2E3D6.9D525%dvhart@linux.intel.com>
 <alpine.DEB.2.10.1407220047490.20847@nanos>
 <20140721213457.46623e2f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721213457.46623e2f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 09:34:57PM -0400, Steven Rostedt wrote:

> I just want to point out that I was having a very nice conversation
> with Robert Haas (Cc'd) in Napa Valley at Linux Collaboration about
> this very topic. Robert is a PostgeSQL developer who told me that they
> implement their spin locks completely in userspace (no futex, just raw
> spinning on shared memory). This is because the sleep on contention of a
> futex has shown to be very expensive in their benchmarks. His work is
> not a micro benchmark but for a very popular database where locking is
> crucial.

Userspace spinlocks are a clusterfuck. Its impossible to solve the
priority inversion trainwrecks they cause _ever_.

We've had -- as I think Mike already pointed out -- tons of 'fun' with
psql exactly because its doing this :-(

> I was telling Robert that if futexes get optimistic spinning, he should
> reconsider their use of userspace spinlocks in favor of this, because
> I'm pretty sure that they will see a great improvement.
> 
> Now Robert will be the best one to answer if the system call is indeed
> more expensive than doing full spins in userspace. If the spin is done
> in the kernel and they still get better performance by just spinning
> blindly in userspace even if the owner is asleep, I think we will have
> our answer.

No, the best way is to measure the exact syscall cost. If he still gets
better performance we need to analyze why, there might be something else
hiding there.

> Note, I believe they only care about shared threads, and this
> optimistic spinning does not need to be something done between
> processes.

There's no reason not to provide it for shared futexes, in fact I
suspect not doing it for shared futexes is going to make the code
uglier.


Anyway, there is one big fail in the entire futex stack that we 'need'
to sort some day and that is NUMA. Some people (again database people)
explicitly do not use futexes and instead use sysvsem because of this.

The problem with numa futexes is that because they're vaddr based there
is no (persistent) node information. You always end up having to fall
back to looking in all nodes before you can guarantee there is no
matching futex.

One way to achieve it is by extending the futex value to include a node
number, but that's obviously a complete ABI break. Then again, it should
be pretty straight fwd, since the node number doesn't need to be part of
the actual atomic update part, just part of the userspace storage.
