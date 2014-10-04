Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaJDVoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 17:44:17 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:40204 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbaJDVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 17:44:16 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, davej@redhat.com,
        hmh@hmh.eng.br
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH v2 1/2] x86: Add cpu_detect_cache_sizes() to init_intel(), add Quark to legacy_cache()
Date: Sat,  4 Oct 2014 22:43:56 +0100
Message-Id: <1412459037-26089-2-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412459037-26089-1-git-send-email-pure.logic@nexus-software.ie>
References: <1412459037-26089-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel processors which don't report cache information via cpuid(2)
or cpuid(4) need quirk code in the legacy_cache_size callback to
report this data. For Intel that callback is is intel_size_cache().

This patch enables calling of cpu_detect_cache_sizes() inside of
init_intel() and hence the calling of the legacy_cache callback in
intel_size_cache(). Adding this call will ensure that PIII Tualatin
currently in intel_size_cache() and Quark SoC X1000 being added to
intel_size_cache() in this patch will report their respective cache
sizes.

This model of calling cpu_detect_cache_sizes() is consistent with
AMD/Via/Cirix/Transmeta and Centaur.

Also added is a string to idenitfy the Quark as Quark SoC X1000
giving better and more descriptive output via /proc/cpuinfo

Adding cpu_detect_cache_sizes to init_intel() will enable calling
of intel_size_cache() on Intel processors which currently no code
can reach. Therefore this patch will also re-enable reporting
of PIII Tualatin cache size information as well as add
Quark SoC X1000 support.

Comment text suggested by Thomas Gleixner

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/cpu/intel.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 74e804d..f4248b7 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -381,7 +381,18 @@ static void init_intel(struct cpuinfo_x86 *c)
 #endif
 	}
 
-	l2 = init_intel_cacheinfo(c);
+	/* Detect legacy cache sizes */
+	cpu_detect_cache_sizes(c);
+
+	/*
+	 * If cache_size has not been initialized via legacy_cache()
+	 * probe it via init_intel_cacheinfo().
+	 */
+	if (c->x86_cache_size == 0)
+		l2 = init_intel_cacheinfo(c);
+	else
+		l2 = c->x86_cache_size;
+
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
@@ -485,6 +496,13 @@ static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	 */
 	if ((c->x86 == 6) && (c->x86_model == 11) && (size == 0))
 		size = 256;
+
+	/*
+	 * Intel Quark SoC X1000 contains a 4-way set associative
+	 * 16K cache with a 16 byte cache line and 256 lines per tag
+	 */
+	if ((c->x86 == 5) && (c->x86_model == 9))
+		size = 16;
 	return size;
 }
 #endif
@@ -686,7 +704,8 @@ static const struct cpu_dev intel_cpu_dev = {
 			  [3] = "OverDrive PODP5V83",
 			  [4] = "Pentium MMX",
 			  [7] = "Mobile Pentium 75 - 200",
-			  [8] = "Mobile Pentium MMX"
+			  [8] = "Mobile Pentium MMX",
+			  [9] = "Quark SoC X1000",
 		  }
 		},
 		{ .family = 6, .model_names =
-- 
1.9.1

