Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbaJLLpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:45:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaJLLpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:45:12 -0400
Date: Sun, 12 Oct 2014 14:48:28 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 23/25] virtio_balloon: enable VQs early on restore
Message-ID: <1413114332-626-24-git-send-email-mst@redhat.com>
References: <1413114332-626-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413114332-626-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio spec requires drivers to set DRIVER_OK before using VQs.
This is set automatically after resume returns, virtio balloon
violated this rule by adding bufs, which causes the VQ to be used
directly within restore.

To fix, call virtio_enable_vqs_early before using VQ.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_balloon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 25ebe8e..9629fad 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -538,6 +538,8 @@ static int virtballoon_restore(struct virtio_device *vdev)
 	if (ret)
 		return ret;
 
+	virtio_enable_vqs_early(vdev);
+
 	fill_balloon(vb, towards_target(vb));
 	update_balloon_size(vb);
 	return 0;
-- 
MST

