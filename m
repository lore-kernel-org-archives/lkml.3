Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760936Ab3BODKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:10:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab3BODKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:10:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Rob Herring <rob.herring@calxeda.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        kernel-team@lists.ubuntu.com
Subject: [ 3.5.y.z extended stable ] Patch "net: calxedaxgmac: throw away overrun frames" has been added to staging queue
Date: Fri, 15 Feb 2013 01:10:32 -0200
Message-Id: <1360897832-15328-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    net: calxedaxgmac: throw away overrun frames

to the linux-3.5.y-queue branch of the 3.5.y.z extended stable tree 
which can be found at:

 http://kernel.ubuntu.com/git?p=ubuntu/linux.git;a=shortlog;h=refs/heads/linux-3.5.y-queue

If you, or anyone else, feels it should not be added to this tree, please 
reply to this email.

For more information about the 3.5.y.z tree, see
https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

Thanks.
-Herton

------

>From f600e21bce4bd4f5c25873bbd8b89b8cdd8dbaef Mon Sep 17 00:00:00 2001
From: Rob Herring <rob.herring@calxeda.com>
Date: Wed, 16 Jan 2013 13:36:37 +0000
Subject: [PATCH] net: calxedaxgmac: throw away overrun frames

commit d6fb3be544b46a7611a3373fcaa62b5b0be01888 upstream.

The xgmac driver assumes 1 frame per descriptor. If a frame larger than
the descriptor's buffer size is received, the frame will spill over into
the next descriptor. So check for received frames that span more than one
descriptor and discard them. This prevents a crash if we receive erroneous
large packets.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/calxeda/xgmac.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 8b0a0e4..8a3cd87 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -546,6 +546,10 @@ static int desc_get_rx_status(struct xgmac_priv *priv, struct xgmac_dma_desc *p)
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
1.7.9.5

