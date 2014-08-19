Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaHSJCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:02:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:41343 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbaHSJCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:02:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="586802748"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 1/3] KVM: vmx: fix ept reserved bits for 1-GByte page 
Date: Tue, 19 Aug 2014 17:04:38 +0800
Message-Id: <1408439080-57721-1-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EPT misconfig handler in kvm will check which reason lead to EPT 
misconfiguration after vmexit. One of the reasons is that an EPT 
paging-structure entry is configured with settings reserved for 
future functionality. However, the handler can't identify if 
paging-structure entry of reserved bits for 1-GByte page are 
configured, since PDPTE which point to 1-GByte page will reserve 
bits 29:12 instead of bits 7:3 which are reserved for PDPTE that 
references an EPT Page Directory. This patch fix it by reserve 
bits 29:12 for 1-GByte page. 

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * same "if" statement cover both 2MB and 1GB pages
 * return 0xf8 for level == 4
 * get the level by checking the return value of ept_rsvd_mask 

 arch/x86/kvm/vmx.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index cad37d5..2763f37 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5521,17 +5521,12 @@ static u64 ept_rsvd_mask(u64 spte, int level)
 	for (i = 51; i > boot_cpu_data.x86_phys_bits; i--)
 		mask |= (1ULL << i);
 
-	if (level > 2)
-		/* bits 7:3 reserved */
-		mask |= 0xf8;
-	else if (level == 2) {
-		if (spte & (1ULL << 7))
-			/* 2MB ref, bits 20:12 reserved */
-			mask |= 0x1ff000;
-		else
-			/* bits 6:3 reserved */
-			mask |= 0x78;
-	}
+	if (spte & (1ULL << 7))
+		/* 1GB/2MB page, bits 29:12 or 20:12 reserved respectively */
+		mask |= (PAGE_SIZE << ((level - 1) * 9)) - PAGE_SIZE;
+	else
+		/* bits 6:3 reserved */
+		mask |= 0x78;
 
 	return mask;
 }
@@ -5561,7 +5556,7 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
 			WARN_ON(1);
 		}
 
-		if (level == 1 || (level == 2 && (spte & (1ULL << 7)))) {
+		if (level == 1 || (rsvd_bits & 0x38)) {
 			u64 ept_mem_type = (spte & 0x38) >> 3;
 
 			if (ept_mem_type == 2 || ept_mem_type == 3 ||
-- 
1.9.1

