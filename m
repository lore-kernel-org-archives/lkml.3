Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3LXNTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 08:19:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3LXNTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 08:19:18 -0500
Message-ID: <52B989CD.6060403@redhat.com>
Date: Tue, 24 Dec 2013 08:19:09 -0500
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
References: <1387809552-20529-1-git-send-email-prarit@redhat.com> <20131224025059.GA24419@gchen.bj.intel.com>
In-Reply-To: <20131224025059.GA24419@gchen.bj.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/23/2013 09:51 PM, Chen, Gong wrote:
> On Mon, Dec 23, 2013 at 09:39:12AM -0500, Prarit Bhargava wrote:
>> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
>> index 7d40698..aed7acc 100644
>> --- a/arch/x86/kernel/irq.c
>> +++ b/arch/x86/kernel/irq.c
>> @@ -281,7 +281,7 @@ int check_irq_vectors_for_cpu_disable(void)
>>  			desc = irq_to_desc(irq);
>>  			data = irq_desc_get_irq_data(desc);
>>  			affinity = data->affinity;
>> -			if (irq_has_action(irq) || !irqd_is_per_cpu(data) ||
>> +			if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
>>  			    !cpumask_subset(affinity, cpu_online_mask))
>>  				this_count++;
> Hi, Prarit
> 
> I noticed that you don't mention another question I asked in last mail.
> 
> "It looks like cpu_online_mask will be updated until cpu_disable_common
> is called, but your check_vectors is called before that."

Oh, I'm sorry ... Yes, check_irq_vectors_for_cpu_disable() is called before we
remove the CPU from the maps.  If there is an error then we have to do much less
clean up of the code.  I explicitly take into account the cpu that is being
downed into the check vectors code.


> 
> native_cpu_disable		
>         cpu_disable_common
>                 remove_cpu_from_maps
>                         /*
>                          * until here, cpu_online_mask/cpu_online_bits
>                          * is cleared
>                          */
>                         set_cpu_online(cpu, false);
> 
> Something I missed?

No -- are you pointing out a bug?

P.
