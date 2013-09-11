Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3IKEa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:30:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3623 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab3IKE3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:29:05 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ulkYN_iQIDMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mAe00Se35yEA:10 a=20KFwNOVAAAA:8 a=J1Y8HTJGAAAA:8 a=wAwfuhEyL-vLSwEzO4gA:9 a=jEp0ucaQiEUA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=wd9KZIgbKDeiVy_P:21 a=BB7zgHEgxMRP9X95:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042859.834349673@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:27:52 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [045/251] virtio_net: fix race in RX VQ processing
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0045-virtio_net-fix-race-in-RX-VQ-processing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit cbdadbbf0c790f79350a8f36029208944c5487d0 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/virtio_net.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 83d2b0c..fc04222 100644
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
1.7.10.4


