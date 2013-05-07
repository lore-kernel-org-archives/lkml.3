Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab3EGELk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:11:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26614 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934Ab3EGD6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:47 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=z1aIMqprH-AA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KUA6A1QI660A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=Z9hppVypvsQCDiRzgicA:9 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035842.928235057@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Whitehead <mwhitehe@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [012/126] EISA/PCI: Fix bus res reference
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0012-EISA-PCI-Fix-bus-res-reference.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

[ Upstream commit 2cfda637e29ce9e3df31b59f64516b2e571cc985 ]

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
Cc: stable@vger.kernel.org	# v3.3+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/eisa/pci_eisa.c |   28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/eisa/pci_eisa.c b/drivers/eisa/pci_eisa.c
index d4cd56a..6c3fca9 100644
--- a/drivers/eisa/pci_eisa.c
+++ b/drivers/eisa/pci_eisa.c
@@ -21,7 +21,8 @@ static struct eisa_root_device pci_eisa_root;
 
 static int __init pci_eisa_init(struct pci_dev *pdev)
 {
-	int rc;
+	int rc, i;
+	struct resource *res, *bus_res = NULL;
 
 	if ((rc = pci_enable_device (pdev))) {
 		printk (KERN_ERR "pci_eisa : Could not enable device %s\n",
@@ -29,9 +30,30 @@ static int __init pci_eisa_init(struct pci_dev *pdev)
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
1.7.10.4


