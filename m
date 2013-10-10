Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3JJPsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:48:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52877 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab3JJPss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:48:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jason Wang <jasowang@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 026/104] vhost_net: poll vhost queue after marking DMA is done
Date: Thu, 10 Oct 2013 08:41:14 -0700
Message-Id: <1381419752-29733-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 19c73b3e08d16ee923f3962df4abf6205127896a ]

We used to poll vhost queue before making DMA is done, this is racy if vhost
thread were waked up before marking DMA is done which can result the signal to
be missed. Fix this by always polling the vhost thread before DMA is done.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/vhost/net.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index dfff647..b8dfb94 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -210,6 +210,11 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	struct vhost_virtqueue *vq = ubufs->vq;
 	int cnt = atomic_read(&ubufs->kref.refcount);
 
+	/* set len to mark this desc buffers done DMA */
+	vq->heads[ubuf->desc].len = success ?
+		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
+	vhost_ubuf_put(ubufs);
+
 	/*
 	 * Trigger polling thread if guest stopped submitting new buffers:
 	 * in this case, the refcount after decrement will eventually reach 1
@@ -220,10 +225,6 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
 	 */
 	if (cnt <= 2 || !(cnt % 16))
 		vhost_poll_queue(&vq->poll);
-	/* set len to mark this desc buffers done DMA */
-	vq->heads[ubuf->desc].len = success ?
-		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
-	vhost_ubuf_put(ubufs);
 }
 
 /* Expects to be always run from workqueue - which acts as
-- 
1.8.1.2

