Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbaE2JkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:40:13 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:52881 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756055AbaE2JkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:40:10 -0400
Message-ID: <53870188.5060209@linux.vnet.ibm.com>
Date: Thu, 29 May 2014 15:14:40 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, waiman.long@hp.com, davej@redhat.com,
        oleg@redhat.com, x86@kernel.org, jeremy@goop.org,
        paul.gortmaker@windriver.com, ak@linux.intel.com, jasowang@redhat.com,
        fernando_b1@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Implement Batched (group) ticket lock
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <53865B53.7050809@redhat.com>
In-Reply-To: <53865B53.7050809@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052909-3864-0000-0000-00000E7EA57E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 03:25 AM, Rik van Riel wrote:
> On 05/28/2014 08:16 AM, Raghavendra K T wrote:
>
> This patch looks very promising.

Thank you Rik.

[...]
>>
>> - My kernbench/ebizzy test on baremetal (32 cpu +ht sandybridge) did not seem to
>>    show the impact of extra cmpxchg. but there should be effect of extra cmpxchg.
>
> Canceled out by better NUMA locality?

Yes perhaps. it was even slightly better.

[...]
>> - we can further add dynamically changing batch_size implementation (inspiration and
>>    hint by Paul McKenney) as necessary.
>
> I could see a larger batch size being beneficial.
>
> Currently the maximum wait time for a spinlock on a system
> with N CPUs is N times the length of the largest critical
> section.
>
> Having the batch size set equal to the number of CPUs would only
> double that, and better locality (CPUs local to the current
> lock holder winning the spinlock operation) might speed things
> up enough to cancel that part of that out again...

having batch size = number of cpus would definitely help contended cases
especially on larger machines (by my experience with testing on a 4
node 32 core machine). +ht case should make it even more
beneficial.

My only botheration was overhead in undercommit cases because of extra
cmpxchg.
So may be batch_size = total cpus / numa node be optimal?...

[...]
>> +#define TICKET_LOCK_INC_SHIFT 1
>> +#define __TICKET_LOCK_TAIL_INC (1<<TICKET_LOCK_INC_SHIFT)
>> +
>>   #ifdef CONFIG_PARAVIRT_SPINLOCKS
>> -#define __TICKET_LOCK_INC	2
>>   #define TICKET_SLOWPATH_FLAG	((__ticket_t)1)
>>   #else
>> -#define __TICKET_LOCK_INC	1
>>   #define TICKET_SLOWPATH_FLAG	((__ticket_t)0)
>>   #endif
>
> For the !CONFIG_PARAVIRT case, TICKET_LOCK_INC_SHIFT used to be 0,
> now you are making it one. Probably not an issue, since even people
> who compile with 128 < CONFIG_NR_CPUS <= 256 will likely have their
> spinlocks padded out to 32 or 64 bits anyway in most data structures.

Yes..

[...]
>> +#define TICKET_BATCH    0x4 /* 4 waiters can contend simultaneously */
>> +#define TICKET_LOCK_BATCH_MASK (~(TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) + \
>> +				  TICKET_LOCK_TAIL_INC - 1)
>
> I do not see the value in having TICKET_BATCH declared with a
> hexadecimal number,

yes.. It had only helped me to make the idea readable to myself, I
could get rid of this if needed.

and it may be worth making sure the code
> does not compile if someone tried a TICKET_BATCH value that
> is not a power of 2.

I agree.  will have BUILD_BUG for not power of 2 in next version.
But yes it reminds me that I wanted to have TICKET_BATCH = 1 for
!CONFIG_PARAVIRT so that we continue to have original fair lock version.
Does that make sense? I left it after thinking about same kernel running
on host/guest which would anyway will have CONFIG_PARAVIRT on.

