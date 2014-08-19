Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaHSR3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:29:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:28258 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753736AbaHSR3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:29:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,896,1400050800"; 
   d="scan'208";a="587012990"
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
Subject: [PATCH v1 04/12] dmaengine: dw: apply both HS interfaces and remove slave_id usage
Date: Tue, 19 Aug 2014 20:29:15 +0300
Message-Id: <1408469363-15901-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of one request line member let's use both source and destination ones.
Usually we have no such hardware except Atmel MMC controller found on AVR32
platform (see arch/avr32/mach-at32ap/at32ap700x.c and
drivers/mmc/host/atmel-mci.c).

This patch removes slave_id usage since it'll be removed from the generic
structure in later. This breaks the non-ACPI / non-DT cases for the users of
the driver, i.e. SPI and HSUART. However, these cases mean only PCI enumerated
devices for now, which is anyway broken (considering more than one DMA
controller in the system) and this patch series is intended to fix that
eventually.

The ACPI and DT cases shall be aware of the channel direction when setting
request lines, but this is a minor problem that would be addressed in future.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/core.c     | 32 ++------------------------------
 drivers/dma/dw/platform.c |  6 ++++--
 drivers/dma/dw/regs.h     |  7 ++++---
 3 files changed, 10 insertions(+), 35 deletions(-)

diff --git a/drivers/dma/dw/core.c b/drivers/dma/dw/core.c
index 0a9c052..1c45212 100644
--- a/drivers/dma/dw/core.c
+++ b/drivers/dma/dw/core.c
@@ -37,24 +37,6 @@
  * support descriptor writeback.
  */
 
-static inline bool is_request_line_unset(struct dw_dma_chan *dwc)
-{
-	return dwc->request_line == (typeof(dwc->request_line))~0;
-}
-
-static inline void dwc_set_masters(struct dw_dma_chan *dwc)
-{
-	struct dw_dma *dw = to_dw_dma(dwc->chan.device);
-	struct dw_dma_slave *dws = dwc->chan.private;
-	unsigned char mmax = dw->nr_masters - 1;
-
-	if (!is_request_line_unset(dwc))
-		return;
-
-	dwc->src_master = min_t(unsigned char, mmax, dwc_get_sms(dws));
-	dwc->dst_master = min_t(unsigned char, mmax, dwc_get_dms(dws));
-}
-
 #define DWC_DEFAULT_CTLLO(_chan) ({				\
 		struct dw_dma_chan *_dwc = to_dw_dma_chan(_chan);	\
 		struct dma_slave_config	*_sconfig = &_dwc->dma_sconfig;	\
@@ -158,10 +140,8 @@ static void dwc_initialize(struct dw_dma_chan *dwc)
 		cfghi |= DWC_CFGH_DST_PER(dws->dst_id);
 		cfghi |= DWC_CFGH_SRC_PER(dws->src_id);
 	} else {
-		if (dwc->direction == DMA_MEM_TO_DEV)
-			cfghi = DWC_CFGH_DST_PER(dwc->request_line);
-		else if (dwc->direction == DMA_DEV_TO_MEM)
-			cfghi = DWC_CFGH_SRC_PER(dwc->request_line);
+		cfghi |= DWC_CFGH_DST_PER(dwc->dst_id);
+		cfghi |= DWC_CFGH_SRC_PER(dwc->src_id);
 	}
 
 	channel_writel(dwc, CFG_LO, cfglo);
@@ -967,10 +947,6 @@ set_runtime_config(struct dma_chan *chan, struct dma_slave_config *sconfig)
 	memcpy(&dwc->dma_sconfig, sconfig, sizeof(*sconfig));
 	dwc->direction = sconfig->direction;
 
-	/* Take the request line from slave_id member */
-	if (is_request_line_unset(dwc))
-		dwc->request_line = sconfig->slave_id;
-
 	convert_burst(&dwc->dma_sconfig.src_maxburst);
 	convert_burst(&dwc->dma_sconfig.dst_maxburst);
 
@@ -1123,8 +1099,6 @@ static int dwc_alloc_chan_resources(struct dma_chan *chan)
 	 * doesn't mean what you think it means), and status writeback.
 	 */
 
-	dwc_set_masters(dwc);
-
 	spin_lock_irqsave(&dwc->lock, flags);
 	i = dwc->descs_allocated;
 	while (dwc->descs_allocated < NR_DESCS_PER_CHANNEL) {
@@ -1182,7 +1156,6 @@ static void dwc_free_chan_resources(struct dma_chan *chan)
 	list_splice_init(&dwc->free_list, &list);
 	dwc->descs_allocated = 0;
 	dwc->initialized = false;
-	dwc->request_line = ~0;
 
 	/* Disable interrupts */
 	channel_clear_bit(dw, MASK.XFER, dwc->mask);
@@ -1604,7 +1577,6 @@ int dw_dma_probe(struct dw_dma_chip *chip, struct dw_dma_platform_data *pdata)
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 
 		dwc->direction = DMA_TRANS_NONE;
-		dwc->request_line = ~0;
 
 		/* Hardware configuration */
 		if (autocfg) {
diff --git a/drivers/dma/dw/platform.c b/drivers/dma/dw/platform.c
index c5b339a..7aa3cd3 100644
--- a/drivers/dma/dw/platform.c
+++ b/drivers/dma/dw/platform.c
@@ -41,7 +41,8 @@ static bool dw_dma_of_filter(struct dma_chan *chan, void *param)
 	if (chan->device != &fargs->dw->dma)
 		return false;
 
-	dwc->request_line = fargs->req;
+	dwc->src_id = fargs->req;
+	dwc->dst_id = fargs->req;
 	dwc->src_master	= fargs->src;
 	dwc->dst_master	= fargs->dst;
 
@@ -86,7 +87,8 @@ static bool dw_dma_acpi_filter(struct dma_chan *chan, void *param)
 	    chan->chan_id != dma_spec->chan_id)
 		return false;
 
-	dwc->request_line = dma_spec->slave_id;
+	dwc->src_id = dma_spec->slave_id;
+	dwc->dst_id = dma_spec->slave_id;
 	dwc->src_master = dwc_get_sms(NULL);
 	dwc->dst_master = dwc_get_dms(NULL);
 
diff --git a/drivers/dma/dw/regs.h b/drivers/dma/dw/regs.h
index af02439..0e82d99 100644
--- a/drivers/dma/dw/regs.h
+++ b/drivers/dma/dw/regs.h
@@ -221,9 +221,10 @@ struct dw_dma_chan {
 	bool			nollp;
 
 	/* custom slave configuration */
-	unsigned int		request_line;
-	unsigned char		src_master;
-	unsigned char		dst_master;
+	u8			src_id;
+	u8			dst_id;
+	u8			src_master;
+	u8			dst_master;
 
 	/* configuration passed via DMA_SLAVE_CONFIG */
 	struct dma_slave_config dma_sconfig;
-- 
2.1.0

