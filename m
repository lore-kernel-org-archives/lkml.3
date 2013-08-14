Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866Ab3HNK7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:59:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab3HNKh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 16/75] virtio_net: fix race in RX VQ processing
Date: Wed, 14 Aug 2013 11:36:05 +0100
Message-Id: <1376476624-10011-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit cbdadbbf0c790f79350a8f36029208944c5487d0 upstream

virtio net called virtqueue_enable_cq on RX path after napi_complete, so
with NAPI_STATE_SCHED clear - outside the implicit napi lock.
This violates the requirement to synchronize virtqueue_enable_cq wrt
virtqueue_add_buf.  In particular, used event can move backwards,
causing us to lose interrupts.
In a debug build, this can trigger panic within START_USE.

Jason Wang reports that he can trigger the races artificially,
by adding udelay() in virtqueue_enable_cb() after virtio_mb().

However, we must call napi_complete to clear NAPI_STATE_SCHED before
polling the virtqueue for used buffers, otherwise napi_schedule_prep in
a callback will fail, causing us to lose RX events.

To fix, call virtqueue_enable_cb_prepare with NAPI_STATE_SCHED
set (under napi lock), later call virtqueue_poll with
NAPI_STATE_SCHED clear (outside the lock).

Reported-by: Jason Wang <jasowang@redhat.com>
Tested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[wg: Backported to 3.2]
Signed-off-by: Wolfram Gloger <wmglo@dent.med.uni-muenchen.de>
Signed-off-by: Luis Henriques<luis.henriques@canonical.com>
---
 drivers/net/virtio_net.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f18149a..858a8da 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -528,7 +528,7 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
 {
 	struct virtnet_info *vi = container_of(napi, struct virtnet_info, napi);
 	void *buf;
-	unsigned int len, received = 0;
+	unsigned int r, len, received = 0;
 
 again:
 	while (received < budget &&
@@ -545,8 +545,9 @@ again:
 
 	/* Out of packets? */
 	if (received < budget) {
+		r = virtqueue_enable_cb_prepare(vi->rvq);
 		napi_complete(napi);
-		if (unlikely(!virtqueue_enable_cb(vi->rvq)) &&
+		if (unlikely(virtqueue_poll(vi->rvq, r)) &&
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(vi->rvq);
 			__napi_schedule(napi);
-- 
1.8.3.2

