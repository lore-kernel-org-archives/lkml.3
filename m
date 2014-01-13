Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbaAMQUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:20:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53623 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbaAMQEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:04:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 162/208] xhci: Limit the spurious wakeup fix only to HP machines
Date: Mon, 13 Jan 2014 16:00:03 +0000
Message-Id: <1389628849-1614-163-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6962d914f317b119e0db7189199b21ec77a4b3e0 upstream.

We've got regression reports that my previous fix for spurious wakeups
after S5 on HP Haswell machines leads to the automatic reboot at
shutdown on some machines.  It turned out that the fix for one side
triggers another BIOS bug in other side.  So, it's exclusive.

Since the original S5 wakeups have been confirmed only on HP machines,
it'd be safer to apply it only to limited machines.  As a wild guess,
limiting to machines with HP PCI SSID should suffice.

This patch should be backported to kernels as old as 3.12, that
contain the commit 638298dc66ea36623dbc2757a24fc2c4ab41b016 "xhci: Fix
spurious wakeups after S5 on Haswell".

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=66171
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: <dashing.meng@gmail.com>
Reported-by: Niklas Schnelle <niklas@komani.de>
Reported-by: Giorgos <ganastasiouGR@gmail.com>
Reported-by: <art1@vhex.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/xhci-pci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index c79e3b9..32ef829 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -124,7 +124,12 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		 * any other sleep) on Haswell machines with LPT and LPT-LP
 		 * with the new Intel BIOS
 		 */
-		xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
+		/* Limit the quirk to only known vendors, as this triggers
+		 * yet another BIOS bug on some other machines
+		 * https://bugzilla.kernel.org/show_bug.cgi?id=66171
+		 */
+		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
+			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
 	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
-- 
1.8.3.2

