Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161070AbaJ3Pny (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:43:54 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62847 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933358AbaJ3Pnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:43:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        linux-watchdog@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH] watchdog: at91rm9200: allow building when using device tree
Date: Thu, 30 Oct 2014 16:43:09 +0100
Message-ID: <3649339.YOqvibXDK5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141030151719.GG17398@piout.net>
References: <1414678534-2677-1-git-send-email-alexandre.belloni@free-electrons.com> <2000678.14fQbcst9s@wuerfel> <20141030151719.GG17398@piout.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LQ1cM9W3L8jdVKeJiMN477kZD4zyjTt0zctjNT4gnuV
 921ix3F/cLMacRK+wLiWr4DD7tC6f4FANomCmm2P9oc6HfFQkx
 Euz/pttT/PiP6hoxu2dA667ONwz5DNYl1a3mW8ld9DsZmuHEYF
 n7qxMyJCaewCIhrUIi/SuBvou4bTanqBjVQntpVFhRGSOo5O0u
 MCiKR8qlVL9+pNhBbKZ/IzAYEm9Nt2xgIII//50mzgLFOveHUs
 kycH6orgI+RxXcNA6EaZmakVIeiXeNNb38lWDwFNpHGHsOmC2k
 D1R5r/t3nvWQgvISr2nFqwbBQ2OlYZwy48UvabFwPrqTUpiVWG
 vfpJPYdi2+mttTWcR4cY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 16:17:19 Alexandre Belloni wrote:
> 
> On 30/10/2014 at 15:43:43 +0100, Arnd Bergmann wrote :
> > On Thursday 30 October 2014 15:36:24 Boris Brezillon wrote:
> > > On Thu, 30 Oct 2014 15:15:34 +0100
> > > Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
> > > 
> > > > When building with device tree, ARCH_AT91RM9200 may not be selected. Allow
> > > > building that driver by also depending on ARCH_AT91.
> > > > 
> > > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> > > 
> > > Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> > > 
> > 
> > Doesn't this reintroduce the bug fixed by commit 09549cd0172 ("watchdog:
> > Revert the AT91RM9200_WATCHDOG dependency")?
> > 
> > At least in 3.18-rc2, the driver still uses at91_st_write/at91_st_read.
> > 
> 
> Hum, right, then we have no better way to express that than depends on
> SOC_AT91RM9200, would that be acceptable ?
> 

Sounds fine to me, but why can't we just fix the dependency?


Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-at91/at91rm9200_devices.c b/arch/arm/mach-at91/at91rm9200_devices.c
index 74f1eaf97801..7f51e406b240 100644
--- a/arch/arm/mach-at91/at91rm9200_devices.c
+++ b/arch/arm/mach-at91/at91rm9200_devices.c
@@ -719,10 +719,19 @@ static void __init at91_add_device_rtc(void) {}
  * -------------------------------------------------------------------- */
 
 #if defined(CONFIG_AT91RM9200_WATCHDOG) || defined(CONFIG_AT91RM9200_WATCHDOG_MODULE)
+static struct resource wdt_resources[] = {
+	[0] = {
+		.start	= AT91RM9200_BASE_ST,
+		.end	= AT91RM9200_BASE_ST + SZ_256 - 1,
+		.flags	= IORESOURCE_MEM,
+	};
+};
+
 static struct platform_device at91rm9200_wdt_device = {
-	.name		= "at91_wdt",
+	.name		= "at91rm9200_wdt",
 	.id		= -1,
-	.num_resources	= 0,
+	.resource	= wdt_resources,
+	.num_resources	= 1,
 };
 
 static void __init at91_add_device_watchdog(void)
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index d0107d424ee4..0592db68f3a8 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -154,14 +154,14 @@ config ARM_SP805_WATCHDOG
 
 config AT91RM9200_WATCHDOG
 	tristate "AT91RM9200 watchdog"
-	depends on ARCH_AT91RM9200
+	depends on ARCH_AT91 || COMPILE_TEST
 	help
 	  Watchdog timer embedded into AT91RM9200 chips. This will reboot your
 	  system when the timeout is reached.
 
 config AT91SAM9X_WATCHDOG
 	tristate "AT91SAM9X / AT91CAP9 watchdog"
-	depends on ARCH_AT91 && !ARCH_AT91RM9200
+	depends on ARCH_AT91
 	select WATCHDOG_CORE
 	help
 	  Watchdog timer embedded into AT91SAM9X and AT91CAP9 chips. This will
diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index dee6cc21d270..6b846e009268 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -26,11 +26,27 @@
 #include <linux/uaccess.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <mach/at91_st.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
 #define WDT_MAX_TIME		256	/* seconds */
 
+static void __iomem *at91_st_base;
+
+#define at91_st_read(field) \
+	readl(at91_st_base + field)
+
+#define at91_st_write(field, value) \
+	writel(value, at91_st_base + field)
+
+#define	AT91_ST_CR		0x00			/* Control Register */
+#define 	AT91_ST_WDRST		(1 << 0)		/* Watchdog Timer Restart */
+
+#define	AT91_ST_WDMR		0x08			/* Watchdog Mode Register */
+#define		AT91_ST_WDV		(0xffff <<  0)		/* Watchdog Counter Value */
+#define		AT91_ST_RSTEN		(1	<< 16)		/* Reset Enable */
+#define		AT91_ST_EXTEN		(1	<< 17)		/* External Signal Assertion Enable */
+
+
 static int wdt_time = WDT_DEFAULT_TIME;
 static bool nowayout = WATCHDOG_NOWAYOUT;
 
@@ -203,12 +222,17 @@ static struct miscdevice at91wdt_miscdev = {
 
 static int at91wdt_probe(struct platform_device *pdev)
 {
+	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	int res;
 
 	if (at91wdt_miscdev.parent)
 		return -EBUSY;
 	at91wdt_miscdev.parent = &pdev->dev;
 
+	at91_st_base = devm_ioremap_resource(&pdev->dev, regs);
+	if (!at91_st_base)
+		return -ENXIO;
+
 	res = misc_register(&at91wdt_miscdev);
 	if (res)
 		return res;
@@ -255,6 +279,7 @@ static int at91wdt_resume(struct platform_device *pdev)
 #endif
 
 static const struct of_device_id at91_wdt_dt_ids[] = {
+	{ .compatible = "atmel,at91rm9200-st" },
 	{ .compatible = "atmel,at91rm9200-wdt" },
 	{ /* sentinel */ }
 };
@@ -267,7 +292,7 @@ static struct platform_driver at91wdt_driver = {
 	.suspend	= at91wdt_suspend,
 	.resume		= at91wdt_resume,
 	.driver		= {
-		.name	= "at91_wdt",
+		.name	= "at91rm9200_wdt",
 		.owner	= THIS_MODULE,
 		.of_match_table = at91_wdt_dt_ids,
 	},

