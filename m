Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHRJs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:48:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:35654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaHRJsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:48:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="559946249"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 1/5] KVM: vmx: fix ept reserved bits for 1-GByte page 
Date: Mon, 18 Aug 2014 17:50:27 +0800
Message-Id: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
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
 arch/x86/kvm/vmx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bfe11cf..71cbee5 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5521,9 +5521,14 @@ static u64 ept_rsvd_mask(u64 spte, int level)
 	for (i = 51; i > boot_cpu_data.x86_phys_bits; i--)
 		mask |= (1ULL << i);
 
-	if (level > 2)
-		/* bits 7:3 reserved */
-		mask |= 0xf8;
+	if (level > 2) {
+		if (spte & (1 << 7))
+			/* 1GB ref, bits 29:12 */
+			mask |= 0x3ffff000;
+		else
+			/* bits 7:3 reserved */
+			mask |= 0xf8;
+	}
 	else if (level == 2) {
 		if (spte & (1ULL << 7))
 			/* 2MB ref, bits 20:12 reserved */
@@ -5561,7 +5566,8 @@ static void ept_misconfig_inspect_spte(struct kvm_vcpu *vcpu, u64 spte,
 			WARN_ON(1);
 		}
 
-		if (level == 1 || (level == 2 && (spte & (1ULL << 7)))) {
+		if (level == 1 || ((level == 3 || level == 2)
+				&& (spte & (1ULL << 7)))) {
 			u64 ept_mem_type = (spte & 0x38) >> 3;
 
 			if (ept_mem_type == 2 || ept_mem_type == 3 ||
-- 
1.9.1

