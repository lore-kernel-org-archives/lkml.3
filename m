Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615Ab3BNTgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:36:23 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:58367 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761602Ab3BNTgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:36:19 -0500
From: Benson Leung <bleung@chromium.org>
To: len.brown@intel.com, colin.king@canonical.com,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, vapier@gentoo.org
Subject: [PATCH v3 1/1] tools/power x86_energy_perf_policy: fix cpuid for i686
Date: Thu, 14 Feb 2013 11:35:58 -0800
Message-Id: <1360870558-11711-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360870558-11711-1-git-send-email-bleung@chromium.org>
References: <1360870558-11711-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_energy_perf_policy reads cpuid using the cpuid instruction.
On i686, when building with PIC, this clobbers ebx, the PIC register.

Fixed using the same cpuid accessor function that vapier@gentoo.org
created for i7z:
http://code.google.com/p/i7z/issues/detail?id=31

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v3 : No changes.
v2 : make cpuid static inline. Remove unused eax from validate_cpuid and
clean up return variables from cpuid().
---
 .../x86_energy_perf_policy.c                       | 30 +++++++++++++++++-----
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 40b3e54..f8f4e63 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -130,20 +130,36 @@ void cmdline(int argc, char **argv)
 	}
 }
 
+static inline void cpuid(unsigned int info, unsigned int *eax,
+			 unsigned int *ebx, unsigned int *ecx,
+			 unsigned int *edx)
+{
+	unsigned int _eax = info, _ebx, _ecx, _edx;
+	asm volatile ("mov %%ebx, %%edi;" /* save ebx (for PIC) */
+		      "cpuid;"
+		      "mov %%ebx, %%esi;" /* pass to caller */
+		      "mov %%edi, %%ebx;" /* restore ebx */
+		      :"+a" (_eax), "=S" (_ebx), "=c" (_ecx), "=d" (_edx)
+		      :      /* inputs: eax is handled above */
+		      :"edi" /* clobbers: we hit edi directly */);
+	if (eax) *eax = _eax;
+	if (ebx) *ebx = _ebx;
+	if (ecx) *ecx = _ecx;
+	if (edx) *edx = _edx;
+}
+
 /*
  * validate_cpuid()
  * returns on success, quietly exits on failure (make verbose with -v)
  */
 void validate_cpuid(void)
 {
-	unsigned int eax, ebx, ecx, edx, max_level;
+	unsigned int ebx, ecx, edx, max_level;
 	unsigned int fms, family, model, stepping;
 
-	eax = ebx = ecx = edx = 0;
-
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx),
-		"=d" (edx) : "a" (0));
+	ebx = ecx = edx = 0;
 
+	cpuid(0, &max_level, &ebx, &ecx, &edx);
 	if (ebx != 0x756e6547 || edx != 0x49656e69 || ecx != 0x6c65746e) {
 		if (verbose)
 			fprintf(stderr, "%.4s%.4s%.4s != GenuineIntel",
@@ -151,7 +167,7 @@ void validate_cpuid(void)
 		exit(1);
 	}
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	cpuid(1, &fms, NULL, NULL, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -173,7 +189,7 @@ void validate_cpuid(void)
 	 * Support for MSR_IA32_ENERGY_PERF_BIAS
 	 * is indicated by CPUID.06H.ECX.bit3
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (6));
+	cpuid(6, NULL, NULL, &ecx, NULL);
 	if (verbose)
 		printf("CPUID.06H.ECX: 0x%x\n", ecx);
 	if (!(ecx & (1 << 3))) {
-- 
1.8.1

