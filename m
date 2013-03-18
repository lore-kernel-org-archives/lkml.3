Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3CROCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 10:02:48 -0400
Received: from storage.astrosoft.ru ([195.218.158.6]:22967 "HELO
	storage.astrosoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751671Ab3CROCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 10:02:46 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 Mar 2013 10:02:44 EDT
From: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Jia Hongtao <B38951@freescale.com>, Li Yang <leoli@freescale.com>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Timur Tabi <timur@freescale.com>, linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org,
        Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
Subject: [PATCH 1/1] For MPC831x the bus probing function needs the fixup to assign addresses to the PCI devices as it was for MPC85xx and MPC86xx. The fixup of the bridge vendor and device ID should be done early in PCI probing. Else the bridge is not detected as FIXUP_HEADER is called too late.
Date: Mon, 18 Mar 2013 17:50:36 +0400
Message-Id: <1363614636-1142-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
X-Mailer: git-send-email 1.7.10.4
X-OriginalArrivalTime: 18 Mar 2013 13:50:29.0906 (UTC) FILETIME=[8D813F20:01CE23DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
---
 arch/powerpc/sysdev/fsl_pci.c | 71 +++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 682084d..2e41a68 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -64,6 +64,34 @@ static int __init fsl_pcie_check_link(struct pci_controller *hose)
 	return 0;
 }
 
+void fsl_pcibios_fixup_bus(struct pci_bus *bus)
+{
+	struct pci_controller *hose = (struct pci_controller *) bus->sysdata;
+	int i;
+
+
+	if ((bus->parent == hose->bus)
+		&& ((fsl_pcie_bus_fixup
+			&& pci_bus_find_capability(bus, 0, PCI_CAP_ID_EXP))
+				|| (hose->indirect_type
+					& PPC_INDIRECT_TYPE_NO_PCIE_LINK))) {
+		for (i = 0; i < 4; ++i) {
+			struct resource *res = bus->resource[i];
+			struct resource *par = bus->parent->resource[i];
+			if (res) {
+				res->start = 0;
+				res->end   = 0;
+				res->flags = 0;
+			}
+			if (res && par) {
+				res->start = par->start;
+				res->end   = par->end;
+				res->flags = par->flags;
+			}
+		}
+	}
+}
+
 #if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
 
 #define MAX_PHYS_ADDR_BITS	40
@@ -384,42 +412,6 @@ static void __init setup_pci_cmd(struct pci_controller *hose)
 	}
 }
 
-void fsl_pcibios_fixup_bus(struct pci_bus *bus)
-{
-	struct pci_controller *hose = pci_bus_to_host(bus);
-	int i, is_pcie = 0, no_link;
-
-	/* The root complex bridge comes up with bogus resources,
-	 * we copy the PHB ones in.
-	 *
-	 * With the current generic PCI code, the PHB bus no longer
-	 * has bus->resource[0..4] set, so things are a bit more
-	 * tricky.
-	 */
-
-	if (fsl_pcie_bus_fixup)
-		is_pcie = early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP);
-	no_link = !!(hose->indirect_type & PPC_INDIRECT_TYPE_NO_PCIE_LINK);
-
-	if (bus->parent == hose->bus && (is_pcie || no_link)) {
-		for (i = 0; i < PCI_BRIDGE_RESOURCE_NUM; ++i) {
-			struct resource *res = bus->resource[i];
-			struct resource *par;
-
-			if (!res)
-				continue;
-			if (i == 0)
-				par = &hose->io_resource;
-			else if (i < 4)
-				par = &hose->mem_resources[i-1];
-			else par = NULL;
-
-			res->start = par ? par->start : 0;
-			res->end   = par ? par->end   : 0;
-			res->flags = par ? par->flags : 0;
-		}
-	}
-}
 
 int __init fsl_add_bridge(struct platform_device *pdev, int is_primary)
 {
@@ -515,7 +507,8 @@ no_bridge:
 }
 #endif /* CONFIG_FSL_SOC_BOOKE || CONFIG_PPC_86xx */
 
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID,
+	quirk_fsl_pcie_header);
 
 #if defined(CONFIG_PPC_83xx) || defined(CONFIG_PPC_MPC512x)
 struct mpc83xx_pcie_priv {
@@ -813,6 +806,10 @@ u64 fsl_pci_immrbar_base(struct pci_controller *hose)
 	}
 #endif
 
+
+
+
+
 #if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
 	if (!is_mpc83xx_pci) {
 		u32 base;
-- 
1.7.11.7

