Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3DVFzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:55:35 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:35307 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3DVFzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:55:33 -0400
Message-ID: <5174D18E.4090506@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 11:28:38 +0530
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
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
In-Reply-To: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042205-4790-0000-0000-000007F436B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2013 03:42 AM, Jiannan Ouyang wrote:
> Hello Everyone,
>
> I recently came up with a spinlock algorithm that can adapt to
> preemption, which you may be interested in.

It is overall a great and clever idea as Rik mentioned already.

  The intuition is to
> downgrade a fair lock to an unfair lock automatically upon preemption,
> and preserve the fairness otherwise.

I also hope being little unfair, does not affect the original intention
of introducing ticket spinlocks too.
Some discussions were here long back in this thead,
https://lkml.org/lkml/2010/6/3/331

It is a guest side optimization,
> and can be used as a complementary technique to host side optimizations
> like co-scheduling and Pause-Loop Exiting.
>
> In my experiments, it improves VM performance by 5:32X on average, when
> running on a non paravirtual VMM, and by 7:91X when running on a VMM
> that supports a paravirtual locking interface (using a pv preemptable
> ticket spinlock), when executing a set of microbenchmarks as well as a
> realistic e-commerce benchmark.

AFAIU, the experiments are on non PLE machines and it would be worth 
experimenting on PLE machines too. and also bigger machines.
(we may get some surprises there otherwise).
'll wait for your next iteration of the patches with "using lower bit"
changes.


>
> A detailed algorithm description can be found in my VEE 2013 paper,
> Preemptable Ticket Spinlocks: Improving Consolidated Performance in the
> Cloud
> Jiannan Ouyang, John R. Lange
> ouyang,jacklange@cs.pitt.edu <mailto:jacklange@cs.pitt.edu>
> University of Pittsburgh
> http://people.cs.pitt.edu/~ouyang/files/publication/preemptable_lock-ouyang-vee13.pdf
>
> The patch is based on stock Linux kernel 3.5.0, and tested on kernel
> 3.4.41 as well.
> http://www.cs.pitt.edu/~ouyang/files/preemptable_lock.tar.gz
>
> Thanks
> --Jiannan
>
> I'm not familiar with patch over email, so I just paste it below, sorry
> for the inconvenience.
> ======================
> diff --git a/arch/x86/include/asm/spinlock.h
> b/arch/x86/include/asm/spinlock.h
> index b315a33..895d3b3 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -48,18 +48,35 @@
>    * in the high part, because a wide xadd increment of the low part
> would carry
>    * up and contaminate the high part.
>    */
> +#define TIMEOUT_UNIT (1<<14)

This value seem to be at the higher end. But I hope you have 
experimented enough to come up with this. Better again to test all these 
tunables?? on PLE machines too.

>   static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
>   {
>          register struct __raw_tickets inc = { .tail = 1 };
> +       unsigned int timeout = 0;
> +       __ticket_t current_head;
>
>          inc = xadd(&lock->tickets, inc);
> -
> +       if (likely(inc.head == inc.tail))
> +               goto spin;
> +
> +       timeout =  TIMEOUT_UNIT * (inc.tail - inc.head);
> +       do {
> +               current_head = ACCESS_ONCE(lock->tickets.head);
> +               if (inc.tail <= current_head) {
> +                       goto spin;
> +               } else if (inc.head != current_head) {
> +                       inc.head = current_head;
> +                       timeout =  TIMEOUT_UNIT * (inc.tail - inc.head);

Good idea indeed to base the loop on head and tail difference.. But for 
virtualization I believe this "directly proportional notion" is little 
tricky too.

