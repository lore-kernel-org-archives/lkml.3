Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaFRPqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:46:13 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:21899 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaFRPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:46:11 -0400
Message-ID: <53A1B43C.8000009@hp.com>
Date: Wed, 18 Jun 2014 11:46:04 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@linutronix.de,
        mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 04/11] qspinlock: Extract out the exchange of tail code
 word
References: <20140615124657.264658593@chello.nl> <20140615130153.376621956@chello.nl> <20140617205525.GB29634@laptop.dumpdata.com> <53A17A09.6010007@redhat.com> <20140618135057.GB4729@laptop.dumpdata.com>
In-Reply-To: <20140618135057.GB4729@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 09:50 AM, Konrad Rzeszutek Wilk wrote:
> On Wed, Jun 18, 2014 at 01:37:45PM +0200, Paolo Bonzini wrote:
>> Il 17/06/2014 22:55, Konrad Rzeszutek Wilk ha scritto:
>>> On Sun, Jun 15, 2014 at 02:47:01PM +0200, Peter Zijlstra wrote:
>>>> From: Waiman Long<Waiman.Long@hp.com>
>>>>
>>>> This patch extracts the logic for the exchange of new and previous tail
>>>> code words into a new xchg_tail() function which can be optimized in a
>>>> later patch.
>>> And also adds a third try on acquiring the lock. That I think should
>>> be a seperate patch.
>> It doesn't really add a new try, the old code is:
>>
>>
>> -	for (;;) {
>> -		new = _Q_LOCKED_VAL;
>> -		if (val)
>> -			new = tail | (val&  _Q_LOCKED_PENDING_MASK);
>> -
>> -		old = atomic_cmpxchg(&lock->val, val, new);
>> -		if (old == val)
>> -			break;
>> -
>> -		val = old;
>> -	}
>>
>>   	/*
>> -	 * we won the trylock; forget about queueing.
>>   	 */
>> -	if (new == _Q_LOCKED_VAL)
>> -		goto release;
>>
>> The trylock happens if the "if (val)" hits the else branch.
>>
>> What the patch does is change it from attempting two transition with a
>> single cmpxchg:
>>
>> -	 * 0,0,0 ->  0,0,1 ; trylock
>> -	 * p,y,x ->  n,y,x ; prev = xchg(lock, node)
>>
>> to first doing the trylock, then the xchg.  If the trylock passes and the
>> xchg returns prev=0,0,0, the next step of the algorithm goes to the
>> locked/uncontended state
>>
>> +	/*
>> +	 * claim the lock:
>> +	 *
>> +	 * n,0 ->  0,1 : lock, uncontended
>>
>> Similar to your suggestion of patch 3, it's expected that the xchg will
>> *not* return prev=0,0,0 after a failed trylock.
> I do like your explanation. I hope that Peter will put it in the
> description as it explains the change quite well.
>
>> However, I *do* agree with you that it's simpler to just squash this patch
>> into 01/11.
> Uh, did I say that? Oh I said why don't make it right the first time!
>
> I meant in terms of seperating the slowpath (aka the bytelock on the pending
> bit) from the queue (MCS code). Or renaming the function to be called
> 'complex' instead of 'slowpath' as it is getting quite hairy.
>
> The #1 patch is nice by itself - as it lays out the foundation of the
> MCS-similar code - and if Ingo decides he does not want this pending
> byte-lock bit business - it can be easily reverted or dropped.

The pending bit code is needed for performance parity with ticket 
spinlock for light load. My own measurement indicates that the queuing 
overhead will cause the queue spinlock to be slower than ticket spinlock 
with 2-4 contending tasks. The pending bit solves the performance 
problem with 2 contending tasks, leave only the 3-4 tasks cases being a 
bit slower than the ticket spinlock which should be more than 
compensated by its superior performance with heavy contention and 
slightly better performance with no contention.

-Longman
