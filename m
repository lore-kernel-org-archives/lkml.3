Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab3ARFcZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 00:32:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:26573 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab3ARFcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 00:32:13 -0500
X-IronPort-AV: E=Sophos;i="4.84,489,1355068800"; 
   d="scan'208";a="6610208"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V5 2/2] virtio-net: reset virtqueue affinity when doing cpu hotplug
Date: Fri, 18 Jan 2013 13:32:01 +0800
Message-Id: <1358487121-7956-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358487121-7956-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1358487121-7956-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 13:31:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/18 13:31:23,
	Serialize complete at 2013/01/18 13:31:23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a cpu notifier to virtio-net, so that we can reset the
virtqueue affinity if the cpu hotplug happens. It improve
the performance through enabling or disabling the virtqueue
affinity after doing cpu hotplug.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <erdnetdev@gmail.com>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
V4->V5:
	New method to deal with the cpu hotplug actions (Rusty)

 drivers/net/virtio_net.c | 50 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 440b0eb..061f2c5 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -26,6 +26,7 @@
 #include <linux/scatterlist.h>
 #include <linux/if_vlan.h>
 #include <linux/slab.h>
+#include <linux/cpu.h>
 
 static int napi_weight = 128;
 module_param(napi_weight, int, 0444);
@@ -126,6 +127,9 @@ struct virtnet_info {
 
 	/* Per-cpu variable to show the mapping from CPU to virtqueue */
 	int __percpu *vq_index;
+
+	/* CPU hot plug notifier */
+	struct notifier_block nb;
 };
 
 struct skb_vnet_hdr {
@@ -1016,7 +1020,7 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev, u16 vid)
 	return 0;
 }
 
-static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
+static void virtnet_set_affinity(struct virtnet_info *vi, bool set, long hcpu)
 {
 	int i;
 	int cpu;
@@ -1026,7 +1030,8 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 	 * setting the affinity hint to eliminate the contention.
 	 */
 	if ((vi->curr_queue_pairs == 1 ||
-	     vi->max_queue_pairs != num_online_cpus()) && set) {
+	     vi->max_queue_pairs != num_online_cpus() - ((hcpu == -1) ? 0 : 1))
+	    && set) {
 		if (vi->affinity_hint_set)
 			set = false;
 		else
@@ -1036,6 +1041,8 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 	if (set) {
 		i = 0;
 		for_each_online_cpu(cpu) {
+			if (cpu == hcpu)
+				continue;
 			virtqueue_set_affinity(vi->rq[i].vq, cpu);
 			virtqueue_set_affinity(vi->sq[i].vq, cpu);
 			*per_cpu_ptr(vi->vq_index, cpu) = i;
@@ -1050,14 +1057,36 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
 		}
 
 		i = 0;
-		for_each_online_cpu(cpu)
+		for_each_online_cpu(cpu) {
+			if (cpu == hcpu)
+				continue;
 			*per_cpu_ptr(vi->vq_index, cpu) =
 				++i % vi->curr_queue_pairs;
+		}
 
 		vi->affinity_hint_set = false;
 	}
 }
 
+static int virtnet_cpu_callback(struct notifier_block *nfb,
+			        unsigned long action, void *hcpu)
+{
+	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
+
+	switch(action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+		virtnet_set_affinity(vi, true, -1);
+		break;
+	case CPU_DOWN_PREPARE:
+		virtnet_set_affinity(vi, true, (long)hcpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 static void virtnet_get_ringparam(struct net_device *dev,
 				struct ethtool_ringparam *ring)
 {
@@ -1105,7 +1134,7 @@ static int virtnet_set_channels(struct net_device *dev,
 		netif_set_real_num_rx_queues(dev, queue_pairs);
 
 		get_online_cpus();
-		virtnet_set_affinity(vi, true);
+		virtnet_set_affinity(vi, true, -1);
 		put_online_cpus();
 	}
 
@@ -1275,7 +1304,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
 	struct virtio_device *vdev = vi->vdev;
 
 	get_online_cpus();
-	virtnet_set_affinity(vi, false);
+	virtnet_set_affinity(vi, false, -1);
 	put_online_cpus();
 
 	vdev->config->del_vqs(vdev);
@@ -1400,7 +1429,7 @@ static int init_vqs(struct virtnet_info *vi)
 		goto err_free;
 
 	get_online_cpus();
-	virtnet_set_affinity(vi, true);
+	virtnet_set_affinity(vi, true, -1);
 	put_online_cpus();
 
 	return 0;
@@ -1534,6 +1563,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 		}
 	}
 
+	vi->nb.notifier_call = &virtnet_cpu_callback;
+	err = register_hotcpu_notifier(&vi->nb);
+	if (err) {
+		pr_debug("virtio_net: registering cpu notifier failed\n");
+		goto free_recv_bufs;
+	}
+
 	/* Assume link up if device can't report link status,
 	   otherwise get link status from config. */
 	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_STATUS)) {
@@ -1580,6 +1616,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
 
+	unregister_hotcpu_notifier(&vi->nb);
+
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = false;
-- 
1.8.1

