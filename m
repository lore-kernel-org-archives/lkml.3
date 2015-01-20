Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbbATJyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:54:24 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51183 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbbATJyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:54:22 -0500
Message-ID: <54BE25C8.4080603@redhat.com>
Date: Tue, 20 Jan 2015 10:54:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, gleb@kernel.org,
        yang.z.zhang@intel.com
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt processing.
References: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
In-Reply-To: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 20/01/2015 09:48, Wincy Van wrote:
> +static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
> +                                               int vector)
> +{
> +       int r = 0;
> +       struct vmcs12 *vmcs12;
> +
> +       /*
> +        * Since posted intr delivery is async,
> +        * we must aquire a spin-lock to avoid
> +        * the race of vmcs12.
> +        */
> +       spin_lock(&to_vmx(vcpu)->nested.vmcs12_lock);
> +       vmcs12 = get_vmcs12(vcpu);
> +       if (!is_guest_mode(vcpu) || !vmcs12) {
> +               r = -1;
> +               goto out;
> +       }

is_guest_mode should be checked first outside the lock, to avoid
affecting the non-nested fast path.  You can then recheck it later
inside the lock.

Another way to avoid the spinlock: in prepare_vmcs02 or a similar place,
you can save vmcs12->posted_intr_nv in a new field
vmx->nested.posted_intr_nv; just set it to -1 if
!nested_cpu_has_posted_intr(vmcs12).  In vmclear, again you just set the
field to -1, and here you can do

	if (!is_guest_mode(vcpu) ||
	    vector != to_vmx(vcpu)->nested.posted_intr_nv) {
		r = -1;
		goto out;
	}

You don't need to access vmcs12, and while there is a race, it's okay
because there is no pointer access.

> 
> +               if (vcpu->mode == IN_GUEST_MODE)
> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
> +                               POSTED_INTR_VECTOR);

Please add a comment that PIR and ON have been set by the L1 hypervisor.

I'll do a full review the other patches as soon as possible.

Paolo

> +               else {
> +                       r = -1;
> +                       goto out;
> +               }
> +
> +               /*
> +                * if posted intr is done by hardware, the
> +                * corresponding eoi was sent to L0. Thus
> +                * we should send eoi to L1 manually.
> +                */
> +               kvm_apic_set_eoi_accelerated(vcpu,
> +                       vmcs12->posted_intr_nv);
