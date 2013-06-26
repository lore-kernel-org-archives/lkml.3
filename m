Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab3FZGbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 02:31:09 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17434 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3FZGbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 02:31:08 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <stern@rowland.harvard.edu>, <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
Date: Wed, 26 Jun 2013 14:29:45 +0800
Message-Id: <1372228185-11518-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>

There's another patch trying to fix this warning:
 "Controller not stopped yet!". 
It is : 997ff893603c6455da4c5e26ba1d0f81adfecdfc .

I don't think it is appropriate to avoid auto-stop for all HP uhci
devices. So add one  tag for the virtual uhci devices, it is used
to replace "wait_for_hp" in the auto-stop case.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/usb/host/uhci-hcd.h |    1 +
 drivers/usb/host/uhci-hub.c |    2 +-
 drivers/usb/host/uhci-pci.c |   21 +++++++++++++++++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/uhci-hcd.h b/drivers/usb/host/uhci-hcd.h
index 6f986d8..915d5df 100644
--- a/drivers/usb/host/uhci-hcd.h
+++ b/drivers/usb/host/uhci-hcd.h
@@ -425,6 +425,7 @@ struct uhci_hcd {
 	/* Silicon quirks */
 	unsigned int oc_low:1;			/* OverCurrent bit active low */
 	unsigned int wait_for_hp:1;		/* Wait for HP port reset */
+	unsigned int virtual_device:1;		/* For some virtual devices */
 	unsigned int big_endian_mmio:1;		/* Big endian registers */
 	unsigned int big_endian_desc:1;		/* Big endian descriptors */
 
diff --git a/drivers/usb/host/uhci-hub.c b/drivers/usb/host/uhci-hub.c
index 9189bc9..da00754 100644
--- a/drivers/usb/host/uhci-hub.c
+++ b/drivers/usb/host/uhci-hub.c
@@ -226,7 +226,7 @@ static int uhci_hub_status_data(struct usb_hcd *hcd, char *buf)
 		if (any_ports_active(uhci))
 			uhci->rh_state = UHCI_RH_RUNNING;
 		else if (time_after_eq(jiffies, uhci->auto_stop_time) &&
-				!uhci->wait_for_hp)
+				!uhci->virtual_device)
 			suspend_rh(uhci, UHCI_RH_AUTO_STOPPED);
 		break;
 
diff --git a/drivers/usb/host/uhci-pci.c b/drivers/usb/host/uhci-pci.c
index c300bd2f7..68e6d92 100644
--- a/drivers/usb/host/uhci-pci.c
+++ b/drivers/usb/host/uhci-pci.c
@@ -110,6 +110,24 @@ static int uhci_pci_global_suspend_mode_is_broken(struct uhci_hcd *uhci)
 	return 0;
 }
 
+static int uhci_virtual_device_ids[][2] = {
+	{0x103c, 0x3300},
+	{0, 0},
+};
+static int uhci_is_virtual_device(struct uhci_hcd *uhci)
+{
+	int i;
+	struct pci_dev *dev;
+
+	dev = to_pci_dev(uhci_dev(uhci));
+	for (i = 0; uhci_virtual_device_ids[i][0] != 0; i++) {
+		if (dev->vendor == uhci_virtual_device_ids[i][0]
+			    && dev->device == uhci_virtual_device_ids[i][1])
+			return 1;
+	}
+	return 0;
+}
+
 static int uhci_pci_init(struct usb_hcd *hcd)
 {
 	struct uhci_hcd *uhci = hcd_to_uhci(hcd);
@@ -129,6 +147,9 @@ static int uhci_pci_init(struct usb_hcd *hcd)
 	if (to_pci_dev(uhci_dev(uhci))->vendor == PCI_VENDOR_ID_HP)
 		uhci->wait_for_hp = 1;
 
+	if (uhci_is_virtual_device(uhci))
+		uhci->virtual_device = 1;
+
 	/* Set up pointers to PCI-specific functions */
 	uhci->reset_hc = uhci_pci_reset_hc;
 	uhci->check_and_reset_hc = uhci_pci_check_and_reset_hc;
-- 
1.7.10.4

