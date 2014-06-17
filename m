Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967620AbaFQW2R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:28:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54245 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966450AbaFQVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:49:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/212] net: cdc_ncm: fix buffer overflow
Date: Tue, 17 Jun 2014 14:42:16 -0700
Message-Id: <1403041506-13646-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>

[ Upstream commit 9becd707841207652449a8dfd90fe9c476d88546 ]

Commit 4d619f625a60 ("net: cdc_ncm: no point in filling up the NTBs
if we send ZLPs") changed the padding logic for devices with the ZLP
flag set.  This meant that frames of any size will be sent without
additional padding, except for the single byte added if the size is
a multiple of the USB packet size. But if the unpadded size is
identical to the maximum frame size, and the maximum size is a
multiplum of the USB packet size, then this one-byte padding will
overflow the buffer.

Prevent padding if already at maximum frame size, letting usbnet
transmit a ZLP instead in this case.

Fixes: 4d619f625a60 ("net: cdc_ncm: no point in filling up the NTBs if we send ZLPs")
Reported by: Yu-an Shih <yshih@nvidia.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/cdc_ncm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index b74f5ff..f2c3646 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -769,7 +769,7 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev, struct sk_buff *skb, __le32 sign)
 	    skb_out->len > CDC_NCM_MIN_TX_PKT)
 		memset(skb_put(skb_out, ctx->tx_max - skb_out->len), 0,
 		       ctx->tx_max - skb_out->len);
-	else if ((skb_out->len % dev->maxpacket) == 0)
+	else if (skb_out->len < ctx->tx_max && (skb_out->len % dev->maxpacket) == 0)
 		*skb_put(skb_out, 1) = 0;	/* force short packet */
 
 	/* set final frame length */
-- 
1.9.1

