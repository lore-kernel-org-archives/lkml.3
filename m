Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbaIDHCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 03:02:30 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:54039 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174AbaIDHC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 03:02:28 -0400
Date: Thu, 4 Sep 2014 10:02:20 +0300
From: Gleb Natapov <gleb@cloudius-systems.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jroedel@suse.de,
        agraf@suse.de, valentine.sinitsyn@gmail.com, jan.kiszka@siemens.com,
        avi@cloudius-systems.com
Subject: Re: [PATCH 3/4] KVM: x86: inject nested page faults on emulated
 instructions
Message-ID: <20140904070220.GL9842@cloudius-systems.com>
References: <1409670830-14544-1-git-send-email-pbonzini@redhat.com>
 <1409670830-14544-4-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409670830-14544-4-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 05:13:49PM +0200, Paolo Bonzini wrote:
> This is required for the following patch to work correctly.  If a nested page
> fault happens during emulation, we must inject a vmexit, not a page fault.
> Luckily we already have the required machinery: it is enough to return
> X86EMUL_INTERCEPTED instead of X86EMUL_PROPAGATE_FAULT.
> 
I wonder why this patch is needed. X86EMUL_PROPAGATE_FAULT causes
ctxt->have_exception to be set to true in x86_emulate_insn().
x86_emulate_instruction() checks ctxt->have_exception and calls
inject_emulated_exception() if it is true. inject_emulated_exception()
calls kvm_propagate_fault() where we check if the fault was nested and
generate vmexit or a page fault accordingly.

> Reported-by: Valentine Sinitsyn <valentine.sinitsyn@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e4ed85e07a01..9e3b74c044ed 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -416,6 +416,16 @@ void kvm_propagate_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
>  		vcpu->arch.mmu.inject_page_fault(vcpu, fault);
>  }
>  
> +static inline int kvm_propagate_or_intercept(struct kvm_vcpu *vcpu,
> +					     struct x86_exception *exception)
> +{
> +	if (likely(!exception->nested_page_fault))
> +		return X86EMUL_PROPAGATE_FAULT;
> +
> +	vcpu->arch.mmu.inject_page_fault(vcpu, exception);
> +	return X86EMUL_INTERCEPTED;
> +}
> +
>  void kvm_inject_nmi(struct kvm_vcpu *vcpu)
>  {
>  	atomic_inc(&vcpu->arch.nmi_queued);
> @@ -4122,7 +4132,7 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
>  		int ret;
>  
>  		if (gpa == UNMAPPED_GVA)
> -			return X86EMUL_PROPAGATE_FAULT;
> +			return kvm_propagate_or_intercept(vcpu, exception);
>  		ret = kvm_read_guest_page(vcpu->kvm, gpa >> PAGE_SHIFT, data,
>  					  offset, toread);
>  		if (ret < 0) {
> @@ -4152,7 +4162,7 @@ static int kvm_fetch_guest_virt(struct x86_emulate_ctxt *ctxt,
>  	gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access|PFERR_FETCH_MASK,
>  						    exception);
>  	if (unlikely(gpa == UNMAPPED_GVA))
> -		return X86EMUL_PROPAGATE_FAULT;
> +		return kvm_propagate_or_intercept(vcpu, exception);
>  
>  	offset = addr & (PAGE_SIZE-1);
>  	if (WARN_ON(offset + bytes > PAGE_SIZE))
> @@ -4203,7 +4213,7 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
>  		int ret;
>  
>  		if (gpa == UNMAPPED_GVA)
> -			return X86EMUL_PROPAGATE_FAULT;
> +			return kvm_propagate_or_intercept(vcpu, exception);
>  		ret = kvm_write_guest(vcpu->kvm, gpa, data, towrite);
>  		if (ret < 0) {
>  			r = X86EMUL_IO_NEEDED;
> @@ -4350,7 +4360,7 @@ static int emulator_read_write_onepage(unsigned long addr, void *val,
>  	ret = vcpu_mmio_gva_to_gpa(vcpu, addr, &gpa, exception, write);
>  
>  	if (ret < 0)
> -		return X86EMUL_PROPAGATE_FAULT;
> +		return kvm_propagate_or_intercept(vcpu, exception);
>  
>  	/* For APIC access vmexit */
>  	if (ret)
> -- 
> 1.8.3.1
> 
> 

--
			Gleb.
