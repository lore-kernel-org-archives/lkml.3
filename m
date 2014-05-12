Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaELBuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:50:35 -0400
Received: from 1wt.eu ([62.212.114.60]:34763 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbaELBn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:58 -0400
Message-Id: <20140512003204.961991014@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 104/143] tg3: Dont check undefined error bits in RXBD
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

[ Upstream commit d7b95315cc7f441418845a165ee56df723941487 ]

Redefine the RXD_ERR_MASK to include only relevant error bits. This fixes
a customer reported issue of randomly dropping packets on the 5719.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/tg3.c | 3 +--
 drivers/net/tg3.h | 6 +++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tg3.c b/drivers/net/tg3.c
index 56648b4..17e8abe 100644
--- a/drivers/net/tg3.c
+++ b/drivers/net/tg3.c
@@ -4557,8 +4557,7 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 
 		work_mask |= opaque_key;
 
-		if ((desc->err_vlan & RXD_ERR_MASK) != 0 &&
-		    (desc->err_vlan != RXD_ERR_ODD_NIBBLE_RCVD_MII)) {
+		if (desc->err_vlan & RXD_ERR_MASK) {
 		drop_it:
 			tg3_recycle_rx(tnapi, opaque_key,
 				       desc_idx, *post_ptr);
diff --git a/drivers/net/tg3.h b/drivers/net/tg3.h
index 529f55a..593f8c6 100644
--- a/drivers/net/tg3.h
+++ b/drivers/net/tg3.h
@@ -2219,7 +2219,11 @@ struct tg3_rx_buffer_desc {
 #define RXD_ERR_TOO_SMALL		0x00400000
 #define RXD_ERR_NO_RESOURCES		0x00800000
 #define RXD_ERR_HUGE_FRAME		0x01000000
-#define RXD_ERR_MASK			0xffff0000
+
+#define RXD_ERR_MASK	(RXD_ERR_BAD_CRC | RXD_ERR_COLLISION |		\
+			 RXD_ERR_LINK_LOST | RXD_ERR_PHY_DECODE |	\
+			 RXD_ERR_MAC_ABRT | RXD_ERR_TOO_SMALL |		\
+			 RXD_ERR_NO_RESOURCES | RXD_ERR_HUGE_FRAME)
 
 	u32				reserved;
 	u32				opaque;
-- 
1.7.12.2.21.g234cd45.dirty



