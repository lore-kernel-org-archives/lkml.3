Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282AbaFYOxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:53:13 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:47697 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbaFYOxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:53:11 -0400
Message-ID: <53AAE242.3060405@linaro.org>
Date: Wed, 25 Jun 2014 16:52:50 +0200
From: Eric Auger <eric.auger@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 0/9] ARM: Forwarding physical interrupts to a guest
 VM
References: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
In-Reply-To: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2014 11:28 AM, Marc Zyngier wrote:
> The GIC architecture (ARM's Generic Interrupt Controller) allows an
> active physical interrupt to be forwarded to a guest, and the guest to
> indirectly perform the deactivation of the interrupt by performing an
> EOI on the virtual interrupt (see for example the GICv2 spec, 3.2.1).
> 
> So far, Linux doesn't have this notion, which is a bit of a pain.
> 
> This patch series introduce two generic features:
> 
> - A way to mark an interrupt as "forwarded": this allows an irq_chip
>   to know that it shouldn't perform the deactivation itself
> - A way to save/restore the "state" of a "forwarded" interrupt
> 
> The series then adapts both GIC drivers to switch to EOImode == 1
> (split priority drop and deactivation), to support this "forwarded"
> feature and hacks the KVM/ARM timer backend to use all of this.
> 
> This requires yet another bit of surgery in the vgic code in order to
> allow a mapping between physical interrupts and virtual
> ones. Hopefully, this should plug into VFIO and the whole irqfd thing,
> but I don't understand any of that just yet (Eric?)

Hello Marc,

Thanks for the patch, it brings a very interesting capability for
improving the performance of KVM device assignment.

>From the integration pov I understand we need to
1) call irq_set_fwd_state to tell the gic the physical IRQ is forwarded
and not deactivate it
2) call vgic_map_phys_irq to the tell the vgic it must program the LRs
accordingly.

We currently have the vfio driver VFIO_DEVICE_SET_IRQS user API that
makes possible to tell: device IRQ index #i (i=0, 1, 2 for my xgmac)
shall trigger this fd.
At that point it would be possible to tell the GIC the physical IRQ
corresponding to i is forwarded.

On the other hand we have KVM_IRQFD that enables to tell KVM: when this
fd is triggered, you implement its handler in KVM irqfd framework and
the handler injects the provided irchip.pin(gsi)=virtualIRQ - the famous
GSI routing table - into this VM.

Building the vgic map table hence requires to do some glue around vfio
and irqfd info: physical IRQ ->(vfio) fd ->(irqfd) gsi.

As such I would say those 2 user APIs(VFIO and IRQFD) are not fully
adapted to put that in place but this may be feasible. Previous
KVM_ASSIGN_DEV_IRQ was directly associated the pIRQ and vIRQ.

we should be able to remove the physical IRQ mask in the vfio driver
(this masking is done when triggering the fd and the IRQ is unmasked
when the virtual IRQ is completed). It was there because the physical
IRQ was completed and could hit again. Now with 2 stage completion the
same IRQ cannot hit while guest has not not DIR'ed the IRQ so it fixes
the issue I guess.

Since we do not have EOI trap anymore we cannot trigger level-sensitive
resamplefd in irqfd (this would be an ARM specificity)

A last comment/question, wouldn't it be possible to inject the vIRQ
(programming the LR) direcly in the irqchip, instead of relying on VFIO
to trigger an eventfd whose handler does the job? This could be an
optional capavility per forwarded IRQ. Of course this would create a
relationship between gic and vgic. Do you see it as ugly - I dare to ask - ?

BR

Eric


> 
> The patches are against 3.16-rc2, plus a massive amount of GICv3
> code. They are also available in my git repo:
> git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/irq-forward
> 
> Open questions (Thomas, these are mostly targeted at you):
> 
> - Are the generic features generic enough?
> - Would the "forwarded" thing be better implemented as a handler
>   rather than an irq_chip specific thing?
> - The split priority drop/deactivate also fits the threaded interrupt
>   model fairly well (no need to mask/unmask). Should we have a go at
>   this too?
> - Does it fit the VFIO+KVM model without playing the ugly mask/unmask
>   dance?
> 
> Thanks,
> 
> 	M.
> 
> Marc Zyngier (9):
>   genirq: Add IRQD_IRQ_FORWARDED flag and accessors
>   genirq: Allow the state of a  forwarded irq to be save/restored
>   irqchip: GIC: Convert to EOImode == 1
>   irqchip: GIC: add support for forwarded interrupts
>   irqchip: GICv3: Convert to EOImode == 1
>   irqchip: GICv3: add support for forwarded interrupts
>   KVM: arm: vgic: allow dynamic mapping of physical/virtual interrupts
>   arm: KVM: timer: move the timer switch into the non-preemptible
>     section
>   KVM: arm: timer: make the interrupt state part of the timer state
> 
>  arch/arm/kvm/arm.c                 |   7 +--
>  drivers/irqchip/irq-gic-v3-its.c   |   2 +
>  drivers/irqchip/irq-gic-v3.c       |  33 +++++++++++-
>  drivers/irqchip/irq-gic.c          | 107 +++++++++++++++++++++++++++++++++----
>  include/kvm/arm_arch_timer.h       |   3 ++
>  include/kvm/arm_vgic.h             |  13 +++++
>  include/linux/interrupt.h          |   2 +
>  include/linux/irq.h                |  32 +++++++++++
>  include/linux/irqchip/arm-gic-v3.h |  12 +++++
>  include/linux/irqchip/arm-gic.h    |   5 ++
>  kernel/irq/manage.c                |  80 +++++++++++++++++++++++++++
>  virt/kvm/arm/arch_timer.c          |  31 ++++++++++-
>  virt/kvm/arm/vgic-v2.c             |  14 ++++-
>  virt/kvm/arm/vgic-v3.c             |  22 +++++++-
>  virt/kvm/arm/vgic.c                |  88 ++++++++++++++++++++++++++++++
>  15 files changed, 431 insertions(+), 20 deletions(-)
> 

