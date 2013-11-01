Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3KAWVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:21:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756277Ab3KAWIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:08:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 32/66] virtio-net: dont respond to cpu hotplug notifier if were not ready
Date: Fri,  1 Nov 2013 15:07:08 -0700
Message-Id: <20131101220643.618047170@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 3ab098df35f8b98b6553edc2e40234af512ba877 ]

We're trying to re-configure the affinity unconditionally in cpu hotplug
callback. This may lead the issue during resuming from s3/s4 since

- virt queues haven't been allocated at that time.
- it's unnecessary since thaw method will re-configure the affinity.

Fix this issue by checking the config_enable and do nothing is we're not ready.

The bug were introduced by commit 8de4b2f3ae90c8fc0f17eeaab87d5a951b66ee17
(virtio-net: reset virtqueue affinity when doing cpu hotplug).

Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1094,6 +1094,11 @@ static int virtnet_cpu_callback(struct n
 {
 	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
 
+	mutex_lock(&vi->config_lock);
+
+	if (!vi->config_enable)
+		goto done;
+
 	switch(action & ~CPU_TASKS_FROZEN) {
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
@@ -1106,6 +1111,9 @@ static int virtnet_cpu_callback(struct n
 	default:
 		break;
 	}
+
+done:
+	mutex_unlock(&vi->config_lock);
 	return NOTIFY_OK;
 }
 


