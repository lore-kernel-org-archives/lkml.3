Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3LSMAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:00:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45386 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab3LSMAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:00:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 197/208] KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)
Date: Thu, 19 Dec 2013 11:54:55 +0000
Message-Id: <1387454106-19326-198-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gleb Natapov <gleb@redhat.com>

commit 17d68b763f09a9ce824ae23eb62c9efc57b69271 upstream.

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
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kvm/lapic.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1dae459..81d7b23 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -153,6 +153,8 @@ static inline int kvm_apic_id(struct kvm_lapic *apic)
 	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
 }
 
+#define KVM_X2APIC_CID_BITS 0
+
 static void recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
@@ -190,7 +192,8 @@ static void recalculate_apic_map(struct kvm *kvm)
 		if (apic_x2apic_mode(apic)) {
 			new->ldr_bits = 32;
 			new->cid_shift = 16;
-			new->cid_mask = new->lid_mask = 0xffff;
+			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
+			new->lid_mask = 0xffff;
 		} else if (kvm_apic_sw_enabled(apic) &&
 				!new->cid_mask /* flat mode */ &&
 				kvm_apic_get_reg(apic, APIC_DFR) == APIC_DFR_CLUSTER) {
-- 
1.8.3.2

