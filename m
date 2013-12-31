Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab3LaVW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 16:22:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359Ab3LaVW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 16:22:28 -0500
Message-ID: <52C33581.1030204@redhat.com>
Date: Tue, 31 Dec 2013 16:22:09 -0500
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
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>	<CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>	<52B336D4.8010809@redhat.com>	<CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>	<52BF060E.7090905@redhat.com>	<CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com>	<52C18C6B.8090802@redhat.com> <CANVTcTbBf8RomFtuvOrkVyHM136ViXVJr2UEQ-i6OvFmRYCqZA@mail.gmail.com>
In-Reply-To: <CANVTcTbBf8RomFtuvOrkVyHM136ViXVJr2UEQ-i6OvFmRYCqZA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/30/2013 09:58 PM, rui wang wrote:
> On 12/30/13, Prarit Bhargava <prarit@redhat.com> wrote:
>>
>>
>> On 12/30/2013 07:56 AM, rui wang wrote:
>>
> ...
>> Okay, so the big issue is that we need to do the calculation without this cpu,
> 
>>
>> int check_irq_vectors_for_cpu_disable(void)
>> {
>>        int irq, cpu;
>>        unsigned int vector, this_count, count;
>>        struct irq_desc *desc;
>>        struct irq_data *data;
>>        struct cpumask online_new; /* cpu_online_mask - this_cpu */
>>        struct cpumask affinity_new; /* affinity - this_cpu */
>>
>>        cpumask_copy(&online_new, cpu_online_mask);
>>        cpu_clear(smp_processor_id(), online_new);
>>
>>        this_count = 0;
>>        for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
>>                irq = __this_cpu_read(vector_irq[vector]);
>>                if (irq >= 0) {
>>                        desc = irq_to_desc(irq);
>>                        data = irq_desc_get_irq_data(desc);
>>                        cpumask_copy(&affinity_new, data->affinity);
>>                        cpu_clear(smp_processor_id(), affinity_new);
>>                        if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>>                            !cpumask_subset(&affinity_new, &online_new) &&
>>                            !cpumask_empty(&affinity_new))
> 
> If this cpu is the only target, then affinity_new becomes empty.
> Should we count it for migration?

Okay, how about,
                        if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
                            ((!cpumask_empty(&affinity_new)) &&
                              !cpumask_subset(&affinity_new, &online_new)) ||
                             cpumask_empty(&affinity_new))
                                this_count++;

I tried this with the following examples and AFAICT I get the correct result:

1) affinity mask = online mask = 0xf.  CPU 3 (1000b) is down'd.

this_count is not incremented.

2) affinity mask is a non-zero subset of the online mask (which IMO is
the "typical" case).  For example, affinity_mask = 0x9, online mask = 0xf.  CPU
3 is again down'd.

this_count is not incremented.

3) affinity_mask = 0x1, online mask = 0x3. (this is your example).  CPU
1 is going down.

this_count is incremented, as the resulting affinity mask will be 0.

4) affinity_mask = 0x0, online mask = 0x7.  CPU 1 is going down.

this_count is incremented, as the affinity mask is 0.

P.
