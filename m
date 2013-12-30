Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab3L3M4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:56:05 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:39510 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705Ab3L3M4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:56:02 -0500
MIME-Version: 1.0
In-Reply-To: <52BF060E.7090905@redhat.com>
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>
	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
	<CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
	<52B336D4.8010809@redhat.com>
	<CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>
	<52BF060E.7090905@redhat.com>
Date: Mon, 30 Dec 2013 20:56:01 +0800
Message-ID: <CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before CPU
 down [v2]
From: rui wang <ruiv.wang@gmail.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        chen gong <gong.chen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/29/13, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 12/20/2013 04:41 AM, rui wang wrote:
<<snip>>
>> The vector number for an irq is programmed in the LSB of the IOAPIC
>> IRTE (or MSI data register in the case of MSI/MSIx). So there can be
>> only one vector number (although multiple CPUs can be specified
>> through DM). An MSI-capable device can dynamically change the lower
>> few bits in the LSB to signal multiple interrupts with a contiguous
>> range of vectors in powers of 2,but each of these vectors is treated
>> as a separate IRQ. i.e. each of them has a separate irq desc, or a
>> separate line in the /proc/interrupt file. This patch shows the MSI
>> irq allocation in detail:
>> http://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?id=51906e779f2b13b38f8153774c4c7163d412ffd9
>>
>> Thanks
>> Rui
>>
>
> Gong and Rui,
>
> After looking at this in detail I realized I made a mistake in my patch by
> including the check for the smp_affinity.  Simply put, it shouldn't be
> there
> given Rui's explanation above.
>
> So I think the patch simply needs to do:
>
>         this_count = 0;
>         for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++)
> {
>                 irq = __this_cpu_read(vector_irq[vector]);
>                 if (irq >= 0) {
>                         desc = irq_to_desc(irq);
>                         data = irq_desc_get_irq_data(desc);
>                         affinity = data->affinity;
>                         if (irq_has_action(irq) && !irqd_is_per_cpu(data))
>                                 this_count++;
>                 }
>         }
>
> Can the two of you confirm the above is correct?  It would be greatly
> appreciated.

An irq can be mapped to only one vector number, but can have multiple
destination CPUs. i.e. the same irq/vector can appear on multiple
CPUs' vector_irq[]. So checking data->affinity is necessary I think.
But notice that data->affinity is updated in chip->irq_set_affinity()
inside fixup_irqs(), while cpu_online_mask is updated in
remove_cpu_from_maps() inside cpu_disable_common(). They are updated
in different places. So the algorithm to check them against each other
should be different, depending on where you put the check_vectors().
That's my understanding.

Thanks
Rui
