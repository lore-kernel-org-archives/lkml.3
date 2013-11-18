Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab3KRTRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:17:53 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35049 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3KRTRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 14:17:47 -0500
Subject: [PATCH 1/2] PCI: Allow PCIe Capability link-related register access
 for switches
To: stable@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        linux-kernel@vger.kernel.org, Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Date: Mon, 18 Nov 2013 12:17:44 -0700
Message-ID: <20131118191744.26774.9578.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131118191723.26774.53479.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d3694d4fa3f44f6a295f8ab064937c8a1549d174 upstream.

Every PCIe device has a link, except Root Complex Integrated Endpoints
and Root Complex Event Collectors.  Previously we didn't give access
to PCIe capability link-related registers for Upstream Ports, Downstream
Ports, and Bridges, so attempts to read PCI_EXP_LNKCTL incorrectly
returned zero.  See PCIe spec r3.0, sec 7.8 and 1.3.2.3.

Reference: http://lkml.kernel.org/r/979A8436335E3744ADCD3A9F2A2B68A52AD136BE@SJEXCHMB10.corp.ad.broadcom.com
Reported-by: Yuval Mintz <yuvalmin@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-By: Jiang Liu <jiang.liu@huawei.com>
CC: stable@vger.kernel.org	# 3.10.x 3.11.x
---
 drivers/pci/access.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 1cc23661f79b..e26c3bd9aca4 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -485,9 +485,13 @@ static inline bool pcie_cap_has_lnkctl(const struct pci_dev *dev)
 	int type = pci_pcie_type(dev);
 
 	return pcie_cap_version(dev) > 1 ||
-	       type == PCI_EXP_TYPE_ROOT_PORT ||
 	       type == PCI_EXP_TYPE_ENDPOINT ||
-	       type == PCI_EXP_TYPE_LEG_END;
+	       type == PCI_EXP_TYPE_LEG_END ||
+	       type == PCI_EXP_TYPE_ROOT_PORT ||
+	       type == PCI_EXP_TYPE_UPSTREAM ||
+	       type == PCI_EXP_TYPE_DOWNSTREAM ||
+	       type == PCI_EXP_TYPE_PCI_BRIDGE ||
+	       type == PCI_EXP_TYPE_PCIE_BRIDGE;
 }
 
 static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)

