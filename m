Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaI2MzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:55:14 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:57768 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaI2MzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:55:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Griffin <peter.griffin@linaro.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] USB: host: st: fix ehci/ohci driver selection
Date: Mon, 29 Sep 2014 14:54:34 +0200
Message-ID: <2536929.C0XC0THfdJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4NkklfXWw+3oAmX7ZSFqoxlKSV4+Ic9DWlnl+wntcB8
 M9O3BinzPtH+ZClkZZxpAsUjXor0TcH6MRMwXgkD7dubFe/1Q+
 cXKDDX3+sz9JzDCQJRIUKhVOwGp2f2H0GiHXVDb9iKNqc8c8Gx
 mVqq1T5+nVv9ygabNeUKJV1AvXMlxkP6ifnGlj20oPI/9bV755
 1OaphNjX2scnRodmChqjKtgLBDRiNMlZehE8q/KsjnepTkPacw
 jF/WnKTqg8WuN5Wb91E1wbxTf5iVc67XAo6b3DqzDVj90OWR/c
 DtnrDBjHIgFaJRx9o0y1TlaspWMDtsEuqBDgA/qOcD9iOxF0ej
 APu+1uYlWT4yEGVFSxyg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The newly added sti ehci and ohci drivers come with a single
Kconfig entry that does not depend on either of the base drivers,
which leads to a link error when they are disabled:

drivers/built-in.o: In function `ohci_platform_init':
:(.init.text+0x14788): undefined reference to `ohci_init_driver'

To fix that, this patch introduces two separate Kconfig options
with proper dependencies, which avoids the problem and is also
more consistent with the other glue drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: d115837259ada ("usb: host: ohci-st: Add OHCI driver support for ST STB devices")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peter Griffin <peter.griffin@linaro.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index b943545f862c..002ba1d5bcf5 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -174,6 +174,15 @@ config USB_EHCI_HCD_SPEAR
           Enables support for the on-chip EHCI controller on
           ST SPEAr chips.
 
+config USB_EHCI_HCD_STI
+	tristate "Support for ST STiHxxx on-chip EHCI USB controller"
+	depends on ARCH_STI && OF
+	select GENERIC_PHY
+	select USB_EHCI_HCD_PLATFORM
+	help
+	  Enable support for the on-chip EHCI controller found on
+	  STMicroelectronics consumer electronics SoC's.
+
 config USB_EHCI_HCD_AT91
         tristate  "Support for Atmel on-chip EHCI USB controller"
         depends on USB_EHCI_HCD && ARCH_AT91
@@ -402,6 +411,15 @@ config USB_OHCI_HCD_SPEAR
           Enables support for the on-chip OHCI controller on
           ST SPEAr chips.
 
+config USB_OHCI_HCD_STI
+	tristate "Support for ST STiHxxx on-chip OHCI USB controller"
+	depends on ARCH_STI && OF
+	select GENERIC_PHY
+	select USB_OHCI_HCD_PLATFORM
+	help
+	  Enable support for the on-chip OHCI controller found on
+	  STMicroelectronics consumer electronics SoC's.
+
 config USB_OHCI_HCD_S3C2410
         tristate "OHCI support for Samsung S3C24xx/S3C64xx SoC series"
         depends on USB_OHCI_HCD && (ARCH_S3C24XX || ARCH_S3C64XX)
@@ -761,14 +779,6 @@ config USB_HCD_SSB
 
 	  If unsure, say N.
 
-config USB_HCD_ST
-	tristate "ST USB driver for ST SoC Series"
-	depends on ARCH_STI && OF
-	select GENERIC_PHY
-	help
-	  Enable support for the on-chip OHCI & EHCI controller found on
-	  STMicroelectronics consumer electronics SoC's.
-
 config USB_HCD_TEST_MODE
 	bool "HCD test mode support"
 	---help---
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index ae2db0b87993..0336bb2c0e6f 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_USB_EHCI_MXC)	+= ehci-mxc.o
 obj-$(CONFIG_USB_EHCI_HCD_OMAP)	+= ehci-omap.o
 obj-$(CONFIG_USB_EHCI_HCD_ORION)	+= ehci-orion.o
 obj-$(CONFIG_USB_EHCI_HCD_SPEAR)	+= ehci-spear.o
+obj-$(CONFIG_USB_EHCI_HCD_ST)	+= ehci-st.o
 obj-$(CONFIG_USB_EHCI_EXYNOS)	+= ehci-exynos.o
 obj-$(CONFIG_USB_EHCI_HCD_AT91) += ehci-atmel.o
 obj-$(CONFIG_USB_EHCI_MSM)	+= ehci-msm.o
@@ -55,6 +56,7 @@ obj-$(CONFIG_USB_OHCI_EXYNOS)	+= ohci-exynos.o
 obj-$(CONFIG_USB_OHCI_HCD_OMAP1)	+= ohci-omap.o
 obj-$(CONFIG_USB_OHCI_HCD_OMAP3)	+= ohci-omap3.o
 obj-$(CONFIG_USB_OHCI_HCD_SPEAR)	+= ohci-spear.o
+obj-$(CONFIG_USB_OHCI_HCD_STI)	+= ohci-st.o
 obj-$(CONFIG_USB_OHCI_HCD_AT91)	+= ohci-at91.o
 obj-$(CONFIG_USB_OHCI_HCD_S3C2410)	+= ohci-s3c2410.o
 obj-$(CONFIG_USB_OHCI_HCD_LPC32XX)	+= ohci-nxp.o
@@ -77,4 +79,3 @@ obj-$(CONFIG_USB_HCD_SSB)	+= ssb-hcd.o
 obj-$(CONFIG_USB_FUSBH200_HCD)	+= fusbh200-hcd.o
 obj-$(CONFIG_USB_FOTG210_HCD)	+= fotg210-hcd.o
 obj-$(CONFIG_USB_MAX3421_HCD)	+= max3421-hcd.o
-obj-$(CONFIG_USB_HCD_ST)	+= ehci-st.o ohci-st.o

