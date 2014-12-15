Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaLOOab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:30:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaLOO32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andreas Noever <andreas.noever@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 167/168] PCI: pciehp: Prevent NULL dereference during probe
Date: Mon, 15 Dec 2014 14:27:01 +0000
Message-Id: <1418653622-21105-168-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Noever <andreas.noever@gmail.com>

commit bceee4a97eb58bd0e80e39eff11b506ddd9e7ad3 upstream.

pciehp assumes that dev->subordinate, the struct pci_bus for a bridge's
secondary bus, exists.  But we do not create that bus if we run out of bus
numbers during enumeration.  This leads to a NULL dereference in
init_slot() (and other places).

Change pciehp_probe() to return -ENODEV when no secondary bus is present.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/hotplug/pciehp_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index a2297db80813..07aa722bb12c 100644
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
2.1.3

