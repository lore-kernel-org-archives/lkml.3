Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbaDUU7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:59:48 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44842
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaDUU7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:59:38 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v2,2/2] hyperv: Simplify the send_completion variables
Date: Mon, 21 Apr 2014 14:54:44 -0700
Message-Id: <1398117284-5236-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1398117284-5236-1-git-send-email-haiyangz@microsoft.com>
References: <1398117284-5236-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The union contains only one member now, so we use the variables in it directly.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |   10 +++-------
 drivers/net/hyperv/netvsc.c       |    7 +++----
 drivers/net/hyperv/netvsc_drv.c   |    8 ++++----
 drivers/net/hyperv/rndis_filter.c |    2 +-
 4 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index a1af0f7..d1f7826 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -136,13 +136,9 @@ struct hv_netvsc_packet {
 	u16 q_idx;
 	struct vmbus_channel *channel;
 
-	union {
-		struct {
-			u64 send_completion_tid;
-			void *send_completion_ctx;
-			void (*send_completion)(void *context);
-		} send;
-	} completion;
+	u64 send_completion_tid;
+	void *send_completion_ctx;
+	void (*send_completion)(void *context);
 
 	/* This points to the memory after page_buf */
 	struct rndis_message *rndis_msg;
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index b103347..bbee446 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -479,9 +479,8 @@ static void netvsc_send_completion(struct netvsc_device *net_device,
 		if (nvsc_packet) {
 			q_idx = nvsc_packet->q_idx;
 			channel = nvsc_packet->channel;
-			nvsc_packet->completion.send.send_completion(
-				nvsc_packet->completion.send.
-				send_completion_ctx);
+			nvsc_packet->send_completion(nvsc_packet->
+						     send_completion_ctx);
 		}
 
 		num_outstanding_sends =
@@ -534,7 +533,7 @@ int netvsc_send(struct hv_device *device,
 		0xFFFFFFFF;
 	sendMessage.msg.v1_msg.send_rndis_pkt.send_buf_section_size = 0;
 
-	if (packet->completion.send.send_completion)
+	if (packet->send_completion)
 		req_id = (ulong)packet;
 	else
 		req_id = 0;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 8f6d53a..c76b665 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -235,7 +235,7 @@ static void netvsc_xmit_completion(void *context)
 {
 	struct hv_netvsc_packet *packet = (struct hv_netvsc_packet *)context;
 	struct sk_buff *skb = (struct sk_buff *)
-		(unsigned long)packet->completion.send.send_completion_tid;
+		(unsigned long)packet->send_completion_tid;
 
 	kfree(packet);
 
@@ -425,9 +425,9 @@ static int netvsc_start_xmit(struct sk_buff *skb, struct net_device *net)
 				(num_data_pgs * sizeof(struct hv_page_buffer)));
 
 	/* Set the completion routine */
-	packet->completion.send.send_completion = netvsc_xmit_completion;
-	packet->completion.send.send_completion_ctx = packet;
-	packet->completion.send.send_completion_tid = (unsigned long)skb;
+	packet->send_completion = netvsc_xmit_completion;
+	packet->send_completion_ctx = packet;
+	packet->send_completion_tid = (unsigned long)skb;
 
 	isvlan = packet->vlan_tci & VLAN_TAG_PRESENT;
 
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 48f5a0f..99c527a 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -236,7 +236,7 @@ static int rndis_filter_send_request(struct rndis_device *dev,
 			packet->page_buf[0].len;
 	}
 
-	packet->completion.send.send_completion = NULL;
+	packet->send_completion = NULL;
 
 	ret = netvsc_send(dev->net_dev->dev, packet);
 	return ret;
-- 
1.7.4.1

