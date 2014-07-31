Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbaGaASf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 20:18:35 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58428
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbaGaASd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 20:18:33 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: net-next: hyperv
Date: Wed, 30 Jul 2014 18:20:16 -0700
Message-Id: <1406769616-29871-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For forwarding scenarios, it will be useful to allocate larger
sendbuf. Make the necessary adjustments to permit this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h |    2 +-
 drivers/net/hyperv/netvsc.c     |    7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 6cc37c1..40ba1ef 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -584,7 +584,7 @@ struct nvsp_message {
 
 #define NETVSC_RECEIVE_BUFFER_SIZE		(1024*1024*16)	/* 16MB */
 #define NETVSC_RECEIVE_BUFFER_SIZE_LEGACY	(1024*1024*15)  /* 15MB */
-#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024)   /* 1MB */
+#define NETVSC_SEND_BUFFER_SIZE			(1024 * 1024 * 16)   /* 16MB */
 #define NETVSC_INVALID_INDEX			-1
 
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index c041f63..c76178e 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -193,8 +193,7 @@ static int netvsc_destroy_buf(struct netvsc_device *net_device)
 	}
 	if (net_device->send_buf) {
 		/* Free up the receive buffer */
-		free_pages((unsigned long)net_device->send_buf,
-			   get_order(net_device->send_buf_size));
+		vfree(net_device->send_buf);
 		net_device->send_buf = NULL;
 	}
 	kfree(net_device->send_section_map);
@@ -303,9 +302,7 @@ static int netvsc_init_buf(struct hv_device *device)
 
 	/* Now setup the send buffer.
 	 */
-	net_device->send_buf =
-		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
-					 get_order(net_device->send_buf_size));
+	net_device->send_buf = vzalloc(net_device->send_buf_size);
 	if (!net_device->send_buf) {
 		netdev_err(ndev, "unable to allocate send "
 			   "buffer of size %d\n", net_device->send_buf_size);
-- 
1.7.4.1

