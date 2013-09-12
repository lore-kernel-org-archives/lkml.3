Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3ILSA4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:00:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab3ILR7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 39/46] vhost_net: poll vhost queue after marking DMA is done
Date: Thu, 12 Sep 2013 10:58:50 -0700
Message-Id: <20130912175725.209002031@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 19c73b3e08d16ee923f3962df4abf6205127896a ]

We used to poll vhost queue before making DMA is done, this is racy if vhost
thread were waked up before marking DMA is done which can result the signal to
be missed. Fix this by always polling the vhost thread before DMA is done.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -307,6 +307,11 @@ static void vhost_zerocopy_callback(stru
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
@@ -317,10 +322,6 @@ static void vhost_zerocopy_callback(stru
 	 */
 	if (cnt <= 2 || !(cnt % 16))
 		vhost_poll_queue(&vq->poll);
-	/* set len to mark this desc buffers done DMA */
-	vq->heads[ubuf->desc].len = success ?
-		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
-	vhost_net_ubuf_put(ubufs);
 }
 
 /* Expects to be always run from workqueue - which acts as


