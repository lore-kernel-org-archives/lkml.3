Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbbATK20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:28:26 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65299 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbbATK2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:28:25 -0500
MIME-Version: 1.0
In-Reply-To: <54BE25C8.4080603@redhat.com>
References: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
 <54BE25C8.4080603@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Tue, 20 Jan 2015 18:28:01 +0800
Message-ID: <CACzj_yX+gmO53ihSOg7c3_6K5B5nTDe-=Ec0CgogKbSbB=isyg@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt processing.
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@kernel.org, yang.z.zhang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 5:54 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 20/01/2015 09:48, Wincy Van wrote:
>> +static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
>> +                                               int vector)
>> +{
>> +       int r = 0;
>> +       struct vmcs12 *vmcs12;
>> +
>> +       /*
>> +        * Since posted intr delivery is async,
>> +        * we must aquire a spin-lock to avoid
>> +        * the race of vmcs12.
>> +        */
>> +       spin_lock(&to_vmx(vcpu)->nested.vmcs12_lock);
>> +       vmcs12 = get_vmcs12(vcpu);
>> +       if (!is_guest_mode(vcpu) || !vmcs12) {
>> +               r = -1;
>> +               goto out;
>> +       }
>
> is_guest_mode should be checked first outside the lock, to avoid
> affecting the non-nested fast path.  You can then recheck it later
> inside the lock.

Agreed, will do.

>
> Another way to avoid the spinlock: in prepare_vmcs02 or a similar place,
> you can save vmcs12->posted_intr_nv in a new field
> vmx->nested.posted_intr_nv; just set it to -1 if
> !nested_cpu_has_posted_intr(vmcs12).  In vmclear, again you just set the
> field to -1, and here you can do
>
>         if (!is_guest_mode(vcpu) ||
>             vector != to_vmx(vcpu)->nested.posted_intr_nv) {
>                 r = -1;
>                 goto out;
>         }
>
> You don't need to access vmcs12, and while there is a race, it's okay
> because there is no pointer access.

That's a good idea. I will apply it to the next version.

>
>>
>> +               if (vcpu->mode == IN_GUEST_MODE)
>> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
>> +                               POSTED_INTR_VECTOR);
>
> Please add a comment that PIR and ON have been set by the L1 hypervisor.

Will do.

>
> I'll do a full review the other patches as soon as possible.
>

Thank you, I will send v3 after it is done.


Wincy
