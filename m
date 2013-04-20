Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab3DTAVB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 20:21:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56311 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965091Ab3DTAVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 20:21:00 -0400
Date: Fri, 19 Apr 2013 17:20:35 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-74c3e3fcf350b2e7e3eaf9550528ee3f74e44b37@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bp@alien8.de, bryan.odonoghue.lkml@nexus-software.ie,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bp@alien8.de, bryan.odonoghue.lkml@nexus-software.ie,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, microcode:
  Verify the family before dispatching microcode patching
Git-Commit-ID: 74c3e3fcf350b2e7e3eaf9550528ee3f74e44b37
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 19 Apr 2013 17:20:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  74c3e3fcf350b2e7e3eaf9550528ee3f74e44b37
Gitweb:     http://git.kernel.org/tip/74c3e3fcf350b2e7e3eaf9550528ee3f74e44b37
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Fri, 19 Apr 2013 16:36:03 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 19 Apr 2013 16:36:03 -0700

x86, microcode: Verify the family before dispatching microcode patching

For each CPU vendor that implements CPU microcode patching, there will
be a minimum family for which this is implemented.  Verify this
minimum level of support.

This can be done in the dispatch function or early in the application
functions.  Doing the latter turned out to be somewhat awkward because
of the ineviable split between the BSP and the AP paths, and rather
than pushing deep into the application functions, do this in
the dispatch function.

Reported-by: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Suggested-by: Borislav Petkov <bp@alien8.de>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie
---
 arch/x86/kernel/microcode_core_early.c | 38 +++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 577db84..833d51d 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -45,9 +45,6 @@ static int __cpuinit x86_vendor(void)
 	u32 eax = 0x00000000;
 	u32 ebx, ecx = 0, edx;
 
-	if (!have_cpuid_p())
-		return X86_VENDOR_UNKNOWN;
-
 	native_cpuid(&eax, &ebx, &ecx, &edx);
 
 	if (CPUID_IS(CPUID_INTEL1, CPUID_INTEL2, CPUID_INTEL3, ebx, ecx, edx))
@@ -59,18 +56,45 @@ static int __cpuinit x86_vendor(void)
 	return X86_VENDOR_UNKNOWN;
 }
 
+static int __cpuinit x86_family(void)
+{
+	u32 eax = 0x00000001;
+	u32 ebx, ecx = 0, edx;
+	int x86;
+
+	native_cpuid(&eax, &ebx, &ecx, &edx);
+
+	x86 = (eax >> 8) & 0xf;
+	if (x86 == 15)
+		x86 += (eax >> 20) & 0xff;
+
+	return x86;
+}
+
 void __init load_ucode_bsp(void)
 {
-	int vendor = x86_vendor();
+	int vendor, x86;
+
+	if (!have_cpuid_p())
+		return;
 
-	if (vendor == X86_VENDOR_INTEL)
+	vendor = x86_vendor();
+	x86 = x86_family();
+
+	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_bsp();
 }
 
 void __cpuinit load_ucode_ap(void)
 {
-	int vendor = x86_vendor();
+	int vendor, x86;
+
+	if (!have_cpuid_p())
+		return;
+
+	vendor = x86_vendor();
+	x86 = x86_family();
 
-	if (vendor == X86_VENDOR_INTEL)
+	if (vendor == X86_VENDOR_INTEL && x86 >= 6)
 		load_ucode_intel_ap();
 }
