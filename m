Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaIXIan (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:30:43 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19157 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaIXI1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:20 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-02-542280640cbe
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
Subject: [PATCH v2] ARM: cacheflush: Fix v7_exit_coherency_flush exynos build
 breakage on ARMv6
Date: Wed, 24 Sep 2014 10:27:02 +0200
Message-id: <1411547222-677-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPLMWRmVeSWpSXmKPExsVy+t/xq7opDUohBu1v1S02zljPajH14RM2
	i497FrBZvH5haNG74CqbxdmmN+wW2ztnsFtsenyN1eLyrjlsFrcv81qsPXKX3WLp9YtMFp+e
	/WO3WLXrD6PFvGen2SxefjzB4iDg8XH9J0aPNfPWMHq0NPeweVzu62Xy2DnrLrvHplWdbB53
	ru1h89i8pN6jb8sqRo/Pm+QCuKK4bFJSczLLUov07RK4Mk6+/8tc8Jm34urpmewNjJe5uxg5
	OCQETCTebfHqYuQEMsUkLtxbzwZiCwksZZT4ui28i5ELyO5jkni56CczSIJNwFhi8/IlbCAJ
	EYEWZol758+CdTALNDFJTNnHC2ILCyRKbJyzlwXEZhFQldg2ZQkLyDJeAVeJ3p36EMvkJE4e
	m8w6gZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQQP2yg3HxMatDjAIcjEo8vBPE
	lUKEWBPLiitzDzFKcDArifCeKAUK8aYkVlalFuXHF5XmpBYfYmTi4JRqYKzl37nuAsfDKSln
	zrpvSpbyEYvb5GwTtWPaavEFseoWCQosPlO//fOWq7q/g7lktcdD9QNlcTPb/+dYla8K3BHw
	vvfOWT/vKU+5n83mtU7yYXxeHGP4b/ania+d6zYn1VW/n5DcUfWhc5rPtOu7bVbPudLHsUzh
	qqPEpCjmU4d5Lwhu0RRNaVFiKc5INNRiLipOBACD/6g0MgIAAA==
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

Fix this by annotating the v7_exit_coherency_flush() asm code with
armv7-a architecture.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reported-by: Mark Brown <broonie@kernel.org>
Link: http://www.spinics.net/lists/linux-samsung-soc/msg36790.html

---

Changes since v1:
1. Use armv7-a arch annotation instead replacing isb/dsb with macros.
   Suggsted by Nicolas Pitre.
---
 arch/arm/include/asm/cacheflush.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/include/asm/cacheflush.h b/arch/arm/include/asm/cacheflush.h
index 79ecb4f34ffb..10e78d00a0bb 100644
--- a/arch/arm/include/asm/cacheflush.h
+++ b/arch/arm/include/asm/cacheflush.h
@@ -466,6 +466,7 @@ static inline void __sync_cache_range_r(volatile void *p, size_t size)
  */
 #define v7_exit_coherency_flush(level) \
 	asm volatile( \
+	".arch	armv7-a \n\t" \
 	"stmfd	sp!, {fp, ip} \n\t" \
 	"mrc	p15, 0, r0, c1, c0, 0	@ get SCTLR \n\t" \
 	"bic	r0, r0, #"__stringify(CR_C)" \n\t" \
-- 
1.9.1

