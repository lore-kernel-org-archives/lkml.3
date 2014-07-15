Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934216AbaGOWB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:01:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54713 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933923AbaGOVhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:50 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 152/198] USB: EHCI: avoid BIOS handover on the HASEE E200
Date: Tue, 15 Jul 2014 14:30:22 -0700
Message-Id: <1405459868-15089-153-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit b0a50e92bda3c4aeb8017d4e6c6e92146ebd5c9b upstream.

Leandro Liptak reports that his HASEE E200 computer hangs when we ask
the BIOS to hand over control of the EHCI host controller.  This
definitely sounds like a bug in the BIOS, but at the moment there is
no way to fix it.

This patch works around the problem by avoiding the handoff whenever
the motherboard and BIOS version match those of Leandro's computer.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Leandro Liptak <leandroliptak@gmail.com>
Tested-by: Leandro Liptak <leandroliptak@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/pci-quirks.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index dfbdd3a..af93c8c 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -657,6 +657,14 @@ static const struct dmi_system_id ehci_dmi_nohandoff_table[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-"),
 		},
 	},
+	{
+		/* HASEE E200 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HASEE"),
+			DMI_MATCH(DMI_BOARD_NAME, "E210"),
+			DMI_MATCH(DMI_BIOS_VERSION, "6.00"),
+		},
+	},
 	{ }
 };
 
@@ -666,9 +674,14 @@ static void ehci_bios_handoff(struct pci_dev *pdev,
 {
 	int try_handoff = 1, tried_handoff = 0;
 
-	/* The Pegatron Lucid tablet sporadically waits for 98 seconds trying
-	 * the handoff on its unused controller.  Skip it. */
-	if (pdev->vendor == 0x8086 && pdev->device == 0x283a) {
+	/*
+	 * The Pegatron Lucid tablet sporadically waits for 98 seconds trying
+	 * the handoff on its unused controller.  Skip it.
+	 *
+	 * The HASEE E200 hangs when the semaphore is set (bugzilla #77021).
+	 */
+	if (pdev->vendor == 0x8086 && (pdev->device == 0x283a ||
+			pdev->device == 0x27cc)) {
 		if (dmi_check_system(ehci_dmi_nohandoff_table))
 			try_handoff = 0;
 	}
-- 
1.9.1

