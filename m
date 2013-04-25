Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab3DYR3P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:29:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab3DYR3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bastian Hecht <hechtb+renesas@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionally
Date: Thu, 25 Apr 2013 19:28:46 +0200
Message-Id: <1366910944-3033663-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:s2O3eT//xPUrEjzC6/5AaONoHpUWDAFbOy3yFPU7brN
 xs38LIYzmMo3x/Tn20ksnbkw8f+8j737PpFnNDNYUSMOOk6IvV
 7Wpl2AGXZs/bUwYdx2Q8ZyHGpgRDQmvM7gMDGCcsazU9BGM0zK
 +DPYmTUJ0DWSim3SmARKCSEDhIsa/KFL5GD5jWfCHsBHWgy6Ni
 tr51NlG7F1jpi0THNkrXm9hsDiGp3jdqBcMG/oNwkEzOf8z36p
 nyVWVxhcR12Hj7eUePkImg3cd4QPjUJXtq6jl+XmMiIbxN/geD
 yJtdV+6pZEZmIoH2Zp8UXaGqbIKwXo+bL5Dl35c8J6/JFqegGH
 GfnotF+DceD18X17j8moMAjRYCkVPbJF9L9rEPk1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The irqchip_init function is only available when building
with CONFIG_OF enabled, which causes this build failure for
bonito_defconfig:

arch/arm/mach-shmobile/built-in.o: In function `r8a7740_init_irq_of':
:(.init.text+0x580): undefined reference to `irqchip_init'

This makes both the OF and the ATAGS portion of the driver
conditional, which avoids the build error and also results
in smaller object code if not both are enabled, without the
need for an #ifdef.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Bastian Hecht <hechtb+renesas@gmail.com>
Cc: Simon Horman <horms+renesas@verge.net.au>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
---
 arch/arm/mach-shmobile/intc-r8a7740.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-shmobile/intc-r8a7740.c b/arch/arm/mach-shmobile/intc-r8a7740.c
index 8871f77..5dc57f1 100644
--- a/arch/arm/mach-shmobile/intc-r8a7740.c
+++ b/arch/arm/mach-shmobile/intc-r8a7740.c
@@ -53,14 +53,23 @@ static void __init r8a7740_init_irq_common(void)
 
 void __init r8a7740_init_irq_of(void)
 {
+	if (!IS_ENABLED(CONFIG_OF))
+		return;
+
 	irqchip_init();
 	r8a7740_init_irq_common();
 }
 
 void __init r8a7740_init_irq(void)
 {
-	void __iomem *gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
-	void __iomem *gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
+	void __iomem *gic_dist_base;
+	void __iomem *gic_cpu_base;
+
+	if (!IS_ENABLED(CONFIG_ATAGS))
+		return;
+
+	gic_dist_base = ioremap_nocache(0xc2800000, 0x1000);
+	gic_cpu_base = ioremap_nocache(0xc2000000, 0x1000);
 
 	/* initialize the Generic Interrupt Controller PL390 r0p0 */
 	gic_init(0, 29, gic_dist_base, gic_cpu_base);
-- 
1.8.1.2

