Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965487AbaCUJah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:30:37 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62063 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965197AbaCUJ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:28:17 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        alex.williamson@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH v2 2/4] KVM: ioapic: clear IRR for edge-triggered interrupts at delivery
Date: Fri, 21 Mar 2014 10:27:59 +0100
Message-Id: <1395394081-16252-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This ensures that IRR bits are set in the KVM_GET_IRQCHIP result only if
the interrupt is still sitting in the IOAPIC.  After the next patches, it
avoids spurious reinjection of the interrupt when KVM_SET_IRQCHIP is
called.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
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


