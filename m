Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3BAL7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 06:59:06 -0500
Received: from multi.imgtec.com ([194.200.65.239]:31910 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab3BAL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 06:58:20 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 2/6] metag: add boot time LNKGET/LNKSET check
Date: Fri, 1 Feb 2013 11:49:06 +0000
Message-ID: <1359719350-24560-3-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
References: <1359719350-24560-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_01_11_58_17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add boot time check for whether LNKGET/LNKSET go through or around the
cache. Depending on the configuration an info message (no harm), warning
(technically wrong but no harm), or big WARN (expect failure in either
kernel or userland) may be emitted if the behaviour is not as expected:

Configuration                                Hardware   Response
------------------------------------------   --------   --------
AROUND_CACHE                                 through    pr_info
!AROUND_CACHE && ATOMICITY_LNKGET            around     WARN (kernel)
     "        && !ATOMICITY_LNKGET && SMP    around     WARN (user)
     "                   "         && !SMP   around     pr_warn

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/mm/cache.c |   79 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/arch/metag/mm/cache.c b/arch/metag/mm/cache.c
index 89da74a..4dd96e4 100644
--- a/arch/metag/mm/cache.c
+++ b/arch/metag/mm/cache.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 #include <asm/cacheflush.h>
 #include <asm/core_reg.h>
+#include <asm/global_lock.h>
 #include <asm/metag_isa.h>
 #include <asm/metag_mem.h>
 #include <asm/metag_regs.h>
@@ -36,6 +37,82 @@ static int icache_set_shift = METAG_TBI_CACHE_SIZE_BASE_LOG2
 static unsigned char dcache_sets_log2 = DEFAULT_CACHE_WAYS_LOG2;
 static unsigned char icache_sets_log2 = DEFAULT_CACHE_WAYS_LOG2;
 
+#ifndef CONFIG_METAG_META12
+/**
+ * metag_lnkget_probe() - Probe whether lnkget/lnkset go around the cache
+ */
+static volatile u32 lnkget_testdata[16] __initdata __aligned(64);
+
+#define LNKGET_CONSTANT 0xdeadbeef
+
+void __init metag_lnkget_probe(void)
+{
+	int temp;
+	long flags;
+
+	/*
+	 * It's conceivable the user has configured a globally coherent cache
+	 * shared with non-Linux hardware threads, so use LOCK2 to prevent them
+	 * from executing and causing cache eviction during the test.
+	 */
+	__global_lock2(flags);
+
+	/* read a value to bring it into the cache */
+	(void)lnkget_testdata[0];
+	lnkget_testdata[0] = 0;
+
+	/* lnkget/lnkset it to modify it */
+	asm volatile(
+		"1:	LNKGETD %0, [%1]\n"
+		"	LNKSETD [%1], %2\n"
+		"	DEFR	%0, TXSTAT\n"
+		"	ANDT	%0, %0, #HI(0x3f000000)\n"
+		"	CMPT	%0, #HI(0x02000000)\n"
+		"	BNZ	1b\n"
+		: "=&d" (temp)
+		: "da" (&lnkget_testdata[0]), "bd" (LNKGET_CONSTANT)
+		: "cc");
+
+	/* re-read it to see if the cached value changed */
+	temp = lnkget_testdata[0];
+
+	__global_unlock2(flags);
+
+	/* flush the cache line to fix any incoherency */
+	__builtin_dcache_flush((void *)&lnkget_testdata[0]);
+
+#if defined(CONFIG_METAG_LNKGET_AROUND_CACHE)
+	/* if the cache is right, LNKGET_AROUND_CACHE is unnecessary */
+	if (temp == LNKGET_CONSTANT)
+		pr_info("LNKGET/SET go through cache but CONFIG_METAG_LNKGET_AROUND_CACHE=y\n");
+#elif defined(CONFIG_METAG_ATOMICITY_LNKGET)
+	/*
+	 * if the cache is wrong, LNKGET_AROUND_CACHE is really necessary
+	 * because the kernel is configured to use LNKGET/SET for atomicity
+	 */
+	WARN(temp != LNKGET_CONSTANT,
+	     "LNKGET/SET go around cache but CONFIG_METAG_LNKGET_AROUND_CACHE=n\n"
+	     "Expect kernel failure as it's used for atomicity primitives\n");
+#elif defined(CONFIG_SMP)
+	/*
+	 * if the cache is wrong, LNKGET_AROUND_CACHE should be used or the
+	 * gateway page won't flush and userland could break.
+	 */
+	WARN(temp != LNKGET_CONSTANT,
+	     "LNKGET/SET go around cache but CONFIG_METAG_LNKGET_AROUND_CACHE=n\n"
+	     "Expect userland failure as it's used for user gateway page\n");
+#else
+	/*
+	 * if the cache is wrong, LNKGET_AROUND_CACHE is set wrong, but it
+	 * doesn't actually matter as it doesn't have any effect on !SMP &&
+	 * !ATOMICITY_LNKGET.
+	 */
+	if (temp != LNKGET_CONSTANT)
+		pr_warn("LNKGET/SET go around cache but CONFIG_METAG_LNKGET_AROUND_CACHE=n\n");
+#endif
+}
+#endif /* !CONFIG_METAG_META12 */
+
 /**
  * metag_cache_probe() - Probe L1 cache configuration.
  *
@@ -68,6 +145,8 @@ void __init metag_cache_probe(void)
 	dcache_set_shift += (config & METAC_CORECFG2_DCSZ_BITS)
 				>> METAC_CORECFG2_DCSZ_S;
 	dcache_set_shift -= dcache_sets_log2;
+
+	metag_lnkget_probe();
 #else
 	/* Extract cache sizes from global heap segment */
 	unsigned long val, u;
-- 
1.7.7.6


