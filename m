Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244Ab3LaC6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 21:58:15 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40383 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3LaC6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 21:58:14 -0500
MIME-Version: 1.0
In-Reply-To: <52C18C6B.8090802@redhat.com>
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>
	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
	<CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
	<52B336D4.8010809@redhat.com>
	<CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>
	<52BF060E.7090905@redhat.com>
	<CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com>
	<52C18C6B.8090802@redhat.com>
Date: Tue, 31 Dec 2013 10:58:13 +0800
Message-ID: <CANVTcTbBf8RomFtuvOrkVyHM136ViXVJr2UEQ-i6OvFmRYCqZA@mail.gmail.com>
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

On 12/30/13, Prarit Bhargava <prarit@redhat.com> wrote:
>
>
> On 12/30/2013 07:56 AM, rui wang wrote:
>
>> An irq can be mapped to only one vector number, but can have multiple
>> destination CPUs. i.e. the same irq/vector can appear on multiple
>> CPUs' vector_irq[]. So checking data->affinity is necessary I think.
>
> That's true Rui -- but here's what I think the scenario actually is.
>
> Suppose we have a 4-cpu system, and we have an IRQ that is mapped to
> multiple
> cpu's vector_irq[].  For example, we have IRQ 200 that is mapped to CPU 2
> vector_irq[50], and CPU 3 vector_irq[60].
>

This should not happen. There's only one LSB to fill the vector number
in IRTE. So either 50 or 60 but not both for an irq.

...
> Okay, so the big issue is that we need to do the calculation without this cpu,

Yes if it's done before calling cpu_disable_comm().

> so I think this works (sorry for the cut-and-paste)
>
> int check_irq_vectors_for_cpu_disable(void)
> {
>        int irq, cpu;
>        unsigned int vector, this_count, count;
>        struct irq_desc *desc;
>        struct irq_data *data;
>        struct cpumask online_new; /* cpu_online_mask - this_cpu */
>        struct cpumask affinity_new; /* affinity - this_cpu */
>
>        cpumask_copy(&online_new, cpu_online_mask);
>        cpu_clear(smp_processor_id(), online_new);
>
>        this_count = 0;
>        for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
>                irq = __this_cpu_read(vector_irq[vector]);
>                if (irq >= 0) {
>                        desc = irq_to_desc(irq);
>                        data = irq_desc_get_irq_data(desc);
>                        cpumask_copy(&affinity_new, data->affinity);
>                        cpu_clear(smp_processor_id(), affinity_new);
>                        if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>                            !cpumask_subset(&affinity_new, &online_new) &&
>                            !cpumask_empty(&affinity_new))

If this cpu is the only target, then affinity_new becomes empty.
Should we count it for migration?

Thanks
Rui
