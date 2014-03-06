Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaCFLPR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 06:15:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:52393 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaCFLPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 06:15:15 -0500
Date: Thu, 6 Mar 2014 12:14:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Khalid Aziz <khalid.aziz@oracle.com>
cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
In-Reply-To: <531781E5.8010000@oracle.com>
Message-ID: <alpine.DEB.2.02.1403052301160.18573@ionos.tec.linutronix.de>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305111006.GT9987@twins.programming.kicks-ass.net> <531781E5.8010000@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Khalid Aziz wrote:
> On 03/05/2014 04:10 AM, Peter Zijlstra wrote:
> > On Tue, Mar 04, 2014 at 04:51:15PM -0800, Andi Kleen wrote:
> > > Anything else?
> > 
> > Proxy execution; its a form of PI that works for arbitrary scheduling
> > policies (thus also very much including fair).
> > 
> > With that what you effectively end up with is the lock holder running
> > 'boosted' by the runtime of its blocked chain until the entire chain
> > runs out of time, at which point preemption doesn't matter anyhow.
> > 
> 
> Hello Peter,
> 
> I read through the concept of proxy execution and it is a very interesting
> concept. I come from many years of realtime and embeddded systems development
> and I can easily recall various problems in the past that can be solved or
> helped by this. Looking at the current problem I am trying to solve with
> databases and JVM, I run into the same issue I described in my earlier email.
> Proxy execution is a post-contention solution. By the time proxy execution can
> do something for my case, I have already paid the price of contention and a
> context switch which is what I am trying to avoid. For a critical section that
> is very short compared to the size of execution thread, which is the case I am
> looking at, avoiding preemption in the middle of that short critical section
> helps much more than dealing with lock contention later on. The goal here is
> to avoid lock contention and associated cost. I do understand the cost of
> dealing with lock contention poorly and that can easily be much bigger cost,
> but I am looking into avoiding even getting there.

We understand that you want to avoid preemption in the first place and
not getting into the contention handling case.

But, what you're trying to do is essentially creating an ABI which we
have to support and maintain forever. And that definitely is worth a
few serious questions.

Lets ignore the mm related issues for now as those can be solved. That's
the least of my worries.

Right now you are using this for a single use case with a well defined
environment, where all related threads reside in the same scheduling
class (FAIR). But that's one of a gazillion of use cases of Linux.

If we allow you to special case your database workload then we have no
argument why we should not do the same thing for realtime workloads
where the SCHED_FAIR housekeeping thread can hold a lock shortly to
access some important data in the SCHED_FIFO realtime computation
thread. Of course the RT people want to avoid the lock contention as
much as you do, just for different reasons.

Add SCHED_EDF, cgroups and hierarchical scheduling to the picture and
hell breaks lose.

Why? Simply because you applied the everything is a nail therefor I
use a hammer approach. Understandable because in your case (data base
workload) almost everything is the same nail.

Thanks,

	tglx








      

