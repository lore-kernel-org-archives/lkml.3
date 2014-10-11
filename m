Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbaJKQPZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:15:25 -0400
Received: from mga14.intel.com ([192.55.52.115]:1839 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbaJKQPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750313"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] usb: musb: ux500_dma: use dmaengine_xxx() APIs
Date: Sat, 11 Oct 2014 21:10:38 +0530
Message-Id: <1413042040-28222-10-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_terminate_all() or dmaengine_slave_config()
API instead of accessing the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/usb/musb/ux500_dma.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 9aad00f..874833d 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -121,8 +121,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 	slave_conf.dst_maxburst = 16;
 	slave_conf.device_fc = false;
 
-	dma_chan->device->device_control(dma_chan, DMA_SLAVE_CONFIG,
-					     (unsigned long) &slave_conf);
+	dmaengine_slave_config(dma_chan, &slave_conf);
 
 	dma_desc = dmaengine_prep_slave_sg(dma_chan, &sg, 1, direction,
 					     DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
@@ -246,9 +245,7 @@ static int ux500_dma_channel_abort(struct dma_channel *channel)
 			musb_writew(epio, MUSB_RXCSR, csr);
 		}
 
-		ux500_channel->dma_chan->device->
-				device_control(ux500_channel->dma_chan,
-					DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(ux500_channel->dma_chan);
 		channel->status = MUSB_DMA_STATUS_FREE;
 	}
 	return 0;
-- 
1.7.0.4

