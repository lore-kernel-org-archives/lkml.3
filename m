Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab3LWP3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 10:29:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab3LWP3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 10:29:36 -0500
Message-ID: <52B856D3.4030802@redhat.com>
Date: Mon, 23 Dec 2013 10:29:23 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: rui wang <ruiv.wang@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Michel Lespinasse <walken@google.com>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        tony.luck@intel.com
Subject: Re: [PATCH] x86, Fix do_IRQ interrupt warning for cpu hotplug retriggered
 irqs
References: <1385990638-19548-1-git-send-email-prarit@redhat.com> <CANVTcTZ-ZkTvR0+=eFyNQ7E8R2UYo1qdA-RQ+9nzK2w=qCPkPQ@mail.gmail.com>
In-Reply-To: <CANVTcTZ-ZkTvR0+=eFyNQ7E8R2UYo1qdA-RQ+9nzK2w=qCPkPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/23/2013 04:41 AM, rui wang wrote:
> On 12/2/13, Prarit Bhargava <prarit@redhat.com> wrote:
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64831
>>
>> When downing a cpu it is possible that there are unhandled irqs left in
>> the APIC IRR register.  fixup_irqs() goes through the IRR and retriggers
>> the IRQs left in the APIC IRR.  After this, the vector for the irq is set
>> to -1.  There is a possibility here, however, that the CPU does handle an
>> irq in the IRR and then calls the vector.
>>
> 
> The patch does not seem to root-cause the problem. It seems to hide
> the real problem.
> 
> It is not possible that a device-triggered irq can arrive to this cpu
> again after fixup_irqs() fills its vector_irq[vector] to -1, because
> we've done the following:
> 
> 1. We disabled interrupt on this cpu in stop_machine().
> 2. We called irq_set_affinity() to exclude this cpu as a target for the irq.
> 3. We checked APIC_IRR and re-triggered any pending irqs to other cpus.

... and we set the IRQ handler to -1 for the down'd cpu.

Rui, I think you're right up to here but I think this has nothing to do with IPI
or locking.

I assumed that the issue I was trying to fix was long standing and well-known
within the kernel given some of the comments I had read here-and-there about
people seeing the do_IRQ errors on LKML.  There have long been reports of the
do_IRQ warning output during cpu down.

Here's what the issue is after step 3 above...

4.  The APIC_IRR is still *set* in the down'd cpu with IRQs disabled.
5.  We continue executing the stop_machine "down" portion of the code, then
continue executing in normal context the "die" code (ie, __cpu_die()).

IRQ disable only pertains stop_machine down.  So after we leave that context,
IRR will still execute.  While the kernel is spinning in cpu_die(), the down'd
cpu attempts to execute handler for IRQ in IRR ... and can't find one because
we've set it to -1.  So we see the warning.

A few additional debug points:

1.  I put a printk in fixup_irq when we call the irq_retrigger on another cpu
that dumps the the down'd CPU and IRQ # in fixup_irqs().  I see that printk
*EVERYTIME* I see the do_IRQ warning.

2.  The do_IRQ warning *always* appears before I see the offline message ...

[  148.656016] Broke affinity for irq 634
[  148.660493] Broke affinity for irq 698
[  148.665739] kvm: disabling virtualization on CPU58
[  148.666732] PRARIT: 58.208 IRR entry ... irq_retrigger call.

at this point we've left the stop_machine() code and we're now continuing to
execute ... then we hit the cpu_die() ... which spins.

[  148.671106] do_IRQ: 58.208 No irq handler for vector (irq -1)
[  148.677544] smpboot: CPU 58 is now offline

I think I have root caused this to the IRR being set in the down'd cpu.  It is
admittedly a rare occurrence in the kernel.  I usually have to run about 1000 up
and down's before hitting it, however, on my current test system it seems to hit
much more frequently, almost 1 in 64 times.

P.
