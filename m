Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757588Ab3BOSWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 13:22:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50038 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3BOSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 13:22:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, spi-devel-general@lists.sourceforge.net,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [PATCH 3/4] spi: pl022: use generic DMA slave configuration if possible
Date: Fri, 15 Feb 2013 19:21:51 +0100
Message-Id: <1360952512-971558-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360952512-971558-1-git-send-email-arnd@arndb.de>
References: <1360952512-971558-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:1Y8YwAo9XKR2838KQY5frN7jYmLCxk+I5Xon4Y8I5bG
 lW7iRC/00bWPk7Sv2bLmQEFAANEKfveIAK0mngugjSd9u6S1/D
 rDljUUz+P1ycgQJSJOGEeYnzo8b0Oko7lF9CehGx+6r34/v7Kj
 RzYMsR0xjNKiYUSotYGvRPIJSt/rsR+hFjf09PLUyrpNvBYA4z
 APE7eGjQwMaRiGNAVm+YPOeE8fsBfOT/5voH1yT7NcUj7jC0rA
 gjFsNU0fFKaocYsHdV0yoR+9CCsnBD+2KfhbgNR4lVPYZ+OFdZ
 NrNvV/tdSD9UwAeS1GZsKPxXv7kEeKoB8r5PxjlQGGXci3MIcK
 A+81RdqVKm5mBIlPFOHuXnfAAqzmICeibd4ur8fnJ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new OF DMA binding, it is possible to completely avoid the
need for platform_data for configuring a DMA channel. In cases where the
platform has already been converted, calling dma_request_slave_channel
should get all the necessary information from the device tree.

Like the patch that converts the dw_dma controller, this is completely
untested and is looking for someone to try it out.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: spi-devel-general@lists.sourceforge.net
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org
---
 .../devicetree/bindings/spi/spi_pl022.txt          | 36 ++++++++++++++++++
 drivers/spi/spi-pl022.c                            | 43 +++++++++++++++++++++-
 2 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi_pl022.txt b/Documentation/devicetree/bindings/spi/spi_pl022.txt
index f158fd3..22ed679 100644
--- a/Documentation/devicetree/bindings/spi/spi_pl022.txt
+++ b/Documentation/devicetree/bindings/spi/spi_pl022.txt
@@ -16,6 +16,11 @@ Optional properties:
                             device will be suspended immediately
 - pl022,rt : indicates the controller should run the message pump with realtime
              priority to minimise the transfer latency on the bus (boolean)
+- dmas : Two or more DMA channel specifiers following the convention outlined
+         in bindings/dma/dma.txt
+- dma-names: Names for the dma channels, if present. There must be at
+	     least one channel named "tx" for transmit and named "rx" for
+             receive.
 
 
 SPI slave nodes must be children of the SPI master node and can
@@ -32,3 +37,34 @@ contain the following properties.
 - pl022,wait-state : Microwire interface: Wait state
 - pl022,duplex : Microwire interface: Full/Half duplex
 
+
+Example:
+
+	spi@e0100000 {
+		compatible = "arm,pl022", "arm,primecell";
+		reg = <0xe0100000 0x1000>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		interrupts = <0 31 0x4>;
+		dmas = <&dma-controller 23 1>,
+			<&dma-controller 24 0>;
+		dma-names = "rx", "tx";
+
+		m25p80@1 {
+			compatible = "st,m25p80";
+			reg = <1>;
+			spi-max-frequency = <12000000>;
+			spi-cpol;
+			spi-cpha;
+			pl022,hierarchy = <0>;
+			pl022,interface = <0>;
+			pl022,slave-tx-disable;
+			pl022,com-mode = <0x2>;
+			pl022,rx-level-trig = <0>;
+			pl022,tx-level-trig = <0>;
+			pl022,ctrl-len = <0x11>;
+			pl022,wait-state = <0>;
+			pl022,duplex = <0>;
+		};
+	};
+	
diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index b0fe393..371cc66f 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1139,6 +1139,35 @@ err_no_rxchan:
 	return -ENODEV;
 }
 
+static int pl022_dma_autoprobe(struct pl022 *pl022)
+{
+	struct device *dev = &pl022->adev->dev;
+
+	/* automatically configure DMA channels from platform, normally using DT */
+	pl022->dma_rx_channel = dma_request_slave_channel(dev, "rx");
+	if (!pl022->dma_rx_channel)
+		goto err_no_rxchan;
+
+	pl022->dma_tx_channel = dma_request_slave_channel(dev, "tx");
+	if (!pl022->dma_tx_channel)
+		goto err_no_txchan;
+
+	pl022->dummypage = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!pl022->dummypage)
+		goto err_no_dummypage;
+
+	return 0;
+
+err_no_dummypage:
+	dma_release_channel(pl022->dma_tx_channel);
+	pl022->dma_tx_channel = NULL;
+err_no_txchan:
+	dma_release_channel(pl022->dma_rx_channel);
+	pl022->dma_rx_channel = NULL;
+err_no_rxchan:
+	return -ENODEV;
+}
+		
 static void terminate_dma(struct pl022 *pl022)
 {
 	struct dma_chan *rxchan = pl022->dma_rx_channel;
@@ -1167,6 +1196,11 @@ static inline int configure_dma(struct pl022 *pl022)
 	return -ENODEV;
 }
 
+static inline int pl022_dma_autoprobe(struct pl022 *pl022)
+{
+	return 0;
+}
+
 static inline int pl022_dma_probe(struct pl022 *pl022)
 {
 	return 0;
@@ -2226,8 +2260,13 @@ static int pl022_probe(struct amba_device *adev, const struct amba_id *id)
 		goto err_no_irq;
 	}
 
-	/* Get DMA channels */
-	if (platform_info->enable_dma) {
+	/* Get DMA channels, try autoconfiguration first */
+	status = pl022_dma_autoprobe(pl022);
+
+	/* If that failed, use channels from platform_info */
+	if (status == 0)
+		platform_info->enable_dma = 1;
+	else if (platform_info->enable_dma) {
 		status = pl022_dma_probe(pl022);
 		if (status != 0)
 			platform_info->enable_dma = 0;
-- 
1.8.1.2

