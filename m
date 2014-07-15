Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759087AbaGOR0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:26:21 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44011 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaGORCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:08 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 12/94] dma: cppi41: handle 0-length packets
Date: Tue, 15 Jul 2014 20:00:27 +0300
Message-Id: <1405443709-15288-12-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Mack <zonque@gmail.com>

When a 0-length packet is received on the bus, desc->pd0 yields 1,
which confuses the driver's users. This information is clearly wrong
and not in accordance to the datasheet, but it's been observed on an
AM335x board, very reproducible.

Fix this by looking at bit 19 in PD2 of the completed packet. This bit
will tell us if a zero-length packet was received on a queue. If it's
set, ignore the value in PD0 and report a total length of 0 instead.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/dma/cppi41.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index d028f36..8f8b0b6 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -86,6 +86,9 @@
 
 #define USBSS_IRQ_PD_COMP	(1 <<  2)
 
+/* Packet Descriptor */
+#define PD2_ZERO_LENGTH		(1 << 19)
+
 struct cppi41_channel {
 	struct dma_chan chan;
 	struct dma_async_tx_descriptor txd;
@@ -307,7 +310,7 @@ static irqreturn_t cppi41_irq(int irq, void *data)
 			__iormb();
 
 		while (val) {
-			u32 desc;
+			u32 desc, len;
 
 			q_num = __fls(val);
 			val &= ~(1 << q_num);
@@ -319,9 +322,13 @@ static irqreturn_t cppi41_irq(int irq, void *data)
 						q_num, desc);
 				continue;
 			}
-			c->residue = pd_trans_len(c->desc->pd6) -
-				pd_trans_len(c->desc->pd0);
 
+			if (c->desc->pd2 & PD2_ZERO_LENGTH)
+				len = 0;
+			else
+				len = pd_trans_len(c->desc->pd0);
+
+			c->residue = pd_trans_len(c->desc->pd6) - len;
 			dma_cookie_complete(&c->txd);
 			c->txd.callback(c->txd.callback_param);
 		}
-- 
1.7.10.4

