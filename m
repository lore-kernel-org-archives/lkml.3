Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab3HFScG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:32:06 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:49053 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3HFScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130806182309.2386.35697.sendpatchset@codeblue.in.ibm.com>
References: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
	<20130806182309.2386.35697.sendpatchset@codeblue.in.ibm.com>
Date: Tue, 6 Aug 2013 11:32:01 -0700
Message-ID: <CAG7+5M3_4D+hQn3xWefniKRWzkdraLCJKHG2PrLGPZLJQQUZVA@mail.gmail.com>
Subject: Re: [PATCH V12 3/5] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl
 to aid migration
From: Eric Northup <digitaleric@google.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
        habanero@linux.vnet.ibm.com, Rik van Riel <riel@redhat.com>,
        srivatsa.vaddagiri@gmail.com, KVM <kvm@vger.kernel.org>,
        linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        chegu_vinod@hp.com, drjones@redhat.com, ouyang@cs.pitt.edu,
        Andi Kleen <andi@firstfloor.org>, avi.kivity@gmail.com,
        Thomas Gleixner <tglx@linutronix.de>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 6, 2013 at 11:23 AM, Raghavendra K T
<raghavendra.kt@linux.vnet.ibm.com> wrote:
> kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
>
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> During migration, any vcpu that got kicked but did not become runnable
> (still in halted state) should be runnable after migration.

If this is about migration correctness, could it get folded into the
previous patch 2/5, so that there's not a broken commit which could
hurt bisection?

>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> Acked-by: Gleb Natapov <gleb@redhat.com>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kvm/x86.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dae4575..1e73dab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6284,7 +6284,12 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
>         kvm_apic_accept_events(vcpu);
> -       mp_state->mp_state = vcpu->arch.mp_state;
> +       if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
> +                                       vcpu->arch.pv.pv_unhalted)
> +               mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
> +       else
> +               mp_state->mp_state = vcpu->arch.mp_state;
> +
>         return 0;
>  }
>
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
