Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaEAUgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaEAUgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:36:37 -0400
Subject: [PATCH] PCI: quirk RTL8110SC INTx masking
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org
Cc: nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Date: Thu, 01 May 2014 14:36:31 -0600
Message-ID: <20140501203525.27822.98248.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INTx masking does not work on this device.  To see this, configure
the network device UP on an active network, note that the interrupt
count continues to increment for the device in /proc/interrupts.  Use
setpci to set the PCI_COMMAND_INTX_DISABLE bit in the PCI_COMMAND
register.  As expected, the interrupt count ceases to increment.
However, reading the PCI_STATUS_INTERRUPT bit of the PCI_STATUS
register does not indicate that interrupts are pending and clearing
PCI_COMMAND_INTX_DISABLE in the PCI_COMMAND register does not allow
the device to continue operation.

This does not affect operation of the host r8169 driver, but it does
prevent the device from being functional when assigned to a VM, such
as with QEMU and VFIO.  The guest driver successfully probes the
device, but there is no traffic.  Mark INTx masking as broken,
allowing the more restrictive APIC masking to be used instead.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/quirks.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index ea55b0f..e15a5da 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2991,6 +2991,14 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_CHELSIO, 0x0030,
 			 quirk_broken_intx_masking);
 DECLARE_PCI_FIXUP_HEADER(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 			 quirk_broken_intx_masking);
+/*
+ * Realtek RTL8169 PCI Gigabit Ethernet Controller (rev 10)
+ * Subsystem: Realtek RTL8169/8110 Family PCI Gigabit Ethernet NIC
+ *
+ * RTL8110SC - Fails under PCI device assignment using DisINTx masking.
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_REALTEK, 0x8169,
+			 quirk_broken_intx_masking);
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)

