Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760283AbbA1UeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:34:05 -0500
Received: from mga03.intel.com ([134.134.136.65]:56986 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605AbbA1UeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:34:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,479,1418112000"; 
   d="scan'208";a="668838937"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Wincy Van <fanwenyi0529@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "gleb@kernel.org" <gleb@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: RE: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Topic: [PATCH v3 1/6] KVM: nVMX: Use hardware MSR bitmap
Thread-Index: AQHQN79lT9Shw/DNlk+phY4fCFwl65zVMIRw
Date: Wed, 28 Jan 2015 08:00:25 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2C547@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
In-Reply-To: <CACzj_yUu5omqFL7u8NE6vyqXGy_-dAeukRspJha+EiGXVBzmYg@mail.gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0SKY9TQ006154

Wincy Van wrote on 2015-01-24:
> Currently, if L1 enables MSR_BITMAP, we will emulate this feature, all of L2's
> msr access is intercepted by L0. Since many features like virtualize x2apic mode
> has a complicated logic and it is difficult for us to emulate, we should use
> hardware and merge the bitmap.
> 
> This patch introduces nested_vmx_merge_msr_bitmap for future use.
> 
> Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
> ---
>  arch/x86/kvm/vmx.c |   71
> +++++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 60 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c index c987374..36d0724
> 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -798,6 +798,7 @@ static unsigned long *vmx_msr_bitmap_legacy;
> static unsigned long *vmx_msr_bitmap_longmode;  static unsigned long
> *vmx_msr_bitmap_legacy_x2apic;  static unsigned long
> *vmx_msr_bitmap_longmode_x2apic;
> +static unsigned long *vmx_msr_bitmap_nested;
>  static unsigned long *vmx_vmread_bitmap;  static unsigned long
> *vmx_vmwrite_bitmap;
> 
> @@ -5812,13 +5813,18 @@ static __init int hardware_setup(void)
>                                 (unsigned long
> *)__get_free_page(GFP_KERNEL);
>         if (!vmx_msr_bitmap_longmode_x2apic)
>                 goto out4;
> +
> +       vmx_msr_bitmap_nested = (unsigned long
> *)__get_free_page(GFP_KERNEL);
> +       if (!vmx_msr_bitmap_nested)
> +               goto out5;
> +

Since the nested virtualization is off by default. It's better to allocate the page
only when nested is true. Maybe adding the following check is better:

if (nested) {
        vmx_msr_bitmap_nested = (unsigned long *)__get_free_page(GFP_KERNEL);
        if (!vmx_msr_bitmap_nested)
                goto out5;
}

...snip...

> +
> +/*
> + * Merge L0's and L1's MSR bitmap, return false to indicate that
> + * we do not use the hardware.
> + */
> +static inline bool nested_vmx_merge_msr_bitmap(struct kvm_vcpu *vcpu,
> +                                              struct vmcs12
> *vmcs12) {
> +       return false;
> +}
> +

The following patches have nothing to do with the MSR control. Why leave the function empty here?

Best regards,
Yang


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
