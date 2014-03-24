Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaCXOMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 10:12:33 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:64405 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbaCXOMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 10:12:30 -0400
MIME-Version: 1.0
Date: Mon, 24 Mar 2014 19:42:30 +0530
X-Google-Sender-Auth: JucAqoG0UsoPtNt1bKpJ9_7-CQ8
Message-ID: <CAC4Lta3Bhh45HLjuMPQam_2WyWsTrLoo+bt5jx48KmBkrY0aAw@mail.gmail.com>
Subject: Re: Enhancement for PLE handler in KVM
From: Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
To: "Li, Bin (Bin)" <bin.bl.li@alcatel-lucent.com>
Cc: KVM <kvm@vger.kernel.org>, Neel Jatania <neel.jatania@alcatel-lucent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 11:54 PM, Li, Bin (Bin)
<bin.bl.li@alcatel-lucent.com> wrote:
> Hello, all.
>
> The PLE handler attempts to determine an alternate vCPU to schedule.  In
> some cases the wrong vCPU is scheduled and performance suffers.
>
> This patch allows for the guest OS to signal, using a hypercall, that it's
> starting/ending a critical section.  Using this information in the PLE
> handler allows for a more intelligent VCPU scheduling determination to be
> made.  The patch only changes the PLE behaviour if this new hypercall
> mechanism is used; if it isn't used, then the existing PLE algorithm
> continues to be used to determine the next vCPU.
>
> Benefit from the patch:
>  -  the guest OS real time performance being significantly improved when
> using hyper call marking entering and leaving guest OS kernel state.
>  - The guest OS system clock jitter measured on on Intel E5 2620 reduced
> from 400ms down to 6ms.
>  - The guest OS system lock is set to a 2ms clock interrupt. The jitter is
> measured by the difference between dtsc() value in clock interrupt handler
> and the expectation of tsc value.
>  - detail of test report is attached as reference.
>
> Path details:
>
> From 77edfa193a4e29ab357ec3b1e097f8469d418507 Mon Sep 17 00:00:00 2001
>
> From: Bin BL LI <bin.bl.li@alcatel-lucent.com>
>
> Date: Mon, 3 Mar 2014 11:23:35 -0500
>
> Subject: [PATCH] Initial commit
>
> ---
>
>  arch/x86/kvm/x86.c            |    7 +++++++
>
>  include/linux/kvm_host.h      |   16 ++++++++++++++++
>
>  include/uapi/linux/kvm_para.h |    2 ++
>
>  virt/kvm/kvm_main.c           |   14 +++++++++++++-
>
>  4 files changed, 38 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>
> index 39c28f0..e735de3 100644
>
> --- a/arch/x86/kvm/x86.c
>
> +++ b/arch/x86/kvm/x86.c
>
> @@ -5582,6 +5582,7 @@ void kvm_arch_exit(void)
>
>  int kvm_emulate_halt(struct kvm_vcpu *vcpu)
>
>  {
>
>      ++vcpu->stat.halt_exits;
>
> +    kvm_vcpu_set_holding_lock(vcpu,false);
>
>      if (irqchip_in_kernel(vcpu->kvm)) {
>
>          vcpu->arch.mp_state = KVM_MP_STATE_HALTED;
>
>          return 1;
>

Joining late to comment on this :(.

Seeing that you are  trying to set 'holding_lock'  in halt handling
path, I am just curious if you could try
https://lkml.org/lkml/2013/7/22/41 to see if you get any benefits. [
We could not get any convincing
 benefit during pv patch posting and dropped it].

 and regarding SPIN_THRESHOLD tuning,  I did some experiment by
dynamically tuning loop count
based on head,tail vaules (for e.g. if we are nearer to the
lock-holder in the queue  loop longer), but that
also did not yield much result.

[...]
