Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab3LSQ3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:29:19 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:38103 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab3LSQ3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:29:17 -0500
Message-ID: <52B31EDA.60908@compulab.co.il>
Date: Thu, 19 Dec 2013 18:29:14 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: xhci: Switch Intel Lynx Point ports to EHCI on shutdown
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: -unknown-@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same issue like with Panther Point chipsets. If the USB ports are
switched to xHCI on shutdown, the xHCI host will send a spurious interrupt,
which will wake the system. Some BIOS have work around for this, but not all.

The bug can be avoided if the USB ports are switched back to EHCI on
shutdown.

Signed-off-by: Denis Turischev <denis@compulab.co.il>

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
--- a/drivers/usb/host/xhci-pci.c	2013-12-19 11:36:12.049589400 +0200
+++ b/drivers/usb/host/xhci-pci.c	2013-12-19 11:37:27.261590385 +0200
@@ -91,8 +91,9 @@
 		xhci->quirks |= XHCI_LPM_SUPPORT;
 		xhci->quirks |= XHCI_INTEL_HOST;
 	}
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-			pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
+	if (pdev->vendor == PCI_VENDOR_ID_INTEL && (
+			(pdev->device == PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) ||
+			(pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI))) {
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
 		xhci->quirks |= XHCI_SW_BW_CHECKING;
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h	2013-12-19 11:36:11.945589398 +0200
+++ b/include/linux/pci_ids.h	2013-12-19 11:35:57.817589213 +0200
@@ -2576,6 +2576,7 @@
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x9c31
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI	0x1e31
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN	0x1e40
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX	0x1e5f
