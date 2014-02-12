Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaBLIXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:23:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50255 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139AbaBLIOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:06 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Niklas Schnelle" <niklas@komani.de>,
        "Giorgos" <ganastasiouGR@gmail.com>, "" <dashing.meng@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>, "" <art1@vhex.net>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.241158989@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 37/79] xhci: Limit the spurious wakeup fix only to HP
 machines
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-pci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -121,7 +121,12 @@ static void xhci_pci_quirks(struct devic
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

