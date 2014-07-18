Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329AbaGRNSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:24 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17953 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422673AbaGRNSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:16 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 061/170] virtio-scsi: avoid cancelling uninitialized work items
Date: Fri, 18 Jul 2014 14:11:06 +0200
Message-Id: <424d0d5db0ee42556f21251760b4acde41caf553.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cdda0e5acbb78f7b777049f8c27899e5c5bb368f upstream.

Calling the workqueue interface on uninitialized work items isn't a
good idea even if they're zeroed. It's not failing catastrophically only
through happy accidents.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/virtio_scsi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 95a5d73e675c..57c39e1e6681 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -288,6 +288,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
 
+static void virtscsi_handle_event(struct work_struct *work);
+
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 			       struct virtio_scsi_event_node *event_node)
 {
@@ -295,6 +297,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 	struct scatterlist sg;
 	unsigned long flags;
 
+	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
@@ -412,7 +415,6 @@ static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
-	INIT_WORK(&event_node->work, virtscsi_handle_event);
 	schedule_work(&event_node->work);
 }
 
-- 
2.0.0

