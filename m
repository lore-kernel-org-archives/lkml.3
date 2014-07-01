Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbaGAHTs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 03:19:48 -0400
Received: from mga14.intel.com ([192.55.52.115]:62746 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109AbaGAHTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 03:19:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,580,1400050800"; 
   d="scan'208";a="555665754"
From: "Chen, Alvin" <alvin.chen@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Boon Leong Ong <boon.leong.ong@intel.com>
Subject: [PATCH v4] USB: ehci-pci: USB host controller support for Intel Quark X1000
Date: Tue,  1 Jul 2014 08:15:34 -0700
Message-Id: <1404227734-14825-2-git-send-email-alvin.chen@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404227734-14825-1-git-send-email-alvin.chen@intel.com>
References: <1404227734-14825-1-git-send-email-alvin.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bryan O'Donoghue <bryan.odonoghue@intel.com>

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
---
changelog v4:
* Just define the maximum threshold value, and clarify it in the comments.
* Improve the comments.

 drivers/usb/host/ehci-pci.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index 3e86bf4..429434d 100644
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
+	* 0x84 is the offset of in/out threshold register,
+	* and it is the same offset as the register of 'hostpc'.
+	*/
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
1.7.9.5

