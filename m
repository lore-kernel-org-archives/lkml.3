Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759638AbbA1UbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:31:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:11145 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbbA1Ua5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:30:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677318687"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Topic: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Index: AQHQN79lT9Shw/DNlk+phY4fCFwl65zVMZZg//+J0gCAAKsDYP//gx4AgACHCkD//395AAAQ3TKAAAClv/D//37JAP//dp/Q
Date: Wed, 28 Jan 2015 13:06:12 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C9D6@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C563@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yVqDYyz5VwCX5d=Po2X_DdsHbqLmON8N=1PVLLocoHNpw@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C800@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yWZzhgjqBPNkxy39v6-uXnRpKb0Eo-YjEQwfSYL+tT-bQ@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C865@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yV+eQP1bZZ07MvECMrQ52DgkcrfsJTFDQ=uPz4j7LkEHg@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C932@SHSMSX104.ccr.corp.intel.com>
 <CACzj_yXCPWFxFxPq45OQEwS_ASE6TQK8XwXEFOcSzQS8r90jaA@mail.gmail.com>
In-Reply-To: <CACzj_yXCPWFxFxPq45OQEwS_ASE6TQK8XwXEFOcSzQS8r90jaA@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SLqjkS007566

Wincy Van wrote on 2015-01-28:
> On Wed, Jan 28, 2015 at 8:33 PM, Zhang, Yang Z <yang.z.zhang@intel.com>
> wrote:
>>>> 
>>>> You are right, but this is not fit for all the cases, we should
>>>> custom the nested_msr_bitmap.
>>>> e.g.  Currently L0 wants to intercept some of the x2apic msrs' reading:
>>>>          if (enable_apicv) {
>>>>                 for (msr = 0x800; msr <= 0x8ff; msr++)
>>>>                 vmx_disable_intercept_msr_read_x2apic(msr); /*
>>>>                 According SDM, in x2apic mode, the whole id reg
>>>> is
>>> used.
>>>>                  * But in KVM, it only use the highest eight bits.
>>>> Need
> to
>>>>                  * intercept it */
>>>>                 vmx_enable_intercept_msr_read_x2apic(0x802); /* TMCCT
>>>>                 */ vmx_enable_intercept_msr_read_x2apic(0x839); /*
>>>>                 TPR */ vmx_disable_intercept_msr_write_x2apic(0x808);
> /*
>>>> EOI
>>> */
>>>>                 vmx_disable_intercept_msr_write_x2apic(0x80b); /*
>>>>                 SELF-IPI */
>>>>                 vmx_disable_intercept_msr_write_x2apic(0x83f);
>>>>         }
>>>> But L1 may not want this. So I think we are better to deal with
>>>> the
>>> 
>>> Actually, from L0's point, it is totally unaware of the L2. The only
>>> thing L0 aware is that the CPU should follow L0's configuration when
>>> VCPU is running. So if L0 wants to trap a msr, then the read operation
>>> to this msr should cause vmexit unconditionally no matter who is
>>> running(who means L1, L2, L3.....).
>>> 
>>>> msrs seperately, there is not a common way suit for all the cases.
>>>> If other features want to intercept a msr in nested entry, they
>>>> can put the custom code in nested_vmx_merge_msr_bitmap.
>>> 
>>> Yes, if other features want to do it in 'nested' entry, they can
>>> fill nested_vmx_merge_msr_bitmap. But if in non-nested case, it
>>> should be our responsibly to handle it correctly, how about add following check:
>>> 
>>> if (type & MSR_TYPE_R && !test_bit(msr, vmcs01_msr_bitmap) &&
>>> !test_bit(msr, msr_bitmap_l1 + 0x000 / f))
>>>         __clear_bit(msr, msr_bitmap_nested + 0x000 / f);
>> 
>> 
>> Anyway, this is not necessary for your current patch. We can consider
>> it later if there really have other features will use it.
>> 
> 
> Yep, I know what you mean now, for other msrs which are not forwarded
> access by a mechanism like virtual-apic page, we should intercept it
> unconditionally. I think we should ensure the msr can be allowed
> before call nested_vmx_disable_intercept_for_msr, if L0 want to
> intercept it, just do not call nested_vmx_disable_intercept_for_msr.

Yes, this is a solution. But I prefer to handle it in nested code path since others may not familiar with nested and may block it by mistake.

> 
>  !test_bit(msr, vmcs01_msr_bitmap) will introduce a problem that some
> of the msrs will be affcted by vmcs01_msr_bitmap, TMCCT and TPR, for example.
> Intercept reading for these msrs is okay, but it is not efficient.

TMCCT is always trapped by most VMM. I don't think TPR is trapped in KVM.

> 
> Thanks,
> Wincy


Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
