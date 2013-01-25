Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3AYJwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 04:52:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:3951 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab3AYJvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 04:51:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,537,1355068800"; 
   d="scan'208";a="6646254"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Eric Dumazet <erdnetdev@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH V8 3/3] virtio-net: reset virtqueue affinity when doing cpu hotplug
Date: Fri, 25 Jan 2013 17:51:31 +0800
Message-Id: <1359107491-6749-3-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359107491-6749-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1359107491-6749-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 17:50:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/25 17:50:43,
	Serialize complete at 2013/01/25 17:50:43
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
Cc: "David S. Miller" <davem@davemloft.net>
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
V5->V6:
	deal with CPU_DOWN_PREPARE separately by just cleaning affinity
V4->V5:
	New method to deal with the cpu hotplug actions (Rusty)

 drivers/net/virtio_net.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 2f6fe9b..35c00c5 100644
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
@@ -1067,6 +1071,26 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
 	vi->affinity_hint_set = true;
 }
 
+static int virtnet_cpu_callback(struct notifier_block *nfb,
+			        unsigned long action, void *hcpu)
+{
+	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
+
+	switch(action & ~CPU_TASKS_FROZEN) {
+	case CPU_ONLINE:
+	case CPU_DOWN_FAILED:
+	case CPU_DEAD:
+		virtnet_set_affinity(vi);
+		break;
+	case CPU_DOWN_PREPARE:
+		virtnet_clean_affinity(vi, (long)hcpu);
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
@@ -1541,6 +1565,13 @@ static int virtnet_probe(struct virtio_device *vdev)
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
@@ -1587,6 +1618,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
 
+	unregister_hotcpu_notifier(&vi->nb);
+
 	/* Prevent config work handler from accessing the device. */
 	mutex_lock(&vi->config_lock);
 	vi->config_enable = false;
-- 
1.8.1

