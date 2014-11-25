Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbaKYLYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:24:44 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbaKYKmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>, davej@redhat.com,
        hmh@hmh.eng.br, Thomas Gleixner <tglx@linutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 128/254] x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cache()
Date: Tue, 25 Nov 2014 10:37:58 +0000
Message-Id: <1416912004-5928-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <pure.logic@nexus-software.ie>

commit aece118e487a744eafcdd0c77fe32b55ee2092a1 upstream.

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

Comment text and cache flow logic suggested by Thomas Gleixner

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: davej@redhat.com
Cc: hmh@hmh.eng.br
Link: http://lkml.kernel.org/r/1412641189-12415-3-git-send-email-pure.logic@nexus-software.ie
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/intel.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 21337cd58b6b..df64630d8053 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -397,6 +397,13 @@ static void init_intel(struct cpuinfo_x86 *c)
 	}
 
 	l2 = init_intel_cacheinfo(c);
+
+	/* Detect legacy cache sizes if init_intel_cacheinfo did not */
+	if (l2 == 0) {
+		cpu_detect_cache_sizes(c);
+		l2 = c->x86_cache_size;
+	}
+
 	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
@@ -500,6 +507,13 @@ static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
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
@@ -727,7 +741,8 @@ static const struct cpu_dev intel_cpu_dev = {
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
2.1.0

