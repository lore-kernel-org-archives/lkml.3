Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaLCNlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:41:47 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:50066 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbaLCNlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:41:45 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH 2/2] KVM: cpuid: set CPUID(EAX=0xd,ECX=1).EBX correctly
Date: Wed,  3 Dec 2014 14:40:30 +0100
Message-Id: <1417614030-1692-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1417614030-1692-1-git-send-email-pbonzini@redhat.com>
References: <1417614030-1692-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the size of the XSAVES area.  This completes guest support
for XSAVES (with no support yet for supervisor states, i.e. XSS == 0
always in guests for now).

Suggested-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2c561dba81c0..646e6e830ac3 100644
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
+	if (best && (best->eax & F(XSAVES)))
+		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
+
 	/*
 	 * The existing code assumes virtual address is 48-bit in the canonical
 	 * address checks; exit if it is ever changed.
-- 
1.8.3.1

