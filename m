Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab3DRJR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3DRJRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 05/72] EISA/PCI: Fix bus res reference
Date: Thu, 18 Apr 2013 10:15:50 +0100
Message-Id: <1366276617-3553-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 2cfda637e29ce9e3df31b59f64516b2e571cc985 upstream.

Matthew found that 3.8.3 is having problems with an old (ancient)
PCI-to-EISA bridge, the Intel 82375. It worked with the 3.2 kernel.
He identified the 82375, but doesn't assign the struct resource *res
pointer inside the struct eisa_root_device, and panics.

pci_eisa_init() was using bus->resource[] directly instead of
pci_bus_resource_n().  The bus->resource[] array is a PCI-internal
implementation detail, and after commit 45ca9e97 (PCI: add helpers for
building PCI bus resource lists) and commit 0efd5aab (PCI: add struct
pci_host_bridge_window with CPU/bus address offset), bus->resource[] is not
used for PCI root buses any more.

The 82375 is a subtractive-decode PCI device, so handle it the same
way we handle PCI-PCI bridges in subtractive-decode mode in
pci_read_bridge_bases().

[bhelgaas: changelog]
Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/eisa/pci_eisa.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index cdae207..ef5c3ec 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -22,7 +22,8 @@ static struct eisa_root_device pci_eisa_root;
 static int __init pci_eisa_init(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	int rc;
+	int rc, i;
+	struct resource *res, *bus_res = NULL;
 
 	if ((rc = pci_enable_device (pdev))) {
 		printk (KERN_ERR "pci_eisa : Could not enable device %s\n",
@@ -30,9 +31,30 @@ static int __init pci_eisa_init(struct pci_dev *pdev,
 		return rc;
 	}
 
+	/*
+	 * The Intel 82375 PCI-EISA bridge is a subtractive-decode PCI
+	 * device, so the resources available on EISA are the same as those
+	 * available on the 82375 bus.  This works the same as a PCI-PCI
+	 * bridge in subtractive-decode mode (see pci_read_bridge_bases()).
+	 * We assume other PCI-EISA bridges are similar.
+	 *
+	 * eisa_root_register() can only deal with a single io port resource,
+	*  so we use the first valid io port resource.
+	 */
+	pci_bus_for_each_resource(pdev->bus, res, i)
+		if (res && (res->flags & IORESOURCE_IO)) {
+			bus_res = res;
+			break;
+		}
+
+	if (!bus_res) {
+		dev_err(&pdev->dev, "No resources available\n");
+		return -1;
+	}
+
 	pci_eisa_root.dev              = &pdev->dev;
-	pci_eisa_root.res	       = pdev->bus->resource[0];
-	pci_eisa_root.bus_base_addr    = pdev->bus->resource[0]->start;
+	pci_eisa_root.res	       = bus_res;
+	pci_eisa_root.bus_base_addr    = bus_res->start;
 	pci_eisa_root.slots	       = EISA_MAX_SLOTS;
 	pci_eisa_root.dma_mask         = pdev->dma_mask;
 	dev_set_drvdata(pci_eisa_root.dev, &pci_eisa_root);
-- 
1.8.1.2

