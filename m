Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaC2OCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 10:02:10 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:33281 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbaC2OCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 10:02:07 -0400
To: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] arm: KVM: fix possible misalignment of PGDs and bounce  page
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 29 Mar 2014 14:01:57 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Salter <msalter@redhat.com>, <kvmarm@lists.cs.columbia.edu>,
        Russell King <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>
Organization: ARM Ltd
In-Reply-To: <20140328193733.GL25519@cbox>
References: <1396016719-13807-1-git-send-email-msalter@redhat.com>
 <20140328193733.GL25519@cbox>
Message-ID: <e44e99a81131febf3b97edd9b099b859@www.loen.fr>
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: christoffer.dall@linaro.org, msalter@redhat.com, kvmarm@lists.cs.columbia.edu, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-03-28 19:37, Christoffer Dall wrote:
> On Fri, Mar 28, 2014 at 10:25:19AM -0400, Mark Salter wrote:
>> The kvm/mmu code shared by arm and arm64 uses kalloc() to allocate
>> a bounce page (if hypervisor init code crosses page boundary) and
>> hypervisor PGDs. The problem is that kalloc() does not guarantee
>> the proper alignment. In the case of the bounce page, the page sized
>> buffer allocated may also cross a page boundary negating the purpose
>> and leading to a hang during kvm initialization. Likewise the PGDs
>> allocated may not meet the minimum alignment requirements of the
>> underlying MMU. This patch uses __get_free_page() to guarantee the
>> worst case alignment needs of the bounce page and PGDs on both arm
>> and arm64.
>>
>> Signed-off-by: Mark Salter <msalter@redhat.com>
>> ---
>>  arch/arm/kvm/mmu.c | 15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 7789857..575d790 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -42,6 +42,8 @@ static unsigned long hyp_idmap_start;
>>  static unsigned long hyp_idmap_end;
>>  static phys_addr_t hyp_idmap_vector;
>>
>> +#define pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>> +
>>  #define kvm_pmd_huge(_x)	(pmd_huge(_x) || pmd_trans_huge(_x))
>>
>>  static void kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t 
>> ipa)
>> @@ -199,14 +201,14 @@ void free_boot_hyp_pgd(void)
>>  	if (boot_hyp_pgd) {
>>  		unmap_range(NULL, boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>>  		unmap_range(NULL, boot_hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
>> -		kfree(boot_hyp_pgd);
>> +		free_pages((unsigned long)boot_hyp_pgd, pgd_order);
>>  		boot_hyp_pgd = NULL;
>>  	}
>>
>>  	if (hyp_pgd)
>>  		unmap_range(NULL, hyp_pgd, TRAMPOLINE_VA, PAGE_SIZE);
>>
>> -	kfree(init_bounce_page);
>> +	free_page((unsigned long)init_bounce_page);
>>  	init_bounce_page = NULL;
>>
>>  	mutex_unlock(&kvm_hyp_pgd_mutex);
>> @@ -236,7 +238,7 @@ void free_hyp_pgds(void)
>>  		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += 
>> PGDIR_SIZE)
>>  			unmap_range(NULL, hyp_pgd, KERN_TO_HYP(addr), PGDIR_SIZE);
>>
>> -		kfree(hyp_pgd);
>> +		free_pages((unsigned long)hyp_pgd, pgd_order);
>>  		hyp_pgd = NULL;
>>  	}
>>
>> @@ -930,7 +932,7 @@ int kvm_mmu_init(void)
>>  		size_t len = __hyp_idmap_text_end - __hyp_idmap_text_start;
>>  		phys_addr_t phys_base;
>>
>> -		init_bounce_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
>> +		init_bounce_page = (void *)__get_free_page(GFP_KERNEL);
>>  		if (!init_bounce_page) {
>>  			kvm_err("Couldn't allocate HYP init bounce page\n");
>>  			err = -ENOMEM;
>> @@ -956,8 +958,9 @@ int kvm_mmu_init(void)
>>  			 (unsigned long)phys_base);
>>  	}
>>
>> -	hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
>> -	boot_hyp_pgd = kzalloc(PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
>> +	hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 
>> pgd_order);
>> +	boot_hyp_pgd = (pgd_t *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 
>> pgd_order);
>> +
>>  	if (!hyp_pgd || !boot_hyp_pgd) {
>>  		kvm_err("Hyp mode PGD not allocated\n");
>>  		err = -ENOMEM;
>> --
>> 1.8.5.3
>>
> This looks right to me.  Funnily enough I seem to remember a 
> discussion
> from when we originally merged this code where someone (maybe me) 
> argued
> that kmalloc() would align to the size of the allocation, but I don't
> see anything backing this up at this point.
>
> So:
>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
>
> If Marc agrees I can queue this for -rc1.

Looks good to me indeed.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

         M.
-- 
Fast, cheap, reliable. Pick two.
