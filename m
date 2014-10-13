Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaJMCa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:30:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaJMCaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 04/25] hyperv: Fix a bug in netvsc_send()
Date: Mon, 13 Oct 2014 04:24:57 +0200
Message-Id: <20141013022454.468467885@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KY Srinivasan <kys@microsoft.com>

[ Upstream commit 3a67c9ccad926a168d8b7891537a452018368a5b ]

After the packet is successfully sent, we should not touch the packet
as it may have been freed. This patch is based on the work done by
Long Li <longli@microsoft.com>.

David, please queue this up for stable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -705,6 +705,7 @@ int netvsc_send(struct hv_device *device
 	unsigned int section_index = NETVSC_INVALID_INDEX;
 	u32 msg_size = 0;
 	struct sk_buff *skb;
+	u16 q_idx = packet->q_idx;
 
 
 	net_device = get_outbound_net_device(device);
@@ -769,24 +770,24 @@ int netvsc_send(struct hv_device *device
 
 	if (ret == 0) {
 		atomic_inc(&net_device->num_outstanding_sends);
-		atomic_inc(&net_device->queue_sends[packet->q_idx]);
+		atomic_inc(&net_device->queue_sends[q_idx]);
 
 		if (hv_ringbuf_avail_percent(&out_channel->outbound) <
 			RING_AVAIL_PERCENT_LOWATER) {
 			netif_tx_stop_queue(netdev_get_tx_queue(
-					    ndev, packet->q_idx));
+					    ndev, q_idx));
 
 			if (atomic_read(&net_device->
-				queue_sends[packet->q_idx]) < 1)
+				queue_sends[q_idx]) < 1)
 				netif_tx_wake_queue(netdev_get_tx_queue(
-						    ndev, packet->q_idx));
+						    ndev, q_idx));
 		}
 	} else if (ret == -EAGAIN) {
 		netif_tx_stop_queue(netdev_get_tx_queue(
-				    ndev, packet->q_idx));
-		if (atomic_read(&net_device->queue_sends[packet->q_idx]) < 1) {
+				    ndev, q_idx));
+		if (atomic_read(&net_device->queue_sends[q_idx]) < 1) {
 			netif_tx_wake_queue(netdev_get_tx_queue(
-					    ndev, packet->q_idx));
+					    ndev, q_idx));
 			ret = -ENOSPC;
 		}
 	} else {


