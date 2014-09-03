Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaICBlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 21:41:24 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29537 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752751AbaICBlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 21:41:23 -0400
X-IronPort-AV: E=Sophos;i="5.04,453,1406563200"; 
   d="scan'208";a="35427497"
Message-ID: <54067206.7050303@cn.fujitsu.com>
Date: Wed, 3 Sep 2014 09:42:30 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>,
        <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v4 4/6] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com> <1409134661-27916-5-git-send-email-tangchen@cn.fujitsu.com> <20140902160005.GA26540@minantech.com>
In-Reply-To: <20140902160005.GA26540@minantech.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

On 09/03/2014 12:00 AM, Gleb Natapov wrote:
> ......
> +static void vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * apic access page could be migrated. When the page is being migrated,
> +	 * GUP will wait till the migrate entry is replaced with the new pte
> +	 * entry pointing to the new page.
> +	 */
> +	vcpu->kvm->arch.apic_access_page = gfn_to_page(vcpu->kvm,
> +				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
> +	kvm_x86_ops->set_apic_access_page_addr(vcpu->kvm,
> +				page_to_phys(vcpu->kvm->arch.apic_access_page));
> I am a little bit worried that here all vcpus write to vcpu->kvm->arch.apic_access_page
> without any locking. It is probably benign since pointer write is atomic on x86. Paolo?
>
> Do we even need apic_access_page? Why not call
>   gfn_to_page(APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT)
>   put_page()
> on rare occasions we need to know its address?

Isn't it a necessary item defined in hardware spec ?

I didn't read intel spec deeply, but according to the code, the page's 
address is
written into vmcs. And it made me think that we cannnot remove it.

Thanks.

>
>> +}
>> +
>>   /*
>>    * Returns 1 to let __vcpu_run() continue the guest execution loop without
>>    * exiting to the userspace.  Otherwise, the value will be returned to the
>> @@ -6049,6 +6062,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>>   			kvm_deliver_pmi(vcpu);
>>   		if (kvm_check_request(KVM_REQ_SCAN_IOAPIC, vcpu))
>>   			vcpu_scan_ioapic(vcpu);
>> +		if (kvm_check_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu))
>> +			vcpu_reload_apic_access_page(vcpu);
>>   	}
>>   
>>   	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win) {
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index a4c33b3..8be076a 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -136,6 +136,7 @@ static inline bool is_error_page(struct page *page)
>>   #define KVM_REQ_GLOBAL_CLOCK_UPDATE 22
>>   #define KVM_REQ_ENABLE_IBS        23
>>   #define KVM_REQ_DISABLE_IBS       24
>> +#define KVM_REQ_APIC_PAGE_RELOAD  25
>>   
>>   #define KVM_USERSPACE_IRQ_SOURCE_ID		0
>>   #define KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID	1
>> @@ -579,6 +580,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm);
>>   void kvm_reload_remote_mmus(struct kvm *kvm);
>>   void kvm_make_mclock_inprogress_request(struct kvm *kvm);
>>   void kvm_make_scan_ioapic_request(struct kvm *kvm);
>> +void kvm_reload_apic_access_page(struct kvm *kvm);
>>   
>>   long kvm_arch_dev_ioctl(struct file *filp,
>>   			unsigned int ioctl, unsigned long arg);
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 33712fb..d8280de 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -210,6 +210,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>>   	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>>   }
>>   
>> +void kvm_reload_apic_access_page(struct kvm *kvm)
>> +{
>> +	make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
>> +}
>> +
>>   int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>>   {
>>   	struct page *page;
>> @@ -294,6 +299,13 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>>   	if (need_tlb_flush)
>>   		kvm_flush_remote_tlbs(kvm);
>>   
>> +	/*
>> +	 * The physical address of apic access page is stroed in VMCS.
>> +	 * So need to update it when it becomes invalid.
>> +	 */
>> +	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
>> +		kvm_reload_apic_access_page(kvm);
>> +
>>   	spin_unlock(&kvm->mmu_lock);
>>   	srcu_read_unlock(&kvm->srcu, idx);
>>   }
>> -- 
>> 1.8.3.1
>>
> --
> 			Gleb.
> .
>

