Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbbAHRG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:06:28 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58094 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386AbbAHRGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:06:23 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 4/8] PCI/MSI: of: Allow msi_domain lookup using the PHB node
Date: Thu,  8 Jan 2015 17:06:08 +0000
Message-Id: <1420736772-11088-5-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of platforms do not need to use the msi-parent property,
as the host bridge itself provides the MSI controller.

Allow this configuration by performing an irq domain lookup based
on the PHB node if it doesn't have a valid msi-parent property.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/of.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/of.c b/drivers/pci/of.c
index d8d1274..75bfb85 100644
--- a/drivers/pci/of.c
+++ b/drivers/pci/of.c
@@ -68,9 +68,14 @@ void pci_set_phb_of_msi_domain(struct pci_bus *bus)
 
 	if (!bus->dev.of_node)
 		return;
+	/* Start looking for a phandle to an MSI controller. */
 	np = of_parse_phandle(bus->dev.of_node, "msi-parent", 0);
+	/*
+	 * If we don't have an msi-parent property, look for a domain
+	 * directly attached to the host bridge.
+	 */
 	if (!np)
-		return;
+		np = bus->dev.of_node;
 	dev_set_msi_domain(&bus->dev, irq_find_host(np));
 #endif
 }
-- 
2.1.4

