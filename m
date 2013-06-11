Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3FKRgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:36:09 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38676 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3FKRgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:36:07 -0400
Message-ID: <51B75FF3.6040808@hp.com>
Date: Tue, 11 Jun 2013 13:35:47 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
References: <20130609193657.GA13392@linux.vnet.ibm.com>  <51B748DA.2070306@hp.com> <1370967632.9844.182.camel@gandalf.local.home>
In-Reply-To: <1370967632.9844.182.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 12:20 PM, Steven Rostedt wrote:
>>> diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
>>> index ad0ad07..cdaefdd 100644
>>> --- a/arch/x86/include/asm/spinlock_types.h
>>> +++ b/arch/x86/include/asm/spinlock_types.h
>>> @@ -7,12 +7,18 @@
>>>
>>>    #include<linux/types.h>
>>>
>>> -#if (CONFIG_NR_CPUS<   256)
>>> +#if (CONFIG_NR_CPUS<   128)
>>>    typedef u8  __ticket_t;
>>>    typedef u16 __ticketpair_t;
>>> -#else
>>> +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2>= (unsigned char)((a) - (b)))
>>> +#elif (CONFIG_NR_CPUS<   32768)
>>>    typedef u16 __ticket_t;
>>>    typedef u32 __ticketpair_t;
>>> +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2>= (unsigned short)((a) - (b)))
>>> +#else
>>> +typedef u32 __ticket_t;
>>> +typedef u64 __ticketpair_t;
>>> +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2>= (unsigned int)((a) - (b)))
>>>    #endif
>> It is theoretically possible that a large number of CPUs (says 64 or
>> more with CONFIG_NR_CPUS<  128) can acquire a ticket from the lock
>> before the check for TICKET_T_CMP_GE() in tkt_spin_pass(). So the check
>> will fail even when there is a large number of CPUs contending for the
>> lock. The chance of this happening is, of course, extremely rare. This
>> is not an error as the lock is still working as it should be without
>> your change.
> Can you explain this more. How can you acquire the ticket and update at
> the same time? If a queue has been set, then you can't acquire the
> ticket as the head has a 1 appended to it.

I am sorry if I confuse you. What I meant is queuing up at the tail of 
the ticket lock incrementing the tail number, not actually getting the lock.

>>
>>> +/*
>>> + * Return a pointer to the queue header associated with the specified lock,
>>> + * or return NULL if there is no queue for the lock or if the lock's queue
>>> + * is in transition.
>>> + */
>>> +static struct tkt_q_head *tkt_q_find_head(arch_spinlock_t *asp)
>>> +{
>>> +	int i;
>>> +	int start;
>>> +
>>> +	start = i = tkt_q_hash(asp);
>>> +	do
>>> +		if (tkt_q_heads[i].ref == asp)
>>> +			return&tkt_q_heads[i];
>>> +	while ((i = tkt_q_next_slot(i)) != start);
>>> +	return NULL;
>>> +}
>> With a table size of 256 and you have to scan the whole table to find
>> the right head queue. This can be a significant overhead. I will suggest
>> setting a limiting of how many entries it scans before it aborts rather
>> than checking the whole table.
> We could add a limit, but in practice I'm not sure that would have any
> issue. I thought the same thing when I first saw this, but to hit most
> of the list, would require a large collision in the hash algorithm,
> would could probably be fixed with a better hash.

The current code will scan the whole table until either it gets a match 
or whole table scan is completed. I first thought that hitting a NULL 
entry can stop the search, but that is not true. It is entirely possible 
that an entry was used when a queue is created but become empty 
immediately after that. So we have to scan the whole table to be sure or 
unless we impose a limit on how many entries we scan.

Regards,
Longman
