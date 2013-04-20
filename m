Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3DTMAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 08:00:22 -0400
Received: from relay2.blacknight.com ([78.153.203.205]:42382 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab3DTMAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 08:00:21 -0400
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        fenghua.yu@intel.com, bp@alien8.de
Cc: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Subject: [PATCH] x86: Add check for P5 to microcode_intel_early v2
Date: Sat, 20 Apr 2013 13:02:24 +0100
Message-Id: <1366459344-10190-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architectural MSRs associated with microcode are for P6 or higher.
Add a check to early microcode to detect < P6.

Without a check for < P6 - we end up reading from unimplemented MSRs
on Pentium.

Thanks to Borislav Petkov for suggestion on where to intercept the P5
resulting in fewer cycles and less code to accomplish the fix.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>
---
 arch/x86/kernel/microcode_core_early.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 577db84..bd251b3 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -50,8 +50,17 @@ static int __cpuinit x86_vendor(void)
 
 	native_cpuid(&eax, &ebx, &ecx, &edx);
 
-	if (CPUID_IS(CPUID_INTEL1, CPUID_INTEL2, CPUID_INTEL3, ebx, ecx, edx))
+	if (CPUID_IS(CPUID_INTEL1, CPUID_INTEL2, CPUID_INTEL3, ebx, ecx, edx)) {
+
+		eax = 0x00000001;
+		ecx = 0;
+		native_cpuid(&eax, &ebx, &ecx, &edx);
+
+		if (((edx >> 8) & 0xf) < 0x6)
+			return X86_VENDOR_UNKNOWN;
+
 		return X86_VENDOR_INTEL;
+	}
 
 	if (CPUID_IS(CPUID_AMD1, CPUID_AMD2, CPUID_AMD3, ebx, ecx, edx))
 		return X86_VENDOR_AMD;
-- 
1.7.10.4

