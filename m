Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3L3PKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:10:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab3L3PKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:10:09 -0500
Message-ID: <52C18CC3.9080507@redhat.com>
Date: Mon, 30 Dec 2013 10:09:55 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: rui wang <ruiv.wang@gmail.com>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
References: <1387394945-5704-1-git-send-email-prarit@redhat.com> <CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com> <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com> <52B336D4.8010809@redhat.com> <CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com> <52BF060E.7090905@redhat.com> <20131230074434.GA20484@gchen.bj.intel.com>
In-Reply-To: <20131230074434.GA20484@gchen.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/30/2013 02:44 AM, Chen, Gong wrote:
> On Sat, Dec 28, 2013 at 12:10:38PM -0500, Prarit Bhargava wrote:
>> Gong and Rui,
>>
>> After looking at this in detail I realized I made a mistake in my patch by
>> including the check for the smp_affinity.  Simply put, it shouldn't be there
>> given Rui's explanation above.
>>
>> So I think the patch simply needs to do:
>>
>>         this_count = 0;
>>         for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
>>                 irq = __this_cpu_read(vector_irq[vector]);
>>                 if (irq >= 0) {
>>                         desc = irq_to_desc(irq);
>>                         data = irq_desc_get_irq_data(desc);
>>                         affinity = data->affinity;
>>                         if (irq_has_action(irq) && !irqd_is_per_cpu(data))
>>                                 this_count++;
>>                 }
>>         }
>>
>> Can the two of you confirm the above is correct?  It would be greatly appreciated.
>>
> 
> No, I don't think it is correct. We still need to consider smp_affinity.
> 
> fixup_irqs
>         irq_set_affinity(native_ioapic_set_affinity)
>                 __ioapic_set_affinity
>                         assign_irq_vector
>                                 __assign_irq_vector
>                         cpu_mask_to_apicid_and
>                 /* now begin to set ioapic RET */
> 
> __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
> {
> ...
>         apic->vector_allocation_domain(cpu, tmp_mask, mask);
> ...
>         for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
>                 per_cpu(vector_irq, new_cpu)[vector] = irq;
>         cfg->vector = vector;
>         cpumask_copy(cfg->domain, tmp_mask);
> ...
> }
> 
> On same vecotr on all related vector_irq, irq is set. So such kind of
> irq should happen in multiple vector_irq. In cpu_mask_to_apicid_and(e.g.
> x2apic_cpu_mask_to_apicid_and for cluster mode), apic is updated
> depending on new mask. That's why I think this kind of interrupt
> should be bypassed.

Hmm ... okay.  I'll take a closer look at this.

Thanks for the additional information.

P.

