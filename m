Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3BTIif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 03:38:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:27405 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab3BTIid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 03:38:33 -0500
X-IronPort-AV: E=Sophos;i="4.84,700,1355068800"; 
   d="scan'208";a="6735346"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: rusty@rustcorp.com.au
Cc: pbonzini@redhat.com, asias@redhat.com, mst@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 17/16] virtio-scsi: use virtqueue_add_sgs for command buffers
Date: Wed, 20 Feb 2013 16:37:29 +0800
Message-Id: <1361349449-9673-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
References: <1361260594-601-1-git-send-email-rusty@rustcorp.com.au>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 16:37:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/20 16:37:50,
	Serialize complete at 2013/02/20 16:37:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new virtqueue_add_sgs function lets us simplify the queueing
path.  In particular, all data protected by the tgt_lock is just gone
(multiqueue will find a new use for the lock).

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c | 93 ++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3449a1f..b002d7b 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -59,11 +59,8 @@ struct virtio_scsi_vq {
 
 /* Per-target queue state */
 struct virtio_scsi_target_state {
-	/* Protects sg.  Lock hierarchy is tgt_lock -> vq_lock.  */
+	/* Never held at the same time as vq_lock.  */
 	spinlock_t tgt_lock;
-
-	/* For sglist construction when adding commands to the virtqueue.  */
-	struct scatterlist sg[];
 };
 
 /* Driver instance state */
@@ -351,75 +348,57 @@ static void virtscsi_event_done(struct virtqueue *vq)
 	spin_unlock_irqrestore(&vscsi->event_vq.vq_lock, flags);
 };
 
-static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
-			     struct scsi_data_buffer *sdb)
-{
-	struct sg_table *table = &sdb->table;
-	struct scatterlist *sg_elem;
-	unsigned int idx = *p_idx;
-	int i;
-
-	for_each_sg(table->sgl, sg_elem, table->nents, i)
-		sg[idx++] = *sg_elem;
-
-	*p_idx = idx;
-}
-
 /**
- * virtscsi_map_cmd - map a scsi_cmd to a virtqueue scatterlist
- * @vscsi	: virtio_scsi state
+ * virtscsi_add_cmd - add a virtio_scsi_cmd to a virtqueue
+ * @vq		: the struct virtqueue we're talking about
  * @cmd		: command structure
- * @out_num	: number of read-only elements
- * @in_num	: number of write-only elements
  * @req_size	: size of the request buffer
  * @resp_size	: size of the response buffer
- *
- * Called with tgt_lock held.
+ * @gfp	: flags to use for memory allocations
  */
-static void virtscsi_map_cmd(struct virtio_scsi_target_state *tgt,
-			     struct virtio_scsi_cmd *cmd,
-			     unsigned *out_num, unsigned *in_num,
-			     size_t req_size, size_t resp_size)
+static int virtscsi_add_cmd(struct virtqueue *vq,
+			    struct virtio_scsi_cmd *cmd,
+			    size_t req_size, size_t resp_size, gfp_t gfp)
 {
 	struct scsi_cmnd *sc = cmd->sc;
-	struct scatterlist *sg = tgt->sg;
-	unsigned int idx = 0;
+	struct scatterlist *sgs[4], req, resp;
+	struct sg_table *out, *in;
+	unsigned out_num = 0, in_num = 0;
+
+	out = in = NULL;
 
-	/* Request header.  */
-	sg_set_buf(&sg[idx++], &cmd->req, req_size);
+	if (sc && sc->sc_data_direction != DMA_NONE) {
+		if (sc->sc_data_direction != DMA_FROM_DEVICE)
+			out = &scsi_out(sc)->table;
+		if (sc->sc_data_direction != DMA_TO_DEVICE)
+			in = &scsi_in(sc)->table;
+	}
 
-	/* Data-out buffer.  */
-	if (sc && sc->sc_data_direction != DMA_FROM_DEVICE)
-		virtscsi_map_sgl(sg, &idx, scsi_out(sc));
+	sg_init_one(&req, &cmd->req, req_size);
+	sgs[out_num++] = &req;
 
-	*out_num = idx;
+	if (out)
+		sgs[out_num++] = out->sgl;
 
-	/* Response header.  */
-	sg_set_buf(&sg[idx++], &cmd->resp, resp_size);
+	sg_init_one(&resp, &cmd->resp, resp_size);
+	sgs[out_num + in_num++] = &resp;
 
-	/* Data-in buffer */
-	if (sc && sc->sc_data_direction != DMA_TO_DEVICE)
-		virtscsi_map_sgl(sg, &idx, scsi_in(sc));
+	if (in)
+		sgs[out_num + in_num++] = in->sgl;
 
-	*in_num = idx - *out_num;
+	return virtqueue_add_sgs(vq, sgs, out_num, in_num, cmd, gfp);
 }
 
-static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
-			     struct virtio_scsi_vq *vq,
+static int virtscsi_kick_cmd(struct virtio_scsi_vq *vq,
 			     struct virtio_scsi_cmd *cmd,
 			     size_t req_size, size_t resp_size, gfp_t gfp)
 {
-	unsigned int out_num, in_num;
 	unsigned long flags;
 	int err;
 	bool needs_kick = false;
 
-	spin_lock_irqsave(&tgt->tgt_lock, flags);
-	virtscsi_map_cmd(tgt, cmd, &out_num, &in_num, req_size, resp_size);
-
-	spin_lock(&vq->vq_lock);
-	err = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
-	spin_unlock(&tgt->tgt_lock);
+	spin_lock_irqsave(&vq->vq_lock, flags);
+	err = virtscsi_add_cmd(vq->vq, cmd, req_size, resp_size, gfp);
 	if (!err)
 		needs_kick = virtqueue_kick_prepare(vq->vq);
 
@@ -433,7 +412,6 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
 static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 {
 	struct virtio_scsi *vscsi = shost_priv(sh);
-	struct virtio_scsi_target_state *tgt = vscsi->tgt[sc->device->id];
 	struct virtio_scsi_cmd *cmd;
 	int ret;
 
@@ -467,7 +445,7 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
 	BUG_ON(sc->cmd_len > VIRTIO_SCSI_CDB_SIZE);
 	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 
-	if (virtscsi_kick_cmd(tgt, &vscsi->req_vq, cmd,
+	if (virtscsi_kick_cmd(&vscsi->req_vq, cmd,
 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
 			      GFP_ATOMIC) == 0)
 		ret = 0;
@@ -481,11 +459,10 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
 	DECLARE_COMPLETION_ONSTACK(comp);
-	struct virtio_scsi_target_state *tgt = vscsi->tgt[cmd->sc->device->id];
 	int ret = FAILED;
 
 	cmd->comp = &comp;
-	if (virtscsi_kick_cmd(tgt, &vscsi->ctrl_vq, cmd,
+	if (virtscsi_kick_cmd(&vscsi->ctrl_vq, cmd,
 			      sizeof cmd->req.tmf, sizeof cmd->resp.tmf,
 			      GFP_NOIO) < 0)
 		goto out;
@@ -591,15 +568,11 @@ static struct virtio_scsi_target_state *virtscsi_alloc_tgt(
 	struct virtio_scsi_target_state *tgt;
 	gfp_t gfp_mask = GFP_KERNEL;
 
-	/* We need extra sg elements at head and tail.  */
-	tgt = kmalloc(sizeof(*tgt) + sizeof(tgt->sg[0]) * (sg_elems + 2),
-		      gfp_mask);
-
+	tgt = kmalloc(sizeof(*tgt), gfp_mask);
 	if (!tgt)
 		return NULL;
 
 	spin_lock_init(&tgt->tgt_lock);
-	sg_init_table(tgt->sg, sg_elems + 2);
 	return tgt;
 }
 
-- 
1.8.1

