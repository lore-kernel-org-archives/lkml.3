Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838Ab3KHCgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:36:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34610 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3KHCR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:17:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 30/91] virtio-net: don't respond to cpu hotplug notifier if we're not ready
Date: Thu,  7 Nov 2013 18:14:45 -0800
Message-Id: <1383876946-2396-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

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

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/virtio_net.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 35c00c5..848d26c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1076,6 +1076,11 @@ static int virtnet_cpu_callback(struct notifier_block *nfb,
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
@@ -1088,6 +1093,9 @@ static int virtnet_cpu_callback(struct notifier_block *nfb,
 	default:
 		break;
 	}
+
+done:
+	mutex_unlock(&vi->config_lock);
 	return NOTIFY_OK;
 }
 
-- 
1.8.1.2

