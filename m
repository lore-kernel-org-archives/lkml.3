Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3HUAWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:22:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:56826 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab3HUAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573808"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>, stable@vger.kernel.org
Subject: [PATCH v2 3/8] turbostat: Use GCC's CPUID functions to support PIC
Date: Tue, 20 Aug 2013 17:20:14 -0700
Message-Id: <1377044419-15045-4-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index b10b8d2..dc30f1b 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -35,6 +35,7 @@
 #include <string.h>
 #include <ctype.h>
 #include <sched.h>
+#include <cpuid.h>
 
 char *proc_stat = "/proc/stat";
 unsigned int interval_sec = 5;	/* set with -i interval_sec */
@@ -1894,7 +1895,7 @@ void check_cpuid()
 
 	eax = ebx = ecx = edx = 0;
 
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));
+	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -1903,7 +1904,7 @@ void check_cpuid()
 		fprintf(stderr, "CPUID(0): %.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -1925,7 +1926,7 @@ void check_cpuid()
 	 * This check is valid for both Intel and AMD.
 	 */
 	ebx = ecx = edx = 0;
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000));
+	__get_cpuid(0x80000000, &max_level, &ebx, &ecx, &edx);
 
 	if (max_level < 0x80000007) {
 		fprintf(stderr, "CPUID: no invariant TSC (max_level 0x%x)\n", max_level);
@@ -1936,7 +1937,7 @@ void check_cpuid()
 	 * Non-Stop TSC is advertised by CPUID.EAX=0x80000007: EDX.bit8
 	 * this check is valid for both Intel and AMD
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000007));
+	__get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
 	has_invariant_tsc = edx & (1 << 8);
 
 	if (!has_invariant_tsc) {
@@ -1949,7 +1950,7 @@ void check_cpuid()
 	 * this check is valid for both Intel and AMD
 	 */
 
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x6));
+	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
 	has_aperf = ecx & (1 << 0);
 	do_dts = eax & (1 << 0);
 	do_ptm = eax & (1 << 6);
-- 
1.8.4.rc3

