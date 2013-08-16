Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3HPF3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:29:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3HPF2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:28:12 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 6/6] vhost_net: remove the max pending check
Date: Fri, 16 Aug 2013 13:16:30 +0800
Message-Id: <1376630190-5912-7-git-send-email-jasowang@redhat.com>
In-Reply-To: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to limit the max pending DMAs to prevent guest from pinning too many
pages. But this could be removed since:

- We have the sk_wmem_alloc check in both tun/macvtap to do the same work
- This max pending check were almost useless since it was one done when there's
  no new buffers coming from guest. Guest can easily exceeds the limitation.
- We've already check upend_idx != done_idx and switch to non zerocopy then. So
  even if all vq->heads were used, we can still does the packet transmission.

So remove this check completely.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index a035a89..ed3f165 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -38,8 +38,6 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
  * Using this limit prevents one virtqueue from starving others. */
 #define VHOST_NET_WEIGHT 0x80000
 
-/* MAX number of TX used buffers for outstanding zerocopy */
-#define VHOST_MAX_PEND 128
 #define VHOST_GOODCOPY_LEN 256
 
 /*
@@ -372,17 +370,6 @@ static void handle_tx(struct vhost_net *net)
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

