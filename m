Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab3CWOAd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:00:33 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34239 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab3CWOAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:00:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,337,1363104000"; 
   d="scan'208";a="6929132"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com, JBottomley@parallels.com,
        venkateshs@google.com, pbonzini@redhat.com, gaowanlong@cn.fujitsu.com
Subject: [PATCH V7 3/5] virtio-scsi: push vq lock/unlock into virtscsi_vq_done
Date: Sat, 23 Mar 2013 19:28:42 +0800
Message-Id: <1364038124-32479-4-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.rc2
In-Reply-To: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
References: <1364038124-32479-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/23 19:26:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/23 19:27:01,
	Serialize complete at 2013/03/23 19:27:01
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
index c23560c..dc2daec 100644
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
1.8.2.rc2

