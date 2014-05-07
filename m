Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755801AbaEGJAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:00:36 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:10795 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751320AbaEGJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:00:34 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Kim Phillips <kim.phillips@linaro.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] ARM: KVM: user_mem_abort: support stage 2 MMIO page mapping
In-Reply-To: <20140506180448.GH3066@lvm> (Christoffer Dall's message of "Tue,
	6 May 2014 19:04:48 +0100")
Organization: ARM Ltd
References: <1395785294-2545-1-git-send-email-kim.phillips@linaro.org>
	<1395785294-2545-2-git-send-email-kim.phillips@linaro.org>
	<20140506180448.GH3066@lvm>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Wed, 07 May 2014 10:00:21 +0100
Message-ID: <87bnvaotei.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kim, Christoffer,

On Tue, May 06 2014 at  7:04:48 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Tue, Mar 25, 2014 at 05:08:14PM -0500, Kim Phillips wrote:
>> Use the correct memory type for device MMIO mappings: PAGE_S2_DEVICE.
>> 
>> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
>> ---
>>  arch/arm/kvm/mmu.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>> 
>> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
>> index 7789857..a354610 100644
>> --- a/arch/arm/kvm/mmu.c
>> +++ b/arch/arm/kvm/mmu.c
>> @@ -652,6 +652,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
>>  	struct vm_area_struct *vma;
>>  	pfn_t pfn;
>> +	pgprot_t mem_type = PAGE_S2;
>>  
>>  	write_fault = kvm_is_write_fault(kvm_vcpu_get_hsr(vcpu));
>>  	if (fault_status == FSC_PERM && !write_fault) {
>> @@ -702,6 +703,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (is_error_pfn(pfn))
>>  		return -EFAULT;
>>  
>> +	if (kvm_is_mmio_pfn(pfn))
>> +		mem_type = PAGE_S2_DEVICE;
>> +
>>  	spin_lock(&kvm->mmu_lock);
>>  	if (mmu_notifier_retry(kvm, mmu_seq))
>>  		goto out_unlock;
>> @@ -709,7 +713,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
>>  
>>  	if (hugetlb) {
>> -		pmd_t new_pmd = pfn_pmd(pfn, PAGE_S2);
>> +		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
>>  		new_pmd = pmd_mkhuge(new_pmd);
>>  		if (writable) {
>>  			kvm_set_s2pmd_writable(&new_pmd);
>> @@ -718,13 +722,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  		coherent_icache_guest_page(kvm, hva & PMD_MASK, PMD_SIZE);
>>  		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
>>  	} else {
>> -		pte_t new_pte = pfn_pte(pfn, PAGE_S2);
>> +		pte_t new_pte = pfn_pte(pfn, mem_type);
>>  		if (writable) {
>>  			kvm_set_s2pte_writable(&new_pte);
>>  			kvm_set_pfn_dirty(pfn);
>>  		}
>>  		coherent_icache_guest_page(kvm, hva, PAGE_SIZE);
>> -		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, false);
>> +		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte,
>> +				     mem_type == PAGE_S2_DEVICE);
>>  	}
>>  
>>  
>> -- 
>> 1.9.1
>> 
>
> I think this looks reasonable.
>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

I feel like I'm missing some context here, and the commit message is way
too terse for me to make sense of it.

So far, we can only get into user_mem_abort on a Stage-2 fault
(translation or permission) for memory. How can we suddenly get here for
a *device* fault? Do we get a special kind of memslot?

I'm not saying the patch does anything wrong, but I'd like to understand
the rationale behind it. On its own, it doesn't make much sense.

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny.
