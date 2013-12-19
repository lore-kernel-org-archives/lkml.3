Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab3LSRHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:07:38 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:50343 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab3LSRHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:07:36 -0500
Message-ID: <52B327D5.3080805@compulab.co.il>
Date: Thu, 19 Dec 2013 19:07:33 +0200
From: Denis Turischev <denis.turischev@compulab.co.il>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on shutdown
References: <52B31EDA.60908@compulab.co.il>
In-Reply-To: <52B31EDA.60908@compulab.co.il>
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

v1: add new device id locally, not in <linux/pci_ids.h>

Signed-off-by: Denis Turischev <denis@compulab.co.il>

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
--- a/drivers/usb/host/xhci-pci.c	2013-12-19 11:36:12.049589400 +0200
+++ b/drivers/usb/host/xhci-pci.c	2013-12-19 11:37:27.261590385 +0200
@@ -34,6 +34,8 @@
 #define PCI_VENDOR_ID_ETRON		0x1b6f
 #define PCI_DEVICE_ID_ASROCK_P67	0x7023

+#define PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI	0x9c31
+
 static const char hcd_name[] = "xhci_hcd";

 /* called after powerup, by probe or system-pm "wakeup" */
@@ -91,8 +93,9 @@
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
