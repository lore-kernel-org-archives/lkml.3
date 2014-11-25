Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaKYMDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:03:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaKYKk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bogdan Mihalcea <bogdan.mihalcea@infim.ro>,
        Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 019/254] xhci: Disable streams on Asmedia 1042 xhci controllers
Date: Tue, 25 Nov 2014 10:36:09 +0000
Message-Id: <1416912004-5928-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2391eacbd00b706ff4902db7dbee21e33b6f1850 upstream.

Streams seem to be broken on the Asmedia 1042. An uas capable Seagate disk
which is known to work fine with other controllers causes the system to freeze
when connected over usb-3 with this controller, where as it works fine with
uas in usb-2 ports, indicating a problem with streams.

This is a bit bigger hammer then I would like to use for this, but for now it
will have to make do. I've ordered a pci-e usb controller card with an Asmedia
1042, once that arrives I'll try to get streams to work (with a quirk flag if
necessary) and then we can re-enable them. For now this at least makes uas
capable disk enclosures work again by forcing fallback to the usb-storage
driver.

Reported-by: Bogdan Mihalcea <bogdan.mihalcea@infim.ro>
Cc: Bogdan Mihalcea <bogdan.mihalcea@infim.ro>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 994a36e582ca..ea14b663c8b2 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -160,6 +160,10 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 			pdev->device == 0x3432)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+			pdev->device == 0x1042)
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");
-- 
2.1.0

