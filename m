Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab3CSJ5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:57:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1842 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753531Ab3CSJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:57:51 -0400
X-IronPort-AV: E=Sophos;i="4.84,871,1355068800"; 
   d="scan'208";a="6901521"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com, JBottomley@parallels.com,
        pbonzini@redhat.com, gaowanlong@cn.fujitsu.com
Subject: [PATCH V5 3/5] virtio-scsi: push vq lock/unlock into virtscsi_vq_done
Date: Tue, 19 Mar 2013 17:57:35 +0800
Message-Id: <1363687057-13580-4-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1363687057-13580-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/19 17:55:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/19 17:55:11,
	Serialize complete at 2013/03/19 17:55:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

Avoid duplicated code in all of the callers.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Asias He <asias@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index bcab9d7..94a64ad 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -167,28 +167,30 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
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
@@ -205,11 +207,8 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
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
@@ -344,11 +343,8 @@ static void virtscsi_event_done(struct virtqueue *vq)
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
1.8.2.rc2

