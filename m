Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965474Ab3HHN5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:57:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965097Ab3HHN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:57:20 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>
Subject: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
Date: Thu,  8 Aug 2013 15:57:07 +0200
Message-Id: <1375970227-14794-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIe switch can be connected directly to the PCIe root complex in QEMU;
ASPM does not expect this topology and dereferences NULL pointer when
initializing.

Downstream port can be also connected to the root complex without
upstream one, so code checks for both, otherwise they dereference NULL
on line drivers/pci/pcie/aspm.c:530 (alloc_pcie_link_state+13):
  		parent = pdev->bus->parent->self->link_state;
"pdev->bus->parent->self == NULL" if upstream port is connected directly
to the root bus and "pdev->bus->parent == NULL" in the second case.

v1 -> v2: (https://lkml.org/lkml/2013/6/19/753)
 - Initialization is aborted in pcie_aspm_init_link_state, where other
   special cases are being handled
 - pci_is_root_bus is used
 - Warning is printed

Reproducer for "downstream -- root" and "downstream -- upstream -- root"
(used qemu-kvm 1.5, q35 machine type might be missing on older ones)

  for parent in pcie.0 upstream; do
   qemu-kvm -m 128 -M q35 -nographic -no-reboot \
     -device x3130-upstream,bus=pcie.0,id=upstream \
     -device xio3130-downstream,bus=$parent,id=downstream,chassis=1 \
     -device virtio-blk-pci,bus=downstream,id=virtio-zero,drive=zero \
     -drive  file=/dev/zero,id=zero,format=raw \
     -kernel bzImage -append "console=ttyS0 panic=3" # pcie_aspm=off
  done

ASPM in QEMU works if we connect upstream through root port
  -device ioh3420,bus=pcie.0,id=root.0 \
  -device x3130-upstream,bus=root.0,id=upstream

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 drivers/pci/pcie/aspm.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 403a443..209cd7f 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -570,6 +570,15 @@ void pcie_aspm_init_link_state(struct pci_dev *pdev)
 	    pdev->bus->self)
 		return;
 
+	/* We require at least two ports between downstream and root bus */
+	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM &&
+	    (pci_is_root_bus(pdev->bus) ||
+	     pci_is_root_bus(pdev->bus->parent))) {
+		dev_warn(&pdev->dev, "ASPM disabled"
+		                     " (connected directly to root bus)\n");
+		return;
+	}
+
 	down_read(&pci_bus_sem);
 	if (list_empty(&pdev->subordinate->devices))
 		goto out;
-- 
1.8.3.1

