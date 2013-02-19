Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab3BSUSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 15:18:49 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63108 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3BSUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 15:18:45 -0500
From: Benson Leung <bleung@chromium.org>
To: len.brown@intel.com, colin.king@canonical.com,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, vapier@gentoo.org
Subject: [PATCH v4 1/1] tools/power x86_energy_perf_policy: fix cpuid for i686
Date: Tue, 19 Feb 2013 12:18:33 -0800
Message-Id: <1361305113-5627-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361305113-5627-1-git-send-email-bleung@chromium.org>
References: <1360870558-11711-1-git-send-email-bleung@chromium.org>
 <1361305113-5627-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_energy_perf_policy reads cpuid using the cpuid instruction.
On i686, when building with PIC, this clobbers ebx, the PIC register.

Fixed using the cpuid accessor function that vapier@gentoo.org wrote:
https://raw.github.com/linux-test-project/ltp/master/include/ltp_cpuid.h

Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
v4 : Cleaned up checkpatch.pl style errors. Used vapier's newer better cpuid.
v3 : No changes.
v2 : make cpuid static inline. Remove unused eax from validate_cpuid and
clean up return variables from cpuid().
---
 .../x86_energy_perf_policy.c                       | 42 ++++++++++++++++++----
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index 40b3e54..4372bd2 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -130,20 +130,48 @@ void cmdline(int argc, char **argv)
 	}
 }
 
+static inline void cpuid(unsigned int info, unsigned int *eax,
+			 unsigned int *ebx, unsigned int *ecx,
+			 unsigned int *edx)
+{
+#if defined(__i386__) || defined(__x86_64__)
+	unsigned int _eax = info, _ebx, _ecx, _edx;
+	asm volatile (
+# ifdef __i386__
+		      "xchg %%ebx, %%esi;" /* save ebx (for PIC) */
+		      "cpuid;"
+		      "xchg %%esi, %%ebx;" /* restore ebx & pass to caller */
+		      : "=S" (_ebx),
+#else
+		      "cpuid;"
+		      : "=b" (_ebx),
+#endif
+			"+a" (_eax), "=c" (_ecx), "=d" (_edx)
+		      : /* inputs: eax is handled above */
+	);
+	if (eax)
+		*eax = _eax;
+	if (ebx)
+		*ebx = _ebx;
+	if (ecx)
+		*ecx = _ecx;
+	if (edx)
+		*edx = _edx;
+#endif
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
@@ -151,7 +179,7 @@ void validate_cpuid(void)
 		exit(1);
 	}
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	cpuid(1, &fms, NULL, NULL, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -173,7 +201,7 @@ void validate_cpuid(void)
 	 * Support for MSR_IA32_ENERGY_PERF_BIAS
 	 * is indicated by CPUID.06H.ECX.bit3
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (6));
+	cpuid(6, NULL, NULL, &ecx, NULL);
 	if (verbose)
 		printf("CPUID.06H.ECX: 0x%x\n", ecx);
 	if (!(ecx & (1 << 3))) {
-- 
1.8.1.3

