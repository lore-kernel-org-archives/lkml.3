Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaHOTSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:18:37 -0400
Received: from mail-pa0-f67.google.com ([209.85.220.67]:64769 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaHOTSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:18:35 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v3] hyperv: Increase the buffer length for netvsc_channel_cb()
Date: Fri, 15 Aug 2014 19:18:19 +0000
Message-Id: <1408130299-50848-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the buffer is too small for a packet from VMBus, a bigger buffer will be
allocated in netvsc_channel_cb() and retry reading the packet from VMBus.
Increasing this buffer size will reduce the retry overhead.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    4 ++--
 drivers/net/hyperv/netvsc.c     |   16 ++++++++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index d5e07de..2f48f79 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -591,7 +591,7 @@ struct nvsp_message {
 
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
 
-#define NETVSC_PACKET_SIZE                      2048
+#define NETVSC_PACKET_SIZE                      4096
 
 #define VRSS_SEND_TAB_SIZE 16
 
@@ -642,7 +642,7 @@ struct netvsc_device {
 	int ring_size;
 
 	/* The primary channel callback buffer */
-	unsigned char cb_buffer[NETVSC_PACKET_SIZE];
+	unsigned char *cb_buffer;
 	/* The sub channel callback buffer */
 	unsigned char *sub_cb_buf;
 };
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 66979cf..5b5644a 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -42,6 +42,12 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	if (!net_device)
 		return NULL;
 
+	net_device->cb_buffer = kzalloc(NETVSC_PACKET_SIZE, GFP_KERNEL);
+	if (!net_device->cb_buffer) {
+		kfree(net_device);
+		return NULL;
+	}
+
 	init_waitqueue_head(&net_device->wait_drain);
 	net_device->start_remove = false;
 	net_device->destroy = false;
@@ -52,6 +58,12 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	return net_device;
 }
 
+static void free_netvsc_device(struct netvsc_device *nvdev)
+{
+	kfree(nvdev->cb_buffer);
+	kfree(nvdev);
+}
+
 static struct netvsc_device *get_outbound_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
@@ -551,7 +563,7 @@ int netvsc_device_remove(struct hv_device *device)
 	if (net_device->sub_cb_buf)
 		vfree(net_device->sub_cb_buf);
 
-	kfree(net_device);
+	free_netvsc_device(net_device);
 	return 0;
 }
 
@@ -1093,7 +1105,7 @@ close:
 	vmbus_close(device->channel);
 
 cleanup:
-	kfree(net_device);
+	free_netvsc_device(net_device);
 
 	return ret;
 }
-- 
1.7.1

