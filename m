Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbbA2EFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:05:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:29548 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbbA2EFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:05:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,484,1418112000"; 
   d="scan'208";a="658413167"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v4 2/6] KVM: nVMX: Enable nested virtualize x2apic mode
Thread-Topic: [PATCH v4 2/6] KVM: nVMX: Enable nested virtualize x2apic mode
Thread-Index: AQHQOxMWJBk+rZSvikyCsGDNUyZvI5zWY0nw//+OuwCAAIg9IA==
Date: Thu, 29 Jan 2015 04:05:29 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2E3F5@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yXSy9NwBFWkvN+y=5oZfJTM5AaoLZ08O-G2+hXtZLqH0Q@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2E2AF@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yXbEirXExiC3p2m_zf9AGLYGKU5fLGHdizPN10eL4Q5Ug@mail.gmail.com>
In-Reply-To: <CACzj_yXbEirXExiC3p2m_zf9AGLYGKU5fLGHdizPN10eL4Q5Ug@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0T45mpD011802

Wincy Van wrote on 2015-01-29:
> On Thu, Jan 29, 2015 at 10:54 AM, Zhang, Yang Z <yang.z.zhang@intel.com>
> wrote:
>>> -8646,7 +8750,8 @@ static void prepare_vmcs02(struct kvm_vcpu
>>> *vcpu, struct vmcs12 *vmcs12)
>>>                         else
>>> vmcs_write64(APIC_ACCESS_ADDR,
>>> 
>>> page_to_phys(vmx->nested.apic_access_page));
>>> -               } else if
>>> (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm)) {
>>> +               } else if
>>> + (!(nested_cpu_has_virt_x2apic_mode(vmcs12))
>>> + &&
>>> +
>>> + (vm_need_virtualize_apic_accesses(vmx->vcpu.kvm))) {
>>>                         exec_control |=
>> 
>> You don't load L2's apic_page in your patch correctly when x2apic
>> mode is
> used. Here is the right change for prepare_vmcs02()(maybe other place
> also need change too):
>> 
>> @@ -8585,7 +8585,8 @@ static void prepare_vmcs02(struct kvm_vcpu *vcpu,
>> struct vmcs12 *vmcs12)
>> 
> CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
>>                         exec_control |=
>> vmcs12->secondary_vm_exec_control;
>> 
>> -               if (exec_control &
>> SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES) { +               if
>> (exec_control & (SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES | + +
>> SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE)) {
>>                         /*
>>                          * If translation failed, no matter: This
>> feature
> asks
>>                          * to exit when accessing the given address,
>> and if it @@ -8594,7 +8595,8 @@ static void prepare_vmcs02(struct
> kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
>>                          */
>>                         if (!vmx->nested.apic_access_page)
>>                                 exec_control &=
>> - ~SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES; +                          
>>       ~ (SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES | + +
>> SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE);
>>                         else
>>                                 vmcs_write64(APIC_ACCESS_ADDR,
>> page_to_phys(vmx->nested.apic_access_page));
>> 
> 
> I think we don't need to do this, if L1 enables x2apic mode, we have
> already checked that the vmcs12->SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES
> is 0. "exec_control |= vmcs12->secondary_vm_exec_control;" merged L1's
> settings, including x2apic mode. the special case is
> vm_need_virtualize_apic_accesses, if vm_need_virtualize_apic_accesses
> returns true, the nested_cpu_has_virt_x2apic_mode will prevent us to set
> the apic access bit.

I just realized that we are talking different thing. I am thinking about VIRTUAL_APIC_PAGE_ADDR(my mistake :)). And it has been handled correctly already. For APIC_ACCESS_ADDR, you are right. The current implementation can handle it well.

> 
> 
> Thanks,
> Wincy


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
