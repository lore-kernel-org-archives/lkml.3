Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083AbaG3HDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:03:21 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:52402 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556AbaG3HDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:03:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0BABKY2FOERCABjGdsb2JhbABahDe0JJdOh1qBFBYQAQEBJz2EMVKBUYhCugyGMhePTB2ENAWKbqkCaQ
X-IPAS-Result: Ar0BABKY2FOERCABjGdsb2JhbABahDe0JJdOh1qBFBYQAQEBJz2EMVKBUYhCugyGMhePTB2ENAWKbqkCaQ
X-IronPort-AV: E=Sophos;i="5.01,762,1400014800"; 
   d="scan'208";a="117376635"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, nadav.amit@gmail.com,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH] KVM: x86: cluster mode broadcast does not work
Date: Wed, 30 Jul 2014 10:03:05 +0300
Message-Id: <1406703785-10023-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local-apic enables cluster mode broadcast. As Intel SDM 10.6.2.2 says:
"Broadcast to all local APICs is achieved by setting all destination bits to
one." This patch enables cluster mode broadcast.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/lapic.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index efb1939..05c9a46 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -560,8 +560,8 @@ int kvm_apic_match_logical_addr(struct kvm_lapic *apic, u8 mda)
 			result = 1;
 		break;
 	case APIC_DFR_CLUSTER:
-		if (((logical_id >> 4) == (mda >> 0x4))
-		    && (logical_id & mda & 0xf))
+		if ((((logical_id >> 4) == (mda >> 0x4))
+		    && (logical_id & mda & 0xf)) || mda == 0xff)
 			result = 1;
 		break;
 	default:
@@ -644,6 +644,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	} else {
 		u32 mda = irq->dest_id << (32 - map->ldr_bits);
 
+		if (irq->dest_id == 0xff &&
+		    kvm_apic_get_reg(src, APIC_DFR) == APIC_DFR_CLUSTER)
+			goto out; /* cluster mode broadcast */
+
 		dst = map->logical_map[apic_cluster_id(map, mda)];
 
 		bitmap = apic_logical_id(map, mda);
-- 
1.9.1

