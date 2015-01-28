Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbbA1U1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:27:12 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45983 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbA1U1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:27:05 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C800@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C563@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yVqDYyz5VwCX5d=Po2X_DdsHbqLmON8N=1PVLLocoHNpw@mail.gmail.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C800@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 19:43:02 +0800
Message-ID: <CACzj_yWZzhgjqBPNkxy39v6-uXnRpKb0Eo-YjEQwfSYL+tT-bQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 7:25 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
> Wincy Van wrote on 2015-01-28:
>> On Wed, Jan 28, 2015 at 4:05 PM, Zhang, Yang Z <yang.z.zhang@intel.com>
>> wrote:
>>>> @@ -8344,7 +8394,68 @@ static int
>>>> nested_vmx_check_msr_bitmap_controls(struct kvm_vcpu *vcpu,  static
>>>> inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
>>>>                                                struct vmcs12
>>>> *vmcs12)  { -       return false; +       struct page *page; +
>>>> unsigned long *msr_bitmap; + +       if
>>>> (!nested_cpu_has_virt_x2apic_mode(vmcs12)) +               return
>>>> false; + +       page = nested_get_page(vcpu, vmcs12->msr_bitmap); +
>>>>     if (!page) { +               WARN_ON(1); +               return
>>>> false; +       } +       msr_bitmap = (unsigned long *)kmap(page); +
>>>>     if (!msr_bitmap) { +
>>>> nested_release_page_clean(page); +               WARN_ON(1); +
>>>>       return false; +       } + +       memset(vmx_msr_bitmap_nested,
>>>> 0xff, PAGE_SIZE); + +       if
>>>> (nested_cpu_has_virt_x2apic_mode(vmcs12)) +               /* TPR is
>>>> allowed */ +
>>>> nested_vmx_disable_intercept_for_msr(msr_bitmap, +
>>>>           vmx_msr_bitmap_nested, +
>>>> APIC_BASE_MSR + (APIC_TASKPRI >> 4), +
>>>> MSR_TYPE_R | MSR_TYPE_W);
>>>
>>> I didn't understand what this function does? Per my understanding,
>>> you only
>> need to set the (vmx_msr_bitmap_nested = vmcs01->msr_bitmap |
>> vmcs12->msr_bitmap) and inject the nested vmexit to L1 if the bit in
>> vmcs12->msr_bitmap is setting. Am I missing some patches?
>>
>> In the beginning, I want to do "vmcs01->msr_bitmap |
>> vmcs12->msr_bitmap", but I remember that there isn't a instruction to
>> do a bit or operation in two pages effectively, so I do the bit or
>> operation in nested_vmx_disable_intercept_for_msr. If the hardware do
>> not support this, I think it is faster if we deal with the bits on demand.
>> nested_vmx_merge_msr_bitmap is used to merge L0's and L1's bitmaps,
>> any features can put their logic here.
>
> You construct the nested_msr_bitmap based on vmcs12->msr_bitmap, what happens if vmcs01->msr_bitmap want to trap this msr?
>

If L0 wants to intercept a msr, we should set
vmx_msr_bitmap_legacy(_x2apic) and vmx_msr_bitmap_longmode(_x2apic),
and that bitmaps should only be loaded in non-nested entry.
Currently we only clear the corresponding bits if L1 enables
virtualize x2apic mode, all the other bits are all set. On nested
entry, we load nested_msr_bitmap, on nested vmexit, we will restore
L0's bitmap.
In the nested entry, L0 only care about L2's msr access, not L1's. I
think that in nested entry, nested_msr_bitmap is "vmcs01->msr_bitmap"
as your mentioned above.

Thanks,
Wincy
