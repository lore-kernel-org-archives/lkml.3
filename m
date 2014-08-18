Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaHRJtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:49:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:36086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaHRJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,885,1400050800"; 
   d="scan'208";a="559946347"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 5/5] KVM: x86: #GP when attempts to write reserved bits of Variable Range MTRRs 
Date: Mon, 18 Aug 2014 17:50:31 +0800
Message-Id: <1408355431-115633-5-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Section 11.11.2.3 of the SDM mentions "All other bits in the IA32_MTRR_PHYSBASEn 
and IA32_MTRR_PHYSMASKn registers are reserved; the processor generates a 
general-protection exception(#GP) if software attempts to write to them". This 
patch do it in kvm.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index caaffeb..aa64c70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1769,11 +1769,22 @@ static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	/* variable MTRRs */
 	if (msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR) {
 		int idx, is_mtrr_mask;
+		u64 mask = 0;
 
 		idx = (msr - 0x200) / 2;
 		is_mtrr_mask = msr - 0x200 - 2 * idx;
-		if (!is_mtrr_mask)
-			return valid_mtrr_type(data & 0xff);
+		for (i = 63; i > boot_cpu_data.x86_phys_bits; i--)
+			mask |= (1ULL << i);
+		if (!is_mtrr_mask) {
+			if (!valid_mtrr_type(data & 0xff))
+				return false;
+			mask |= 0xf00;
+		} else
+			mask |= 0x7ff;
+		if (data & mask) {
+			kvm_inject_gp(vcpu, 0);
+			return false;
+		}
 	}
 	return true;
 }
-- 
1.9.1

