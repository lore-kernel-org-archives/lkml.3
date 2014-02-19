Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbaBSKN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:13:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaBSKN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:56 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] xhci: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:28 +0100
Message-Id: <1392804931-30671-8-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

This update also cleans up a bit xhci_setup_msi() and
xhci_setup_msix() returning of success.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/usb/host/xhci.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6fe577d..1755d18 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -232,9 +232,10 @@ static int xhci_setup_msi(struct xhci_hcd *xhci)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 				"disable MSI interrupt");
 		pci_disable_msi(pdev);
+		return ret;
 	}
 
-	return ret;
+	return 0;
 }
 
 /*
@@ -291,8 +292,9 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 		xhci->msix_entries[i].vector = 0;
 	}
 
-	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
-	if (ret) {
+	ret = pci_enable_msix_range(pdev, xhci->msix_entries,
+				    xhci->msix_count, xhci->msix_count);
+	if (ret < 0) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 				"Failed to enable MSI-X");
 		goto free_entries;
@@ -307,7 +309,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 	}
 
 	hcd->msix_enabled = 1;
-	return ret;
+	return 0;
 
 disable_msix:
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "disable MSI-X interrupt");
-- 
1.7.7.6

