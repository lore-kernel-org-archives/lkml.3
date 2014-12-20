Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbaLTBPP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:15:15 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:45525
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbaLTBPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:15:14 -0500
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next] hyperv: Fix some variable name typos in send-buffer init/revoke
Date: Fri, 19 Dec 2014 18:25:18 -0800
Message-Id: <1419042318-7221-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The changed names are union fields with the same size, so the existing code
still works. But, we now update these variables to the correct names.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    1 +
 drivers/net/hyperv/netvsc.c     |   15 ++++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 2f48f79..384ca4f 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -590,6 +590,7 @@ struct nvsp_message {
 
 
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
+#define NETVSC_SEND_BUFFER_ID			0
 
 #define NETVSC_PACKET_SIZE                      4096
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index dd867e6..9f49c01 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -161,8 +161,8 @@ static int netvsc_destroy_buf(struct netvsc_device *net_device)
 
 	/* Deal with the send buffer we may have setup.
 	 * If we got a  send section size, it means we received a
-	 * SendsendBufferComplete msg (ie sent
-	 * NvspMessage1TypeSendReceiveBuffer msg) therefore, we need
+	 * NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE msg (ie sent
+	 * NVSP_MSG1_TYPE_SEND_SEND_BUF msg) therefore, we need
 	 * to send a revoke msg here
 	 */
 	if (net_device->send_section_size) {
@@ -172,7 +172,8 @@ static int netvsc_destroy_buf(struct netvsc_device *net_device)
 
 		revoke_packet->hdr.msg_type =
 			NVSP_MSG1_TYPE_REVOKE_SEND_BUF;
-		revoke_packet->msg.v1_msg.revoke_recv_buf.id = 0;
+		revoke_packet->msg.v1_msg.revoke_send_buf.id =
+			NETVSC_SEND_BUFFER_ID;
 
 		ret = vmbus_sendpacket(net_device->dev->channel,
 				       revoke_packet,
@@ -204,7 +205,7 @@ static int netvsc_destroy_buf(struct netvsc_device *net_device)
 		net_device->send_buf_gpadl_handle = 0;
 	}
 	if (net_device->send_buf) {
-		/* Free up the receive buffer */
+		/* Free up the send buffer */
 		vfree(net_device->send_buf);
 		net_device->send_buf = NULL;
 	}
@@ -339,9 +340,9 @@ static int netvsc_init_buf(struct hv_device *device)
 	init_packet = &net_device->channel_init_pkt;
 	memset(init_packet, 0, sizeof(struct nvsp_message));
 	init_packet->hdr.msg_type = NVSP_MSG1_TYPE_SEND_SEND_BUF;
-	init_packet->msg.v1_msg.send_recv_buf.gpadl_handle =
+	init_packet->msg.v1_msg.send_send_buf.gpadl_handle =
 		net_device->send_buf_gpadl_handle;
-	init_packet->msg.v1_msg.send_recv_buf.id = 0;
+	init_packet->msg.v1_msg.send_send_buf.id = NETVSC_SEND_BUFFER_ID;
 
 	/* Send the gpadl notification request */
 	ret = vmbus_sendpacket(device->channel, init_packet,
@@ -364,7 +365,7 @@ static int netvsc_init_buf(struct hv_device *device)
 		netdev_err(ndev, "Unable to complete send buffer "
 			   "initialization with NetVsp - status %d\n",
 			   init_packet->msg.v1_msg.
-			   send_recv_buf_complete.status);
+			   send_send_buf_complete.status);
 		ret = -EINVAL;
 		goto cleanup;
 	}
-- 
1.7.1

