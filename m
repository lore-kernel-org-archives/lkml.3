Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761875AbbA1Upu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:45:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:11275 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759742AbbA1Upp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:45:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677275171"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Topic: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Index: AQHQN79lT9Shw/DNlk+phY4fCFwl65zVMIRw//+BigCAAKsBQA==
Date: Wed, 28 Jan 2015 11:09:45 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C7AB@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C547@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yXza_so5EPsJmLOkHMbk3bz9aXen09xCnj0O=KRZDd_Pw@mail.gmail.com>
In-Reply-To: <CACzj_yXza_so5EPsJmLOkHMbk3bz9aXen09xCnj0O=KRZDd_Pw@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SKjs5B006416

Wincy Van wrote on 2015-01-28:
> On Wed, Jan 28, 2015 at 4:00 PM, Zhang, Yang Z <yang.z.zhang@intel.com>
> wrote:
>>> @@ -5812,13 +5813,18 @@ static __init int hardware_setup(void)
>>>                                 (unsigned long
>>> *)__get_free_page(GFP_KERNEL);
>>>         if (!vmx_msr_bitmap_longmode_x2apic)
>>>                 goto out4;
>>> +
>>> +       vmx_msr_bitmap_nested = (unsigned long
>>> *)__get_free_page(GFP_KERNEL);
>>> +       if (!vmx_msr_bitmap_nested)
>>> +               goto out5;
>>> +
>> 
>> Since the nested virtualization is off by default. It's better to
>> allocate the page only when nested is true. Maybe adding the following
>> check is better:
>> 
>> if (nested) {
>>         vmx_msr_bitmap_nested = (unsigned long
>>         *)__get_free_page(GFP_KERNEL); if (!vmx_msr_bitmap_nested)
>>                 goto out5;
>> }
> 
> Agreed. Will do.
> 
>> 
>> ...snip...
>> 
>>> +
>>> +/*
>>> + * Merge L0's and L1's MSR bitmap, return false to indicate that
>>> + * we do not use the hardware.
>>> + */
>>> +static inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
>>> +                                              struct vmcs12
>>> *vmcs12) {
>>> +       return false;
>>> +}
>>> +
>> 
>> The following patches have nothing to do with the MSR control. Why
>> leave the function empty here?
>> 
> 
> No. In patch "Enable nested virtualize x2apic mode", we will return
> false if L1 disabled virt_x2apic_mode, then the hardware MSR-bitmap control is disabled.
> This is faster than rebuilding the vmx_msr_bitmap_nested.
> This function returns false here to indicate that we do not use the hardware.
> Since It is not only virtualize x2apic mode using this, other features
> may use this either. I think it isn't suitable to introduce this function in other patches.

Yes, rebuilding is more costly. But your current implementation cannot leverage the APICv feature correctly. I replied in another thread.

> 
> 
>> Best regards,
>> Yang
>> 
>>


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
