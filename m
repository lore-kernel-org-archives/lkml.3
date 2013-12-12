Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab3LLUiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:38:11 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:48290 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3LLUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:37:18 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gleb@redhat.com, kvm@vger.kernel.org, pmatouse@redhat.com,
        stable@vger.kernel.org
Subject: [PATCH] KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)
Date: Thu, 12 Dec 2013 21:36:54 +0100
Message-Id: <1386880614-23300-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

A guest can cause a BUG_ON() leading to a host kernel crash.
When the guest writes to the ICR to request an IPI, while in x2apic
mode the following things happen, the destination is read from
ICR2, which is a register that the guest can control.

kvm_irq_delivery_to_apic_fast uses the high 16 bits of ICR2 as the
cluster id.  A BUG_ON is triggered, which is a protection against
accessing map->logical_map with an out-of-bounds access and manages
to avoid that anything really unsafe occurs.

The logic in the code is correct from real HW point of view. The problem
is that KVM supports only one cluster with ID 0 in clustered mode, but
the code that has the bug does not take this into account.

Reported-by: Lars Bull <larsbull@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b8bec45c1610..801dc3fd66e1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -143,6 +143,8 @@ static inline int kvm_apic_id(struct kvm_lapic *apic)
 	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
 }
 
+#define KMV_X2APIC_CID_BITS 0
+
 static void recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
@@ -180,7 +182,8 @@ static void recalculate_apic_map(struct kvm *kvm)
 		if (apic_x2apic_mode(apic)) {
 			new->ldr_bits = 32;
 			new->cid_shift = 16;
-			new->cid_mask = new->lid_mask = 0xffff;
+			new->cid_mask = (1 << KMV_X2APIC_CID_BITS) - 1;
+			new->lid_mask = 0xffff;
 		} else if (kvm_apic_sw_enabled(apic) &&
 				!new->cid_mask /* flat mode */ &&
 				kvm_apic_get_reg(apic, APIC_DFR) == APIC_DFR_CLUSTER) {
-- 
1.8.3.1

