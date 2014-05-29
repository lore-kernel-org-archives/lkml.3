Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934148AbaE2FQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:16:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615AbaE2Efh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Bj=F8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 107/140] net: cdc_ncm: fix buffer overflow
Date: Wed, 28 May 2014 21:34:06 -0700
Message-Id: <20140529043103.327713075@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc_ncm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -768,7 +768,7 @@ cdc_ncm_fill_tx_frame(struct usbnet *dev
 	    skb_out->len > CDC_NCM_MIN_TX_PKT)
 		memset(skb_put(skb_out, ctx->tx_max - skb_out->len), 0,
 		       ctx->tx_max - skb_out->len);
-	else if ((skb_out->len % dev->maxpacket) == 0)
+	else if (skb_out->len < ctx->tx_max && (skb_out->len % dev->maxpacket) == 0)
 		*skb_put(skb_out, 1) = 0;	/* force short packet */
 
 	/* set final frame length */


