Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab3HEUnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:43:04 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50980 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HEUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:00 -0400
Message-ID: <9248037ae3be6b38790864f958af051ed8ae87f4.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 11/20] tile PCI RC: restructure TRIO initialization
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRIO shim initialization is shared with other kernel drivers
such as the endpoint and StreamIO drivers, so reorganize the
initialization flow to ensure that the root complex driver properly
initializes TRIO state regardless of what kind of TRIO driver will
end up using the shim.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/pci.h |   1 +
 arch/tile/kernel/pci_gx.c   | 209 +++++++++++++++++++++++++-------------------
 2 files changed, 118 insertions(+), 92 deletions(-)

diff --git a/arch/tile/include/asm/pci.h b/arch/tile/include/asm/pci.h
index 9cf5308..1f1b654 100644
--- a/arch/tile/include/asm/pci.h
+++ b/arch/tile/include/asm/pci.h
@@ -180,6 +180,7 @@ struct pci_controller {
 
 extern struct pci_controller pci_controllers[TILEGX_NUM_TRIO * TILEGX_TRIO_PCIES];
 extern gxio_trio_context_t trio_contexts[TILEGX_NUM_TRIO];
+extern int num_trio_shims;
 
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index fde3589..8051638 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -80,16 +80,28 @@ static int rc_delay[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 /* The PCI I/O space size in each PCI domain. */
 #define IO_SPACE_SIZE		0x10000
 
+/* Provide shorter versions of some very long constant names. */
+#define AUTO_CONFIG_RC	\
+	TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC
+#define AUTO_CONFIG_RC_G1	\
+	TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC_G1
+#define AUTO_CONFIG_EP	\
+	TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT
+#define AUTO_CONFIG_EP_G1	\
+	TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT_G1
+
 /* Array of the PCIe ports configuration info obtained from the BIB. */
 struct pcie_port_property pcie_ports[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 
+/* Number of configured TRIO instances. */
+int num_trio_shims;
+
 /* All drivers share the TRIO contexts defined here. */
 gxio_trio_context_t trio_contexts[TILEGX_NUM_TRIO];
 
 /* Pointer to an array of PCIe RC controllers. */
 struct pci_controller pci_controllers[TILEGX_NUM_TRIO * TILEGX_TRIO_PCIES];
 int num_rc_controllers;
-static int num_ep_controllers;
 
 static struct pci_ops tile_cfg_ops;
 
@@ -141,13 +153,14 @@ static int tile_pcie_open(int trio_index)
 {
 	gxio_trio_context_t *context = &trio_contexts[trio_index];
 	int ret;
+	int mac;
 
 	/*
 	 * This opens a file descriptor to the TRIO shim.
 	 */
 	ret = gxio_trio_init(context, trio_index);
 	if (ret < 0)
-		return ret;
+		goto gxio_trio_init_failure;
 
 	/*
 	 * Allocate an ASID for the kernel.
@@ -189,17 +202,89 @@ static int tile_pcie_open(int trio_index)
 	}
 #endif
 
+	/* Get the properties of the PCIe ports on this TRIO instance. */
+	ret = hv_dev_pread(context->fd, 0,
+		(HV_VirtAddr)&pcie_ports[trio_index][0],
+		sizeof(struct pcie_port_property) * TILEGX_TRIO_PCIES,
+		GXIO_TRIO_OP_GET_PORT_PROPERTY);
+	if (ret < 0) {
+		pr_err("PCI: PCIE_GET_PORT_PROPERTY failure, error %d,"
+		       " on TRIO %d\n", ret, trio_index);
+		goto get_port_property_failure;
+	}
+
+	context->mmio_base_mac =
+		iorpc_ioremap(context->fd, 0, HV_TRIO_CONFIG_IOREMAP_SIZE);
+	if (context->mmio_base_mac == NULL) {
+		pr_err("PCI: TRIO config space mapping failure, error %d,"
+		       " on TRIO %d\n", ret, trio_index);
+		ret = -ENOMEM;
+
+		goto trio_mmio_mapping_failure;
+	}
+
+	/* Check the port strap state which will override the BIB setting. */
+	for (mac = 0; mac < TILEGX_TRIO_PCIES; mac++) {
+		TRIO_PCIE_INTFC_PORT_CONFIG_t port_config;
+		unsigned int reg_offset;
+
+		/* Ignore ports that are not specified in the BIB. */
+		if (!pcie_ports[trio_index][mac].allow_rc &&
+		    !pcie_ports[trio_index][mac].allow_ep)
+			continue;
+
+		reg_offset =
+			(TRIO_PCIE_INTFC_PORT_CONFIG <<
+				TRIO_CFG_REGION_ADDR__REG_SHIFT) |
+			(TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
+				TRIO_CFG_REGION_ADDR__INTFC_SHIFT) |
+			(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
+
+		port_config.word =
+			__gxio_mmio_read(context->mmio_base_mac + reg_offset);
+
+		if (port_config.strap_state != AUTO_CONFIG_RC &&
+		    port_config.strap_state != AUTO_CONFIG_RC_G1) {
+			/*
+			 * If this is really intended to be an EP port, record
+			 * it so that the endpoint driver will know about it.
+			 */
+			if (port_config.strap_state == AUTO_CONFIG_EP ||
+			    port_config.strap_state == AUTO_CONFIG_EP_G1)
+				pcie_ports[trio_index][mac].allow_ep = 1;
+		}
+	}
+
 	return ret;
 
+trio_mmio_mapping_failure:
+get_port_property_failure:
 asid_alloc_failure:
 #ifdef USE_SHARED_PCIE_CONFIG_REGION
 pio_alloc_failure:
 #endif
 	hv_dev_close(context->fd);
+gxio_trio_init_failure:
+	context->fd = -1;
 
 	return ret;
 }
 
+static int __init tile_trio_init(void)
+{
+	int i;
+
+	/* We loop over all the TRIO shims. */
+	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
+		if (tile_pcie_open(i) < 0)
+			continue;
+		num_trio_shims++;
+	}
+
+	return 0;
+}
+postcore_initcall(tile_trio_init);
+
 static void
 tilegx_legacy_irq_ack(struct irq_data *d)
 {
@@ -320,14 +405,39 @@ free_irqs:
 }
 
 /*
+ * Return 1 if the port is strapped to operate in RC mode.
+ */
+static int
+strapped_for_rc(gxio_trio_context_t *trio_context, int mac)
+{
+	TRIO_PCIE_INTFC_PORT_CONFIG_t port_config;
+	unsigned int reg_offset;
+
+	/* Check the port configuration. */
+	reg_offset =
+		(TRIO_PCIE_INTFC_PORT_CONFIG <<
+			TRIO_CFG_REGION_ADDR__REG_SHIFT) |
+		(TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
+			TRIO_CFG_REGION_ADDR__INTFC_SHIFT) |
+		(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
+	port_config.word =
+		__gxio_mmio_read(trio_context->mmio_base_mac + reg_offset);
+
+	if (port_config.strap_state == AUTO_CONFIG_RC ||
+	    port_config.strap_state == AUTO_CONFIG_RC_G1)
+		return 1;
+	else
+		return 0;
+}
+
+/*
  * Find valid controllers and fill in pci_controller structs for each
  * of them.
  *
- * Returns the number of controllers discovered.
+ * Return the number of controllers discovered.
  */
 int __init tile_pci_init(void)
 {
-	int num_trio_shims = 0;
 	int ctl_index = 0;
 	int i, j;
 
@@ -338,19 +448,6 @@ int __init tile_pci_init(void)
 
 	pr_info("PCI: Searching for controllers...\n");
 
-	/*
-	 * We loop over all the TRIO shims.
-	 */
-	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
-		int ret;
-
-		ret = tile_pcie_open(i);
-		if (ret < 0)
-			continue;
-
-		num_trio_shims++;
-	}
-
 	if (num_trio_shims == 0 || sim_is_simulator())
 		return 0;
 
@@ -361,29 +458,16 @@ int __init tile_pci_init(void)
 	 */
 	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
 		gxio_trio_context_t *context = &trio_contexts[i];
-		int ret;
 
 		if (context->fd < 0)
 			continue;
 
-		ret = hv_dev_pread(context->fd, 0,
-			(HV_VirtAddr)&pcie_ports[i][0],
-			sizeof(struct pcie_port_property) * TILEGX_TRIO_PCIES,
-			GXIO_TRIO_OP_GET_PORT_PROPERTY);
-		if (ret < 0) {
-			pr_err("PCI: PCIE_GET_PORT_PROPERTY failure, error %d,"
-				" on TRIO %d\n", ret, i);
-			continue;
-		}
-
 		for (j = 0; j < TILEGX_TRIO_PCIES; j++) {
-			if (pcie_ports[i][j].allow_rc) {
+			if (pcie_ports[i][j].allow_rc &&
+			    strapped_for_rc(context, j)) {
 				pcie_rc[i][j] = 1;
 				num_rc_controllers++;
 			}
-			else if (pcie_ports[i][j].allow_ep) {
-				num_ep_controllers++;
-			}
 		}
 	}
 
@@ -600,35 +684,10 @@ int __init pcibios_init(void)
 
 	tile_pci_init();
 
-	if (num_rc_controllers == 0 && num_ep_controllers == 0)
+	if (num_rc_controllers == 0)
 		return 0;
 
 	/*
-	 * We loop over all the TRIO shims and set up the MMIO mappings.
-	 */
-	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
-		gxio_trio_context_t *context = &trio_contexts[i];
-
-		if (context->fd < 0)
-			continue;
-
-		/*
-		 * Map in the MMIO space for the MAC.
-		 */
-		offset = 0;
-		context->mmio_base_mac =
-			iorpc_ioremap(context->fd, offset,
-				      HV_TRIO_CONFIG_IOREMAP_SIZE);
-		if (context->mmio_base_mac == NULL) {
-			pr_err("PCI: MAC map failure on TRIO %d\n", i);
-
-			hv_dev_close(context->fd);
-			context->fd = -1;
-			continue;
-		}
-	}
-
-	/*
 	 * Delay a bit in case devices aren't ready.  Some devices are
 	 * known to require at least 20ms here, but we use a more
 	 * conservative value.
@@ -639,7 +698,6 @@ int __init pcibios_init(void)
 	for (next_busno = 0, i = 0; i < num_rc_controllers; i++) {
 		struct pci_controller *controller = &pci_controllers[i];
 		gxio_trio_context_t *trio_context = controller->trio;
-		TRIO_PCIE_INTFC_PORT_CONFIG_t port_config;
 		TRIO_PCIE_INTFC_PORT_STATUS_t port_status;
 		TRIO_PCIE_INTFC_TX_FIFO_CTL_t tx_fifo_ctl;
 		struct pci_bus *bus;
@@ -656,39 +714,6 @@ int __init pcibios_init(void)
 		mac = controller->mac;
 
 		/*
-		 * Check the port strap state which will override the BIB
-		 * setting.
-		 */
-
-		reg_offset =
-			(TRIO_PCIE_INTFC_PORT_CONFIG <<
-				TRIO_CFG_REGION_ADDR__REG_SHIFT) |
-			(TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
-				TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
-			(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
-
-		port_config.word =
-			__gxio_mmio_read(trio_context->mmio_base_mac +
-					 reg_offset);
-
-		if ((port_config.strap_state !=
-			TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC) &&
-			(port_config.strap_state !=
-			TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC_G1)) {
-			/*
-			 * If this is really intended to be an EP port,
-			 * record it so that the endpoint driver will know about it.
-			 */
-			if (port_config.strap_state ==
-			TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT ||
-			port_config.strap_state ==
-			TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT_G1)
-				pcie_ports[trio_index][mac].allow_ep = 1;
-
-			continue;
-		}
-
-		/*
 		 * Check for PCIe link-up status to decide if we need
 		 * to force the link to come up.
 		 */
-- 
1.8.3.1

