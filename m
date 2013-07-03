Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab3GCTK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:10:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33334 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964960Ab3GCTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:25 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=pemasO0rU-IA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=gPntw-wNL_0A:10 a=VnNF1IyMAAAA:8 a=wMNdZWldAAAA:8 a=BN9_AadSUIzlny2J81kA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.144246821@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [105/141] powerpc/pseries: Perform proper max_bus_speed detection
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0105-powerpc-pseries-Perform-proper-max_bus_speed-detecti.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

[ Upstream commit d82fb31abc46620b7c22758c75707069f2763646 ]

On pseries machines the detection for max_bus_speed should be done
through an OpenFirmware property. This patch adds a function to perform
this detection and a hook to perform dynamic adding of the function only
for pseries. This is done by overwriting the weak
pcibios_root_bridge_prepare function which is called by
pci_create_root_bus().

From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/machdep.h       |    3 ++
 arch/powerpc/kernel/pci-common.c         |    8 +++++
 arch/powerpc/platforms/pseries/pci.c     |   53 ++++++++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h |    4 +++
 arch/powerpc/platforms/pseries/setup.c   |    3 ++
 5 files changed, 71 insertions(+)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 42ce570..fd23013 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -29,6 +29,7 @@ struct rtc_time;
 struct file;
 struct pci_controller;
 struct kimage;
+struct pci_host_bridge;
 
 struct machdep_calls {
 	char		*name;
@@ -107,6 +108,8 @@ struct machdep_calls {
 	void		(*pcibios_fixup)(void);
 	int		(*pci_probe_mode)(struct pci_bus *);
 	void		(*pci_irq_fixup)(struct pci_dev *dev);
+	int		(*pcibios_root_bridge_prepare)(struct pci_host_bridge
+				*bridge);
 
 	/* To setup PHBs when using automatic OF platform driver for PCI */
 	int		(*pci_setup_phb)(struct pci_controller *host);
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 51ecf87..6fe4341 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -826,6 +826,14 @@ int pci_proc_domain(struct pci_bus *bus)
 	return 1;
 }
 
+int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	if (ppc_md.pcibios_root_bridge_prepare)
+		return ppc_md.pcibios_root_bridge_prepare(bridge);
+
+	return 0;
+}
+
 /* This header fixup will do the resource fixup for all devices as they are
  * probed, but not for bridge ranges
  */
diff --git a/arch/powerpc/platforms/pseries/pci.c b/arch/powerpc/platforms/pseries/pci.c
index 2c6ded2..7f6f556 100644
--- a/arch/powerpc/platforms/pseries/pci.c
+++ b/arch/powerpc/platforms/pseries/pci.c
@@ -107,3 +107,56 @@ static void fixup_winbond_82c105(struct pci_dev* dev)
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WINBOND, PCI_DEVICE_ID_WINBOND_82C105,
 			 fixup_winbond_82c105);
+
+int pseries_root_bridge_prepare(struct pci_host_bridge *bridge)
+{
+	struct device_node *dn, *pdn;
+	struct pci_bus *bus;
+	const uint32_t *pcie_link_speed_stats;
+
+	bus = bridge->bus;
+
+	dn = pcibios_get_phb_of_node(bus);
+	if (!dn)
+		return 0;
+
+	for (pdn = dn; pdn != NULL; pdn = of_get_next_parent(pdn)) {
+		pcie_link_speed_stats = (const uint32_t *) of_get_property(pdn,
+			"ibm,pcie-link-speed-stats", NULL);
+		if (pcie_link_speed_stats)
+			break;
+	}
+
+	of_node_put(pdn);
+
+	if (!pcie_link_speed_stats) {
+		pr_err("no ibm,pcie-link-speed-stats property\n");
+		return 0;
+	}
+
+	switch (pcie_link_speed_stats[0]) {
+	case 0x01:
+		bus->max_bus_speed = PCIE_SPEED_2_5GT;
+		break;
+	case 0x02:
+		bus->max_bus_speed = PCIE_SPEED_5_0GT;
+		break;
+	default:
+		bus->max_bus_speed = PCI_SPEED_UNKNOWN;
+		break;
+	}
+
+	switch (pcie_link_speed_stats[1]) {
+	case 0x01:
+		bus->cur_bus_speed = PCIE_SPEED_2_5GT;
+		break;
+	case 0x02:
+		bus->cur_bus_speed = PCIE_SPEED_5_0GT;
+		break;
+	default:
+		bus->cur_bus_speed = PCI_SPEED_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
diff --git a/arch/powerpc/platforms/pseries/pseries.h b/arch/powerpc/platforms/pseries/pseries.h
index 9a3dda0..b79393d 100644
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -60,4 +60,8 @@ extern int dlpar_detach_node(struct device_node *);
 /* Snooze Delay, pseries_idle */
 DECLARE_PER_CPU(long, smt_snooze_delay);
 
+/* PCI root bridge prepare function override for pseries */
+struct pci_host_bridge;
+int pseries_root_bridge_prepare(struct pci_host_bridge *bridge);
+
 #endif /* _PSERIES_PSERIES_H */
diff --git a/arch/powerpc/platforms/pseries/setup.c b/arch/powerpc/platforms/pseries/setup.c
index 51ecac9..5f01342 100644
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -404,6 +404,9 @@ static void __init pSeries_setup_arch(void)
 		ppc_md.enable_pmcs = pseries_lpar_enable_pmcs;
 	else
 		ppc_md.enable_pmcs = power4_enable_pmcs;
+
+	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+
 }
 
 static int __init pSeries_init_panel(void)
-- 
1.7.10.4


