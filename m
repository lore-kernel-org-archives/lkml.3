Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab3C3N3X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 09:29:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60162 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756030Ab3C3N3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 09:29:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v4 6/6] USB: OHCI: avoid conflicting platform drivers
Date: Sat, 30 Mar 2013 14:29:38 +0100
Message-Id: <1364650178-29389-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364648663-29296-1-git-send-email-arnd@arndb.de>
References: <1364648663-29296-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:JKUfN8Z5zi3zOVdvB7ObEIuu/m57IpphPDElsO9bxQH
 cIH5D3PpQ09s1HkzZ5PW9aPgCiEZnpqINo7xxO6vldPxRzSlXK
 lGLzxBE6/EEGFwQywRQXR8A/X1W1Tw69r8JdHsJ8KaHsz/lZYI
 2CtRzimQ0DBUnOwDnQ0tuo+VtbFlzua+Vcm1qwWpAmcm+hoP+P
 KxV1MmVeu0op/nOQxBuTCmP6VbmqXCXoMMx4KEyr5inFzGSnTs
 wjKwx+DTlKl78hT5AWmRqZrfqgbMeFpDe7Lbgg3mUedyU62KIs
 XH7//9Gl/J53LLJersHTThcGNxRJfuL8kHES4Sf3+eZENPNZxy
 NC4Ve7yUe3Qk0zsG2MEu8/+io33YeYaxiSVGWS5SEc5pl1qGv5
 Th7nrF6BQyJFA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the EHCI driver, OHCI supports a large number of different platform
glue drivers by directly including them, which causes problems with
conflicting macro definitions in some cases. As more ARM architecture
specific back-ends are required to coexist in a single build, we should
split those out into separate drivers. Unfortunately, the infrastructure
for that is still under development, so to give us more time, this uses
a separate *_PLATFORM_DRIVER macro for each ARM specific OHCI backend,
just like we already do on PowerPC and some of the other ARM platforms.

In linux-3.10, only the SPEAr and CNS3xxx back-ends would actually conflict
without this patch, but over time we would get more of them, so this
is a way to avoid having to patch the driver every time it breaks. We
should still split out all back-ends into separate loadable modules,
but that work is only needed to improve code size and cleanliness after
this patch, not for correctness.

While we're here, this fixes the incorrectly sorted error path
for the OMAP1 and OMAP3 backends to ensure we always unregister
the exact set of drivers that were registered before erroring out.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Manjunath Goudar <manjunath.goudar@linaro.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/ohci-hcd.c | 136 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 118 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 180a2b0..9e6de95 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -1102,12 +1102,12 @@ MODULE_LICENSE ("GPL");
 
 #if defined(CONFIG_ARCH_S3C24XX) || defined(CONFIG_ARCH_S3C64XX)
 #include "ohci-s3c2410.c"
-#define PLATFORM_DRIVER		ohci_hcd_s3c2410_driver
+#define S3C2410_PLATFORM_DRIVER	ohci_hcd_s3c2410_driver
 #endif
 
 #ifdef CONFIG_USB_OHCI_EXYNOS
 #include "ohci-exynos.c"
-#define PLATFORM_DRIVER		exynos_ohci_driver
+#define EXYNOS_PLATFORM_DRIVER	exynos_ohci_driver
 #endif
 
 #ifdef CONFIG_USB_OHCI_HCD_OMAP1
@@ -1127,25 +1127,24 @@ MODULE_LICENSE ("GPL");
 
 #ifdef CONFIG_ARCH_EP93XX
 #include "ohci-ep93xx.c"
-#define PLATFORM_DRIVER		ohci_hcd_ep93xx_driver
+#define EP93XX_PLATFORM_DRIVER	ohci_hcd_ep93xx_driver
 #endif
 
 #ifdef CONFIG_ARCH_AT91
 #include "ohci-at91.c"
-#define PLATFORM_DRIVER		ohci_hcd_at91_driver
+#define AT91_PLATFORM_DRIVER	ohci_hcd_at91_driver
 #endif
 
 #ifdef CONFIG_ARCH_LPC32XX
 #include "ohci-nxp.c"
-#define PLATFORM_DRIVER		usb_hcd_nxp_driver
+#define NXP_PLATFORM_DRIVER	usb_hcd_nxp_driver
 #endif
 
 #ifdef CONFIG_ARCH_DAVINCI_DA8XX
 #include "ohci-da8xx.c"
-#define PLATFORM_DRIVER		ohci_hcd_da8xx_driver
+#define DAVINCI_PLATFORM_DRIVER	ohci_hcd_da8xx_driver
 #endif
 
-
 #ifdef CONFIG_USB_OHCI_HCD_PPC_OF
 #include "ohci-ppc-of.c"
 #define OF_PLATFORM_DRIVER	ohci_hcd_ppc_of_driver
@@ -1153,7 +1152,7 @@ MODULE_LICENSE ("GPL");
 
 #ifdef CONFIG_PLAT_SPEAR
 #include "ohci-spear.c"
-#define PLATFORM_DRIVER		spear_ohci_hcd_driver
+#define SPEAR_PLATFORM_DRIVER	spear_ohci_hcd_driver
 #endif
 
 #ifdef CONFIG_PPC_PS3
@@ -1199,7 +1198,14 @@ MODULE_LICENSE ("GPL");
 	!defined(SA1111_DRIVER) &&	\
 	!defined(PS3_SYSTEM_BUS_DRIVER) && \
 	!defined(SM501_OHCI_DRIVER) && \
-	!defined(TMIO_OHCI_DRIVER)
+	!defined(TMIO_OHCI_DRIVER) && \
+	!defined(S3C2410_PLATFORM_DRIVER) && \
+	!defined(EXYNOS_PLATFORM_DRIVER) && \
+	!defined(EP93XX_PLATFORM_DRIVER) && \
+	!defined(AT91_PLATFORM_DRIVER) && \
+	!defined(NXP_PLATFORM_DRIVER) && \
+	!defined(DAVINCI_PLATFORM_DRIVER) && \
+	!defined(SPEAR_PLATFORM_DRIVER)
 #error "missing bus glue for ohci-hcd"
 #endif
 
@@ -1277,9 +1283,79 @@ static int __init ohci_hcd_mod_init(void)
 		goto error_tmio;
 #endif
 
+#ifdef S3C2410_PLATFORM_DRIVER
+	retval = platform_driver_register(&S3C2410_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_s3c2410;
+#endif
+
+#ifdef EXYNOS_PLATFORM_DRIVER
+	retval = platform_driver_register(&EXYNOS_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_exynos;
+#endif
+
+#ifdef EP93XX_PLATFORM_DRIVER
+	retval = platform_driver_register(&EP93XX_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_ep93xx;
+#endif
+
+#ifdef AT91_PLATFORM_DRIVER
+	retval = platform_driver_register(&AT91_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_at91;
+#endif
+
+#ifdef NXP_PLATFORM_DRIVER
+	retval = platform_driver_register(&NXP_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_nxp;
+#endif
+
+#ifdef DAVINCI_PLATFORM_DRIVER
+	retval = platform_driver_register(&DAVINCI_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_davinci;
+#endif
+
+#ifdef SPEAR_PLATFORM_DRIVER
+	retval = platform_driver_register(&SPEAR_PLATFORM_DRIVER);
+	if (retval < 0)
+		goto error_spear;
+#endif
+
 	return retval;
 
 	/* Error path */
+#ifdef SPEAR_PLATFORM_DRIVER
+	platform_driver_unregister(&SPEAR_PLATFORM_DRIVER);
+ error_spear:
+#endif
+#ifdef DAVINCI_PLATFORM_DRIVER
+	platform_driver_unregister(&DAVINCI_PLATFORM_DRIVER);
+ error_davinci:
+#endif
+#ifdef NXP_PLATFORM_DRIVER
+	platform_driver_unregister(&NXP_PLATFORM_DRIVER);
+ error_nxp:
+#endif
+#ifdef AT91_PLATFORM_DRIVER
+	platform_driver_unregister(&AT91_PLATFORM_DRIVER);
+ error_at91:
+#endif
+#ifdef EP93XX_PLATFORM_DRIVER
+	platform_driver_unregister(&EP93XX_PLATFORM_DRIVER);
+ error_ep93xx:
+#endif
+#ifdef EXYNOS_PLATFORM_DRIVER
+	platform_driver_unregister(&EXYNOS_PLATFORM_DRIVER);
+ error_exynos:
+#endif
+#ifdef S3C2410_PLATFORM_DRIVER
+	platform_driver_unregister(&S3C2410_PLATFORM_DRIVER);
+ error_s3c2410:
+#endif
 #ifdef TMIO_OHCI_DRIVER
 	platform_driver_unregister(&TMIO_OHCI_DRIVER);
  error_tmio:
@@ -1300,17 +1376,17 @@ static int __init ohci_hcd_mod_init(void)
 	platform_driver_unregister(&OF_PLATFORM_DRIVER);
  error_of_platform:
 #endif
-#ifdef PLATFORM_DRIVER
-	platform_driver_unregister(&PLATFORM_DRIVER);
- error_platform:
+#ifdef OMAP3_PLATFORM_DRIVER
+	platform_driver_unregister(&OMAP3_PLATFORM_DRIVER);
+ error_omap3_platform:
 #endif
 #ifdef OMAP1_PLATFORM_DRIVER
 	platform_driver_unregister(&OMAP1_PLATFORM_DRIVER);
  error_omap1_platform:
 #endif
-#ifdef OMAP3_PLATFORM_DRIVER
-	platform_driver_unregister(&OMAP3_PLATFORM_DRIVER);
- error_omap3_platform:
+#ifdef PLATFORM_DRIVER
+	platform_driver_unregister(&PLATFORM_DRIVER);
+ error_platform:
 #endif
 #ifdef PS3_SYSTEM_BUS_DRIVER
 	ps3_ohci_driver_unregister(&PS3_SYSTEM_BUS_DRIVER);
@@ -1329,6 +1405,27 @@ module_init(ohci_hcd_mod_init);
 
 static void __exit ohci_hcd_mod_exit(void)
 {
+#ifdef SPEAR_PLATFORM_DRIVER
+	platform_driver_unregister(&SPEAR_PLATFORM_DRIVER);
+#endif
+#ifdef DAVINCI_PLATFORM_DRIVER
+	platform_driver_unregister(&DAVINCI_PLATFORM_DRIVER);
+#endif
+#ifdef NXP_PLATFORM_DRIVER
+	platform_driver_unregister(&NXP_PLATFORM_DRIVER);
+#endif
+#ifdef AT91_PLATFORM_DRIVER
+	platform_driver_unregister(&AT91_PLATFORM_DRIVER);
+#endif
+#ifdef EP93XX_PLATFORM_DRIVER
+	platform_driver_unregister(&EP93XX_PLATFORM_DRIVER);
+#endif
+#ifdef EXYNOS_PLATFORM_DRIVER
+	platform_driver_unregister(&EXYNOS_PLATFORM_DRIVER);
+#endif
+#ifdef S3C2410_PLATFORM_DRIVER
+	platform_driver_unregister(&S3C2410_PLATFORM_DRIVER);
+#endif
 #ifdef TMIO_OHCI_DRIVER
 	platform_driver_unregister(&TMIO_OHCI_DRIVER);
 #endif
@@ -1344,12 +1441,15 @@ static void __exit ohci_hcd_mod_exit(void)
 #ifdef OF_PLATFORM_DRIVER
 	platform_driver_unregister(&OF_PLATFORM_DRIVER);
 #endif
-#ifdef PLATFORM_DRIVER
-	platform_driver_unregister(&PLATFORM_DRIVER);
-#endif
 #ifdef OMAP3_PLATFORM_DRIVER
 	platform_driver_unregister(&OMAP3_PLATFORM_DRIVER);
 #endif
+#ifdef OMAP1_PLATFORM_DRIVER
+	platform_driver_unregister(&OMAP1_PLATFORM_DRIVER);
+#endif
+#ifdef PLATFORM_DRIVER
+	platform_driver_unregister(&PLATFORM_DRIVER);
+#endif
 #ifdef PS3_SYSTEM_BUS_DRIVER
 	ps3_ohci_driver_unregister(&PS3_SYSTEM_BUS_DRIVER);
 #endif
-- 
1.8.1.2

