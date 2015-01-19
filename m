Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbbASM4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:56:50 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:56068 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbASM4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <54BCEDD5.40301@redhat.com>
References: <CACzj_yWjkW0azZGEVHKkQZJWRjNykxCfBRz=tEA=d624WGzccw@mail.gmail.com>
 <54BCEDD5.40301@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Mon, 19 Jan 2015 20:34:10 +0800
Message-ID: <CACzj_yVTWDB6_JMsV_itHoOudBio1YgkBosBYz70O6JeQ6w_Ug@mail.gmail.com>
Subject: Re: [PATCH 5/5] KVM: nVMX: Enable nested posted interrupt processing.
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: gleb@kernel.org, yang.z.zhang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 7:43 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Hi Wincy,
>
> there is only one thing that I don't understand in this patchset, and it is:
>
> On 16/01/2015 06:59, Wincy Van wrote:
>> +       /*
>> +        * if vcpu is in L2, we are fast enough to complete
>> +        * before L1 changes/destroys vmcs12.
>> +        */
>
> ... this comment.  What do you mean exactly?
>

Hi, Paolo,

Actually, there is a race window between
vmx_deliver_nested_posted_interrupt and nested_release_vmcs12
since posted intr delivery is async:

         cpu 1
          cpu 2
(nested posted intr)                                      (dest vcpu,
release vmcs12)
vmcs12 = get_vmcs12(vcpu);
if (!is_guest_mode(vcpu) || !vmcs12) {
        r = -1;
        goto out;
}


kunmap(vmx->nested.current_vmcs12_page);

       ......


oops! current vmcs12 is invalid.

However, we have already checked that the destination vcpu
is_in_guest_mode, and if L1
want to destroy vmcs12(in handle_vmptrld/clear, etc..), the dest vcpu
must have done a nested
vmexit and a non-nested vmexit(handle_vmptr***).

Hence, we can disable local interrupts while delivering nested posted
interrupts to make sure
we are faster than the destination vcpu. This is a bit tricky but it
an avoid that race. I think we
do not need to add a spin lock here. RCU does not fit this case, since
it will introduce a
new race window between the rcu handler and handle_vmptr**.

I am wondering that whether there is a better way : )

Thanks,

Wincy
