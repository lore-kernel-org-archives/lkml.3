Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaCFQdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:33:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23475 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaCFQdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:33:14 -0500
Message-ID: <5318A30B.4020702@oracle.com>
Date: Thu, 06 Mar 2014 09:32:11 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305111006.GT9987@twins.programming.kicks-ass.net> <531781E5.8010000@oracle.com> <alpine.DEB.2.02.1403052301160.18573@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1403052301160.18573@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 04:14 AM, Thomas Gleixner wrote:
> We understand that you want to avoid preemption in the first place and
> not getting into the contention handling case.
>
> But, what you're trying to do is essentially creating an ABI which we
> have to support and maintain forever. And that definitely is worth a
> few serious questions.

Fair enough. I agree a new ABI should not be created lightly.

>
> Lets ignore the mm related issues for now as those can be solved. That's
> the least of my worries.
>
> Right now you are using this for a single use case with a well defined
> environment, where all related threads reside in the same scheduling
> class (FAIR). But that's one of a gazillion of use cases of Linux.
>

Creating a new ABI for a single use case or a special case is something 
I would argue against as well. I am with you on that. I am stating that 
databases and JVM happen to be two real world examples of the scenario 
where CFS can cause convoying problem inadvertently for a well designed 
critical section that represents a small portion of overall execution 
thread, simply because of where in the current timeslice the critical 
section is hit. If there are other examples others have come across, I 
would love to hear it. If we can indeed say this is a very special case 
for an uncommon workload, I would completely agree with refusing to 
create a new ABI.

> If we allow you to special case your database workload then we have no
> argument why we should not do the same thing for realtime workloads
> where the SCHED_FAIR housekeeping thread can hold a lock shortly to
> access some important data in the SCHED_FIFO realtime computation
> thread. Of course the RT people want to avoid the lock contention as
> much as you do, just for different reasons.
>
> Add SCHED_EDF, cgroups and hierarchical scheduling to the picture and
> hell breaks lose.

Realtime and deadline scheduler policies are supposed to be higher 
priority than CFS. A thread running in CFS that can impact threads 
running with realtime policies is a bad thing, agreed? What I am 
proposing actually allows a thread running with CFS to get out of the 
way of threads running with realtime policies quicker. In your specific 
example, the SCHED_FAIR housekeeping thread gets a chance to get out of 
SCHED_FIFO threads' way by giving its critical section better chance to 
complete execution before causing a convoy problem and while its cache 
is hot by using the exact same mechanism I am proposing. The logic is 
not onerous. Thread asks for amnesty from one context switch if and only 
if rescheduling point happens in the middle of its timeslice. If 
rescheduling point does not occur during its critical section, the 
thread takes that request back and life goes on as if nothing changed. 
If rescheduling point happens in the middle of thread's critical 
section, it gets the amnesty but it yields the processor as soon as it 
is done with its critical section. Any thread that does not play nice 
gets penalized next time it wants immunity (as hpa suggested).

Thanks,
Khalid

