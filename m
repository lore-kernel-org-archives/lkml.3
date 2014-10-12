Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaJLLpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:45:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaJLLpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:45:04 -0400
Date: Sun, 12 Oct 2014 14:48:17 +0300
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
        Paolo Bonzini <pbonzini@redhat.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: [PATCH v3 21/25] virito_scsi: use freezable WQ for events
Message-ID: <1413114332-626-22-git-send-email-mst@redhat.com>
References: <1413114332-626-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413114332-626-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Michael S. Tsirkin noticed a race condition:
we reset device on freeze, but system WQ is still
running so it might try adding bufs to a VQ meanwhile.

To fix, switch to handling events from the freezable WQ.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 2b565b3..501838d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -390,7 +390,7 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
-	schedule_work(&event_node->work);
+	queue_work(system_freezable_wq, &event_node->work);
 }
 
 static void virtscsi_event_done(struct virtqueue *vq)
-- 
MST

