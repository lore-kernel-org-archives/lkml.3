Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaIGR4r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 13:56:47 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:53209 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbaIGR4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 13:56:44 -0400
From: Stanimir Varbanov <svarbanov@mm-sol.com>
To: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Gross <agross@codeaurora.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH] dmaengine: qcom_bam_dma: add one more optional clock
Date: Sun,  7 Sep 2014 20:55:47 +0300
Message-Id: <1410112547-363-1-git-send-email-svarbanov@mm-sol.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BAM is tightly coupled with the peripheral to which it
belongs. In that sprit to access the BAM configuration
registers the driver needs to enable some peripheral
clocks. Currently the DT node enables bamclk which seems
is not enough for some peripherals (for example the crypto
engine wants core and iface clocks). This change attempts
to solve this issue by adding one more optional clock
in bam_dma driver.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 .../devicetree/bindings/dma/qcom_bam_dma.txt       | 12 ++++--
 drivers/dma/qcom_bam_dma.c                         | 44 +++++++++++++++-------
 2 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
index d75a9d7..2376897 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -6,8 +6,11 @@ Required properties:
 - interrupts: Should contain the one interrupt shared by all channels
 - #dma-cells: must be <1>, the cell in the dmas property of the client device
   represents the channel number
-- clocks: required clock
-- clock-names: must contain "bam_clk" entry
+- clocks: list of required clock plus one optional clock. The optional clock
+          is needed for some peripherals and can be omitted.
+- clock-names: must contain "core" clock name representing the required clock
+               plus the optional "iface" clock name depending on
+               peripheral needs.
 - qcom,ee : indicates the active Execution Environment identifier (0-7) used in
   the secure world.
 
@@ -17,8 +20,9 @@ Example:
 		compatible = "qcom,bam-v1.4.0";
 		reg = <0xf9984000 0x15000>;
 		interrupts = <0 94 0>;
-		clocks = <&gcc GCC_BAM_DMA_AHB_CLK>;
-		clock-names = "bam_clk";
+		clocks = <&gcc GCC_BLSP1_UART2_APPS_CLK>,
+			 <&gcc GCC_BLSP1_AHB_CLK>;
+		clock-names = "core", "iface";
 		#dma-cells = <1>;
 		qcom,ee = <0>;
 	};
diff --git a/drivers/dma/qcom_bam_dma.c b/drivers/dma/qcom_bam_dma.c
index 7a4bbb0..d898ec3 100644
--- a/drivers/dma/qcom_bam_dma.c
+++ b/drivers/dma/qcom_bam_dma.c
@@ -297,7 +297,7 @@ struct bam_device {
 	/* execution environment ID, from DT */
 	u32 ee;
 
-	struct clk *bamclk;
+	struct clk *iface, *core;
 	int irq;
 
 	/* dma start transaction tasklet */
@@ -996,19 +996,32 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	bdev->bamclk = devm_clk_get(bdev->dev, "bam_clk");
-	if (IS_ERR(bdev->bamclk))
-		return PTR_ERR(bdev->bamclk);
+	bdev->core = devm_clk_get(bdev->dev, "core");
+	if (IS_ERR(bdev->core))
+		return PTR_ERR(bdev->core);
 
-	ret = clk_prepare_enable(bdev->bamclk);
+	ret = clk_prepare_enable(bdev->core);
 	if (ret) {
-		dev_err(bdev->dev, "failed to prepare/enable clock\n");
+		dev_err(bdev->dev, "failed to prepare/enable core clock\n");
 		return ret;
 	}
 
+	bdev->iface = devm_clk_get(bdev->dev, "iface");
+	if (IS_ERR(bdev->iface) && PTR_ERR(bdev->iface) == -EPROBE_DEFER) {
+		ret = -EPROBE_DEFER;
+		goto err_disable_core_clk;
+	} else if (!IS_ERR(bdev->iface)) {
+		ret = clk_prepare_enable(bdev->iface);
+		if (ret) {
+			dev_err(bdev->dev,
+				"failed to prepare/enable iface clock\n");
+			goto err_disable_core_clk;
+		}
+	}
+
 	ret = bam_init(bdev);
 	if (ret)
-		goto err_disable_clk;
+		goto err_disable_clks;
 
 	tasklet_init(&bdev->task, dma_tasklet, (unsigned long)bdev);
 
@@ -1017,7 +1030,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 	if (!bdev->channels) {
 		ret = -ENOMEM;
-		goto err_disable_clk;
+		goto err_disable_clks;
 	}
 
 	/* allocate and initialize channels */
@@ -1029,7 +1042,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = devm_request_irq(bdev->dev, bdev->irq, bam_dma_irq,
 			IRQF_TRIGGER_HIGH, "bam_dma", bdev);
 	if (ret)
-		goto err_disable_clk;
+		goto err_disable_clks;
 
 	/* set max dma segment size */
 	bdev->common.dev = bdev->dev;
@@ -1037,7 +1050,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_set_max_seg_size(bdev->common.dev, BAM_MAX_DATA_SIZE);
 	if (ret) {
 		dev_err(bdev->dev, "cannot set maximum segment size\n");
-		goto err_disable_clk;
+		goto err_disable_clks;
 	}
 
 	platform_set_drvdata(pdev, bdev);
@@ -1058,7 +1071,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	ret = dma_async_device_register(&bdev->common);
 	if (ret) {
 		dev_err(bdev->dev, "failed to register dma async device\n");
-		goto err_disable_clk;
+		goto err_disable_clks;
 	}
 
 	ret = of_dma_controller_register(pdev->dev.of_node, bam_dma_xlate,
@@ -1070,8 +1083,10 @@ static int bam_dma_probe(struct platform_device *pdev)
 
 err_unregister_dma:
 	dma_async_device_unregister(&bdev->common);
-err_disable_clk:
-	clk_disable_unprepare(bdev->bamclk);
+err_disable_clks:
+	clk_disable_unprepare(bdev->iface);
+err_disable_core_clk:
+	clk_disable_unprepare(bdev->core);
 	return ret;
 }
 
@@ -1099,7 +1114,8 @@ static int bam_dma_remove(struct platform_device *pdev)
 
 	tasklet_kill(&bdev->task);
 
-	clk_disable_unprepare(bdev->bamclk);
+	clk_disable_unprepare(bdev->iface);
+	clk_disable_unprepare(bdev->core);
 
 	return 0;
 }
-- 
1.8.3.2

