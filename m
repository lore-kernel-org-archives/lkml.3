Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaBNTDQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 14:03:16 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:6328 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbaBNTDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 14:03:14 -0500
Message-ID: <52FE6817.5050708@hp.com>
Date: Fri, 14 Feb 2014 14:01:43 -0500
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
References: <20140210195820.834693028@infradead.org> <20140210203659.796912337@infradead.org> <52FA6941.4060102@hp.com> <52FA844B.7070003@hp.com> <20140213163546.GF6835@laptop.programming.kicks-ass.net> <20140213172657.GF3545@laptop.programming.kicks-ass.net>
In-Reply-To: <20140213172657.GF3545@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 12:26 PM, Peter Zijlstra wrote:
> On Thu, Feb 13, 2014 at 05:35:46PM +0100, Peter Zijlstra wrote:
>> On Tue, Feb 11, 2014 at 03:12:59PM -0500, Waiman Long wrote:
>>> Using the same locktest program to repetitively take a single rwlock with
>>> programmable number of threads and count their execution times. Each
>>> thread takes the lock 5M times on a 4-socket 40-core Westmere-EX
>>> system. I bound all the threads to different CPUs with the following
>>> 3 configurations:
>>>
>>>   1) Both CPUs and lock are in the same node
>>>   2) CPUs and lock are in different nodes
>>>   3) Half of the CPUs are in same node as the lock&  the other half
>>>      are remote
>> I can't find these configurations in the below numbers; esp the first is
>> interesting because most computers out there have no nodes.
>>
>>> Two types of qrwlock are tested:
>>>   1) Use MCS lock
>>>   2) Use ticket lock
>> arch_spinlock_t; you forget that if you change that to an MCS style lock
>> this one goes along for free.
> Furthermore; comparing the current rwlock to the ticket-rwlock already
> shows an improvement, so on that aspect its worth it as well.

As I said in my previous email, I am not against your change.

> And there's also the paravirt people to consider; a fair rwlock will
> make them unhappy; and I'm hoping that their current paravirt ticket
> stuff is sufficient to deal with the ticket-rwlock without them having
> to come and wreck things again.

Actually, my original qrwlock patch has an unfair option. With some 
minor change, it can be made unfair pretty easily. So we can use the 
paravirt config macro to change that to unfair if it is what the 
virtualization people want.

> Similarly; qspinlock needs paravirt support.
>
>

The current paravirt code has hard-coded the use of ticket spinlock. 
That is why I have to disable my qspinlock code if paravirt is enabled.

I have thinking about that paravirt support. Since the waiting tasks are 
queued up. By maintaining some kind of heart beat signal, it is possible 
to make the waiting task jump the queue if the previous one in the queue 
doesn't seem to be alive. I will work on that next once I am done with 
the current qspinlock patch.

-Longman
