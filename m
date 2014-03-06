Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaCFQJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:09:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44379 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaCFQJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:09:52 -0500
Message-ID: <53189D92.8080404@oracle.com>
Date: Thu, 06 Mar 2014 09:08:50 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305111006.GT9987@twins.programming.kicks-ass.net> <531781E5.8010000@oracle.com> <20140306095742.GI9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140306095742.GI9987@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2014 02:57 AM, Peter Zijlstra wrote:
> On Wed, Mar 05, 2014 at 12:58:29PM -0700, Khalid Aziz wrote:
>> Looking at the current problem I am trying to
>> solve with databases and JVM, I run into the same issue I described in my
>> earlier email. Proxy execution is a post-contention solution. By the time
>> proxy execution can do something for my case, I have already paid the price
>> of contention and a context switch which is what I am trying to avoid. For a
>> critical section that is very short compared to the size of execution
>> thread, which is the case I am looking at, avoiding preemption in the middle
>> of that short critical section helps much more than dealing with lock
>> contention later on.
>
> Like others have already stated; its likely still cheaper than the
> pile-up you get now. It might not be optimally fast, but it sure takes
> out the worst case you have now.
>
>> The goal here is to avoid lock contention and
>> associated cost. I do understand the cost of dealing with lock contention
>> poorly and that can easily be much bigger cost, but I am looking into
>> avoiding even getting there.
>
> The thing is; unless userspace is a RT program or practises the same
> discipline in such an extend as that it make no practical difference,
> there's always going to be the case where you fail to cover the entire
> critical section, at which point you're back to your pile-up fail.
>
> So while the limited preemption guard helps the best cast, it doesn't
> help the worst case at all.

That is true. I am breaking this problem into two parts - (1) avoid pile 
up, (2) if pile up happens, deal with it efficiently. Worst case 
scenario you point out is the second part of the problem. Solutions for 
that can be PTHREAD_PRIO_PROTECT protocol for the threads that use POSIX 
threads or proxy execution. Once pile up has happened, cost of a system 
call to boost thread priority becomes much smaller part of overall cost 
of handling the pile up.

Part (1) of this problem is what my patch attempts to solve. Here the 
cost of system call to boost priority or do anything else is too high. 
The mechanism to avoid pile up has to be very light weight to be of any use.

>
> So supposing we went with this now; you (or someone else) will come back
> in a year's time and tell us that if we only just stretch this window a
> little, their favourite workload will also benefit.
>
> Where's the end of that?
>
> And what about CONFIG_HZ; suppose you compile your kernel with HZ=100
> and your 1 extra tick is sufficient. Then someone compiles their kernel
> with HZ=1000 and it all comes apart.
>
>

My goal here is to help the cases where critical section is short and 
executes quickly as it should be for well designed critical sections in 
threads that want to run using CFS. I see this as an incremental 
improvement over current situation. With CFS, timeslice is adaptive and 
depends upon the workload, so it is not directly tied to CONFIG_HZ. But 
you are right, CONFIG_HZ does have a bearing on this. I see a critical 
section that can easily go over a single timeslice and cause a pile up, 
as a workload designed to create these problems. Such a workload needs 
to use SCHED_FIFO or the deadline scheduler with properly designed yield 
points and priorities, or live with the pile ups caused by using CFS. 
Trying to help such cases with CFS is not beneficial and will cause CFS 
to become more and more complex. What I am trying to do is help the 
cases where a short critical section ends up being pre-empted simply 
because the execution reached critical section only towards the end of 
current timeslice and resulted in an unintended pile up. So give these 
cases a tool to avoid pile ups but use of the tool comes with 
restrictions (yield the processor as soon as you can if you got amnesty, 
and pay a penalty if you don't). At this point, the two workloads I know 
of that fit this group are databases and JVM both of which are in 
significant use.

Makes sense?

Thanks,
Khalid
