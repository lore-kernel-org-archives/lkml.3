Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaGVUxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:53:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:40507 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaGVUxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:53:08 -0400
Date: Tue, 22 Jul 2014 22:52:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Waiman Long <waiman.long@hp.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@kernel.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Scott J Norton <scott.norton@hp.com>,
        Robert Haas <robertmhaas@gmail.com>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
In-Reply-To: <53CEC8AC.7020700@hp.com>
Message-ID: <alpine.DEB.2.10.1407222243210.23352@nanos>
References: <CFF29E4A.9D44E%dvhart@linux.intel.com> <alpine.DEB.2.10.1407212025130.20847@nanos> <20140721212740.GS3935@laptop> <CALCETrXSaWM6-nxr4ggtMh5qcfTQg4wRvkW8FTSbri5+_1ZbVg@mail.gmail.com> <alpine.DEB.2.10.1407212344130.20847@nanos>
 <CFF2E3D6.9D525%dvhart@linux.intel.com> <alpine.DEB.2.10.1407220047490.20847@nanos> <20140721213457.46623e2f@gandalf.local.home> <20140722074719.GV3935@laptop> <alpine.DEB.2.10.1407221034260.20847@nanos> <20140722084842.GZ3935@laptop>
 <alpine.DEB.2.10.1407221057230.20847@nanos> <53CEC8AC.7020700@hp.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Waiman Long wrote:

> On 07/22/2014 05:59 AM, Thomas Gleixner wrote:
> > On Tue, 22 Jul 2014, Peter Zijlstra wrote:
> > > On Tue, Jul 22, 2014 at 10:39:17AM +0200, Thomas Gleixner wrote:
> > > > On Tue, 22 Jul 2014, Peter Zijlstra wrote:
> > > > > Anyway, there is one big fail in the entire futex stack that we 'need'
> > > > > to sort some day and that is NUMA. Some people (again database people)
> > > > > explicitly do not use futexes and instead use sysvsem because of this.
> > > > > 
> > > > > The problem with numa futexes is that because they're vaddr based
> > > > > there
> > > > > is no (persistent) node information. You always end up having to fall
> > > > > back to looking in all nodes before you can guarantee there is no
> > > > > matching futex.
> > > > > 
> > > > > One way to achieve it is by extending the futex value to include a
> > > > > node
> > > > > number, but that's obviously a complete ABI break. Then again, it
> > > > > should
> > > > > be pretty straight fwd, since the node number doesn't need to be part
> > > > > of
> > > > > the actual atomic update part, just part of the userspace storage.
> > > > So you want per node hash buckets, right? Fair enough, but how do you
> > > > make sure, that no thread/process on a different node is fiddling with
> > > > that "node bound" futex as well?
> > > You don't and that should work just as well, just slower. But since the
> > > node id is in the futex 'value' we'll always end up in the right
> > > node-hash, even if its a remote one.
> > > 
> > > So yes, per node hashes, and a persistent futex->node map.
> > Which works fine as long as you only have the futex_q on the stack of
> > the blocked task. If user space is lying to you, then you just end up
> > with a bunch of threads sleeping forever. Who cares?
> > 
> > But if you create independent kernel state, which we have with
> > pi_state and which you need for finegrained locking and further
> > spinning fun, you open up another can of worms. Simply because this
> > would enable rogue user space to create multiple instances of the
> > kernel internal state. I can predict the CVEs resulting from that
> > even without using a crystal ball.
> > 
> > Thanks,
> > 
> > 	tglx
> 
> I think NUMA futex, if implemented, is a completely independent piece that
> have no direct relationship with optimistic spinning futex. It should be a
> separate patch and not mixing with optimistic spinning patch which will only
> make the latter one more complicated.

Bullshit. Of course it handles separate issues, but Peter is
completely right, that the NUMA aspect is a far bigger issue than the
optimistic spinning stuff. Do you have an idea what the costs of cross
node memory access and cacheline bouncing are? Obviously not, as you
only interest seems to be to slap optimistic spinning to every place
which deals with locking.

And if you had tried to read _AND_ understand the discussion above,
you might have noticed that providing NUMA awareness requires a lot of
the functionality which is needed for optimistic spinning as well.

But no, you did not even take the time to think about it, you just
claim that it makes your optimistic stuff more complicated. Just get
it, there is a world outside of optimistic spinning.

Thanks,

	tglx
