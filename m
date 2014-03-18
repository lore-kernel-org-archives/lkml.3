Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaCRO5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:57:41 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45942 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350AbaCROzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:55:08 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 3/4] KVM: ioapic: extract body of kvm_ioapic_set_irq
Date: Tue, 18 Mar 2014 15:54:54 +0100
Message-Id: <1395154495-22807-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will reuse it to process a nonzero IRR that is passed to KVM_SET_IRQCHIP.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/ioapic.c | 63 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 39 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 25e16a6898ed..7a573f1bb79e 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -163,6 +163,44 @@ static bool rtc_irq_check_coalesced(struct kvm_ioapic *ioapic)
 	return false;
 }
 
+static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
+		int level, bool line_status)
+{
+	union kvm_ioapic_redirect_entry entry;
+	u32 mask = 1 << irq;
+	u32 old_irr;
+	int edge, ret;
+
+	entry = ioapic->redirtbl[irq];
+	edge = (entry.fields.trig_mode == IOAPIC_EDGE_TRIG);
+
+	if (!level) {
+		ioapic->irr &= ~mask;
+		ret = 1;
+		goto out;
+	}
+
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
@@ -308,38 +346,15 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
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


