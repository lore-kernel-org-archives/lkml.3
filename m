Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaCXSBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 14:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554AbaCXSBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 14:01:48 -0400
Date: Mon, 24 Mar 2014 18:59:32 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gleb@kernel.org,
        mtosatti@redhat.com, alex.williamson@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 0/4] KVM: cleanup ioapic and fix KVM_SET_IRQCHIP with
 irr != 0
Message-ID: <20140324175932.GA9199@potion.brq.redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-21 10:27+0100, Paolo Bonzini:
> Unlike the old qemu-kvm, which really never did that, with new QEMU
> it is for some reason somewhat likely to migrate a VM with a nonzero
> IRR in the ioapic.  In the case of ISA edge-triggered interrupts,
> this represents an interrupt that has not left the IOAPIC, which would
> be okay but it is not handled right by KVM_SET_IRQCHIP.  Because the
> interrupt is never injected, the guest never acknowledges it, the host
> never deasserts the pin and new interrupts are dropped.
> 
> There are two problems to solve.
> 
> The obvious one is that interrupts are not reinjected upon KVM_SET_IRQCHIP,
> which is taken care of by patches 3-4.
> 
> The second is that right now the IRR value depends on the falling edge
> of the interrupt (as passed by the userspace via kvm_ioapic_set_irq).
> This is unnecessary, and may lead to spurious reinjection in the
> destination of migration; instead, we can clear the (internal-only)
> IRR bit as soon as the interrupt leaves the IOAPIC.  This is done by
> patch 2, which patch 1 prepares for.
> 
> This fixes migration of Windows guests without HPET.  Please review.
> 
> Paolo
> 
> v1->v2:
> 	more comments in patch 3
> 	change argument name in patch 3 from level to irq_level
> 	use IOAPIC_NUM_PINS in patch 4 as a limit to for_each_set_bit
> 	remove debug printk in patch 4

Nice solution to a tricky problem,

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>

> Paolo Bonzini (4):
>   KVM: ioapic: merge ioapic_deliver into ioapic_service
>   KVM: ioapic: clear IRR for edge-triggered interrupts at delivery
>   KVM: ioapic: extract body of kvm_ioapic_set_irq
>   KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
> 
>  virt/kvm/ioapic.c | 107 +++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 69 insertions(+), 38 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
