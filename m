Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3FELkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 07:40:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37973 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147Ab3FELkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 07:40:18 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>, Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>
Subject: [PATCH 1/2] spi: spi-omap2-mcspi.c: Add dts for slave device configuration.
Date: Wed, 5 Jun 2013 14:39:57 +0300
Message-ID: <1370432398-7796-2-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Brugger <matthias.bgg@gmail.com>

TI omap2 mcspi allows the slave devices to configure the behavior of
the SPI master. This patch adds device tree support to the existing
options.

[Illia: added changes discussed at
https://patchwork.kernel.org/patch/2333911/]

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
---
 Documentation/devicetree/bindings/spi/omap-spi.txt |   17 ++++++++
 drivers/spi/spi-omap2-mcspi.c                      |   40 ++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/omap-spi.txt b/Documentation/devicetree/bindings/spi/omap-spi.txt
index 938809c..87b2841 100644
--- a/Documentation/devicetree/bindings/spi/omap-spi.txt
+++ b/Documentation/devicetree/bindings/spi/omap-spi.txt
@@ -10,8 +10,15 @@ Required properties:
 			  input. The default is D0 as input and
 			  D1 as output.
 
+SPI Controller specific data in SPI slave nodes:
+- The spi slave nodes can provide the following information which is used
+  by the spi controller:
+  - ti,spi-turbo-mode: Set turbo mode for this device.
+
 Example:
 
+- SoC Specific Portion:
+
 mcspi1: mcspi@1 {
     #address-cells = <1>;
     #size-cells = <0>;
@@ -20,3 +27,13 @@ mcspi1: mcspi@1 {
     ti,spi-num-cs = <4>;
 };
 
+- Board Specific Portion:
+
+	spi-device@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		controller-data {
+			ti,spi-turbo-mode;
+		};
+	};
diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 86d2158..67d0409 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -735,6 +735,38 @@ static u32 omap2_mcspi_calc_divisor(u32 speed_hz)
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
+	if (of_find_property(data_np, "ti,spi-turbo-mode", NULL))
+		cd->turbo_mode = 1;
+
+	of_node_put(data_np);
+	return cd;
+}
+
 /* called only when no transfer is active to this device */
 static int omap2_mcspi_setup_transfer(struct spi_device *spi,
 		struct spi_transfer *t)
@@ -856,6 +888,11 @@ static int omap2_mcspi_setup(struct spi_device *spi)
 	struct omap2_mcspi_regs	*ctx = &mcspi->ctx;
 	struct omap2_mcspi_dma	*mcspi_dma;
 	struct omap2_mcspi_cs	*cs = spi->controller_state;
+	struct omap2_mcspi_device_config *cd;
+
+	if (spi->dev.of_node)
+		spi->controller_data = omap2_mcspi_get_slave_ctrldata(spi);
+	cd = spi->controller_data;
 
 	if (spi->bits_per_word < 4 || spi->bits_per_word > 32) {
 		dev_dbg(&spi->dev, "setup: unsupported %d bit words\n",
@@ -902,6 +939,9 @@ static void omap2_mcspi_cleanup(struct spi_device *spi)
 
 	mcspi = spi_master_get_devdata(spi->master);
 
+	if (spi->dev.of_node && spi->controller_data)
+		kfree(spi->controller_data);
+
 	if (spi->controller_state) {
 		/* Unlink controller state from context save list */
 		cs = spi->controller_state;
-- 
1.7.0.4

