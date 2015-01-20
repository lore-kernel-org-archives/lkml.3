Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbbATHkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:40:55 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:39524 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbbATHkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:40:53 -0500
Message-ID: <54BE04F7.7030402@redhat.com>
Date: Tue, 20 Jan 2015 08:34:15 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>
CC: gleb@kernel.org, yang.z.zhang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH 5/5] KVM: nVMX: Enable nested posted interrupt processing.
References: <CACzj_yWjkW0azZGEVHKkQZJWRjNykxCfBRz=tEA=d624WGzccw@mail.gmail.com> <54BCEDD5.40301@redhat.com> <CACzj_yVTWDB6_JMsV_itHoOudBio1YgkBosBYz70O6JeQ6w_Ug@mail.gmail.com>
In-Reply-To: <CACzj_yVTWDB6_JMsV_itHoOudBio1YgkBosBYz70O6JeQ6w_Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/01/2015 13:34, Wincy Van wrote:
> 
> Actually, there is a race window between
> vmx_deliver_nested_posted_interrupt and nested_release_vmcs12
> since posted intr delivery is async:
> 
>          cpu 1
>           cpu 2
> (nested posted intr)                                      (dest vcpu,
> release vmcs12)
> vmcs12 = get_vmcs12(vcpu);
> if (!is_guest_mode(vcpu) || !vmcs12) {
>         r = -1;
>         goto out;
> }
> 
> 
> kunmap(vmx->nested.current_vmcs12_page);
> 
>        ......
> 
> 
> oops! current vmcs12 is invalid.
> 
> However, we have already checked that the destination vcpu
> is_in_guest_mode, and if L1
> want to destroy vmcs12(in handle_vmptrld/clear, etc..), the dest vcpu
> must have done a nested
> vmexit and a non-nested vmexit(handle_vmptr***).
> 
> Hence, we can disable local interrupts while delivering nested posted
> interrupts to make sure
> we are faster than the destination vcpu. This is a bit tricky but it
> an avoid that race. I think we
> do not need to add a spin lock here. RCU does not fit this case, since
> it will introduce a
> new race window between the rcu handler and handle_vmptr**.
> 
> I am wondering that whether there is a better way : )

Why not just use a spinlock?

Paolo
