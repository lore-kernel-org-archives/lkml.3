Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3ILIkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:40:17 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:60988 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752382Ab3ILIkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:40:08 -0400
Date: Thu, 12 Sep 2013 10:40:04 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        Carlo Caione <carlo.caione@gmail.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [GIT PULL REQUEST] watchdog - v3.11-rc1 patches
Message-ID: <20130912084004.GB401@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://www.linux-watchdog.org/linux-watchdog.git

This contains:
* New watchdog driver for Allwinner A10/A13
* some devm_ioremap_resource simplifications
* a s3c2410_wdt change that removes the global variables

This will update the following files:

 Kconfig       |   10 ++
 Makefile      |    1 
 ar7_wdt.c     |    5 -
 nuc900_wdt.c  |    5 -
 s3c2410_wdt.c |  228 +++++++++++++++++++++++++++++++------------------------
 sunxi_wdt.c   |  237 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ts72xx_wdt.c  |   10 --
 7 files changed, 377 insertions(+), 119 deletions(-)

with these Changes:

commit bd5cc119ef6bbe8ad64a303542c436c7a82498b7
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Wed Aug 14 11:11:24 2013 +0200

    watchdog: s3c2410_wdt: simplify use of devm_ioremap_resource
    
    Remove unneeded error handling on the result of a call to
    platform_get_resource when the value is passed to devm_ioremap_resource.
    
    Move the call to platform_get_resource adjacent to the call to
    devm_ioremap_resource to make the connection between them more clear.
    
    A simplified version of the semantic patch that makes this change is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression pdev,res,n,e,e1;
    expression ret != 0;
    identifier l;
    @@
    
    - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
      ... when != res
    - if (res == NULL) { ... \(goto l;\|return ret;\) }
      ... when != res
    + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
      e = devm_ioremap_resource(e1, res);
    // </smpl>
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 8ecc7d2b2207ed9642e3d0140bfaa8c93a6ea47f
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Mon Aug 19 10:51:52 2013 +0200

    watchdog: simplify platform_get_resource_byname/devm_ioremap_resource
    
    Remove unneeded error handling on the result of a call to
    platform_get_resource_byname when the value is passed to devm_ioremap_resource.
    
    A simplified version of the semantic patch that makes this change is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression pdev,res,e,e1;
    expression ret != 0;
    identifier l;
    @@
    
      res = platform_get_resource_byname(...);
    - if (res == NULL) { ... \(goto l;\|return ret;\) }
      e = devm_ioremap_resource(e1, res);
    // </smpl>
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 086f2d500c693e2d175fe06c9dbfde1c69a26644
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Wed Aug 14 11:11:23 2013 +0200

    watchdog: ts72xx_wdt: simplify use of devm_ioremap_resource
    
    Remove unneeded error handling on the result of a call to
    platform_get_resource when the value is passed to devm_ioremap_resource.
    
    A simplified version of the semantic patch that makes this change is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression pdev,res,n,e,e1;
    expression ret != 0;
    identifier l;
    @@
    
    - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
      ... when != res
    - if (res == NULL) { ... \(goto l;\|return ret;\) }
      ... when != res
    + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
      e = devm_ioremap_resource(e1, res);
    // </smpl>
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit 9aebc962767194c330868f53e293d4179919912c
Author: Julia Lawall <Julia.Lawall@lip6.fr>
Date:   Wed Aug 14 11:11:14 2013 +0200

    watchdog: nuc900_wdt.c: simplify use of devm_ioremap_resource
    
    Remove unneeded error handling on the result of a call to
    platform_get_resource when the value is passed to devm_ioremap_resource.
    
    A simplified version of the semantic patch that makes this change is as
    follows: (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @@
    expression pdev,res,n,e,e1;
    expression ret != 0;
    identifier l;
    @@
    
    - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
      ... when != res
    - if (res == NULL) { ... \(goto l;\|return ret;\) }
      ... when != res
    + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
      e = devm_ioremap_resource(e1, res);
    // </smpl>
    
    Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
    Reviewed-by: Guenter Roeck <linux@roeck-us.net>
    Acked-by: Wan Zongshun <mcuos.com@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit d00680ed002649c8d06237a0abefcd89211757fd
Author: Carlo Caione <carlo.caione@gmail.com>
Date:   Tue Jul 30 21:20:46 2013 +0200

    watchdog: sunxi: New watchdog driver for Allwinner A10/A13
    
    This patch adds the driver for the watchdog found in the Allwinner A10 and
    A13 SoCs. It has DT-support and uses the new watchdog framework.
    
    Signed-off-by: Carlo Caione <carlo.caione@gmail.com>
    Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

commit af4ea6312cebd756221b813b0b69bca9b201a6af
Author: Leela Krishna Amudala <l.krishna@samsung.com>
Date:   Tue Aug 27 15:36:03 2013 +0530

    watchdog: s3c2410_wdt: remove the global variables
    
    This patch removes the global variables in the driver file and
    group them into a structure.
    
    Signed-off-by: Leela Krishna Amudala <l.krishna@samsung.com>
    Reviewed-by: Tomasz Figa <t.figa@samsung.com>
    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index 362085d..d1d53f3 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -290,6 +290,16 @@ config ORION_WATCHDOG
 	  To compile this driver as a module, choose M here: the
 	  module will be called orion_wdt.
 
+config SUNXI_WATCHDOG
+	tristate "Allwinner SoCs watchdog support"
+	depends on ARCH_SUNXI
+	select WATCHDOG_CORE
+	help
+	  Say Y here to include support for the watchdog timer
+	  in Allwinner SoCs.
+	  To compile this driver as a module, choose M here: the
+	  module will be called sunxi_wdt.
+
 config COH901327_WATCHDOG
 	bool "ST-Ericsson COH 901 327 watchdog"
 	depends on ARCH_U300
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 2f26a0b..6c5bb27 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_PNX4008_WATCHDOG) += pnx4008_wdt.o
 obj-$(CONFIG_IOP_WATCHDOG) += iop_wdt.o
 obj-$(CONFIG_DAVINCI_WATCHDOG) += davinci_wdt.o
 obj-$(CONFIG_ORION_WATCHDOG) += orion_wdt.o
+obj-$(CONFIG_SUNXI_WATCHDOG) += sunxi_wdt.o
 obj-$(CONFIG_COH901327_WATCHDOG) += coh901327_wdt.o
 obj-$(CONFIG_STMP3XXX_RTC_WATCHDOG) += stmp3xxx_rtc_wdt.o
 obj-$(CONFIG_NUC900_WATCHDOG) += nuc900_wdt.o
diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
index 2f3cc8f..b3709f9 100644
--- a/drivers/watchdog/ar7_wdt.c
+++ b/drivers/watchdog/ar7_wdt.c
@@ -280,11 +280,6 @@ static int ar7_wdt_probe(struct platform_device *pdev)
 
 	ar7_regs_wdt =
 		platform_get_resource_byname(pdev, IORESOURCE_MEM, "regs");
-	if (!ar7_regs_wdt) {
-		pr_err("could not get registers resource\n");
-		return -ENODEV;
-	}
-
 	ar7_wdt = devm_ioremap_resource(&pdev->dev, ar7_regs_wdt);
 	if (IS_ERR(ar7_wdt))
 		return PTR_ERR(ar7_wdt);
diff --git a/drivers/watchdog/nuc900_wdt.c b/drivers/watchdog/nuc900_wdt.c
index e2b6d2c..b15b6ef 100644
--- a/drivers/watchdog/nuc900_wdt.c
+++ b/drivers/watchdog/nuc900_wdt.c
@@ -256,11 +256,6 @@ static int nuc900wdt_probe(struct platform_device *pdev)
 	spin_lock_init(&nuc900_wdt->wdt_lock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no memory resource specified\n");
-		return -ENOENT;
-	}
-
 	nuc900_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(nuc900_wdt->wdt_base))
 		return PTR_ERR(nuc900_wdt->wdt_base);
diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 6a22cf5..23aad7c 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -84,13 +84,17 @@ MODULE_PARM_DESC(soft_noboot, "Watchdog action, set to 1 to ignore reboots, "
 			"0 to reboot (default 0)");
 MODULE_PARM_DESC(debug, "Watchdog debug, set to >1 for debug (default 0)");
 
-static struct device    *wdt_dev;	/* platform device attached to */
-static struct resource	*wdt_mem;
-static struct resource	*wdt_irq;
-static struct clk	*wdt_clock;
-static void __iomem	*wdt_base;
-static unsigned int	 wdt_count;
-static DEFINE_SPINLOCK(wdt_lock);
+struct s3c2410_wdt {
+	struct device		*dev;
+	struct clk		*clock;
+	void __iomem		*reg_base;
+	unsigned int		count;
+	spinlock_t		lock;
+	unsigned long		wtcon_save;
+	unsigned long		wtdat_save;
+	struct watchdog_device	wdt_device;
+	struct notifier_block	freq_transition;
+};
 
 /* watchdog control routines */
 
@@ -102,29 +106,38 @@ do {							\
 
 /* functions */
 
+static inline struct s3c2410_wdt *freq_to_wdt(struct notifier_block *nb)
+{
+	return container_of(nb, struct s3c2410_wdt, freq_transition);
+}
+
 static int s3c2410wdt_keepalive(struct watchdog_device *wdd)
 {
-	spin_lock(&wdt_lock);
-	writel(wdt_count, wdt_base + S3C2410_WTCNT);
-	spin_unlock(&wdt_lock);
+	struct s3c2410_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	spin_lock(&wdt->lock);
+	writel(wdt->count, wdt->reg_base + S3C2410_WTCNT);
+	spin_unlock(&wdt->lock);
 
 	return 0;
 }
 
-static void __s3c2410wdt_stop(void)
+static void __s3c2410wdt_stop(struct s3c2410_wdt *wdt)
 {
 	unsigned long wtcon;
 
-	wtcon = readl(wdt_base + S3C2410_WTCON);
+	wtcon = readl(wdt->reg_base + S3C2410_WTCON);
 	wtcon &= ~(S3C2410_WTCON_ENABLE | S3C2410_WTCON_RSTEN);
-	writel(wtcon, wdt_base + S3C2410_WTCON);
+	writel(wtcon, wdt->reg_base + S3C2410_WTCON);
 }
 
 static int s3c2410wdt_stop(struct watchdog_device *wdd)
 {
-	spin_lock(&wdt_lock);
-	__s3c2410wdt_stop();
-	spin_unlock(&wdt_lock);
+	struct s3c2410_wdt *wdt = watchdog_get_drvdata(wdd);
+
+	spin_lock(&wdt->lock);
+	__s3c2410wdt_stop(wdt);
+	spin_unlock(&wdt->lock);
 
 	return 0;
 }
@@ -132,12 +145,13 @@ static int s3c2410wdt_stop(struct watchdog_device *wdd)
 static int s3c2410wdt_start(struct watchdog_device *wdd)
 {
 	unsigned long wtcon;
+	struct s3c2410_wdt *wdt = watchdog_get_drvdata(wdd);
 
-	spin_lock(&wdt_lock);
+	spin_lock(&wdt->lock);
 
-	__s3c2410wdt_stop();
+	__s3c2410wdt_stop(wdt);
 
-	wtcon = readl(wdt_base + S3C2410_WTCON);
+	wtcon = readl(wdt->reg_base + S3C2410_WTCON);
 	wtcon |= S3C2410_WTCON_ENABLE | S3C2410_WTCON_DIV128;
 
 	if (soft_noboot) {
@@ -148,25 +162,26 @@ static int s3c2410wdt_start(struct watchdog_device *wdd)
 		wtcon |= S3C2410_WTCON_RSTEN;
 	}
 
-	DBG("%s: wdt_count=0x%08x, wtcon=%08lx\n",
-	    __func__, wdt_count, wtcon);
+	DBG("%s: count=0x%08x, wtcon=%08lx\n",
+	    __func__, wdt->count, wtcon);
 
-	writel(wdt_count, wdt_base + S3C2410_WTDAT);
-	writel(wdt_count, wdt_base + S3C2410_WTCNT);
-	writel(wtcon, wdt_base + S3C2410_WTCON);
-	spin_unlock(&wdt_lock);
+	writel(wdt->count, wdt->reg_base + S3C2410_WTDAT);
+	writel(wdt->count, wdt->reg_base + S3C2410_WTCNT);
+	writel(wtcon, wdt->reg_base + S3C2410_WTCON);
+	spin_unlock(&wdt->lock);
 
 	return 0;
 }
 
-static inline int s3c2410wdt_is_running(void)
+static inline int s3c2410wdt_is_running(struct s3c2410_wdt *wdt)
 {
-	return readl(wdt_base + S3C2410_WTCON) & S3C2410_WTCON_ENABLE;
+	return readl(wdt->reg_base + S3C2410_WTCON) & S3C2410_WTCON_ENABLE;
 }
 
 static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeout)
 {
-	unsigned long freq = clk_get_rate(wdt_clock);
+	struct s3c2410_wdt *wdt = watchdog_get_drvdata(wdd);
+	unsigned long freq = clk_get_rate(wdt->clock);
 	unsigned int count;
 	unsigned int divisor = 1;
 	unsigned long wtcon;
@@ -192,7 +207,7 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
 		}
 
 		if ((count / divisor) >= 0x10000) {
-			dev_err(wdt_dev, "timeout %d too big\n", timeout);
+			dev_err(wdt->dev, "timeout %d too big\n", timeout);
 			return -EINVAL;
 		}
 	}
@@ -201,15 +216,15 @@ static int s3c2410wdt_set_heartbeat(struct watchdog_device *wdd, unsigned timeou
 	    __func__, timeout, divisor, count, count/divisor);
 
 	count /= divisor;
-	wdt_count = count;
+	wdt->count = count;
 
 	/* update the pre-scaler */
-	wtcon = readl(wdt_base + S3C2410_WTCON);
+	wtcon = readl(wdt->reg_base + S3C2410_WTCON);
 	wtcon &= ~S3C2410_WTCON_PRESCALE_MASK;
 	wtcon |= S3C2410_WTCON_PRESCALE(divisor-1);
 
-	writel(count, wdt_base + S3C2410_WTDAT);
-	writel(wtcon, wdt_base + S3C2410_WTCON);
+	writel(count, wdt->reg_base + S3C2410_WTDAT);
+	writel(wtcon, wdt->reg_base + S3C2410_WTCON);
 
 	wdd->timeout = (count * divisor) / freq;
 
@@ -242,21 +257,23 @@ static struct watchdog_device s3c2410_wdd = {
 
 static irqreturn_t s3c2410wdt_irq(int irqno, void *param)
 {
-	dev_info(wdt_dev, "watchdog timer expired (irq)\n");
+	struct s3c2410_wdt *wdt = platform_get_drvdata(param);
+
+	dev_info(wdt->dev, "watchdog timer expired (irq)\n");
 
-	s3c2410wdt_keepalive(&s3c2410_wdd);
+	s3c2410wdt_keepalive(&wdt->wdt_device);
 	return IRQ_HANDLED;
 }
 
-
 #ifdef CONFIG_CPU_FREQ
 
 static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 					  unsigned long val, void *data)
 {
 	int ret;
+	struct s3c2410_wdt *wdt = freq_to_wdt(nb);
 
-	if (!s3c2410wdt_is_running())
+	if (!s3c2410wdt_is_running(wdt))
 		goto done;
 
 	if (val == CPUFREQ_PRECHANGE) {
@@ -265,14 +282,15 @@ static int s3c2410wdt_cpufreq_transition(struct notifier_block *nb,
 		 * the watchdog is running.
 		 */
 
-		s3c2410wdt_keepalive(&s3c2410_wdd);
+		s3c2410wdt_keepalive(&wdt->wdt_device);
 	} else if (val == CPUFREQ_POSTCHANGE) {
-		s3c2410wdt_stop(&s3c2410_wdd);
+		s3c2410wdt_stop(&wdt->wdt_device);
 
-		ret = s3c2410wdt_set_heartbeat(&s3c2410_wdd, s3c2410_wdd.timeout);
+		ret = s3c2410wdt_set_heartbeat(&wdt->wdt_device,
+						wdt->wdt_device.timeout);
 
 		if (ret >= 0)
-			s3c2410wdt_start(&s3c2410_wdd);
+			s3c2410wdt_start(&wdt->wdt_device);
 		else
 			goto err;
 	}
@@ -281,34 +299,35 @@ done:
 	return 0;
 
  err:
-	dev_err(wdt_dev, "cannot set new value for timeout %d\n",
-				s3c2410_wdd.timeout);
+	dev_err(wdt->dev, "cannot set new value for timeout %d\n",
+				wdt->wdt_device.timeout);
 	return ret;
 }
 
-static struct notifier_block s3c2410wdt_cpufreq_transition_nb = {
-	.notifier_call	= s3c2410wdt_cpufreq_transition,
-};
-
-static inline int s3c2410wdt_cpufreq_register(void)
+static inline int s3c2410wdt_cpufreq_register(struct s3c2410_wdt *wdt)
 {
-	return cpufreq_register_notifier(&s3c2410wdt_cpufreq_transition_nb,
+	wdt->freq_transition.notifier_call = s3c2410wdt_cpufreq_transition;
+
+	return cpufreq_register_notifier(&wdt->freq_transition,
 					 CPUFREQ_TRANSITION_NOTIFIER);
 }
 
-static inline void s3c2410wdt_cpufreq_deregister(void)
+static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
 {
-	cpufreq_unregister_notifier(&s3c2410wdt_cpufreq_transition_nb,
+	wdt->freq_transition.notifier_call = s3c2410wdt_cpufreq_transition;
+
+	cpufreq_unregister_notifier(&wdt->freq_transition,
 				    CPUFREQ_TRANSITION_NOTIFIER);
 }
 
 #else
-static inline int s3c2410wdt_cpufreq_register(void)
+
+static inline int s3c2410wdt_cpufreq_register(struct s3c2410_wdt *wdt)
 {
 	return 0;
 }
 
-static inline void s3c2410wdt_cpufreq_deregister(void)
+static inline void s3c2410wdt_cpufreq_deregister(struct s3c2410_wdt *wdt)
 {
 }
 #endif
@@ -316,6 +335,9 @@ static inline void s3c2410wdt_cpufreq_deregister(void)
 static int s3c2410wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev;
+	struct s3c2410_wdt *wdt;
+	struct resource *wdt_mem;
+	struct resource *wdt_irq;
 	unsigned int wtcon;
 	int started = 0;
 	int ret;
@@ -323,13 +345,14 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	DBG("%s: probe=%p\n", __func__, pdev);
 
 	dev = &pdev->dev;
-	wdt_dev = &pdev->dev;
 
-	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (wdt_mem == NULL) {
-		dev_err(dev, "no memory resource specified\n");
-		return -ENOENT;
-	}
+	wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
+	if (!wdt)
+		return -ENOMEM;
+
+	wdt->dev = &pdev->dev;
+	spin_lock_init(&wdt->lock);
+	wdt->wdt_device = s3c2410_wdd;
 
 	wdt_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (wdt_irq == NULL) {
@@ -339,35 +362,40 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	}
 
 	/* get the memory region for the watchdog timer */
-	wdt_base = devm_ioremap_resource(dev, wdt_mem);
-	if (IS_ERR(wdt_base)) {
-		ret = PTR_ERR(wdt_base);
+	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	wdt->reg_base = devm_ioremap_resource(dev, wdt_mem);
+	if (IS_ERR(wdt->reg_base)) {
+		ret = PTR_ERR(wdt->reg_base);
 		goto err;
 	}
 
-	DBG("probe: mapped wdt_base=%p\n", wdt_base);
+	DBG("probe: mapped reg_base=%p\n", wdt->reg_base);
 
-	wdt_clock = devm_clk_get(dev, "watchdog");
-	if (IS_ERR(wdt_clock)) {
+	wdt->clock = devm_clk_get(dev, "watchdog");
+	if (IS_ERR(wdt->clock)) {
 		dev_err(dev, "failed to find watchdog clock source\n");
-		ret = PTR_ERR(wdt_clock);
+		ret = PTR_ERR(wdt->clock);
 		goto err;
 	}
 
-	clk_prepare_enable(wdt_clock);
+	clk_prepare_enable(wdt->clock);
 
-	ret = s3c2410wdt_cpufreq_register();
+	ret = s3c2410wdt_cpufreq_register(wdt);
 	if (ret < 0) {
 		dev_err(dev, "failed to register cpufreq\n");
 		goto err_clk;
 	}
 
+	watchdog_set_drvdata(&wdt->wdt_device, wdt);
+
 	/* see if we can actually set the requested timer margin, and if
 	 * not, try the default value */
 
-	watchdog_init_timeout(&s3c2410_wdd, tmr_margin,  &pdev->dev);
-	if (s3c2410wdt_set_heartbeat(&s3c2410_wdd, s3c2410_wdd.timeout)) {
-		started = s3c2410wdt_set_heartbeat(&s3c2410_wdd,
+	watchdog_init_timeout(&wdt->wdt_device, tmr_margin, &pdev->dev);
+	ret = s3c2410wdt_set_heartbeat(&wdt->wdt_device,
+					wdt->wdt_device.timeout);
+	if (ret) {
+		started = s3c2410wdt_set_heartbeat(&wdt->wdt_device,
 					CONFIG_S3C2410_WATCHDOG_DEFAULT_TIME);
 
 		if (started == 0)
@@ -386,9 +414,9 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 		goto err_cpufreq;
 	}
 
-	watchdog_set_nowayout(&s3c2410_wdd, nowayout);
+	watchdog_set_nowayout(&wdt->wdt_device, nowayout);
 
-	ret = watchdog_register_device(&s3c2410_wdd);
+	ret = watchdog_register_device(&wdt->wdt_device);
 	if (ret) {
 		dev_err(dev, "cannot register watchdog (%d)\n", ret);
 		goto err_cpufreq;
@@ -396,18 +424,20 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 
 	if (tmr_atboot && started == 0) {
 		dev_info(dev, "starting watchdog timer\n");
-		s3c2410wdt_start(&s3c2410_wdd);
+		s3c2410wdt_start(&wdt->wdt_device);
 	} else if (!tmr_atboot) {
 		/* if we're not enabling the watchdog, then ensure it is
 		 * disabled if it has been left running from the bootloader
 		 * or other source */
 
-		s3c2410wdt_stop(&s3c2410_wdd);
+		s3c2410wdt_stop(&wdt->wdt_device);
 	}
 
+	platform_set_drvdata(pdev, wdt);
+
 	/* print out a statement of readiness */
 
-	wtcon = readl(wdt_base + S3C2410_WTCON);
+	wtcon = readl(wdt->reg_base + S3C2410_WTCON);
 
 	dev_info(dev, "watchdog %sactive, reset %sabled, irq %sabled\n",
 		 (wtcon & S3C2410_WTCON_ENABLE) ?  "" : "in",
@@ -417,64 +447,64 @@ static int s3c2410wdt_probe(struct platform_device *pdev)
 	return 0;
 
  err_cpufreq:
-	s3c2410wdt_cpufreq_deregister();
+	s3c2410wdt_cpufreq_deregister(wdt);
 
  err_clk:
-	clk_disable_unprepare(wdt_clock);
-	wdt_clock = NULL;
+	clk_disable_unprepare(wdt->clock);
+	wdt->clock = NULL;
 
  err:
-	wdt_irq = NULL;
-	wdt_mem = NULL;
 	return ret;
 }
 
 static int s3c2410wdt_remove(struct platform_device *dev)
 {
-	watchdog_unregister_device(&s3c2410_wdd);
+	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
 
-	s3c2410wdt_cpufreq_deregister();
+	watchdog_unregister_device(&wdt->wdt_device);
 
-	clk_disable_unprepare(wdt_clock);
-	wdt_clock = NULL;
+	s3c2410wdt_cpufreq_deregister(wdt);
+
+	clk_disable_unprepare(wdt->clock);
+	wdt->clock = NULL;
 
-	wdt_irq = NULL;
-	wdt_mem = NULL;
 	return 0;
 }
 
 static void s3c2410wdt_shutdown(struct platform_device *dev)
 {
-	s3c2410wdt_stop(&s3c2410_wdd);
+	struct s3c2410_wdt *wdt = platform_get_drvdata(dev);
+
+	s3c2410wdt_stop(&wdt->wdt_device);
 }
 
 #ifdef CONFIG_PM_SLEEP
 
-static unsigned long wtcon_save;
-static unsigned long wtdat_save;
-
 static int s3c2410wdt_suspend(struct device *dev)
 {
+	struct s3c2410_wdt *wdt = dev_get_drvdata(dev);
+
 	/* Save watchdog state, and turn it off. */
-	wtcon_save = readl(wdt_base + S3C2410_WTCON);
-	wtdat_save = readl(wdt_base + S3C2410_WTDAT);
+	wdt->wtcon_save = readl(wdt->reg_base + S3C2410_WTCON);
+	wdt->wtdat_save = readl(wdt->reg_base + S3C2410_WTDAT);
 
 	/* Note that WTCNT doesn't need to be saved. */
-	s3c2410wdt_stop(&s3c2410_wdd);
+	s3c2410wdt_stop(&wdt->wdt_device);
 
 	return 0;
 }
 
 static int s3c2410wdt_resume(struct device *dev)
 {
-	/* Restore watchdog state. */
+	struct s3c2410_wdt *wdt = dev_get_drvdata(dev);
 
-	writel(wtdat_save, wdt_base + S3C2410_WTDAT);
-	writel(wtdat_save, wdt_base + S3C2410_WTCNT); /* Reset count */
-	writel(wtcon_save, wdt_base + S3C2410_WTCON);
+	/* Restore watchdog state. */
+	writel(wdt->wtdat_save, wdt->reg_base + S3C2410_WTDAT);
+	writel(wdt->wtdat_save, wdt->reg_base + S3C2410_WTCNT);/* Reset count */
+	writel(wdt->wtcon_save, wdt->reg_base + S3C2410_WTCON);
 
 	dev_info(dev, "watchdog %sabled\n",
-		(wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
+		(wdt->wtcon_save & S3C2410_WTCON_ENABLE) ? "en" : "dis");
 
 	return 0;
 }
diff --git a/drivers/watchdog/sunxi_wdt.c b/drivers/watchdog/sunxi_wdt.c
new file mode 100644
index 0000000..1f94b42
--- /dev/null
+++ b/drivers/watchdog/sunxi_wdt.c
@@ -0,0 +1,237 @@
+/*
+ *      sunxi Watchdog Driver
+ *
+ *      Copyright (c) 2013 Carlo Caione
+ *                    2012 Henrik Nordstrom
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ *
+ *      Based on xen_wdt.c
+ *      (c) Copyright 2010 Novell, Inc.
+ */
+
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+
+#define WDT_MAX_TIMEOUT         16
+#define WDT_MIN_TIMEOUT         1
+#define WDT_MODE_TIMEOUT(n)     ((n) << 3)
+#define WDT_TIMEOUT_MASK        WDT_MODE_TIMEOUT(0x0F)
+
+#define WDT_CTRL                0x00
+#define WDT_CTRL_RELOAD         ((1 << 0) | (0x0a57 << 1))
+
+#define WDT_MODE                0x04
+#define WDT_MODE_EN             (1 << 0)
+#define WDT_MODE_RST_EN         (1 << 1)
+
+#define DRV_NAME		"sunxi-wdt"
+#define DRV_VERSION		"1.0"
+
+static bool nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int timeout = WDT_MAX_TIMEOUT;
+
+struct sunxi_wdt_dev {
+	struct watchdog_device wdt_dev;
+	void __iomem *wdt_base;
+};
+
+/*
+ * wdt_timeout_map maps the watchdog timer interval value in seconds to
+ * the value of the register WDT_MODE bit 3:6
+ *
+ * [timeout seconds] = register value
+ *
+ */
+
+static const int wdt_timeout_map[] = {
+	[1] = 0b0001,  /* 1s  */
+	[2] = 0b0010,  /* 2s  */
+	[3] = 0b0011,  /* 3s  */
+	[4] = 0b0100,  /* 4s  */
+	[5] = 0b0101,  /* 5s  */
+	[6] = 0b0110,  /* 6s  */
+	[8] = 0b0111,  /* 8s  */
+	[10] = 0b1000, /* 10s */
+	[12] = 0b1001, /* 12s */
+	[14] = 0b1010, /* 14s */
+	[16] = 0b1011, /* 16s */
+};
+
+static int sunxi_wdt_ping(struct watchdog_device *wdt_dev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+
+	iowrite32(WDT_CTRL_RELOAD, wdt_base + WDT_CTRL);
+
+	return 0;
+}
+
+static int sunxi_wdt_set_timeout(struct watchdog_device *wdt_dev,
+		unsigned int timeout)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	u32 reg;
+
+	if (wdt_timeout_map[timeout] == 0)
+		timeout++;
+
+	sunxi_wdt->wdt_dev.timeout = timeout;
+
+	reg = ioread32(wdt_base + WDT_MODE);
+	reg &= ~WDT_TIMEOUT_MASK;
+	reg |= WDT_MODE_TIMEOUT(wdt_timeout_map[timeout]);
+	iowrite32(reg, wdt_base + WDT_MODE);
+
+	sunxi_wdt_ping(wdt_dev);
+
+	return 0;
+}
+
+static int sunxi_wdt_stop(struct watchdog_device *wdt_dev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+
+	iowrite32(0, wdt_base + WDT_MODE);
+
+	return 0;
+}
+
+static int sunxi_wdt_start(struct watchdog_device *wdt_dev)
+{
+	u32 reg;
+	struct sunxi_wdt_dev *sunxi_wdt = watchdog_get_drvdata(wdt_dev);
+	void __iomem *wdt_base = sunxi_wdt->wdt_base;
+	int ret;
+
+	ret = sunxi_wdt_set_timeout(&sunxi_wdt->wdt_dev,
+			sunxi_wdt->wdt_dev.timeout);
+	if (ret < 0)
+		return ret;
+
+	reg = ioread32(wdt_base + WDT_MODE);
+	reg |= (WDT_MODE_RST_EN | WDT_MODE_EN);
+	iowrite32(reg, wdt_base + WDT_MODE);
+
+	return 0;
+}
+
+static const struct watchdog_info sunxi_wdt_info = {
+	.identity	= DRV_NAME,
+	.options	= WDIOF_SETTIMEOUT |
+			  WDIOF_KEEPALIVEPING |
+			  WDIOF_MAGICCLOSE,
+};
+
+static const struct watchdog_ops sunxi_wdt_ops = {
+	.owner		= THIS_MODULE,
+	.start		= sunxi_wdt_start,
+	.stop		= sunxi_wdt_stop,
+	.ping		= sunxi_wdt_ping,
+	.set_timeout	= sunxi_wdt_set_timeout,
+};
+
+static int __init sunxi_wdt_probe(struct platform_device *pdev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt;
+	struct resource *res;
+	int err;
+
+	sunxi_wdt = devm_kzalloc(&pdev->dev, sizeof(*sunxi_wdt), GFP_KERNEL);
+	if (!sunxi_wdt)
+		return -EINVAL;
+
+	platform_set_drvdata(pdev, sunxi_wdt);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	sunxi_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(sunxi_wdt->wdt_base))
+		return PTR_ERR(sunxi_wdt->wdt_base);
+
+	sunxi_wdt->wdt_dev.info = &sunxi_wdt_info;
+	sunxi_wdt->wdt_dev.ops = &sunxi_wdt_ops;
+	sunxi_wdt->wdt_dev.timeout = WDT_MAX_TIMEOUT;
+	sunxi_wdt->wdt_dev.max_timeout = WDT_MAX_TIMEOUT;
+	sunxi_wdt->wdt_dev.min_timeout = WDT_MIN_TIMEOUT;
+	sunxi_wdt->wdt_dev.parent = &pdev->dev;
+
+	watchdog_init_timeout(&sunxi_wdt->wdt_dev, timeout, &pdev->dev);
+	watchdog_set_nowayout(&sunxi_wdt->wdt_dev, nowayout);
+
+	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, sunxi_wdt);
+
+	sunxi_wdt_stop(&sunxi_wdt->wdt_dev);
+
+	err = watchdog_register_device(&sunxi_wdt->wdt_dev);
+	if (unlikely(err))
+		return err;
+
+	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
+			sunxi_wdt->wdt_dev.timeout, nowayout);
+
+	return 0;
+}
+
+static int __exit sunxi_wdt_remove(struct platform_device *pdev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
+
+	watchdog_unregister_device(&sunxi_wdt->wdt_dev);
+	watchdog_set_drvdata(&sunxi_wdt->wdt_dev, NULL);
+
+	return 0;
+}
+
+static void sunxi_wdt_shutdown(struct platform_device *pdev)
+{
+	struct sunxi_wdt_dev *sunxi_wdt = platform_get_drvdata(pdev);
+
+	sunxi_wdt_stop(&sunxi_wdt->wdt_dev);
+}
+
+static const struct of_device_id sunxi_wdt_dt_ids[] = {
+	{ .compatible = "allwinner,sun4i-wdt" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, sunxi_wdt_dt_ids);
+
+static struct platform_driver sunxi_wdt_driver = {
+	.probe		= sunxi_wdt_probe,
+	.remove		= sunxi_wdt_remove,
+	.shutdown	= sunxi_wdt_shutdown,
+	.driver		= {
+		.owner		= THIS_MODULE,
+		.name		= DRV_NAME,
+		.of_match_table	= of_match_ptr(sunxi_wdt_dt_ids)
+	},
+};
+
+module_platform_driver(sunxi_wdt_driver);
+
+module_param(timeout, uint, 0);
+MODULE_PARM_DESC(timeout, "Watchdog heartbeat in seconds");
+
+module_param(nowayout, bool, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+		"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Carlo Caione <carlo.caione@gmail.com>");
+MODULE_AUTHOR("Henrik Nordstrom <henrik@henriknordstrom.net>");
+MODULE_DESCRIPTION("sunxi WatchDog Timer Driver");
+MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index 4da59b4..42913f1 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -403,21 +403,11 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 	}
 
 	r1 = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r1) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		return -ENODEV;
-	}
-
 	wdt->control_reg = devm_ioremap_resource(&pdev->dev, r1);
 	if (IS_ERR(wdt->control_reg))
 		return PTR_ERR(wdt->control_reg);
 
 	r2 = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	if (!r2) {
-		dev_err(&pdev->dev, "failed to get memory resource\n");
-		return -ENODEV;
-	}
-
 	wdt->feed_reg = devm_ioremap_resource(&pdev->dev, r2);
 	if (IS_ERR(wdt->feed_reg))
 		return PTR_ERR(wdt->feed_reg);
