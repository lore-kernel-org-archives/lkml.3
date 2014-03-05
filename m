Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaCERXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:23:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41473 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaCERXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:23:31 -0500
Message-ID: <53175D54.1020804@oracle.com>
Date: Wed, 05 Mar 2014 10:22:28 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de> <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com>
In-Reply-To: <20140305163644.GA2824@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 09:36 AM, Oleg Nesterov wrote:
> On 03/05, Andi Kleen wrote:
>>
>> On Wed, Mar 05, 2014 at 03:54:20PM +0100, Oleg Nesterov wrote:
>>> On 03/04, Andi Kleen wrote:
>>>>
>>>> Anything else?
>>>
>>> Well, we have yield_to(). Perhaps sys_yield_to(lock_owner) can help.
>>> Or perhaps sys_futex() can do this if it knows the owner. Don't ask
>>> me what exactly I mean though ;)
>>
>> You mean yield_to() would extend the time slice?
>>
>> That would be the same as the mmap page, just with a syscall right?
>
> Not the same. Very roughly I meant something like
>
> 	my_lock()
> 	{
> 		if (!TRY_LOCK()) {
> 			yield_to(owner);
> 			LOCK();
> 		}
>
> 		owner = gettid();
> 	}
>
> But once again, I am not sure if this makes any sense.
>
> Oleg.
>

Trouble with that approach is by the time a thread finds out it can not 
acquire the lock because someone else has it, we have already paid the 
price of context switch. What I am trying to do is to avoid that cost. I 
looked into a few other approaches to solving this problem without 
making kernel changes:

- Use PTHREAD_PRIO_PROTECT protocol to boost the priority of thread that 
holds the lock to minimize contention and CPU cycles wasted by other 
threads only to find out someone already has the lock. Problem I ran 
into is the implementation of PTHREAD_PRIO_PROTECT requires another 
system call, sched_setscheduler(), inside the library to boost priority. 
Now I have added the overhead of a new system call which easily 
outweighs any performance gains from removing lock contention. Besides 
databases implement their own spinlocks to maximize performance and thus 
can not use PTHREAD_PRIO_PROTECT in posix threads library.

- I looked into adaptive spinning futex work Darren Hart was working on. 
It looked very promising but I ran into the same problem again. It 
reduces the cost of contention by delaying context switches in cases 
where spinning is quicker but it still does not do anything to reduce 
the cost of context switch for a thread to get the CPU only to find out 
it can not get the lock. This cost again outweighs the 3%-5% benefit we 
are seeing from just not giving up CPU in the middle of critical section.

Makes sense?

--
Khalid
