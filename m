Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932806AbaBUQZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:25:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbaBUQZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:25:54 -0500
Date: Fri, 21 Feb 2014 17:27:50 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2] xhci: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140221162749.GE17353@dhcp-26-207.brq.redhat.com>
References: <1392804931-30671-8-git-send-email-agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392804931-30671-8-git-send-email-agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

This update also cleans up a bit xhci_setup_msi() and
xhci_setup_msix() returning of success.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/usb/host/xhci.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6fe577d..dc7cfb5 100644
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
@@ -291,7 +292,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 		xhci->msix_entries[i].vector = 0;
 	}
 
-	ret = pci_enable_msix(pdev, xhci->msix_entries, xhci->msix_count);
+	ret = pci_enable_msix_exact(pdev, xhci->msix_entries, xhci->msix_count);
 	if (ret) {
 		xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 				"Failed to enable MSI-X");
@@ -307,7 +308,7 @@ static int xhci_setup_msix(struct xhci_hcd *xhci)
 	}
 
 	hcd->msix_enabled = 1;
-	return ret;
+	return 0;
 
 disable_msix:
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init, "disable MSI-X interrupt");
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
