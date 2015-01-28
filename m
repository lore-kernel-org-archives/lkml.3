Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbbA1EN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:13:58 -0500
Received: from mail.kernel.org ([198.145.29.136]:36770 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760424AbbA1ENz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:13:55 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 007/177] PCI: pciehp: Prevent NULL dereference during probe
Date: Wed, 28 Jan 2015 12:06:21 +0800
Message-Id: <1422418236-12852-14-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Noever <andreas.noever@gmail.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit bceee4a97eb58bd0e80e39eff11b506ddd9e7ad3 upstream.

pciehp assumes that dev->subordinate, the struct pci_bus for a bridge's
secondary bus, exists.  But we do not create that bus if we run out of bus
numbers during enumeration.  This leads to a NULL dereference in
init_slot() (and other places).

Change pciehp_probe() to return -ENODEV when no secondary bus is present.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/pci/hotplug/pciehp_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 9e39df9..75dc402 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -237,6 +237,13 @@ static int pciehp_probe(struct pcie_device *dev)
 	else if (pciehp_acpi_slot_detection_check(dev->port))
 		goto err_out_none;
 
+	if (!dev->port->subordinate) {
+		/* Can happen if we run out of bus numbers during probe */
+		dev_err(&dev->device,
+			"Hotplug bridge without secondary bus, ignoring\n");
+		goto err_out_none;
+	}
+
 	ctrl = pcie_init(dev);
 	if (!ctrl) {
 		dev_err(&dev->device, "Controller initialization failed\n");
-- 
1.9.1

