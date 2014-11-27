Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaK0TES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 14:04:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbaK0TEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 14:04:09 -0500
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 3/4] KVM: x86: allow 256 logical x2APICs again
Date: Thu, 27 Nov 2014 20:03:13 +0100
Message-Id: <1417114994-25235-4-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While fixing an x2apic bug,
 17d68b7 KVM: x86: fix guest-initiated crash with x2apic (CVE-2013-6376)
we've made only one cluster available.  This means that the amount of
logically addressible x2APICs was reduced to 16 and VCPUs kept
overwriting themselves in that region, so even the first cluster wasn't
set up correctly.

This patch extends x2APIC support back to the logical_map's limit, and
keeps the CVE fixed as messages for non-present APICs are dropped.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 11 ++++++-----
 arch/x86/kvm/lapic.h |  2 --
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 049d30f..f6e3369 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -132,8 +132,6 @@ static inline int kvm_apic_id(struct kvm_lapic *apic)
 	return (kvm_apic_get_reg(apic, APIC_ID) >> 24) & 0xff;
 }
 
-#define KVM_X2APIC_CID_BITS 0
-
 static void recalculate_apic_map(struct kvm *kvm)
 {
 	struct kvm_apic_map *new, *old = NULL;
@@ -163,8 +161,7 @@ static void recalculate_apic_map(struct kvm *kvm)
 		if (apic_x2apic_mode(apic)) {
 			new->ldr_bits = 32;
 			new->cid_shift = 16;
-			new->cid_mask = (1 << KVM_X2APIC_CID_BITS) - 1;
-			new->lid_mask = 0xffff;
+			new->cid_mask = new->lid_mask = 0xffff;
 			new->broadcast = X2APIC_BROADCAST;
 		} else if (kvm_apic_get_reg(apic, APIC_LDR)) {
 			if (kvm_apic_get_reg(apic, APIC_DFR) ==
@@ -697,8 +694,12 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 		dst = &map->phys_map[irq->dest_id];
 	} else {
 		u32 mda = irq->dest_id << (32 - map->ldr_bits);
+		u16 cid = apic_cluster_id(map, mda);
 
-		dst = map->logical_map[apic_cluster_id(map, mda)];
+		if (cid >= ARRAY_SIZE(map->logical_map))
+			goto out;
+
+		dst = map->logical_map[cid];
 
 		bitmap = apic_logical_id(map, mda);
 
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d4365f2..c674fce 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -154,8 +154,6 @@ static inline u16 apic_cluster_id(struct kvm_apic_map *map, u32 ldr)
 	ldr >>= 32 - map->ldr_bits;
 	cid = (ldr >> map->cid_shift) & map->cid_mask;
 
-	BUG_ON(cid >= ARRAY_SIZE(map->logical_map));
-
 	return cid;
 }
 
-- 
2.1.0

