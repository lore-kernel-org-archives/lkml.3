Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536Ab3AQNHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:07:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755955Ab3AQNG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:06:59 -0500
Date: Thu, 17 Jan 2013 15:06:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v6 1/3] KVM: x86: clean up reexecute_instruction
Message-ID: <20130117130655.GC31120@redhat.com>
References: <50F2D64C.4030804@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F2D64C.4030804@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the series:
Reviewed-by: Gleb Natapov <gleb@redhat.com>

On Sun, Jan 13, 2013 at 11:44:12PM +0800, Xiao Guangrong wrote:
> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
> retry_instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |   13 ++++++-------
>  1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1c9c834..08cacd9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4761,19 +4761,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>  	if (tdp_enabled)
>  		return false;
> 
> +	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
> +	if (gpa == UNMAPPED_GVA)
> +		return true; /* let cpu generate fault */
> +
>  	/*
>  	 * if emulation was due to access to shadowed page table
>  	 * and it failed try to unshadow page and re-enter the
>  	 * guest to let CPU execute the instruction.
>  	 */
> -	if (kvm_mmu_unprotect_page_virt(vcpu, gva))
> +	if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
>  		return true;
> 
> -	gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
> -
> -	if (gpa == UNMAPPED_GVA)
> -		return true; /* let cpu generate fault */
> -
>  	/*
>  	 * Do not retry the unhandleable instruction if it faults on the
>  	 * readonly host memory, otherwise it will goto a infinite loop:
> @@ -4828,7 +4827,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>  	if (!vcpu->arch.mmu.direct_map)
>  		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> 
> -	kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +	kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> 
>  	return true;
>  }
> -- 
> 1.7.7.6

--
			Gleb.
