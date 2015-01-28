Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385AbbA1U7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:59:25 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:55519 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227AbbA1U7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:59:21 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C865@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C563@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yVqDYyz5VwCX5d=Po2X_DdsHbqLmON8N=1PVLLocoHNpw@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C800@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yWZzhgjqBPNkxy39v6-uXnRpKb0Eo-YjEQwfSYL+tT-bQ@mail.gmail.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C865@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 20:06:20 +0800
Message-ID: <CACzj_yV+eQP1bZZ07MvECMrQ52DgkcrfsJTFDQ=uPz4j7LkEHg@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 7:52 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
>>>
>>
>> If L0 wants to intercept a msr, we should set
>> vmx_msr_bitmap_legacy(_x2apic) and vmx_msr_bitmap_longmode(_x2apic),
>> and that bitmaps should only be loaded in non-nested entry.
>> Currently we only clear the corresponding bits if L1 enables
>> virtualize x2apic mode, all the other bits are all set. On nested
>> entry, we load nested_msr_bitmap, on nested vmexit, we will restore L0's bitmap.
>> In the nested entry, L0 only care about L2's msr access, not L1's. I
>> think that in nested entry, nested_msr_bitmap is "vmcs01->msr_bitmap"
>> as your mentioned above.
>
> Mmm... I think if the bit is setting in vmcs01->msr_bitmap means whenever the VCPU(no matter in nested guest mode or not) accesses this msr should cause vmexit, not only L1. That's why need to construct the vmcs02->msr_bitmap based on (vmcs01->msr_bitmap ORed vmcs12->msr_bitmap).
>

You are right, but this is not fit for all the cases, we should custom
the nested_msr_bitmap.
e.g.  Currently L0 wants to intercept some of the x2apic msrs' reading:
         if (enable_apicv) {
                for (msr = 0x800; msr <= 0x8ff; msr++)
                        vmx_disable_intercept_msr_read_x2apic(msr);

                /* According SDM, in x2apic mode, the whole id reg is used.
                 * But in KVM, it only use the highest eight bits. Need to
                 * intercept it */
                vmx_enable_intercept_msr_read_x2apic(0x802);
                /* TMCCT */
                vmx_enable_intercept_msr_read_x2apic(0x839);
                /* TPR */
                vmx_disable_intercept_msr_write_x2apic(0x808);
                /* EOI */
                vmx_disable_intercept_msr_write_x2apic(0x80b);
                /* SELF-IPI */
                vmx_disable_intercept_msr_write_x2apic(0x83f);
        }
But L1 may not want this. So I think we are better to deal with the msrs
seperately, there is not a common way suit for all the cases. If other
features want to intercept a msr in nested entry, they can put the
custom code in nested_vmx_merge_msr_bitmap.


Thanks,
Wincy
