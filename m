Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaDAN0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbaDAN01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:26:27 -0400
Message-ID: <533ABE71.9090507@redhat.com>
Date: Tue, 01 Apr 2014 09:26:09 -0400
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
References: <20140331113442.0d628362@annuminas.surriel.com> <20140401105318.GA2823@gmail.com> <533AB741.5080508@redhat.com> <20140401132037.GB7024@gmail.com>
In-Reply-To: <20140401132037.GB7024@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 09:20 AM, Ingo Molnar wrote:
> 
> * Rik van Riel <riel@redhat.com> wrote:
> 
>>>>  int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>  			   unsigned long address, pte_t *ptep)
>>>>  {
>>>> -	int young;
>>>> +	int young, cpu;
>>>>  
>>>>  	young = ptep_test_and_clear_young(vma, address, ptep);
>>>> -	if (young)
>>>> -		flush_tlb_page(vma, address);
>>>> +	if (young) {
>>>> +		for_each_cpu(cpu, vma->vm_mm->cpu_vm_mask_var)
>>>> +			tlb_set_force_flush(cpu);
>>>
>>> Hm, just to play the devil's advocate - what happens when we have 
>>> a va that is used on a few dozen, a few hundred or a few thousand 
>>> CPUs? Will the savings be dwarved by the O(nr_cpus_used) loop 
>>> overhead?
>>>
>>> Especially as this is touching cachelines on other CPUs and likely 
>>> creating the worst kind of cachemisses. That can really kill 
>>> performance.
>>
>> flush_tlb_page does the same O(nr_cpus_used) loop, but it sends an 
>> IPI to each CPU every time, instead of dirtying a cache line once 
>> per pageout run (or until the next context switch).
>>
>> Does that address your concern?
> 
> That depends on the platform - which could implement flush_tlb_page() 
> as a broadcast IPI - but yes, it was bad before as well, now it became 
> more visible and I noticed it :)
> 
> Wouldn't it be more scalable to use a generation count as a timestamp, 
> and set that in the mm? mm that last flushed before that timestamp 
> need to flush, or so. That gets rid of the mask logic and the loop, 
> AFAICS.

More scalable in the page eviction code, sure.

However, that would cause the context switch code to load an
additional cache line, so I am not convinced that is a good
tradeoff...

-- 
All rights reversed
