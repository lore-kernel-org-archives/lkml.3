Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbaCROzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:55:12 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53950 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbaCROzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:55:10 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 4/4] KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
Date: Tue, 18 Mar 2014 15:54:55 +0100
Message-Id: <1395154495-22807-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the previous patches, an interrupt whose bit is set in the IRR
register will never be in the LAPIC's IRR and has never been injected
on the migration source.  So inject it on the destination.

This fixes migration of Windows guests without HPET (they use the RTC
to trigger the scheduler tick, and lose it after migration).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/ioapic.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 7a573f1bb79e..63fb432ab502 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -201,6 +201,19 @@ out:
 	return ret;
 }
 
+void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)
+{
+	u32 idx;
+
+	rtc_irq_eoi_tracking_reset(ioapic);
+	for_each_set_bit(idx, &irr, 32) {
+		printk("ioapic_service for GSI %d\n", idx);
+		ioapic_set_irq(ioapic, idx, 1, true);
+	}
+	kvm_rtc_eoi_tracking_restore_all(ioapic);
+}
+
+
 static void update_handled_vectors(struct kvm_ioapic *ioapic)
 {
 	DECLARE_BITMAP(handled_vectors, 256);
@@ -601,9 +614,10 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
 
 	spin_lock(&ioapic->lock);
 	memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
+	ioapic->irr = 0;
 	update_handled_vectors(ioapic);
 	kvm_vcpu_request_scan_ioapic(kvm);
-	kvm_rtc_eoi_tracking_restore_all(ioapic);
+	kvm_ioapic_inject_all(ioapic, state->irr);
 	spin_unlock(&ioapic->lock);
 	return 0;
 }
-- 
1.8.3.1

