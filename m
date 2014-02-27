Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaB0FPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:15:00 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50887 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbaB0FO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:14:57 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <msmucr@gmail.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 1/2] dma: cppi41: start tear down only if channel is busy
Date: Thu, 27 Feb 2014 10:44:40 +0530
Message-ID: <1393478081-14226-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
References: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start the channel tear down only if the channel is busy, else just
bail out. In some cases its seen that by the time the tear down is
initiated the cppi completes the DMA, especially in ISOCH transfers.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/dma/cppi41.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index c18aebf..d028f36 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -620,12 +620,15 @@ static int cppi41_stop_chan(struct dma_chan *chan)
 	u32 desc_phys;
 	int ret;
 
+	desc_phys = lower_32_bits(c->desc_phys);
+	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
+	if (!cdd->chan_busy[desc_num])
+		return 0;
+
 	ret = cppi41_tear_down_chan(c);
 	if (ret)
 		return ret;
 
-	desc_phys = lower_32_bits(c->desc_phys);
-	desc_num = (desc_phys - cdd->descs_phys) / sizeof(struct cppi41_desc);
 	WARN_ON(!cdd->chan_busy[desc_num]);
 	cdd->chan_busy[desc_num] = NULL;
 
-- 
1.8.1

