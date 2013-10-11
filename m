Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3JKUxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:53:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45402 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab3JKTh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 41/48] dmaengine: imx-dma: fix callback path in tasklet
Date: Fri, 11 Oct 2013 12:36:48 -0700
Message-Id: <20131011193641.698724072@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit fcaaba6c7136fe47e5a13352f99a64b019b6d2c5 upstream.

We need to free the ld_active list head before jumping into the callback
routine. Otherwise the callback could run into issue_pending and change
our ld_active list head we just going to free. This will run the channel
list into an currupted and undefined state.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/imx-dma.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -563,13 +563,11 @@ static void imxdma_tasklet(unsigned long
 
 	if (list_empty(&imxdmac->ld_active)) {
 		/* Someone might have called terminate all */
-		goto out;
+		spin_unlock_irqrestore(&imxdma->lock, flags);
+		return;
 	}
 	desc = list_first_entry(&imxdmac->ld_active, struct imxdma_desc, node);
 
-	if (desc->desc.callback)
-		desc->desc.callback(desc->desc.callback_param);
-
 	/* If we are dealing with a cyclic descriptor keep it on ld_active
 	 * and dont mark the descripor as complete.
 	 * Only in non-cyclic cases it would be marked as complete
@@ -597,6 +595,10 @@ static void imxdma_tasklet(unsigned long
 	}
 out:
 	spin_unlock_irqrestore(&imxdma->lock, flags);
+
+	if (desc->desc.callback)
+		desc->desc.callback(desc->desc.callback_param);
+
 }
 
 static int imxdma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,


