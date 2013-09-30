Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab3I3XJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 19:09:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab3I3XJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 19:09:06 -0400
Date: Mon, 30 Sep 2013 20:05:24 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 05/15] KVM: MMU: flush tlb out of mmu lock when
 write-protect the sptes
Message-ID: <20130930230524.GB31805@amt.cnet>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1378376958-27252-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378376958-27252-6-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 06:29:08PM +0800, Xiao Guangrong wrote:
> Now we can flush all the TLBs out of the mmu lock without TLB corruption when
> write-proect the sptes, it is because:
> - we have marked large sptes readonly instead of dropping them that means we
>   just change the spte from writable to readonly so that we only need to care
>   the case of changing spte from present to present (changing the spte from
>   present to nonpresent will flush all the TLBs immediately), in other words,
>   the only case we need to care is mmu_spte_update()
> 
> - in mmu_spte_update(), we have checked
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
> index 7488229..a983570 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4320,15 +4320,25 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
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

What about need_remote_flush? 

