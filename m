Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbaE3Isp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:48:45 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:45301 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbaE3Isk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:48:40 -0400
Message-ID: <538846F1.3030303@linux.vnet.ibm.com>
Date: Fri, 30 May 2014 14:23:05 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        konrad.wilk@oracle.com, pbonzini@redhat.com, gleb@redhat.com,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, davej@redhat.com, oleg@redhat.com,
        x86@kernel.org, jeremy@goop.org, paul.gortmaker@windriver.com,
        ak@linux.intel.com, jasowang@redhat.com, fernando_b1@lab.ntt.co.jp,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, riel@redhat.com, mtosatti@redhat.com,
        chegu_vinod@hp.com
Subject: Re: [RFC] Implement Batched (group) ticket lock
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <5387B87E.2010609@hp.com>
In-Reply-To: <5387B87E.2010609@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14053008-7014-0000-0000-000004FABAE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 04:15 AM, Waiman Long wrote:
> On 05/28/2014 08:16 AM, Raghavendra K T wrote:
>> - we need an intelligent way to nullify the effect of batching for
>> baremetal
>>   (because extra cmpxchg is not required).
>
> To do this, you will need to have 2 slightly different algorithms
> depending on the paravirt_ticketlocks_enabled jump label.

Thanks for the hint Waiman.

[...]
>> +spin:
>> +    for (;;) {
>> +        inc.head = ACCESS_ONCE(lock->tickets.head);
>> +        if (!(inc.head&  TICKET_LOCK_HEAD_INC)) {
>> +            new.head = inc.head | TICKET_LOCK_HEAD_INC;
>> +            if (cmpxchg(&lock->tickets.head, inc.head, new.head)
>> +                    == inc.head)
>> +                goto out;
>> +        }
>> +        cpu_relax();
>> +    }
>> +
>
> It had taken me some time to figure out the the LSB of inc.head is used
> as a bit lock for the contending tasks in the spin loop. I would suggest
> adding some comment here to make it easier to look at.

Agree. 'll add a comment.

[...]
>> +#define TICKET_BATCH    0x4 /* 4 waiters can contend simultaneously */
>> +#define TICKET_LOCK_BATCH_MASK
>> (~(TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) + \
>> +                  TICKET_LOCK_TAIL_INC - 1)
>
> I don't think TAIL_INC has anything to do with setting the BATCH_MASK.
> It works here because TAIL_INC is 2. I think it is clearer to define it
> as either "(~(TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) + 1)" or
> (~((TICKET_BATCH<<TICKET_LOCK_INC_SHIFT) - 1)).

You are right.
Thanks for pointing out. Your expression is simple and clearer. 'll use
one of them.

