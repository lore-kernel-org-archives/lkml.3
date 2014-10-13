Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaJMC7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:59:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaJMCZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:25:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Long Li <longli@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 09/16] hyperv: Fix a bug in netvsc_start_xmit()
Date: Mon, 13 Oct 2014 04:24:06 +0200
Message-Id: <20141013022341.793972022@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022341.386913672@linuxfoundation.org>
References: <20141013022341.386913672@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KY Srinivasan <kys@microsoft.com>

[ Upstream commit dedb845ded56ded1c62f5398a94ffa8615d4592d ]

After the packet is successfully sent, we should not touch the skb
as it may have been freed. This patch is based on the work done by
Long Li <longli@microsoft.com>.

In this version of the patch I have fixed issues pointed out by David.
David, please queue this up for stable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Tested-by: Long Li <longli@microsoft.com>
Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -138,6 +138,7 @@ static int netvsc_start_xmit(struct sk_b
 	struct hv_netvsc_packet *packet;
 	int ret;
 	unsigned int i, num_pages, npg_data;
+	u32 skb_length = skb->len;
 
 	/* Add multipages for skb->data and additional 2 for RNDIS */
 	npg_data = (((unsigned long)skb->data + skb_headlen(skb) - 1)
@@ -208,7 +209,7 @@ static int netvsc_start_xmit(struct sk_b
 	ret = rndis_filter_send(net_device_ctx->device_ctx,
 				  packet);
 	if (ret == 0) {
-		net->stats.tx_bytes += skb->len;
+		net->stats.tx_bytes += skb_length;
 		net->stats.tx_packets++;
 	} else {
 		kfree(packet);


