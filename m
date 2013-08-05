Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3HEUoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:44:55 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50984 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755397Ab3HEUnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:10 -0400
Message-ID: <5d806e6622b33c80dc421025619fe574a121863d.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 15/20] tile PCI RC: use proper accessor function
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the low-level hv_dev_pread() API makes assumptions about the
layout of datastructures in the Tilera hypervisor API; it's better to
use the gxio_XXX accessor and the pcie_trio_ports_property struct.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 8352d85..de5008b 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -91,7 +91,7 @@ static int rc_delay[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 	TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT_G1
 
 /* Array of the PCIe ports configuration info obtained from the BIB. */
-struct pcie_port_property pcie_ports[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
+struct pcie_trio_ports_property pcie_ports[TILEGX_NUM_TRIO];
 
 /* Number of configured TRIO instances. */
 int num_trio_shims;
@@ -195,10 +195,7 @@ static int tile_pcie_open(int trio_index)
 #endif
 
 	/* Get the properties of the PCIe ports on this TRIO instance. */
-	ret = hv_dev_pread(context->fd, 0,
-		(HV_VirtAddr)&pcie_ports[trio_index][0],
-		sizeof(struct pcie_port_property) * TILEGX_TRIO_PCIES,
-		GXIO_TRIO_OP_GET_PORT_PROPERTY);
+	ret = gxio_trio_get_port_property(context, &pcie_ports[trio_index]);
 	if (ret < 0) {
 		pr_err("PCI: PCIE_GET_PORT_PROPERTY failure, error %d,"
 		       " on TRIO %d\n", ret, trio_index);
@@ -221,8 +218,8 @@ static int tile_pcie_open(int trio_index)
 		unsigned int reg_offset;
 
 		/* Ignore ports that are not specified in the BIB. */
-		if (!pcie_ports[trio_index][mac].allow_rc &&
-		    !pcie_ports[trio_index][mac].allow_ep)
+		if (!pcie_ports[trio_index].ports[mac].allow_rc &&
+		    !pcie_ports[trio_index].ports[mac].allow_ep)
 			continue;
 
 		reg_offset =
@@ -243,7 +240,7 @@ static int tile_pcie_open(int trio_index)
 			 */
 			if (port_config.strap_state == AUTO_CONFIG_EP ||
 			    port_config.strap_state == AUTO_CONFIG_EP_G1)
-				pcie_ports[trio_index][mac].allow_ep = 1;
+				pcie_ports[trio_index].ports[mac].allow_ep = 1;
 		}
 	}
 
@@ -438,9 +435,10 @@ int __init tile_pci_init(void)
 		return 0;
 
 	/*
-	 * Now determine which PCIe ports are configured to operate in RC mode.
-	 * We look at the Board Information Block first and then see if there
-	 * are any overriding configuration by the HW strapping pin.
+	 * Now determine which PCIe ports are configured to operate in RC
+	 * mode.  To use a port, it must be allowed to be in RC mode by the
+	 * Board Information Block, and the hardware strapping pins must be
+	 * set to RC mode.
 	 */
 	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
 		gxio_trio_context_t *context = &trio_contexts[i];
@@ -449,7 +447,7 @@ int __init tile_pci_init(void)
 			continue;
 
 		for (j = 0; j < TILEGX_TRIO_PCIES; j++) {
-			if (pcie_ports[i][j].allow_rc &&
+			if (pcie_ports[i].ports[j].allow_rc &&
 			    strapped_for_rc(context, j)) {
 				pcie_rc[i][j] = 1;
 				num_rc_controllers++;
@@ -736,7 +734,7 @@ int __init pcibios_init(void)
 			__gxio_mmio_read(trio_context->mmio_base_mac +
 					 reg_offset);
 		if (!port_status.dl_up) {
-			if (pcie_ports[trio_index][mac].removable) {
+			if (pcie_ports[trio_index].ports[mac].removable) {
 				pr_info("PCI: link is down, MAC %d on TRIO %d\n",
 					mac, trio_index);
 				pr_info("This is expected if no PCIe card"
-- 
1.8.3.1

