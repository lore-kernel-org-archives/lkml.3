Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbaGAKrr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:47:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbaGAKro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:47:44 -0400
Date: Tue, 1 Jul 2014 13:49:41 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH RFC 2/2] vhost: support urgent descriptors
Message-ID: <1404203661-7521-2-git-send-email-mst@redhat.com>
References: <1404203661-7521-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404203661-7521-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.h | 19 +++++++++++++------
 drivers/vhost/net.c   | 30 +++++++++++++++++++++---------
 drivers/vhost/scsi.c  | 23 +++++++++++++++--------
 drivers/vhost/test.c  |  5 +++--
 drivers/vhost/vhost.c | 23 ++++++++++++++++-------
 5 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 3eda654..61ca542 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -96,6 +96,9 @@ struct vhost_virtqueue {
 	/* Last used index value we have signalled on */
 	bool signalled_used_valid;
 
+	/* Urgent descriptor was used */
+	bool urgent;
+
 	/* Log writes to used structure. */
 	bool log_used;
 	u64 log_addr;
@@ -138,20 +141,24 @@ long vhost_vring_ioctl(struct vhost_dev *d, int ioctl, void __user *argp);
 int vhost_vq_access_ok(struct vhost_virtqueue *vq);
 int vhost_log_access_ok(struct vhost_dev *);
 
-int vhost_get_vq_desc(struct vhost_virtqueue *,
+int vhost_get_vq_desc(struct vhost_virtqueue *, bool *urgent,
 		      struct iovec iov[], unsigned int iov_count,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
 void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 
 int vhost_init_used(struct vhost_virtqueue *);
-int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-		     unsigned count);
-void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
+int vhost_add_used(struct vhost_virtqueue *, bool urgent,
+		   unsigned int head, int len);
+int vhost_add_used_n(struct vhost_virtqueue *, bool urgent,
+		     struct vring_used_elem *heads, unsigned count);
+void vhost_add_used_and_signal(struct vhost_dev *,
+			       struct vhost_virtqueue *,
+			       bool urgent,
 			       unsigned int id, int len);
 void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *heads, unsigned count);
+				 bool urgent,
+				 struct vring_used_elem *heads, unsigned count);
 void vhost_signal(struct vhost_dev *, struct vhost_virtqueue *);
 void vhost_disable_notify(struct vhost_dev *, struct vhost_virtqueue *);
 bool vhost_enable_notify(struct vhost_dev *, struct vhost_virtqueue *);
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 8dae2f7..5f0567f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -48,9 +48,11 @@ MODULE_PARM_DESC(experimental_zcopytx, "Enable Zero Copy TX;"
  * status internally; used for zerocopy tx only.
  */
 /* Lower device DMA failed */
-#define VHOST_DMA_FAILED_LEN	3
+#define VHOST_DMA_FAILED_LEN	4
 /* Lower device DMA done */
-#define VHOST_DMA_DONE_LEN	2
+#define VHOST_DMA_DONE_LEN	3
+/* Lower device DMA in progress, urgent bit set */
+#define VHOST_DMA_URGENT	2
 /* Lower device DMA in progress */
 #define VHOST_DMA_IN_PROGRESS	1
 /* Buffer unused */
@@ -284,11 +286,13 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 		container_of(vq, struct vhost_net_virtqueue, vq);
 	int i, add;
 	int j = 0;
+	bool urgent = false;
 
 	for (i = nvq->done_idx; i != nvq->upend_idx; i = (i + 1) % UIO_MAXIOV) {
 		if (vq->heads[i].len == VHOST_DMA_FAILED_LEN)
 			vhost_net_tx_err(net);
 		if (VHOST_DMA_IS_DONE(vq->heads[i].len)) {
+			urgent = urgent || vq->heads[i].len == VHOST_DMA_URGENT;
 			vq->heads[i].len = VHOST_DMA_CLEAR_LEN;
 			++j;
 		} else
@@ -296,7 +300,7 @@ static void vhost_zerocopy_signal_used(struct vhost_net *net,
 	}
 	while (j) {
 		add = min(UIO_MAXIOV - nvq->done_idx, j);
-		vhost_add_used_and_signal_n(vq->dev, vq,
+		vhost_add_used_and_signal_n(vq->dev, vq, urgent,
 					    &vq->heads[nvq->done_idx], add);
 		nvq->done_idx = (nvq->done_idx + add) % UIO_MAXIOV;
 		j -= add;
@@ -363,6 +367,7 @@ static void handle_tx(struct vhost_net *net)
 	zcopy = nvq->ubufs;
 
 	for (;;) {
+		bool urgent;
 		/* Release DMAs done buffers first */
 		if (zcopy)
 			vhost_zerocopy_signal_used(net, vq);
@@ -374,7 +379,7 @@ static void handle_tx(struct vhost_net *net)
 			      % UIO_MAXIOV == nvq->done_idx))
 			break;
 
-		head = vhost_get_vq_desc(vq, vq->iov,
+		head = vhost_get_vq_desc(vq, &urgent, vq->iov,
 					 ARRAY_SIZE(vq->iov),
 					 &out, &in,
 					 NULL, NULL);
@@ -417,7 +422,8 @@ static void handle_tx(struct vhost_net *net)
 			ubuf = nvq->ubuf_info + nvq->upend_idx;
 
 			vq->heads[nvq->upend_idx].id = head;
-			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
+			vq->heads[nvq->upend_idx].len = urgent ?
+				VHOST_DMA_IN_PROGRESS : VHOST_DMA_URGENT;
 			ubuf->callback = vhost_zerocopy_callback;
 			ubuf->ctx = nvq->ubufs;
 			ubuf->desc = nvq->upend_idx;
@@ -445,7 +451,7 @@ static void handle_tx(struct vhost_net *net)
 			pr_debug("Truncated TX packet: "
 				 " len %d != %zd\n", err, len);
 		if (!zcopy_used)
-			vhost_add_used_and_signal(&net->dev, vq, head, 0);
+			vhost_add_used_and_signal(&net->dev, vq, urgent, head, 0);
 		else
 			vhost_zerocopy_signal_used(net, vq);
 		total_len += len;
@@ -488,6 +494,7 @@ static int peek_head_len(struct sock *sk)
  *	returns number of buffer heads allocated, negative on error
  */
 static int get_rx_bufs(struct vhost_virtqueue *vq,
+		       bool *urgentp,
 		       struct vring_used_elem *heads,
 		       int datalen,
 		       unsigned *iovcount,
@@ -502,11 +509,13 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 	int r, nlogs = 0;
 
 	while (datalen > 0 && headcount < quota) {
+		bool urgent;
+
 		if (unlikely(seg >= UIO_MAXIOV)) {
 			r = -ENOBUFS;
 			goto err;
 		}
-		r = vhost_get_vq_desc(vq, vq->iov + seg,
+		r = vhost_get_vq_desc(vq, &urgent, vq->iov + seg,
 				      ARRAY_SIZE(vq->iov) - seg, &out,
 				      &in, log, log_num);
 		if (unlikely(r < 0))
@@ -527,6 +536,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 			nlogs += *log_num;
 			log += *log_num;
 		}
+		*urgentp = *urgentp || urgent;
 		heads[headcount].id = d;
 		heads[headcount].len = iov_length(vq->iov + seg, in);
 		datalen -= heads[headcount].len;
@@ -590,9 +600,11 @@ static void handle_rx(struct vhost_net *net)
 	mergeable = vhost_has_feature(vq, VIRTIO_NET_F_MRG_RXBUF);
 
 	while ((sock_len = peek_head_len(sock->sk))) {
+		bool urgent;
+
 		sock_len += sock_hlen;
 		vhost_len = sock_len + vhost_hlen;
-		headcount = get_rx_bufs(vq, vq->heads, vhost_len,
+		headcount = get_rx_bufs(vq, &urgent, vq->heads, vhost_len,
 					&in, vq_log, &log,
 					likely(mergeable) ? UIO_MAXIOV : 1);
 		/* On error, stop handling until the next kick. */
@@ -654,7 +666,7 @@ static void handle_rx(struct vhost_net *net)
 			vhost_discard_vq_desc(vq, headcount);
 			break;
 		}
-		vhost_add_used_and_signal_n(&net->dev, vq, vq->heads,
+		vhost_add_used_and_signal_n(&net->dev, vq, urgent, vq->heads,
 					    headcount);
 		if (unlikely(vq_log))
 			vhost_log_write(vq, vq_log, log, vhost_len);
diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 69906ca..0a7e5bc 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -72,6 +72,8 @@ struct tcm_vhost_cmd {
 	int tvc_vq_desc;
 	/* virtio-scsi initiator task attribute */
 	int tvc_task_attr;
+	/* Descriptor urgent? */
+	bool tvc_vq_desc_urgent;
 	/* virtio-scsi initiator data direction */
 	enum dma_data_direction tvc_data_direction;
 	/* Expected data transfer length from virtio-scsi header */
@@ -606,6 +608,7 @@ tcm_vhost_do_evt_work(struct vhost_scsi *vs, struct tcm_vhost_evt *evt)
 	struct virtio_scsi_event __user *eventp;
 	unsigned out, in;
 	int head, ret;
+	bool urgent;
 
 	if (!vq->private_data) {
 		vs->vs_events_missed = true;
@@ -614,7 +617,7 @@ tcm_vhost_do_evt_work(struct vhost_scsi *vs, struct tcm_vhost_evt *evt)
 
 again:
 	vhost_disable_notify(&vs->dev, vq);
-	head = vhost_get_vq_desc(vq, vq->iov,
+	head = vhost_get_vq_desc(vq, &urgent, vq->iov,
 			ARRAY_SIZE(vq->iov), &out, &in,
 			NULL, NULL);
 	if (head < 0) {
@@ -643,7 +646,7 @@ again:
 	eventp = vq->iov[out].iov_base;
 	ret = __copy_to_user(eventp, event, sizeof(*event));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, urgent, head, 0);
 	else
 		vq_err(vq, "Faulted on tcm_vhost_send_event\n");
 }
@@ -704,7 +707,8 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
 		ret = copy_to_user(cmd->tvc_resp, &v_rsp, sizeof(v_rsp));
 		if (likely(ret == 0)) {
 			struct vhost_scsi_virtqueue *q;
-			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
+			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc_urgent,
+				       cmd->tvc_vq_desc, 0);
 			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
 			vq = q - vs->vqs;
 			__set_bit(vq, signal);
@@ -947,6 +951,7 @@ static void tcm_vhost_submission_work(struct work_struct *work)
 static void
 vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 			   struct vhost_virtqueue *vq,
+			   bool urgent,
 			   int head, unsigned out)
 {
 	struct virtio_scsi_cmd_resp __user *resp;
@@ -958,7 +963,7 @@ vhost_scsi_send_bad_target(struct vhost_scsi *vs,
 	resp = vq->iov[out].iov_base;
 	ret = __copy_to_user(resp, &rsp, sizeof(rsp));
 	if (!ret)
-		vhost_add_used_and_signal(&vs->dev, vq, head, 0);
+		vhost_add_used_and_signal(&vs->dev, vq, urgent, head, 0);
 	else
 		pr_err("Faulted on virtio_scsi_cmd_resp\n");
 }
@@ -980,6 +985,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	u8 *target, *lunp, task_attr;
 	bool hdr_pi;
 	void *req, *cdb;
+	bool urgent;
 
 	mutex_lock(&vq->mutex);
 	/*
@@ -993,7 +999,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 	vhost_disable_notify(&vs->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
+		head = vhost_get_vq_desc(vq, &urgent, vq->iov,
 					ARRAY_SIZE(vq->iov), &out, &in,
 					NULL, NULL);
 		pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
@@ -1067,7 +1073,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 		/* virtio-scsi spec requires byte 0 of the lun to be 1 */
 		if (unlikely(*lunp != 1)) {
-			vhost_scsi_send_bad_target(vs, vq, head, out);
+			vhost_scsi_send_bad_target(vs, vq, urgent, head, out);
 			continue;
 		}
 
@@ -1075,7 +1081,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 
 		/* Target does not exist, fail the request */
 		if (unlikely(!tpg)) {
-			vhost_scsi_send_bad_target(vs, vq, head, out);
+			vhost_scsi_send_bad_target(vs, vq, urgent, head, out);
 			continue;
 		}
 
@@ -1187,6 +1193,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 		 * tcm_vhost_queue_data_in() and tcm_vhost_queue_status()
 		 */
 		cmd->tvc_vq_desc = head;
+		cmd->tvc_vq_desc_urgent = urgent;
 		/*
 		 * Dispatch tv_cmd descriptor for cmwq execution in process
 		 * context provided by tcm_vhost_workqueue.  This also ensures
@@ -1203,7 +1210,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
 err_free:
 	vhost_scsi_free_cmd(cmd);
 err_cmd:
-	vhost_scsi_send_bad_target(vs, vq, head, out);
+	vhost_scsi_send_bad_target(vs, vq, urgent, head, out);
 out:
 	mutex_unlock(&vq->mutex);
 }
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index d9c501e..757f3a2 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -42,6 +42,7 @@ static void handle_vq(struct vhost_test *n)
 	int head;
 	size_t len, total_len = 0;
 	void *private;
+	bool urgent;
 
 	mutex_lock(&vq->mutex);
 	private = vq->private_data;
@@ -53,7 +54,7 @@ static void handle_vq(struct vhost_test *n)
 	vhost_disable_notify(&n->dev, vq);
 
 	for (;;) {
-		head = vhost_get_vq_desc(vq, vq->iov,
+		head = vhost_get_vq_desc(vq, &urgent, vq->iov,
 					 ARRAY_SIZE(vq->iov),
 					 &out, &in,
 					 NULL, NULL);
@@ -79,7 +80,7 @@ static void handle_vq(struct vhost_test *n)
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		vhost_add_used_and_signal(&n->dev, vq, urgent,  head, 0);
 		total_len += len;
 		if (unlikely(total_len >= VHOST_TEST_WEIGHT)) {
 			vhost_poll_queue(&vq->poll);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c90f437..0dcd9d2 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -186,6 +186,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->last_used_idx = 0;
 	vq->signalled_used = 0;
 	vq->signalled_used_valid = false;
+	vq->urgent = false;
 	vq->used_flags = 0;
 	vq->log_used = false;
 	vq->log_addr = -1ull;
@@ -1201,7 +1202,7 @@ static int get_indirect(struct vhost_virtqueue *vq,
  * This function returns the descriptor number found, or vq->num (which is
  * never a valid descriptor number) if none was found.  A negative code is
  * returned on error. */
-int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+int vhost_get_vq_desc(struct vhost_virtqueue *vq, bool *urgent,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num)
@@ -1251,6 +1252,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 
 	/* When we start there are none of either input nor output. */
 	*out_num = *in_num = 0;
+	*urgent = false;
 	if (unlikely(log))
 		*log_num = 0;
 
@@ -1274,6 +1276,8 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 			       i, vq->desc + i);
 			return -EFAULT;
 		}
+		if (desc.flags & VRING_DESC_F_URGENT)
+			*urgent = true;
 		if (desc.flags & VRING_DESC_F_INDIRECT) {
 			ret = get_indirect(vq, iov, iov_size,
 					   out_num, in_num,
@@ -1333,11 +1337,11 @@ EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
-int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
+int vhost_add_used(struct vhost_virtqueue *vq, bool urgent, unsigned int head, int len)
 {
 	struct vring_used_elem heads = { head, len };
 
-	return vhost_add_used_n(vq, &heads, 1);
+	return vhost_add_used_n(vq, urgent, &heads, 1);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used);
 
@@ -1386,7 +1390,8 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 
 /* After we've used one of their buffers, we tell them about it.  We'll then
  * want to notify the guest, using eventfd. */
-int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
+int vhost_add_used_n(struct vhost_virtqueue *vq, bool urgent,
+		     struct vring_used_elem *heads,
 		     unsigned count)
 {
 	int start, n, r;
@@ -1416,6 +1421,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 		if (vq->log_ctx)
 			eventfd_signal(vq->log_ctx, 1);
 	}
+	vq->urgent = vq->urgent || urgent;
 	return r;
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_n);
@@ -1433,12 +1439,13 @@ static bool vhost_notify(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 	    unlikely(vq->avail_idx == vq->last_avail_idx))
 		return true;
 
-	if (!vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
+	if (vq->urgent || !vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX)) {
 		__u16 flags;
 		if (__get_user(flags, &vq->avail->flags)) {
 			vq_err(vq, "Failed to get flags");
 			return true;
 		}
+		vq->urgent = false;
 		return !(flags & VRING_AVAIL_F_NO_INTERRUPT);
 	}
 	old = vq->signalled_used;
@@ -1468,9 +1475,10 @@ EXPORT_SYMBOL_GPL(vhost_signal);
 /* And here's the combo meal deal.  Supersize me! */
 void vhost_add_used_and_signal(struct vhost_dev *dev,
 			       struct vhost_virtqueue *vq,
+			       bool urgent,
 			       unsigned int head, int len)
 {
-	vhost_add_used(vq, head, len);
+	vhost_add_used(vq, urgent, head, len);
 	vhost_signal(dev, vq);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
@@ -1478,9 +1486,10 @@ EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
 /* multi-buffer version of vhost_add_used_and_signal */
 void vhost_add_used_and_signal_n(struct vhost_dev *dev,
 				 struct vhost_virtqueue *vq,
+				 bool urgent,
 				 struct vring_used_elem *heads, unsigned count)
 {
-	vhost_add_used_n(vq, heads, count);
+	vhost_add_used_n(vq, urgent, heads, count);
 	vhost_signal(dev, vq);
 }
 EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
-- 
MST

