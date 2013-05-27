Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3E0Mly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 08:41:54 -0400
Received: from storage.astrosoft.ru ([195.218.158.6]:35089 "HELO
	storage.astrosoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932143Ab3E0Mlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 08:41:53 -0400
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 08:41:52 EDT
From: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Roy Zang <tie-fei.zang@freescale.com>,
        Jia Hongtao <B38951@freescale.com>, Li Yang <leoli@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
Subject: [PATCH 1/1] MPC831x: fix PCI express probing
Date: Mon, 27 May 2013 14:29:43 +0200
Message-Id: <1369657783-19962-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
X-Mailer: git-send-email 1.7.11.7
X-OriginalArrivalTime: 27 May 2013 12:29:53.0732 (UTC) FILETIME=[E3D62840:01CE5AD5]
X-MS-Antispam-Report: v=1.1 cv=2q6Veme4G/q3pcE5bdlzCS6ieJhnhBtyc6jHFX2NKno= c=1 sm=1 a=WvVkE4Vu0esA:10 a=X7gM1dXb2OgA:10 a=XuZcRw/agxWFXBge871Jfw==:17 a=QyVQ8uDMAAAA:8 a=o7LM9JJRffF_vSSh4eQA:9 a=gDFPXOgAOVMA:10 a=XuZcRw/agxWFXBge871Jfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For MPC831x the bus probing function also needs the fixup to assign
addresses to the PCI devices as it was for MPC85xx and MPC86xx.
The fixup of the bridge vendor and device ID should be done early in
PCI probing. Else the bridge is not detected as FIXUP_HEADER is called
too late.

Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
---
 arch/powerpc/sysdev/fsl_pci.c | 68 +++++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 028ac1f..94d1bd4 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -84,6 +84,34 @@ static int fsl_pcie_check_link(struct pci_controller *hose)
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
+			|| (hose->indirect_type
+				& PPC_INDIRECT_TYPE_NO_PCIE_LINK))) {
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
 static int fsl_indirect_read_config(struct pci_bus *bus, unsigned int devfn,
 				    int offset, int len, u32 *val)
 {
@@ -419,43 +447,6 @@ static void __init setup_pci_cmd(struct pci_controller *hose)
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
-
 int __init fsl_add_bridge(struct platform_device *pdev, int is_primary)
 {
 	int len;
@@ -562,7 +553,8 @@ no_bridge:
 }
 #endif /* CONFIG_FSL_SOC_BOOKE || CONFIG_PPC_86xx */
 
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID, quirk_fsl_pcie_header);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_FREESCALE, PCI_ANY_ID,
+	quirk_fsl_pcie_header);
 
 #if defined(CONFIG_PPC_83xx) || defined(CONFIG_PPC_MPC512x)
 struct mpc83xx_pcie_priv {
-- 
1.7.11.7

