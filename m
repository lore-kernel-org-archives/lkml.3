Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbaLJTt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:33536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988AbaLJTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770560"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 10/13] misc: mic: SCIF messaging and node enumeration APIs
Date: Wed, 10 Dec 2014 11:47:50 -0800
Message-Id: <553e33b4e5ebfb67a194ce65e16312aed63b1412.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCIF messaging APIs which allow sending messages between the SCIF
endpoints via a byte stream based ring buffer which has been
optimized to avoid reads across PCIe. The SCIF messaging APIs
are typically used for short < 1024 byte messages for best
performance while the RDMA APIs which will be submitted in a future
patch series is recommended for larger transfers. The node
enumeration API enables a user to query for the number of nodes
online in the SCIF network and their node ids.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/scif/scif_epd.h    |   4 +
 drivers/misc/mic/scif/scif_api.c    | 398 ++++++++++++++++++++++++++++++++++++
 drivers/misc/mic/scif/scif_epd.c    |  32 +++
 drivers/misc/mic/scif/scif_fd.c     |  93 +++++++++
 drivers/misc/mic/scif/scif_nm.c     |  17 ++
 drivers/misc/mic/scif/scif_nodeqp.c |  36 +++-
 6 files changed, 579 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mic/scif/scif_epd.h b/drivers/misc/mic/scif/scif_epd.h
index 65c628e..331322a 100644
--- a/drivers/misc/mic/scif/scif_epd.h
+++ b/drivers/misc/mic/scif/scif_epd.h
@@ -144,6 +144,8 @@ int scif_rsrv_port(u16 port);
 void scif_get_port(u16 port);
 int scif_get_new_port(void);
 void scif_put_port(u16 port);
+int scif_user_send(scif_epd_t epd, void __user *msg, int len, int flags);
+int scif_user_recv(scif_epd_t epd, void __user *msg, int len, int flags);
 void scif_cnctreq(struct scif_dev *scifdev, struct scifmsg *msg);
 void scif_cnctgnt(struct scif_dev *scifdev, struct scifmsg *msg);
 void scif_cnctgnt_ack(struct scif_dev *scifdev, struct scifmsg *msg);
@@ -151,6 +153,8 @@ void scif_cnctgnt_nack(struct scif_dev *scifdev, struct scifmsg *msg);
 void scif_cnctrej(struct scif_dev *scifdev, struct scifmsg *msg);
 void scif_discnct(struct scif_dev *scifdev, struct scifmsg *msg);
 void scif_discnt_ack(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_clientsend(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_clientrcvd(struct scif_dev *scifdev, struct scifmsg *msg);
 int __scif_connect(scif_epd_t epd, struct scif_port_id *dst, bool non_block);
 int __scif_flush(scif_epd_t epd);
 #endif /* SCIF_EPD_H */
diff --git a/drivers/misc/mic/scif/scif_api.c b/drivers/misc/mic/scif/scif_api.c
index 28494a3..2fb219b 100644
--- a/drivers/misc/mic/scif/scif_api.c
+++ b/drivers/misc/mic/scif/scif_api.c
@@ -870,3 +870,401 @@ scif_accept_error_epalloc:
 	return err;
 }
 EXPORT_SYMBOL_GPL(scif_accept);
+
+/*
+ * scif_msg_param_check:
+ * @epd: The end point returned from scif_open()
+ * @len: Length to receive
+ * @flags: blocking or non blocking
+ *
+ * Validate parameters for messaging APIs scif_send(..)/scif_recv(..).
+ */
+static inline int scif_msg_param_check(scif_epd_t epd, int len, int flags)
+{
+	int ret = -EINVAL;
+
+	if (len < 0)
+		goto err_ret;
+	if (flags && (!(flags & SCIF_RECV_BLOCK)))
+		goto err_ret;
+	ret = 0;
+err_ret:
+	return ret;
+}
+
+static int _scif_send(scif_epd_t epd, void *msg, int len, int flags)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	struct scifmsg notif_msg;
+	int curr_xfer_len = 0, sent_len = 0, write_count;
+	int ret = 0;
+	struct scif_qp *qp = ep->qp_info.qp;
+
+	if (flags & SCIF_SEND_BLOCK)
+		might_sleep();
+
+	spin_lock(&ep->lock);
+	while (sent_len != len && SCIFEP_CONNECTED == ep->state) {
+		write_count = scif_rb_space(&qp->outbound_q);
+		if (write_count) {
+			/* Best effort to send as much data as possible */
+			curr_xfer_len = min(len - sent_len, write_count);
+			ret = scif_rb_write(&qp->outbound_q, msg,
+					    curr_xfer_len);
+			if (ret < 0)
+				break;
+			/* Success. Update write pointer */
+			scif_rb_commit(&qp->outbound_q);
+			/*
+			 * Send a notification to the peer about the
+			 * produced data message.
+			 */
+			notif_msg.src = ep->port;
+			notif_msg.uop = SCIF_CLIENT_SENT;
+			notif_msg.payload[0] = ep->remote_ep;
+			ret = _scif_nodeqp_send(ep->remote_dev, &notif_msg);
+			if (ret)
+				break;
+			sent_len += curr_xfer_len;
+			msg = msg + curr_xfer_len;
+			continue;
+		}
+		curr_xfer_len = min(len - sent_len, SCIF_ENDPT_QP_SIZE - 1);
+		/* Not enough RB space. return for the Non Blocking case */
+		if (!(flags & SCIF_SEND_BLOCK))
+			break;
+
+		spin_unlock(&ep->lock);
+		/* Wait for a SCIF_CLIENT_RCVD message in the Blocking case */
+		ret =
+		wait_event_interruptible(ep->sendwq,
+					 (SCIFEP_CONNECTED != ep->state) ||
+					 (scif_rb_space(&qp->outbound_q) >=
+					 curr_xfer_len));
+		spin_lock(&ep->lock);
+		if (ret)
+			break;
+	}
+	if (sent_len)
+		ret = sent_len;
+	else if (!ret && SCIFEP_CONNECTED != ep->state)
+		ret = SCIFEP_DISCONNECTED == ep->state ?
+			-ECONNRESET : -ENOTCONN;
+	spin_unlock(&ep->lock);
+	return ret;
+}
+
+static int _scif_recv(scif_epd_t epd, void *msg, int len, int flags)
+{
+	int read_size;
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	struct scifmsg notif_msg;
+	int curr_recv_len = 0, remaining_len = len, read_count;
+	int ret = 0;
+	struct scif_qp *qp = ep->qp_info.qp;
+
+	if (flags & SCIF_RECV_BLOCK)
+		might_sleep();
+	spin_lock(&ep->lock);
+	while (remaining_len && (SCIFEP_CONNECTED == ep->state ||
+				 SCIFEP_DISCONNECTED == ep->state)) {
+		read_count = scif_rb_count(&qp->inbound_q, remaining_len);
+		if (read_count) {
+			/*
+			 * Best effort to recv as much data as there
+			 * are bytes to read in the RB particularly
+			 * important for the Non Blocking case.
+			 */
+			curr_recv_len = min(remaining_len, read_count);
+			read_size = scif_rb_get_next(&qp->inbound_q,
+						     msg, curr_recv_len);
+			if (ep->state == SCIFEP_CONNECTED) {
+				/*
+				 * Update the read pointer only if the endpoint
+				 * is still connected else the read pointer
+				 * might no longer exist since the peer has
+				 * freed resources!
+				 */
+				scif_rb_update_read_ptr(&qp->inbound_q);
+				/*
+				 * Send a notification to the peer about the
+				 * consumed data message only if the EP is in
+				 * SCIFEP_CONNECTED state.
+				 */
+				notif_msg.src = ep->port;
+				notif_msg.uop = SCIF_CLIENT_RCVD;
+				notif_msg.payload[0] = ep->remote_ep;
+				ret = _scif_nodeqp_send(ep->remote_dev,
+							&notif_msg);
+				if (ret)
+					break;
+			}
+			remaining_len -= curr_recv_len;
+			msg = msg + curr_recv_len;
+			continue;
+		}
+		/*
+		 * Bail out now if the EP is in SCIFEP_DISCONNECTED state else
+		 * we will keep looping forever.
+		 */
+		if (ep->state == SCIFEP_DISCONNECTED)
+			break;
+		/*
+		 * Return in the Non Blocking case if there is no data
+		 * to read in this iteration.
+		 */
+		if (!(flags & SCIF_RECV_BLOCK))
+			break;
+		curr_recv_len = min(remaining_len, SCIF_ENDPT_QP_SIZE - 1);
+		spin_unlock(&ep->lock);
+		/*
+		 * Wait for a SCIF_CLIENT_SEND message in the blocking case
+		 * or until other side disconnects.
+		 */
+		ret =
+		wait_event_interruptible(ep->recvwq,
+					 SCIFEP_CONNECTED != ep->state ||
+					 scif_rb_count(&qp->inbound_q,
+						       curr_recv_len)
+					 >= curr_recv_len);
+		spin_lock(&ep->lock);
+		if (ret)
+			break;
+	}
+	if (len - remaining_len)
+		ret = len - remaining_len;
+	else if (!ret && ep->state != SCIFEP_CONNECTED)
+		ret = ep->state == SCIFEP_DISCONNECTED ?
+			-ECONNRESET : -ENOTCONN;
+	spin_unlock(&ep->lock);
+	return ret;
+}
+
+/**
+ * scif_user_send() - Send data to connection queue
+ * @epd: The end point returned from scif_open()
+ * @msg: Address to place data
+ * @len: Length to receive
+ * @flags: blocking or non blocking
+ *
+ * This function is called from the driver IOCTL entry point
+ * only and is a wrapper for _scif_send().
+ */
+int scif_user_send(scif_epd_t epd, void __user *msg, int len, int flags)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	int err = 0;
+	int sent_len = 0;
+	char *tmp;
+	int loop_len;
+	int chunk_len = min(len, (1 << (MAX_ORDER + PAGE_SHIFT - 1)));
+
+	pr_debug("SCIFAPI send (U): ep %p %s\n", ep, scif_ep_states[ep->state]);
+	if (!len)
+		return 0;
+
+	err = scif_msg_param_check(epd, len, flags);
+	if (err)
+		goto send_err;
+
+	tmp = kmalloc(chunk_len, GFP_KERNEL);
+	if (!tmp) {
+		err = -ENOMEM;
+		goto send_err;
+	}
+	/*
+	 * Grabbing the lock before breaking up the transfer in
+	 * multiple chunks is required to ensure that messages do
+	 * not get fragmented and reordered.
+	 */
+	mutex_lock(&ep->sendlock);
+	while (sent_len != len) {
+		loop_len = len - sent_len;
+		loop_len = min(chunk_len, loop_len);
+		if (copy_from_user(tmp, msg, loop_len)) {
+			err = -EFAULT;
+			goto send_free_err;
+		}
+		err = _scif_send(epd, tmp, loop_len, flags);
+		if (err < 0)
+			goto send_free_err;
+		sent_len += err;
+		msg += err;
+		if (err != loop_len)
+			goto send_free_err;
+	}
+send_free_err:
+	mutex_unlock(&ep->sendlock);
+	kfree(tmp);
+send_err:
+	return err < 0 ? err : sent_len;
+}
+
+/**
+ * scif_user_recv() - Receive data from connection queue
+ * @epd: The end point returned from scif_open()
+ * @msg: Address to place data
+ * @len: Length to receive
+ * @flags: blocking or non blocking
+ *
+ * This function is called from the driver IOCTL entry point
+ * only and is a wrapper for _scif_recv().
+ */
+int scif_user_recv(scif_epd_t epd, void __user *msg, int len, int flags)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	int err = 0;
+	int recv_len = 0;
+	char *tmp;
+	int loop_len;
+	int chunk_len = min(len, (1 << (MAX_ORDER + PAGE_SHIFT - 1)));
+
+	pr_debug("SCIFAPI recv (U): ep %p %s\n", ep, scif_ep_states[ep->state]);
+	if (!len)
+		return 0;
+
+	err = scif_msg_param_check(epd, len, flags);
+	if (err)
+		goto recv_err;
+
+	tmp = kmalloc(chunk_len, GFP_KERNEL);
+	if (!tmp) {
+		err = -ENOMEM;
+		goto recv_err;
+	}
+	/*
+	 * Grabbing the lock before breaking up the transfer in
+	 * multiple chunks is required to ensure that messages do
+	 * not get fragmented and reordered.
+	 */
+	mutex_lock(&ep->recvlock);
+	while (recv_len != len) {
+		loop_len = len - recv_len;
+		loop_len = min(chunk_len, loop_len);
+		err = _scif_recv(epd, tmp, loop_len, flags);
+		if (err < 0)
+			goto recv_free_err;
+		if (copy_to_user(msg, tmp, err)) {
+			err = -EFAULT;
+			goto recv_free_err;
+		}
+		recv_len += err;
+		msg += err;
+		if (err != loop_len)
+			goto recv_free_err;
+	}
+recv_free_err:
+	mutex_unlock(&ep->recvlock);
+	kfree(tmp);
+recv_err:
+	return err < 0 ? err : recv_len;
+}
+
+/**
+ * scif_send() - Send data to connection queue
+ * @epd: The end point returned from scif_open()
+ * @msg: Address to place data
+ * @len: Length to receive
+ * @flags: blocking or non blocking
+ *
+ * This function is called from the kernel mode only and is
+ * a wrapper for _scif_send().
+ */
+int scif_send(scif_epd_t epd, void *msg, int len, int flags)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	int ret;
+
+	pr_debug("SCIFAPI send (K): ep %p %s\n", ep, scif_ep_states[ep->state]);
+	if (!len)
+		return 0;
+
+	ret = scif_msg_param_check(epd, len, flags);
+	if (ret)
+		return ret;
+	if (!ep->remote_dev)
+		return -ENOTCONN;
+	/*
+	 * Grab the mutex lock in the blocking case only
+	 * to ensure messages do not get fragmented/reordered.
+	 * The non blocking mode is protected using spin locks
+	 * in _scif_send().
+	 */
+	if (flags & SCIF_SEND_BLOCK)
+		mutex_lock(&ep->sendlock);
+
+	ret = _scif_send(epd, msg, len, flags);
+
+	if (flags & SCIF_SEND_BLOCK)
+		mutex_unlock(&ep->sendlock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scif_send);
+
+/**
+ * scif_recv() - Receive data from connection queue
+ * @epd: The end point returned from scif_open()
+ * @msg: Address to place data
+ * @len: Length to receive
+ * @flags: blocking or non blocking
+ *
+ * This function is called from the kernel mode only and is
+ * a wrapper for _scif_recv().
+ */
+int scif_recv(scif_epd_t epd, void *msg, int len, int flags)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	int ret;
+
+	pr_debug("SCIFAPI recv (K): ep %p %s\n", ep, scif_ep_states[ep->state]);
+
+	if (!len)
+		return 0;
+
+	ret = scif_msg_param_check(epd, len, flags);
+	if (ret)
+		return ret;
+	/*
+	 * Grab the mutex lock in the blocking case only
+	 * to ensure messages do not get fragmented/reordered.
+	 * The non blocking mode is protected using spin locks
+	 * in _scif_send().
+	 */
+	if (flags & SCIF_RECV_BLOCK)
+		mutex_lock(&ep->recvlock);
+
+	ret = _scif_recv(epd, msg, len, flags);
+
+	if (flags & SCIF_RECV_BLOCK)
+		mutex_unlock(&ep->recvlock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scif_recv);
+
+int scif_get_node_ids(u16 *nodes, int len, u16 *self)
+{
+	int online = 0;
+	int offset = 0;
+	int node;
+
+	if (!scif_is_mgmt_node())
+		scif_get_node_info();
+
+	*self = scif_info.nodeid;
+	mutex_lock(&scif_info.conflock);
+	len = min_t(int, len, scif_info.total);
+	for (node = 0; node <= scif_info.maxid; node++) {
+		if (_scifdev_alive(&scif_dev[node])) {
+			online++;
+			if (offset < len)
+				nodes[offset++] = node;
+		}
+	}
+	pr_debug("SCIFAPI get_node_ids total %d online %d filled in %d nodes\n",
+		 scif_info.total, online, offset);
+	mutex_unlock(&scif_info.conflock);
+
+	return online;
+}
+EXPORT_SYMBOL_GPL(scif_get_node_ids);
diff --git a/drivers/misc/mic/scif/scif_epd.c b/drivers/misc/mic/scif/scif_epd.c
index 685ee5c..b4bfbb0 100644
--- a/drivers/misc/mic/scif/scif_epd.c
+++ b/drivers/misc/mic/scif/scif_epd.c
@@ -319,3 +319,35 @@ void scif_discnt_ack(struct scif_dev *scifdev, struct scifmsg *msg)
 	spin_unlock(&ep->lock);
 	complete(&ep->discon);
 }
+
+/**
+ * scif_clientsend() - Respond to SCIF_CLIENT_SEND interrupt message
+ * @msg:        Interrupt message
+ *
+ * Remote side is confirming send or receive interrupt handling is complete.
+ */
+void scif_clientsend(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	spin_lock(&ep->lock);
+	if (SCIFEP_CONNECTED == ep->state)
+		wake_up_interruptible(&ep->recvwq);
+	spin_unlock(&ep->lock);
+}
+
+/**
+ * scif_clientrcvd() - Respond to SCIF_CLIENT_RCVD interrupt message
+ * @msg:        Interrupt message
+ *
+ * Remote side is confirming send or receive interrupt handling is complete.
+ */
+void scif_clientrcvd(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	spin_lock(&ep->lock);
+	if (SCIFEP_CONNECTED == ep->state)
+		wake_up_interruptible(&ep->sendwq);
+	spin_unlock(&ep->lock);
+}
diff --git a/drivers/misc/mic/scif/scif_fd.c b/drivers/misc/mic/scif/scif_fd.c
index 4ccdf7d..c590524 100644
--- a/drivers/misc/mic/scif/scif_fd.c
+++ b/drivers/misc/mic/scif/scif_fd.c
@@ -69,6 +69,7 @@ static long scif_fdioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	struct scif_endpt *priv = f->private_data;
 	void __user *argp = (void __user *)arg;
 	int err = 0;
+	struct scifioctl_msg request;
 	bool non_block = false;
 
 	non_block = !!(f->f_flags & O_NONBLOCK);
@@ -197,6 +198,98 @@ static long scif_fdioctl(struct file *f, unsigned int cmd, unsigned long arg)
 		f->private_data = newep;
 		return 0;
 	}
+	case SCIF_SEND:
+	{
+		struct scif_endpt *priv = f->private_data;
+
+		if (copy_from_user(&request, argp,
+				   sizeof(struct scifioctl_msg))) {
+			err = -EFAULT;
+			goto send_err;
+		}
+		err = scif_user_send(priv, request.msg,
+				     request.len, request.flags);
+		if (err < 0)
+			goto send_err;
+		if (copy_to_user(&
+				 ((struct scifioctl_msg __user *)argp)->out_len,
+				 &err, sizeof(err))) {
+			err = -EFAULT;
+			goto send_err;
+		}
+		err = 0;
+send_err:
+		scif_err_debug(err, "scif_send");
+		return err;
+	}
+	case SCIF_RECV:
+	{
+		struct scif_endpt *priv = f->private_data;
+
+		if (copy_from_user(&request, argp,
+				   sizeof(struct scifioctl_msg))) {
+			err = -EFAULT;
+			goto recv_err;
+		}
+
+		err = scif_user_recv(priv, request.msg,
+				     request.len, request.flags);
+		if (err < 0)
+			goto recv_err;
+
+		if (copy_to_user(&
+				 ((struct scifioctl_msg __user *)argp)->out_len,
+			&err, sizeof(err))) {
+			err = -EFAULT;
+			goto recv_err;
+		}
+		err = 0;
+recv_err:
+		scif_err_debug(err, "scif_recv");
+		return err;
+	}
+	case SCIF_GET_NODEIDS:
+	{
+		struct scifioctl_node_ids node_ids;
+		int entries;
+		u16 *nodes;
+		void __user *unodes, *uself;
+		u16 self;
+
+		if (copy_from_user(&node_ids, argp, sizeof(node_ids))) {
+			err = -EFAULT;
+			goto getnodes_err2;
+		}
+
+		entries = min_t(int, scif_info.maxid, node_ids.len);
+		nodes = kmalloc_array(entries, sizeof(u16), GFP_KERNEL);
+		if (entries && !nodes) {
+			err = -ENOMEM;
+			goto getnodes_err2;
+		}
+		node_ids.len = scif_get_node_ids(nodes, entries, &self);
+
+		unodes = node_ids.nodes;
+		if (copy_to_user(unodes, nodes, sizeof(u16) * entries)) {
+			err = -EFAULT;
+			goto getnodes_err1;
+		}
+
+		uself = node_ids.self;
+		if (copy_to_user(uself, &self, sizeof(u16))) {
+			err = -EFAULT;
+			goto getnodes_err1;
+		}
+
+		if (copy_to_user(argp, &node_ids, sizeof(node_ids))) {
+			err = -EFAULT;
+			goto getnodes_err1;
+		}
+getnodes_err1:
+		kfree(nodes);
+getnodes_err2:
+		return err;
+	}
 	}
 	return -EINVAL;
 }
diff --git a/drivers/misc/mic/scif/scif_nm.c b/drivers/misc/mic/scif/scif_nm.c
index f28b74a..e1298ee 100644
--- a/drivers/misc/mic/scif/scif_nm.c
+++ b/drivers/misc/mic/scif/scif_nm.c
@@ -210,3 +210,20 @@ void scif_disconnect_node(u32 node_id, bool mgmt_initiated)
 				   (atomic_read(&scifdev->disconn_rescnt) == 1),
 				   SCIF_NODE_ALIVE_TIMEOUT);
 }
+
+void scif_get_node_info(void)
+{
+	struct scifmsg msg;
+	DECLARE_COMPLETION_ONSTACK(node_info);
+
+	msg.uop = SCIF_GET_NODE_INFO;
+	msg.src.node = scif_info.nodeid;
+	msg.dst.node = SCIF_MGMT_NODE;
+	msg.payload[3] = (u64)&node_info;
+
+	if ((scif_nodeqp_send(&scif_dev[SCIF_MGMT_NODE], &msg)))
+		return;
+
+	/* Wait for a response with SCIF_GET_NODE_INFO */
+	wait_for_completion(&node_info);
+}
diff --git a/drivers/misc/mic/scif/scif_nodeqp.c b/drivers/misc/mic/scif/scif_nodeqp.c
index a51762d0..0f6bedf 100644
--- a/drivers/misc/mic/scif/scif_nodeqp.c
+++ b/drivers/misc/mic/scif/scif_nodeqp.c
@@ -587,7 +587,10 @@ static char *message_types[] = {"BAD",
 				"CNCT_GNTNACK",
 				"CNCT_REJ",
 				"DISCNCT",
-				"DISCNT_ACK"};
+				"DISCNT_ACK",
+				"CLIENT_SENT",
+				"CLIENT_RCVD",
+				"SCIF_GET_NODE_INFO"};
 
 static void
 scif_display_message(struct scif_dev *scifdev, struct scifmsg *msg,
@@ -944,6 +947,34 @@ scif_node_remove_ack(struct scif_dev *scifdev, struct scifmsg *msg)
 	wake_up(&sdev->disconn_wq);
 }
 
+/**
+ * scif_get_node_info: Respond to SCIF_GET_NODE_INFO interrupt message
+ * @msg:        Interrupt message
+ *
+ * Retrieve node info i.e maxid and total from the mgmt node.
+ */
+static __always_inline void
+scif_get_node_info_resp(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	if (scif_is_mgmt_node()) {
+		swap(msg->dst.node, msg->src.node);
+		mutex_lock(&scif_info.conflock);
+		msg->payload[1] = scif_info.maxid;
+		msg->payload[2] = scif_info.total;
+		mutex_unlock(&scif_info.conflock);
+		scif_nodeqp_send(scifdev, msg);
+	} else {
+		struct completion *node_info =
+			(struct completion *)msg->payload[3];
+
+		mutex_lock(&scif_info.conflock);
+		scif_info.maxid = msg->payload[1];
+		scif_info.total = msg->payload[2];
+		complete_all(node_info);
+		mutex_unlock(&scif_info.conflock);
+	}
+}
+
 static void
 scif_msg_unknown(struct scif_dev *scifdev, struct scifmsg *msg)
 {
@@ -970,6 +1001,9 @@ static void (*scif_intr_func[SCIF_MAX_MSG + 1])
 	scif_cnctrej,		/* SCIF_CNCT_REJ */
 	scif_discnct,		/* SCIF_DISCNCT */
 	scif_discnt_ack,	/* SCIF_DISCNT_ACK */
+	scif_clientsend,	/* SCIF_CLIENT_SENT */
+	scif_clientrcvd,	/* SCIF_CLIENT_RCVD */
+	scif_get_node_info_resp,/* SCIF_GET_NODE_INFO */
 };
 
 /**
-- 
1.8.2.1

