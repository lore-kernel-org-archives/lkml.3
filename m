Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab3AOKid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 05:38:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3AOKhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 05:37:13 -0500
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH V4 1/3] vhost_net: correct error handling in vhost_net_set_backend()
Date: Tue, 15 Jan 2013 18:28:44 +0800
Message-Id: <1358245726-16250-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1358245726-16250-1-git-send-email-jasowang@redhat.com>
References: <1358245726-16250-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when vhost_init_used() fails the sock refcnt and ubufs were
leaked. Correct this by calling vhost_init_used() before assign ubufs and
restore the oldsock when it fails.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index ebd08b2..d10ad6f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -827,15 +827,16 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 			r = PTR_ERR(ubufs);
 			goto err_ubufs;
 		}
-		oldubufs = vq->ubufs;
-		vq->ubufs = ubufs;
+
 		vhost_net_disable_vq(n, vq);
 		rcu_assign_pointer(vq->private_data, sock);
-		vhost_net_enable_vq(n, vq);
-
 		r = vhost_init_used(vq);
 		if (r)
-			goto err_vq;
+			goto err_used;
+		vhost_net_enable_vq(n, vq);
+
+		oldubufs = vq->ubufs;
+		vq->ubufs = ubufs;
 
 		n->tx_packets = 0;
 		n->tx_zcopy_err = 0;
@@ -859,6 +860,11 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 	mutex_unlock(&n->dev.mutex);
 	return 0;
 
+err_used:
+	rcu_assign_pointer(vq->private_data, oldsock);
+	vhost_net_enable_vq(n, vq);
+	if (ubufs)
+		vhost_ubuf_put_and_wait(ubufs);
 err_ubufs:
 	fput(sock->file);
 err_vq:
-- 
1.7.1

