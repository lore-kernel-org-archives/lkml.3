Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968350Ab3HJBRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 21:17:54 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:44100 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968318Ab3HJBRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 21:17:53 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] usb: Move definition of USB_EHCI_BIG_ENDIAN_MMIO et al. out side of the ifs.
Date: Fri,  9 Aug 2013 18:17:48 -0700
Message-Id: <1376097468-8531-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

When CONFIG_USB_SUPPORT is not selected we get things like:

scripts/kconfig/mconf Kconfig
warning: (MIPS_SEAD3 && PMC_MSP && CPU_CAVIUM_OCTEON) selects USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies (USB_SUPPORT && USB)

It is much cleaner to make the various system Kconfigs select
USB_EHCI_BIG_ENDIAN_MMIO rather than move the system config
information into USB's Kconfig, but the warnings are annoying.

Eliminate the warning by moving the definition of
USB_EHCI_BIG_ENDIAN_MMIO outside of all the Kconfig if statements.
While we are at it move USB_OHCI_BIG_ENDIAN_DESC,
USB_OHCI_BIG_ENDIAN_MMIO, USB_OHCI_LITTLE_ENDIAN and
USB_EHCI_BIG_ENDIAN_DESC too, as they could very well suffer similar
problems for other systems.

Get rid of the redundant "default n" in USB_OHCI_BIG_ENDIAN_DESC and
USB_OHCI_BIG_ENDIAN_MMIO

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
---

Change from v1: Added USB_OHCI_BIG_ENDIAN_DESC,
USB_OHCI_BIG_ENDIAN_MMIO, USB_OHCI_LITTLE_ENDIAN and
USB_EHCI_BIG_ENDIAN_DESC to the set of symbols moved.

 drivers/usb/Kconfig      | 17 +++++++++++++++++
 drivers/usb/host/Kconfig | 20 --------------------
 2 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 73f62ca..2642b8a 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -6,9 +6,26 @@
 config USB_ARCH_HAS_OHCI
 	bool
 
+config USB_OHCI_BIG_ENDIAN_DESC
+	bool
+
+config USB_OHCI_BIG_ENDIAN_MMIO
+	bool
+
+config USB_OHCI_LITTLE_ENDIAN
+	bool
+	default n if STB03xxx || PPC_MPC52xx
+	default y
+
 config USB_ARCH_HAS_EHCI
 	bool
 
+config USB_EHCI_BIG_ENDIAN_MMIO
+	bool
+
+config USB_EHCI_BIG_ENDIAN_DESC
+	bool
+
 config USB_ARCH_HAS_XHCI
 	bool
 
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index 8e8e694..e3ea970 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -113,12 +113,6 @@ config USB_EHCI_HCD_PMC_MSP
 		Enables support for the onchip USB controller on the PMC_MSP7100 Family SoC's.
 		If unsure, say N.
 
-config USB_EHCI_BIG_ENDIAN_MMIO
-	bool
-
-config USB_EHCI_BIG_ENDIAN_DESC
-	bool
-
 config XPS_USB_HCD_XILINX
 	bool "Use Xilinx usb host EHCI controller core"
 	depends on (PPC32 || MICROBLAZE)
@@ -506,20 +500,6 @@ config USB_OCTEON_OHCI
 	  controller.  It is needed for low-speed USB 1.0 device
 	  support.  All CN6XXX based chips with USB are supported.
 
-
-config USB_OHCI_BIG_ENDIAN_DESC
-	bool
-	default n
-
-config USB_OHCI_BIG_ENDIAN_MMIO
-	bool
-	default n
-
-config USB_OHCI_LITTLE_ENDIAN
-	bool
-	default n if STB03xxx || PPC_MPC52xx
-	default y
-
 endif # USB_OHCI_HCD
 
 config USB_UHCI_HCD
-- 
1.7.11.7

