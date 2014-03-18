Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969AbaCRO1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:27:20 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57153 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbaCRO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:27:17 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, mtosatti@redhat.com
Subject: [PATCH 0/4] KVM: cleanup ioapic and fix KVM_SET_IRQCHIP with irr != 0
Date: Tue, 18 Mar 2014 15:27:05 +0100
Message-Id: <1395152829-22694-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unlike the old qemu-kvm, which really never did that, with new QEMU
it is for some reason somewhat likely to migrate a VM with a nonzero
IRR in the ioapic.  In the case of ISA edge-triggered interrupts,
this represents an interrupt that has not left the IOAPIC, which would
be okay but it is not handled right by KVM_SET_IRQCHIP.  Because the
interrupt is never injected, the guest never acknowledges it, the host
never deasserts the pin and new interrupts are dropped.

There are two problems to solve.

The obvious one is that interrupts are not reinjected upon KVM_SET_IRQCHIP,
which is taken care of by patches 3-4.

The second is that right now the IRR value depends on the falling edge
of the interrupt (as passed by the userspace via kvm_ioapic_set_irq).
This is unnecessary, and may lead to spurious reinjection in the
destination of migration; instead, we can clear the (internal-only)
IRR bit as soon as the interrupt leaves the IOAPIC.  This is done by
patch 2, which patch 1 prepares for.

This fixes migration of Windows guests without HPET.  Please review.

Paolo

Paolo Bonzini (4):
  KVM: ioapic: merge ioapic_deliver into ioapic_service
  KVM: ioapic: clear IRR for edge-triggered interrupts at delivery
  KVM: ioapic: extract body of kvm_ioapic_set_irq
  KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP

 virt/kvm/ioapic.c | 97 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 59 insertions(+), 38 deletions(-)

-- 
1.8.3.1

