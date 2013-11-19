Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3KSVfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:35:52 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:50920 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab3KSVfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:35:46 -0500
Subject: [PATCH v2 1/3] PCI: Allow PCIe Capability link-related register
 access for switches
To: stable@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        linux-kernel@vger.kernel.org, Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Date: Tue, 19 Nov 2013 14:35:44 -0700
Message-ID: <20131119213544.3839.44254.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
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
CC: stable@vger.kernel.org	# v3.7+
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

