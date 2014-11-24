Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaKXQn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:43:58 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41832 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbaKXQnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:43:55 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: wanpeng.li@linux.intel.com, namit@cs.technion.ac.il, hpa@linux.intel.com
Subject: [CFT PATCH v2 1/2] kvm: x86: mask out XSAVES
Date: Mon, 24 Nov 2014 17:43:33 +0100
Message-Id: <1416847414-22253-2-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
References: <1416847414-22253-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This feature is not supported inside KVM guests yet, because we do not emulate
MSR_IA32_XSS.  Mask it out.

Cc: Nadav Amit <namit@cs.technion.ac.il>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 20d83217fb1d..a4f5ac46226c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -320,6 +320,10 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(ADX) | F(SMAP) | F(AVX512F) | F(AVX512PF) | F(AVX512ER) |
 		F(AVX512CD);
 
+	/* cpuid 0xD.1.eax */
+	const u32 kvm_supported_word10_x86_features =
+		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
+
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -456,13 +460,18 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->eax &= supported;
 		entry->edx &= supported >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
+		if (!supported)
+			break;
+
 		for (idx = 1, i = 1; idx < 64; ++idx) {
 			u64 mask = ((u64)1 << idx);
 			if (*nent >= maxnent)
 				goto out;
 
 			do_cpuid_1_ent(&entry[i], function, idx);
-			if (entry[i].eax == 0 || !(supported & mask))
+			if (idx == 1)
+				entry[i].eax &= kvm_supported_word10_x86_features;
+			else if (entry[i].eax == 0 || !(supported & mask))
 				continue;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-- 
1.8.3.1


