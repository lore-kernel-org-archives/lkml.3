Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965403AbaCUJ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:28:35 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:49353 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965297AbaCUJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:28:22 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, gleb@kernel.org, mtosatti@redhat.com,
        alex.williamson@redhat.com, jan.kiszka@siemens.com
Subject: [PATCH v2 4/4] KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
Date: Fri, 21 Mar 2014 10:28:01 +0100
Message-Id: <1395394081-16252-5-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
References: <1395394081-16252-1-git-send-email-pbonzini@redhat.com>
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
	v1->v2:
	use IOAPIC_NUM_PINS as a limit to for_each_set_bit
	remove debug printk

 virt/kvm/ioapic.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/ioapic.c b/virt/kvm/ioapic.c
index 270f7fe73f39..d4b601547f1f 100644
--- a/virt/kvm/ioapic.c
+++ b/virt/kvm/ioapic.c
@@ -212,6 +212,18 @@ out:
 	return ret;
 }
 
+static void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)
+{
+	u32 idx;
+
+	rtc_irq_eoi_tracking_reset(ioapic);
+	for_each_set_bit(idx, &irr, IOAPIC_NUM_PINS)
+		ioapic_set_irq(ioapic, idx, 1, true);
+
+	kvm_rtc_eoi_tracking_restore_all(ioapic);
+}
+
+
 static void update_handled_vectors(struct kvm_ioapic *ioapic)
 {
 	DECLARE_BITMAP(handled_vectors, 256);
@@ -612,9 +624,10 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
 
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

