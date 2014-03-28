Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaC1RwG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:52:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaC1Ras (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:30:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 3.10 20/22] xhci: Fix resume issues on Renesas chips in Samsung laptops
Date: Fri, 28 Mar 2014 10:32:12 -0700
Message-Id: <20140328173112.142157710@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173109.378288825@linuxfoundation.org>
References: <20140328173109.378288825@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 1aa9578c1a9450fb21501c4f549f5b1edb557e6d upstream.

Don Zickus <dzickus@redhat.com> writes:

Some co-workers of mine bought Samsung laptops that had mostly usb3 ports.
Those ports did not resume correctly (the driver would timeout communicating
and fail).  This led to frustration as suspend/resume is a common use for
laptops.

Poking around, I applied the reset on resume quirk to this chipset and the
resume started working.  Reloading the xhci_hcd module had been the temporary
workaround.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reported-by: Don Zickus <dzickus@redhat.com>
Tested-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -113,6 +113,11 @@ static void xhci_pci_quirks(struct devic
 		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
 		xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_RENESAS &&
+			pdev->device == 0x0015 &&
+			pdev->subsystem_vendor == PCI_VENDOR_ID_SAMSUNG &&
+			pdev->subsystem_device == 0xc0cd)
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
 	if (pdev->vendor == PCI_VENDOR_ID_VIA)
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
 }


