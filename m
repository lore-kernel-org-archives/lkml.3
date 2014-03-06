Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbaCFAiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 19:38:17 -0500
Received: from mail.lang.hm ([64.81.33.126]:37954 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757260AbaCFAiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 19:38:16 -0500
Date: Wed, 5 Mar 2014 16:36:18 -0800 (PST)
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
In-Reply-To: <5317BE94.20703@oracle.com>
Message-ID: <alpine.DEB.2.02.1403051631590.6682@nftneq.ynat.uz>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz> <5317B7D5.2030403@oracle.com>
 <alpine.DEB.2.02.1403051555360.6682@nftneq.ynat.uz> <5317BE94.20703@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Khalid Aziz wrote:

> On 03/05/2014 04:59 PM, David Lang wrote:
>> what's the cost to setup mmap of this file in /proc. this is sounding
>> like a lot of work.
>
> That is a one time cost paid when a thread initializes itself.
>
>> 
>>>> is this gain from not giving up the CPU at all? or is it from avoiding
>>>> all the delays due to the contending thread trying in turn? the
>>>> yield_to() approach avoids all those other threads trying in turn so it
>>>> should get fairly close to the same benefits.
>>>> 
>>> 
>>> The gain is from avoiding contention by giving locking thread a chance
>>> to complete its critical section which is expected to be very short
>>> (certainly shorter than timeslice). Pre-emption immunity gives it one
>>> and only one additional timeslice.
>> 
>> but the yield_to() does almost the same thing, there is a small bump,
>> but you don't have to wait for thread B to spin, thread C..ZZZ etc to
>> spin before thread A can finish it's work. As soon as the second thread
>> hits the critical section, thread A is going to be able to do more work
>> (and hopefully finish)
>> 
>>> Hope this helps clear things up.
>> 
>> It doesn't sound like you and I are understanding how the yield_to()
>> approach would work. I hope my comments have helped get us on the same
>> page.
>> 
>
> I apologize if I am being dense. My understanding of yield_to() is what Oleg 
> had said in his reply earlier, so I will quote the example he gave:
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
> If thread A had already lost the processor by the time thread B executes 
> above code, wouldn't we have paid the price of two context switches for 
> thread A?

Yes, you pay for two context switches, but you don't pay for threads B..ZZZ all 
running (and potentially spinning) trying to aquire the lock before thread A is 
able to complete it's work.

As soon as a second thread hits the contention, thread A gets time to finish.

It's not as 'good' [1] as thread A just working longer, but it's FAR better than 
thread A sleeping while every other thread runs and potentially tries to get the 
lock

[1] it wastes the context switches, but it avoids the overhead of figuring out 
if the thread needs to extend it's time, and if it's time was actually extended, 
and what penalty it should suffer the next time it runs....

I expect that in practice, it will be very close to the 'theoretical ideal' of 
"I'm doing something important, don't interrupt me", without all the potential 
abuse of such a flag.

David Lang
