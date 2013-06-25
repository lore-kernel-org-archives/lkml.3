Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab3FYO3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:29:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3FYO3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:29:03 -0400
Date: Tue, 25 Jun 2013 17:29:46 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Asias He <asias@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCHv2] vhost-net: fix use-after-free in vhost_net_flush
Message-ID: <20130625142946.GA17414@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---

Please review, and queue for 3.10 and stable.
Changes since v1:
	- no functional change, tweaked the commit message

 drivers/vhost/net.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 5c77d6a..534adb0 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -149,6 +149,11 @@ static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
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
 
@@ -1073,7 +1078,7 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	mutex_unlock(&vq->mutex);
 
 	if (oldubufs) {
-		vhost_net_ubuf_put_and_wait(oldubufs);
+		vhost_net_ubuf_put_wait_and_free(oldubufs);
 		mutex_lock(&vq->mutex);
 		vhost_zerocopy_signal_used(n, vq);
 		mutex_unlock(&vq->mutex);
@@ -1091,7 +1096,7 @@ err_used:
 	vq->private_data = oldsock;
 	vhost_net_enable_vq(n, vq);
 	if (ubufs)
-		vhost_net_ubuf_put_and_wait(ubufs);
+		vhost_net_ubuf_put_wait_and_free(ubufs);
 err_ubufs:
 	fput(sock->file);
 err_vq:
-- 
MST
