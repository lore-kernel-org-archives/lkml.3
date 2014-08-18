Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaHRJtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:49:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:35940 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbaHRJtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="559946339"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 4/5] KVM: x86: fix check legal type of Variable Range MTRRs  
Date: Mon, 18 Aug 2014 17:50:30 +0800
Message-Id: <1408355431-115633-4-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first entry in each pair(IA32_MTRR_PHYSBASEn) defines the base 
address and memory type for the range; the second entry(IA32_MTRR_PHYSMASKn)
contains a mask used to determine the address range. The legal values 
for the type field of IA32_MTRR_PHYSBASEn are 0,1,4,5, and 6. However,
IA32_MTRR_PHYSMASKn don't have type field. This patch avoid check if 
the type field is legal for IA32_MTRR_PHYSMASKn.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/x86.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 204422d..30f55cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1767,7 +1767,15 @@ static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	}
 
 	/* variable MTRRs */
-	return valid_mtrr_type(data & 0xff);
+	if (msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR) {
+		int idx, is_mtrr_mask;
+
+		idx = (msr - 0x200) / 2;
+		is_mtrr_mask = msr - 0x200 - 2 * idx;
+		if (!is_mtrr_mask)
+			return valid_mtrr_type(data & 0xff);
+	}
+	return true;
 }
 
 static int set_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
-- 
1.9.1

