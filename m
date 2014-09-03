Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbaICJ6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:58:19 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57448 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932348AbaICJ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:58:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Bryan O'Donoghue" <bryan.odonoghue@intel.com>,
        "Alvin (Weike) Chen" <alvin.chen@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 19/56] USB: ehci-pci: USB host controller support for Intel Quark X1000
Date: Wed,  3 Sep 2014 11:26:38 +0200
Message-Id: <5ba902d79f89da32de0bbfa2fb1b9bda227e5561.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6e693739e9b603b3ca9ce0d4f4178f0633458465 upstream.

The EHCI packet buffer in/out threshold is programmable for Intel Quark X1000
USB host controller, and the default value is 0x20 dwords. The in/out threshold
can be programmed to 0x80 dwords (512 Bytes) to maximize the perfomrance,
but only when isochronous/interrupt transactions are not initiated by the USB
host controller. This patch is to reconfigure the packet buffer in/out
threshold as maximal as possible to maximize the performance, and 0x7F dwords
(508 Bytes) should be used because the USB host controller initiates
isochronous/interrupt transactions.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@intel.com>
Signed-off-by: Alvin (Weike) Chen <alvin.chen@intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Reviewed-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ehci-pci.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 3e86bf4371b3..ca7b964124af 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -35,6 +35,21 @@ static const char hcd_name[] = "ehci-pci";
 #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
 
 /*-------------------------------------------------------------------------*/
+#define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
+static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
+{
+	return pdev->vendor == PCI_VENDOR_ID_INTEL &&
+		pdev->device == PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC;
+}
+
+/*
+ * 0x84 is the offset of in/out threshold register,
+ * and it is the same offset as the register of 'hostpc'.
+ */
+#define	intel_quark_x1000_insnreg01	hostpc
+
+/* Maximum usable threshold value is 0x7f dwords for both IN and OUT */
+#define INTEL_QUARK_X1000_EHCI_MAX_THRESHOLD	0x007f007f
 
 /* called after powerup, by probe or system-pm "wakeup" */
 static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
@@ -50,6 +65,16 @@ static int ehci_pci_reinit(struct ehci_hcd *ehci, struct pci_dev *pdev)
 	if (!retval)
 		ehci_dbg(ehci, "MWI active\n");
 
+	/* Reset the threshold limit */
+	if (is_intel_quark_x1000(pdev)) {
+		/*
+		 * For the Intel QUARK X1000, raise the I/O threshold to the
+		 * maximum usable value in order to improve performance.
+		 */
+		ehci_writel(ehci, INTEL_QUARK_X1000_EHCI_MAX_THRESHOLD,
+			ehci->regs->intel_quark_x1000_insnreg01);
+	}
+
 	return 0;
 }
 
-- 
2.1.0

