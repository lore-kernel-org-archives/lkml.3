Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbbAUKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:25:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbbAUKZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:25:21 -0500
Message-ID: <54BF7E86.60205@redhat.com>
Date: Wed, 21 Jan 2015 11:25:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 2/5] KVM: nVMX: Enable nested virtualize x2apic mode.
References: <CACzj_yV+FTFVevjGbJ3Ord7CPbCw7kPMLhQxRaCjZe0uXkYmew@mail.gmail.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC26324@SHSMSX104.ccr.corp.intel.com> <CACzj_yW8eFadtQbw54V8wCGto7_6Gq_G_Z1z61TYKbrK3O2Erw@mail.gmail.com>
In-Reply-To: <CACzj_yW8eFadtQbw54V8wCGto7_6Gq_G_Z1z61TYKbrK3O2Erw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/01/2015 11:16, Wincy Van wrote:
> On Wed, Jan 21, 2015 at 4:35 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
>> Wincy Van wrote on 2015-01-16:
>>> When L2 is using x2apic, we can use virtualize x2apic mode to gain higher
>>> performance.
>>>
>>> This patch also introduces nested_vmx_check_apicv_controls for the nested
>>> apicv patches.
>>>
>>> Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
>>
>> To enable x2apic, should you to consider the behavior changes to rdmsr and wrmsr. I didn't see your patch do it. Is it correct?
> 
> Yes, indeed, I've not noticed that kvm handle nested msr bitmap
> manually, the next version will fix this.
> 
>> BTW, this patch has nothing to do with APICv, it's better to not use x2apic here and change to apicv in following patch.
> 
> Do you mean that we should split this patch from the apicv patch set?

I think it's okay to keep it in the same patchset, but you can put it first.

Paolo

> 
>>
>>> ---
>>>  arch/x86/kvm/vmx.c |   49
>>> ++++++++++++++++++++++++++++++++++++++++++++++++-
>>>  1 files changed, 48 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c index 954dd54..10183ee
>>> 100644
>>> --- a/arch/x86/kvm/vmx.c
>>> +++ b/arch/x86/kvm/vmx.c
>>> @@ -1134,6 +1134,11 @@ static inline bool nested_cpu_has_xsaves(struct
>>> vmcs12 *vmcs12)
>>>                 vmx_xsaves_supported();
>>>  }
>>>
>>> +static inline bool nested_cpu_has_virt_x2apic_mode(struct vmcs12
>>> +*vmcs12) {
>>> +       return nested_cpu_has2(vmcs12,
>>> +SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
>>> +}
>>> +
>>>  static inline bool is_exception(u32 intr_info)  {
>>>         return (intr_info & (INTR_INFO_INTR_TYPE_MASK |
>>> INTR_INFO_VALID_MASK)) @@ -2426,6 +2431,7 @@ static void
>>> nested_vmx_setup_ctls_msrs(struct vcpu_vmx *vmx)
>>>         vmx->nested.nested_vmx_secondary_ctls_low = 0;
>>>         vmx->nested.nested_vmx_secondary_ctls_high &=
>>>                 SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES |
>>> +               SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
>>>                 SECONDARY_EXEC_WBINVD_EXITING |
>>>                 SECONDARY_EXEC_XSAVES;
>>>
>>> @@ -7333,6 +7339,9 @@ static bool nested_vmx_exit_handled(struct
>>> kvm_vcpu *vcpu)
>>>         case EXIT_REASON_APIC_ACCESS:
>>>                 return nested_cpu_has2(vmcs12,
>>>
>>> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES);
>>> +       case EXIT_REASON_APIC_WRITE:
>>> +               /* apic_write should exit unconditionally. */
>>> +               return 1;
>>
>> APIC_WRITE vmexit is introduced by APIC register virtualization not virtualize x2apic. Move it to next patch.
> 
> Agreed, will do.
> 
> Thanks,
> 
> Wincy
> 
