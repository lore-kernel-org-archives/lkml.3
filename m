Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbbAUIop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:44:45 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53317 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbbAUIo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:44:26 -0500
MIME-Version: 1.0
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC2629C@SHSMSX104.ccr.corp.intel.com>
References: <CACzj_yWxK9d_47a9ZHqtk2HSJBN6+LvtDScQqWd5znfSt8ia0Q@mail.gmail.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AC2629C@SHSMSX104.ccr.corp.intel.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 21 Jan 2015 16:44:03 +0800
Message-ID: <CACzj_yWDkuNxu=-Fqy3aPJJ_sveeCtmjKJRAvEjsNb+-7kdjAQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] KVM: nVMX: Enable nested posted interrupt processing.
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

On Wed, Jan 21, 2015 at 4:07 PM, Zhang, Yang Z <yang.z.zhang@intel.com> wrote:
>> +       if (vector == vmcs12->posted_intr_nv &&
>> +           nested_cpu_has_posted_intr(vmcs12)) {
>> +               if (vcpu->mode == IN_GUEST_MODE)
>> +                       apic->send_IPI_mask(get_cpu_mask(vcpu->cpu),
>> +                               POSTED_INTR_VECTOR);
>> +               else {
>> +                       r = -1;
>> +                       goto out;
>> +               }
>> +
>> +               /*
>> +                * if posted intr is done by hardware, the
>> +                * corresponding eoi was sent to L0. Thus
>> +                * we should send eoi to L1 manually.
>> +                */
>> +               kvm_apic_set_eoi_accelerated(vcpu,
>> +                       vmcs12->posted_intr_nv);
>
> Why this is necessary? As your comments mentioned, it is done by hardware not L1, why L1 should aware of it?
>

According to SDM 29.6, if the processor recognizes a posted interrupt,
it will send an EOI to LAPIC.
If the posted intr is done by hardware, the processor will send eoi to
hardware LAPIC, not L1's, just
like the none-nested case(the physical interrupt is dismissed). So we
should take care of the L1's
LAPIC and send an eoi to it.


Thanks,

Wincy
