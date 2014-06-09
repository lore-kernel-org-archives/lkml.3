Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaFIVGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:06:54 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:33831 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932226AbaFIVGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:06:50 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH] PCI: Prevent NULL dereference during pciehp probe
Date: Mon,  9 Jun 2014 23:03:32 +0200
Message-Id: <1402347812-8059-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pciehp assumes that dev->subordinate exists. But we do not assign a bus
if we run out of bus numbers during enumeration. This leads to a NULL
dereference in init_slot (and other places).

Change pciehp_probe to return -ENODEV when no subordinate bus is
present.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/hotplug/pciehp_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 0e0a2ff..e5abcaf 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -255,6 +255,13 @@ static int pciehp_probe(struct pcie_device *dev)
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
2.0.0

