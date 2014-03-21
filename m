Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965469AbaCUJ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:29:30 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:52786 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965237AbaCUJ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:28:19 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        alex.williamson@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH v2 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
Date: Fri, 21 Mar 2014 10:28:00 +0100
Message-Id: <1395394081-16252-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will reuse it to process a nonzero IRR that is passed to KVM_SET_IRQCHIP.

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2:
	more comments
	change argument name from level to irq_level

 virt/kvm/ioapic.c | 74 +++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 25e16a6898ed..270f7fe73f39 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -163,6 +163,55 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
 	return false;
 }
 
+static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
+		int irq_level, bool line_status)
+{
+	union kvm_ioapic_redirect_entry entry;
+	u32 mask = 1 << irq;
+	u32 old_irr;
+	int edge, ret;
+
+	entry = ioapic->redirtbl[irq];
+	edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
+
+	if (!irq_level) {
+		ioapic->irr &= ~mask;
+		ret = 1;
+		goto out;
+	}
+
+	/*
+	 * Return 0 for coalesced interrupts; for edge-triggered interrupts,
+	 * this only happens if a previous edge has not been delivered due
+	 * do masking.  For level interrupts, the remote_irr field tells
+	 * us if the interrupt is waiting for an EOI.
+	 *
+	 * RTC is special: it is edge-triggered, but userspace likes to know
+	 * if it has been already ack-ed via EOI because coalesced RTC
+	 * interrupts lead to time drift in Windows guests.  So we track
+	 * EOI manually for the RTC interrupt.
+	 */
+	if (irq == RTC_GSI && line_status &&
+		rtc_irq_check_coalesced(ioapic)) {
+		ret = 0;
+		goto out;
+	}
+
+	old_irr = ioapic->irr;
+	ioapic->irr |= mask;
+	if ((edge && old_irr == ioapic->irr) ||
+	    (!edge && entry.fields.remote_irr)) {
+		ret = 0;
+		goto out;
+	}
+
+	ret = ioapic_service(ioapic, irq, line_status);
+
+out:
+	trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
+	return ret;
+}
+
 static void update_handled_vectors(struct kvm_ioapic *ioapic)
 {
 	DECLARE_BITMAP(handled_vectors, 256);
@@ -308,38 +357,15 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 int kvm_ioapic_set_irq(struct kvm_ioapic *ioapic, int irq, int irq_source_id,
 		       int level, bool line_status)
 {
-	u32 old_irr;
-	u32 mask = 1 << irq;
-	union kvm_ioapic_redirect_entry entry;
 	int ret, irq_level;
 
 	BUG_ON(irq < 0 || irq >= IOAPIC_NUM_PINS);
 
 	spin_lock(&ioapic->lock);
-	old_irr = ioapic->irr;
 	irq_level = __kvm_irq_line_state(&ioapic->irq_states[irq],
 					 irq_source_id, level);
-	entry = ioapic->redirtbl[irq];
-	if (!irq_level) {
-		ioapic->irr &= ~mask;
-		ret = 1;
-	} else {
-		int edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
+	ret = ioapic_set_irq(ioapic, irq, irq_level, line_status);
 
-		if (irq == RTC_GSI && line_status &&
-			rtc_irq_check_coalesced(ioapic)) {
-			ret = 0; /* coalesced */
-			goto out;
-		}
-		ioapic->irr |= mask;
-		if ((edge && old_irr != ioapic->irr) ||
-		    (!edge && !entry.fields.remote_irr))
-			ret = ioapic_service(ioapic, irq, line_status);
-		else
-			ret = 0; /* report coalesced interrupt */
-	}
-out:
-	trace_kvm_ioapic_set_irq(entry.bits, irq, ret == 0);
 	spin_unlock(&ioapic->lock);
 
 	return ret;
-- 
1.8.3.1


