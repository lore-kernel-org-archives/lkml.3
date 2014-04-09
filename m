Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaDIOw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:52:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807AbaDIOw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:52:27 -0400
Date: Wed, 9 Apr 2014 11:51:37 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@kernel.org, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: MMU: flush tlb out of mmu lock when
 write-protect the sptes
Message-ID: <20140409145137.GA23449@amt.cnet>
References: <1394460109-3150-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1394460109-3150-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394460109-3150-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 10:01:49PM +0800, Xiao Guangrong wrote:
> Now we can flush all the TLBs out of the mmu lock without TLB corruption when
> write-proect the sptes, it is because:
> - we have marked large sptes readonly instead of dropping them that means we
>   just change the spte from writable to readonly so that we only need to care
>   the case of changing spte from present to present (changing the spte from
>   present to nonpresent will flush all the TLBs immediately), in other words,
>   the only case we need to care is mmu_spte_update()
> 
> - in mmu_spte_update(), we haved checked
>   SPTE_HOST_WRITEABLE | PTE_MMU_WRITEABLE instead of PT_WRITABLE_MASK, that
>   means it does not depend on PT_WRITABLE_MASK anymore
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 25 +++++++++++++++++++++----
>  arch/x86/kvm/mmu.h | 14 ++++++++++++++
>  arch/x86/kvm/x86.c | 12 ++++++++++--
>  3 files changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 17bb136..01a8c35 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4281,15 +4281,32 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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
> +	 * kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
> +	 * which do tlb flush out of mmu-lock should be serialized by
> +	 * kvm->slots_lock otherwise tlb flush would be missed.
> +	 */
> +	lockdep_assert_held(&kvm->slots_lock);
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
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 2926152..585d6b1 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -96,6 +96,20 @@ static inline int is_present_gpte(unsigned long pte)
>  	return pte & PT_PRESENT_MASK;
>  }
>  
> +/*
> + * Please note PT_WRITABLE_MASK is not stable since
> + * 1) fast_page_fault() sets spte from readonly to writable out of mmu-lock or
> + * 2) kvm_mmu_slot_remove_write_access() and kvm_vm_ioctl_get_dirty_log()
> + *    can write protect sptes but flush tlb out mmu-lock that means we may use
> + *    the corrupt tlb entries which depend on this bit.
> + *
> + * Both cases do not modify the status of  spte_is_locklessly_modifiable() so
> + * if you want to check whether the spte is writable on MMU you can check
> + * SPTE_MMU_WRITEABLE instead. If you want to update spte without losing
> + * A/D bits and tlb flush, you can check spte_is_locklessly_modifiable()
> + * instead. See the comments in spte_has_volatile_bits() and
> + * mmu_spte_update().
> + */
>  static inline int is_writable_pte(unsigned long pte)
>  {

Xiao,

Can't get the SPTE_MMU_WRITEABLE part.

So assume you are writing code to perform some action after guest memory
has been write protected. You would

spin_lock(mmu_lock);

if (writeable spte bit is set)
    remove writeable spte bit from spte
remote TLB flush            (*)
action

spin_unlock(mmu_lock);

(*) is necessary because reading the writeable spte bit as zero
does not guarantee remote TLBs have been flushed.

Now what SPTE_MMU_WRITEABLE has to do with it ?

Perhaps a recipe like that (or just the rules) would be useful.

The remaining patches look good.

