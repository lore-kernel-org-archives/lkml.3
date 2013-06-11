Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3FKUHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:07:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827Ab3FKUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 66/79] powerpc/pseries: Perform proper max_bus_speed detection
Date: Tue, 11 Jun 2013 13:03:32 -0700
Message-Id: <20130611195324.738144481@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>

commit d82fb31abc46620b7c22758c75707069f2763646 upstream.

On pseries machines the detection for max_bus_speed should be done
through an OpenFirmware property. This patch adds a function to perform
this detection and a hook to perform dynamic adding of the function only
for pseries. This is done by overwriting the weak
pcibios_root_bridge_prepare function which is called by
pci_create_root_bus().

From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/machdep.h       |    3 +
 arch/powerpc/kernel/pci-common.c         |    8 ++++
 arch/powerpc/platforms/pseries/pci.c     |   53 +++++++++++++++++++++++++++++++
 arch/powerpc/platforms/pseries/pseries.h |    4 ++
 arch/powerpc/platforms/pseries/setup.c   |    2 +
 5 files changed, 70 insertions(+)

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
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -845,6 +845,14 @@ int pci_proc_domain(struct pci_bus *bus)
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
--- a/arch/powerpc/platforms/pseries/pci.c
+++ b/arch/powerpc/platforms/pseries/pci.c
@@ -108,3 +108,56 @@ static void fixup_winbond_82c105(struct
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
--- a/arch/powerpc/platforms/pseries/pseries.h
+++ b/arch/powerpc/platforms/pseries/pseries.h
@@ -60,4 +60,8 @@ extern int dlpar_detach_node(struct devi
 /* Snooze Delay, pseries_idle */
 DECLARE_PER_CPU(long, smt_snooze_delay);
 
+/* PCI root bridge prepare function override for pseries */
+struct pci_host_bridge;
+int pseries_root_bridge_prepare(struct pci_host_bridge *bridge);
+
 #endif /* _PSERIES_PSERIES_H */
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -466,6 +466,8 @@ static void __init pSeries_setup_arch(vo
 	else
 		ppc_md.enable_pmcs = power4_enable_pmcs;
 
+	ppc_md.pcibios_root_bridge_prepare = pseries_root_bridge_prepare;
+
 	if (firmware_has_feature(FW_FEATURE_SET_MODE)) {
 		long rc;
 		if ((rc = pSeries_enable_reloc_on_exc()) != H_SUCCESS) {


