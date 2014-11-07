Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaKGSjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:39:17 -0500
Received: from queue01c.mail.zen.net.uk ([212.23.3.237]:58279 "EHLO
	queue01c.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaKGSjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:39:16 -0500
X-Greylist: delayed 1958 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2014 13:39:15 EST
From: Jon Medhurst <tixy@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/2] dma: pl330: Limit MFIFO usage for memcpy to avoid exhausting entries
Date: Fri,  7 Nov 2014 18:05:18 +0000
Message-Id: <1415383518-29327-3-git-send-email-tixy@linaro.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1415383518-29327-1-git-send-email-tixy@linaro.org>
References: <1415383518-29327-1-git-send-email-tixy@linaro.org>
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MFIFO is shared by all channels so restrict each memcpy to it's fair
share. This is being over cautious, but without a global view of DMA
channel usage on a system it's not possible to come up with a more
optimum safe limit.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---
 drivers/dma/pl330.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 8f869ec..849439a 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2336,7 +2336,7 @@ static inline int get_burst_len(struct dma_pl330_desc *desc, size_t len)
 	int burst_len;
 
 	burst_len = pl330->pcfg.data_bus_width / 8;
-	burst_len *= pl330->pcfg.data_buf_dep;
+	burst_len *= pl330->pcfg.data_buf_dep / pl330->pcfg.num_chan;
 	burst_len >>= desc->rqcfg.brst_size;
 
 	/* src/dst_burst_len can't be more than 16 */
-- 
2.1.1

