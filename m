Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbaEHNyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:54:47 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62729 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaEHNwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:52:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, linux-omap@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 7/8] usb: ohci: sort out dependencies for lpc32xx and omap
Date: Thu,  8 May 2014 15:52:20 +0200
Message-Id: <1399557141-1346645-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rac/O/G2cRq4pHr6b+uvhzWFwc3e06e/vpilKBCAtmg
 aK0ZVpRua89xT7qSbwkD+UI2AQIrwmmoK8ri3UBjtoApfg5qSZ
 izk0YUKLdQzB6EsK25svIfgX02LSCaM9kdaJNZdKtmZLxcrsvx
 UM1ABW5wxIoYP02q1CkbRqKcJjcl46ekK6X6EACi6VeI9TYWUN
 YyUzvxAJoANgug2JxMg17vKyGsGMpMB74dLRGBiJXTM0M8UdKK
 rwNaWQL3Sd+XtDtcTIHlhXrm5dEmacczuZqS318LNtK1JWwMRw
 3iAfO/Z2Gk4lMd+1sfi/3Vp7Sfv+2CKrk5tw0vYjBAFc671FIj
 h9ErBiNHI9zlLvfYbTcCVbzaoq/QIvodbhrA/7+6t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dependency on the isp1301 driver is not something that
should be in the main OHCI driver but rather the SoC specific
part of it.

This moves the dependency for LPC32xx into USB_OHCI_HCD_LPC32XX,
and changes the 'select ISP1301_OMAP' to a similar 'depends on'.
Since the same dependency exists for the client driver, do the
same change there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/gadget/Kconfig | 4 ++--
 drivers/usb/host/Kconfig   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 7fca52b..ba18e9c 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -157,7 +157,7 @@ config USB_AT91
 
 config USB_LPC32XX
 	tristate "LPC32XX USB Peripheral Controller"
-	depends on ARCH_LPC32XX
+	depends on ARCH_LPC32XX && I2C
 	select USB_ISP1301
 	help
 	   This option selects the USB device controller in the LPC32xx SoC.
@@ -226,7 +226,7 @@ config USB_GR_UDC
 config USB_OMAP
 	tristate "OMAP USB Device Controller"
 	depends on ARCH_OMAP1
-	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
+	depends on ISP1301_OMAP || !(MACH_OMAP_H2 || MACH_OMAP_H3)
 	help
 	   Many Texas Instruments OMAP processors have flexible full
 	   speed USB device controllers, with support for up to 30
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 890fc8c..e229a47 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -345,8 +345,6 @@ config USB_FOTG210_HCD
 
 config USB_OHCI_HCD
 	tristate "OHCI HCD (USB 1.1) support"
-	select ISP1301_OMAP if MACH_OMAP_H2 || MACH_OMAP_H3
-	depends on USB_ISP1301 || !ARCH_LPC32XX
 	---help---
 	  The Open Host Controller Interface (OHCI) is a standard for accessing
 	  USB 1.1 host controller hardware.  It does more in hardware than Intel's
@@ -365,6 +363,7 @@ if USB_OHCI_HCD
 config USB_OHCI_HCD_OMAP1
 	tristate "OHCI support for OMAP1/2 chips"
 	depends on ARCH_OMAP1
+	depends on ISP1301_OMAP || !(MACH_OMAP_H2 || MACH_OMAP_H3)
 	default y
 	---help---
 	  Enables support for the OHCI controller on OMAP1/2 chips.
@@ -388,6 +387,7 @@ config USB_OHCI_HCD_S3C2410
 config USB_OHCI_HCD_LPC32XX
 	tristate "Support for LPC on-chip OHCI USB controller"
 	depends on USB_OHCI_HCD && ARCH_LPC32XX
+	depends on USB_ISP1301
 	default y
 	---help---
           Enables support for the on-chip OHCI controller on
-- 
1.8.3.2

