Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab3KNAgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 19:36:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab3KNAg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 19:36:29 -0500
Date: Wed, 13 Nov 2013 22:36:10 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 04/15] KVM: MMU: flush tlb out of mmu lock when
 write-protect the sptes
Message-ID: <20131114003609.GA15692@amt.cnet>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382534973-13197-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 23, 2013 at 09:29:22PM +0800, Xiao Guangrong wrote:
> Now we can flush all the TLBs out of the mmu lock without TLB corruption when
> write-proect the sptes, it is because:
> - we have marked large sptes readonly instead of dropping them that means we
>   just change the spte from writable to readonly so that we only need to care
>   the case of changing spte from present to present (changing the spte from
>   present to nonpresent will flush all the TLBs immediately), in other words,
>   the only case we need to care is mmu_spte_update()

Xiao,

Any code location which reads the writable bit in the spte and assumes if its not
set, that the translation which the spte refers to is not cached in a
remote CPU's TLB can become buggy. (*)

It might be the case that now its not an issue, but its so subtle that
it should be improved.

Can you add a fat comment on top of is_writeable_bit describing this?
(and explain why is_writable_pte users do not make an assumption
about (*). 

"Writeable bit of locklessly modifiable sptes might be cleared
but TLBs not flushed: so whenever reading locklessly modifiable sptes
you cannot assume TLBs are flushed".

For example this one is unclear:

                if (!can_unsync && is_writable_pte(*sptep))
                        goto set_pte;
And:

        if (!is_writable_pte(spte) &&
              !(pt_protect && spte_is_locklessly_modifiable(spte)))
                return false;

This is safe because get_dirty_log/kvm_mmu_slot_remove_write_access are
serialized by a single mutex (if there were two mutexes, it would not be
safe). Can you add an assert to both
kvm_mmu_slot_remove_write_access/kvm_vm_ioctl_get_dirty_log 
for (slots_lock) is locked, and explain?

So just improve the comments please, thanks (no need to resend whole
series).

> - in mmu_spte_update(), we haved checked
>   SPTE_HOST_WRITEABLE | PTE_MMU_WRITEABLE instead of PT_WRITABLE_MASK, that
>   means it does not depend on PT_WRITABLE_MASK anymore
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 18 ++++++++++++++----
>  arch/x86/kvm/x86.c |  9 +++++++--
>  2 files changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 62f18ec..337d173 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4273,15 +4273,25 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
>  			if (*rmapp)
>  				__rmap_write_protect(kvm, rmapp, false);
>  
> -			if (need_resched() || spin_needbreak(&kvm->mmu_lock)) {
> -				kvm_flush_remote_tlbs(kvm);
> +			if (need_resched() || spin_needbreak(&kvm->mmu_lock))
>  				cond_resched_lock(&kvm->mmu_lock);
> -			}
>  		}
>  	}
>  
> -	kvm_flush_remote_tlbs(kvm);
>  	spin_unlock(&kvm->mmu_lock);
> +
> +	/*
> +	 * We can flush all the TLBs out of the mmu lock without TLB
> +	 * corruption since we just change the spte from writable to
> +	 * readonly so that we only need to care the case of changing
> +	 * spte from present to present (changing the spte from present
> +	 * to nonpresent will flush all the TLBs immediately), in other
> +	 * words, the only case we care is mmu_spte_update() where we
> +	 * haved checked SPTE_HOST_WRITEABLE | SPTE_MMU_WRITEABLE
> +	 * instead of PT_WRITABLE_MASK, that means it does not depend
> +	 * on PT_WRITABLE_MASK anymore.
> +	 */
> +	kvm_flush_remote_tlbs(kvm);
>  }
>  
>  #define BATCH_ZAP_PAGES	10
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b3aa650..573c6b3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3571,11 +3571,16 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
>  		offset = i * BITS_PER_LONG;
>  		kvm_mmu_write_protect_pt_masked(kvm, memslot, offset, mask);
>  	}
> -	if (is_dirty)
> -		kvm_flush_remote_tlbs(kvm);
>  
>  	spin_unlock(&kvm->mmu_lock);
>  
> +	/*
> +	 * All the TLBs can be flushed out of mmu lock, see the comments in
> +	 * kvm_mmu_slot_remove_write_access().
> +	 */
> +	if (is_dirty)
> +		kvm_flush_remote_tlbs(kvm);
> +
>  	r = -EFAULT;
>  	if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
>  		goto out;
> -- 
> 1.8.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
