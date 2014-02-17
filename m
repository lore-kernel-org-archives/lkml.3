Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbaBPXsA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:48:00 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:38460
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbaBPXrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:47:32 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/3] Drivers: net: hyperv: Cleanup the netvsc receive callback functio
Date: Sun, 16 Feb 2014 16:38:45 -0800
Message-Id: <1392597525-13346-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1392597525-13346-1-git-send-email-kys@microsoft.com>
References: <1392597483-13307-1-git-send-email-kys@microsoft.com>
 <1392597525-13346-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the buffer allocation in the receive path for normal packets.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    2 ++
 drivers/net/hyperv/netvsc.c     |   33 ++++++++++-----------------------
 2 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 7645ba3..01a16ea 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -506,6 +506,8 @@ struct netvsc_device {
 
 	/* Holds rndis device info */
 	void *extension;
+	/* The recive buffer for this device */
+	unsigned char cb_buffer[NETVSC_PACKET_SIZE];
 };
 
 /* NdisInitialize message */
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 7fa2bba..9a0e9c6 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -795,22 +795,16 @@ static void netvsc_channel_cb(void *context)
 	struct netvsc_device *net_device;
 	u32 bytes_recvd;
 	u64 request_id;
-	unsigned char *packet;
 	struct vmpacket_descriptor *desc;
 	unsigned char *buffer;
 	int bufferlen = NETVSC_PACKET_SIZE;
 	struct net_device *ndev;
 
-	packet = kzalloc(NETVSC_PACKET_SIZE * sizeof(unsigned char),
-			 GFP_ATOMIC);
-	if (!packet)
-		return;
-	buffer = packet;
-
 	net_device = get_inbound_net_device(device);
 	if (!net_device)
-		goto out;
+		return;
 	ndev = net_device->ndev;
+	buffer = net_device->cb_buffer;
 
 	do {
 		ret = vmbus_recvpacket_raw(device->channel, buffer, bufferlen,
@@ -838,23 +832,16 @@ static void netvsc_channel_cb(void *context)
 					break;
 				}
 
-				/* reset */
-				if (bufferlen > NETVSC_PACKET_SIZE) {
-					kfree(buffer);
-					buffer = packet;
-					bufferlen = NETVSC_PACKET_SIZE;
-				}
 			} else {
-				/* reset */
-				if (bufferlen > NETVSC_PACKET_SIZE) {
-					kfree(buffer);
-					buffer = packet;
-					bufferlen = NETVSC_PACKET_SIZE;
-				}
-
+				/*
+				 * We are done for this pass.
+				 */
 				break;
 			}
+
 		} else if (ret == -ENOBUFS) {
+			if (bufferlen > NETVSC_PACKET_SIZE)
+				kfree(buffer);
 			/* Handle large packet */
 			buffer = kmalloc(bytes_recvd, GFP_ATOMIC);
 			if (buffer == NULL) {
@@ -869,8 +856,8 @@ static void netvsc_channel_cb(void *context)
 		}
 	} while (1);
 
-out:
-	kfree(buffer);
+	if (bufferlen > NETVSC_PACKET_SIZE)
+		kfree(buffer);
 	return;
 }
 
-- 
1.7.4.1

