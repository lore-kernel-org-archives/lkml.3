Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422833Ab3FUAf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:35:56 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:59848 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778Ab3FUAft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:35:49 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@fluxnic.net>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>, Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH v6 2/8] ARM: s3c64xx: Bypass legacy initialization when booting with DT
Date: Fri, 21 Jun 2013 02:35:18 +0200
Message-Id: <1371774924-9224-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
References: <1371774924-9224-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows bypassing most of legacy initialization when booting
an S3C64xx-based board using device tree, by adding conditional checks
for DT presence to initcalls which are no longer necessary when booting
with DT..

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 arch/arm/mach-s3c64xx/common.c  | 12 ++++++++++++
 arch/arm/mach-s3c64xx/dma.c     |  9 +++++++++
 arch/arm/mach-s3c64xx/irq-pm.c  |  9 +++++++++
 arch/arm/mach-s3c64xx/s3c6400.c |  9 +++++++++
 arch/arm/mach-s3c64xx/s3c6410.c |  9 +++++++++
 arch/arm/plat-samsung/init.c    | 12 +++++++++++-
 6 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c64xx/common.c b/arch/arm/mach-s3c64xx/common.c
index bf00e60..77a22c6 100644
--- a/arch/arm/mach-s3c64xx/common.c
+++ b/arch/arm/mach-s3c64xx/common.c
@@ -14,6 +14,10 @@
  * published by the Free Software Foundation.
  */
 
+/*
+ * NOTE: Code in this file is not used when booting with Device Tree support.
+ */
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -202,6 +206,10 @@ void __init s3c64xx_init_io(struct map_desc *mach_desc, int size)
 
 static __init int s3c64xx_dev_init(void)
 {
+	/* Not applicable when using DT. */
+	if (of_have_populated_dt())
+		return 0;
+
 	subsys_system_register(&s3c64xx_subsys, NULL);
 	return device_register(&s3c64xx_dev);
 }
@@ -403,6 +411,10 @@ static int __init s3c64xx_init_irq_eint(void)
 {
 	int irq;
 
+	/* On DT-enabled systems EINTs are handled by pinctrl-s3c64xx driver. */
+	if (of_have_populated_dt())
+		return -ENODEV;
+
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(27); irq++) {
 		irq_set_chip_and_handler(irq, &s3c_irq_eint, handle_level_irq);
 		irq_set_chip_data(irq, (void *)eint_irq_to_bit(irq));
diff --git a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
index c511dfa..7e22c21 100644
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -12,6 +12,10 @@
  * published by the Free Software Foundation.
 */
 
+/*
+ * NOTE: Code in this file is not used when booting with Device Tree support.
+ */
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -24,6 +28,7 @@
 #include <linux/err.h>
 #include <linux/io.h>
 #include <linux/amba/pl080.h>
+#include <linux/of.h>
 
 #include <mach/dma.h>
 #include <mach/map.h>
@@ -726,6 +731,10 @@ static int __init s3c64xx_dma_init(void)
 {
 	int ret;
 
+	/* This driver is not supported when booting with device tree. */
+	if (of_have_populated_dt())
+		return -ENODEV;
+
 	printk(KERN_INFO "%s: Registering DMA channels\n", __func__);
 
 	dma_pool = dma_pool_create("DMA-LLI", NULL, sizeof(struct pl080s_lli), 16, 0);
diff --git a/arch/arm/mach-s3c64xx/irq-pm.c b/arch/arm/mach-s3c64xx/irq-pm.c
index c3da1b6..1649c0d 100644
--- a/arch/arm/mach-s3c64xx/irq-pm.c
+++ b/arch/arm/mach-s3c64xx/irq-pm.c
@@ -12,12 +12,17 @@
  * published by the Free Software Foundation.
  */
 
+/*
+ * NOTE: Code in this file is not used when booting with Device Tree support.
+ */
+
 #include <linux/kernel.h>
 #include <linux/syscore_ops.h>
 #include <linux/interrupt.h>
 #include <linux/serial_core.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/of.h>
 
 #include <mach/map.h>
 
@@ -101,6 +106,10 @@ static struct syscore_ops s3c64xx_irq_syscore_ops = {
 
 static __init int s3c64xx_syscore_init(void)
 {
+	/* Appropriate drivers (pinctrl, uart) handle this when using DT. */
+	if (of_have_populated_dt())
+		return 0;
+
 	register_syscore_ops(&s3c64xx_irq_syscore_ops);
 
 	return 0;
diff --git a/arch/arm/mach-s3c64xx/s3c6400.c b/arch/arm/mach-s3c64xx/s3c6400.c
index 331fe8e..3db0c98 100644
--- a/arch/arm/mach-s3c64xx/s3c6400.c
+++ b/arch/arm/mach-s3c64xx/s3c6400.c
@@ -9,6 +9,10 @@
  * published by the Free Software Foundation.
 */
 
+/*
+ * NOTE: Code in this file is not used when booting with Device Tree support.
+ */
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
@@ -20,6 +24,7 @@
 #include <linux/device.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -76,6 +81,10 @@ static struct device s3c6400_dev = {
 
 static int __init s3c6400_core_init(void)
 {
+	/* Not applicable when using DT. */
+	if (of_have_populated_dt())
+		return 0;
+
 	return subsys_system_register(&s3c6400_subsys, NULL);
 }
 
diff --git a/arch/arm/mach-s3c64xx/s3c6410.c b/arch/arm/mach-s3c64xx/s3c6410.c
index 7e6fa12..72b2278 100644
--- a/arch/arm/mach-s3c64xx/s3c6410.c
+++ b/arch/arm/mach-s3c64xx/s3c6410.c
@@ -10,6 +10,10 @@
  * published by the Free Software Foundation.
 */
 
+/*
+ * NOTE: Code in this file is not used when booting with Device Tree support.
+ */
+
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/interrupt.h>
@@ -21,6 +25,7 @@
 #include <linux/device.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -79,6 +84,10 @@ static struct device s3c6410_dev = {
 
 static int __init s3c6410_core_init(void)
 {
+	/* Not applicable when using DT. */
+	if (of_have_populated_dt())
+		return 0;
+
 	return subsys_system_register(&s3c6410_subsys, NULL);
 }
 
diff --git a/arch/arm/plat-samsung/init.c b/arch/arm/plat-samsung/init.c
index 3e5c461..e92aee2 100644
--- a/arch/arm/plat-samsung/init.c
+++ b/arch/arm/plat-samsung/init.c
@@ -11,12 +11,18 @@
  * published by the Free Software Foundation.
 */
 
+/*
+ * NOTE: Code in this file is not used on S3C64xx when booting with
+ * Device Tree support.
+ */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/serial_core.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <mach/hardware.h>
 
@@ -147,8 +153,12 @@ static int __init s3c_arch_init(void)
 
 	// do the correct init for cpu
 
-	if (cpu == NULL)
+	if (cpu == NULL) {
+		/* Not needed when booting with device tree. */
+		if (of_have_populated_dt())
+			return 0;
 		panic("s3c_arch_init: NULL cpu\n");
+	}
 
 	ret = (cpu->init)();
 	if (ret != 0)
-- 
1.8.2.1

