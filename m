Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaBEUHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:07:00 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48408 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaBEUGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Alex He <alex.he@amd.com>, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 139/213] xHCI: Correct the #define XHCI_LEGACY_DISABLE_SMI
Date: Wed, 5 Feb 2014 15:01:34 -0500
Message-ID: <1391630568-49251-140-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex He <alex.he@amd.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 95018a53f7653e791bba1f54c8d75d9cb700d1bd upstream.

Re-define XHCI_LEGACY_DISABLE_SMI and used it in right way. All SMI enable
bits will be cleared to zero and flag bits 29:31 are also cleared to zero.
Other bits should be presvered as Table 146.

This patch should be backported to kernels as old as 2.6.31.

Signed-off-by: Alex He <alex.he@amd.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/pci-quirks.c    | 10 +++++++---
 drivers/usb/host/xhci-ext-caps.h |  5 +++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index bfbc6b97eb8f..afc37d4879cc 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -466,9 +466,13 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 		}
 	}
 
-	/* Disable any BIOS SMIs */
-	writel(XHCI_LEGACY_DISABLE_SMI,
-			base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
+	val = readl(base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
+	/* Mask off (turn off) any enabled SMIs */
+	val &= XHCI_LEGACY_DISABLE_SMI;
+	/* Mask all SMI events bits, RW1C */
+	val |= XHCI_LEGACY_SMI_EVENTS;
+	/* Disable any BIOS SMIs and clear all SMI events*/
+	writel(val, base + ext_cap_offset + XHCI_LEGACY_CONTROL_OFFSET);
 
 hc_init:
 	op_reg_base = base + XHCI_HC_LENGTH(readl(base));
diff --git a/drivers/usb/host/xhci-ext-caps.h b/drivers/usb/host/xhci-ext-caps.h
index 78c4edac1db1..e2acc97b169b 100644
--- a/drivers/usb/host/xhci-ext-caps.h
+++ b/drivers/usb/host/xhci-ext-caps.h
@@ -62,8 +62,9 @@
 /* USB Legacy Support Control and Status Register  - section 7.1.2 */
 /* Add this offset, plus the value of xECP in HCCPARAMS to the base address */
 #define XHCI_LEGACY_CONTROL_OFFSET	(0x04)
-/* bits 1:2, 5:12, and 17:19 need to be preserved; bits 21:28 should be zero */
-#define	XHCI_LEGACY_DISABLE_SMI		((0x3 << 1) + (0xff << 5) + (0x7 << 17))
+/* bits 1:3, 5:12, and 17:19 need to be preserved; bits 21:28 should be zero */
+#define	XHCI_LEGACY_DISABLE_SMI		((0x7 << 1) + (0xff << 5) + (0x7 << 17))
+#define XHCI_LEGACY_SMI_EVENTS		(0x7 << 29)
 
 /* command register values to disable interrupts and halt the HC */
 /* start/stop HC execution - do not write unless HC is halted*/
-- 
1.8.5.2

