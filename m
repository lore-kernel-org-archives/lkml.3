Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab3HPF2u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:28:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab3HPF2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:28:01 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 2/6] vhost_net: use vhost_add_used_and_signal_n() in vhost_zerocopy_signal_used()
Date: Fri, 16 Aug 2013 13:16:26 +0800
Message-Id: <1376630190-5912-3-git-send-email-jasowang@redhat.com>
In-Reply-To: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to use vhost_add_used_and_signal_n() to avoid multiple calls to
vhost_add_used_and_signal(). With the patch we will call at most 2 times
(consider done_idx warp around) compared to N times w/o this patch.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 280ee66..8a6dd0d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -281,7 +281,7 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 {
 	struct vhost_net_virtqueue *nvq =
 		container_of(vq, struct vhost_net_virtqueue, vq);
-	int i;
+	int i, add;
 	int j = 0;
 
 	for (i = nvq->done_idx; i != nvq->upend_idx; i = (i + 1) % UIO_MAXIOV) {
@@ -289,14 +289,17 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 			vhost_net_tx_err(net);
 		if (VHOST_DMA_IS_DONE(vq->heads[i].len)) {
 			vq->heads[i].len = VHOST_DMA_CLEAR_LEN;
-			vhost_add_used_and_signal(vq->dev, vq,
-						  vq->heads[i].id, 0);
 			++j;
 		} else
 			break;
 	}
-	if (j)
-		nvq->done_idx = i;
+	while (j) {
+		add = min(UIO_MAXIOV - nvq->done_idx, j);
+		vhost_add_used_and_signal_n(vq->dev, vq,
+					    &vq->heads[nvq->done_idx], add);
+		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
+		j -= add;
+	}
 }
 
 static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
-- 
1.7.1

