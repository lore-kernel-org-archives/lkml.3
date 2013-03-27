Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3C0I6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:58:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:47262 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab3C0I6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:58:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,917,1355126400"; 
   d="scan'208";a="285153143"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4/6] dw_dmac: add ACPI support
Date: Wed, 27 Mar 2013 10:58:00 +0200
Message-Id: <1364374682-8547-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
In-Reply-To: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1364374682-8547-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we have proper ACPI DMA helpers implemented, the driver may use it. This
patch introduces custom filter function together with acpi_device_id table.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c      | 68 ++++++++++++++++++++++++++++++++++------------
 drivers/dma/dw_dmac_regs.h |  1 -
 2 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index e33dc3b..2e5deaa 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -25,6 +25,8 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/acpi.h>
+#include <linux/acpi_dma.h>
 
 #include "dw_dmac_regs.h"
 #include "dmaengine.h"
@@ -983,13 +985,6 @@ static inline void convert_burst(u32 *maxburst)
 		*maxburst = 0;
 }
 
-static inline void convert_slave_id(struct dw_dma_chan *dwc)
-{
-	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
-
-	dwc->dma_sconfig.slave_id -= dw->request_line_base;
-}
-
 static int
 set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 {
@@ -1008,7 +1003,6 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 
 	convert_burst(&dwc->dma_sconfig.src_maxburst);
 	convert_burst(&dwc->dma_sconfig.dst_maxburst);
-	convert_slave_id(dwc);
 
 	return 0;
 }
@@ -1284,6 +1278,46 @@ static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
 	return dma_request_channel(cap, dw_dma_of_filter, &fargs);
 }
 
+#ifdef CONFIG_ACPI
+static bool dw_dma_acpi_filter(struct dma_chan *chan, void *param)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	struct acpi_dma_spec *dma_spec = param;
+
+	if (chan->device->dev != dma_spec->dev ||
+	    chan->chan_id != dma_spec->chan_id)
+		return false;
+
+	dwc->request_line = dma_spec->slave_id;
+	dwc->src_master = dwc_get_sms(NULL);
+	dwc->dst_master = dwc_get_dms(NULL);
+
+	return true;
+}
+
+static void dw_dma_acpi_controller_register(struct dw_dma *dw)
+{
+	struct device *dev = dw->dma.dev;
+	struct acpi_dma_filter_info *info;
+	int ret;
+
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return;
+
+	dma_cap_zero(info->dma_cap);
+	dma_cap_set(DMA_SLAVE, info->dma_cap);
+	info->filter_fn = dw_dma_acpi_filter;
+
+	ret = devm_acpi_dma_controller_register(dev, acpi_dma_simple_xlate,
+						info);
+	if (ret)
+		dev_err(dev, "could not register acpi_dma_controller\n");
+}
+#else /* !CONFIG_ACPI */
+static inline void dw_dma_acpi_controller_register(struct dw_dma *dw) {}
+#endif /* !CONFIG_ACPI */
+
 /* --------------------- Cyclic DMA API extensions -------------------- */
 
 /**
@@ -1620,7 +1654,6 @@ dw_dma_parse_dt(struct platform_device *pdev)
 
 static int dw_probe(struct platform_device *pdev)
 {
-	const struct platform_device_id *match;
 	struct dw_dma_platform_data *pdata;
 	struct resource		*io;
 	struct dw_dma		*dw;
@@ -1704,11 +1737,6 @@ static int dw_probe(struct platform_device *pdev)
 		memcpy(dw->data_width, pdata->data_width, 4);
 	}
 
-	/* Get the base request line if set */
-	match = platform_get_device_id(pdev);
-	if (match)
-		dw->request_line_base = (unsigned int)match->driver_data;
-
 	/* Calculate all channel mask before DMA setup */
 	dw->all_chan_mask = (1 << nr_channels) - 1;
 
@@ -1833,6 +1861,9 @@ static int dw_probe(struct platform_device *pdev)
 				"could not register of_dma_controller\n");
 	}
 
+	if (ACPI_HANDLE(&pdev->dev))
+		dw_dma_acpi_controller_register(dw);
+
 	return 0;
 }
 
@@ -1904,11 +1935,12 @@ static const struct of_device_id dw_dma_of_id_table[] = {
 MODULE_DEVICE_TABLE(of, dw_dma_of_id_table);
 #endif
 
-static const struct platform_device_id dw_dma_ids[] = {
-	/* Name,	Request Line Base */
-	{ "INTL9C60",	(kernel_ulong_t)16 },
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id dw_dma_acpi_id_table[] = {
+	{ "INTL9C60", 0 },
 	{ }
 };
+#endif
 
 static struct platform_driver dw_driver = {
 	.probe		= dw_probe,
@@ -1918,8 +1950,8 @@ static struct platform_driver dw_driver = {
 		.name	= "dw_dmac",
 		.pm	= &dw_dev_pm_ops,
 		.of_match_table = of_match_ptr(dw_dma_of_id_table),
+		.acpi_match_table = ACPI_PTR(dw_dma_acpi_id_table),
 	},
-	.id_table	= dw_dma_ids,
 };
 
 static int __init dw_init(void)
diff --git a/drivers/dma/dw_dmac_regs.h b/drivers/dma/dw_dmac_regs.h
index 9b0e12e..9d41720 100644
--- a/drivers/dma/dw_dmac_regs.h
+++ b/drivers/dma/dw_dmac_regs.h
@@ -250,7 +250,6 @@ struct dw_dma {
 	/* hardware configuration */
 	unsigned char		nr_masters;
 	unsigned char		data_width[4];
-	unsigned int		request_line_base;
 
 	struct dw_dma_chan	chan[0];
 };
-- 
1.8.2.rc0.22.gb3600c3

