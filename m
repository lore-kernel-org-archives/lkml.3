Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbaDALRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:17:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbaDALRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Chan <mchan@broadcom.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 073/144] tg3: Don't check undefined error bits in RXBD
Date: Tue,  1 Apr 2014 12:14:37 +0100
Message-Id: <1396350948-29910-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit d7b95315cc7f441418845a165ee56df723941487 upstream.

Redefine the RXD_ERR_MASK to include only relevant error bits. This fixes
a customer reported issue of randomly dropping packets on the 5719.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 +--
 drivers/net/ethernet/broadcom/tg3.h | 6 +++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 849b141..c200bc2 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6760,8 +6760,7 @@ static int tg3_rx(struct tg3_napi *tnapi, int budget)
 
 		work_mask |= opaque_key;
 
-		if ((desc->err_vlan & RXD_ERR_MASK) != 0 &&
-		    (desc->err_vlan != RXD_ERR_ODD_NIBBLE_RCVD_MII)) {
+		if (desc->err_vlan & RXD_ERR_MASK) {
 		drop_it:
 			tg3_recycle_rx(tnapi, tpr, opaque_key,
 				       desc_idx, *post_ptr);
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index cd63d11..f37417d 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -2588,7 +2588,11 @@ struct tg3_rx_buffer_desc {
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
1.9.1

