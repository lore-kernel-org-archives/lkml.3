Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281Ab3BLNHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 08:07:39 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:60317 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933238Ab3BLNHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 08:07:01 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>, asias@redhat.com, mst@redhat.com,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH v3 3/5] virtio-scsi: push vq lock/unlock into virtscsi_vq_done
Date: Tue, 12 Feb 2013 14:06:29 +0100
Message-Id: <1360674391-2661-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
References: <1360674391-2661-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid duplicated code in all of the callers.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/virtio_scsi.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3dd4ec5..3d77210 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -165,28 +165,30 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 	sc->scsi_done(sc);
 }
 
-static void virtscsi_vq_done(struct virtio_scsi *vscsi, struct virtqueue *vq,
+static void virtscsi_vq_done(struct virtio_scsi *vscsi,
+			     struct virtio_scsi_vq *virtscsi_vq,
 			     void (*fn)(struct virtio_scsi *vscsi, void *buf))
 {
 	void *buf;
 	unsigned int len;
+	unsigned long flags;
+	struct virtqueue *vq = virtscsi_vq->vq;
 
+	spin_lock_irqsave(&virtscsi_vq->vq_lock, flags);
 	do {
 		virtqueue_disable_cb(vq);
 		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
 			fn(vscsi, buf);
 	} while (!virtqueue_enable_cb(vq));
+	spin_unlock_irqrestore(&virtscsi_vq->vq_lock, flags);
 }
 
 static void virtscsi_req_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
-	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
-	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
+	virtscsi_vq_done(vscsi, &vscsi->req_vq, virtscsi_complete_cmd);
 };
 
 static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
@@ -203,11 +205,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->ctrl_vq.vq_lock, flags);
-	virtscsi_vq_done(vscsi, vq, virtscsi_complete_free);
-	spin_unlock_irqrestore(&vscsi->ctrl_vq.vq_lock, flags);
+	virtscsi_vq_done(vscsi, &vscsi->ctrl_vq, virtscsi_complete_free);
 };
 
 static int virtscsi_kick_event(struct virtio_scsi *vscsi,
@@ -342,11 +341,8 @@ static void virtscsi_event_done(struct virtqueue *vq)
 {
 	struct Scsi_Host *sh = virtio_scsi_host(vq->vdev);
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
-	virtscsi_vq_done(vscsi, vq, virtscsi_complete_event);
-	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
+	virtscsi_vq_done(vscsi, &vscsi->event_vq, virtscsi_complete_event);
 };
 
 /**
-- 
1.7.1


