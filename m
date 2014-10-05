Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbaJEQkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:40:47 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:35680
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaJEQko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:40:44 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH net 1/1] hyperv: Fix a bug in netvsc_send()
Date: Sun,  5 Oct 2014 10:42:51 -0700
Message-Id: <1412530971-29897-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the packet is successfully sent, we should not touch the packet 
as it may have been freed. This patch is based on the work done by
Long Li <longli@microsoft.com>.

David, please queue this up for stable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/net/hyperv/netvsc.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 977984b..7d76c95 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -717,6 +717,7 @@ int netvsc_send(struct hv_device *device,
 	unsigned int section_index = NETVSC_INVALID_INDEX;
 	u32 msg_size = 0;
 	struct sk_buff *skb;
+	u16 q_idx = packet->q_idx;
 
 
 	net_device = get_outbound_net_device(device);
@@ -781,24 +782,24 @@ int netvsc_send(struct hv_device *device,
 
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
-- 
1.7.4.1

