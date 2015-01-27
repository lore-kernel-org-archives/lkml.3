Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbbA0VhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:37:10 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47514 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822AbbA0VhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:37:08 -0500
Message-ID: <54C804FD.6060108@redhat.com>
Date: Tue, 27 Jan 2015 22:37:01 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v3 2/6] KVM: nVMX: Enable nested virtualize x2apic mode.
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
In-Reply-To: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/01/2015 11:21, Wincy Van wrote:
> +       memset(vmx_msr_bitmap_nested, 0xff, PAGE_SIZE);

Most bytes are always 0xff.  It's better to initialize it to 0xff once,
and set the bit here if !nested_cpu_has_virt_x2apic_mode(vmcs12).

> +       if (nested_cpu_has_virt_x2apic_mode(vmcs12))

Please add braces here, because of the /* */ command below.

> +               /* TPR is allowed */
> +               nested_vmx_disable_intercept_for_msr(msr_bitmap,
> +                               vmx_msr_bitmap_nested,
> +                               APIC_BASE_MSR + (APIC_TASKPRI >> 4),
> +                               MSR_TYPE_R | MSR_TYPE_W);
> 
> +static inline int nested_vmx_check_virt_x2apic(struct kvm_vcpu *vcpu,
> +                                              struct vmcs12 *vmcs12)
> +{
> +       if (nested_cpu_has2(vmcs12, SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
> +               return -EINVAL;

No need for this function and nested_cpu_has_virt_x2apic_mode.  Just
inline them in their caller(s).  Same for other cases throughout the series.

Paolo

> +       return 0;
> +}
> +
> +static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
> +                                          struct vmcs12 *vmcs12)
> +{
> +       int r;
> +
> +       if (!nested_cpu_has_virt_x2apic_mode(vmcs12))
> +               return 0;
> +
> +       r = nested_vmx_check_virt_x2apic(vcpu, vmcs12);
> +       if (r)
> +               goto fail;
> +
