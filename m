Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbaLJTtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:49:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:57532 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376AbaLJTtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770557"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 09/13] misc: mic: SCIF connections APIs i.e. accept and connect
Date: Wed, 10 Dec 2014 11:47:49 -0800
Message-Id: <7105f60fd49fa7a9bf51c28eaae9bbc1da969fb6.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikhil Rao <nikhil.rao@intel.com>

SCIF connection APIs which establish a SCIF connection between
a pair of SCIF endpoints. A SCIF connection consists of a
dedicated queue-pair between the endpoints. Client messages are
sent over the queue-pair whereas the signaling associated with the
message is multiplexed over the node queue-pair. Similarly other
control messages such as exposing registered memory are also sent
over the node queue-pair. The SCIF endpoints must be in connected
state to exchange messages, register memory, map remote memory and
trigger DMA transfers. SCIF connections can be set up
asynchronously or synchronously.

Thanks to Johnnie S Peters for authoring parts of this patch during
early bring up of the SCIF driver.

Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
---
 drivers/misc/mic/scif/scif_epd.h    |   8 +
 drivers/misc/mic/scif/scif_api.c    | 455 ++++++++++++++++++++++++++++++++++++
 drivers/misc/mic/scif/scif_epd.c    | 229 ++++++++++++++++++
 drivers/misc/mic/scif/scif_fd.c     | 106 +++++++++
 drivers/misc/mic/scif/scif_main.c   |   1 +
 drivers/misc/mic/scif/scif_nm.c     |  36 +++
 drivers/misc/mic/scif/scif_nodeqp.c |  16 +-
 7 files changed, 850 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mic/scif/scif_epd.h b/drivers/misc/mic/scif/scif_epd.h
index b973b99..65c628e 100644
--- a/drivers/misc/mic/scif/scif_epd.h
+++ b/drivers/misc/mic/scif/scif_epd.h
@@ -144,5 +144,13 @@ int scif_rsrv_port(u16 port);
 void scif_get_port(u16 port);
 int scif_get_new_port(void);
 void scif_put_port(u16 port);
+void scif_cnctreq(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_cnctgnt(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_cnctgnt_ack(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_cnctgnt_nack(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_cnctrej(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_discnct(struct scif_dev *scifdev, struct scifmsg *msg);
+void scif_discnt_ack(struct scif_dev *scifdev, struct scifmsg *msg);
+int __scif_connect(scif_epd_t epd, struct scif_port_id *dst, bool non_block);
 int __scif_flush(scif_epd_t epd);
 #endif /* SCIF_EPD_H */
diff --git a/drivers/misc/mic/scif/scif_api.c b/drivers/misc/mic/scif/scif_api.c
index d5f10f3..28494a3 100644
--- a/drivers/misc/mic/scif/scif_api.c
+++ b/drivers/misc/mic/scif/scif_api.c
@@ -415,3 +415,458 @@ int scif_listen(scif_epd_t epd, int backlog)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(scif_listen);
+
+/*
+ ************************************************************************
+ * SCIF connection flow:
+ *
+ * 1) A SCIF listening endpoint can call scif_accept(..) to wait for SCIF
+ *	connections via a SCIF_CNCT_REQ message
+ * 2) A SCIF endpoint can initiate a SCIF connection by calling
+ *	scif_connect(..) which calls scif_setup_qp_connect(..) which
+ *	allocates the local qp for the endpoint ring buffer and then sends
+ *	a SCIF_CNCT_REQ to the remote node and waits for a SCIF_CNCT_GNT or
+ *	a SCIF_CNCT_REJ message
+ * 3) The peer node handles a SCIF_CNCT_REQ via scif_cnctreq_resp(..) which
+ *	wakes up any threads blocked in step 1 or sends a SCIF_CNCT_REJ
+ *	message otherwise
+ * 4) A thread blocked waiting for incoming connections allocates its local
+ *	endpoint QP and ring buffer following which it sends a SCIF_CNCT_GNT
+ *	and waits for a SCIF_CNCT_GNT(N)ACK. If the allocation fails then
+ *	the node sends a SCIF_CNCT_REJ message
+ * 5) Upon receipt of a SCIF_CNCT_GNT or a SCIF_CNCT_REJ message the
+ *	connecting endpoint is woken up as part of handling
+ *	scif_cnctgnt_resp(..) following which it maps the remote endpoints'
+ *	QP, updates its outbound QP and sends a SCIF_CNCT_GNTACK message on
+ *	success or a SCIF_CNCT_GNTNACK message on failure and completes
+ *	the scif_connect(..) API
+ * 6) Upon receipt of a SCIF_CNCT_GNT(N)ACK the accepting endpoint blocked
+ *	in step 4 is woken up and completes the scif_accept(..) API
+ * 7) The SCIF connection is now established between the two SCIF endpoints.
+ */
+static int scif_conn_func(struct scif_endpt *ep)
+{
+	int err = 0;
+	struct scifmsg msg;
+	struct device *spdev;
+
+	/* Initiate the first part of the endpoint QP setup */
+	err = scif_setup_qp_connect(ep->qp_info.qp, &ep->qp_info.qp_offset,
+				    SCIF_ENDPT_QP_SIZE, ep->remote_dev);
+	if (err) {
+		pr_err("%s err %d qp_offset 0x%llx\n",
+		       __func__, err, ep->qp_info.qp_offset);
+		ep->state = SCIFEP_BOUND;
+		goto connect_error_simple;
+	}
+
+	spdev = scif_get_peer_dev(ep->remote_dev);
+	if (IS_ERR(spdev)) {
+		err = PTR_ERR(spdev);
+		goto cleanup_qp;
+	}
+	/* Format connect message and send it */
+	msg.src = ep->port;
+	msg.dst = ep->conn_port;
+	msg.uop = SCIF_CNCT_REQ;
+	msg.payload[0] = (u64)ep;
+	msg.payload[1] = ep->qp_info.qp_offset;
+	err = _scif_nodeqp_send(ep->remote_dev, &msg);
+	if (err)
+		goto connect_error_dec;
+	scif_put_peer_dev(spdev);
+	/*
+	 * Wait for the remote node to respond with SCIF_CNCT_GNT or
+	 * SCIF_CNCT_REJ message.
+	 */
+	wait_event_timeout(ep->conwq, ep->state != SCIFEP_CONNECTING,
+			   SCIF_NODE_ALIVE_TIMEOUT);
+	spdev = scif_get_peer_dev(ep->remote_dev);
+	if (IS_ERR(spdev)) {
+		err = PTR_ERR(spdev);
+		goto cleanup_qp;
+	}
+	if (ep->state == SCIFEP_MAPPING) {
+		err = scif_setup_qp_connect_response(ep->remote_dev,
+						     ep->qp_info.qp,
+						     ep->qp_info.gnt_pld);
+		/*
+		 * If the resource to map the queue are not available then
+		 * we need to tell the other side to terminate the accept
+		 */
+		if (err) {
+			pr_err("%s %d err %d\n", __func__, __LINE__, err);
+			msg.uop = SCIF_CNCT_GNTNACK;
+			msg.payload[0] = ep->remote_ep;
+			_scif_nodeqp_send(ep->remote_dev, &msg);
+			ep->state = SCIFEP_BOUND;
+			goto connect_error_dec;
+		}
+
+		msg.uop = SCIF_CNCT_GNTACK;
+		msg.payload[0] = ep->remote_ep;
+		err = _scif_nodeqp_send(ep->remote_dev, &msg);
+		if (err) {
+			ep->state = SCIFEP_BOUND;
+			goto connect_error_dec;
+		}
+		ep->state = SCIFEP_CONNECTED;
+		mutex_lock(&scif_info.connlock);
+		list_add_tail(&ep->list, &scif_info.connected);
+		mutex_unlock(&scif_info.connlock);
+		pr_debug("SCIFAPI connect: ep %p connected\n", ep);
+	} else if (ep->state == SCIFEP_BOUND) {
+		pr_debug("SCIFAPI connect: ep %p connection refused\n", ep);
+		err = -ECONNREFUSED;
+		goto connect_error_dec;
+	}
+	scif_put_peer_dev(spdev);
+	return err;
+connect_error_dec:
+	scif_put_peer_dev(spdev);
+cleanup_qp:
+	scif_cleanup_ep_qp(ep);
+connect_error_simple:
+	return err;
+}
+
+/*
+ * scif_conn_handler:
+ *
+ * Workqueue handler for servicing non-blocking SCIF connect
+ *
+ */
+void scif_conn_handler(struct work_struct *work)
+{
+	struct scif_endpt *ep;
+
+	do {
+		ep = NULL;
+		spin_lock(&scif_info.nb_connect_lock);
+		if (!list_empty(&scif_info.nb_connect_list)) {
+			ep = list_first_entry(&scif_info.nb_connect_list,
+					      struct scif_endpt, conn_list);
+			list_del(&ep->conn_list);
+		}
+		spin_unlock(&scif_info.nb_connect_lock);
+		if (ep)
+			ep->conn_err = scif_conn_func(ep);
+	} while (ep);
+}
+
+int __scif_connect(scif_epd_t epd, struct scif_port_id *dst, bool non_block)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	int err = 0;
+	struct scif_dev *remote_dev;
+	struct device *spdev;
+
+	pr_debug("SCIFAPI connect: ep %p %s\n", ep,
+		 scif_ep_states[ep->state]);
+
+	if (!scif_dev || dst->node > scif_info.maxid)
+		return -ENODEV;
+
+	might_sleep();
+
+	remote_dev = &scif_dev[dst->node];
+	spdev = scif_get_peer_dev(remote_dev);
+	if (IS_ERR(spdev)) {
+		err = PTR_ERR(spdev);
+		return err;
+	}
+
+	spin_lock(&ep->lock);
+	switch (ep->state) {
+	case SCIFEP_ZOMBIE:
+	case SCIFEP_CLOSING:
+		err = -EINVAL;
+		break;
+	case SCIFEP_DISCONNECTED:
+		if (ep->conn_async_state == ASYNC_CONN_INPROGRESS)
+			ep->conn_async_state = ASYNC_CONN_FLUSH_WORK;
+		else
+			err = -EINVAL;
+		break;
+	case SCIFEP_LISTENING:
+	case SCIFEP_CLLISTEN:
+		err = -EOPNOTSUPP;
+		break;
+	case SCIFEP_CONNECTING:
+	case SCIFEP_MAPPING:
+		if (ep->conn_async_state == ASYNC_CONN_INPROGRESS)
+			err = -EINPROGRESS;
+		else
+			err = -EISCONN;
+		break;
+	case SCIFEP_CONNECTED:
+		if (ep->conn_async_state == ASYNC_CONN_INPROGRESS)
+			ep->conn_async_state = ASYNC_CONN_FLUSH_WORK;
+		else
+			err = -EISCONN;
+		break;
+	case SCIFEP_UNBOUND:
+		ep->port.port = scif_get_new_port();
+		if (!ep->port.port) {
+			err = -ENOSPC;
+		} else {
+			ep->port.node = scif_info.nodeid;
+			ep->conn_async_state = ASYNC_CONN_IDLE;
+		}
+		/* Fall through */
+	case SCIFEP_BOUND:
+		/*
+		 * If a non-blocking connect has been already initiated
+		 * (conn_async_state is either ASYNC_CONN_INPROGRESS or
+		 * ASYNC_CONN_FLUSH_WORK), the end point could end up in
+		 * SCIF_BOUND due an error in the connection process
+		 * (e.g., connection refused) If conn_async_state is
+		 * ASYNC_CONN_INPROGRESS - transition to ASYNC_CONN_FLUSH_WORK
+		 * so that the error status can be collected. If the state is
+		 * already ASYNC_CONN_FLUSH_WORK - then set the error to
+		 * EINPROGRESS since some other thread is waiting to collect
+		 * error status.
+		 */
+		if (ep->conn_async_state == ASYNC_CONN_INPROGRESS) {
+			ep->conn_async_state = ASYNC_CONN_FLUSH_WORK;
+		} else if (ep->conn_async_state == ASYNC_CONN_FLUSH_WORK) {
+			err = -EINPROGRESS;
+		} else {
+			ep->conn_port = *dst;
+			init_waitqueue_head(&ep->sendwq);
+			init_waitqueue_head(&ep->recvwq);
+			init_waitqueue_head(&ep->conwq);
+			ep->conn_async_state = 0;
+
+			if (unlikely(non_block))
+				ep->conn_async_state = ASYNC_CONN_INPROGRESS;
+		}
+		break;
+	}
+
+	if (err || ep->conn_async_state == ASYNC_CONN_FLUSH_WORK)
+			goto connect_simple_unlock1;
+
+	ep->state = SCIFEP_CONNECTING;
+	ep->remote_dev = &scif_dev[dst->node];
+	ep->qp_info.qp->magic = SCIFEP_MAGIC;
+	if (ep->conn_async_state == ASYNC_CONN_INPROGRESS) {
+		spin_lock(&scif_info.nb_connect_lock);
+		list_add_tail(&ep->conn_list, &scif_info.nb_connect_list);
+		spin_unlock(&scif_info.nb_connect_lock);
+		err = -EINPROGRESS;
+		schedule_work(&scif_info.conn_work);
+	}
+connect_simple_unlock1:
+	spin_unlock(&ep->lock);
+	scif_put_peer_dev(spdev);
+	if (err) {
+		return err;
+	} else if (ep->conn_async_state == ASYNC_CONN_FLUSH_WORK) {
+		flush_work(&scif_info.conn_work);
+		err = ep->conn_err;
+		spin_lock(&ep->lock);
+		ep->conn_async_state = ASYNC_CONN_IDLE;
+		spin_unlock(&ep->lock);
+	} else {
+		err = scif_conn_func(ep);
+	}
+	return err;
+}
+
+int scif_connect(scif_epd_t epd, struct scif_port_id *dst)
+{
+	return __scif_connect(epd, dst, false);
+}
+EXPORT_SYMBOL_GPL(scif_connect);
+
+/**
+ * scif_accept() - Accept a connection request from the remote node
+ *
+ * The function accepts a connection request from the remote node.  Successful
+ * complete is indicate by a new end point being created and passed back
+ * to the caller for future reference.
+ *
+ * Upon successful complete a zero will be returned and the peer information
+ * will be filled in.
+ *
+ * If the end point is not in the listening state -EINVAL will be returned.
+ *
+ * If during the connection sequence resource allocation fails the -ENOMEM
+ * will be returned.
+ *
+ * If the function is called with the ASYNC flag set and no connection requests
+ * are pending it will return -EAGAIN.
+ *
+ * If the remote side is not sending any connection requests the caller may
+ * terminate this function with a signal.  If so a -EINTR will be returned.
+ */
+int scif_accept(scif_epd_t epd, struct scif_port_id *peer,
+		scif_epd_t *newepd, int flags)
+{
+	struct scif_endpt *lep = (struct scif_endpt *)epd;
+	struct scif_endpt *cep;
+	struct scif_conreq *conreq;
+	struct scifmsg msg;
+	int err;
+	struct device *spdev;
+
+	pr_debug("SCIFAPI accept: ep %p %s\n", lep, scif_ep_states[lep->state]);
+
+	if (flags & ~SCIF_ACCEPT_SYNC) {
+		pr_debug("SCIFAPI accept: ep %p invalid flags %x\n",
+			 lep, flags & ~SCIF_ACCEPT_SYNC);
+		return -EINVAL;
+	}
+
+	if (!peer || !newepd) {
+		pr_debug("SCIFAPI accept: ep %p peer %p or newepd %p NULL\n",
+			 lep, peer, newepd);
+		return -EINVAL;
+	}
+
+	might_sleep();
+	spin_lock(&lep->lock);
+	if (lep->state != SCIFEP_LISTENING) {
+		pr_debug("SCIFAPI accept: ep %p not listening\n", lep);
+		spin_unlock(&lep->lock);
+		return -EINVAL;
+	}
+
+	if (!lep->conreqcnt && !(flags & SCIF_ACCEPT_SYNC)) {
+		/* No connection request present and we do not want to wait */
+		spin_unlock(&lep->lock);
+		return -EAGAIN;
+	}
+
+	lep->files = current->files;
+retry_connection:
+	spin_unlock(&lep->lock);
+	/* Wait for the remote node to send us a SCIF_CNCT_REQ */
+	err = wait_event_interruptible(lep->conwq,
+				       (lep->conreqcnt ||
+				       (lep->state != SCIFEP_LISTENING)));
+	if (err)
+		return err;
+
+	if (lep->state != SCIFEP_LISTENING)
+		return -EINTR;
+
+	spin_lock(&lep->lock);
+
+	if (!lep->conreqcnt)
+		goto retry_connection;
+
+	/* Get the first connect request off the list */
+	conreq = list_first_entry(&lep->conlist, struct scif_conreq, list);
+	list_del(&conreq->list);
+	lep->conreqcnt--;
+	spin_unlock(&lep->lock);
+
+	/* Fill in the peer information */
+	peer->node = conreq->msg.src.node;
+	peer->port = conreq->msg.src.port;
+
+	cep = kzalloc(sizeof(*cep), GFP_KERNEL);
+	if (!cep) {
+		err = -ENOMEM;
+		goto scif_accept_error_epalloc;
+	}
+	spin_lock_init(&cep->lock);
+	mutex_init(&cep->sendlock);
+	mutex_init(&cep->recvlock);
+	cep->state = SCIFEP_CONNECTING;
+	cep->remote_dev = &scif_dev[peer->node];
+	cep->remote_ep = conreq->msg.payload[0];
+
+	cep->qp_info.qp = kzalloc(sizeof(*cep->qp_info.qp), GFP_KERNEL);
+	if (!cep->qp_info.qp) {
+		err = -ENOMEM;
+		goto scif_accept_error_qpalloc;
+	}
+
+	cep->qp_info.qp->magic = SCIFEP_MAGIC;
+	spdev = scif_get_peer_dev(cep->remote_dev);
+	if (IS_ERR(spdev)) {
+		err = PTR_ERR(spdev);
+		goto scif_accept_error_map;
+	}
+	err = scif_setup_qp_accept(cep->qp_info.qp, &cep->qp_info.qp_offset,
+				   conreq->msg.payload[1], SCIF_ENDPT_QP_SIZE,
+				   cep->remote_dev);
+	if (err) {
+		pr_debug("SCIFAPI accept: ep %p new %p scif_setup_qp_accept %d qp_offset 0x%llx\n",
+			 lep, cep, err, cep->qp_info.qp_offset);
+		scif_put_peer_dev(spdev);
+		goto scif_accept_error_map;
+	}
+
+	cep->port.node = lep->port.node;
+	cep->port.port = lep->port.port;
+	cep->peer.node = peer->node;
+	cep->peer.port = peer->port;
+	init_waitqueue_head(&cep->sendwq);
+	init_waitqueue_head(&cep->recvwq);
+	init_waitqueue_head(&cep->conwq);
+
+	msg.uop = SCIF_CNCT_GNT;
+	msg.src = cep->port;
+	msg.payload[0] = cep->remote_ep;
+	msg.payload[1] = cep->qp_info.qp_offset;
+	msg.payload[2] = (u64)cep;
+
+	err = _scif_nodeqp_send(cep->remote_dev, &msg);
+	scif_put_peer_dev(spdev);
+	if (err)
+		goto scif_accept_error_map;
+retry:
+	/* Wait for the remote node to respond with SCIF_CNCT_GNT(N)ACK */
+	err = wait_event_timeout(cep->conwq, cep->state != SCIFEP_CONNECTING,
+				 SCIF_NODE_ACCEPT_TIMEOUT);
+	if (!err && scifdev_alive(cep))
+		goto retry;
+	err = !err ? -ENODEV : 0;
+	if (err)
+		goto scif_accept_error_map;
+	kfree(conreq);
+
+	spin_lock(&cep->lock);
+
+	if (cep->state == SCIFEP_CLOSING) {
+		/*
+		 * Remote failed to allocate resources and NAKed the grant.
+		 * There is at this point nothing referencing the new end point.
+		 */
+		spin_unlock(&cep->lock);
+		scif_teardown_ep(cep);
+		kfree(cep);
+
+		/* If call with sync flag then go back and wait. */
+		if (flags & SCIF_ACCEPT_SYNC) {
+			spin_lock(&lep->lock);
+			goto retry_connection;
+		}
+
+		pr_debug("SCIFAPI accept: ep %p new %p fail\n", lep, cep);
+		return -EAGAIN;
+	}
+
+	scif_get_port(cep->port.port);
+	*newepd = (scif_epd_t)cep;
+	spin_unlock(&cep->lock);
+	return 0;
+scif_accept_error_map:
+	scif_teardown_ep(cep);
+scif_accept_error_qpalloc:
+	kfree(cep);
+scif_accept_error_epalloc:
+	msg.uop = SCIF_CNCT_REJ;
+	msg.dst.node = conreq->msg.src.node;
+	msg.dst.port = conreq->msg.src.port;
+	msg.payload[0] = conreq->msg.payload[0];
+	msg.payload[1] = conreq->msg.payload[1];
+	scif_nodeqp_send(&scif_dev[conreq->msg.src.node], &msg);
+	kfree(conreq);
+	return err;
+}
+EXPORT_SYMBOL_GPL(scif_accept);
diff --git a/drivers/misc/mic/scif/scif_epd.c b/drivers/misc/mic/scif/scif_epd.c
index a2b728a..685ee5c 100644
--- a/drivers/misc/mic/scif/scif_epd.c
+++ b/drivers/misc/mic/scif/scif_epd.c
@@ -76,6 +76,24 @@ void scif_add_epd_to_zombie_list(struct scif_endpt *ep, bool eplock_held)
 	schedule_work(&scif_info.misc_work);
 }
 
+static struct scif_endpt *scif_find_listen_ep(u16 port)
+{
+	struct scif_endpt *ep = NULL;
+	struct list_head *pos, *tmpq;
+
+	spin_lock(&scif_info.eplock);
+	list_for_each_safe(pos, tmpq, &scif_info.listen) {
+		ep = list_entry(pos, struct scif_endpt, list);
+		if (ep->port.port == port) {
+			spin_lock(&ep->lock);
+			spin_unlock(&scif_info.eplock);
+			return ep;
+		}
+	}
+	spin_unlock(&scif_info.eplock);
+	return NULL;
+}
+
 void scif_cleanup_zombie_epd(void)
 {
 	struct list_head *pos, *tmpq;
@@ -90,3 +108,214 @@ void scif_cleanup_zombie_epd(void)
 	}
 	spin_unlock(&scif_info.eplock);
 }
+
+/**
+ * scif_cnctreq() - Respond to SCIF_CNCT_REQ interrupt message
+ * @msg:        Interrupt message
+ *
+ * This message is initiated by the remote node to request a connection
+ * to the local node.  This function looks for an end point in the
+ * listen state on the requested port id.
+ *
+ * If it finds a listening port it places the connect request on the
+ * listening end points queue and wakes up any pending accept calls.
+ *
+ * If it does not find a listening end point it sends a connection
+ * reject message to the remote node.
+ */
+void scif_cnctreq(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = NULL;
+	struct scif_conreq *conreq;
+
+	conreq = kmalloc(sizeof(*conreq), GFP_KERNEL);
+	if (!conreq)
+		/* Lack of resources so reject the request. */
+		goto conreq_sendrej;
+
+	ep = scif_find_listen_ep(msg->dst.port);
+	if (!ep)
+		/*  Send reject due to no listening ports */
+		goto conreq_sendrej_free;
+
+	if (ep->backlog <= ep->conreqcnt) {
+		/*  Send reject due to too many pending requests */
+		spin_unlock(&ep->lock);
+		goto conreq_sendrej_free;
+	}
+
+	conreq->msg = *msg;
+	list_add_tail(&conreq->list, &ep->conlist);
+	ep->conreqcnt++;
+	wake_up_interruptible(&ep->conwq);
+	spin_unlock(&ep->lock);
+	return;
+
+conreq_sendrej_free:
+	kfree(conreq);
+conreq_sendrej:
+	msg->uop = SCIF_CNCT_REJ;
+	scif_nodeqp_send(&scif_dev[msg->src.node], msg);
+}
+
+/**
+ * scif_cnctgnt() - Respond to SCIF_CNCT_GNT interrupt message
+ * @msg:        Interrupt message
+ *
+ * An accept() on the remote node has occurred and sent this message
+ * to indicate success.  Place the end point in the MAPPING state and
+ * save the remote nodes memory information.  Then wake up the connect
+ * request so it can finish.
+ */
+void scif_cnctgnt(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	spin_lock(&ep->lock);
+	if (SCIFEP_CONNECTING == ep->state) {
+		ep->peer.node = msg->src.node;
+		ep->peer.port = msg->src.port;
+		ep->qp_info.gnt_pld = msg->payload[1];
+		ep->remote_ep = msg->payload[2];
+		ep->state = SCIFEP_MAPPING;
+
+		wake_up(&ep->conwq);
+	}
+	spin_unlock(&ep->lock);
+}
+
+/**
+ * scif_cnctgnt_ack() - Respond to SCIF_CNCT_GNTACK interrupt message
+ * @msg:        Interrupt message
+ *
+ * The remote connection request has finished mapping the local memory.
+ * Place the connection in the connected state and wake up the pending
+ * accept() call.
+ */
+void scif_cnctgnt_ack(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	mutex_lock(&scif_info.connlock);
+	spin_lock(&ep->lock);
+	/* New ep is now connected with all resources set. */
+	ep->state = SCIFEP_CONNECTED;
+	list_add_tail(&ep->list, &scif_info.connected);
+	wake_up(&ep->conwq);
+	spin_unlock(&ep->lock);
+	mutex_unlock(&scif_info.connlock);
+}
+
+/**
+ * scif_cnctgnt_nack() - Respond to SCIF_CNCT_GNTNACK interrupt message
+ * @msg:        Interrupt message
+ *
+ * The remote connection request failed to map the local memory it was sent.
+ * Place the end point in the CLOSING state to indicate it and wake up
+ * the pending accept();
+ */
+void scif_cnctgnt_nack(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	spin_lock(&ep->lock);
+	ep->state = SCIFEP_CLOSING;
+	wake_up(&ep->conwq);
+	spin_unlock(&ep->lock);
+}
+
+/**
+ * scif_cnctrej() - Respond to SCIF_CNCT_REJ interrupt message
+ * @msg:        Interrupt message
+ *
+ * The remote end has rejected the connection request.  Set the end
+ * point back to the bound state and wake up the pending connect().
+ */
+void scif_cnctrej(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	spin_lock(&ep->lock);
+	if (SCIFEP_CONNECTING == ep->state) {
+		ep->state = SCIFEP_BOUND;
+		wake_up(&ep->conwq);
+	}
+	spin_unlock(&ep->lock);
+}
+
+/**
+ * scif_discnct() - Respond to SCIF_DISCNCT interrupt message
+ * @msg:        Interrupt message
+ *
+ * The remote node has indicated close() has been called on its end
+ * point.  Remove the local end point from the connected list, set its
+ * state to disconnected and ensure accesses to the remote node are
+ * shutdown.
+ *
+ * When all accesses to the remote end have completed then send a
+ * DISCNT_ACK to indicate it can remove its resources and complete
+ * the close routine.
+ */
+void scif_discnct(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = NULL;
+	struct scif_endpt *tmpep;
+	struct list_head *pos, *tmpq;
+
+	mutex_lock(&scif_info.connlock);
+	list_for_each_safe(pos, tmpq, &scif_info.connected) {
+		tmpep = list_entry(pos, struct scif_endpt, list);
+		/*
+		 * The local ep may have sent a disconnect and and been closed
+		 * due to a message response time out. It may have been
+		 * allocated again and formed a new connection so we want to
+		 * check if the remote ep matches
+		 */
+		if (((u64)tmpep == msg->payload[1]) &&
+		    ((u64)tmpep->remote_ep == msg->payload[0])) {
+			list_del(pos);
+			ep = tmpep;
+			spin_lock(&ep->lock);
+			break;
+		}
+	}
+
+	/*
+	 * If the terminated end is not found then this side started closing
+	 * before the other side sent the disconnect.  If so the ep will no
+	 * longer be on the connected list.  Regardless the other side
+	 * needs to be acked to let it know close is complete.
+	 */
+	if (!ep) {
+		mutex_unlock(&scif_info.connlock);
+		goto discnct_ack;
+	}
+
+	ep->state = SCIFEP_DISCONNECTED;
+	list_add_tail(&ep->list, &scif_info.disconnected);
+
+	wake_up_interruptible(&ep->sendwq);
+	wake_up_interruptible(&ep->recvwq);
+	spin_unlock(&ep->lock);
+	mutex_unlock(&scif_info.connlock);
+
+discnct_ack:
+	msg->uop = SCIF_DISCNT_ACK;
+	scif_nodeqp_send(&scif_dev[msg->src.node], msg);
+}
+
+/**
+ * scif_discnct_ack() - Respond to SCIF_DISCNT_ACK interrupt message
+ * @msg:        Interrupt message
+ *
+ * Remote side has indicated it has not more references to local resources
+ */
+void scif_discnt_ack(struct scif_dev *scifdev, struct scifmsg *msg)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)msg->payload[0];
+
+	spin_lock(&ep->lock);
+	ep->state = SCIFEP_DISCONNECTED;
+	spin_unlock(&ep->lock);
+	complete(&ep->discon);
+}
diff --git a/drivers/misc/mic/scif/scif_fd.c b/drivers/misc/mic/scif/scif_fd.c
index d81ab7c..4ccdf7d 100644
--- a/drivers/misc/mic/scif/scif_fd.c
+++ b/drivers/misc/mic/scif/scif_fd.c
@@ -68,6 +68,7 @@ static long scif_fdioctl(struct file *f, unsigned int cmd, unsigned long arg)
 {
 	struct scif_endpt *priv = f->private_data;
 	void __user *argp = (void __user *)arg;
+	int err = 0;
 	bool non_block = false;
 
 	non_block = !!(f->f_flags & O_NONBLOCK);
@@ -91,6 +92,111 @@ static long scif_fdioctl(struct file *f, unsigned int cmd, unsigned long arg)
 	}
 	case SCIF_LISTEN:
 		return scif_listen(priv, arg);
+	case SCIF_CONNECT:
+	{
+		struct scifioctl_connect req;
+		struct scif_endpt *ep = (struct scif_endpt *)priv;
+
+		if (copy_from_user(&req, argp, sizeof(req)))
+			return -EFAULT;
+
+		err = __scif_connect(priv, &req.peer, non_block);
+		if (err < 0)
+			return err;
+
+		req.self.node = ep->port.node;
+		req.self.port = ep->port.port;
+
+		if (copy_to_user(argp, &req, sizeof(req)))
+			return -EFAULT;
+
+		return 0;
+	}
+	/*
+	 * Accept is done in two halves.  The request ioctl does the basic
+	 * functionality of accepting the request and returning the information
+	 * about it including the internal ID of the end point.  The register
+	 * is done with the internal ID on a new file descriptor opened by the
+	 * requesting process.
+	 */
+	case SCIF_ACCEPTREQ:
+	{
+		struct scifioctl_accept request;
+		scif_epd_t *ep = (scif_epd_t *)&request.endpt;
+
+		if (copy_from_user(&request, argp, sizeof(request)))
+			return -EFAULT;
+
+		err = scif_accept(priv, &request.peer, ep, request.flags);
+		if (err < 0)
+			return err;
+
+		if (copy_to_user(argp, &request, sizeof(request))) {
+			scif_close(*ep);
+			return -EFAULT;
+		}
+		/*
+		 * Add to the list of user mode eps where the second half
+		 * of the accept is not yet completed.
+		 */
+		spin_lock(&scif_info.eplock);
+		list_add_tail(&((*ep)->miacceptlist), &scif_info.uaccept);
+		list_add_tail(&((*ep)->liacceptlist), &priv->li_accept);
+		(*ep)->listenep = priv;
+		priv->acceptcnt++;
+		spin_unlock(&scif_info.eplock);
+
+		return 0;
+	}
+	case SCIF_ACCEPTREG:
+	{
+		struct scif_endpt *priv = f->private_data;
+		struct scif_endpt *newep;
+		struct scif_endpt *lisep;
+		struct scif_endpt *fep = NULL;
+		struct scif_endpt *tmpep;
+		struct list_head *pos, *tmpq;
+
+		/* Finally replace the pointer to the accepted endpoint */
+		if (copy_from_user(&newep, argp, sizeof(void *)))
+			return -EFAULT;
+
+		/* Remove form the user accept queue */
+		spin_lock(&scif_info.eplock);
+		list_for_each_safe(pos, tmpq, &scif_info.uaccept) {
+			tmpep = list_entry(pos,
+					   struct scif_endpt, miacceptlist);
+			if (tmpep == newep) {
+				list_del(pos);
+				fep = tmpep;
+				break;
+			}
+		}
+
+		if (!fep) {
+			spin_unlock(&scif_info.eplock);
+			return -ENOENT;
+		}
+
+		lisep = newep->listenep;
+		list_for_each_safe(pos, tmpq, &lisep->li_accept) {
+			tmpep = list_entry(pos,
+					   struct scif_endpt, liacceptlist);
+			if (tmpep == newep) {
+				list_del(pos);
+				lisep->acceptcnt--;
+				break;
+			}
+		}
+
+		spin_unlock(&scif_info.eplock);
+
+		/* Free the resources automatically created from the open. */
+		scif_teardown_ep(priv);
+		scif_add_epd_to_zombie_list(priv, !SCIF_EPLOCK_HELD);
+		f->private_data = newep;
+		return 0;
+	}
 	}
 	return -EINVAL;
 }
diff --git a/drivers/misc/mic/scif/scif_main.c b/drivers/misc/mic/scif/scif_main.c
index b81ad4d..d834552 100644
--- a/drivers/misc/mic/scif/scif_main.c
+++ b/drivers/misc/mic/scif/scif_main.c
@@ -334,6 +334,7 @@ static int _scif_init(void)
 	scif_info.en_msg_log = 0;
 	scif_info.p2p_enable = 1;
 	INIT_WORK(&scif_info.misc_work, scif_misc_handler);
+	INIT_WORK(&scif_info.conn_work, scif_conn_handler);
 	idr_init(&scif_ports);
 	return 0;
 }
diff --git a/drivers/misc/mic/scif/scif_nm.c b/drivers/misc/mic/scif/scif_nm.c
index 0c612db..f28b74a 100644
--- a/drivers/misc/mic/scif/scif_nm.c
+++ b/drivers/misc/mic/scif/scif_nm.c
@@ -20,6 +20,41 @@
 #include "scif_main.h"
 #include "scif_map.h"
 
+/**
+ * scif_invalidate_ep() - Set state for all connected endpoints
+ * to disconnected and wake up all send/recv waitqueues
+ */
+static void scif_invalidate_ep(int node)
+{
+	struct scif_endpt *ep;
+	struct list_head *pos, *tmpq;
+
+	flush_work(&scif_info.conn_work);
+	mutex_lock(&scif_info.connlock);
+	list_for_each_safe(pos, tmpq, &scif_info.disconnected) {
+		ep = list_entry(pos, struct scif_endpt, list);
+		if (ep->remote_dev->node == node) {
+			spin_lock(&ep->lock);
+			scif_cleanup_ep_qp(ep);
+			spin_unlock(&ep->lock);
+		}
+	}
+	list_for_each_safe(pos, tmpq, &scif_info.connected) {
+		ep = list_entry(pos, struct scif_endpt, list);
+		if (ep->remote_dev->node == node) {
+			list_del(pos);
+			spin_lock(&ep->lock);
+			ep->state = SCIFEP_DISCONNECTED;
+			list_add_tail(&ep->list, &scif_info.disconnected);
+			scif_cleanup_ep_qp(ep);
+			wake_up_interruptible(&ep->sendwq);
+			wake_up_interruptible(&ep->recvwq);
+			spin_unlock(&ep->lock);
+		}
+	}
+	mutex_unlock(&scif_info.connlock);
+}
+
 void scif_free_qp(struct scif_dev *scifdev)
 {
 	struct scif_qp *qp = scifdev->qpairs;
@@ -91,6 +126,7 @@ void scif_cleanup_scifdev(struct scif_dev *dev)
 		scif_destroy_intr_wq(dev);
 	}
 	scif_destroy_p2p(dev);
+	scif_invalidate_ep(dev->node);
 	scif_send_acks(dev);
 	scif_cleanup_qp(dev);
 }
diff --git a/drivers/misc/mic/scif/scif_nodeqp.c b/drivers/misc/mic/scif/scif_nodeqp.c
index 7c72d8f..a51762d0 100644
--- a/drivers/misc/mic/scif/scif_nodeqp.c
+++ b/drivers/misc/mic/scif/scif_nodeqp.c
@@ -580,7 +580,14 @@ static char *message_types[] = {"BAD",
 				"SCIF_NODE_ADD_ACK",
 				"SCIF_NODE_ADD_NACK",
 				"REMOVE_NODE",
-				"REMOVE_NODE_ACK"};
+				"REMOVE_NODE_ACK",
+				"CNCT_REQ",
+				"CNCT_GNT",
+				"CNCT_GNTACK",
+				"CNCT_GNTNACK",
+				"CNCT_REJ",
+				"DISCNCT",
+				"DISCNT_ACK"};
 
 static void
 scif_display_message(struct scif_dev *scifdev, struct scifmsg *msg,
@@ -956,6 +963,13 @@ static void (*scif_intr_func[SCIF_MAX_MSG + 1])
 	scif_node_add_nack,	/* SCIF_NODE_ADD_NACK */
 	scif_node_remove,	/* SCIF_NODE_REMOVE */
 	scif_node_remove_ack,	/* SCIF_NODE_REMOVE_ACK */
+	scif_cnctreq,		/* SCIF_CNCT_REQ */
+	scif_cnctgnt,		/* SCIF_CNCT_GNT */
+	scif_cnctgnt_ack,	/* SCIF_CNCT_GNTACK */
+	scif_cnctgnt_nack,	/* SCIF_CNCT_GNTNACK */
+	scif_cnctrej,		/* SCIF_CNCT_REJ */
+	scif_discnct,		/* SCIF_DISCNCT */
+	scif_discnt_ack,	/* SCIF_DISCNT_ACK */
 };
 
 /**
-- 
1.8.2.1

