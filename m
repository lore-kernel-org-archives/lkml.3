Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaHSRap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:30:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:10172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbaHSR3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="590323078"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@kernel.org>,
        Hein Tibosch <hein_tibosch@yahoo.es>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Takashi Iwai <tiwai@suse.de>,
        Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 05/12] dmaengine: dw: introduce generic filter function
Date: Tue, 19 Aug 2014 20:29:16 +0300
Message-Id: <1408469363-15901-6-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The introduced filter function would be reused in the ACPI and DT cases since
in those cases we have to apply mandatory data to the requested channel. Thus,
patch moves platform driver to use it in that case.

The function unlikely can't be used by users of the driver due to an implicit
dependency to the dw_dmac_core module.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c     | 20 +++++++++++++++
 drivers/dma/dw/internal.h | 24 +-----------------
 drivers/dma/dw/platform.c | 63 ++++++++++++++---------------------------------
 3 files changed, 40 insertions(+), 67 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 1c45212..10e43ea 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -919,6 +919,26 @@ err_desc_get:
 	return NULL;
 }
 
+bool dw_dma_filter(struct dma_chan *chan, void *param)
+{
+	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
+	struct dw_dma_slave *dws = param;
+
+	if (!dws || dws->dma_dev != chan->device->dev)
+		return false;
+
+	/* We have to copy data since dws can be temporary storage */
+
+	dwc->src_id = dws->src_id;
+	dwc->dst_id = dws->dst_id;
+
+	dwc->src_master = dws->src_master;
+	dwc->dst_master = dws->dst_master;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(dw_dma_filter);
+
 /*
  * Fix sconfig's burst size according to dw_dmac. We need to convert them as:
  * 1 -> 0, 4 -> 1, 8 -> 2, 16 -> 3.
diff --git a/drivers/dma/dw/internal.h b/drivers/dma/dw/internal.h
index 43cc1df..2c8d02f 100644
--- a/drivers/dma/dw/internal.h
+++ b/drivers/dma/dw/internal.h
@@ -43,28 +43,6 @@ int dw_dma_resume(struct dw_dma_chip *chip);
 
 #endif /* CONFIG_PM_SLEEP */
 
-/**
- * dwc_get_dms - get destination master
- * @slave:	pointer to the custom slave configuration
- *
- * Returns destination master in the custom slave configuration if defined, or
- * default value otherwise.
- */
-static inline unsigned int dwc_get_dms(struct dw_dma_slave *slave)
-{
-	return slave ? slave->dst_master : 0;
-}
-
-/**
- * dwc_get_sms - get source master
- * @slave:	pointer to the custom slave configuration
- *
- * Returns source master in the custom slave configuration if defined, or
- * default value otherwise.
- */
-static inline unsigned int dwc_get_sms(struct dw_dma_slave *slave)
-{
-	return slave ? slave->src_master : 1;
-}
+extern bool dw_dma_filter(struct dma_chan *chan, void *param);
 
 #endif /* _DW_DMAC_INTERNAL_H */
diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index 7aa3cd3..860c9ac 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -25,74 +25,49 @@
 
 #include "internal.h"
 
-struct dw_dma_of_filter_args {
-	struct dw_dma *dw;
-	unsigned int req;
-	unsigned int src;
-	unsigned int dst;
-};
-
-static bool dw_dma_of_filter(struct dma_chan *chan, void *param)
-{
-	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
-	struct dw_dma_of_filter_args *fargs = param;
-
-	/* Ensure the device matches our channel */
-	if (chan->device != &fargs->dw->dma)
-		return false;
-
-	dwc->src_id = fargs->req;
-	dwc->dst_id = fargs->req;
-	dwc->src_master	= fargs->src;
-	dwc->dst_master	= fargs->dst;
-
-	return true;
-}
-
 static struct dma_chan *dw_dma_of_xlate(struct of_phandle_args *dma_spec,
 					struct of_dma *ofdma)
 {
 	struct dw_dma *dw = ofdma->of_dma_data;
-	struct dw_dma_of_filter_args fargs = {
-		.dw = dw,
+	struct dw_dma_slave slave = {
+		.dma_dev = dw->dma.dev,
 	};
 	dma_cap_mask_t cap;
 
 	if (dma_spec->args_count != 3)
 		return NULL;
 
-	fargs.req = dma_spec->args[0];
-	fargs.src = dma_spec->args[1];
-	fargs.dst = dma_spec->args[2];
+	slave.src_id = dma_spec->args[0];
+	slave.dst_id = dma_spec->args[0];
+	slave.src_master = dma_spec->args[1];
+	slave.dst_master = dma_spec->args[2];
 
-	if (WARN_ON(fargs.req >= DW_DMA_MAX_NR_REQUESTS ||
-		    fargs.src >= dw->nr_masters ||
-		    fargs.dst >= dw->nr_masters))
+	if (WARN_ON(slave.src_id >= DW_DMA_MAX_NR_REQUESTS ||
+		    slave.dst_id >= DW_DMA_MAX_NR_REQUESTS ||
+		    slave.src_master >= dw->nr_masters ||
+		    slave.dst_master >= dw->nr_masters))
 		return NULL;
 
 	dma_cap_zero(cap);
 	dma_cap_set(DMA_SLAVE, cap);
 
 	/* TODO: there should be a simpler way to do this */
-	return dma_request_channel(cap, dw_dma_of_filter, &fargs);
+	return dma_request_channel(cap, dw_dma_filter, &slave);
 }
 
 #ifdef CONFIG_ACPI
 static bool dw_dma_acpi_filter(struct dma_chan *chan, void *param)
 {
-	struct dw_dma_chan *dwc = to_dw_dma_chan(chan);
 	struct acpi_dma_spec *dma_spec = param;
+	struct dw_dma_slave slave = {
+		.dma_dev = dma_spec->dev,
+		.src_id = dma_spec->slave_id,
+		.dst_id = dma_spec->slave_id,
+		.src_master = 1,
+		.dst_master = 0,
+	};
 
-	if (chan->device->dev != dma_spec->dev ||
-	    chan->chan_id != dma_spec->chan_id)
-		return false;
-
-	dwc->src_id = dma_spec->slave_id;
-	dwc->dst_id = dma_spec->slave_id;
-	dwc->src_master = dwc_get_sms(NULL);
-	dwc->dst_master = dwc_get_dms(NULL);
-
-	return true;
+	return dw_dma_filter(chan, &slave);
 }
 
 static void dw_dma_acpi_controller_register(struct dw_dma *dw)
-- 
2.1.0

