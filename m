Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3DVQmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:42:53 -0400
Received: from mb1i1mx.ns.pitt.edu ([136.142.11.141]:60768 "EHLO
	mb1i1.ns.pitt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752474Ab3DVQmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:42:51 -0400
Date: Mon, 22 Apr 2013 12:42:49 -0400
From: Jiannan Ouyang <ouyang@cs.pitt.edu>
Subject: Re: Preemptable Ticket Spinlock
In-reply-to: <5174D18E.4090506@linux.vnet.ibm.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
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
Message-id: <CAJocwcc0M2Xr=ozpwLRM1vejMVfofr9n-TpAXU_efB_3MaCF5Q@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
 <5174D18E.4090506@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 1:58 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:

>  The intuition is to
>>
>> downgrade a fair lock to an unfair lock automatically upon preemption,
>> and preserve the fairness otherwise.
>
>
> I also hope being little unfair, does not affect the original intention
> of introducing ticket spinlocks too.
> Some discussions were here long back in this thead,
> https://lkml.org/lkml/2010/6/3/331
>

Good point. I also have the question that why not use unfair lock
under virtual environment,
and is fairness really a big issue. However, given that current kernel
is using ticket lock, I
assume fairness is a necessary spinlock feature.

Regard the fairness of preemptable-lock, I did a user space experiment
using 8 pCPU to
compete on one spinlock, and count the lock acquisition times. Results
show that lock acquisition
counts are *almost* evenly distributed between threads in preemptable-lock.

>
> AFAIU, the experiments are on non PLE machines and it would be worth
> experimenting on PLE machines too. and also bigger machines.
> (we may get some surprises there otherwise).
> 'll wait for your next iteration of the patches with "using lower bit"
> changes.
>

Yes, they are on PLE machines. Current implementation and evaluation
is still at the stage of
concept proving. More experiments (with PLE, bigger machiens, etc) are
needed to better understand
the lock behavior.

>> +#define TIMEOUT_UNIT (1<<14)
>
>
> This value seem to be at the higher end. But I hope you have experimented
> enough to come up with this. Better again to test all these tunables?? on
> PLE machines too.
>
>
I actually didn't tune this parameter at all... But yes, find a better
value is necessary if it is in industry code.

>>   static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>>   {
>>          register struct __raw_tickets inc = { .tail = 1 };
>> +       unsigned int timeout = 0;
>> +       __ticket_t current_head;
>>
>>          inc = xadd(&lock->tickets, inc);
>> -
>> +       if (likely(inc.head == inc.tail))
>> +               goto spin;
>> +
>> +       timeout =  TIMEOUT_UNIT * (inc.tail - inc.head);
>> +       do {
>> +               current_head = ACCESS_ONCE(lock->tickets.head);
>> +               if (inc.tail <= current_head) {
>> +                       goto spin;
>> +               } else if (inc.head != current_head) {
>> +                       inc.head = current_head;
>> +                       timeout =  TIMEOUT_UNIT * (inc.tail - inc.head);
>
>
> Good idea indeed to base the loop on head and tail difference.. But for
> virtualization I believe this "directly proportional notion" is little
> tricky too.
>

Could you explain your concern a little bit more?

Thanks
--Jiannan
