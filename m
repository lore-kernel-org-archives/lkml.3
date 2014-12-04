Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669AbaLDP7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 10:59:51 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46388 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbaLDP5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 10:57:33 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 5/9] KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
Date: Thu,  4 Dec 2014 16:57:10 +0100
Message-Id: <1417708634-24333-6-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
References: <1417708634-24333-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the size of the XSAVES area.  This starts providing guest support
for XSAVES (with no support yet for supervisor states, i.e. XSS == 0
always in guests for now).

Wanpeng Li suggested testing XSAVEC as well as XSAVES, since in practice
no real processor exists that only has one of them, and there is no
other way for userspace programs to compute the area of the XSAVEC
save area.  CPUID(EAX=0xd,ECX=1).EBX provides an upper bound.

Suggested-by: Radim Krčmář <rkrcmar@redhat.com>
Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e24df01ab118..2f7bc2de9915 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -23,7 +23,7 @@
 #include "mmu.h"
 #include "trace.h"
 
-static u32 xstate_required_size(u64 xstate_bv)
+static u32 xstate_required_size(u64 xstate_bv, bool compacted)
 {
 	int feature_bit = 0;
 	u32 ret = XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET;
@@ -31,9 +31,10 @@ static u32 xstate_required_size(u64 xstate_bv)
 	xstate_bv &= XSTATE_EXTEND_MASK;
 	while (xstate_bv) {
 		if (xstate_bv & 0x1) {
-		        u32 eax, ebx, ecx, edx;
+		        u32 eax, ebx, ecx, edx, offset;
 		        cpuid_count(0xD, feature_bit, &eax, &ebx, &ecx, &edx);
-			ret = max(ret, eax + ebx);
+			offset = compacted ? ret : ebx;
+			ret = max(ret, offset + eax);
 		}
 
 		xstate_bv >>= 1;
@@ -87,9 +88,13 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 			(best->eax | ((u64)best->edx << 32)) &
 			kvm_supported_xcr0();
 		vcpu->arch.guest_xstate_size = best->ebx =
-			xstate_required_size(vcpu->arch.xcr0);
+			xstate_required_size(vcpu->arch.xcr0, false);
 	}
 
+	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
+	if (best && (best->eax & (F(XSAVES)|F(XSAVEC))))
+		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+
 	/*
 	 * The existing code assumes virtual address is 48-bit in the canonical
 	 * address checks; exit if it is ever changed.
@@ -470,9 +475,14 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 				goto out;
 
 			do_cpuid_1_ent(&entry[i], function, idx);
-			if (idx == 1)
+			if (idx == 1) {
 				entry[i].eax &= kvm_supported_word10_x86_features;
-			else if (entry[i].eax == 0 || !(supported & mask))
+				entry[i].ebx = 0;
+				if (entry[i].eax & (F(XSAVES)|F(XSAVEC)))
+					entry[i].ebx =
+						xstate_required_size(supported,
+								     true);
+			} else if (entry[i].eax == 0 || !(supported & mask))
 				continue;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
-- 
1.8.3.1


