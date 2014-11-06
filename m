Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaKFWoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:44:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279AbaKFWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 023/162] hyperv: Fix a bug in netvsc_start_xmit()
Date: Thu,  6 Nov 2014 14:34:47 -0800
Message-Id: <1415313426-9622-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/hyperv/netvsc_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 6ea06a8..f4aef42 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -147,6 +147,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	struct hv_netvsc_packet *packet;
 	int ret;
 	unsigned int i, num_pages, npg_data;
+	u32 skb_length = skb->len;
 
 	/* Add multipages for skb->data and additional 2 for RNDIS */
 	npg_data = (((unsigned long)skb->data + skb_headlen(skb) - 1)
@@ -217,7 +218,7 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 	ret = rndis_filter_send(net_device_ctx->device_ctx,
 				  packet);
 	if (ret == 0) {
-		net->stats.tx_bytes += skb->len;
+		net->stats.tx_bytes += skb_length;
 		net->stats.tx_packets++;
 	} else {
 		kfree(packet);
-- 
1.9.1

