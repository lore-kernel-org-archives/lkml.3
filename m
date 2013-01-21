Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3AUL0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:26:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36146 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3AUL0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:26:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,506,1355068800"; 
   d="scan'208";a="6622339"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V6 2/3] virtio-net: split out clean affinity function
Date: Mon, 21 Jan 2013 19:25:23 +0800
Message-Id: <1358767524-17934-2-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1358767524-17934-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1358767524-17934-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/21 19:24:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/21 19:24:45,
	Serialize complete at 2013/01/21 19:24:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the clean affinity function to virtnet_clean_affinity().

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Eric Dumazet <erdnetdev@gmail.com>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
V5->V6: NEW

 drivers/net/virtio_net.c | 67 +++++++++++++++++++++++++++---------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 70cd957..1a35a8c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1016,48 +1016,57 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev, u16 vid)
 	return 0;
 }
 
-static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
+static void virtnet_clean_affinity(struct virtnet_info *vi, long hcpu)
 {
 	int i;
 	int cpu;
 
-	/* In multiqueue mode, when the number of cpu is equal to the number of
-	 * queue pairs, we let the queue pairs to be private to one cpu by
-	 * setting the affinity hint to eliminate the contention.
-	 */
-	if ((vi->curr_queue_pairs == 1 ||
-	     vi->max_queue_pairs != num_online_cpus()) && set) {
-		if (vi->affinity_hint_set)
-			set = false;
-		else
-			return;
-	}
-
-	if (set) {
-		i = 0;
-		for_each_online_cpu(cpu) {
-			virtqueue_set_affinity(vi->rq[i].vq, cpu);
-			virtqueue_set_affinity(vi->sq[i].vq, cpu);
-			*per_cpu_ptr(vi->vq_index, cpu) = i;
-			i++;
-		}
-
-		vi->affinity_hint_set = true;
-	} else {
-		for(i = 0; i < vi->max_queue_pairs; i++) {
+	if (vi->affinity_hint_set) {
+		for (i = 0; i < vi->max_queue_pairs; i++) {
 			virtqueue_set_affinity(vi->rq[i].vq, -1);
 			virtqueue_set_affinity(vi->sq[i].vq, -1);
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
 
+static void virtnet_set_affinity(struct virtnet_info *vi)
+{
+	int i;
+	int cpu;
+
+	/* In multiqueue mode, when the number of cpu is equal to the number of
+	 * queue pairs, we let the queue pairs to be private to one cpu by
+	 * setting the affinity hint to eliminate the contention.
+	 */
+	if (vi->curr_queue_pairs == 1 ||
+	    vi->max_queue_pairs != num_online_cpus()) {
+		if (vi->affinity_hint_set)
+			virtnet_clean_affinity(vi, -1);
+		else
+			return;
+	}
+
+	i = 0;
+	for_each_online_cpu(cpu) {
+		virtqueue_set_affinity(vi->rq[i].vq, cpu);
+		virtqueue_set_affinity(vi->sq[i].vq, cpu);
+		*per_cpu_ptr(vi->vq_index, cpu) = i;
+		i++;
+	}
+
+	vi->affinity_hint_set = true;
+}
+
 static void virtnet_get_ringparam(struct net_device *dev,
 				struct ethtool_ringparam *ring)
 {
@@ -1105,7 +1114,7 @@ static int virtnet_set_channels(struct net_device *dev,
 		netif_set_real_num_rx_queues(dev, queue_pairs);
 
 		get_online_cpus();
-		virtnet_set_affinity(vi, true);
+		virtnet_set_affinity(vi);
 		put_online_cpus();
 	}
 
@@ -1274,7 +1283,7 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
 {
 	struct virtio_device *vdev = vi->vdev;
 
-	virtnet_set_affinity(vi, false);
+	virtnet_clean_affinity(vi, -1);
 
 	vdev->config->del_vqs(vdev);
 
@@ -1398,7 +1407,7 @@ static int init_vqs(struct virtnet_info *vi)
 		goto err_free;
 
 	get_online_cpus();
-	virtnet_set_affinity(vi, true);
+	virtnet_set_affinity(vi);
 	put_online_cpus();
 
 	return 0;
-- 
1.8.1

