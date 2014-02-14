Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaBNSt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 13:49:56 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:48259 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaBNStz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 13:49:55 -0500
Message-ID: <52FE64FA.6040803@hp.com>
Date: Fri, 14 Feb 2014 13:48:26 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 7/8] locking: Introduce qrwlock
References: <20140210195820.834693028@infradead.org> <20140210203659.796912337@infradead.org> <52FA6941.4060102@hp.com> <52FA844B.7070003@hp.com> <20140213163546.GF6835@laptop.programming.kicks-ass.net>
In-Reply-To: <20140213163546.GF6835@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 11:35 AM, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 03:12:59PM -0500, Waiman Long wrote:
>> Using the same locktest program to repetitively take a single rwlock with
>> programmable number of threads and count their execution times. Each
>> thread takes the lock 5M times on a 4-socket 40-core Westmere-EX
>> system. I bound all the threads to different CPUs with the following
>> 3 configurations:
>>
>>   1) Both CPUs and lock are in the same node
>>   2) CPUs and lock are in different nodes
>>   3) Half of the CPUs are in same node as the lock&  the other half
>>      are remote
> I can't find these configurations in the below numbers; esp the first is
> interesting because most computers out there have no nodes.

I have a local and remote number in the measurement data that I sent 
out. The local ones are when both CPUs and lock are in the same node. 
The remote is when they are in different nodes.

>> Two types of qrwlock are tested:
>>   1) Use MCS lock
>>   2) Use ticket lock
> arch_spinlock_t; you forget that if you change that to an MCS style lock
> this one goes along for free.

Yes, I am aware of that. I am not saying that it is a bad idea to use 
arch_spin_t.  I will be happy if your version of qrwlock patch get 
merged. I am just saying that it maybe a better idea to use MCS lock 
directly especially in case that the spinlock is not converted to use a 
MCS-style lock. I will be more happy if that happen.


>
> On that; I had a look at your qspinlock and got a massive head-ache so I
> rewrote it. Aside from being very mess code it also suffered from a few
> fairness issues in that it is possible (albeit highly unlikely) to steal
> a lock instead of being properly queued; per your xchg() usage.
>
> The below boots; but I've not done much else with it, so it will
> probably explode in your face.

Thank for looking into my qspinlock patch. I will take a look at your 
changes and incorporate it to make it more fair. I have already 
rewritten it along the same line your version of the qrwlock patch. I 
have done some performance testing at low contention level using my 
microbenchmark. The qspinlock was indeed slower than ticket lock with 
2-4 contending tasks. The break-even point is at 5 contending tasks. To 
fix this performance deficit, I added an optimized x86 specific 
contention path for 2 contending tasks so that it would perform better 
than the ticket lock. It will still be somewhat slower for 3-4 
contending tasks, but the 2 contending task case is probably the most 
common.

With that change, I would say that my qspinlock patch should be good 
enough as a replacement of ticket spinlock for x86. I will send out an 
updated qspinlock patch in a day or two when I finish my testing.

-Longman
