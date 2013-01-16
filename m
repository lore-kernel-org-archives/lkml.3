Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab3APXVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:21:06 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:54789 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab3APXVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:21:05 -0500
References: <50F2D64C.4030804@linux.vnet.ibm.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <50F2D64C.4030804@linux.vnet.ibm.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <D45F69EE-C63A-4707-B497-7E68EEA15927@gmail.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
X-Mailer: iPhone Mail (10A523)
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v6 1/3] KVM: x86: clean up reexecute_instruction
Date: Thu, 17 Jan 2013 07:20:57 +0800
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping, ping, ping...... :(

Sent from my iPhone

On Jan 13, 2013, at 23:44, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Little cleanup for reexecute_instruction, also use gpa_to_gfn in
> retry_instruction
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
> arch/x86/kvm/x86.c |   13 ++++++-------
> 1 files changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1c9c834..08cacd9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4761,19 +4761,18 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gva_t gva)
>    if (tdp_enabled)
>        return false;
> 
> +    gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
> +    if (gpa == UNMAPPED_GVA)
> +        return true; /* let cpu generate fault */
> +
>    /*
>     * if emulation was due to access to shadowed page table
>     * and it failed try to unshadow page and re-enter the
>     * guest to let CPU execute the instruction.
>     */
> -    if (kvm_mmu_unprotect_page_virt(vcpu, gva))
> +    if (kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa)))
>        return true;
> 
> -    gpa = kvm_mmu_gva_to_gpa_system(vcpu, gva, NULL);
> -
> -    if (gpa == UNMAPPED_GVA)
> -        return true; /* let cpu generate fault */
> -
>    /*
>     * Do not retry the unhandleable instruction if it faults on the
>     * readonly host memory, otherwise it will goto a infinite loop:
> @@ -4828,7 +4827,7 @@ static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>    if (!vcpu->arch.mmu.direct_map)
>        gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
> 
> -    kvm_mmu_unprotect_page(vcpu->kvm, gpa >> PAGE_SHIFT);
> +    kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
> 
>    return true;
> }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
