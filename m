Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaF3MaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751802AbaF3MaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 108/181] USB: EHCI: avoid BIOS handover on the HASEE E200
Date: Mon, 30 Jun 2014 13:52:09 +0200
Message-Id: <bd7853ced3aa4f4272bb5cfba0801c5c1bf976d7.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/pci-quirks.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index f8763cc9d301..877f87f9513b 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -645,6 +645,14 @@ static const struct dmi_system_id ehci_dmi_nohandoff_table[] = {
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
 
@@ -654,9 +662,14 @@ static void ehci_bios_handoff(struct pci_dev *pdev,
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
2.0.0

