Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983Ab3GaN0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47094 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759854Ab3GaN0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jason Wang" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Wolfram Gloger" <wmglo@dent.med.uni-muenchen.de>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.797153437@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [28/84] virtio_net: fix race in RX VQ processing
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit cbdadbbf0c790f79350a8f36029208944c5487d0 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
diff -upr linux-3.2.49/drivers/net/virtio_net.c linux-3.2.49wg/drivers/net/virtio_net.c
--- linux-3.2.49/drivers/net/virtio_net.c	2012-01-05 00:55:44.000000000 +0100
+++ linux-3.2.49wg/drivers/net/virtio_net.c	2013-07-27 13:57:33.000000000 +0200
@@ -508,7 +508,7 @@ static int virtnet_poll(struct napi_stru
 {
 	struct virtnet_info *vi = container_of(napi, struct virtnet_info, napi);
 	void *buf;
-	unsigned int len, received = 0;
+	unsigned int r, len, received = 0;
 
 again:
 	while (received < budget &&
@@ -525,8 +525,9 @@ again:
 
 	/* Out of packets? */
 	if (received < budget) {
+		r = virtqueue_enable_cb_prepare(vi->rvq);
 		napi_complete(napi);
-		if (unlikely(!virtqueue_enable_cb(vi->rvq)) &&
+		if (unlikely(virtqueue_poll(vi->rvq, r)) &&
 		    napi_schedule_prep(napi)) {
 			virtqueue_disable_cb(vi->rvq);
 			__napi_schedule(napi);

