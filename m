Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbaI3DL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:11:59 -0400
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:60555 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755300AbaI3DL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:11:57 -0400
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        hmh@hmh.eng.br, x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH 2/3] x86: Quark: Update cache reporting, add Quark SoC X1000 string
Date: Tue, 30 Sep 2014 04:11:49 +0100
Message-Id: <1412046710-2686-3-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a path for legacy_cache_size to get a Quark SoC X1000 cache size
Update init_intel to take account of PIII Tualatin and Quark X1000
reporting cache size via legacy_cache_size
Add string to family/model structure for completeness and better
output of /proc/cpuinfo

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/kernel/cpu/intel.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 50ce751..686eae7 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -396,7 +396,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 #endif
 	}
 
-	l2 = init_intel_cacheinfo(c);
+
+	/* legacy_cache may have provided and cache_size already if not probe */
+	if (c->x86_cache_size == 0)
+		l2 = init_intel_cacheinfo(c);
+	else
+		l2 = c->x86_cache_size;
+
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
@@ -500,6 +506,15 @@ static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	 */
 	if ((c->x86 == 6) && (c->x86_model == 11) && (size == 0))
 		size = 256;
+
+
+	/*
+	 * Intel Quark SoC X1000 contains a 4-way set associative
+	 * 16K cache with a 16 byte cache line and 256 lines per tag
+	 */
+	if ((c->x86 == 5) && (c->x86_model == 9))
+		size = 16;
+
 	return size;
 }
 #endif
@@ -701,7 +716,8 @@ static const struct cpu_dev intel_cpu_dev = {
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

