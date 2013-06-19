Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab3FSS4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:56:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756847Ab3FSS4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:56:40 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>,
        Joe Lawrence <Joe.Lawrence@stratus.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH] PCI: avoid NULL deref in alloc_pcie_link_state
Date: Wed, 19 Jun 2013 20:56:14 +0200
Message-Id: <1371668174-32115-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCIe switch upstream port can be connected directly to the PCIe root bus
in QEMU; ASPM does not expect this topology and dereferences NULL pointer
when initializing.

I have not confirmed this can happen on real hardware, but it is presented
as a feature in QEMU, so there is no reason to panic if we can recover.

The dereference happens with topology defined by
  -M q35 -device x3130-upstream,bus=pcie.0,id=upstream \
  -device xio3130-downstream,bus=upstream,id=downstream,chassis=1
where on line drivers/pci/pcie/aspm.c:530 (alloc_pcie_link_state+13):
  		parent = pdev->bus->parent->self->link_state;
"pdev->bus->parent->self == NULL", because "pdev->bus->parent" has no
"->parent", hence no "->self".

Even though discouraged by QEMU documentation, one can set up even
topology without the upstream port
  -M q35 -device xio3130-downstream,bus=pcie.0,id=downstream,chassis=1
so "pdev->bus->parent == NULL", because "pdev->bus" is the root bus.
The patch checks for this too, because I do not like *NULL.

Right now, PCIe switch has to connect to the root port
  -M q35 -device ioh3420,bus=pcie.0,id=root.0 \
  -device x3130-upstream,bus=root.0,id=upstream \
  -device xio3130-downstream,bus=upstream,id=downstream,chassis=1

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 drivers/pci/pcie/aspm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 403a443..1ad1514 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -527,8 +527,8 @@ static struct pcie_link_state *alloc_pcie_link_state(struct pci_dev *pdev)
 	link->pdev = pdev;
 	if (pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM) {
 		struct pcie_link_state *parent;
-		parent = pdev->bus->parent->self->link_state;
-		if (!parent) {
+		if (!pdev->bus->parent || !pdev->bus->parent->self ||
+		    !(parent = pdev->bus->parent->self->link_state)) {
 			kfree(link);
 			return NULL;
 		}
-- 
1.8.1.4

