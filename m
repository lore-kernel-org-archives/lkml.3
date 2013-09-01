Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab3IAJSA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 05:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753027Ab3IAJR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 05:17:58 -0400
Date: Sun, 1 Sep 2013 12:17:44 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
Message-ID: <20130901091744.GF22899@redhat.com>
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 02:41:37PM +0200, Paolo Bonzini wrote:
> Page tables in a read-only memory slot will currently cause a triple
> fault because the page walker uses gfn_to_hva and it fails on such a slot.
> 
> OVMF uses such a page table; however, real hardware seems to be fine with
> that as long as the accessed/dirty bits are set.  Save whether the slot
> is readonly, and later check it when updating the accessed and dirty bits.
> 
The fix looks OK to me, but some comment below.

> Cc: stable@vger.kernel.org
> Cc: gleb@redhat.com
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	CCing to stable@ since the regression was introduced with
> 	support for readonly memory slots.
> 
>  arch/x86/kvm/paging_tmpl.h |  7 ++++++-
>  include/linux/kvm_host.h   |  1 +
>  virt/kvm/kvm_main.c        | 14 +++++++++-----
>  3 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
> index 0433301..dadc5c0 100644
> --- a/arch/x86/kvm/paging_tmpl.h
> +++ b/arch/x86/kvm/paging_tmpl.h
> @@ -99,6 +99,7 @@ struct guest_walker {
>  	pt_element_t prefetch_ptes[PTE_PREFETCH_NUM];
>  	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
>  	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
> +	bool pte_writable[PT_MAX_FULL_LEVELS];
>  	unsigned pt_access;
>  	unsigned pte_access;
>  	gfn_t gfn;
> @@ -235,6 +236,9 @@ static int FNAME(update_accessed_dirty_bits)(struct kvm_vcpu *vcpu,
>  		if (pte == orig_pte)
>  			continue;
>  
> +		if (unlikely(!walker->pte_writable[level - 1]))
> +			return -EACCES;
> +
>  		ret = FNAME(cmpxchg_gpte)(vcpu, mmu, ptep_user, index, orig_pte, pte);
>  		if (ret)
>  			return ret;
> @@ -309,7 +313,8 @@ retry_walk:
>  			goto error;
>  		real_gfn = gpa_to_gfn(real_gfn);
>  
> -		host_addr = gfn_to_hva(vcpu->kvm, real_gfn);
> +		host_addr = gfn_to_hva_read(vcpu->kvm, real_gfn,
> +					    &walker->pte_writable[walker->level - 1]);
The use of gfn_to_hva_read is misleading. The code can still write into
gfn. Lets rename gfn_to_hva_read to gfn_to_hva_prot() and gfn_to_hva()
to gfn_to_hva_write().

This makes me think are there other places where gfn_to_hva() was
used, but gfn_to_hva_prot() should have been?
 - kvm_host_page_size() looks incorrect. We never use huge page to map
   read only memory slots currently.
 - kvm_handle_bad_page() also looks incorrect and may cause incorrect
   address to be reported to userspace.
 - kvm_setup_async_pf() also incorrect. Makes all page fault on read
   only slot to be sync.
 - kvm_vm_fault() one looks OK since function assumes write only slots,
   but it is obsolete and should be deleted anyway.

Others in generic and x86 code looks OK, somebody need to check ppc and
arm code.


>  		if (unlikely(kvm_is_error_hva(host_addr)))
>  			goto error;
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ca645a0..22f9cdf 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -533,6 +533,7 @@ int gfn_to_page_many_atomic(struct kvm *kvm, gfn_t gfn, struct page **pages,
>  
>  struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
>  unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn);
> +unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn, bool *writable);
>  unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn);
>  void kvm_release_page_clean(struct page *page);
>  void kvm_release_page_dirty(struct page *page);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f7e4334..418d037 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1078,11 +1078,15 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
>  EXPORT_SYMBOL_GPL(gfn_to_hva);
>  
>  /*
> - * The hva returned by this function is only allowed to be read.
> - * It should pair with kvm_read_hva() or kvm_read_hva_atomic().
> + * If writable is set to false, the hva returned by this function is only
> + * allowed to be read.
>   */
> -static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
> +unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn, bool *writable)
>  {
> +	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> +	if (writable)
> +		*writable = !memslot_is_readonly(slot);
> +
>  	return __gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL, false);
>  }
>  
> @@ -1450,7 +1454,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  	int r;
>  	unsigned long addr;
>  
> -	addr = gfn_to_hva_read(kvm, gfn);
> +	addr = gfn_to_hva_read(kvm, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
>  	r = kvm_read_hva(data, (void __user *)addr + offset, len);
> @@ -1488,7 +1492,7 @@ int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
>  	gfn_t gfn = gpa >> PAGE_SHIFT;
>  	int offset = offset_in_page(gpa);
>  
> -	addr = gfn_to_hva_read(kvm, gfn);
> +	addr = gfn_to_hva_read(kvm, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
>  	pagefault_disable();
> -- 
> 1.8.3.1

--
			Gleb.
