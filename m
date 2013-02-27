Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929Ab3B0ARD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:17:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760415Ab3B0AJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Igor Grinberg <grinberg@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [ 58/86] ARM: PXA3xx: program the CSMSADRCFG register
Date: Tue, 26 Feb 2013 16:08:06 -0800
Message-Id: <20130226235918.936540604@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


