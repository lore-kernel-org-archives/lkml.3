Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291Ab3APXhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:37:00 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:52737 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab3APXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:36:59 -0500
From: Rob Herring <robherring2@gmail.com>
To: netdev@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] net: calxedaxgmac: throw away overrun frames
Date: Wed, 16 Jan 2013 17:36:37 -0600
Message-Id: <1358379397-7152-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The xgmac driver assumes 1 frame per descriptor. If a frame larger than
the descriptor's buffer size is received, the frame will spill over into
the next descriptor. So check for received frames that span more than one
descriptor and discard them. This prevents a crash if we receive erroneous
large packets.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/calxeda/xgmac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index b407043..f7f0290 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -548,6 +548,10 @@ static int desc_get_rx_status(struct xgmac_priv *priv, struct xgmac_dma_desc *p)
 		return -1;
 	}
 
+	/* All frames should fit into a single buffer */
+	if (!(status & RXDESC_FIRST_SEG) || !(status & RXDESC_LAST_SEG))
+		return -1;
+
 	/* Check if packet has checksum already */
 	if ((status & RXDESC_FRAME_TYPE) && (status & RXDESC_EXT_STATUS) &&
 		!(ext_status & RXDESC_IP_PAYLOAD_MASK))
-- 
1.7.10.4

