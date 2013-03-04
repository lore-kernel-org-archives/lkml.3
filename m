Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3CDDml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60748 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754823Ab3CDDmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:35 -0500
Message-Id: <20130304033708.853079921@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Igor Grinberg <grinberg@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [ 012/153] ARM: PXA3xx: program the CSMSADRCFG register
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-pxa/include/mach/smemc.h |    1 +
 arch/arm/mach-pxa/smemc.c              |   15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-pxa/include/mach/smemc.h
+++ b/arch/arm/mach-pxa/include/mach/smemc.h
@@ -37,6 +37,7 @@
 #define CSADRCFG1	(SMEMC_VIRT + 0x84)  /* Address Configuration Register for CS1 */
 #define CSADRCFG2	(SMEMC_VIRT + 0x88)  /* Address Configuration Register for CS2 */
 #define CSADRCFG3	(SMEMC_VIRT + 0x8C)  /* Address Configuration Register for CS3 */
+#define CSMSADRCFG	(SMEMC_VIRT + 0xA0)  /* Chip Select Configuration Register */
 
 /*
  * More handy macros for PCMCIA
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
@@ -49,8 +51,19 @@ static struct syscore_ops smemc_syscore_
 
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


