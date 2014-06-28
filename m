Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaF1RrJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:47:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaF1RrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:47:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Leandro Liptak <leandroliptak@gmail.com>
Subject: [PATCH 3.4 08/43] USB: EHCI: avoid BIOS handover on the HASEE E200
Date: Sat, 28 Jun 2014 10:45:59 -0700
Message-Id: <20140628174450.193084615@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174449.788784511@linuxfoundation.org>
References: <20140628174449.788784511@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/pci-quirks.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -555,6 +555,14 @@ static const struct dmi_system_id __devi
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
 
@@ -564,9 +572,14 @@ static void __devinit ehci_bios_handoff(
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


