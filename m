Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaJFPIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 11:08:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbaJFPIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 11:08:13 -0400
Date: Mon, 6 Oct 2014 18:11:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>, netdev@vger.kernel.org
Subject: [PATCH v2 15/15] virtio_net: fix use after free on allocation failure
Message-ID: <1412608214-31944-16-git-send-email-mst@redhat.com>
References: <1412608214-31944-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412608214-31944-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the extremely unlikely event that driver initialization fails after
RX buffers are added, virtio net frees RX buffers while VQs are
still active, potentially causing device to use a freed buffer.

To fix, reset device first - same as we do on device removal.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 drivers/net/virtio_net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 430f3ae..3551417 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1830,6 +1830,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 	return 0;
 
 free_recv_bufs:
+	vi->vdev->config->reset(vdev);
+
 	free_receive_bufs(vi);
 	unregister_netdev(dev);
 free_vqs:
-- 
MST

