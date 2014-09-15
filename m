Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbaIOKPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:15:15 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25369 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbaIOKOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:14:40 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d5-5416bc0db957
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 3/4] amba: Don't unprepare the clocks if device driver wants
 IRQ safe runtime PM
Date: Mon, 15 Sep 2014 12:13:52 +0200
Message-id: <1410776033-22156-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410776033-22156-1-git-send-email-k.kozlowski@samsung.com>
References: <1410776033-22156-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrALMWRmVeSWpSXmKPExsVy+t/xK7q8e8RCDGZe1LTYOGM9q8X0qRcY
	LVZP/ctqceDPDkaL1y8MLc42vWG3WDJ5PqvF5V1z2Cw+9x5htLh9mddi7ZG77BbvXkZYHF8b
	bvGybz+LA59HS3MPm8fiPS+ZPO5c28PmseTNIVaPvi2rGD0+b5Lz2Pv5N0sAexSXTUpqTmZZ
	apG+XQJXRs/TNYwF+0Qruh/NZGpgXCHYxcjJISFgInFvw3MmCFtM4sK99WxdjFwcQgJLGSU6
	7n6CcvqYJGaceMoIUsUmYCyxefkSsISIwDsmiVvbT7GAOMwCRxklpve+BZslLJAqseXeRaAO
	Dg4WAVWJaYeEQcK8Au4SHdN/sEGsk5M4eWwyK4jNKeAhse1tAzuILQRU8+nJS8YJjLwLGBlW
	MYqmliYXFCel5xrqFSfmFpfmpesl5+duYoSE6pcdjIuPWR1iFOBgVOLhZbgiHCLEmlhWXJl7
	iFGCg1lJhHfqVrEQId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYzKok7lLr1lob1bWpcWpx39tUC6
	WpqB/eg6k2PvpzsvDXsjXna2ymenue0F7xfSmwJnTMvm3rvgo0nOuScfDz4rWVF2okHjochL
	rX9vvQvMPYpmFfSsl99fmGvOlVjLa/BvTjlTiGYW0w1hR8kcKYu0+wuLnh/vk90n/Vp9Zvgx
	55zTeWsuMSmxFGckGmoxFxUnAgD74dbgMwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMBA bus driver defines runtime Power Management functions which
disable and unprepare AMBA bus clock. This is problematic for runtime PM
because unpreparing a clock might sleep so it is not interrupt safe.

However some drivers may want to implement runtime PM functions in
interrupt-safe way (see pm_runtime_irq_safe()). In such case the AMBA
bus driver should not unprepare/prepare the clock in runtime suspend and
resume callbacks.

Detect the device driver behavior after calling its probe function and
store it. During runtime suspend/resume deal with clocks according to
stored value.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/amba/bus.c       | 30 ++++++++++++++++++++++++++----
 include/linux/amba/bus.h |  1 +
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3cf61a127ee5..388ff4481762 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -94,8 +94,18 @@ static int amba_pm_runtime_suspend(struct device *dev)
 	struct amba_device *pcdev = to_amba_device(dev);
 	int ret = pm_generic_runtime_suspend(dev);
 
-	if (ret == 0 && dev->driver)
-		clk_disable_unprepare(pcdev->pclk);
+	if (ret == 0 && dev->driver) {
+		/*
+		 * Drivers should not change pm_runtime_is_irq_safe()
+		 * after probe.
+		 */
+		WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
+
+		if (pcdev->irq_safe)
+			clk_disable(pcdev->pclk);
+		else
+			clk_disable_unprepare(pcdev->pclk);
+	}
 
 	return ret;
 }
@@ -106,7 +116,16 @@ static int amba_pm_runtime_resume(struct device *dev)
 	int ret;
 
 	if (dev->driver) {
-		ret = clk_prepare_enable(pcdev->pclk);
+		/*
+		 * Drivers should not change pm_runtime_is_irq_safe()
+		 * after probe.
+		 */
+		WARN_ON(pcdev->irq_safe != pm_runtime_is_irq_safe(dev));
+
+		if (pcdev->irq_safe)
+			ret = clk_enable(pcdev->pclk);
+		else
+			ret = clk_prepare_enable(pcdev->pclk);
 		/* Failure is probably fatal to the system, but... */
 		if (ret)
 			return ret;
@@ -191,8 +210,11 @@ static int amba_probe(struct device *dev)
 		pm_runtime_enable(dev);
 
 		ret = pcdrv->probe(pcdev, id);
-		if (ret == 0)
+		if (ret == 0) {
+			if (pm_runtime_is_irq_safe(dev))
+				pcdev->irq_safe = 1;
 			break;
+		}
 
 		pm_runtime_disable(dev);
 		pm_runtime_set_suspended(dev);
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index ad52027a9cbf..ce101e4497d6 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -32,6 +32,7 @@ struct amba_device {
 	struct clk		*pclk;
 	unsigned int		periphid;
 	unsigned int		irq[AMBA_NR_IRQS];
+	unsigned int		irq_safe:1;
 };
 
 struct amba_driver {
-- 
1.9.1

