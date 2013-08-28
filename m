Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab3H1HXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 03:23:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4910 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab3H1HXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 03:23:48 -0400
Date: Wed, 28 Aug 2013 10:23:42 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 06/12] KVM: MMU: flush tlb if the spte can be locklessly
 modified
Message-ID: <20130828072342.GM22899@redhat.com>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375189330-24066-7-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:02:04PM +0800, Xiao Guangrong wrote:
> Relax the tlb flush condition since we will write-protect the spte out of mmu
> lock. Note lockless write-protection only marks the writable spte to readonly
> and the spte can be writable only if both SPTE_HOST_WRITEABLE and
> SPTE_MMU_WRITEABLE are set (that are tested by spte_is_locklessly_modifiable)
> 
> This patch is used to avoid this kind of race:
> 
>       VCPU 0                         VCPU 1
> lockless wirte protection:
>       set spte.w = 0
>                                  lock mmu-lock
> 
>                                  write protection the spte to sync shadow page,
>                                  see spte.w = 0, then without flush tlb
> 
> 				 unlock mmu-lock
> 
>                                  !!! At this point, the shadow page can still be
>                                      writable due to the corrupt tlb entry
>      Flush all TLB
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 58283bf..5a40564 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -600,7 +600,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
>  	 * we always atomicly update it, see the comments in
>  	 * spte_has_volatile_bits().
>  	 */
> -	if (is_writable_pte(old_spte) && !is_writable_pte(new_spte))
> +	if (spte_is_locklessly_modifiable(old_spte) &&
> +	      !is_writable_pte(new_spte))
>  		ret = true;
This will needlessly flush tlbs when dirty login is not in use (common
case) and old spte is non writable. Can you estimate how serious the
performance hit is?

>  
>  	if (!shadow_accessed_mask)
> -- 
> 1.8.1.4

--
			Gleb.
