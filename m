Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaEGVtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:49:52 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45646
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbaEGVtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:49:01 -0400
x-originating-ip: 72.167.245.219
From: Haiyang Zhang <haiyangz@microsoft.com>
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: haiyangz@microsoft.com, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: [PATCH net-next] Add support for netvsc build without CONFIG_SYSFS flag
Date: Wed,  7 May 2014 15:45:04 -0700
Message-Id: <1399502704-18495-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change ensures the driver can be built successfully without the
CONFIG_SYSFS flag.
MS-TFS: 182270

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/net/hyperv/hyperv_net.h   |    2 ++
 drivers/net/hyperv/netvsc_drv.c   |   12 +++++++++++-
 drivers/net/hyperv/rndis_filter.c |    4 ++--
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
index 4b7df5a..23b96bc 100644
--- a/drivers/net/hyperv/hyperv_net.h
+++ b/drivers/net/hyperv/hyperv_net.h
@@ -87,6 +87,8 @@ struct ndis_recv_scale_cap { /* NDIS_RECEIVE_SCALE_CAPABILITIES */
 #define HASH_KEYLEN NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2
 extern u8 netvsc_hash_key[];
 
+extern unsigned int netvsc_num_queue;
+
 struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
 	struct ndis_obj_header hdr;
 
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 939e3af..07896f3 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -52,6 +52,8 @@ static int ring_size = 128;
 module_param(ring_size, int, S_IRUGO);
 MODULE_PARM_DESC(ring_size, "Ring buffer size (# of pages)");
 
+unsigned int netvsc_num_queue = 1;
+
 static void do_set_multicast(struct work_struct *w)
 {
 	struct net_device_context *ndevctx =
@@ -639,9 +641,11 @@ int netvsc_recv_callback(struct hv_device *device_obj,
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       packet->vlan_tci);
 
+#ifdef CONFIG_SYSFS
 	skb_record_rx_queue(skb, packet->channel->
 			    offermsg.offer.sub_channel_index %
 			    net->real_num_rx_queues);
+#endif
 
 	net->stats.rx_packets++;
 	net->stats.rx_bytes += packet->total_data_buflen;
@@ -788,7 +792,7 @@ static int netvsc_probe(struct hv_device *dev,
 	int ret;
 
 	net = alloc_etherdev_mq(sizeof(struct net_device_context),
-				num_online_cpus());
+				netvsc_num_queue);
 	if (!net)
 		return -ENOMEM;
 
@@ -824,8 +828,10 @@ static int netvsc_probe(struct hv_device *dev,
 	nvdev = hv_get_drvdata(dev);
 	netif_set_real_num_tx_queues(net, nvdev->num_chn);
 	netif_set_real_num_rx_queues(net, nvdev->num_chn);
+#ifdef CONFIG_SYSFS
 	dev_info(&dev->device, "real num tx,rx queues:%u, %u\n",
 		 net->real_num_tx_queues, net->real_num_rx_queues);
+#endif
 
 	ret = register_netdev(net);
 	if (ret != 0) {
@@ -897,6 +903,10 @@ static void __exit netvsc_drv_exit(void)
 
 static int __init netvsc_drv_init(void)
 {
+#ifdef CONFIG_SYSFS
+	netvsc_num_queue = num_online_cpus();
+#endif
+
 	if (ring_size < RING_SIZE_MIN) {
 		ring_size = RING_SIZE_MIN;
 		pr_info("Increased ring_size to %d (min allowed)\n",
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 99c527a..9db163c 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1094,8 +1094,8 @@ int rndis_filter_device_add(struct hv_device *dev,
 	if (ret || rsscap.num_recv_que < 2)
 		goto out;
 
-	net_device->num_chn = (num_online_cpus() < rsscap.num_recv_que) ?
-			       num_online_cpus() : rsscap.num_recv_que;
+	net_device->num_chn = (netvsc_num_queue < rsscap.num_recv_que) ?
+			       netvsc_num_queue : rsscap.num_recv_que;
 	if (net_device->num_chn == 1)
 		goto out;
 
-- 
1.7.4.1

