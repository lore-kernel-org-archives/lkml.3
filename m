Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbaCEXQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:16:21 -0500
Received: from mail.lang.hm ([64.81.33.126]:60353 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbaCEXQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:16:20 -0500
Date: Wed, 5 Mar 2014 15:13:48 -0800 (PST)
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
In-Reply-To: <53175D54.1020804@oracle.com>
Message-ID: <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Khalid Aziz wrote:

> On 03/05/2014 09:36 AM, Oleg Nesterov wrote:
>> On 03/05, Andi Kleen wrote:
>>> 
>>> On Wed, Mar 05, 2014 at 03:54:20PM +0100, Oleg Nesterov wrote:
>>>> On 03/04, Andi Kleen wrote:
>>>>> 
>>>>> Anything else?
>>>> 
>>>> Well, we have yield_to(). Perhaps sys_yield_to(lock_owner) can help.
>>>> Or perhaps sys_futex() can do this if it knows the owner. Don't ask
>>>> me what exactly I mean though ;)
>>> 
>>> You mean yield_to() would extend the time slice?
>>> 
>>> That would be the same as the mmap page, just with a syscall right?
>> 
>> Not the same. Very roughly I meant something like
>>
>> 	my_lock()
>> 	{
>> 		if (!TRY_LOCK()) {
>> 			yield_to(owner);
>> 			LOCK();
>> 		}
>>
>> 		owner = gettid();
>> 	}
>> 
>> But once again, I am not sure if this makes any sense.
>> 
>> Oleg.
>> 
>
> Trouble with that approach is by the time a thread finds out it can not 
> acquire the lock because someone else has it, we have already paid the price 
> of context switch. What I am trying to do is to avoid that cost. I looked 
> into a few other approaches to solving this problem without making kernel 
> changes:

Yes, you have paid the cost of the context switch, but your original problem 
description talked about having multiple other threads trying to get the lock, 
then spinning trying to get the lock (wasting time if the process holding it is 
asleep, but not if it's running on another core) and causing a long delay before 
the process holding the lock gets a chance to run again.

Having the threads immediately yield to the process that has the lock reduces 
this down to two context switches, which isn't perfect, but it's a LOT better 
than what you started from.

> - Use PTHREAD_PRIO_PROTECT protocol to boost the priority of thread that 
> holds the lock to minimize contention and CPU cycles wasted by other threads 
> only to find out someone already has the lock. Problem I ran into is the 
> implementation of PTHREAD_PRIO_PROTECT requires another system call, 
> sched_setscheduler(), inside the library to boost priority. Now I have added 
> the overhead of a new system call which easily outweighs any performance 
> gains from removing lock contention. Besides databases implement their own 
> spinlocks to maximize performance and thus can not use PTHREAD_PRIO_PROTECT 
> in posix threads library.

well, writing to something in /proc isn't free either. And how is the thread 
supposed to know if it needs to do so or if it's going to have enough time to 
finish it's work before it's out of time (how can it know how much time it would 
have left anyway?)

> - I looked into adaptive spinning futex work Darren Hart was working on. It 
> looked very promising but I ran into the same problem again. It reduces the 
> cost of contention by delaying context switches in cases where spinning is 
> quicker but it still does not do anything to reduce the cost of context 
> switch for a thread to get the CPU only to find out it can not get the lock. 
> This cost again outweighs the 3%-5% benefit we are seeing from just not 
> giving up CPU in the middle of critical section.

is this gain from not giving up the CPU at all? or is it from avoiding all the 
delays due to the contending thread trying in turn? the yield_to() approach 
avoids all those other threads trying in turn so it should get fairly close to 
the same benefits.

David Lang
