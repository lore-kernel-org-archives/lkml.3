Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaDAMzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:55:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbaDAMzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:55:46 -0400
Message-ID: <533AB741.5080508@redhat.com>
Date: Tue, 01 Apr 2014 08:55:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, shli@kernel.org,
        akpm@linux-foundation.org, hughd@google.com, mgorman@suse.de,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86,mm: delay TLB flush after clearing accessed bit
References: <20140331113442.0d628362@annuminas.surriel.com> <20140401105318.GA2823@gmail.com>
In-Reply-To: <20140401105318.GA2823@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 06:53 AM, Ingo Molnar wrote:
> 
> The speedup looks good to me!
> 
> I have one major concern (see the last item), plus a few minor nits:

I will address all the minor issues. Let me explain the major one :)

>> @@ -196,6 +201,13 @@ static inline void reset_lazy_tlbstate(void)
>>  	this_cpu_write(cpu_tlbstate.active_mm, &init_mm);
>>  }
>>  
>> +static inline void tlb_set_force_flush(int cpu)
>> +{
>> +	struct tlb_state *percputlb= &per_cpu(cpu_tlbstate, cpu);
> 
> s/b= /b = /
> 
>> +	if (percputlb->force_flush == false)
>> +		percputlb->force_flush = true;
>> +}
>> +
>>  #endif	/* SMP */

This code does a test before the set, so each cache line will only be
grabbed exclusively once, if there is heavy pageout scanning activity.

>> @@ -399,11 +400,13 @@ int pmdp_test_and_clear_young(struct vm_area_struct *vma,
>>  int ptep_clear_flush_young(struct vm_area_struct *vma,
>>  			   unsigned long address, pte_t *ptep)
>>  {
>> -	int young;
>> +	int young, cpu;
>>  
>>  	young = ptep_test_and_clear_young(vma, address, ptep);
>> -	if (young)
>> -		flush_tlb_page(vma, address);
>> +	if (young) {
>> +		for_each_cpu(cpu, vma->vm_mm->cpu_vm_mask_var)
>> +			tlb_set_force_flush(cpu);
> 
> Hm, just to play the devil's advocate - what happens when we have a va 
> that is used on a few dozen, a few hundred or a few thousand CPUs? 
> Will the savings be dwarved by the O(nr_cpus_used) loop overhead?
> 
> Especially as this is touching cachelines on other CPUs and likely 
> creating the worst kind of cachemisses. That can really kill 
> performance.

flush_tlb_page does the same O(nr_cpus_used) loop, but it sends an
IPI to each CPU every time, instead of dirtying a cache line once
per pageout run (or until the next context switch).

Does that address your concern?

-- 
All rights reversed
