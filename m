Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285AbaCROzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:55:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:48307 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaCROzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:55:06 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 2/4] KVM: ioapic: clear IRR for edge-triggered interrupts at delivery
Date: Tue, 18 Mar 2014 15:54:53 +0100
Message-Id: <1395154495-22807-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that IRR bits are set in the KVM_GET_IRQCHIP result only if
the interrupt is still sitting in the IOAPIC.  After the next patches, it
avoids spurious reinjection of the interrupt when KVM_SET_IRQCHIP is
called.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/ioapic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 0b4914147b9d..25e16a6898ed 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -288,6 +288,9 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 	irqe.level = 1;
 	irqe.shorthand = 0;
 
+	if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
+		ioapic->irr &= ~(1 << irq);
+
 	if (irq == RTC_GSI && line_status) {
 		BUG_ON(ioapic->rtc_status.pending_eoi != 0);
 		ret = kvm_irq_delivery_to_apic(ioapic->kvm, NULL, &irqe,
-- 
1.8.3.1


