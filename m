Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3CWOAq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 10:00:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59055 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab3CWOAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 10:00:15 -0400
X-IronPort-AV: E=Sophos;i="4.87,337,1363104000"; 
   d="scan'208";a="6929133"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
        mst@redhat.com, asias@redhat.com, JBottomley@parallels.com,
        venkateshs@google.com, pbonzini@redhat.com, gaowanlong@cn.fujitsu.com
Subject: [PATCH V7 2/5] virtio-scsi: pass struct virtio_scsi to virtqueue completion function
Date: Sat, 23 Mar 2013 19:28:41 +0800
Message-Id: <1364038124-32479-3-git-send-email-gaowanlong@cn.fujitsu.com>
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

This will be needed soon in order to retrieve the per-target
struct.

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reviewed-by: Asias He <asias@redhat.com>
---
 drivers/scsi/virtio_scsi.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index ffa03e8..c23560c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -104,7 +104,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
  *
  * Called with vq_lock held.
  */
-static void virtscsi_complete_cmd(void *buf)
+static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 	struct scsi_cmnd *sc = cmd->sc;
@@ -165,7 +165,8 @@ static void virtscsi_complete_cmd(void *buf)
 	sc->scsi_done(sc);
 }
 
-static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
+static void virtscsi_vq_done(struct virtio_scsi *vscsi, struct virtqueue *vq,
+			     void (*fn)(struct virtio_scsi *vscsi, void *buf))
 {
 	void *buf;
 	unsigned int len;
@@ -173,7 +174,7 @@ static void virtscsi_vq_done(struct virtqueue *vq, void (*fn)(void *buf))
 	do {
 		virtqueue_disable_cb(vq);
 		while ((buf = virtqueue_get_buf(vq, &len)) != NULL)
-			fn(buf);
+			fn(vscsi, buf);
 	} while (!virtqueue_enable_cb(vq));
 }
 
@@ -184,11 +185,11 @@ static void virtscsi_req_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->req_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_cmd);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_cmd);
 	spin_unlock_irqrestore(&vscsi->req_vq.vq_lock, flags);
 };
 
-static void virtscsi_complete_free(void *buf)
+static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_cmd *cmd = buf;
 
@@ -205,7 +206,7 @@ static void virtscsi_ctrl_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->ctrl_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_free);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_free);
 	spin_unlock_irqrestore(&vscsi->ctrl_vq.vq_lock, flags);
 };
 
@@ -329,7 +330,7 @@ static void virtscsi_handle_event(struct work_struct *work)
 	virtscsi_kick_event(vscsi, event_node);
 }
 
-static void virtscsi_complete_event(void *buf)
+static void virtscsi_complete_event(struct virtio_scsi *vscsi, void *buf)
 {
 	struct virtio_scsi_event_node *event_node = buf;
 
@@ -344,7 +345,7 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
-	virtscsi_vq_done(vq, virtscsi_complete_event);
+	virtscsi_vq_done(vscsi, vq, virtscsi_complete_event);
 	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
 };
 
-- 
1.8.2.rc2

