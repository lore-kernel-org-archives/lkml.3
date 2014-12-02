Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaLBNJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:09:40 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63421 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbaLBNJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:09:38 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: rkrcmar@redhat.com, Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: [PATCH] KVM: cpuid: mask more bits in leaf 0xd and subleaves
Date: Tue,  2 Dec 2014 14:09:30 +0100
Message-Id: <1417525770-16485-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- EAX=0Dh, ECX=1: output registers EBX/ECX/EDX are reserved.

- EAX=0Dh, ECX>1: output register ECX is zero for all the CPUID leaves
we support, because variable "supported" comes from XCR0 and not XSS.
However, only bits above 0 are reserved.  Output register EDX is reserved.

Source: Intel Architecture Instruction Set Extensions Programming
Reference, ref. number 319433-022

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0d919bc33b02..b1366743a728 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -470,10 +470,17 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 				goto out;
 
 			do_cpuid_1_ent(&entry[i], function, idx);
-			if (idx == 1)
+			if (idx == 1) {
 				entry[i].eax &= kvm_supported_word10_x86_features;
-			else if (entry[i].eax == 0 || !(supported & mask))
-				continue;
+				entry[i].ebx = 0;
+				entry[i].ecx = 0;
+			} else {
+				if (entry[i].eax == 0 || !(supported & mask))
+					continue;
+				WARN_ON_ONCE(entry[i].ecx & 1);
+				entry[i].ecx &= 1;
+			}
+			entry[i].edx = 0;
 			entry[i].flags |=
 			       KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
 			++*nent;
-- 
1.8.3.1

