Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbaIXHcM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:32:12 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:37532 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbaIXHcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:32:10 -0400
X-IronPort-AV: E=Sophos;i="5.04,587,1406563200"; 
   d="scan'208";a="36383370"
Message-ID: <54227369.5090701@cn.fujitsu.com>
Date: Wed, 24 Sep 2014 15:31:53 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, <pbonzini@redhat.com>
CC: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] kvm, mem-hotplug: Add arch specific mmu notifier
 to handle apic access migration.
References: <541FEC79.40209@redhat.com> <1411524563-17003-1-git-send-email-tangchen@cn.fujitsu.com> <54226DF7.2050806@web.de>
In-Reply-To: <54226DF7.2050806@web.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/24/2014 03:08 PM, Jan Kiszka wrote:
> On 2014-09-24 04:09, Tang Chen wrote:
>> Hi Paolo,
>>
>> I'm not sure if this patch is following your comment. Please review.
>> And all the other comments are followed. If this patch is OK, I'll
>> send v8 soon.
>>
>> Thanks.
>>
>> We are handling "L1 and L2 share one apic access page" situation when migrating
>> apic access page. We should do some handling when migration happens in the
>> following situations:
>>
>>     1) when L0 is running: Update L1's vmcs in the next L0->L1 entry and L2's
>>        vmcs in the next L1->L2 entry.
>>
>>     2) when L1 is running: Force a L1->L0 exit, update L1's vmcs in the next
>>        L0->L1 entry and L2's vmcs in the next L1->L2 entry.
>>
>>     3) when L2 is running: Force a L2->L0 exit, update L2's vmcs in the next
>>        L0->L2 entry and L1's vmcs in the next L2->L1 exit.
>>
>> This patch force a L1->L0 exit or L2->L0 exit when shared apic access page is
>> migrated using mmu notifier. Since apic access page is only used on intel x86,
>> this is arch specific code.
>> ---
>>   arch/arm/include/asm/kvm_host.h     |  6 ++++++
>>   arch/arm64/include/asm/kvm_host.h   |  6 ++++++
>>   arch/ia64/include/asm/kvm_host.h    |  8 ++++++++
>>   arch/mips/include/asm/kvm_host.h    |  7 +++++++
>>   arch/powerpc/include/asm/kvm_host.h |  6 ++++++
>>   arch/s390/include/asm/kvm_host.h    |  9 +++++++++
>>   arch/x86/include/asm/kvm_host.h     |  2 ++
>>   arch/x86/kvm/x86.c                  | 11 +++++++++++
>>   virt/kvm/kvm_main.c                 |  3 +++
>>   9 files changed, 58 insertions(+)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 6dfb404..79bbf7d 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -182,6 +182,12 @@ static inline int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
>>   	return 0;
>>   }
>>   
>> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +							 unsigned long address)
>> +{
>> +	return;
> Redundant return, more cases below.

OK, will remove it. Thanks.

>
> Jan
>
>> +}
>> +
>>   struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>>   struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
>>   
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index e10c45a..ee89fad 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -192,6 +192,12 @@ static inline int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
>>   	return 0;
>>   }
>>   
>> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +							 unsigned long address)
>> +{
>> +	return;
>> +}
>> +
>>   struct kvm_vcpu *kvm_arm_get_running_vcpu(void);
>>   struct kvm_vcpu __percpu **kvm_get_running_vcpus(void);
>>   
>> diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
>> index db95f57..326ac55 100644
>> --- a/arch/ia64/include/asm/kvm_host.h
>> +++ b/arch/ia64/include/asm/kvm_host.h
>> @@ -574,6 +574,14 @@ static inline struct kvm_pt_regs *vcpu_regs(struct kvm_vcpu *v)
>>   	return (struct kvm_pt_regs *) ((unsigned long) v + KVM_STK_OFFSET) - 1;
>>   }
>>   
>> +#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
>> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +							 unsigned long address)
>> +{
>> +	return;
>> +}
>> +#endif /* KVM_ARCH_WANT_MMU_NOTIFIER */
>> +
>>   typedef int kvm_vmm_entry(void);
>>   typedef void kvm_tramp_entry(union context *host, union context *guest);
>>   
>> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
>> index 7a3fc67..c392705 100644
>> --- a/arch/mips/include/asm/kvm_host.h
>> +++ b/arch/mips/include/asm/kvm_host.h
>> @@ -767,5 +767,12 @@ extern int kvm_mips_trans_mtc0(uint32_t inst, uint32_t *opc,
>>   extern void kvm_mips_dump_stats(struct kvm_vcpu *vcpu);
>>   extern unsigned long kvm_mips_get_ramsize(struct kvm *kvm);
>>   
>> +#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
>> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +							 unsigned long address)
>> +{
>> +	return;
>> +}
>> +#endif /* KVM_ARCH_WANT_MMU_NOTIFIER */
>>   
>>   #endif /* __MIPS_KVM_HOST_H__ */
>> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
>> index 98d9dd5..c16a573 100644
>> --- a/arch/powerpc/include/asm/kvm_host.h
>> +++ b/arch/powerpc/include/asm/kvm_host.h
>> @@ -61,6 +61,12 @@ extern int kvm_age_hva(struct kvm *kvm, unsigned long hva);
>>   extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>>   extern void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>>   
>> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +							 unsigned long address)
>> +{
>> +	return;
>> +}
>> +
>>   #define HPTEG_CACHE_NUM			(1 << 15)
>>   #define HPTEG_HASH_BITS_PTE		13
>>   #define HPTEG_HASH_BITS_PTE_LONG	12
>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>> index 773bef7..693290f 100644
>> --- a/arch/s390/include/asm/kvm_host.h
>> +++ b/arch/s390/include/asm/kvm_host.h
>> @@ -450,4 +450,13 @@ void kvm_arch_async_page_present(struct kvm_vcpu *vcpu,
>>   
>>   extern int sie64a(struct kvm_s390_sie_block *, u64 *);
>>   extern char sie_exit;
>> +
>> +#ifdef KVM_ARCH_WANT_MMU_NOTIFIER
>> +static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +							 unsigned long address)
>> +{
>> +	return;
>> +}
>> +#endif /* KVM_ARCH_WANT_MMU_NOTIFIER */
>> +
>>   #endif
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 66480fd..408b944 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1047,6 +1047,8 @@ int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu);
>>   int kvm_cpu_get_interrupt(struct kvm_vcpu *v);
>>   void kvm_vcpu_reset(struct kvm_vcpu *vcpu);
>>   void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu);
>> +void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +					   unsigned long address);
>>   
>>   void kvm_define_shared_msr(unsigned index, u32 msr);
>>   void kvm_set_shared_msr(unsigned index, u64 val, u64 mask);
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c064ca6..e042ef6 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6011,6 +6011,17 @@ void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);
>>   
>> +void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>> +					   unsigned long address)
>> +{
>> +	/*
>> +	 * The physical address of apic access page is stored in VMCS.
>> +	 * Update it when it becomes invalid.
>> +	 */
>> +	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
>> +		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>> +}
>> +
>>   /*
>>    * Returns 1 to let __vcpu_run() continue the guest execution loop without
>>    * exiting to the userspace.  Otherwise, the value will be returned to the
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 0f8b6f6..5427973d 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -295,6 +295,9 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>>   		kvm_flush_remote_tlbs(kvm);
>>   
>>   	spin_unlock(&kvm->mmu_lock);
>> +
>> +	kvm_arch_mmu_notifier_invalidate_page(kvm, address);
>> +
>>   	srcu_read_unlock(&kvm->srcu, idx);
>>   }
>>   
>>
>

