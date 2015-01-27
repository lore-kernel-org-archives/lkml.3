Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525AbbA0MTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488AbbA0MTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 099/126] xhci: Add broken-streams quirk for Fresco Logic FL1000G xhci controllers
Date: Tue, 27 Jan 2015 12:16:44 +0000
Message-Id: <1422361031-19364-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 7f5c4d631aed243ca89c6673427954210b1628ec upstream.

Streams do not work reliabe on Fresco Logic FL1000G xhci controllers,
trying to use them results in errors like this:

21:37:33 kernel: xhci_hcd 0000:04:00.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
21:37:33 kernel: xhci_hcd 0000:04:00.0: @00000000368b3570 9067b000 00000000 05000000 01078001
21:37:33 kernel: xhci_hcd 0000:04:00.0: ERROR Transfer event for disabled endpoint or incorrect stream ring
21:37:33 kernel: xhci_hcd 0000:04:00.0: @00000000368b3580 9067b400 00000000 05000000 01038001

As always I've ordered a pci-e addon card with a Fresco Logic controller for
myself to see if I can come up with a better fix then the big hammer, in
the mean time this will make uas devices work again (in usb-storage mode)
for FL1000G users.

Reported-by: Marcin Zajączkowski <mszpak@wp.pl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index e614d1831e79..fd8c8e669cac 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -80,6 +80,8 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 				"must be suspended extra slowly",
 				pdev->revision);
 		}
+		if (pdev->device == PCI_DEVICE_ID_FRESCO_LOGIC_PDK)
+			xhci->quirks |= XHCI_BROKEN_STREAMS;
 		/* Fresco Logic confirms: all revisions of this chip do not
 		 * support MSI, even though some of them claim to in their PCI
 		 * capabilities.
-- 
2.1.4

