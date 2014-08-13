Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaHMSEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:04:09 -0400
Received: from mail-pd0-f196.google.com ([209.85.192.196]:48782 "EHLO
	mail-pd0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaHMSEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:04:07 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next,v2] hyperv: Increase the buffer length for netvsc_channel_cb()
Date: Wed, 13 Aug 2014 18:03:44 +0000
Message-Id: <1407953024-35191-1-git-send-email-haiyangz@microsoft.com>
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
 drivers/net/hyperv/hyperv_net.h |    2 +-
 drivers/net/hyperv/netvsc.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index d5e07de..b14a0ef 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -591,7 +591,7 @@ struct nvsp_message {
 
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
 
-#define NETVSC_PACKET_SIZE                      2048
+#define NETVSC_PACKET_SIZE                      4096
 
 #define VRSS_SEND_TAB_SIZE 16
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 66979cf..45899f2 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -38,7 +38,7 @@ static struct netvsc_device *alloc_net_device(struct hv_device *device)
 	struct netvsc_device *net_device;
 	struct net_device *ndev = hv_get_drvdata(device);
 
-	net_device = kzalloc(sizeof(struct netvsc_device), GFP_KERNEL);
+	net_device = vzalloc(sizeof(*net_device));
 	if (!net_device)
 		return NULL;
 
@@ -551,7 +551,7 @@ int netvsc_device_remove(struct hv_device *device)
 	if (net_device->sub_cb_buf)
 		vfree(net_device->sub_cb_buf);
 
-	kfree(net_device);
+	vfree(net_device);
 	return 0;
 }
 
@@ -1093,7 +1093,7 @@ close:
 	vmbus_close(device->channel);
 
 cleanup:
-	kfree(net_device);
+	vfree(net_device);
 
 	return ret;
 }
-- 
1.7.1

