Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbbA2DJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:09:59 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59291 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965031AbbA2Cg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C932@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C563@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yVqDYyz5VwCX5d=Po2X_DdsHbqLmON8N=1PVLLocoHNpw@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C800@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yWZzhgjqBPNkxy39v6-uXnRpKb0Eo-YjEQwfSYL+tT-bQ@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C865@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yV+eQP1bZZ07MvECMrQ52DgkcrfsJTFDQ=uPz4j7LkEHg@mail.gmail.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C932@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 20:45:16 +0800
Message-ID: <CACzj_yXCPWFxFxPq45OQEwS_ASE6TQK8XwXEFOcSzQS8r90jaA@mail.gmail.com>
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

On Wed, Jan 28, 2015 at 8:33 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
>>>
>>> You are right, but this is not fit for all the cases, we should
>>> custom the nested_msr_bitmap.
>>> e.g.  Currently L0 wants to intercept some of the x2apic msrs' reading:
>>>          if (enable_apicv) {
>>>                 for (msr = 0x800; msr <= 0x8ff; msr++)
>> vmx_disable_intercept_msr_read_x2apic(msr);
>>>                 /* According SDM, in x2apic mode, the whole id reg
>>> is
>> used.
>>>                  * But in KVM, it only use the highest eight bits. Need to
>>>                  * intercept it */
>>>                 vmx_enable_intercept_msr_read_x2apic(0x802); /* TMCCT
>>>                 */ vmx_enable_intercept_msr_read_x2apic(0x839); /* TPR
>>>                 */ vmx_disable_intercept_msr_write_x2apic(0x808); /*
>>> EOI
>> */
>>>                 vmx_disable_intercept_msr_write_x2apic(0x80b); /*
>>>                 SELF-IPI */
>>>                 vmx_disable_intercept_msr_write_x2apic(0x83f);
>>>         }
>>> But L1 may not want this. So I think we are better to deal with the
>>
>> Actually, from L0's point, it is totally unaware of the L2. The only
>> thing L0 aware is that the CPU should follow L0's configuration when
>> VCPU is running. So if L0 wants to trap a msr, then the read operation
>> to this msr should cause vmexit unconditionally no matter who is running(who means L1, L2, L3.....).
>>
>>> msrs seperately, there is not a common way suit for all the cases.
>>> If other features want to intercept a msr in nested entry, they can
>>> put the custom code in nested_vmx_merge_msr_bitmap.
>>
>> Yes, if other features want to do it in 'nested' entry, they can fill
>> nested_vmx_merge_msr_bitmap. But if in non-nested case, it should be
>> our responsibly to handle it correctly, how about add following check:
>>
>> if (type & MSR_TYPE_R && !test_bit(msr, vmcs01_msr_bitmap) &&
>> !test_bit(msr, msr_bitmap_l1 + 0x000 / f))
>>         __clear_bit(msr, msr_bitmap_nested + 0x000 / f);
>
>
> Anyway, this is not necessary for your current patch. We can consider it later if there really have other features will use it.
>

Yep, I know what you mean now, for other msrs which are not forwarded
access by a mechanism like virtual-apic page, we should intercept it
unconditionally. I think we should ensure the msr can be allowed
before call nested_vmx_disable_intercept_for_msr, if L0 want to
intercept it, just do not call nested_vmx_disable_intercept_for_msr.

 !test_bit(msr, vmcs01_msr_bitmap) will introduce a problem that some
of the msrs will be affcted by vmcs01_msr_bitmap, TMCCT and TPR, for
example.
Intercept reading for these msrs is okay, but it is not efficient.

Thanks,
Wincy
