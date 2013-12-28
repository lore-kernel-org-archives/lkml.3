Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab3L1RK4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 12:10:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755301Ab3L1RKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 12:10:54 -0500
Message-ID: <52BF060E.7090905@redhat.com>
Date: Sat, 28 Dec 2013 12:10:38 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: rui wang <ruiv.wang@gmail.com>
CC: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        chen gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>	<CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>	<52B336D4.8010809@redhat.com> <CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>
In-Reply-To: <CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/20/2013 04:41 AM, rui wang wrote:
> On 12/20/13, Prarit Bhargava <prarit@redhat.com> wrote:
>>
>>
>> On 12/19/2013 01:05 PM, Tony Luck wrote:
>>> On Wed, Dec 18, 2013 at 11:50 AM, Tony Luck <tony.luck@intel.com> wrote:
>>>> Looks good to me.
>>>
>>> Though now I've been confused by an offline question about affinity.
>>
>> Heh :)  I'm pursuing it now.  Rui has asked a pretty good question that I
>> don't
>> know the answer to off the top of my head.  I'm still looking at the code.
>>
>>>
>>> Suppose we have some interrupt that has affinity to multiple cpus. E.g.
>>> (real example from one of my machines):
>>>
>>> # cat /proc/irq/94/smp_affinity_list
>>> 26,54
>>>
>>> Now If I want to take either cpu26 or cpu54 offline - I'm guessing that I
>>> don't
>>> really need to find a new home for vector 94 - because the other one of
>>> that
>>> pair already has that set up.  But your check_vectors code doesn't look
>>> like
>>> it accounts for that - if we take cpu26 offline - it would see that
>>> cpu54 doesn't
>>> have 94 free - but doesn't check that it is for the same interrupt.
>>>
>>> But I may be mixing "vectors" and "irqs" here.
>>
>> Yep.  The question really is this: is the irq mapped to a single vector or
>> multiple vectors. (I think)
>>
> 
> The vector number for an irq is programmed in the LSB of the IOAPIC
> IRTE (or MSI data register in the case of MSI/MSIx). So there can be
> only one vector number (although multiple CPUs can be specified
> through DM). An MSI-capable device can dynamically change the lower
> few bits in the LSB to signal multiple interrupts with a contiguous
> range of vectors in powers of 2,but each of these vectors is treated
> as a separate IRQ. i.e. each of them has a separate irq desc, or a
> separate line in the /proc/interrupt file. This patch shows the MSI
> irq allocation in detail:
> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=51906e779f2b13b38f8153774c4c7163d412ffd9
> 
> Thanks
> Rui
> 

Gong and Rui,

After looking at this in detail I realized I made a mistake in my patch by
including the check for the smp_affinity.  Simply put, it shouldn't be there
given Rui's explanation above.

So I think the patch simply needs to do:

        this_count = 0;
        for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
                irq = __this_cpu_read(vector_irq[vector]);
                if (irq >= 0) {
                        desc = irq_to_desc(irq);
                        data = irq_desc_get_irq_data(desc);
                        affinity = data->affinity;
                        if (irq_has_action(irq) && !irqd_is_per_cpu(data))
                                this_count++;
                }
        }

Can the two of you confirm the above is correct?  It would be greatly appreciated.

Tony, I apologize -- your comments made me think you were stating a fact and not
asking a question on the behavior of affinity.  I completely misunderstood what
you were suggesting.  I thought you were implying that that the affinity "tied"
IRQ behavior together; it does not.  It is simply a suggestion of what IRQs
should be assigned to a particular CPU.  There is an expectation that the system
will attempt to honour the affinity, however, it is not like each CPU is
assigned a separate IRQ.

P.
