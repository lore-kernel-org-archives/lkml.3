Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3BLUtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:49:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53928 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab3BLUlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [ 12/36] net: calxedaxgmac: throw away overrun frames
Date: Tue, 12 Feb 2013 12:41:06 -0800
Message-Id: <20130212203858.764747327@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Rob Herring <rob.herring@calxeda.com>

[ Upstream commit d6fb3be544b46a7611a3373fcaa62b5b0be01888 ]

The xgmac driver assumes 1 frame per descriptor. If a frame larger than
the descriptor's buffer size is received, the frame will spill over into
the next descriptor. So check for received frames that span more than one
descriptor and discard them. This prevents a crash if we receive erroneous
large packets.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/calxeda/xgmac.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -547,6 +547,10 @@ static int desc_get_rx_status(struct xgm
 		return -1;
 	}
 
+	/* All frames should fit into a single buffer */
+	if (!(status & RXDESC_FIRST_SEG) || !(status & RXDESC_LAST_SEG))
+		return -1;
+
 	/* Check if packet has checksum already */
 	if ((status & RXDESC_FRAME_TYPE) && (status & RXDESC_EXT_STATUS) &&
 		!(ext_status & RXDESC_IP_PAYLOAD_MASK))


