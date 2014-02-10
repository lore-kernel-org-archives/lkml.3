Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaBJT4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:56:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35053 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbaBJTqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:46:55 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Triplett <josh@joshtriplett.org>, Len Brown <len.brown@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 074/124] turbostat: Use GCC's CPUID functions to support PIC
Date: Mon, 10 Feb 2014 11:40:14 -0800
Message-Id: <1392061264-28124-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 10f4d14..1f4d8df 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -35,6 +35,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <sched.h>
+#include <cpuid.h>
 
 char *proc_stat = "/proc/stat";
 unsigned int interval_sec = 5;	/* set with -i interval_sec */
@@ -1810,7 +1811,7 @@ void check_cpuid()
 
 	eax = ebx = ecx = edx = 0;
 
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));
+	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -1819,7 +1820,7 @@ void check_cpuid()
 		fprintf(stderr, "CPUID(0): %.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -1841,7 +1842,7 @@ void check_cpuid()
 	 * This check is valid for both Intel and AMD.
 	 */
 	ebx = ecx = edx = 0;
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000));
+	__get_cpuid(0x80000000, &max_level, &ebx, &ecx, &edx);
 
 	if (max_level < 0x80000007) {
 		fprintf(stderr, "CPUID: no invariant TSC (max_level 0x%x)\n", max_level);
@@ -1852,7 +1853,7 @@ void check_cpuid()
 	 * Non-Stop TSC is advertised by CPUID.EAX=0x80000007: EDX.bit8
 	 * this check is valid for both Intel and AMD
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000007));
+	__get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
 	has_invariant_tsc = edx & (1 << 8);
 
 	if (!has_invariant_tsc) {
@@ -1865,7 +1866,7 @@ void check_cpuid()
 	 * this check is valid for both Intel and AMD
 	 */
 
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x6));
+	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
 	has_aperf = ecx & (1 << 0);
 	do_dts = eax & (1 << 0);
 	do_ptm = eax & (1 << 6);
-- 
1.8.3.2

