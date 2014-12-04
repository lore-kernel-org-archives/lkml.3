Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaLDLbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:31:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:40557 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754010AbaLDLbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:31:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424996383"
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>, <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH v2 2/4] kvm: cpuid: fix the size of xsaves area
Date: Thu,  4 Dec 2014 19:11:08 +0800
Message-Id: <1417691470-5221-2-git-send-email-wanpeng.li@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1417691470-5221-1-git-send-email-wanpeng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The section of CPUID(EAX=0xd, ECX=1) in the spec which commit
f5c2290cd01e (KVM: cpuid: mask more bits in leaf 0xd and subleaves)
mentioned is older than SDM.

EBX: Bits 31-00: The size in bytes of the XSAVE area containing all
states enabled by XCR0|IA32_XSS.

The the value of EBX should represent the size of XCR0 related XSAVE
area since IA32_XSS is not used currently.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * add F(XSAVEC) check

 arch/x86/kvm/cpuid.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 646e6e8..5b78e9b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -477,7 +477,10 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 			do_cpuid_1_ent(&entry[i], function, idx);
 			if (idx == 1) {
 				entry[i].eax &= kvm_supported_word10_x86_features;
-				entry[i].ebx = 0;
+				if (entry[i].eax & (F(XSAVES) | F(XSAVEC)))
+					entry[i].ebx = xstate_required_size(supported, true);
+				else
+					entry[i].ebx = xstate_required_size(supported, false);
 			} else {
 				if (entry[i].eax == 0 || !(supported & mask))
 					continue;
-- 
1.9.1

