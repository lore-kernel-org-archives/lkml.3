Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab3CYXAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 19:00:40 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:46774 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156Ab3CYXAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 19:00:37 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Enric Balletbo Serra" <eballetbo@gmail.com>,
        "Javier Martinez Canillas" <martinez.javier@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-omap@vger.kernel.org, ezequiel.garcia@free-electrons.com
Subject: [PATCH] spi: spi-omap2-mcspi.c: Add dts for slave device configuration.
Date: Tue, 26 Mar 2013 00:00:15 +0100
Message-Id: <1364252415-3613-1-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TI omap2 mcspi allows the slave devices to configure the behavior of
the SPI master. This patch adds device tree support to the existing
options.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 Documentation/devicetree/bindings/spi/omap-spi.txt | 23 ++++++++++++
 drivers/spi/spi-omap2-mcspi.c                      | 41 ++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/Documentation/devicetree/bindings/spi/omap-spi.txt b/Documentation/devicetree/bindings/spi/omap-spi.txt
index 938809c..fef16bf 100644
--- a/Documentation/devicetree/bindings/spi/omap-spi.txt
+++ b/Documentation/devicetree/bindings/spi/omap-spi.txt
@@ -10,8 +10,20 @@ Required properties:
 			  input. The default is D0 as input and
 			  D1 as output.
 
+SPI Controller specific data in SPI slave nodes:
+
+- The spi slave nodes can provide the following information which is used
+  by the spi controller.
+
+- ti,spi-cs-per-word: Set chipselect to be toggled on every word send.
+
+- ti,spi-turbo-mode: Set turbo mode for this device.
+
+
 Example:
 
+- SoC Specific Portion:
+
 mcspi1: mcspi@1 {
     #address-cells = <1>;
     #size-cells = <0>;
@@ -20,3 +32,14 @@ mcspi1: mcspi@1 {
     ti,spi-num-cs = <4>;
 };
 
+- Board Specific Portion:
+
+	spi-device@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		controller-data {
+			ti,spi-cs-per-word = <1>;
+			ti,spi-turbo-mode = <0>;
+		};
+	};
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 893c3d7..1ae5009 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -731,11 +731,47 @@ static u32 omap2_mcspi_calc_divisor(u32 speed_hz)
 	return 15;
 }
 
+static struct omap2_mcspi_device_config *omap2_mcspi_get_slave_ctrldata(
+			struct spi_device *spi)
+{
+	struct omap2_mcspi_device_config *cd;
+	struct device_node *slave_np, *data_np = NULL;
+
+	slave_np = spi->dev.of_node;
+	if (!slave_np) {
+		dev_err(&spi->dev, "device node not found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	data_np = of_get_child_by_name(slave_np, "controller-data");
+	if (!data_np) {
+		dev_err(&spi->dev, "child node 'controller-data' not found\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	cd = kzalloc(sizeof(*cd), GFP_KERNEL);
+	if (!cd) {
+		dev_err(&spi->dev, "could not allocate memory for controller data\n");
+		of_node_put(data_np);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	if (of_get_property(data_np, "ti,spi-cs-per-word", NULL))
+		cd->cs_per_word = 1;
+
+	if (of_get_property(data_np, "ti,spi-turbo-mode", NULL))
+		cd->turbo_mode = 1;
+
+	of_node_put(data_np);
+	return cd;
+}
+
 /* called only when no transfer is active to this device */
 static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 		struct spi_transfer *t)
 {
 	struct omap2_mcspi_cs *cs = spi->controller_state;
+	struct omap2_mcspi_device_config *cd = spi->controller_data;
 	struct omap2_mcspi *mcspi;
 	struct spi_master *spi_cntrl;
 	u32 l = 0, div = 0;
@@ -745,6 +781,11 @@ static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 	mcspi = spi_master_get_devdata(spi->master);
 	spi_cntrl = mcspi->master;
 
+	if (!cd && spi->dev.of_node) {
+		cd = omap2_mcspi_get_slave_ctrldata(spi);
+		spi->controller_data = cd;
+	}
+
 	if (t != NULL && t->bits_per_word)
 		word_len = t->bits_per_word;
 
-- 
1.7.11.7

