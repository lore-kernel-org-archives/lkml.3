Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaCIWSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 18:18:31 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:55289
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaCIWS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 18:18:29 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next] hyperv: Change the receive buffer size for legacy hosts
Date: Sun,  9 Mar 2014 16:10:59 -0700
Message-Id: <1394406659-22493-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a bug in the Hyper-V host verion 2008R2, we need to use a slightly smaller
receive buffer size, otherwise the buffer will not be accepted by the legacy hosts.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    1 +
 drivers/net/hyperv/netvsc.c     |    6 +++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 39fc230..ea5f182 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -516,6 +516,7 @@ struct nvsp_message {
 #define NETVSC_MTU 65536
 
 #define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*16)	/* 16MB */
+#define NETVSC_RECEIVE_BUFFER_SIZE_LEGACY	(1024*1024*15)  /* 15MB */
 
 #define NETVSC_RECEIVE_BUFFER_ID		0xcafe
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 1a0280d..daddea2 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -365,6 +365,11 @@ static int netvsc_connect_vsp(struct hv_device *device)
 		goto cleanup;
 
 	/* Post the big receive buffer to NetVSP */
+	if (net_device->nvsp_version <= NVSP_PROTOCOL_VERSION_2)
+		net_device->recv_buf_size = NETVSC_RECEIVE_BUFFER_SIZE_LEGACY;
+	else
+		net_device->recv_buf_size = NETVSC_RECEIVE_BUFFER_SIZE;
+
 	ret = netvsc_init_recv_buf(device);
 
 cleanup:
@@ -898,7 +903,6 @@ int netvsc_device_add(struct hv_device *device, void *additional_info)
 	ndev = net_device->ndev;
 
 	/* Initialize the NetVSC channel extension */
-	net_device->recv_buf_size = NETVSC_RECEIVE_BUFFER_SIZE;
 	spin_lock_init(&net_device->recv_pkt_list_lock);
 
 	INIT_LIST_HEAD(&net_device->recv_pkt_list);
-- 
1.7.4.1

