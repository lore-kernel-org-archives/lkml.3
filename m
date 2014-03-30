Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755315AbaCaAKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:10:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754270AbaC3Xmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Len Brown" <len.brown@intel.com>,
        "Josh Triplett" <josh@joshtriplett.org>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.842109211@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 045/200] turbostat: Use GCC's CPUID functions to
 support PIC
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/power/x86/turbostat/turbostat.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -32,6 +32,7 @@
 #include <dirent.h>
 #include <string.h>
 #include <ctype.h>
+#include <cpuid.h>
 
 #define MSR_TSC	0x10
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
@@ -847,7 +848,7 @@ void check_cpuid()
 
 	eax = ebx = ecx = edx = 0;
 
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0));
+	__get_cpuid(0, &max_level, &ebx, &ecx, &edx);
 
 	if (ebx == 0x756e6547 && edx == 0x49656e69 && ecx == 0x6c65746e)
 		genuine_intel = 1;
@@ -856,7 +857,7 @@ void check_cpuid()
 		fprintf(stderr, "%.4s%.4s%.4s ",
 			(char *)&ebx, (char *)&edx, (char *)&ecx);
 
-	asm("cpuid" : "=a" (fms), "=c" (ecx), "=d" (edx) : "a" (1) : "ebx");
+	__get_cpuid(1, &fms, &ebx, &ecx, &edx);
 	family = (fms >> 8) & 0xf;
 	model = (fms >> 4) & 0xf;
 	stepping = fms & 0xf;
@@ -878,7 +879,7 @@ void check_cpuid()
 	 * This check is valid for both Intel and AMD.
 	 */
 	ebx = ecx = edx = 0;
-	asm("cpuid" : "=a" (max_level), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000000));
+	__get_cpuid(0x80000000, &max_level, &ebx, &ecx, &edx);
 
 	if (max_level < 0x80000007) {
 		fprintf(stderr, "CPUID: no invariant TSC (max_level 0x%x)\n", max_level);
@@ -889,7 +890,7 @@ void check_cpuid()
 	 * Non-Stop TSC is advertised by CPUID.EAX=0x80000007: EDX.bit8
 	 * this check is valid for both Intel and AMD
 	 */
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x80000007));
+	__get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
 	has_invariant_tsc = edx & (1 << 8);
 
 	if (!has_invariant_tsc) {
@@ -902,7 +903,7 @@ void check_cpuid()
 	 * this check is valid for both Intel and AMD
 	 */
 
-	asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx) : "a" (0x6));
+	__get_cpuid(0x6, &eax, &ebx, &ecx, &edx);
 	has_aperf = ecx & (1 << 0);
 	if (!has_aperf) {
 		fprintf(stderr, "No APERF MSR\n");

