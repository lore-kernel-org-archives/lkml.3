Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3L0QNP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 11:13:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751739Ab3L0QNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 11:13:13 -0500
Message-ID: <52BDA70C.1080508@redhat.com>
Date: Fri, 27 Dec 2013 11:13:00 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86, irq, fix logical AND/OR error in check_irq_vectors_for_cpu_disable()
References: <1387809552-20529-1-git-send-email-prarit@redhat.com> <20131224025059.GA24419@gchen.bj.intel.com> <52B989CD.6060403@redhat.com> <20131225024048.GA29542@gchen.bj.intel.com>
In-Reply-To: <20131225024048.GA29542@gchen.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/24/2013 09:40 PM, Chen, Gong wrote:
> On Tue, Dec 24, 2013 at 08:19:09AM -0500, Prarit Bhargava wrote:
>> On 12/23/2013 09:51 PM, Chen, Gong wrote:
>>> On Mon, Dec 23, 2013 at 09:39:12AM -0500, Prarit Bhargava wrote:
>>>> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
>>>> index 7d40698..aed7acc 100644
>>>> --- a/arch/x86/kernel/irq.c
>>>> +++ b/arch/x86/kernel/irq.c
>>>> @@ -281,7 +281,7 @@ int check_irq_vectors_for_cpu_disable(void)
>>>>  			desc = irq_to_desc(irq);
>>>>  			data = irq_desc_get_irq_data(desc);
>>>>  			affinity = data->affinity;
>>>> -			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
>>>> +			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>>>>  			    !cpumask_subset(affinity, cpu_online_mask))
>>>>  				this_count++;
>>> Hi, Prarit
>>>
>>> I noticed that you don't mention another question I asked in last mail.
>>>
>>> "It looks like cpu_online_mask will be updated until cpu_disable_common
>>> is called, but your check_vectors is called before that."
>>
>> Oh, I'm sorry ... Yes, check_irq_vectors_for_cpu_disable() is called before we
>> remove the CPU from the maps.  If there is an error then we have to do much less
>> clean up of the code.  I explicitly take into account the cpu that is being
>> downed into the check vectors code.
>>
> Here is my question: How to decide this_count can be incrased?
> 1) it is a valid irq(irq_has_action) 2) it is not percpu irq(!irqd_is_per_cpu)
> 3) it is not shared with left online cpus(!cpumask_subset)
> 
> For item 3, I have some concerns.
> Your current codes are called before cpu_disable_common, so affinity and
> cpu_online_mask are both not updated. BTW, it means your calculation
> for count is not correct because it concludes one to-be-off-lined cpu
> 
> +       for_each_online_cpu(cpu) {
> +               if (cpu == smp_processor_id())
> +                       continue;
> +               for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
> +                    vector++) {
> +                       if (per_cpu(vector_irq, cpu)[vector] < 0)
> +                               count++;
> +               }
> +       }
> 
> Back to my question, assume cpu1 will be off-lined and one irq affinity is
> set as (1, 2) -- this irq will be bypassed. Looks good. But if one irq
> affinity is set as only (1), -- this irq is bypassed, too. Not right!

Oh, yes, this is a bug.  ... and as you point out ...

> 
> Furthermore, you even can't use cpumask_subset as evaluation condition,
> whatever affinity/cpu_online_mask is updated or not. Let me paste the
> comment of cpumask_subset:
> /**
>  * cpumask_subset - (*src1p & ~*src2p) == 0
>  * @src1p: the first input
>  * @src2p: the second input
>  *
>  * Returns 1 if *@src1p is a subset of *@src2p, else returns 0
>  */
> Here we can see, even if src1p is an empty set, it still can be considered
> as the subset of src2p. For our this special case, I mean cpu1 will
> be off-lined and one irq affinity is set as (1). If this irq affinity
> is updated to (0), it means no cpu is bound to this irq, but the
> calculation of cpumask_subset will return true and this irq will be
> bypassed. For this case, cpumask_empty should be more suitable.

I definitely should have used cpumask_empty().  I'll retest ...

P.
