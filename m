Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316AbaEGO4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 10:56:09 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:47533 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaEGO4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 10:56:05 -0400
Date: Wed, 7 May 2014 07:55:57 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Kim Phillips <kim.phillips@linaro.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] ARM: KVM: user_mem_abort: support stage 2 MMIO page
 mapping
Message-ID: <20140507145557.GJ3066@lvm>
References: <1395785294-2545-1-git-send-email-kim.phillips@linaro.org>
 <1395785294-2545-2-git-send-email-kim.phillips@linaro.org>
 <20140506180448.GH3066@lvm>
 <87bnvaotei.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bnvaotei.fsf@approximate.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 10:00:21AM +0100, Marc Zyngier wrote:
> Kim, Christoffer,
> 
> On Tue, May 06 2014 at  7:04:48 pm BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> > On Tue, Mar 25, 2014 at 05:08:14PM -0500, Kim Phillips wrote:
> >> Use the correct memory type for device MMIO mappings: PAGE_S2_DEVICE.
> >> 
> >> Signed-off-by: Kim Phillips <kim.phillips@linaro.org>
> >> ---
> >>  arch/arm/kvm/mmu.c | 11 ++++++++---
> >>  1 file changed, 8 insertions(+), 3 deletions(-)
> >> 
> >> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> >> index 7789857..a354610 100644
> >> --- a/arch/arm/kvm/mmu.c
> >> +++ b/arch/arm/kvm/mmu.c
> >> @@ -652,6 +652,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>  	struct kvm_mmu_memory_cache *memcache = &vcpu->arch.mmu_page_cache;
> >>  	struct vm_area_struct *vma;
> >>  	pfn_t pfn;
> >> +	pgprot_t mem_type = PAGE_S2;
> >>  
> >>  	write_fault = kvm_is_write_fault(kvm_vcpu_get_hsr(vcpu));
> >>  	if (fault_status == FSC_PERM && !write_fault) {
> >> @@ -702,6 +703,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>  	if (is_error_pfn(pfn))
> >>  		return -EFAULT;
> >>  
> >> +	if (kvm_is_mmio_pfn(pfn))
> >> +		mem_type = PAGE_S2_DEVICE;
> >> +
> >>  	spin_lock(&kvm->mmu_lock);
> >>  	if (mmu_notifier_retry(kvm, mmu_seq))
> >>  		goto out_unlock;
> >> @@ -709,7 +713,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>  		hugetlb = transparent_hugepage_adjust(&pfn, &fault_ipa);
> >>  
> >>  	if (hugetlb) {
> >> -		pmd_t new_pmd = pfn_pmd(pfn, PAGE_S2);
> >> +		pmd_t new_pmd = pfn_pmd(pfn, mem_type);
> >>  		new_pmd = pmd_mkhuge(new_pmd);
> >>  		if (writable) {
> >>  			kvm_set_s2pmd_writable(&new_pmd);
> >> @@ -718,13 +722,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >>  		coherent_icache_guest_page(kvm, hva & PMD_MASK, PMD_SIZE);
> >>  		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
> >>  	} else {
> >> -		pte_t new_pte = pfn_pte(pfn, PAGE_S2);
> >> +		pte_t new_pte = pfn_pte(pfn, mem_type);
> >>  		if (writable) {
> >>  			kvm_set_s2pte_writable(&new_pte);
> >>  			kvm_set_pfn_dirty(pfn);
> >>  		}
> >>  		coherent_icache_guest_page(kvm, hva, PAGE_SIZE);
> >> -		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, false);
> >> +		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte,
> >> +				     mem_type == PAGE_S2_DEVICE);
> >>  	}
> >>  
> >>  
> >> -- 
> >> 1.9.1
> >> 
> >
> > I think this looks reasonable.
> >
> > Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 
> I feel like I'm missing some context here, and the commit message is way
> too terse for me to make sense of it.
> 
> So far, we can only get into user_mem_abort on a Stage-2 fault
> (translation or permission) for memory. How can we suddenly get here for
> a *device* fault? Do we get a special kind of memslot?
> 
> I'm not saying the patch does anything wrong, but I'd like to understand
> the rationale behind it. On its own, it doesn't make much sense.
> 
Think device passthrough.  There's nothing preventing user space from
setting up a memory region to point to device memory (through VFIO or
/dev/mem).  If that's done, we should enforce device memory properties
so writes don't linger around in the cache to be written some time later
when that device memory potentially doesn't belong to the VM anymore.

This is just one tiny piece of all of them to make device passthrough
work, and we could hold off with this patch until we have something more
complete.  On the other hand, we need to start somewhere, and this is
hardly intrusive and is functionally correct even though you don't have
a full device passthrough setup.

-Christoffer
