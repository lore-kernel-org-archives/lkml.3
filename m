Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaEMVfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:35:15 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55673 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaEMVe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:34:59 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 1/4] spi: qup: Remove chip select function
Date: Tue, 13 May 2014 16:34:41 -0500
Message-Id: <1400016884-9568-2-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the chip select function.  Chip select should instead be
supported using GPIOs, defining the DT entry "cs-gpios", and letting the SPI
core assert/deassert the chip select as it sees fit.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 .../devicetree/bindings/spi/qcom,spi-qup.txt       |    6 +++++
 drivers/spi/spi-qup.c                              |   28 ++------------------
 2 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt b/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
index b82a268..bee6ff2 100644
--- a/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
+++ b/Documentation/devicetree/bindings/spi/qcom,spi-qup.txt
@@ -23,6 +23,12 @@ Optional properties:
 - spi-max-frequency: Specifies maximum SPI clock frequency,
                      Units - Hz. Definition as per
                      Documentation/devicetree/bindings/spi/spi-bus.txt
+- num-cs:	total number of chipselects
+- cs-gpios:	should specify GPIOs used for chipselects.
+		The gpios will be referred to as reg = <index> in the SPI child
+		nodes.  If unspecified, a single SPI device without a chip
+		select can be used.
+
 
 SPI slave nodes must be children of the SPI master node and can contain
 properties described in Documentation/devicetree/bindings/spi/spi-bus.txt
diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index b032e88..ea7017b 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -18,7 +18,9 @@
 #include <linux/io.h>
 #include <linux/list.h>
 #include <linux/module.h>
+#include <linux/gpio.h>
 #include <linux/of.h>
+#include <linux/of_gpio.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/spi/spi.h>
@@ -424,31 +426,6 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 	return 0;
 }
 
-static void spi_qup_set_cs(struct spi_device *spi, bool enable)
-{
-	struct spi_qup *controller = spi_master_get_devdata(spi->master);
-
-	u32 iocontol, mask;
-
-	iocontol = readl_relaxed(controller->base + SPI_IO_CONTROL);
-
-	/* Disable auto CS toggle and use manual */
-	iocontol &= ~SPI_IO_C_MX_CS_MODE;
-	iocontol |= SPI_IO_C_FORCE_CS;
-
-	iocontol &= ~SPI_IO_C_CS_SELECT_MASK;
-	iocontol |= SPI_IO_C_CS_SELECT(spi->chip_select);
-
-	mask = SPI_IO_C_CS_N_POLARITY_0 << spi->chip_select;
-
-	if (enable)
-		iocontol |= mask;
-	else
-		iocontol &= ~mask;
-
-	writel_relaxed(iocontol, controller->base + SPI_IO_CONTROL);
-}
-
 static int spi_qup_transfer_one(struct spi_master *master,
 			      struct spi_device *spi,
 			      struct spi_transfer *xfer)
@@ -576,7 +553,6 @@ static int spi_qup_probe(struct platform_device *pdev)
 	master->num_chipselect = SPI_NUM_CHIPSELECTS;
 	master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
 	master->max_speed_hz = max_freq;
-	master->set_cs = spi_qup_set_cs;
 	master->transfer_one = spi_qup_transfer_one;
 	master->dev.of_node = pdev->dev.of_node;
 	master->auto_runtime_pm = true;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

