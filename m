Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbaJHIKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 04:10:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaJHIKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 04:10:51 -0400
Date: Wed, 8 Oct 2014 01:10:35 -0700
From: "tip-bot for Bryan O'Donoghue" <tipbot@zytor.com>
Message-ID: <tip-aece118e487a744eafcdd0c77fe32b55ee2092a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        pure.logic@nexus-software.ie, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pure.logic@nexus-software.ie, tglx@linutronix.de
In-Reply-To: <1412641189-12415-3-git-send-email-pure.logic@nexus-software.ie>
References: <1412641189-12415-3-git-send-email-pure.logic@nexus-software.ie>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Add cpu_detect_cache_sizes to init_intel(
 ) add Quark legacy_cache()
Git-Commit-ID: aece118e487a744eafcdd0c77fe32b55ee2092a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aece118e487a744eafcdd0c77fe32b55ee2092a1
Gitweb:     http://git.kernel.org/tip/aece118e487a744eafcdd0c77fe32b55ee2092a1
Author:     Bryan O'Donoghue <pure.logic@nexus-software.ie>
AuthorDate: Tue, 7 Oct 2014 01:19:49 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 8 Oct 2014 10:07:46 +0200

x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cache()

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
---
 arch/x86/kernel/cpu/intel.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 50ce751..1ef4562 100644
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
@@ -701,7 +715,8 @@ static const struct cpu_dev intel_cpu_dev = {
 			  [3] = "OverDrive PODP5V83",
 			  [4] = "Pentium MMX",
 			  [7] = "Mobile Pentium 75 - 200",
-			  [8] = "Mobile Pentium MMX"
+			  [8] = "Mobile Pentium MMX",
+			  [9] = "Quark SoC X1000",
 		  }
 		},
 		{ .family = 6, .model_names =
