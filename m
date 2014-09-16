Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaIPMxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 08:53:22 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62023 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365AbaIPMxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 08:53:21 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c1-541832be1912
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        "David A. Long" <dave.long@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>, Vinayak Kale <vkale@apm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH] ARM: cacheflush: Fix exynos build breakage on ARMv6 by using
 macros for ISB/DSB
Date: Tue, 16 Sep 2014 14:52:59 +0200
Message-id: <1410871979-12470-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/xK7r7jCRCDL62iFpsnLGe1WLqwyds
	Fh/3LGCzeP3C0KJ3wVU2i7NNb9gttnfOYLfY9Pgaq8XlXXPYLG5f5rVYe+Quu8XS6xeZLD49
	+8dusWrXH0aLec9Os1m8/HiCxUHA4+P6T4wea+atYfRoae5h87jc18vksXPWXXaPTas62Tzu
	XNvD5rF5Sb1H35ZVjB6fN8kFcEVx2aSk5mSWpRbp2yVwZdw6soyl4KlIxa7Lc9kbGP8IdDFy
	ckgImEis6T3KDmGLSVy4t56ti5GLQ0hgKaPEj++XmSGcPiaJ1UvPMoJUsQkYS2xevgSsSkSg
	hVni3vmzbCAJZoEmJokp+3hBbGGBJIlzW++xgNgsAqoSr1ovgDXzCrhLvF20lwlinZzEyWOT
	WScwci9gZFjFKJpamlxQnJSea6hXnJhbXJqXrpecn7uJERKuX3YwLj5mdYhRgINRiYc34594
	iBBrYllxZe4hRgkOZiURXg9NiRAh3pTEyqrUovz4otKc1OJDjEwcnFINjIYzVEyYNqQrN0xv
	St/SVKOrl/T6Ze29uVXr5vZfWPrrk33r53d2ExfHTa8OYE6L/X3u1SrpbqG8e4lTmbsUDu1i
	zfF/Kuo//d1xL3Yn+7ZN56fkCbfvL5GbHP/Qfs+dSV3Hl5XucrTsEl9wq8Tr2bc/rH9rPR9m
	1d2/uyPKee36Pze4OLs2GCqxFGckGmoxFxUnAgA+IuvRNQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes build breakage of platsmp.c if ARMv6 was chosen for compile
time options (e.g. by building allmodconfig):

$ make allmodconfig
$ make
  CC      arch/arm/mach-exynos/platsmp.o
/tmp/ccdQM0Eg.s: Assembler messages:
/tmp/ccdQM0Eg.s:432: Error: selected processor does not support ARM mode `isb '
/tmp/ccdQM0Eg.s:437: Error: selected processor does not support ARM mode `isb '
/tmp/ccdQM0Eg.s:438: Error: selected processor does not support ARM mode `dsb '
make[1]: *** [arch/arm/mach-exynos/platsmp.o] Error 1

The error was introduced in commit "ARM: EXYNOS: Move code from
hotplug.c to platsmp.c".  Previously code using
v7_exit_coherency_flush() macro was built with '-march=armv7-a' flag but
this flag dissapeared during the movement.

Use isb() and dsb() macros in v7_exit_coherency_flush() so the proper
code will be generated for ARMv6.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: Mark Brown <broonie@kernel.org>
Link: http://www.spinics.net/lists/linux-samsung-soc/msg36790.html
---
 arch/arm/include/asm/cacheflush.h | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 79ecb4f34ffb..b74eeec971c0 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -464,22 +464,27 @@ static inline void __sync_cache_range_r(volatile void *p, size_t size)
  *   CONFIG_FRAME_POINTER=y.  ip is saved as well if ever r12-clobbering
  *   trampoline are inserted by the linker and to keep sp 64-bit aligned.
  */
-#define v7_exit_coherency_flush(level) \
+#define v7_exit_coherency_flush(level) do { \
 	asm volatile( \
 	"stmfd	sp!, {fp, ip} \n\t" \
 	"mrc	p15, 0, r0, c1, c0, 0	@ get SCTLR \n\t" \
 	"bic	r0, r0, #"__stringify(CR_C)" \n\t" \
 	"mcr	p15, 0, r0, c1, c0, 0	@ set SCTLR \n\t" \
-	"isb	\n\t" \
+	: : : "r0","r1","r2","r3","r4","r5","r6","r7", \
+	      "r9","r10","lr","memory" ); \
+	isb(); \
+	asm volatile( \
 	"bl	v7_flush_dcache_"__stringify(level)" \n\t" \
 	"mrc	p15, 0, r0, c1, c0, 1	@ get ACTLR \n\t" \
 	"bic	r0, r0, #(1 << 6)	@ disable local coherency \n\t" \
 	"mcr	p15, 0, r0, c1, c0, 1	@ set ACTLR \n\t" \
-	"isb	\n\t" \
-	"dsb	\n\t" \
-	"ldmfd	sp!, {fp, ip}" \
 	: : : "r0","r1","r2","r3","r4","r5","r6","r7", \
-	      "r9","r10","lr","memory" )
+	      "r9","r10","lr","memory" ); \
+	isb(); \
+	dsb(); \
+	asm volatile( \
+	"ldmfd	sp!, {fp, ip}" ); \
+	} while (0)
 
 int set_memory_ro(unsigned long addr, int numpages);
 int set_memory_rw(unsigned long addr, int numpages);
-- 
1.9.1

