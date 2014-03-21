Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760331AbaCUADb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:03:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760295AbaCUAD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 019/149] tg3: Dont check undefined error bits in RXBD
Date: Thu, 20 Mar 2014 17:03:02 -0700
Message-Id: <20140321000437.612161655@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

[ Upstream commit d7b95315cc7f441418845a165ee56df723941487 ]

Redefine the RXD_ERR_MASK to include only relevant error bits. This fixes
a customer reported issue of randomly dropping packets on the 5719.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/tg3.c |    3 +--
 drivers/net/ethernet/broadcom/tg3.h |    6 +++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6827,8 +6827,7 @@ static int tg3_rx(struct tg3_napi *tnapi
 
 		work_mask |= opaque_key;
 
-		if ((desc->err_vlan & RXD_ERR_MASK) != 0 &&
-		    (desc->err_vlan != RXD_ERR_ODD_NIBBLE_RCVD_MII)) {
+		if (desc->err_vlan & RXD_ERR_MASK) {
 		drop_it:
 			tg3_recycle_rx(tnapi, tpr, opaque_key,
 				       desc_idx, *post_ptr);
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -2601,7 +2601,11 @@ struct tg3_rx_buffer_desc {
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


