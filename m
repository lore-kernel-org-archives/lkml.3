Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaEHQS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:18:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:34560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbaEHQPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979585"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Holger Hans Peter Freyther <holger@moiji-mobile.com>
Subject: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
Date: Thu,  8 May 2014 19:25:55 +0300
Message-Id: <1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Add a command line switch for disabling ehci port switchover.  Useful
for working around / debugging xhci incompatibilities where ehci
operation is available.

Reference: http://marc.info/?l=linux-usb&m=138920063001509&w=2

Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Holger Hans Peter Freyther <holger@moiji-mobile.com>
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 Documentation/kernel-parameters.txt |  3 +++
 drivers/usb/host/pci-quirks.c       | 15 +++++++++++++--
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4384217..fc3403114 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2251,6 +2251,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
 
+	noxhci_port_switch
+			[USB] Use EHCI instead of XHCI where available
+
 	cpu0_hotplug	[X86] Turn on CPU0 hotplug feature when
 			CONFIG_BOOTPARAM_HOTPLUG_CPU0 is off.
 			Some features depend on CPU0. Known dependencies are:
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 00661d3..38bfe3d 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -823,6 +823,15 @@ static int handshake(void __iomem *ptr, u32 mask, u32 done,
 	return -ETIMEDOUT;
 }
 
+static int noxhci_port_switch;
+
+static int __init noxhci_port_switch_setup(char *str)
+{
+	noxhci_port_switch = 1;
+	return 0;
+}
+early_param("noxhci_port_switch", noxhci_port_switch_setup);
+
 /*
  * Intel's Panther Point chipset has two host controllers (EHCI and xHCI) that
  * share some number of ports.  These ports can be switched between either
@@ -860,8 +869,7 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 		return;
 
 	/* Don't switchover the ports if the user hasn't compiled the xHCI
-	 * driver.  Otherwise they will see "dead" USB ports that don't power
-	 * the devices.
+	 * driver or has explicitly disabled switchover
 	 */
 	if (!IS_ENABLED(CONFIG_USB_XHCI_HCD)) {
 		dev_warn(&xhci_pdev->dev,
@@ -871,6 +879,9 @@ void usb_enable_intel_xhci_ports(struct pci_dev *xhci_pdev)
 				"USB 3.0 devices will work at USB 2.0 speeds.\n");
 		usb_disable_xhci_ports(xhci_pdev);
 		return;
+	} else if (noxhci_port_switch) {
+		usb_disable_xhci_ports(xhci_pdev);
+		return;
 	}
 
 	/* Read USB3PRM, the USB 3.0 Port Routing Mask Register
-- 
1.8.3.2

