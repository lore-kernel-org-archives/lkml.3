Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaB0FPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:15:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50891 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754803AbaB0FPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:15:00 -0500
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <dmaengine@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <dan.j.williams@intel.com>,
        <vinod.koul@intel.com>, <msmucr@gmail.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH 2/2] usb: musb: musb_cppi41: Dont reprogram DMA if tear down is initiated
Date: Thu, 27 Feb 2014 10:44:41 +0530
Message-ID: <1393478081-14226-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
References: <1393478081-14226-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reprogramming the DMA after tear down is initiated leads to warning.
This is mainly seen with ISOCH since we do a delayed completion for
ISOCH transfers. In ISOCH transfers dma_completion should not reprogram
if the channel tear down is initiated.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_cppi41.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
index f3ec7d2..e201b1e 100644
--- a/drivers/usb/musb/musb_cppi41.c
+++ b/drivers/usb/musb/musb_cppi41.c
@@ -132,7 +132,8 @@ static void cppi41_trans_done(struct cppi41_dma_channel *cppi41_channel)
 	struct musb_hw_ep *hw_ep = cppi41_channel->hw_ep;
 	struct musb *musb = hw_ep->musb;
 
-	if (!cppi41_channel->prog_len) {
+	if (!cppi41_channel->prog_len ||
+	    (cppi41_channel->channel.status == MUSB_DMA_STATUS_FREE)) {
 
 		/* done, complete */
 		cppi41_channel->channel.actual_len =
-- 
1.8.1

