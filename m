Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaLXDPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 22:15:30 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:57811 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbaLXDP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 22:15:26 -0500
From: Wincy Van <fanwenyi0529@gmail.com>
To: pbonzini@redhat.com, bsd@redhat.com
Cc: yang.z.zhang@intel.com, wanpeng.li@linux.intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, fanwenyi0529@gmail.com
Subject: [PATCH 1/1] KVM: ioapic: Record edge-triggered interrupts delivery status.
Date: Wed, 24 Dec 2014 11:14:29 +0800
Message-Id: <1419390869-1636-1-git-send-email-fanwenyi0529@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the bug discussed in
https://www.mail-archive.com/kvm@vger.kernel.org/msg109813.html

This patch uses a new field named irr_delivered to record the
delivery status of edge-triggered interrupts, and clears the
delivered interrupts in kvm_get_ioapic. So it has the same effect
of commit 0bc830b05c667218d703f2026ec866c49df974fc
("KVM: ioapic: clear IRR for edge-triggered interrupts at delivery")
while avoids the bug of Windows guests.

Signed-off-by: Wincy Van <fanwenyi0529@gmail.com>
---
 arch/x86/kvm/ioapic.c |    7 ++++++-
 arch/x86/kvm/ioapic.h |    1 +
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index b1947e0..a2e9d96 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -206,6 +206,8 @@ static int ioapic_set_irq(struct kvm_ioapic *ioapic, unsigned int irq,
 
 	old_irr = ioapic->irr;
 	ioapic->irr |= mask;
+	if (edge)
+		ioapic->irr_delivered &= ~mask;
 	if ((edge && old_irr == ioapic->irr) ||
 	    (!edge && entry.fields.remote_irr)) {
 		ret = 0;
@@ -349,7 +351,7 @@ static int ioapic_service(struct kvm_ioapic *ioapic, int irq, bool line_status)
 	irqe.shorthand = 0;
 
 	if (irqe.trig_mode == IOAPIC_EDGE_TRIG)
-		ioapic->irr &= ~(1 << irq);
+		ioapic->irr_delivered |= 1 << irq;
 
 	if (irq == RTC_GSI && line_status) {
 		/*
@@ -597,6 +599,7 @@ static void kvm_ioapic_reset(struct kvm_ioapic *ioapic)
 	ioapic->base_address = IOAPIC_DEFAULT_BASE_ADDRESS;
 	ioapic->ioregsel = 0;
 	ioapic->irr = 0;
+	ioapic->irr_delivered = 0;
 	ioapic->id = 0;
 	memset(ioapic->irq_eoi, 0x00, IOAPIC_NUM_PINS);
 	rtc_irq_eoi_tracking_reset(ioapic);
@@ -654,6 +657,7 @@ int kvm_get_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
 
 	spin_lock(&ioapic->lock);
 	memcpy(state, ioapic, sizeof(struct kvm_ioapic_state));
+	state->irr &= ~ioapic->irr_delivered;
 	spin_unlock(&ioapic->lock);
 	return 0;
 }
@@ -667,6 +671,7 @@ int kvm_set_ioapic(struct kvm *kvm, struct kvm_ioapic_state *state)
 	spin_lock(&ioapic->lock);
 	memcpy(ioapic, state, sizeof(struct kvm_ioapic_state));
 	ioapic->irr = 0;
+	ioapic->irr_delivered = 0;
 	update_handled_vectors(ioapic);
 	kvm_vcpu_request_scan_ioapic(kvm);
 	kvm_ioapic_inject_all(ioapic, state->irr);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 3c91955..a5cdfc0 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -77,6 +77,7 @@ struct kvm_ioapic {
 	struct rtc_status rtc_status;
 	struct delayed_work eoi_inject;
 	u32 irq_eoi[IOAPIC_NUM_PINS];
+	u32 irr_delivered;
 };
 
 #ifdef DEBUG
-- 
1.7.1

