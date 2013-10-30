Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3J3N6C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:58:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:13189 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab3J3N57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:57:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="427076894"
Date: Wed, 30 Oct 2013 18:33:25 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Olof Johansson <olof@lixom.net>, Joel Fernandes <joelf@ti.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Dan Williams <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt.porter@linaro.org>
Subject: Re: [PATCH 01/28] dmaengine: use DMA_COMPLETE for dma completion
 status
Message-ID: <20131030130325.GA18788@intel.com>
References: <CAPcyv4hOZHmegDiPYmeVWzOUCasQaixzCzpLHs37i7RZznhGsA@mail.gmail.com>
 <20131017020745.GA14013@intel.com>
 <20131017142755.GA4477@breakpoint.cc>
 <20131017134846.GG14013@intel.com>
 <Pine.LNX.4.64.1310242326500.2900@axis700.grange>
 <20131025042310.GC21230@intel.com>
 <Pine.LNX.4.64.1310250813370.6186@axis700.grange>
 <20131025054321.GD21230@intel.com>
 <Pine.LNX.4.64.1310250840350.6186@axis700.grange>
 <CAOesGMivD_3zSL503R0OaqyGv4Rj8qJqnbM2TdmjtxR2U63ztw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMivD_3zSL503R0OaqyGv4Rj8qJqnbM2TdmjtxR2U63ztw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:47:55AM -0700, Olof Johansson wrote:
> This patch broke some TI platforms (using edma) due to namespace
> conflicts. The error is:
> 
> ../../include/linux/dmaengine.h:54:2: error: expected identifier
> before numeric constant   (for DMA_COMPLETE)
> 
> .. it's because they define DMA_COMPLETE in include/platform_data/edma.h.
> 
> The edma driver seems to overall lack prefixes and thus pollutes
> global namespaces, so it should be fixed up.
Yup this needs some work.

I fixed up the error with below, can you pls verify. Pls note this is compile
tested only!

-----><8---------------------------

From: Vinod Koul <vinod.koul@intel.com>
Date: Wed, 30 Oct 2013 18:22:30 +0530
Subject: [PATCH] dmanengine: fix edma driver to not define DMA_COMPLETE

edma header defines DMA_COMPLETE, this causes issues as commit adfedd9a32e4 move
DMA_SUCCESS to DMA_COMPLETE. edma should properly namespace its defines and
needs a future fix

Reported-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 arch/arm/common/edma.c             |    4 ++--
 drivers/dma/edma.c                 |    4 ++--
 include/linux/platform_data/edma.h |    8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 8e1a024..41bca32 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -404,7 +404,7 @@ static irqreturn_t dma_irq_handler(int irq, void *data)
 					BIT(slot));
 			if (edma_cc[ctlr]->intr_data[channel].callback)
 				edma_cc[ctlr]->intr_data[channel].callback(
-					channel, DMA_COMPLETE,
+					channel, EDMA_DMA_COMPLETE,
 					edma_cc[ctlr]->intr_data[channel].data);
 		}
 	} while (sh_ipr);
@@ -459,7 +459,7 @@ static irqreturn_t dma_ccerr_handler(int irq, void *data)
 								callback) {
 						edma_cc[ctlr]->intr_data[k].
 						callback(k,
-						DMA_CC_ERROR,
+						EDMA_DMA_CC_ERROR,
 						edma_cc[ctlr]->intr_data
 						[k].data);
 					}
diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 29fa358..cb69f3a 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -407,7 +407,7 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 	edma_pause(echan->ch_num);
 
 	switch (ch_status) {
-	case DMA_COMPLETE:
+	case EDMA_DMA_COMPLETE:
 		spin_lock_irqsave(&echan->vchan.lock, flags);
 
 		edesc = echan->edesc;
@@ -426,7 +426,7 @@ static void edma_callback(unsigned ch_num, u16 ch_status, void *data)
 		spin_unlock_irqrestore(&echan->vchan.lock, flags);
 
 		break;
-	case DMA_CC_ERROR:
+	case EDMA_DMA_CC_ERROR:
 		spin_lock_irqsave(&echan->vchan.lock, flags);
 
 		edma_read_slot(EDMA_CHAN_SLOT(echan->slot[0]), &p);
diff --git a/include/linux/platform_data/edma.h b/include/linux/platform_data/edma.h
index 179fb91..f50821c 100644
--- a/include/linux/platform_data/edma.h
+++ b/include/linux/platform_data/edma.h
@@ -67,10 +67,10 @@ struct edmacc_param {
 #define ITCCHEN		BIT(23)
 
 /*ch_status paramater of callback function possible values*/
-#define DMA_COMPLETE 1
-#define DMA_CC_ERROR 2
-#define DMA_TC1_ERROR 3
-#define DMA_TC2_ERROR 4
+#define EDMA_DMA_COMPLETE 1
+#define EDMA_DMA_CC_ERROR 2
+#define EDMA_DMA_TC1_ERROR 3
+#define EDMA_DMA_TC2_ERROR 4
 
 enum address_mode {
 	INCR = 0,
-- 
1.7.0.4

--
~Vinod
