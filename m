Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab3IBIxC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:53:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758143Ab3IBIw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:52:57 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V3 6/6] vhost_net: correctly limit the max pending buffers
Date: Mon,  2 Sep 2013 16:41:01 +0800
Message-Id: <1378111261-14826-7-git-send-email-jasowang@redhat.com>
In-Reply-To: <1378111261-14826-1-git-send-email-jasowang@redhat.com>
References: <1378111261-14826-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Michael point out, We used to limit the max pending DMAs to get better cache
utilization. But it was not done correctly since it was one done when there's no
new buffers submitted from guest. Guest can easily exceeds the limitation by
keeping sending packets.

So this patch moves the check into main loop. Tests shows about 5%-10%
improvement on per cpu throughput for guest tx.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 8e9dc55..831eb4f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -363,6 +363,13 @@ static void handle_tx(struct vhost_net *net)
 		if (zcopy)
 			vhost_zerocopy_signal_used(net, vq);
 
+		/* If more outstanding DMAs, queue the work.
+		 * Handle upend_idx wrap around
+		 */
+		if (unlikely((nvq->upend_idx + vq->num - VHOST_MAX_PEND)
+			      % UIO_MAXIOV == nvq->done_idx))
+			break;
+
 		head = vhost_get_vq_desc(&net->dev, vq, vq->iov,
 					 ARRAY_SIZE(vq->iov),
 					 &out, &in,
@@ -372,17 +379,6 @@ static void handle_tx(struct vhost_net *net)
 			break;
 		/* Nothing new?  Wait for eventfd to tell us they refilled. */
 		if (head == vq->num) {
-			int num_pends;
-
-			/* If more outstanding DMAs, queue the work.
-			 * Handle upend_idx wrap around
-			 */
-			num_pends = likely(nvq->upend_idx >= nvq->done_idx) ?
-				    (nvq->upend_idx - nvq->done_idx) :
-				    (nvq->upend_idx + UIO_MAXIOV -
-				     nvq->done_idx);
-			if (unlikely(num_pends > VHOST_MAX_PEND))
-				break;
 			if (unlikely(vhost_enable_notify(&net->dev, vq))) {
 				vhost_disable_notify(&net->dev, vq);
 				continue;
-- 
1.7.1

