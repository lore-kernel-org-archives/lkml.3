Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933881Ab3GZVks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:40:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50788 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3GZUs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Asias He <asias@redhat.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 20/79] vhost-net: fix use-after-free in vhost_net_flush
Date: Fri, 26 Jul 2013 13:47:10 -0700
Message-Id: <20130726204724.050905059@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit c38e39c378f46f00ce922dd40a91043a9925c28d ]

vhost_net_ubuf_put_and_wait has a confusing name:
it will actually also free it's argument.
Thus since commit 1280c27f8e29acf4af2da914e80ec27c3dbd5c01
    "vhost-net: flush outstanding DMAs on memory change"
vhost_net_flush tries to use the argument after passing it
to vhost_net_ubuf_put_and_wait, this results
in use after free.
To fix, don't free the argument in vhost_net_ubuf_put_and_wait,
add an new API for callers that want to free ubufs.

Acked-by: Asias He <asias@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -150,6 +150,11 @@ static void vhost_net_ubuf_put_and_wait(
 {
 	kref_put(&ubufs->kref, vhost_net_zerocopy_done_signal);
 	wait_event(ubufs->wait, !atomic_read(&ubufs->kref.refcount));
+}
+
+static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
+{
+	vhost_net_ubuf_put_and_wait(ubufs);
 	kfree(ubufs);
 }
 
@@ -948,7 +953,7 @@ static long vhost_net_set_backend(struct
 	mutex_unlock(&vq->mutex);
 
 	if (oldubufs) {
-		vhost_net_ubuf_put_and_wait(oldubufs);
+		vhost_net_ubuf_put_wait_and_free(oldubufs);
 		mutex_lock(&vq->mutex);
 		vhost_zerocopy_signal_used(n, vq);
 		mutex_unlock(&vq->mutex);
@@ -966,7 +971,7 @@ err_used:
 	rcu_assign_pointer(vq->private_data, oldsock);
 	vhost_net_enable_vq(n, vq);
 	if (ubufs)
-		vhost_net_ubuf_put_and_wait(ubufs);
+		vhost_net_ubuf_put_wait_and_free(ubufs);
 err_ubufs:
 	fput(sock->file);
 err_vq:


