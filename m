Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab3F1S6g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:58:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab3F1S6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:58:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jon Medhurst <tixy@linaro.org>, Russell King <rmk+kernel@arm.linux.org.uk>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 055/105] ARM: 7752/1: errata: LoUIS bit field in CLIDR register is incorrect
Date: Fri, 28 Jun 2013 11:51:17 -0700
Message-Id: <1372445527-24414-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Medhurst <tixy@linaro.org>

commit 691557941af4c12bd307ad81a4d9fa9c7743ac28 upstream.

On Cortex-A9 before version r1p0, the LoUIS bit field of the CLIDR
register returns zero when it should return one. This leads to cache
maintenance operations which rely on this value to not function as
intended, causing data corruption.

The workaround for this errata is to detect affected CPUs and correct
the LoUIS value read.

Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/Kconfig       | 10 ++++++++++
 arch/arm/mm/cache-v7.S |  8 ++++++++
 2 files changed, 18 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 67874b8..613f3a6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1294,6 +1294,16 @@ config PL310_ERRATA_588369
 	   is not correctly implemented in PL310 as clean lines are not
 	   invalidated as a result of these operations.
 
+config ARM_ERRATA_643719
+	bool "ARM errata: LoUIS bit field in CLIDR register is incorrect"
+	depends on CPU_V7 && SMP
+	help
+	  This option enables the workaround for the 643719 Cortex-A9 (prior to
+	  r1p0) erratum. On affected cores the LoUIS bit field of the CLIDR
+	  register returns zero when it should return one. The workaround
+	  corrects this value, ensuring cache maintenance operations which use
+	  it behave as intended and avoiding data corruption.
+
 config ARM_ERRATA_720789
 	bool "ARM errata: TLBIASIDIS and TLBIMVAIS operations can broadcast a faulty ASID"
 	depends on CPU_V7
diff --git a/arch/arm/mm/cache-v7.S b/arch/arm/mm/cache-v7.S
index 7539ec2..2b37ba9 100644
--- a/arch/arm/mm/cache-v7.S
+++ b/arch/arm/mm/cache-v7.S
@@ -46,6 +46,14 @@ ENTRY(v7_flush_dcache_louis)
 	mrc	p15, 1, r0, c0, c0, 1		@ read clidr, r0 = clidr
 	ALT_SMP(ands	r3, r0, #(7 << 21))	@ extract LoUIS from clidr
 	ALT_UP(ands	r3, r0, #(7 << 27))	@ extract LoUU from clidr
+#ifdef CONFIG_ARM_ERRATA_643719
+	ALT_SMP(mrceq	p15, 0, r2, c0, c0, 0)	@ read main ID register
+	ALT_UP(moveq	pc, lr)			@ LoUU is zero, so nothing to do
+	ldreq	r1, =0x410fc090                 @ ID of ARM Cortex A9 r0p?
+	biceq	r2, r2, #0x0000000f             @ clear minor revision number
+	teqeq	r2, r1                          @ test for errata affected core and if so...
+	orreqs	r3, #(1 << 21)			@   fix LoUIS value (and set flags state to 'ne')
+#endif
 	ALT_SMP(mov	r3, r3, lsr #20)	@ r3 = LoUIS * 2
 	ALT_UP(mov	r3, r3, lsr #26)	@ r3 = LoUU * 2
 	moveq	pc, lr				@ return if level == 0
-- 
1.8.1.2

