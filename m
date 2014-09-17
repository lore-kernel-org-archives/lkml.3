Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbaIQMyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 08:54:47 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:59483 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754510AbaIQMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 08:54:28 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FAPqDGVSERCAB/2dsb2JhbABggw2BKtByAYEVFgEBeIQEAQUnUhBRVxmIPrd6hkWPSwcWhDUFhh+FGp1+iRmDYWmCSgEBAQ
X-IPAS-Result: Ah0FAPqDGVSERCAB/2dsb2JhbABggw2BKtByAYEVFgEBeIQEAQUnUhBRVxmIPrd6hkWPSwcWhDUFhh+FGp1+iRmDYWmCSgEBAQ
X-IronPort-AV: E=Sophos;i="5.04,540,1406581200"; 
   d="scan'208";a="122640362"
From: Nadav Amit <namit@cs.technion.ac.il>
To: bp@alien8.de
Cc: mingo@kernel.org, nadav.amit@gmail.com, pbonzini@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, Nadav Amit <namit@cs.technion.ac.il>
Subject: [RESEND PATCH 3/3] KVM: x86: Using cpuid structs in KVM
Date: Wed, 17 Sep 2014 15:54:14 +0300
Message-Id: <1410958454-7501-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
References: <20140917124501.GC5358@nazgul.tnic>
 <1410958454-7501-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using cpuid structs in KVM to eliminate cryptic code with many bit operations.
The code does not introduce functional changes.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 arch/x86/kvm/cpuid.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 38a0afe..a7479ab 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -18,6 +18,7 @@
 #include <linux/uaccess.h>
 #include <asm/user.h>
 #include <asm/xsave.h>
+#include <asm/cpuid_def.h>
 #include "cpuid.h"
 #include "lapic.h"
 #include "mmu.h"
@@ -357,16 +358,18 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	/* function 4 has additional index. */
 	case 4: {
-		int i, cache_type;
+		int i;
 
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until cache_type is zero */
 		for (i = 1; ; ++i) {
+			union cpuid4_eax eax;
+
 			if (*nent >= maxnent)
 				goto out;
 
-			cache_type = entry[i - 1].eax & 0x1f;
-			if (!cache_type)
+			eax.full = entry[i - 1].eax;
+			if (!eax.split.cache_type)
 				break;
 			do_cpuid_1_ent(&entry[i], function, i);
 			entry[i].flags |=
@@ -423,16 +426,18 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 	}
 	/* function 0xb has additional index. */
 	case 0xb: {
-		int i, level_type;
+		int i;
 
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 		/* read more entries until level_type is zero */
 		for (i = 1; ; ++i) {
+			union cpuid11_ecx ecx;
+
 			if (*nent >= maxnent)
 				goto out;
 
-			level_type = entry[i - 1].ecx & 0xff00;
-			if (!level_type)
+			ecx.full = entry[i - 1].ecx;
+			if (!ecx.split.level_type)
 				break;
 			do_cpuid_1_ent(&entry[i], function, i);
 			entry[i].flags |=
@@ -505,13 +510,13 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->eax = entry->ebx = entry->ecx = 0;
 		break;
 	case 0x80000008: {
-		unsigned g_phys_as = (entry->eax >> 16) & 0xff;
-		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
-		unsigned phys_as = entry->eax & 0xff;
+		union cpuid_8_8_eax eax;
 
-		if (!g_phys_as)
-			g_phys_as = phys_as;
-		entry->eax = g_phys_as | (virt_as << 8);
+		eax.full = entry->eax;
+		eax.split.virt_as = max_t(int, eax.split.virt_as, 48);
+		if (!eax.split.guest_phys_as)
+			eax.split.guest_phys_as = eax.split.phys_as;
+		entry->eax = eax.full;
 		entry->ebx = entry->edx = 0;
 		break;
 	}
@@ -724,13 +729,16 @@ EXPORT_SYMBOL_GPL(kvm_find_cpuid_entry);
 int cpuid_maxphyaddr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
+	union cpuid_8_8_eax eax;
 
 	best = kvm_find_cpuid_entry(vcpu, 0x80000000, 0);
 	if (!best || best->eax < 0x80000008)
 		goto not_found;
 	best = kvm_find_cpuid_entry(vcpu, 0x80000008, 0);
-	if (best)
-		return best->eax & 0xff;
+	if (best) {
+		eax.full = best->eax;
+		return eax.split.phys_as;
+	}
 not_found:
 	return 36;
 }
-- 
1.9.1

