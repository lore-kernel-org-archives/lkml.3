Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3G3N0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:26:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab3G3N0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:26:46 -0400
Message-ID: <51F7BF00.5060703@redhat.com>
Date: Tue, 30 Jul 2013 15:26:24 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte writable
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 30/07/2013 15:02, Xiao Guangrong ha scritto:
> Make sure we can see the writable spte before the dirt bitmap is visible
> 
> We do this is for kvm_vm_ioctl_get_dirty_log() write-protects the spte based
> on the dirty bitmap, we should ensure the writable spte can be found in rmap
> before the dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and
> failed to write-protect the page
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 35d4b50..0fe56ad 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2486,12 +2486,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		}
>  	}
>  
> -	if (pte_access & ACC_WRITE_MASK)
> -		mark_page_dirty(vcpu->kvm, gfn);
> -
>  set_pte:
>  	if (mmu_spte_update(sptep, spte))
>  		kvm_flush_remote_tlbs(vcpu->kvm);
> +
> +	if (pte_access & ACC_WRITE_MASK)
> +		mark_page_dirty(vcpu->kvm, gfn);
>  done:
>  	return ret;
>  }
> 

What about this comment above:

                /*
                 * Optimization: for pte sync, if spte was writable the hash
                 * lookup is unnecessary (and expensive). Write protection
                 * is responsibility of mmu_get_page / kvm_sync_page.
                 * Same reasoning can be applied to dirty page accounting.
                 */
                if (!can_unsync && is_writable_pte(*sptep))
                        goto set_pte;

                if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {


?

Should it be changed to

                if (!can_unsync && is_writable_pte(*sptep))
                        pte_access &= ~ACC_WRITE_MASK; /* do not mark dirty */

                else if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {

?

Thanks,

Paolo
