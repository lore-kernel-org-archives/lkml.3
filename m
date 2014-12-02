Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaLBFSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 00:18:12 -0500
Received: from mga14.intel.com ([192.55.52.115]:28453 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925AbaLBFSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 00:18:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="423853962"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/2] kvm: x86: revert mask out xsaves
Date: Tue,  2 Dec 2014 13:17:52 +0800
Message-Id: <1417497473-1159-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xsaves will be exported to guest in the next patch, so revert the
mask out xsaves patch.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/cpuid.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a4f5ac4..7af07571 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -320,10 +320,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		F(ADX) | F(SMAP) | F(AVX512F) | F(AVX512PF) | F(AVX512ER) |
 		F(AVX512CD);
 
-	/* cpuid 0xD.1.eax */
-	const u32 kvm_supported_word10_x86_features =
-		F(XSAVEOPT) | F(XSAVEC) | F(XGETBV1);
-
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();
 
@@ -460,8 +456,6 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->eax &= supported;
 		entry->edx &= supported >> 32;
 		entry->flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-		if (!supported)
-			break;
 
 		for (idx = 1, i = 1; idx < 64; ++idx) {
 			u64 mask = ((u64)1 << idx);
@@ -469,9 +463,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 				goto out;
 
 			do_cpuid_1_ent(&entry[i], function, idx);
-			if (idx == 1)
-				entry[i].eax &= kvm_supported_word10_x86_features;
-			else if (entry[i].eax == 0 || !(supported & mask))
+			if (entry[i].eax == 0 || !(supported & mask))
 				continue;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-- 
1.9.1

