Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3B1OqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:46:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3B1OqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:46:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 011/139] ARM: PXA3xx: program the CSMSADRCFG register
Date: Thu, 28 Feb 2013 14:42:41 +0000
Message-Id: <1362062689-2567-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Grinberg <grinberg@compulab.co.il>

commit d107a204154ddd79339203c2deeb7433f0cf6777 upstream.

The Chip Select Configuration Register must be programmed to 0x2 in
order to achieve the correct behavior of the Static Memory Controller.

Without this patch devices wired to DFI and accessed through SMC cannot
be accessed after resume from S2.

Do not rely on the boot loader to program the CSMSADRCFG register by
programming it in the kernel smemc module.

Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/mach-pxa/include/mach/smemc.h |  1 +
 arch/arm/mach-pxa/smemc.c              | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-pxa/include/mach/smemc.h b/arch/arm/mach-pxa/include/mach/smemc.h
index b7de471..b802f28 100644
--- a/arch/arm/mach-pxa/include/mach/smemc.h
+++ b/arch/arm/mach-pxa/include/mach/smemc.h
@@ -37,6 +37,7 @@
 #define CSADRCFG1	(SMEMC_VIRT + 0x84)  /* Address Configuration Register for CS1 */
 #define CSADRCFG2	(SMEMC_VIRT + 0x88)  /* Address Configuration Register for CS2 */
 #define CSADRCFG3	(SMEMC_VIRT + 0x8C)  /* Address Configuration Register for CS3 */
+#define CSMSADRCFG	(SMEMC_VIRT + 0xA0)  /* Chip Select Configuration Register */
 
 /*
  * More handy macros for PCMCIA
diff --git a/arch/arm/mach-pxa/smemc.c b/arch/arm/mach-pxa/smemc.c
index 7992305..f38aa89 100644
--- a/arch/arm/mach-pxa/smemc.c
+++ b/arch/arm/mach-pxa/smemc.c
@@ -40,6 +40,8 @@ static void pxa3xx_smemc_resume(void)
 	__raw_writel(csadrcfg[1], CSADRCFG1);
 	__raw_writel(csadrcfg[2], CSADRCFG2);
 	__raw_writel(csadrcfg[3], CSADRCFG3);
+	/* CSMSADRCFG wakes up in its default state (0), so we need to set it */
+	__raw_writel(0x2, CSMSADRCFG);
 }
 
 static struct syscore_ops smemc_syscore_ops = {
@@ -49,8 +51,19 @@ static struct syscore_ops smemc_syscore_ops = {
 
 static int __init smemc_init(void)
 {
-	if (cpu_is_pxa3xx())
+	if (cpu_is_pxa3xx()) {
+		/*
+		 * The only documentation we have on the
+		 * Chip Select Configuration Register (CSMSADRCFG) is that
+		 * it must be programmed to 0x2.
+		 * Moreover, in the bit definitions, the second bit
+		 * (CSMSADRCFG[1]) is called "SETALWAYS".
+		 * Other bits are reserved in this register.
+		 */
+		__raw_writel(0x2, CSMSADRCFG);
+
 		register_syscore_ops(&smemc_syscore_ops);
+	}
 
 	return 0;
 }
-- 
1.8.1.2

