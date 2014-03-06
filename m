Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaCFOYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 09:24:36 -0500
Received: from mail.lang.hm ([64.81.33.126]:55249 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaCFOYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 09:24:33 -0500
Date: Thu, 6 Mar 2014 06:23:18 -0800 (PST)
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
In-Reply-To: <5317CDC4.8020908@oracle.com>
Message-ID: <alpine.DEB.2.02.1403060620350.32171@nftneq.ynat.uz>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <531641A8.40306@zytor.com> <53164824.3000704@oracle.com> <20140304222356.41c55bbc@alan.etchedpixels.co.uk> <5316574F.6040105@oracle.com> <alpine.DEB.2.02.1403050129570.18573@ionos.tec.linutronix.de>
 <8738ix5uyk.fsf@tassilo.jf.intel.com> <20140305145420.GA30173@redhat.com> <20140305155601.GF22728@two.firstfloor.org> <20140305163644.GA2824@redhat.com> <53175D54.1020804@oracle.com> <alpine.DEB.2.02.1403051506550.6682@nftneq.ynat.uz> <5317B7D5.2030403@oracle.com>
 <alpine.DEB.2.02.1403051555360.6682@nftneq.ynat.uz> <5317BE94.20703@oracle.com> <alpine.DEB.2.02.1403051631590.6682@nftneq.ynat.uz> <5317CDC4.8020908@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014, Khalid Aziz wrote:

> On 03/05/2014 05:36 PM, David Lang wrote:
>> Yes, you pay for two context switches, but you don't pay for threads
>> B..ZZZ all running (and potentially spinning) trying to aquire the lock
>> before thread A is able to complete it's work.
>> 
>
> Ah, great. We are converging now.
>
>> As soon as a second thread hits the contention, thread A gets time to
>> finish.
>
> Only as long as thread A could be scheduled immediately which may or may not 
> be the case depending upon what else is running on the core thread A last ran 
> on and if thread A needs to be migrated to another core.
>
>> 
>> It's not as 'good' [1] as thread A just working longer,
>
> and that is the exact spot where I am trying to improve performance.

well, you have said that the "give me more time" flag results in 3-5% better 
performance for databases under some workloads, how does this compare with the 
results of yield_to()?

I think that the two approaches are going to be very close. I'd lay good odds 
that the difference between the two is very hard to extract from the noise of 
the variation of different runs (I won't say statistically insignificant, but I 
will say that I expect it to take a lot of statistical analysis to pull it out 
of the clutter)

David Lang

>> but it's FAR
>> better than thread A sleeping while every other thread runs and
>> potentially tries to get the lock
>
> Absolutely. I agree with that.
>
>> 
>> [1] it wastes the context switches, but it avoids the overhead of
>> figuring out if the thread needs to extend it's time, and if it's time
>> was actually extended, and what penalty it should suffer the next time
>> it runs....
>
> All of it can be done by setting and checking couple of flags in task_struct. 
> That is not insignificant, but hardly expensive. Logic is quite simple:
>
> resched()
> {
> 	........
> 	if (immmunity) {
> 		if (!penalty) {
> 			immunity = 0;
> 			penalty = 1;
> 			-- skip context switch --
> 		}
> 		else {
> 			immunity = penalty = 0;
> 			-- do the context switch --
> 		}
> 	}
> 	.........
> }
>
> sched_yield()
> {
> 	......
> 	penalty = 0;
> 	......
> }
>
> This simple logic will also work to defeat the obnoxius threads that keep 
> setting immunity request flag repeatedly within the same critical section to 
> give themselves multiple extensions.
>
> Thanks,
> Khalid
>
