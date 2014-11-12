Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaKLLiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:38:20 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51575 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaKLLiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:17 -0500
Message-ID: <546346A4.3020409@redhat.com>
Date: Wed, 12 Nov 2014 12:38:12 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: Andy Lutomirski <luto@amacapital.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH] x86, kvm, vmx: Always use LOAD_IA32_EFER if available
References: <32d96cddbe65b897151b95a0e0f8326e404646f8.1415413387.git.luto@amacapital.net>
In-Reply-To: <32d96cddbe65b897151b95a0e0f8326e404646f8.1415413387.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/11/2014 03:25, Andy Lutomirski wrote:
> At least on Sandy Bridge, letting the CPU switch IA32_EFER is much
> faster than switching it manually.
> 
> I benchmarked this using the vmexit kvm-unit-test (single run, but
> GOAL multiplied by 5 to do more iterations):
> 
> Test                                  Before      After    Change
> cpuid                                   2000       1932    -3.40%
> vmcall                                  1914       1817    -5.07%
> mov_from_cr8                              13         13     0.00%
> mov_to_cr8                                19         19     0.00%
> inl_from_pmtimer                       19164      10619   -44.59%
> inl_from_qemu                          15662      10302   -34.22%
> inl_from_kernel                         3916       3802    -2.91%
> outl_to_kernel                          2230       2194    -1.61%
> mov_dr                                   172        176     2.33%
> ipi                                (skipped)  (skipped)
> ipi+halt                           (skipped)  (skipped)
> ple-round-robin                           13         13     0.00%
> wr_tsc_adjust_msr                       1920       1845    -3.91%
> rd_tsc_adjust_msr                       1892       1814    -4.12%
> mmio-no-eventfd:pci-mem                16394      11165   -31.90%
> mmio-wildcard-eventfd:pci-mem           4607       4645     0.82%
> mmio-datamatch-eventfd:pci-mem          4601       4610     0.20%
> portio-no-eventfd:pci-io               11507       7942   -30.98%
> portio-wildcard-eventfd:pci-io          2239       2225    -0.63%
> portio-datamatch-eventfd:pci-io         2250       2234    -0.71%
> 
> I haven't explicitly computed the significance of these numbers,
> but this isn't subtle.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/kvm/vmx.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3e556c68351b..e72b9660e51c 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -1659,8 +1659,14 @@ static bool update_transition_efer(struct vcpu_vmx *vmx, int efer_offset)
>  	vmx->guest_msrs[efer_offset].mask = ~ignore_bits;
>  
>  	clear_atomic_switch_msr(vmx, MSR_EFER);
> -	/* On ept, can't emulate nx, and must switch nx atomically */
> -	if (enable_ept && ((vmx->vcpu.arch.efer ^ host_efer) & EFER_NX)) {
> +
> +	/*
> +	 * On EPT, we can't emulate NX, so we must switch EFER atomically.
> +	 * On CPUs that support "load IA32_EFER", always switch EFER
> +	 * atomically, since it's faster than switching it manually.
> +	 */
> +	if (cpu_has_load_ia32_efer ||
> +	    (enable_ept && ((vmx->vcpu.arch.efer ^ host_efer) & EFER_NX))) {
>  		guest_efer = vmx->vcpu.arch.efer;
>  		if (!(guest_efer & EFER_LMA))
>  			guest_efer &= ~EFER_LME;
> 

I am committing this patch, with an additional remark in the commit message:

 The results were reproducible on all of Nehalem, Sandy Bridge and
 Ivy Bridge.  The slowness of manual switching is because writing
 to EFER with WRMSR triggers a TLB flush, even if the only bit you're
 touching is SCE (so the page table format is not affected).  Doing
 the write as part of vmentry/vmexit, instead, does not flush the TLB,
 probably because all processors that have EPT also have VPID.

Paolo
