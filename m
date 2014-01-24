Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbaAXIoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 03:44:23 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:37879 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaAXIoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 03:44:20 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v4 13/14] spi: rspi: Add DT support
Date: Fri, 24 Jan 2014 09:44:03 +0100
Message-Id: <1390553044-11860-14-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
References: <1390553044-11860-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: devicetree@vger.kernel.org
---
v2:
  - Clarify RSPI/QSPI
  - Add interrupt-parent
  - s/should/must/ for #address-cells and #size-cells
v3:
  - Add renesas,rspi-sh
  - Drop -rcar suffix for QSPI
  - Clarify num-cs
  - Implement DT support in driver
  - Changed one-line summary from "Documentation: dt: Add Renesas RSPI/QSPI
    bindings" to "spi: rspi: Add DT support"
v4:
  - Clarify SoCtype and interrupts
  - Add clock property
  - Add QSPI example
  - Add interrupt-names
  - Add link to Renesas pinctrl
  - Rename "renesas,rspi-sh" to "renesas,rspi", to match platform device
    naming
  - spi-rspi.c:
      - Remove Soc-specific matching from spi-rspi.c given the fallback is
	mandatory
      - Things became a lot simpler due to the replacement of platform_data
        fields by the "rspi-rz" platform device binding.
---
 Documentation/devicetree/bindings/spi/spi-rspi.txt |   58 +++++++++++
 drivers/spi/spi-rspi.c                             |  106 ++++++++++++++------
 2 files changed, 135 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-rspi.txt

diff --git a/Documentation/devicetree/bindings/spi/spi-rspi.txt b/Documentation/devicetree/bindings/spi/spi-rspi.txt
new file mode 100644
index 000000000000..ed84299a9c61
--- /dev/null
+++ b/Documentation/devicetree/bindings/spi/spi-rspi.txt
@@ -0,0 +1,58 @@
+Device tree configuration for Renesas RSPI/QSPI driver
+
+Required properties:
+- compatible       : For Renesas Serial Peripheral Interface on legacy SH:
+		     "renesas,rspi-<soctype>", "renesas,rspi" as fallback.
+		     For Renesas Serial Peripheral Interface on RZ/A1H:
+		     "renesas,rspi-<soctype>", "renesas,rspi-rz" as fallback.
+		     For Quad Serial Peripheral Interface on R-Car Gen2:
+		     "renesas,qspi-<soctype>", "renesas,qspi" as fallback.
+		     Examples of valid soctypes are "sh7757" (SH),
+		     "r7s72100" (RZ/A1H), "r8a7790" (R-Car H2), and
+		     "r8a7791" (R-Car M2).
+- reg              : Address start and address range size of the device
+- interrupts       : 1 interrupt for RSPI cores using a single multiplexed
+		     interrupt,
+		     3 interrupts (SPEI, SPRI, SPTI) for RSPI cores using
+		     separate interrupts.
+- interrupt-names  : Array of strings associated with the interrupt numbers:
+		     "error" for SPEI, "rx" for SPRI, and "tx" for SPTI.
+		     For RSPI cores using a single multiplexed interrupt, the
+		     name "mux" is optional.
+- interrupt-parent : The phandle for the interrupt controller that
+		     services interrupts for this device.
+- num-cs	   : Number of chip selects. Some RSPI cores have more than 1.
+- #address-cells   : Must be <1>
+- #size-cells      : Must be <0>
+
+Optional properties:
+- clocks:           : Must contain a reference to the functional clock.
+
+Pinctrl properties might be needed, too.  See
+Documentation/devicetree/bindings/pinctrl/renesas,*.
+
+Examples:
+
+	spi0: spi@e800c800 {
+		compatible = "renesas,rspi-r7s72100", "renesas,rspi-rz";
+		reg = <0xe800c800 0x24>;
+		interrupts = <0 238 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 239 IRQ_TYPE_LEVEL_HIGH>,
+			     <0 240 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "error", "rx", "tx";
+		interrupt-parent = <&gic>;
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
+
+	spi: spi@e6b10000 {
+		compatible = "renesas,qspi-r8a7791", "renesas,qspi";
+		reg = <0 0xe6b10000 0 0x2c>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp9_clks R8A7791_CLK_QSPI_MOD>;
+		num-cs = <1>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+	};
diff --git a/drivers/spi/spi-rspi.c b/drivers/spi/spi-rspi.c
index d79a7ed9b92e..e56fcb5f7f99 100644
--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -31,6 +31,7 @@
 #include <linux/clk.h>
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
+#include <linux/of_device.h>
 #include <linux/sh_dma.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/rspi.h>
@@ -985,6 +986,56 @@ static int rspi_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct spi_ops rspi_ops = {
+	.set_config_register =		rspi_set_config_register,
+	.transfer_one =			rspi_transfer_one,
+};
+
+static const struct spi_ops rspi_rz_ops = {
+	.set_config_register =		rspi_rz_set_config_register,
+	.transfer_one =			rspi_rz_transfer_one,
+};
+
+static const struct spi_ops qspi_ops = {
+	.set_config_register =		qspi_set_config_register,
+	.transfer_one =			qspi_transfer_one,
+};
+
+#ifdef CONFIG_OF
+static const struct of_device_id rspi_of_match[] = {
+	/* RSPI on legacy SH */
+	{ .compatible = "renesas,rspi", .data = &rspi_ops },
+	/* RSPI on RZ/A1H */
+	{ .compatible = "renesas,rspi-rz", .data = &rspi_rz_ops },
+	/* QSPI on R-Car Gen2 */
+	{ .compatible = "renesas,qspi", .data = &qspi_ops },
+	{ /* sentinel */ }
+};
+
+MODULE_DEVICE_TABLE(of, rspi_of_match);
+
+static int rspi_parse_dt(struct device *dev, struct spi_master *master)
+{
+	u32 num_cs;
+	int error;
+
+	/* Parse DT properties */
+	error = of_property_read_u32(dev->of_node, "num-cs", &num_cs);
+	if (error) {
+		dev_err(dev, "of_property_read_u32 num-cs failed %d\n", error);
+		return error;
+	}
+
+	master->num_chipselect = num_cs;
+	return 0;
+}
+#else
+static inline int rspi_parse_dt(struct device *dev, struct spi_master *master)
+{
+	return -EINVAL;
+}
+#endif /* CONFIG_OF */
+
 static int rspi_request_irq(struct device *dev, unsigned int irq,
 			    irq_handler_t handler, const char *suffix,
 			    void *dev_id)
@@ -1004,16 +1055,9 @@ static int rspi_probe(struct platform_device *pdev)
 	struct spi_master *master;
 	struct rspi_data *rspi;
 	int ret;
-	const struct rspi_plat_data *rspi_pd = dev_get_platdata(&pdev->dev);
+	const struct of_device_id *of_id;
+	const struct rspi_plat_data *rspi_pd;
 	const struct spi_ops *ops;
-	const struct platform_device_id *id_entry = pdev->id_entry;
-
-	ops = (struct spi_ops *)id_entry->driver_data;
-	/* ops parameter check */
-	if (!ops->set_config_register) {
-		dev_err(&pdev->dev, "there is no set_config_register\n");
-		return -ENODEV;
-	}
 
 	master = spi_alloc_master(&pdev->dev, sizeof(struct rspi_data));
 	if (master == NULL) {
@@ -1021,6 +1065,28 @@ static int rspi_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	of_id = of_match_device(rspi_of_match, &pdev->dev);
+	if (of_id) {
+		ops = of_id->data;
+		ret = rspi_parse_dt(&pdev->dev, master);
+		if (ret)
+			goto error1;
+	} else {
+		ops = (struct spi_ops *)pdev->id_entry->driver_data;
+		rspi_pd = dev_get_platdata(&pdev->dev);
+		if (rspi_pd && rspi_pd->num_chipselect)
+			master->num_chipselect = rspi_pd->num_chipselect;
+		else
+			master->num_chipselect = 2; /* default */
+	};
+
+	/* ops parameter check */
+	if (!ops->set_config_register) {
+		dev_err(&pdev->dev, "there is no set_config_register\n");
+		ret = -ENODEV;
+		goto error1;
+	}
+
 	rspi = spi_master_get_devdata(master);
 	platform_set_drvdata(pdev, rspi);
 	rspi->ops = ops;
@@ -1048,11 +1114,6 @@ static int rspi_probe(struct platform_device *pdev)
 
 	init_waitqueue_head(&rspi->wait);
 
-	if (rspi_pd && rspi_pd->num_chipselect)
-		master->num_chipselect = rspi_pd->num_chipselect;
-	else
-		master->num_chipselect = 2; /* default */
-
 	master->bus_num = pdev->id;
 	master->setup = rspi_setup;
 	master->transfer_one = ops->transfer_one;
@@ -1060,6 +1121,7 @@ static int rspi_probe(struct platform_device *pdev)
 	master->prepare_message = rspi_prepare_message;
 	master->unprepare_message = rspi_unprepare_message;
 	master->mode_bits = SPI_CPHA | SPI_CPOL | SPI_LOOP;
+	master->dev.of_node = pdev->dev.of_node;
 
 	ret = platform_get_irq_byname(pdev, "rx");
 	if (ret < 0) {
@@ -1122,21 +1184,6 @@ error1:
 	return ret;
 }
 
-static struct spi_ops rspi_ops = {
-	.set_config_register =		rspi_set_config_register,
-	.transfer_one =			rspi_transfer_one,
-};
-
-static struct spi_ops rspi_rz_ops = {
-	.set_config_register =		rspi_rz_set_config_register,
-	.transfer_one =			rspi_rz_transfer_one,
-};
-
-static struct spi_ops qspi_ops = {
-	.set_config_register =		qspi_set_config_register,
-	.transfer_one =			qspi_transfer_one,
-};
-
 static struct platform_device_id spi_driver_ids[] = {
 	{ "rspi",	(kernel_ulong_t)&rspi_ops },
 	{ "rspi-rz",	(kernel_ulong_t)&rspi_rz_ops },
@@ -1153,6 +1200,7 @@ static struct platform_driver rspi_driver = {
 	.driver		= {
 		.name = "renesas_spi",
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(rspi_of_match),
 	},
 };
 module_platform_driver(rspi_driver);
-- 
1.7.9.5

