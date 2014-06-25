Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbaFYJce (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 05:32:34 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51350 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755332AbaFYJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 05:28:57 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, eric.auger@linaro.org,
        Christoffer Dall <christoffer.dall@linaro.org>
Subject: [RFC PATCH 0/9] ARM: Forwarding physical interrupts to a guest VM
Date: Wed, 25 Jun 2014 10:28:41 +0100
Message-Id: <1403688530-23273-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GIC architecture (ARM's Generic Interrupt Controller) allows an
active physical interrupt to be forwarded to a guest, and the guest to
indirectly perform the deactivation of the interrupt by performing an
EOI on the virtual interrupt (see for example the GICv2 spec, 3.2.1).

So far, Linux doesn't have this notion, which is a bit of a pain.

This patch series introduce two generic features:

- A way to mark an interrupt as "forwarded": this allows an irq_chip
  to know that it shouldn't perform the deactivation itself
- A way to save/restore the "state" of a "forwarded" interrupt

The series then adapts both GIC drivers to switch to EOImode == 1
(split priority drop and deactivation), to support this "forwarded"
feature and hacks the KVM/ARM timer backend to use all of this.

This requires yet another bit of surgery in the vgic code in order to
allow a mapping between physical interrupts and virtual
ones. Hopefully, this should plug into VFIO and the whole irqfd thing,
but I don't understand any of that just yet (Eric?)

The patches are against 3.16-rc2, plus a massive amount of GICv3
code. They are also available in my git repo:
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/irq-forward

Open questions (Thomas, these are mostly targeted at you):

- Are the generic features generic enough?
- Would the "forwarded" thing be better implemented as a handler
  rather than an irq_chip specific thing?
- The split priority drop/deactivate also fits the threaded interrupt
  model fairly well (no need to mask/unmask). Should we have a go at
  this too?
- Does it fit the VFIO+KVM model without playing the ugly mask/unmask
  dance?

Thanks,

	M.

Marc Zyngier (9):
  genirq: Add IRQD_IRQ_FORWARDED flag and accessors
  genirq: Allow the state of a  forwarded irq to be save/restored
  irqchip: GIC: Convert to EOImode == 1
  irqchip: GIC: add support for forwarded interrupts
  irqchip: GICv3: Convert to EOImode == 1
  irqchip: GICv3: add support for forwarded interrupts
  KVM: arm: vgic: allow dynamic mapping of physical/virtual interrupts
  arm: KVM: timer: move the timer switch into the non-preemptible
    section
  KVM: arm: timer: make the interrupt state part of the timer state

 arch/arm/kvm/arm.c                 |   7 +--
 drivers/irqchip/irq-gic-v3-its.c   |   2 +
 drivers/irqchip/irq-gic-v3.c       |  33 +++++++++++-
 drivers/irqchip/irq-gic.c          | 107 +++++++++++++++++++++++++++++++++----
 include/kvm/arm_arch_timer.h       |   3 ++
 include/kvm/arm_vgic.h             |  13 +++++
 include/linux/interrupt.h          |   2 +
 include/linux/irq.h                |  32 +++++++++++
 include/linux/irqchip/arm-gic-v3.h |  12 +++++
 include/linux/irqchip/arm-gic.h    |   5 ++
 kernel/irq/manage.c                |  80 +++++++++++++++++++++++++++
 virt/kvm/arm/arch_timer.c          |  31 ++++++++++-
 virt/kvm/arm/vgic-v2.c             |  14 ++++-
 virt/kvm/arm/vgic-v3.c             |  22 +++++++-
 virt/kvm/arm/vgic.c                |  88 ++++++++++++++++++++++++++++++
 15 files changed, 431 insertions(+), 20 deletions(-)

-- 
1.8.3.4

