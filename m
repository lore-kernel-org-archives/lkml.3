Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbaGXMWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:22:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758605AbaGXMWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:22:31 -0400
Message-ID: <53D0FA78.2000609@redhat.com>
Date: Thu, 24 Jul 2014 14:22:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Nadav Amit <namit@cs.technion.ac.il>
CC: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com
Subject: Re: [PATCH] KVM: x86: Assertions to check no overrun in MSR lists
References: <1406203616-5579-1-git-send-email-namit@cs.technion.ac.il>
In-Reply-To: <1406203616-5579-1-git-send-email-namit@cs.technion.ac.il>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 24/07/2014 14:06, Nadav Amit ha scritto:
> Currently there is no check whether shared MSRs list overrun the allocated size
> which can results in bugs. In addition there is no check that vmx->guest_msrs
> has sufficient space to accommodate all the VMX msrs.  This patch adds the
> assertions.
> 
> Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
> ---
>  arch/x86/kvm/vmx.c | 2 ++
>  arch/x86/kvm/x86.c | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 7534a9f..286a931 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7585,6 +7585,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
>  		goto free_vcpu;
>  
>  	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	BUILD_BUG_ON(PAGE_SIZE / sizeof(struct shared_msr_entry) < NR_VMX_MSR);
> +
>  	err = -ENOMEM;
>  	if (!vmx->guest_msrs) {
>  		goto uninit_vcpu;
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f750b69..f5cd7876 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -212,6 +212,7 @@ static void shared_msr_update(unsigned slot, u32 msr)
>  
>  void kvm_define_shared_msr(unsigned slot, u32 msr)
>  {
> +	BUG_ON(slot >= KVM_NR_SHARED_MSRS);
>  	if (slot >= shared_msrs_global.nr)
>  		shared_msrs_global.nr = slot + 1;
>  	shared_msrs_global.msrs[slot] = msr;
> 

Thanks, both are good improvements.  I'm adding this patch on top.

-------------------- 8< ---------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] Replace NR_VMX_MSR with its definition

Using ARRAY_SIZE directly makes it easier to read the code.  While touching
the code, replace the division by a multiplication in the recently added
BUILD_BUG_ON.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 3397a88b7463..906f9e49d0e7 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -823,7 +823,6 @@ static const u32 vmx_msr_index[] = {
 #endif
 	MSR_EFER, MSR_TSC_AUX, MSR_STAR,
 };
-#define NR_VMX_MSR ARRAY_SIZE(vmx_msr_index)
 
 static inline bool is_page_fault(u32 intr_info)
 {
@@ -4441,7 +4440,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmx->vcpu.arch.pat = host_pat;
 	}
 
-	for (i = 0; i < NR_VMX_MSR; ++i) {
+	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i) {
 		u32 index = vmx_msr_index[i];
 		u32 data_low, data_high;
 		int j = vmx->nmsrs;
@@ -7608,7 +7607,8 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto free_vcpu;
 
 	vmx->guest_msrs = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	BUILD_BUG_ON(PAGE_SIZE / sizeof(struct shared_msr_entry) < NR_VMX_MSR);
+	BUILD_BUG_ON(ARRAY_SIZE(vmx_msr_index) * sizeof(vmx->guest_msrs[0])
+		     > PAGE_SIZE);
 
 	err = -ENOMEM;
 	if (!vmx->guest_msrs) {
@@ -8960,7 +8960,7 @@ static int __init vmx_init(void)
 
 	rdmsrl_safe(MSR_EFER, &host_efer);
 
-	for (i = 0; i < NR_VMX_MSR; ++i)
+	for (i = 0; i < ARRAY_SIZE(vmx_msr_index); ++i)
 		kvm_define_shared_msr(i, vmx_msr_index[i]);
 
 	vmx_io_bitmap_a = (unsigned long *)__get_free_page(GFP_KERNEL);

