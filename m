Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaGHFvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 01:51:04 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:39499 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbaGHFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 01:51:03 -0400
Message-ID: <53BB86C2.9040805@redhat.com>
Date: Tue, 08 Jul 2014 07:50:58 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@kernel.org>
Subject: Re: [PATCH] KVM: x86: Check for nested events if there is an injectable
 interrupt
References: <jpgd2dgfp5s.fsf@redhat.com>
In-Reply-To: <jpgd2dgfp5s.fsf@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/07/2014 06:30, Bandan Das ha scritto:
>
> With commit b6b8a1451fc40412c57d1 that introduced
> vmx_check_nested_events, checks for injectable interrupts happen
> at different points in time for L1 and L2 that could potentially
> cause a race. The regression occurs because KVM_REQ_EVENT is always
> set when nested_run_pending is set even if there's no pending interrupt.
> Consequently, there could be a small window when check_nested_events
> returns without exiting to L1, but an interrupt comes through soon
> after and it incorrectly, gets injected to L2 by inject_pending_event
> Fix this by adding a call to check for nested events too when a check
> for injectable interrupt returns true
>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 73537ec..56327a6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5907,6 +5907,19 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
>  			kvm_x86_ops->set_nmi(vcpu);
>  		}
>  	} else if (kvm_cpu_has_injectable_intr(vcpu)) {
> +		/*
> +		 * TODO/FIXME: We are calling check_nested_events again
> +		 * here to avoid a race condition. We should really be
> +		 * setting KVM_REQ_EVENT only on certain events
> +		 * and not unconditionally.
> +		 * See https://lkml.org/lkml/2014/7/2/60 for discussion
> +		 * about this proposal and current concerns
> +		 */
> +		if (is_guest_mode(vcpu) && kvm_x86_ops->check_nested_events) {
> +			r = kvm_x86_ops->check_nested_events(vcpu, req_int_win);
> +			if (r != 0)
> +				return r;
> +		}
>  		if (kvm_x86_ops->interrupt_allowed(vcpu)) {
>  			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu),
>  					    false);
>

I think this should be done for NMI as well.

Jan, what do you think?  Can you run Jailhouse through this patch?

Paolo
