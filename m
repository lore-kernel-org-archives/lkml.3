Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3FRO1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:27:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:57600 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab3FRO1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:27:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="351757675"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/2] spi/pxa2xx: use a flag to check if the device is runtime suspended
Date: Tue, 18 Jun 2013 17:29:45 +0300
Message-Id: <1371565785-31332-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1371565785-31332-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code calls pm_runtime_suspended() in the interrupt handler to check
if the device is suspended or not. However, runtime PM status of the device
is only set to suspended once all PM runtime suspend hooks have executed.

In our case we have the device bound to the ACPI power domain and its
runtime suspend hook will put the device to D3hot (or D3cold if possible).
This effectively means that the device is powered off before its state is
set to runtime suspended. During this time, it might get an interrupt that
is meant for another device (as the interrupt line is shared), and because
the device is powered off accessing its registers will return 0xffffffff
that the driver misinterprets as an invalid state. When this happens user
will see messages like below on the console:

	pxa2xx-spi INT33C0:00: bad message state in interrupt handler

Fix this by adding flag to the driver private data that indicates whether
the device is runtime suspended, and in that case return IRQ_NONE from the
interrupt handler.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c | 4 +++-
 drivers/spi/spi-pxa2xx.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index b92a5d0..a105c03 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -536,7 +536,7 @@ static irqreturn_t ssp_int(int irq, void *dev_id)
 	 * the IRQ was not for us (we shouldn't be RPM suspended when the
 	 * interrupt is enabled).
 	 */
-	if (pm_runtime_suspended(&drv_data->pdev->dev))
+	if (drv_data->suspended)
 		return IRQ_NONE;
 
 	sccr1_reg = read_SSCR1(reg);
@@ -1309,6 +1309,7 @@ static int pxa2xx_spi_runtime_suspend(struct device *dev)
 	struct driver_data *drv_data = dev_get_drvdata(dev);
 
 	clk_disable_unprepare(drv_data->ssp->clk);
+	drv_data->suspended = true;
 	return 0;
 }
 
@@ -1317,6 +1318,7 @@ static int pxa2xx_spi_runtime_resume(struct device *dev)
 	struct driver_data *drv_data = dev_get_drvdata(dev);
 
 	clk_prepare_enable(drv_data->ssp->clk);
+	drv_data->suspended = false;
 	return 0;
 }
 #endif
diff --git a/drivers/spi/spi-pxa2xx.h b/drivers/spi/spi-pxa2xx.h
index 5adc2a1..a5f8bb5 100644
--- a/drivers/spi/spi-pxa2xx.h
+++ b/drivers/spi/spi-pxa2xx.h
@@ -86,6 +86,7 @@ struct driver_data {
 	int (*read)(struct driver_data *drv_data);
 	irqreturn_t (*transfer_handler)(struct driver_data *drv_data);
 	void (*cs_control)(u32 command);
+	bool suspended;
 
 	void __iomem *lpss_base;
 };
-- 
1.8.3.1

