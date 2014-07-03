Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbaGCJZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:25:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030536AbaGCJY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:24:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 174/198] USB: EHCI: avoid BIOS handover on the HASEE E200
Date: Thu,  3 Jul 2014 10:20:17 +0100
Message-Id: <1404379241-8590-175-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/host/pci-quirks.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index b9848e4d3d44..75c818c164d5 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -568,6 +568,14 @@ static const struct dmi_system_id ehci_dmi_nohandoff_table[] = {
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
 
@@ -577,9 +585,14 @@ static void ehci_bios_handoff(struct pci_dev *pdev,
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

