Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3JCLuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:50:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab3JCLuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:50:51 -0400
Message-ID: <524D5A2D.6070001@redhat.com>
Date: Thu, 03 Oct 2013 13:51:09 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 5/7] KVM: mmu: remove argument to kvm_init_shadow_mmu
 and kvm_init_shadow_ept_mmu
References: <1380725776-14948-1-git-send-email-pbonzini@redhat.com> <1380725776-14948-6-git-send-email-pbonzini@redhat.com> <20131003112555.GD17294@redhat.com>
In-Reply-To: <20131003112555.GD17294@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/10/2013 13:25, Gleb Natapov ha scritto:
> On Wed, Oct 02, 2013 at 04:56:14PM +0200, Paolo Bonzini wrote:
>> The initialization function in mmu.c can always use walk_mmu, which
>> is known to be vcpu->arch.mmu.  Only init_kvm_nested_mmu is used to
>> initialize vcpu->arch.nested_mmu.
>>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  arch/x86/kvm/mmu.c | 15 +++++++++------
>>  arch/x86/kvm/mmu.h |  5 ++---
>>  arch/x86/kvm/svm.c |  4 ++--
>>  arch/x86/kvm/vmx.c |  4 ++--
>>  4 files changed, 15 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 40772ef..ac598c8 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -3742,11 +3742,13 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
>>  	update_last_pte_bitmap(vcpu, context);
>>  }
>>  
>> -void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
>> +void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
>>  {
>>  	bool smep = kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
>> +	struct kvm_mmu *context = vcpu->arch.walk_mmu;
> I'd rather use &vcpu->arch.mmu here.
> 
>> +
>>  	ASSERT(vcpu);
>> -	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
>> +	ASSERT(!VALID_PAGE(context->root_hpa));
>>  
>>  	if (!is_paging(vcpu))
>>  		nonpaging_init_context(vcpu, context);
>> @@ -3765,11 +3767,12 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
>>  
>> -void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
>> -		bool execonly)
>> +void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly)
>>  {
>> +	struct kvm_mmu *context = vcpu->arch.walk_mmu;
>> +
>>  	ASSERT(vcpu);
>> -	ASSERT(!VALID_PAGE(vcpu->arch.mmu.root_hpa));
>> +	ASSERT(!VALID_PAGE(context->root_hpa));
>>  
>>  	context->shadow_root_level = kvm_x86_ops->get_tdp_level();
>>  
>> @@ -3790,7 +3793,7 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
>>  
>>  static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_init_shadow_mmu(vcpu, vcpu->arch.walk_mmu);
>> +	kvm_init_shadow_mmu(vcpu);
>>  	vcpu->arch.walk_mmu->set_cr3           = kvm_x86_ops->set_cr3;
>>  	vcpu->arch.walk_mmu->get_cr3           = get_cr3;
>>  	vcpu->arch.walk_mmu->get_pdptr         = kvm_pdptr_read;
> And change walk_mmu to mmu here too for consistency with all other
> places. Basically if you want to initialize use mmu or nested_mmu.
> Use walk_mmu pointer only when you need to use mmu.

Makes sense, especially considering how kvm_init_shadow_mmu initializes 
vcpu->arch.mmu.base_role directly.

Something like this (large enough that I'll probably make it a separate 
patch in v2)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index ac598c8..d1f53cf 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3702,7 +3704,7 @@ static void paging32E_init_context(struct kvm_vcpu *vcpu,
 
 static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 {
-	struct kvm_mmu *context = vcpu->arch.walk_mmu;
+	struct kvm_mmu *context = &vcpu->arch.mmu;
 
 	context->base_role.word = 0;
 	context->page_fault = tdp_page_fault;
@@ -3745,7 +3747,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 {
 	bool smep = kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
-	struct kvm_mmu *context = vcpu->arch.walk_mmu;
+	struct kvm_mmu *context = &vcpu->arch.mmu;
 
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(context->root_hpa));
@@ -3759,17 +3761,17 @@ void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu)
 	else
 		paging32_init_context(vcpu, context);
 
-	vcpu->arch.mmu.base_role.nxe = is_nx(vcpu);
-	vcpu->arch.mmu.base_role.cr4_pae = !!is_pae(vcpu);
-	vcpu->arch.mmu.base_role.cr0_wp  = is_write_protection(vcpu);
-	vcpu->arch.mmu.base_role.smep_andnot_wp
+	context->base_role.nxe = is_nx(vcpu);
+	context->base_role.cr4_pae = !!is_pae(vcpu);
+	context->base_role.cr0_wp  = is_write_protection(vcpu);
+	context->base_role.smep_andnot_wp
 		= smep && !is_write_protection(vcpu);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_mmu);
 
 void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly)
 {
-	struct kvm_mmu *context = vcpu->arch.walk_mmu;
+	struct kvm_mmu *context = &vcpu->arch.mmu;
 
 	ASSERT(vcpu);
 	ASSERT(!VALID_PAGE(context->root_hpa));
@@ -3793,11 +3795,13 @@ EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
 static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu *context = &vcpu->arch.mmu;
+
 	kvm_init_shadow_mmu(vcpu);
-	vcpu->arch.walk_mmu->set_cr3           = kvm_x86_ops->set_cr3;
-	vcpu->arch.walk_mmu->get_cr3           = get_cr3;
-	vcpu->arch.walk_mmu->get_pdptr         = kvm_pdptr_read;
-	vcpu->arch.walk_mmu->inject_page_fault = kvm_inject_page_fault;
+	context->set_cr3           = kvm_x86_ops->set_cr3;
+	context->get_cr3           = get_cr3;
+	context->get_pdptr         = kvm_pdptr_read;
+	context->inject_page_fault = kvm_inject_page_fault;
 }
 
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)

How far should I go?  Should I also remove the context argument from
nonpaging_init_context and friends, changing it to a local variable?
(Doesn't seem like a big improvement in clarity).

Paolo

>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 2926152..c9d3d8f 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -70,9 +70,8 @@ enum {
>>  };
>>  
>>  int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
>> -void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
>> -void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
>> -		bool execonly);
>> +void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu);
>> +void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly);
>>  
>>  static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
>>  {
>> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
>> index c7168a5..37bcd6b 100644
>> --- a/arch/x86/kvm/svm.c
>> +++ b/arch/x86/kvm/svm.c
>> @@ -1961,8 +1961,8 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
>>  
>>  static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_init_shadow_mmu(vcpu, &vcpu->arch.mmu);
>> -
>> +	WARN_ON(mmu_is_nested(vcpu));
>> +	kvm_init_shadow_mmu(vcpu);
>>  	vcpu->arch.mmu.set_cr3           = nested_svm_set_tdp_cr3;
>>  	vcpu->arch.mmu.get_cr3           = nested_svm_get_tdp_cr3;
>>  	vcpu->arch.mmu.get_pdptr         = nested_svm_get_tdp_pdptr;
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 2db9164..fdd1cb8 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -7501,9 +7501,9 @@ static unsigned long nested_ept_get_cr3(struct kvm_vcpu *vcpu)
>>  
>>  static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
>>  {
>> -	kvm_init_shadow_ept_mmu(vcpu, &vcpu->arch.mmu,
>> +	WARN_ON(mmu_is_nested(vcpu));
>> +	kvm_init_shadow_ept_mmu(vcpu,
>>  			nested_vmx_ept_caps & VMX_EPT_EXECUTE_ONLY_BIT);
>> -
>>  	vcpu->arch.mmu.set_cr3           = vmx_set_cr3;
>>  	vcpu->arch.mmu.get_cr3           = nested_ept_get_cr3;
>>  	vcpu->arch.mmu.inject_page_fault = nested_ept_inject_page_fault;
>> -- 
>> 1.8.3.1
>>
> 
> --
> 			Gleb.
> 

