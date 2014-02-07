Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaBGLZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:25:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41254 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaBGLZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:25:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>, Len Brown <len.brown@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 88/88] turbostat: Use GCC's CPUID functions to support PIC
Date: Fri,  7 Feb 2014 11:23:25 +0000
Message-Id: <1391772205-22239-89-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
References: <1391772205-22239-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.30 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Triplett <josh@joshtriplett.org>

commit 2b92865e648ce04a39fda4f903784a5d01ecb0dc upstream.

turbostat uses inline assembly to call cpuid.  On 32-bit x86, on systems
that have certain security features enabled by default that make -fPIC
the default, this causes a build error:

turbostat.c: In function ‘check_cpuid’:
turbostat.c:1906:2: error: PIC register clobbered by ‘ebx’ in ‘asm’
  asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
  ^

GCC provides a header cpuid.h, containing a __get_cpuid function that
works with both PIC and non-PIC.  (On PIC, it saves and restores ebx
around the cpuid instruction.)  Use that instead.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 16de7ad..43a7bda 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -34,6 +34,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <sched.h>
+#include <cpuid.h>
 
 #define MSR_TSC	0x10
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
@@ -955,7 +956,7 @@ void check_cpuid()
 
 	eax = ebx = ecx = edx = 0;
 
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));
+	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -964,7 +965,7 @@ void check_cpuid()
 		fprintf(stderr, "%.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -986,7 +987,7 @@ void check_cpuid()
 	 * This check is valid for both Intel and AMD.
 	 */
 	ebx = ecx = edx = 0;
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000));
+	__get_cpuid(0x80000000, &max_level, &ebx, &ecx, &edx);
 
 	if (max_level < 0x80000007) {
 		fprintf(stderr, "CPUID: no invariant TSC (max_level 0x%x)\n", max_level);
@@ -997,7 +998,7 @@ void check_cpuid()
 	 * Non-Stop TSC is advertised by CPUID.EAX=0x80000007: EDX.bit8
 	 * this check is valid for both Intel and AMD
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000007));
+	__get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
 	has_invariant_tsc = edx & (1 << 8);
 
 	if (!has_invariant_tsc) {
@@ -1010,7 +1011,7 @@ void check_cpuid()
 	 * this check is valid for both Intel and AMD
 	 */
 
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x6));
+	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
 	has_aperf = ecx & (1 << 0);
 	if (!has_aperf) {
 		fprintf(stderr, "No APERF MSR\n");
-- 
1.8.3.2

