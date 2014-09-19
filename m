Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbaISOIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 10:08:01 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:34529 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaISOIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 10:08:00 -0400
Message-ID: <541C38C3.9090207@gmail.com>
Date: Fri, 19 Sep 2014 10:08:03 -0400
From: Liang Chen <liangchen.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, pbonzini@redhat.com
CC: rkrcmar@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] KVM: x86: directly use kvm_make_request again
References: <1411058317-23646-1-git-send-email-liangchen.linux@gmail.com> <1411058317-23646-3-git-send-email-liangchen.linux@gmail.com> <541BC949.4050602@linux.vnet.ibm.com>
In-Reply-To: <541BC949.4050602@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/19/2014 02:12 AM, Xiao Guangrong wrote:
> On 09/19/2014 12:38 AM, Liang Chen wrote:
>> A one-line wrapper around kvm_make_request does not seem
>> particularly useful. Replace kvm_mmu_flush_tlb() with
>> kvm_make_request() again to free the namespace a bit.
>>
>> Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |  1 -
>>  arch/x86/kvm/mmu.c              | 16 +++++-----------
>>  arch/x86/kvm/vmx.c              |  2 +-
>>  arch/x86/kvm/x86.c              | 11 ++++++++---
>>  4 files changed, 14 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 7c492ed..77ade89 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -917,7 +917,6 @@ void kvm_inject_nmi(struct kvm_vcpu *vcpu);
>>
>>  int fx_init(struct kvm_vcpu *vcpu);
>>
>> -void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu);
>>  void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>>  		       const u8 *new, int bytes);
>>  int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index b41fd97..acc2d0c5 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -1749,7 +1749,7 @@ static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>  		return 1;
>>  	}
>>
>> -	kvm_mmu_flush_tlb(vcpu);
>> +	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  	return 0;
>>  }
>>
>> @@ -1802,7 +1802,7 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
>>
>>  	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
>>  	if (flush)
>> -		kvm_mmu_flush_tlb(vcpu);
>> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  }
>>
>>  struct mmu_page_path {
>> @@ -2536,7 +2536,7 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>>  	      true, host_writable)) {
>>  		if (write_fault)
>>  			*emulate = 1;
>> -		kvm_mmu_flush_tlb(vcpu);
>> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  	}
>>
>>  	if (unlikely(is_mmio_spte(*sptep) && emulate))
>> @@ -3450,12 +3450,6 @@ static void nonpaging_init_context(struct kvm_vcpu *vcpu,
>>  	context->nx = false;
>>  }
>>
>> -void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
>> -{
>> -	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>> -}
>> -EXPORT_SYMBOL_GPL(kvm_mmu_flush_tlb);
>> -
>>  void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu)
>>  {
>>  	mmu_free_roots(vcpu);
>> @@ -3961,7 +3955,7 @@ static void mmu_pte_write_flush_tlb(struct kvm_vcpu *vcpu, bool zap_page,
>>  	if (remote_flush)
>>  		kvm_flush_remote_tlbs(vcpu->kvm);
>>  	else if (local_flush)
>> -		kvm_mmu_flush_tlb(vcpu);
>> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  }
>>
>>  static u64 mmu_pte_write_fetch_gpte(struct kvm_vcpu *vcpu, gpa_t *gpa,
>> @@ -4222,7 +4216,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
>>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
>>  {
>>  	vcpu->arch.mmu.invlpg(vcpu, gva);
>> -	kvm_mmu_flush_tlb(vcpu);
>> +	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  	++vcpu->stat.invlpg;
>>  }
>>  EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index bfe11cf..bb0a7ab 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -6617,7 +6617,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>>  	switch (type) {
>>  	case VMX_EPT_EXTENT_GLOBAL:
>>  		kvm_mmu_sync_roots(vcpu);
>> -		kvm_mmu_flush_tlb(vcpu);
>> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  		nested_vmx_succeed(vcpu);
>>  		break;
>>  	default:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 9eb5458..fc3df50 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -726,7 +726,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
>>  {
>>  	if (cr3 == kvm_read_cr3(vcpu) && !pdptrs_changed(vcpu)) {
>>  		kvm_mmu_sync_roots(vcpu);
>> -		kvm_mmu_flush_tlb(vcpu);
>> +		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
>>  		return 0;
>>  	}
>>
>> @@ -5989,6 +5989,12 @@ static void vcpu_scan_ioapic(struct kvm_vcpu *vcpu)
>>  	kvm_apic_update_tmr(vcpu, tmr);
>>  }
>>
>> +static void kvm_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>> +{
>> +	++vcpu->stat.tlb_flush;
>> +	kvm_x86_ops->tlb_flush(vcpu);
>> +}
>> +
>>  /*
>>   * Returns 1 to let __vcpu_run() continue the guest execution loop without
>>   * exiting to the userspace.  Otherwise, the value will be returned to the
>> @@ -6018,8 +6024,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>  		if (kvm_check_request(KVM_REQ_MMU_SYNC, vcpu))
>>  			kvm_mmu_sync_roots(vcpu);
>>  		if (kvm_check_request(KVM_REQ_TLB_FLUSH, vcpu)) {
>> -			++vcpu->stat.tlb_flush;
>> -			kvm_x86_ops->tlb_flush(vcpu);
>> +			kvm_vcpu_flush_tlb(vcpu);
> NACK!
>
> Do not understand why you have to introduce a meaningful name
> here - it's used just inner a function, which can not help to
> improve a readability of the code at all.
>
> What i suggested is renaming kvm_mmu_flush_tlb() since it's a
> API used in multiple files - a good name helps developer to
> know what it's doing and definitely easier typing.
>
>
>
Thanks for the comments. However ...

Leaving kvm_mmu_flush_tlb might be error prone. People might have a
tendency to make simalir change as the ++vcpu->stat.tlb_flush in
the function in the future. I know we have gatekeepers who can spot
 out that kind of mistake, but why bothering with that... 

I agree raw request doesn't look good. But 
kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu) is completely
understandable even to a beginner, and future-proof is just
as important.


Thanks,
Liang

