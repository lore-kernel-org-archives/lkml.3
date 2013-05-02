Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716Ab3EBPSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:18:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:51145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932558Ab3EBPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH, RFC 16/22] USB: UHCI: clarify Kconfig dependencies
Date: Thu,  2 May 2013 17:16:20 +0200
Message-Id: <1367507786-505303-17-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:t9mgKZk4YKDZl4xLlFn1WRb6uHzm2ot3INHU6owzn4Q
 8P37pNW3O1jlI6P1OEGjWzGod3JI9luvtzbvmoMXgsrffdeUvd
 gNjB5OmjGaPd/Kyofd+WI6rogcIar8T6NVkL+Uwro0GnSlsygL
 UtVPvNH3259OqAD5YkpLcSqPhHCpyOEdxBVUgMZfqP6SQrJJSr
 nJamNt4F40OZy0P3wKRqA9nvmnHXhIFpeLfqBsg5AozpIN1zvb
 8M2av6E84BPuyDok9u8vuX/jfIcsBBK01EYqFue0+mT8fOm5AC
 oN0k5qaar9j4t8rQVKe8seCIJ9jlzd7p8j2WvpGWrZOrheLDFj
 lDUUeAKFy3ip/AFXNc+WaFFLetoa5vPbnSCf45JwB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The UHCI driver currently gives a build error if the base driver is
enabled but none of the three bus glues are turned on:

drivers/usb/host/uhci-hcd.c:857:2: error: #error "missing bus glue for uhci-hcd"

A better solution for this is to change the Kconfig statements to
prevent getting into this situation. This adds a new USB_UHCI_CORE
symbol in Kconfig, which is selected by each of the three bus glues.
This way, the driver never gets built if all three of them are disabled.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/usb/host/Kconfig    | 36 +++++++++++++++++++++++++++---------
 drivers/usb/host/Makefile   |  2 +-
 drivers/usb/host/uhci-hcd.c |  4 ++--
 3 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 7b176bc..656af4d 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -525,28 +525,46 @@ config USB_UHCI_HCD
 	  To compile this driver as a module, choose M here: the
 	  module will be called uhci-hcd.
 
-config USB_UHCI_SUPPORT_NON_PCI_HC
-	bool
-	depends on USB_UHCI_HCD
-	default y if (SPARC_LEON || ARCH_VT8500)
+if USB_UHCI_HCD
+
+config USB_UHCI_PCI
+	tristate
+	default USB_UHCI_HCD
+	depends on PCI
+	select USB_UHCI_CORE
+
+config USB_UHCI_GRLIB
+	tristate
+	default USB_UHCI_HCD
+	depends on SPARC_LEON
+	select USB_UHCI_CORE
+	select USB_UHCI_SUPPORT_NON_PCI_HC
+	select USB_UHCI_BIG_ENDIAN_MMIO
+	select USB_UHCI_BIG_ENDIAN_DESC
 
 config USB_UHCI_PLATFORM
 	bool "Generic UHCI Platform Driver support"
-	depends on USB_UHCI_SUPPORT_NON_PCI_HC
 	default y if ARCH_VT8500
+	select USB_UHCI_SUPPORT_NON_PCI_HC
+	select USB_UHCI_CORE
 	---help---
 	  Enable support for generic UHCI platform devices that require no
 	  additional configuration.
 
+config USB_UHCI_CORE
+	tristate
+	depends on USB_UHCI_HCD
+
+config USB_UHCI_SUPPORT_NON_PCI_HC
+	bool
+
 config USB_UHCI_BIG_ENDIAN_MMIO
 	bool
-	depends on USB_UHCI_SUPPORT_NON_PCI_HC && SPARC_LEON
-	default y
 
 config USB_UHCI_BIG_ENDIAN_DESC
 	bool
-	depends on USB_UHCI_SUPPORT_NON_PCI_HC && SPARC_LEON
-	default y
+
+endif
 
 config USB_FHCI_HCD
 	tristate "Freescale QE USB Host Controller support"
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index 4fb73c1..1441d42 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -38,7 +38,7 @@ obj-$(CONFIG_USB_OXU210HP_HCD)	+= oxu210hp-hcd.o
 obj-$(CONFIG_USB_ISP116X_HCD)	+= isp116x-hcd.o
 obj-$(CONFIG_USB_ISP1362_HCD)	+= isp1362-hcd.o
 obj-$(CONFIG_USB_OHCI_HCD)	+= ohci-hcd.o
-obj-$(CONFIG_USB_UHCI_HCD)	+= uhci-hcd.o
+obj-$(CONFIG_USB_UHCI_CORE)	+= uhci-hcd.o
 obj-$(CONFIG_USB_FHCI_HCD)	+= fhci.o
 obj-$(CONFIG_USB_XHCI_HCD)	+= xhci-hcd.o
 obj-$(CONFIG_USB_SL811_HCD)	+= sl811-hcd.o
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 4a86b63..612b792 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -838,12 +838,12 @@ static int uhci_count_ports(struct usb_hcd *hcd)
 
 static const char hcd_name[] = "uhci_hcd";
 
-#ifdef CONFIG_PCI
+#ifdef CONFIG_USB_UHCI_PCI
 #include "uhci-pci.c"
 #define	PCI_DRIVER		uhci_pci_driver
 #endif
 
-#ifdef CONFIG_SPARC_LEON
+#ifdef CONFIG_USB_UHCI_GRLIB
 #include "uhci-grlib.c"
 #define PLATFORM_DRIVER		uhci_grlib_driver
 #endif
-- 
1.8.1.2

