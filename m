Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3KZSPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:15:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab3KZSNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:13:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 3.11 21/36] PCI: Support PCIe Capability Slot registers only for ports with slots
Date: Tue, 26 Nov 2013 10:12:31 -0800
Message-Id: <20131126181029.471123401@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131126181025.029404973@linuxfoundation.org>
References: <20131126181025.029404973@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 6d3a1741f1e648cfbd5a0cc94477a0d5004c6f5e upstream.

Previously we allowed callers to access Slot Capabilities, Status, and
Control for Root Ports even if the Root Port did not implement a slot.
This seems dubious because the spec only requires these registers if a
slot is implemented.

It's true that even Root Ports without slots must have *space* for these
slot registers, because the Root Capabilities, Status, and Control
registers are after the slot registers in the capability.  However,
for a v1 PCIe Capability, the *semantics* of the slot registers are
undefined unless a slot is implemented.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-By: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/access.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -497,9 +497,9 @@ static inline bool pcie_cap_has_sltctl(c
 {
 	int type = pci_pcie_type(dev);
 
-	return type == PCI_EXP_TYPE_ROOT_PORT ||
-	       (type == PCI_EXP_TYPE_DOWNSTREAM &&
-		pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT);
+	return (type == PCI_EXP_TYPE_ROOT_PORT ||
+		type == PCI_EXP_TYPE_DOWNSTREAM) &&
+	       pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT;
 }
 
 static inline bool pcie_cap_has_rtctl(const struct pci_dev *dev)


