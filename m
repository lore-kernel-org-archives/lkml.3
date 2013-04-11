Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937779Ab3DKANt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 20:13:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52058 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937298Ab3DKAGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 20:06:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <t.figa@samsung.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH 17/30] pwm: samsung: repair the worst MMIO abuses
Date: Thu, 11 Apr 2013 02:04:59 +0200
Message-Id: <1365638712-1028578-18-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:u9yWnfeNlhl72CdYMhmFTSoV4VATRU7OrQaMpOYfdUI
 FJBrjwRdndptWXlKM0j0wE66BUugcF1lCmY6sSO+rEE6S1gI2l
 EX5PACRbkf1psIXUccs/5uUJONHdSGwHOsqfTPCX+GvU4i7jRQ
 OEV8UziafyrEjHHhw5Shg9yqZM6yy5R1WdZ0VNR6i6VYV3N+v1
 XYpPpvs7HxfN/KjhzaxriPjV8S13axA4MOZfq0/zx+dn5XkZWz
 XZ9Iaq3Dcpe781QArAStcufVtPnfz5VqBxwBWH91XBvxwthRmI
 T8JEBtN8o/m9gv8po3I1kO2p1Y9Ly+NF05UimUr9r4D7qz4H3V
 vD3lvHkKIDoiEH8aO9rX6jZ7DOh46NGJW77LLnqiyU21BJiEtb
 DrljsmMvEpEpA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Samsung PWM driver uses "magic" pointers that are mapped
at boot time to point its MMIO registers. This fails horribly
with a multiplatform kernel, which can not rely on platform
specific header files to contain the right values, aside from
this being a really bad idea in general.

This changes the driver to at least pass an __iomem token
around in the device structure to dereference that. Fixing
the platform code is much harder, so we'll leave that
until we have a DT binding for pwm-samsung, which may require
other changes in this area. Since we are already touching
every MMIO accessor in this driver, let's also use the
proper readl_relaxed variant rather than __raw_readl.

Tomasz Figa has a set of patches to clean this up in a proper
way, but that might be too late for 3.10.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pwm/pwm-samsung.c | 60 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 5207e6c..9d7234d 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -22,9 +22,25 @@
 #include <linux/io.h>
 #include <linux/pwm.h>
 
-#include <mach/map.h>
+#ifndef CONFIG_ARCH_MULTIPLATFORM
+/*
+ * This is gross: the platform maps the timer at a fixed
+ * virtual address and expects us to use that address
+ * rather than a proper resource. This should get done properly
+ * when we get a DT binding for this driver.
+ */
+#include <plat/map-base.h>
+static inline void dummy(void)
+{
+	BUILD_BUG_ON(S3C_VA_TIMER != IOMEM(0xf6300000));
+}
+#else
+#define S3C_VA_TIMER IOMEM(0xf6300000);
+#endif
 
-#include <plat/regs-timer.h>
+#define S3C2410_TCON		8
+#define S3C2410_TCNTB(tmr)	(0x0c + (tmr)*0x0c + 0x00)
+#define S3C2410_TCMPB(tmr)	(0x0c + (tmr)*0x0c + 0x04)
 
 struct s3c_chip {
 	struct platform_device	*pdev;
@@ -38,6 +54,7 @@ struct s3c_chip {
 
 	unsigned char		 tcon_base;
 	unsigned char		 pwm_id;
+	void __iomem		*base;
 	struct pwm_chip		 chip;
 };
 
@@ -65,9 +82,9 @@ static int s3c_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	local_irq_save(flags);
 
-	tcon = __raw_readl(S3C2410_TCON);
+	tcon = readl_relaxed(s3c->base + S3C2410_TCON);
 	tcon |= pwm_tcon_start(s3c);
-	__raw_writel(tcon, S3C2410_TCON);
+	writel_relaxed(tcon, s3c->base + S3C2410_TCON);
 
 	local_irq_restore(flags);
 
@@ -82,9 +99,9 @@ static void s3c_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
 
 	local_irq_save(flags);
 
-	tcon = __raw_readl(S3C2410_TCON);
+	tcon = readl_relaxed(s3c->base + S3C2410_TCON);
 	tcon &= ~pwm_tcon_start(s3c);
-	__raw_writel(tcon, S3C2410_TCON);
+	writel_relaxed(tcon, s3c->base + S3C2410_TCON);
 
 	local_irq_restore(flags);
 }
@@ -133,8 +150,8 @@ static int s3c_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* The TCMP and TCNT can be read without a lock, they're not
 	 * shared between the timers. */
 
-	tcmp = __raw_readl(S3C2410_TCMPB(s3c->pwm_id));
-	tcnt = __raw_readl(S3C2410_TCNTB(s3c->pwm_id));
+	tcmp = readl_relaxed(s3c->base + S3C2410_TCMPB(s3c->pwm_id));
+	tcnt = readl_relaxed(s3c->base + S3C2410_TCNTB(s3c->pwm_id));
 
 	period = NS_IN_HZ / period_ns;
 
@@ -177,16 +194,16 @@ static int s3c_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	local_irq_save(flags);
 
-	__raw_writel(tcmp, S3C2410_TCMPB(s3c->pwm_id));
-	__raw_writel(tcnt, S3C2410_TCNTB(s3c->pwm_id));
+	writel_relaxed(tcmp, s3c->base + S3C2410_TCMPB(s3c->pwm_id));
+	writel_relaxed(tcnt, s3c->base + S3C2410_TCNTB(s3c->pwm_id));
 
-	tcon = __raw_readl(S3C2410_TCON);
+	tcon = readl_relaxed(s3c->base + S3C2410_TCON);
 	tcon |= pwm_tcon_manulupdate(s3c);
 	tcon |= pwm_tcon_autoreload(s3c);
-	__raw_writel(tcon, S3C2410_TCON);
+	writel_relaxed(tcon, s3c->base + S3C2410_TCON);
 
 	tcon &= ~pwm_tcon_manulupdate(s3c);
-	__raw_writel(tcon, S3C2410_TCON);
+	writel_relaxed(tcon, s3c->base + S3C2410_TCON);
 
 	local_irq_restore(flags);
 
@@ -207,6 +224,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	unsigned long flags;
 	unsigned long tcon;
 	unsigned int id = pdev->id;
+	struct resource *res;
 	int ret;
 
 	if (id == 4) {
@@ -220,6 +238,12 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	/* try to get a proper base address, fall back to S3C_VA_TIMER */
+	s3c->base = S3C_VA_TIMER;
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res)
+		s3c->base = devm_ioremap(dev, res->start, resource_size(res));
+
 	/* calculate base of control bits in TCON */
 	s3c->tcon_base = id == 0 ? 0 : (id * 4) + 4;
 	s3c->pwm_id = id;
@@ -245,9 +269,9 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 
 	local_irq_save(flags);
 
-	tcon = __raw_readl(S3C2410_TCON);
+	tcon = readl_relaxed(s3c->base + S3C2410_TCON);
 	tcon |= pwm_tcon_invert(s3c);
-	__raw_writel(tcon, S3C2410_TCON);
+	writel_relaxed(tcon, s3c->base + S3C2410_TCON);
 
 	local_irq_restore(flags);
 
@@ -258,7 +282,7 @@ static int s3c_pwm_probe(struct platform_device *pdev)
 	}
 
 	pwm_dbg(s3c, "config bits %02x\n",
-		(__raw_readl(S3C2410_TCON) >> s3c->tcon_base) & 0x0f);
+		(readl_relaxed(s3c->base + S3C2410_TCON) >> s3c->tcon_base) & 0x0f);
 
 	dev_info(dev, "tin at %lu, tdiv at %lu, tin=%sclk, base %d\n",
 		 clk_get_rate(s3c->clk),
@@ -310,9 +334,9 @@ static int s3c_pwm_resume(struct platform_device *pdev)
 	unsigned long tcon;
 
 	/* Restore invertion */
-	tcon = __raw_readl(S3C2410_TCON);
+	tcon = readl_relaxed(s3c->base + S3C2410_TCON);
 	tcon |= pwm_tcon_invert(s3c);
-	__raw_writel(tcon, S3C2410_TCON);
+	writel_relaxed(tcon, s3c->base + S3C2410_TCON);
 
 	return 0;
 }
-- 
1.8.1.2

