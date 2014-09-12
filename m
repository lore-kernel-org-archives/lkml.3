Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaILO4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:56:37 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49192 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaILO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:56:35 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-b1-541309a024f8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        dmaengine@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RFC PATCH v2 1/2] amba: Allow AMBA drivers to use their own runtime PM
Date: Fri, 12 Sep 2014 16:56:18 +0200
Message-id: <1410533779-3310-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1410533779-3310-1-git-send-email-k.kozlowski@samsung.com>
References: <1410533779-3310-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsVy+t/xy7oLOIVDDG6s07TYOGM9q8X0qRcY
	LVZP/ctqceDPDkaL1y8MLc42vWG3WDJ5PqvF5V1z2CxuX+a1WHvkLrvFu5cRFsfXhlu87NvP
	4sDr0dLcw+axeM9LJo871/aweSx5c4jVo2/LKkaPz5vkPPZ+/s0SwB7FZZOSmpNZllqkb5fA
	lfHo4WGWgjm8FQvPLGNvYDzN1cXIySEhYCLR0HadHcIWk7hwbz1bFyMXh5DAUkaJZY8XsUM4
	fUwSszfuB6tiEzCW2Lx8CViViMAlJolf916DVTELHGWUmN77lgmkSlggQOLj/DZGEJtFQFVi
	9vdJYHFeATeJKVP/QO2Tkzh5bDIriM0p4C6xe+9EoHoOoHVuEh+3WU5g5F3AyLCKUTS1NLmg
	OCk911CvODG3uDQvXS85P3cTIyRAv+xgXHzM6hCjAAejEg8vxznBECHWxLLiytxDjBIczEoi
	vDdeCYUI8aYkVlalFuXHF5XmpBYfYmTi4JRqYMx/udVthsrR9UwCXp8X+MQKpnpNiGtZ87Vs
	Zv6iyUHTu0UVTsm8nSjDc1buYdyGD/37dHemvL4pyHmhNYqx5HLdIn6rm+zmAXOV5t6fw3Xc
	nWXTXN3/novW+RyaUKlX81b4X3tsvz/Hpmm3pb21JnsnH5h3dxtjb77/SX2F9fd/ztfmMrNj
	K1diKc5INNRiLipOBAAn9Jn3LgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMBA bus driver defines runtime Power Management functions which
disable and unprepare AMBA bus clock. This is problematic for runtime PM
because unpreparing a clock might sleep so it is not interrupt safe.

However some drivers may want to implement runtime PM functions in
interrupt-safe way (see pm_runtime_irq_safe()). If such driver
implements its own runtime PM functions then assume it will handle the
runtime PM completely and it will replace our clock handling.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/amba/bus.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3cf61a127ee5..38461430b7cf 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -94,9 +94,18 @@ static int amba_pm_runtime_suspend(struct device *dev)
 	struct amba_device *pcdev = to_amba_device(dev);
 	int ret = pm_generic_runtime_suspend(dev);
 
-	if (ret == 0 && dev->driver)
+	if (ret == 0 && dev->driver) {
+		/*
+		 * If driver handles runtime suspend don't duplicate
+		 * the work here.
+		 */
+		if (dev->driver->pm && dev->driver->pm->runtime_suspend)
+			goto out;
+
 		clk_disable_unprepare(pcdev->pclk);
+	}
 
+out:
 	return ret;
 }
 
@@ -106,12 +115,16 @@ static int amba_pm_runtime_resume(struct device *dev)
 	int ret;
 
 	if (dev->driver) {
+		if (dev->driver->pm && dev->driver->pm->runtime_resume)
+			goto out;
+
 		ret = clk_prepare_enable(pcdev->pclk);
 		/* Failure is probably fatal to the system, but... */
 		if (ret)
 			return ret;
 	}
 
+out:
 	return pm_generic_runtime_resume(dev);
 }
 #endif
-- 
1.9.1

