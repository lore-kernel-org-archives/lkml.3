Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaEJBFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 21:05:52 -0400
Received: from g6t1526.atlanta.hp.com ([15.193.200.69]:58691 "EHLO
	g6t1526.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbaEJBFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 21:05:50 -0400
Message-ID: <536D7B55.6030208@hp.com>
Date: Fri, 09 May 2014 21:05:25 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 07/19] qspinlock: Use a simple write to grab the lock,
 if applicable
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com> <1399474907-22206-8-git-send-email-Waiman.Long@hp.com> <20140508190004.GO2844@laptop.programming.kicks-ass.net>
In-Reply-To: <20140508190004.GO2844@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 03:00 PM, Peter Zijlstra wrote:
> On Wed, May 07, 2014 at 11:01:35AM -0400, Waiman Long wrote:
>> @@ -94,23 +94,29 @@ static inline struct mcs_spinlock *decode_tail(u32 tail)
>>    * can allow better optimization of the lock acquisition for the pending
>>    * bit holder.
>>    */
>> -#if _Q_PENDING_BITS == 8
>> -
>>   struct __qspinlock {
>>   	union {
>>   		atomic_t val;
>> -		struct {
>>   #ifdef __LITTLE_ENDIAN
>> +		u8	 locked;
>> +		struct {
>>   			u16	locked_pending;
>>   			u16	tail;
>> +		};
>>   #else
>> +		struct {
>>   			u16	tail;
>>   			u16	locked_pending;
>> -#endif
>>   		};
>> +		struct {
>> +			u8	reserved[3];
>> +			u8	locked;
>> +		};
>> +#endif
>>   	};
>>   };
>>
>> +#if _Q_PENDING_BITS == 8
> That doesn't make sense, that struct __qspinlock only makes sense when
> _Q_PENDING_BITS == 8.

I need to use the locked field (the 2nd strcut) in get_qlock() where I 
grab the lock by setting the lock byte directly. Since the endian-aware 
structure is already in place, I reused it and have to expose it even 
when _Q_PENDING_BITS isn't 8. I will document that more clearly in the 
code to avoid this confusion.

-Longman
