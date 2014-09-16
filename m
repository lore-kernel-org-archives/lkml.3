Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaIPLYh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 07:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbaIPLYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 07:24:36 -0400
Message-ID: <54181DE1.3040502@redhat.com>
Date: Tue, 16 Sep 2014 13:24:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>, gleb@kernel.org, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de
CC: kvm@vger.kernel.org, laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 4/6] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410864122-12434-1-git-send-email-tangchen@cn.fujitsu.com> <1410864122-12434-5-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1410864122-12434-5-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/09/2014 12:42, Tang Chen ha scritto:
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 33712fb..0df82c1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -210,6 +210,11 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
>  	make_all_cpus_request(kvm, KVM_REQ_SCAN_IOAPIC);
>  }
>  
> +void kvm_reload_apic_access_page(struct kvm *kvm)
> +{
> +	make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
> +}
> +
>  int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  {
>  	struct page *page;
> @@ -294,6 +299,13 @@ static void kvm_mmu_notifier_invalidate_page(struct mmu_notifier *mn,
>  	if (need_tlb_flush)
>  		kvm_flush_remote_tlbs(kvm);
>  
> +	/*
> +	 * The physical address of apic access page is stored in VMCS.
> +	 * Update it when it becomes invalid.
> +	 */
> +	if (address == gfn_to_hva(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT))
> +		kvm_reload_apic_access_page(kvm);

This cannot be in the generic code.  It is architecture-specific.
Please add a new function kvm_arch_mmu_notifier_invalidate_page, and
call it outside the mmu_lock.

kvm_reload_apic_access_page need not be in virt/kvm/kvm_main.c, either.

Paolo

>  	spin_unlock(&kvm->mmu_lock);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }

