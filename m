Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbaABQE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:04:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaABQEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:04:53 -0500
Message-ID: <52C58E0F.6090204@redhat.com>
Date: Thu, 02 Jan 2014 11:04:31 -0500
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
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        chen gong <gong.chen@linux.intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
References: <1387394945-5704-1-git-send-email-prarit@redhat.com> <CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com> <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com> <52B336D4.8010809@redhat.com> <CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com> <52BF060E.7090905@redhat.com> <CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com> <52C18C6B.8090802@redhat.com> <CANVTcTbBf8RomFtuvOrkVyHM136ViXVJr2UEQ-i6OvFmRYCqZA@mail.gmail.com> <52C33581.1030204@redhat.com> <20140102024138.GA28000@gchen.bj.intel.com> <52C56234.5030608@redhat.com>
In-Reply-To: <52C56234.5030608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/02/2014 07:57 AM, Prarit Bhargava wrote:
> 
> 
> On 01/01/2014 09:41 PM, Chen, Gong wrote:
>> On Tue, Dec 31, 2013 at 04:22:09PM -0500, Prarit Bhargava wrote:
>>> Okay, how about,
>>>                         if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>>>                             ((!cpumask_empty(&affinity_new)) &&
>>>                               !cpumask_subset(&affinity_new, &online_new)) ||
>>>                              cpumask_empty(&affinity_new))
>>>                                 this_count++;
>>>
>> I think it is good but a little bit complicated. How about this:
>>
>>         if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>>             /* add some commments to emphysize the importance of turn */
>>             (cpumask_empty(&affinity_new) ||
>>             !cpumask_subset(&affinity_new, &online_new)))
> 
> Yeah :)  I thought of that after I sent it. :)
> 
>>
>>> I tried this with the following examples and AFAICT I get the correct result:
>>>
>>> 1) affinity mask = online mask = 0xf.  CPU 3 (1000b) is down'd.
>>>
>>> this_count is not incremented.
>>>
>>> 2) affinity mask is a non-zero subset of the online mask (which IMO is
>>> the "typical" case).  For example, affinity_mask = 0x9, online mask = 0xf.  CPU
>>> 3 is again down'd.
>>>
>>> this_count is not incremented.
>>>
>>> 3) affinity_mask = 0x1, online mask = 0x3. (this is your example).  CPU
>>> 1 is going down.
>>>
>>> this_count is incremented, as the resulting affinity mask will be 0.
>>>
>>> 4) affinity_mask = 0x0, online mask = 0x7.  CPU 1 is going down.
>>>
>>> this_count is incremented, as the affinity mask is 0.
>>>
>> The 4th scenario is very tricky. If you try to set affinity from user space,
>> it will return failure because before kernel tried to change the affinity it
>> will verify it:
>> int __ioapic_set_affinity(...)
>> {
>> ...
>>         if (!cpumask_intersects(mask, cpu_online_mask))
>>                 return -EINVAL;
>> ...
>> }
>>
>> So from this point of view, affinity can't be 0. But your patch is very
>> special because you change it by hand:
>>         cpu_clear(smp_processor_id(), affinity_new);
>>
>> so it is reasonable. It makes me thinking a little bit more. In fixup_irqs
>> we have similar logic but we don't protect it. Maybe it is because currently
>> the scenario 4 can't happen because we stop it in advance. But who knows
>> if one day we use it in other situation we will hit this subtle issue
>> probably.
>>
>> So, Prarit, I suggest you writing another patch to fix this potential issue
>> for fixup_irqs. How would you think?
> 
> As you know Rui, I've been staring at that code wondering if it needs a fix.
> I'd like to hear Gong Chen's thoughts about it too...
> 

Oops -- got my sender header mixed up somehow.  Sorry 'bout that Gong :(

Gong, I think I'd like to go with the above patch for now and then take a closer
look at fixing the fixup_irqs() in another patch.  The reason is that I think
the above patch is critical for getting cpu hotplug working with large systems
with many devices.

I'm going to do more testing and will resubmit the patch later in the day.

P.
