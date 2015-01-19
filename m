Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbbASPYP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 10:24:15 -0500
Received: from nivc-ms1.auriga.com ([80.240.102.146]:27577 "EHLO
	nivc-ms1.auriga.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbbASPYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:24:13 -0500
From: Aleksey Makarov <aleksey.makarov@auriga.com>
To: <linux-ide@vger.kernel.org>
CC: <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        Aleksey Makarov <aleksey.makarov@auriga.com>,
        "Anton Vorontsov" <avorontsov@ru.mvista.com>,
        Vinita Gupta <vgupta@caviumnetworks.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Ralf Baechle" <ralf@linux-mips.org>, Tejun Heo <tj@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>, <devicetree@vger.kernel.org>
Subject: [PATCH] SATA: OCTEON: support SATA on OCTEON platform
Date: Mon, 19 Jan 2015 18:23:58 +0300
Message-ID: <1421681040-3392-1-git-send-email-aleksey.makarov@auriga.com>
X-Mailer: git-send-email 2.2.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [80.240.102.213]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OCTEON SATA controller is currently found on cn71XX devices.

Signed-off-by: David Daney <david.daney@cavium.com>
Signed-off-by: Vinita Gupta <vgupta@caviumnetworks.com>
[aleksey.makarov@auriga.com: preparing for submission,
conflict resolution, fixes for the platform code]
Signed-off-by: Aleksey Makarov <aleksey.makarov@auriga.com>
---
 .../devicetree/bindings/ata/ahci-platform.txt      |   1 +
 .../devicetree/bindings/mips/cavium/sata-uctl.txt  |  31 ++++++
 arch/mips/cavium-octeon/octeon-platform.c          |   1 +
 drivers/ata/Kconfig                                |   9 ++
 drivers/ata/Makefile                               |   1 +
 drivers/ata/ahci_platform.c                        |  10 ++
 drivers/ata/sata_octeon.c                          | 107 +++++++++++++++++++++
 7 files changed, 160 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt
 create mode 100644 drivers/ata/sata_octeon.c

diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
index 4ab09f2..1a5d3be 100644
--- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -11,6 +11,7 @@ Required properties:
 - compatible        : compatible string, one of:
   - "allwinner,sun4i-a10-ahci"
   - "hisilicon,hisi-ahci"
+  - "cavium,octeon-7130-ahci"
   - "ibm,476gtr-ahci"
   - "marvell,armada-380-ahci"
   - "snps,dwc-ahci"
diff --git a/Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt b/Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt
new file mode 100644
index 0000000..222e66e
--- /dev/null
+++ b/Documentation/devicetree/bindings/mips/cavium/sata-uctl.txt
@@ -0,0 +1,31 @@
+* UCTL SATA controller glue
+
+Properties:
+- compatible: "cavium,octeon-7130-sata-uctl"
+
+  Compatibility with the cn7130 SOC.
+
+- reg: The base address of the UCTL register bank.
+
+- #address-cells: Must be <2>.
+
+- #size-cells: Must be <2>.
+
+- ranges: Empty to signify direct mapping of the children.
+
+Example:
+
+	uctl@118006c000000 {
+	        compatible = "cavium,octeon-7130-sata-uctl";
+	        reg = <0x00011800 0x6c000000 0x00000000 0x00000100>;
+	        ranges;
+	        #address-cells = <0x00000002>;
+	        #size-cells = <0x00000002>;
+	        sata@16c00 {
+	                compatible = "cavium,octeon-7130-ahci";
+	                reg = <0x00016c00 0x00000000 0x00000000 0x00000200>;
+	                interrupt-parent = <0x0000000d>;
+	                interrupts = <0x00000002 0x00000004>;
+	                cavium,qlm-trim-alias = "sata";
+	        };
+	};
diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index b67ddf0..6518231 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -445,6 +445,7 @@ static struct of_device_id __initdata octeon_ids[] = {
 	{ .compatible = "cavium,octeon-3860-bootbus", },
 	{ .compatible = "cavium,mdio-mux", },
 	{ .compatible = "gpio-leds", },
+	{ .compatible = "cavium,octeon-7130-sata-uctl", },
 	{},
 };
 
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a3a1360..28a11fe 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -188,6 +188,15 @@ config SATA_SIL24
 
 	  If unsure, say N.
 
+config SATA_OCTEON
+	tristate "Cavium Octeon Soc Serial ATA"
+	depends on SATA_AHCI_PLATFORM && CAVIUM_OCTEON_SOC
+	default y
+	help
+	  This option enables support for Cavium Octeon SoC Serial ATA.
+
+	  If unsure, say N.
+
 config ATA_SFF
 	bool "ATA SFF support (for legacy IDE and PATA)"
 	default y
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index ae41107..4a0e5e3 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_ST)		+= ahci_st.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_TEGRA)	+= ahci_tegra.o libahci.o libahci_platform.o
 obj-$(CONFIG_AHCI_XGENE)	+= ahci_xgene.o libahci.o libahci_platform.o
+obj-$(CONFIG_SATA_OCTEON)	+= sata_octeon.o
 
 # SFF w/ custom DMA
 obj-$(CONFIG_PDC_ADMA)		+= pdc_adma.o
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 18d5398..bb36396 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -22,6 +22,12 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
+#if IS_ENABLED(CONFIG_SATA_OCTEON)
+void ahci_octeon_config(struct platform_device *pdev);
+#else
+static inline void ahci_octeon_config(struct platform_device *pdev) {}
+#endif
+
 static const struct ata_port_info ahci_port_info = {
 	.flags		= AHCI_FLAG_COMMON,
 	.pio_mask	= ATA_PIO4,
@@ -46,6 +52,9 @@ static int ahci_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
+	if (of_device_is_compatible(dev->of_node, "cavium,octeon-7130-ahci"))
+		ahci_octeon_config(pdev);
+
 	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info);
 	if (rc)
 		goto disable_resources;
@@ -67,6 +76,7 @@ static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "ibm,476gtr-ahci", },
 	{ .compatible = "snps,dwc-ahci", },
 	{ .compatible = "hisilicon,hisi-ahci", },
+	{ .compatible = "cavium,octeon-7130-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
diff --git a/drivers/ata/sata_octeon.c b/drivers/ata/sata_octeon.c
new file mode 100644
index 0000000..e24cc27
--- /dev/null
+++ b/drivers/ata/sata_octeon.c
@@ -0,0 +1,107 @@
+/*
+ * SATA glue for Cavium Octeon III SOCs.
+ *
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2010-2015 Cavium Networks
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/dma-mapping.h>
+#include <linux/platform_device.h>
+
+#include <asm/octeon/octeon.h>
+#include <asm/bitfield.h>
+
+/**
+ * cvmx_sata_uctl_shim_cfg
+ * from cvmx-sata-defs.h
+ *
+ * Accessible by: only when A_CLKDIV_EN
+ * Reset by: IOI reset (srst_n) or SATA_UCTL_CTL[SATA_UCTL_RST]
+ * This register allows configuration of various shim (UCTL) features.
+ * Fields XS_NCB_OOB_* are captured when there are no outstanding OOB errors
+ * indicated in INTSTAT and a new OOB error arrives.
+ * Fields XS_BAD_DMA_* are captured when there are no outstanding DMA errors
+ * indicated in INTSTAT and a new DMA error arrives.
+ */
+union cvmx_sata_uctl_shim_cfg {
+	uint64_t u64;
+	struct cvmx_sata_uctl_shim_cfg_s {
+	/*
+	 * Read/write error log for out-of-bound UAHC register access.
+	 * 0 = read, 1 = write.
+	 */
+	__BITFIELD_FIELD(uint64_t xs_ncb_oob_wrn               : 1,
+	__BITFIELD_FIELD(uint64_t reserved_57_62               : 6,
+	/*
+	 * SRCID error log for out-of-bound UAHC register access.
+	 * The IOI outbound SRCID for the OOB error.
+	 */
+	__BITFIELD_FIELD(uint64_t xs_ncb_oob_osrc              : 9,
+	/*
+	 * Read/write error log for bad DMA access from UAHC.
+	 * 0 = read error log, 1 = write error log.
+	 */
+	__BITFIELD_FIELD(uint64_t xm_bad_dma_wrn               : 1,
+	__BITFIELD_FIELD(uint64_t reserved_44_46               : 3,
+	/*
+	 * ErrType error log for bad DMA access from UAHC. Encodes the type of
+	 * error encountered (error largest encoded value has priority).
+	 * See SATA_UCTL_XM_BAD_DMA_TYPE_E.
+	 */
+	__BITFIELD_FIELD(uint64_t xm_bad_dma_type              : 4,
+	__BITFIELD_FIELD(uint64_t reserved_13_39               : 27,
+	/*
+	 * Selects the IOI read command used by DMA accesses.
+	 * See SATA_UCTL_DMA_READ_CMD_E.
+	 */
+	__BITFIELD_FIELD(uint64_t dma_read_cmd                 : 1,
+	__BITFIELD_FIELD(uint64_t reserved_10_11               : 2,
+	/*
+	 * Selects the endian format for DMA accesses to the L2C.
+	 * See SATA_UCTL_ENDIAN_MODE_E.
+	 */
+	__BITFIELD_FIELD(uint64_t dma_endian_mode              : 2,
+	__BITFIELD_FIELD(uint64_t reserved_2_7                 : 6,
+	/*
+	 * Selects the endian format for IOI CSR accesses to the UAHC.
+	 * Note that when UAHC CSRs are accessed via RSL, they are returned
+	 * as big-endian. See SATA_UCTL_ENDIAN_MODE_E.
+	 */
+	__BITFIELD_FIELD(uint64_t csr_endian_mode              : 2,
+		;))))))))))))
+	} s;
+};
+
+#define CVMX_SATA_UCTL_SHIM_CFG (CVMX_ADD_IO_SEG(0x000118006C0000E8ull))
+
+void ahci_octeon_config(struct platform_device *pdev)
+{
+	union cvmx_sata_uctl_shim_cfg shim_cfg;
+
+	/* set-up endian mode */
+	shim_cfg.u64 = cvmx_read_csr(CVMX_SATA_UCTL_SHIM_CFG);
+#ifdef __BIG_ENDIAN
+	shim_cfg.s.dma_endian_mode = 1;
+	shim_cfg.s.csr_endian_mode = 1;
+#else
+	shim_cfg.s.dma_endian_mode = 0;
+	shim_cfg.s.csr_endian_mode = 0;
+#endif
+	shim_cfg.s.dma_read_cmd = 1; /* No allocate L2C */
+	cvmx_write_csr(CVMX_SATA_UCTL_SHIM_CFG, shim_cfg.u64);
+
+	/* Set a good dma_mask */
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(64);
+	pdev->dev.dma_mask = &pdev->dev.coherent_dma_mask;
+}
+EXPORT_SYMBOL(ahci_octeon_config);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Cavium, Inc. <support@cavium.com>");
+MODULE_DESCRIPTION("Cavium Inc. sata config.");
-- 
2.2.2

