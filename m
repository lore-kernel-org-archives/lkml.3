Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbaCFABl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:01:41 -0500
Received: from mail.lang.hm ([64.81.33.126]:57636 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675AbaCFABj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:01:39 -0500
Date: Wed, 5 Mar 2014 15:59:42 -0800 (PST)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Khalid Aziz <khalid.aziz@oracle.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
In-Reply-To: <5317B7D5.2030403@oracle.com>
Message-ID: <alpine.DEB.2.02.1403051555360.6682@nftneq.ynat.uz>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz>
 <5317B7D5.2030403@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Khalid Aziz wrote:

> On 03/05/2014 04:13 PM, David Lang wrote:
>> Yes, you have paid the cost of the context switch, but your original
>> problem description talked about having multiple other threads trying to
>> get the lock, then spinning trying to get the lock (wasting time if the
>> process holding it is asleep, but not if it's running on another core)
>> and causing a long delay before the process holding the lock gets a
>> chance to run again.
>> 
>> Having the threads immediately yield to the process that has the lock
>> reduces this down to two context switches, which isn't perfect, but it's
>> a LOT better than what you started from.
>
> OK, let us consider the multiple core scenario:
>
> - Thread A gets scheduled on core 1, runs for 95% of its timeslice before it 
> gets to its critical section.
> - Thread A grabs the lock and quickly reaches the end of its timeslice before 
> finishing its critical section.
> - Thread A is preempted on core 1 by a completely unrelated thread.
> - Thread B in the mean time is scheduled on core 2 and happens to get to its 
> critical section right away where it tries to grab the lock held by thread A. 
> It spins for a bit waiting to see if lock becomes available, gives up and 
> yields to next process in queue.
> - Since thread A ran recently, it is now stuck towards the end of run queue, 
> so thread C gets to run on core 2 which goes through same fate as thread A.
>
> Now scale this scenario across more cores and more threads that all want the 
> same lock to execute their small critical section. This cost of spinning and 
> context switch could have been avoided if thread A could get additional 
> timeslice to complete its critical section. Yielding to the process holding 
> the lock happens only after contention has happened and we have paid the 
> price of two context switches for the lock owner. When yield_to() happens, 
> the lock owner may not get to run on the core it was on because an unrelated 
> thread is running on that core and it needs to wait for that thread's 
> timeslice to run out. If the lock owner gets scheduled on another core, we 
> pay the price of repopulating the cache for a new thread on that core. 
> yield_to() is better than having a convoy building up of processes waiting 
> for the same lock but worse than avoiding the contention altogether.

with yield_to(), when thread B hit the contention, thread A would get more time 
an be able to complete immediatly, so by the time thread C gets around to 
running, there is no longer any contention.

>> 
>> well, writing to something in /proc isn't free either. And how is the
>> thread supposed to know if it needs to do so or if it's going to have
>> enough time to finish it's work before it's out of time (how can it know
>> how much time it would have left anyway?)
>
> Cost is writing to a memory location since thread is using mmap, not 
> insignificant but hardly expensive. Thread does not need to know how much 
> time it has left in current timeslice. It always sets the flag to request 
> pre-emption immunity before entering the critical section and clears the flag 
> when it exits its critical section. If the thread comes up for pre-emption 
> while the flag is set, it gets immunity. If it does not, flag will be cleared 
> at the end of critical section any way.

what's the cost to setup mmap of this file in /proc. this is sounding like a lot 
of work.

>> is this gain from not giving up the CPU at all? or is it from avoiding
>> all the delays due to the contending thread trying in turn? the
>> yield_to() approach avoids all those other threads trying in turn so it
>> should get fairly close to the same benefits.
>> 
>
> The gain is from avoiding contention by giving locking thread a chance to 
> complete its critical section which is expected to be very short (certainly 
> shorter than timeslice). Pre-emption immunity gives it one and only one 
> additional timeslice.

but the yield_to() does almost the same thing, there is a small bump, but you 
don't have to wait for thread B to spin, thread C..ZZZ etc to spin before thread 
A can finish it's work. As soon as the second thread hits the critical section, 
thread A is going to be able to do more work (and hopefully finish)

> Hope this helps clear things up.

It doesn't sound like you and I are understanding how the yield_to() approach 
would work. I hope my comments have helped get us on the same page.

David Lang
