Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaKLBdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:33:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbaKLBdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:33:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bogdan Mihalcea <bogdan.mihalcea@infim.ro>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 3.17 248/319] xhci: Disable streams on Asmedia 1042 xhci controllers
Date: Wed, 12 Nov 2014 10:16:26 +0900
Message-Id: <20141112011033.838780946@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-pci.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -146,6 +146,10 @@ static void xhci_pci_quirks(struct devic
 			pdev->device == 0x3432)
 		xhci->quirks |= XHCI_BROKEN_STREAMS;
 
+	if (pdev->vendor == PCI_VENDOR_ID_ASMEDIA &&
+			pdev->device == 0x1042)
+		xhci->quirks |= XHCI_BROKEN_STREAMS;
+
 	if (xhci->quirks & XHCI_RESET_ON_RESUME)
 		xhci_dbg_trace(xhci, trace_xhci_dbg_quirks,
 				"QUIRK: Resetting on resume");


