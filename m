Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3ILRpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 13:45:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56774 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3ILRpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:45:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 17/23] vhost: zerocopy: poll vq in zerocopy callback
Date: Thu, 12 Sep 2013 10:45:13 -0700
Message-Id: <20130912174453.622798288@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912174451.748805761@linuxfoundation.org>
References: <20130912174451.748805761@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit c70aa540c7a9f67add11ad3161096fb95233aa2e upstream.

We add used and signal guest in worker thread but did not poll the virtqueue
during the zero copy callback. This may lead the missing of adding and
signalling during zerocopy. Solve this by polling the virtqueue and let it
wakeup the worker during callback.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vhost.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1603,6 +1603,7 @@ void vhost_zerocopy_callback(struct ubuf
 	struct vhost_ubuf_ref *ubufs = ubuf->ctx;
 	struct vhost_virtqueue *vq = ubufs->vq;
 
+	vhost_poll_queue(&vq->poll);
 	/* set len = 1 to mark this desc buffers done DMA */
 	vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 	kref_put(&ubufs->kref, vhost_zerocopy_done_signal);


