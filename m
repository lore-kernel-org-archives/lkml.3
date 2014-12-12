Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbaLLGQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:16:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51691 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758029AbaLLGQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:52 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andreas Noever" <andreas.noever@gmail.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.483468712@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 008/164] PCI: pciehp: Prevent NULL dereference during
 probe
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/hotplug/pciehp_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -237,6 +237,13 @@ static int pciehp_probe(struct pcie_devi
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

