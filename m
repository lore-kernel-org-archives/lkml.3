Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaHAMPY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:15:24 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:35215 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaHAMPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:15:21 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] PCI: tegra: Implement a proper resource hierarchy
Date: Fri,  1 Aug 2014 14:15:11 +0200
Message-Id: <1406895311-18869-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
References: <1406895311-18869-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Currently the resource hierarchy generated from the PCIe host bridge is
completely flat:

	$ cat /proc/iomem
	00000000-00000fff : /pcie-controller@00003000/pci@1,0
	00003000-000037ff : pads
	00003800-000039ff : afi
	10000000-1fffffff : cs
	28000000-28003fff : r8169
	28004000-28004fff : r8169
	...

The host bridge driver doesn't request all the resources that are used.
Windows allocated to each of the root ports aren't tracked, so there is
no way for resources allocated to individual devices to be matched up
with the correct parent resource by the PCI core.

This patch addresses this in two steps. It first takes the union of all
regions associated with the PCIe host bridge (control registers, root
port registers, configuration space, I/O and prefetchable as well as
non-prefetchable memory regions) and uses it as the new root of the
resource hierarchy.

Subsequently, regions are allocated from within this new root resource
so that the resource tree looks much more like what's expected:

	# cat /proc/iomem
	00000000-3fffffff : /pcie-controller@00003000
	  00000000-00000fff : /pcie-controller@00003000/pci@1,0
	  00003000-000037ff : pads
	  00003800-000039ff : afi
	  10000000-1fffffff : cs
	  20000000-27ffffff : non-prefetchable
	  28000000-3fffffff : prefetchable
	    28000000-280fffff : PCI Bus 0000:01
	      28000000-28003fff : 0000:01:00.0
	        28000000-28003fff : r8169
	      28004000-28004fff : 0000:01:00.0
	        28004000-28004fff : r8169
	...

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/pci/host/pci-tegra.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 0fb0fdb223d5..83fa33e16650 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -253,6 +253,7 @@ struct tegra_pcie {
 	struct list_head buses;
 	struct resource *cs;
 
+	struct resource all;
 	struct resource io;
 	struct resource mem;
 	struct resource prefetch;
@@ -626,6 +627,15 @@ DECLARE_PCI_FIXUP_FINAL(PCI_ANY_ID, PCI_ANY_ID, tegra_pcie_relax_enable);
 static int tegra_pcie_setup(int nr, struct pci_sys_data *sys)
 {
 	struct tegra_pcie *pcie = sys_to_pcie(sys);
+	int err;
+
+	err = devm_request_resource(pcie->dev, &pcie->all, &pcie->mem);
+	if (err < 0)
+		return err;
+
+	err = devm_request_resource(pcie->dev, &pcie->all, &pcie->prefetch);
+	if (err)
+		return err;
 
 	pci_add_resource_offset(&sys->resources, &pcie->mem, sys->mem_offset);
 	pci_add_resource_offset(&sys->resources, &pcie->prefetch,
@@ -1514,6 +1524,12 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 	struct resource res;
 	int err;
 
+	memset(&pcie->all, 0, sizeof(pcie->all));
+	pcie->all.flags = IORESOURCE_MEM;
+	pcie->all.name = np->full_name;
+	pcie->all.start = ~0;
+	pcie->all.end = 0;
+
 	if (of_pci_range_parser_init(&parser, np)) {
 		dev_err(pcie->dev, "missing \"ranges\" property\n");
 		return -EINVAL;
@@ -1525,21 +1541,31 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		switch (res.flags & IORESOURCE_TYPE_BITS) {
 		case IORESOURCE_IO:
 			memcpy(&pcie->io, &res, sizeof(res));
-			pcie->io.name = "I/O";
+			pcie->io.name = np->full_name;
 			break;
 
 		case IORESOURCE_MEM:
 			if (res.flags & IORESOURCE_PREFETCH) {
 				memcpy(&pcie->prefetch, &res, sizeof(res));
-				pcie->prefetch.name = "PREFETCH";
+				pcie->prefetch.name = "prefetchable";
 			} else {
 				memcpy(&pcie->mem, &res, sizeof(res));
-				pcie->mem.name = "MEM";
+				pcie->mem.name = "non-prefetchable";
 			}
 			break;
 		}
+
+		if (res.start <= pcie->all.start)
+			pcie->all.start = res.start;
+
+		if (res.end >= pcie->all.end)
+			pcie->all.end = res.end;
 	}
 
+	err = devm_request_resource(pcie->dev, &iomem_resource, &pcie->all);
+	if (err < 0)
+		return err;
+
 	err = of_pci_parse_bus_range(np, &pcie->busn);
 	if (err < 0) {
 		dev_err(pcie->dev, "failed to parse ranges property: %d\n",
-- 
2.0.3

