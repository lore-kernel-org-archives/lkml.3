Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3KRTSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:18:03 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35832 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3KRTRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:17:54 -0500
Subject: [PATCH 2/2] PCI: Support PCIe Capability Slot registers only for
 ports with slots
To: stable@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        linux-kernel@vger.kernel.org, Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Date: Mon, 18 Nov 2013 12:17:52 -0700
Message-ID: <20131118191752.26774.25303.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6d3a1741f1e648cfbd5a0cc94477a0d5004c6f5e upstream.

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
CC: stable@vger.kernel.org	# 3.10.x 3.11.x
---
 drivers/pci/access.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index e26c3bd9aca4..bcd92b629d3c 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -499,8 +499,8 @@ static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
 	int type = pci_pcie_type(dev);
 
 	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
-	       (type == PCI_EXP_TYPE_DOWNSTREAM &&
+	       ((type == PCI_EXP_TYPE_ROOT_PORT ||
+	         type == PCI_EXP_TYPE_DOWNSTREAM) &&
 		pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT);
 }
 

