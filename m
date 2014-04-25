Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaDYR2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:28:15 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:41791 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752141AbaDYR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:28:14 -0400
Message-ID: <535A9B23.9060105@arm.com>
Date: Fri, 25 Apr 2014 18:28:03 +0100
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Salter <msalter@redhat.com>
CC: Christoffer Dall <christoffer.dall@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] arm: KVM: fix possible misalignment of PGDs and bounce
 page
References: <1396016719-13807-1-git-send-email-msalter@redhat.com>  <20140328193733.GL25519@cbox>  <e44e99a81131febf3b97edd9b099b859@www.loen.fr> <1398445293.3010.77.camel@deneb.redhat.com>
In-Reply-To: <1398445293.3010.77.camel@deneb.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 18:01, Mark Salter wrote:
> Ping. Can we get this into 3.15rc as a bug fix? Anything I can help
> with?

It sure has to go in. I'll queue it.

Thanks for the reminder.

	M.

> On Sat, 2014-03-29 at 14:01 +0000, Marc Zyngier wrote:
>> On 2014-03-28 19:37, Christoffer Dall wrote:
>>> On Fri, Mar 28, 2014 at 10:25:19AM -0400, Mark Salter wrote:
>>>> The kvm/mmu code shared by arm and arm64 uses kalloc() to allocate
>>>> a bounce page (if hypervisor init code crosses page boundary) and
>>>> hypervisor PGDs. The problem is that kalloc() does not guarantee
>>>> the proper alignment. In the case of the bounce page, the page sized
>>>> buffer allocated may also cross a page boundary negating the purpose
>>>> and leading to a hang during kvm initialization. Likewise the PGDs
>>>> allocated may not meet the minimum alignment requirements of the
>>>> underlying MMU. This patch uses __get_free_page() to guarantee the
>>>> worst case alignment needs of the bounce page and PGDs on both arm
>>>> and arm64.
>>>>
>>>> Signed-off-by: Mark Salter <msalter@redhat.com>
>>>> ---
>>>>  arch/arm/kvm/mmu.c | 15 +++++++++------
>>>>  1 file changed, 9 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>>>> index 7789857..575d790 100644
>>>> --- a/arch/arm/kvm/mmu.c
>>>> +++ b/arch/arm/kvm/mmu.c
>>>> @@ -42,6 +42,8 @@ static unsigned long hyp_idmap_start;
>>>>  static unsigned long hyp_idmap_end;
>>>>  static phys_addr_t hyp_idmap_vector;
>>>>
>>>> +#define pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>>>> +
>>>>  #define kvm_pmd_huge(_x)	(pmd_huge(_x) || pmd_trans_huge(_x))
>>>>
>>>>  static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t 
>>>> ipa)
>>>> @@ -199,14 +201,14 @@ void free_boot_hyp_pgd(void)
>>>>  	if (boot_hyp_pgd) {
>>>>  		unmap_range(NULL, boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>>>  		unmap_range(NULL, boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
>>>> -		kfree(boot_hyp_pgd);
>>>> +		free_pages((unsigned long)boot_hyp_pgd, pgd_order);
>>>>  		boot_hyp_pgd = NULL;
>>>>  	}
>>>>
>>>>  	if (hyp_pgd)
>>>>  		unmap_range(NULL, hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
>>>>
>>>> -	kfree(init_bounce_page);
>>>> +	free_page((unsigned long)init_bounce_page);
>>>>  	init_bounce_page = NULL;
>>>>
>>>>  	mutex_unlock(&kvm_hyp_pgd_mutex);
>>>> @@ -236,7 +238,7 @@ void free_hyp_pgds(void)
>>>>  		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += 
>>>> PGDIR_SIZE)
>>>>  			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
>>>>
>>>> -		kfree(hyp_pgd);
>>>> +		free_pages((unsigned long)hyp_pgd, pgd_order);
>>>>  		hyp_pgd = NULL;
>>>>  	}
>>>>
>>>> @@ -930,7 +932,7 @@ int kvm_mmu_init(void)
>>>>  		size_t len = __hyp_idmap_text_end - __hyp_idmap_text_start;
>>>>  		phys_addr_t phys_base;
>>>>
>>>> -		init_bounce_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>>>> +		init_bounce_page = (void *)__get_free_page(GFP_KERNEL);
>>>>  		if (!init_bounce_page) {
>>>>  			kvm_err("Couldn't allocate HYP init bounce page\n");
>>>>  			err = -ENOMEM;
>>>> @@ -956,8 +958,9 @@ int kvm_mmu_init(void)
>>>>  			 (unsigned long)phys_base);
>>>>  	}
>>>>
>>>> -	hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
>>>> -	boot_hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
>>>> +	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 
>>>> pgd_order);
>>>> +	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 
>>>> pgd_order);
>>>> +
>>>>  	if (!hyp_pgd || !boot_hyp_pgd) {
>>>>  		kvm_err("Hyp mode PGD not allocated\n");
>>>>  		err = -ENOMEM;
>>>> --
>>>> 1.8.5.3
>>>>
>>> This looks right to me.  Funnily enough I seem to remember a 
>>> discussion
>>> from when we originally merged this code where someone (maybe me) 
>>> argued
>>> that kmalloc() would align to the size of the allocation, but I don't
>>> see anything backing this up at this point.
>>>
>>> So:
>>>
>>> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>>>
>>> If Marc agrees I can queue this for -rc1.
>>
>> Looks good to me indeed.
>>
>> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
>>
>>          M.
> 
> 
> 


-- 
Jazz is not dead. It just smells funny...
