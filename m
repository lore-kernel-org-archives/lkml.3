Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab3FDOsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:48:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59989 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3FDOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:48:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH, RFC 2/2] USB: host: make USB_ARCH_HAS_?HCI obsolete
Date: Tue, 04 Jun 2013 16:48:16 +0200
Message-ID: <1810803.LEeYoES7nl@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1733192.k73fhLUdvU@wuerfel>
References: <1733192.k73fhLUdvU@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:d610BaE1HuiB/KABK9Xh81g1EnNhZoC6HDRFR6I9vUk
 O5iIZ7TmxaJVBUYBI01P4Mizw8OD3XfnDk25n0pRpe3Jnq8HlL
 Ds9UPHQ9expoL+WqwvYEhyWtKcUDhnWynlLLJJqtbozu34XoAN
 I2USkoATmnqh/k1G069c0/zXFrs0mFlFLzDS4JOy7MOPf0s5AO
 0NH/hkK8D3bAHX2SFdZWlOGWyKK9GnE/gC6uQcvZACgEw1o9YH
 ZebiH8rchaeenoUfv/UAfu1sJVnWy90azwcxOV31j3XnJmdeNr
 Ivhj0QrwTMojNMdFm03m1iQyl6lW65pvCXmCM8e24tN+LKuWLO
 B1OaKKwWQYM0OalJ/frQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three options USB_ARCH_HAS_{EHCI,OHCI,XHCI} are all well beyond
their recommended shelf life. They have caused numerous build failures
over the years because they are never completely correct, and with
the move to splitting out the platform specific back-ends out of the
driver, there is no real need for them any more. Also, the use of making
USB_ARCH_HAS_HCD depend on it is questionable since one can always enable
dummy_hc these days.

This patch enables them unconditionally for all platforms and
architectures, which means it is now possible to build host controller
drivers for machines that are known not to come with this hardware,
but that is just how we treat most other drivers.

In order to minimise the impact on existing architecture code and
defconfig files, all the Kconfig are left present for now. All platforms
that currently do 'select USB_ARCH_HAS_*' should subsequently be changed
not to select that. All drivers depending on USB_ARCH_HAS_HCD should
be changed to depend on USB_SUPPORT instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 92e1dc9..654cd81 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -2,59 +2,15 @@
 # USB device configuration
 #
 
-# many non-PCI SOC chips embed OHCI
+# These are unused now, remove them once they are no longer selected
 config USB_ARCH_HAS_OHCI
-	boolean
-	# ARM:
-	default y if SA1111
-	default y if ARCH_OMAP
-	default y if ARCH_S3C24XX
-	default y if PXA27x
-	default y if PXA3xx
-	default y if ARCH_EP93XX
-	default y if ARCH_AT91
-	default y if MFD_TC6393XB
-	default y if ARCH_W90X900
-	default y if ARCH_DAVINCI_DA8XX
-	default y if ARCH_CNS3XXX
-	default y if PLAT_SPEAR
-	default y if ARCH_EXYNOS
-	# PPC:
-	default y if STB03xxx
-	default y if PPC_MPC52xx
-	# MIPS:
-	default y if MIPS_ALCHEMY
-	default y if MACH_JZ4740
-	# more:
-	default PCI
-
-# some non-PCI hcds implement EHCI
+	def_bool HAS_IOMEM
+
 config USB_ARCH_HAS_EHCI
-	boolean
-	default y if FSL_SOC
-	default y if PPC_MPC512x
-	default y if ARCH_IXP4XX
-	default y if ARCH_W90X900
-	default y if ARCH_AT91
-	default y if ARCH_MXC
-	default y if ARCH_MXS
-	default y if ARCH_OMAP3
-	default y if ARCH_CNS3XXX
-	default y if ARCH_VT8500
-	default y if PLAT_SPEAR
-	default y if PLAT_S5P
-	default y if ARCH_MSM
-	default y if MICROBLAZE
-	default y if SPARC_LEON
-	default y if ARCH_MMP
-	default y if MACH_LOONGSON1
-	default y if PLAT_ORION
-	default PCI
-
-# some non-PCI HCDs implement xHCI
+	def_bool HAS_IOMEM
+
 config USB_ARCH_HAS_XHCI
-	boolean
-	default PCI
+	def_bool HAS_IOMEM
 
 menuconfig USB_SUPPORT
 	bool "USB support"
@@ -71,19 +27,8 @@ config USB_COMMON
 	default y
 	depends on USB || USB_GADGET
 
-# Host-side USB depends on having a host controller
-# NOTE:  dummy_hcd is always an option, but it's ignored here ...
-# NOTE:  SL-811 option should be board-specific ...
 config USB_ARCH_HAS_HCD
-	boolean
-	default y if USB_ARCH_HAS_OHCI
-	default y if USB_ARCH_HAS_EHCI
-	default y if USB_ARCH_HAS_XHCI
-	default y if PCMCIA && !M32R			# sl811_cs
-	default y if ARM				# SL-811
-	default y if BLACKFIN				# SL-811
-	default y if SUPERH				# r8a66597-hcd
-	default PCI
+	def_bool HAS_IOMEM
 
 # ARM SA1111 chips have a non-PCI based "OHCI-compatible" USB host interface.
 config USB
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index e060ecf..045f9d27 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -17,7 +17,7 @@ config USB_C67X00_HCD
 
 config USB_XHCI_HCD
 	tristate "xHCI HCD (USB 3.0) support"
-	depends on USB_ARCH_HAS_XHCI
+	depends on PCI
 	---help---
 	  The eXtensible Host Controller Interface (xHCI) is standard for USB 3.0
 	  "SuperSpeed" host controller hardware.
@@ -43,7 +43,6 @@ endif # USB_XHCI_HCD
 
 config USB_EHCI_HCD
 	tristate "EHCI HCD (USB 2.0) support"
-	depends on USB_ARCH_HAS_EHCI
 	---help---
 	  The Enhanced Host Controller Interface (EHCI) is standard for USB 2.0
 	  "high speed" (480 Mbit/sec, 60 Mbyte/sec) host controller hardware.
@@ -361,7 +360,6 @@ config USB_FUSBH200_HCD
 
 config USB_OHCI_HCD
 	tristate "OHCI HCD (USB 1.1) support"
-	depends on USB_ARCH_HAS_OHCI
 	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
 	depends on USB_ISP1301 || !ARCH_LPC32XX
 	---help---

