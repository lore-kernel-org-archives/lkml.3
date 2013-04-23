Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab3DWBvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 21:51:32 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:51394 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3DWBva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 21:51:30 -0400
Message-ID: <5175E9E4.60903@linux.vnet.ibm.com>
Date: Tue, 23 Apr 2013 07:24:44 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jiannan Ouyang <ouyang@cs.pitt.edu>
CC: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com> <5174D18E.4090506@linux.vnet.ibm.com> <CAJocwcc0M2Xr=ozpwLRM1vejMVfofr9n-TpAXU_efB_3MaCF5Q@mail.gmail.com>
In-Reply-To: <CAJocwcc0M2Xr=ozpwLRM1vejMVfofr9n-TpAXU_efB_3MaCF5Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042301-4790-0000-0000-000007F89216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 10:12 PM, Jiannan Ouyang wrote:
> On Mon, Apr 22, 2013 at 1:58 AM, Raghavendra K T
> <raghavendra.kt@linux.vnet.ibm.com> wrote:

[...]

>>>    static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>>    {
>>>           register struct __raw_tickets inc = { .tail = 1 };
>>> +       unsigned int timeout = 0;
>>> +       __ticket_t current_head;
>>>
>>>           inc = xadd(&lock->tickets, inc);
>>> -
>>> +       if (likely(inc.head == inc.tail))
>>> +               goto spin;
>>> +
>>> +       timeout =  TIMEOUT_UNIT * (inc.tail - inc.head);

Forgot to mention about this, for immediate wait case,
you can busyloop instead of timeout (I mean

timeout =  TIMEOUT_UNIT * (inc.tail - inc.head -1);

This ideas was used by Rik in his spinlock  backoff patches.

>>> +       do {
>>> +               current_head = ACCESS_ONCE(lock->tickets.head);
>>> +               if (inc.tail <= current_head) {
>>> +                       goto spin;
>>> +               } else if (inc.head != current_head) {
>>> +                       inc.head = current_head;
>>> +                       timeout =  TIMEOUT_UNIT * (inc.tail - inc.head);
>>
>>
>> Good idea indeed to base the loop on head and tail difference.. But for
>> virtualization I believe this "directly proportional notion" is little
>> tricky too.
>>
>
> Could you explain your concern a little bit more?
>

Consider a big machine with 2 VMs running.
If nth vcpu of say VM1 waiting in the queue, the question is,

Do we have to have all the n VCPU doing busyloop and thus burning
sigma (n*(n+1) * TIMEOUT_UNIT)) ?

OR

Is it that, far off vcpu in the queue worth giving his time back so that 
probably some other vcpu of VM1 doing good work OR vcpu of VM2 can 
benefit from this.

I mean far the vcpu in the queue, let him yield voluntarily. (inversely 
proportional notion just because it is vcpu). and of course for some n < 
THRESHOLD we can still have directly proportional wait idea.

Does this idea sound good ?

