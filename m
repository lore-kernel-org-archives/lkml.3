Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaIKKrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 06:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaIKKrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 06:47:31 -0400
Message-ID: <54117DB4.307@redhat.com>
Date: Thu, 11 Sep 2014 12:47:16 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, mtosatti@redhat.com,
        nadav.amit@gmail.com, jan.kiszka@web.de, kvm@vger.kernel.org,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        guz.fnst@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/7] kvm, mem-hotplug: Reload L1' apic access page
 on migration in vcpu_enter_guest().
References: <1410413886-32213-1-git-send-email-tangchen@cn.fujitsu.com> <1410413886-32213-5-git-send-email-tangchen@cn.fujitsu.com> <541169AD.6060908@redhat.com> <20140911101200.GF25317@minantech.com>
In-Reply-To: <20140911101200.GF25317@minantech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 11/09/2014 12:12, Gleb Natapov ha scritto:
> On Thu, Sep 11, 2014 at 11:21:49AM +0200, Paolo Bonzini wrote:
>> Il 11/09/2014 07:38, Tang Chen ha scritto:
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>>> index 63c4c3e..da6d55d 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -7093,6 +7093,11 @@ static void vmx_set_virtual_x2apic_mode(struct kvm_vcpu *vcpu, bool set)
>>>  	vmx_set_msr_bitmap(vcpu);
>>>  }
>>>  
>>> +static void vmx_set_apic_access_page_addr(struct kvm *kvm, hpa_t hpa)
>>> +{
>>> +	vmcs_write64(APIC_ACCESS_ADDR, hpa);
>>
>> This has to be guarded by "if (!is_guest_mode(vcpu))".
>>
> We do need to write it if L1 and L2 share APIC_ACCESS_ADDR and skip
> it otherwise, no?

Yes, but this would be handled by patch 6:

 		} else if (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
+			struct page *page = gfn_to_page(vmx->vcpu.kvm,
+				APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
 			exec_control |=
 				SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES;
-			vmcs_write64(APIC_ACCESS_ADDR,
-				page_to_phys(vcpu->kvm->arch.apic_access_page));
+			vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
+			/*
+			 * Do not pin apic access page in memory so that memory
+			 * hotplug process is able to migrate it.
+			 */
+			put_page(page);
 		}

However, this is also useless code duplication because the above snippet could
reuse vcpu_reload_apic_access_page too.

So I think you cannot do the is_guest_mode check in
kvm_vcpu_reload_apic_access_page and also not in
vmx_reload_apic_access_page.  But you could do something like

kvm_vcpu_reload_apic_access_page(...)
{
	...
	kvm_x86_ops->reload_apic_access_page(...);
}
EXPORT_SYMBOL_GPL(kvm_vcpu_reload_apic_access_page);

/* used in vcpu_enter_guest only */
vcpu_reload_apic_access_page(...)
{
	if (!is_guest_mode(vcpu))
		kvm_vcpu_reload_apic_access_page(...)
}

Paolo
