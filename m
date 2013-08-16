Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3HPF3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:29:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3HPF2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:28:10 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 5/6] vhost_net: poll vhost queue after marking DMA is done
Date: Fri, 16 Aug 2013 13:16:29 +0800
Message-Id: <1376630190-5912-6-git-send-email-jasowang@redhat.com>
In-Reply-To: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to poll vhost queue before making DMA is done, this is racy if vhost
thread were waked up before marking DMA is done which can result the signal to
be missed. Fix this by always poll the vhost thread before DMA is done.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 70cab75..a035a89 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -308,6 +308,11 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	struct vhost_virtqueue *vq = ubufs->vq;
 	int cnt = atomic_read(&ubufs->kref.refcount);
 
+	/* set len to mark this desc buffers done DMA */
+	vq->heads[ubuf->desc].len = success ?
+		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
+	vhost_net_ubuf_put(ubufs);
+
 	/*
 	 * Trigger polling thread if guest stopped submitting new buffers:
 	 * in this case, the refcount after decrement will eventually reach 1
@@ -318,10 +323,6 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	 */
 	if (cnt <= 2 || !(cnt % 16))
 		vhost_poll_queue(&vq->poll);
-	/* set len to mark this desc buffers done DMA */
-	vq->heads[ubuf->desc].len = success ?
-		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
-	vhost_net_ubuf_put(ubufs);
 }
 
 /* Expects to be always run from workqueue - which acts as
-- 
1.7.1

