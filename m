Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbaGJBGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 21:06:07 -0400
Received: from mail-yk0-f201.google.com ([209.85.160.201]:49974 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaGJBF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 21:05:57 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Julius Werner <jwerner@chromium.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-tegra@vger.kernel.org, Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 4/4] xhci: Allow xHCI drivers to be built as separate modules
Date: Wed,  9 Jul 2014 18:05:50 -0700
Message-Id: <1404954350-26343-5-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
References: <1404954350-26343-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of building all of the xHCI code into a single module, separate
it out into the core (xhci-hcd), PCI (xhci-pci, now selected by the new
config option CONFIG_USB_XHCI_PCI), and platform (xhci-plat) drivers.
Also update the PCI/platform drivers with module descriptions/licenses
and have them register their respective drivers in their initcalls.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/usb/host/Kconfig     |  5 +++++
 drivers/usb/host/Makefile    | 10 +++++-----
 drivers/usb/host/xhci-pci.c  |  9 +++++++--
 drivers/usb/host/xhci-plat.c |  9 +++++++--
 drivers/usb/host/xhci.c      | 22 ----------------------
 drivers/usb/host/xhci.h      | 19 -------------------
 6 files changed, 24 insertions(+), 50 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 03314f8..aea6a13 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -26,6 +26,11 @@ config USB_XHCI_HCD
 
 if USB_XHCI_HCD
 
+config USB_XHCI_PCI
+       tristate
+       depends on PCI
+       default y
+
 config USB_XHCI_PLATFORM
 	tristate
 
diff --git a/drivers/usb/host/Makefile b/drivers/usb/host/Makefile
index af89a90..bafba71 100644
--- a/drivers/usb/host/Makefile
+++ b/drivers/usb/host/Makefile
@@ -15,19 +15,19 @@ fhci-$(CONFIG_FHCI_DEBUG) += fhci-dbg.o
 xhci-hcd-y := xhci.o xhci-mem.o
 xhci-hcd-y += xhci-ring.o xhci-hub.o xhci-dbg.o
 xhci-hcd-y += xhci-trace.o
-xhci-hcd-$(CONFIG_PCI)	+= xhci-pci.o
 
-ifneq ($(CONFIG_USB_XHCI_PLATFORM), )
-	xhci-hcd-y		+= xhci-plat.o
+xhci-plat-hcd-y := xhci-plat.o
 ifneq ($(CONFIG_USB_XHCI_MVEBU), )
-	xhci-hcd-y		+= xhci-mvebu.o
-endif
+	xhci-plat-hcd-y		+= xhci-mvebu.o
 endif
 
 obj-$(CONFIG_USB_WHCI_HCD)	+= whci/
 
 obj-$(CONFIG_PCI)		+= pci-quirks.o
 
+obj-$(CONFIG_USB_XHCI_PCI)	+= xhci-pci.o
+obj-$(CONFIG_USB_XHCI_PLATFORM) += xhci-plat-hcd.o
+
 obj-$(CONFIG_USB_EHCI_HCD)	+= ehci-hcd.o
 obj-$(CONFIG_USB_EHCI_PCI)	+= ehci-pci.o
 obj-$(CONFIG_USB_EHCI_HCD_PLATFORM)	+= ehci-platform.o
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index d06ffe7..fbfd4a7 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -344,7 +344,7 @@ static struct pci_driver xhci_pci_driver = {
 #endif
 };
 
-int __init xhci_register_pci(void)
+static int __init xhci_pci_init(void)
 {
 	xhci_init_driver(&xhci_pci_hc_driver, xhci_pci_setup);
 #ifdef CONFIG_PM
@@ -353,8 +353,13 @@ int __init xhci_register_pci(void)
 #endif
 	return pci_register_driver(&xhci_pci_driver);
 }
+module_init(xhci_pci_init);
 
-void xhci_unregister_pci(void)
+static void __exit xhci_pci_exit(void)
 {
 	pci_unregister_driver(&xhci_pci_driver);
 }
+module_exit(xhci_pci_exit);
+
+MODULE_DESCRIPTION("xHCI PCI Host Controller Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index 49799db..c324408 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -233,13 +233,18 @@ static struct platform_driver usb_xhci_driver = {
 };
 MODULE_ALIAS("platform:xhci-hcd");
 
-int xhci_register_plat(void)
+static int __init xhci_plat_init(void)
 {
 	xhci_init_driver(&xhci_plat_hc_driver, xhci_plat_setup);
 	return platform_driver_register(&usb_xhci_driver);
 }
+module_init(xhci_plat_init);
 
-void xhci_unregister_plat(void)
+static void __exit xhci_plat_exit(void)
 {
 	platform_driver_unregister(&usb_xhci_driver);
 }
+module_exit(xhci_plat_exit);
+
+MODULE_DESCRIPTION("xHCI Platform Host Controller Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 4958a60..3f32b5a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -4951,18 +4951,6 @@ MODULE_LICENSE("GPL");
 
 static int __init xhci_hcd_init(void)
 {
-	int retval;
-
-	retval = xhci_register_pci();
-	if (retval < 0) {
-		pr_debug("Problem registering PCI driver.\n");
-		return retval;
-	}
-	retval = xhci_register_plat();
-	if (retval < 0) {
-		pr_debug("Problem registering platform driver.\n");
-		goto unreg_pci;
-	}
 	/*
 	 * Check the compiler generated sizes of structures that must be laid
 	 * out in specific ways for hardware access.
@@ -4981,15 +4969,5 @@ static int __init xhci_hcd_init(void)
 	/* xhci_run_regs has eight fields and embeds 128 xhci_intr_regs */
 	BUILD_BUG_ON(sizeof(struct xhci_run_regs) != (8+8*128)*32/8);
 	return 0;
-unreg_pci:
-	xhci_unregister_pci();
-	return retval;
 }
 module_init(xhci_hcd_init);
-
-static void __exit xhci_hcd_cleanup(void)
-{
-	xhci_unregister_pci();
-	xhci_unregister_plat();
-}
-module_exit(xhci_hcd_cleanup);
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 902f55b..ac03d22 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1729,25 +1729,6 @@ void xhci_urb_free_priv(struct xhci_hcd *xhci, struct urb_priv *urb_priv);
 void xhci_free_command(struct xhci_hcd *xhci,
 		struct xhci_command *command);
 
-#ifdef CONFIG_PCI
-/* xHCI PCI glue */
-int xhci_register_pci(void);
-void xhci_unregister_pci(void);
-#else
-static inline int xhci_register_pci(void) { return 0; }
-static inline void xhci_unregister_pci(void) {}
-#endif
-
-#if IS_ENABLED(CONFIG_USB_XHCI_PLATFORM)
-int xhci_register_plat(void);
-void xhci_unregister_plat(void);
-#else
-static inline int xhci_register_plat(void)
-{ return 0; }
-static inline void xhci_unregister_plat(void)
-{  }
-#endif
-
 /* xHCI host controller glue */
 typedef void (*xhci_get_quirks_t)(struct device *, struct xhci_hcd *);
 int xhci_handshake(struct xhci_hcd *xhci, void __iomem *ptr,
-- 
2.0.0.526.g5318336

