Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaHSJC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:02:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:41343 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbaHSJCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:02:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="586802759"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 2/3] KVM: x86: fix check legal type of Variable Range MTRRs  
Date: Tue, 19 Aug 2014 17:04:39 +0800
Message-Id: <1408439080-57721-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1408439080-57721-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1408439080-57721-1-git-send-email-wanpeng.li@linux.intel.com>
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
v1 -> v2:
 * WARN_ON if not fall in variable Range MTRRs 
 * the base/mask can be separated just with an "&"

 arch/x86/kvm/x86.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5f5edb6..fb3ea7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1747,7 +1747,13 @@ static bool mtrr_valid(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	}
 
 	/* variable MTRRs */
-	return valid_mtrr_type(data & 0xff);
+	WARN_ON(!(msr >= 0x200 && msr < 0x200 + 2 * KVM_NR_VAR_MTRR));
+
+	if ((msr & 1) == 0)
+		/* MTRR base */
+		return valid_mtrr_type(data & 0xff);
+	/* MTRR mask */
+	return true;
 }
 
 static int set_msr_mtrr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
-- 
1.9.1

