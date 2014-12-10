Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbaLJTwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:52:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:57532 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932894AbaLJTtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770554"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 08/13] misc: mic: SCIF open close bind and listen APIs
Date: Wed, 10 Dec 2014 11:47:48 -0800
Message-Id: <ca817c51aa5d24603d9a1a49199021e093c3b843.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCIF character device file operations and kernel APIs for opening and
closing a user and kernel mode SCIF endpoint. This patch also enables
binding to a SCIF port and listening for incoming SCIF connections.

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/Kconfig            |  19 ++
 drivers/misc/mic/Makefile           |   1 +
 drivers/misc/mic/scif/Makefile      |  15 ++
 drivers/misc/mic/scif/scif_epd.h    | 148 +++++++++++++
 drivers/misc/mic/scif/scif_main.h   |   2 +
 drivers/misc/mic/scif/scif_nodeqp.h |  12 +-
 drivers/misc/mic/scif/scif_api.c    | 417 ++++++++++++++++++++++++++++++++++++
 drivers/misc/mic/scif/scif_epd.c    |  92 ++++++++
 drivers/misc/mic/scif/scif_fd.c     | 104 +++++++++
 drivers/misc/mic/scif/scif_ports.c  | 124 +++++++++++
 10 files changed, 933 insertions(+), 1 deletion(-)
 create mode 100644 drivers/misc/mic/scif/Makefile
 create mode 100644 drivers/misc/mic/scif/scif_epd.h
 create mode 100644 drivers/misc/mic/scif/scif_api.c
 create mode 100644 drivers/misc/mic/scif/scif_epd.c
 create mode 100644 drivers/misc/mic/scif/scif_fd.c
 create mode 100644 drivers/misc/mic/scif/scif_ports.c

diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
index afc9f53..bcf6e36 100644
--- a/drivers/misc/mic/Kconfig
+++ b/drivers/misc/mic/Kconfig
@@ -69,3 +69,22 @@ config INTEL_MIC_CARD
 
 	  For more information see
 	  <http://software.intel.com/en-us/mic-developer>.
+
+comment "SCIF Driver"
+
+config SCIF
+	tristate "SCIF Driver"
+	depends on 64BIT && PCI && X86 && SCIF_BUS
+	help
+	  This enables SCIF Driver support for the Intel Many Integrated
+	  Core (MIC) family of PCIe form factor coprocessor devices that
+	  run a 64 bit Linux OS. The Symmetric Communication Interface
+	  (SCIF (pronounced as skiff)) is a low level communications API
+	  across PCIe currently implemented for MIC.
+
+	  If you are building a host kernel with an Intel MIC device then
+	  say M (recommended) or Y, else say N. If unsure say N.
+
+	  More information about the Intel MIC family as well as the Linux
+	  OS and tools for MIC to use with this driver are available from
+	  <http://software.intel.com/en-us/mic-developer>.
diff --git a/drivers/misc/mic/Makefile b/drivers/misc/mic/Makefile
index 6bc6083..a74042c 100644
--- a/drivers/misc/mic/Makefile
+++ b/drivers/misc/mic/Makefile
@@ -5,3 +5,4 @@
 obj-$(CONFIG_INTEL_MIC_HOST) += host/
 obj-$(CONFIG_INTEL_MIC_CARD) += card/
 obj-y += bus/
+obj-$(CONFIG_SCIF) += scif/
diff --git a/drivers/misc/mic/scif/Makefile b/drivers/misc/mic/scif/Makefile
new file mode 100644
index 0000000..bf10bb7
--- /dev/null
+++ b/drivers/misc/mic/scif/Makefile
@@ -0,0 +1,15 @@
+#
+# Makefile - SCIF driver.
+# Copyright(c) 2014, Intel Corporation.
+#
+obj-$(CONFIG_SCIF) += scif.o
+scif-objs := scif_main.o
+scif-objs += scif_peer_bus.o
+scif-objs += scif_ports.o
+scif-objs += scif_debugfs.o
+scif-objs += scif_fd.o
+scif-objs += scif_api.o
+scif-objs += scif_epd.o
+scif-objs += scif_rb.o
+scif-objs += scif_nodeqp.o
+scif-objs += scif_nm.o
diff --git a/drivers/misc/mic/scif/scif_epd.h b/drivers/misc/mic/scif/scif_epd.h
new file mode 100644
index 0000000..b973b99
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_epd.h
@@ -0,0 +1,148 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ *
+ */
+#ifndef SCIF_EPD_H
+#define SCIF_EPD_H
+
+#include <linux/delay.h>
+#include <linux/scif.h>
+#include <linux/scif_ioctl.h>
+
+#define SCIF_EPLOCK_HELD true
+
+enum scif_epd_state {
+	SCIFEP_UNBOUND,
+	SCIFEP_BOUND,
+	SCIFEP_LISTENING,
+	SCIFEP_CONNECTED,
+	SCIFEP_CONNECTING,
+	SCIFEP_MAPPING,
+	SCIFEP_CLOSING,
+	SCIFEP_CLLISTEN,
+	SCIFEP_DISCONNECTED,
+	SCIFEP_ZOMBIE
+};
+
+/*
+ * struct scif_conreq - Data structure added to the connection list.
+ *
+ * @msg: connection request message received
+ * @list: link to list of connection requests
+ */
+struct scif_conreq {
+	struct scifmsg msg;
+	struct list_head list;
+};
+
+/* Size of the RB for the Endpoint QP */
+#define SCIF_ENDPT_QP_SIZE 0x1000
+
+/*
+ * scif_endpt_qp_info - SCIF endpoint queue pair
+ *
+ * @qp - Qpair for this endpoint
+ * @qp_offset - DMA address of the QP
+ * @gnt_pld - Payload in a SCIF_CNCT_GNT message containing the
+ * physical address of the remote_qp.
+ */
+struct scif_endpt_qp_info {
+	struct scif_qp *qp;
+	dma_addr_t qp_offset;
+	dma_addr_t gnt_pld;
+};
+
+/*
+ * struct scif_endpt - The SCIF endpoint data structure
+ *
+ * @state: end point state
+ * @lock: lock synchronizing access to endpoint fields like state etc
+ * @port: self port information
+ * @peer: peer port information
+ * @backlog: maximum pending connection requests
+ * @qp_info: Endpoint QP information for SCIF messaging
+ * @remote_dev: scifdev used by this endpt to communicate with remote node.
+ * @remote_ep: remote endpoint
+ * @conreqcnt: Keep track of number of connection requests.
+ * @files: Open file information used to match the id passed in with
+ *         the flush routine.
+ * @conlist: list of connection requests
+ * @conwq: waitqueue for connection processing
+ * @discon: completion used during disconnection
+ * @sendwq: waitqueue used during sending messages
+ * @recvwq: waitqueue used during message receipt
+ * @sendlock: Synchronize ordering of messages sent
+ * @recvlock: Synchronize ordering of messages received
+ * @list: link to list of various endpoints like connected, listening etc
+ * @li_accept: pending ACCEPTREG
+ * @acceptcnt: pending ACCEPTREG cnt
+ * @liacceptlist: link to listen accept
+ * @miacceptlist: link to uaccept
+ * @listenep: associated listen ep
+ * @conn_work: Non blocking connect work
+ * @conn_port: Connection port
+ * @conn_err: Errors during connection
+ * @conn_async_state: Async connection
+ * @conn_list: List of async connection requests
+ */
+struct scif_endpt {
+	enum scif_epd_state state;
+	spinlock_t lock;
+	struct scif_port_id port;
+	struct scif_port_id peer;
+	int backlog;
+	struct scif_endpt_qp_info qp_info;
+	struct scif_dev *remote_dev;
+	u64 remote_ep;
+	int conreqcnt;
+	struct files_struct *files;
+	struct list_head conlist;
+	wait_queue_head_t conwq;
+	struct completion discon;
+	wait_queue_head_t sendwq;
+	wait_queue_head_t recvwq;
+	struct mutex sendlock;
+	struct mutex recvlock;
+	struct list_head list;
+	struct list_head li_accept;
+	int acceptcnt;
+	struct list_head liacceptlist;
+	struct list_head miacceptlist;
+	struct scif_endpt *listenep;
+	struct scif_port_id conn_port;
+	int conn_err;
+	int conn_async_state;
+	struct list_head conn_list;
+};
+
+static inline int scifdev_alive(struct scif_endpt *ep)
+{
+	return _scifdev_alive(ep->remote_dev);
+}
+
+void scif_cleanup_zombie_epd(void);
+void scif_teardown_ep(void *endpt);
+void scif_cleanup_ep_qp(struct scif_endpt *ep);
+void scif_add_epd_to_zombie_list(struct scif_endpt *ep, bool eplock_held);
+void scif_get_node_info(void);
+void scif_send_acks(struct scif_dev *dev);
+void scif_conn_handler(struct work_struct *work);
+int scif_rsrv_port(u16 port);
+void scif_get_port(u16 port);
+int scif_get_new_port(void);
+void scif_put_port(u16 port);
+int __scif_flush(scif_epd_t epd);
+#endif /* SCIF_EPD_H */
diff --git a/drivers/misc/mic/scif/scif_main.h b/drivers/misc/mic/scif/scif_main.h
index 861439e..591cf4a 100644
--- a/drivers/misc/mic/scif/scif_main.h
+++ b/drivers/misc/mic/scif/scif_main.h
@@ -234,6 +234,8 @@ static inline int _scifdev_alive(struct scif_dev *scifdev)
 	return !!spdev;
 }
 
+#include "scif_epd.h"
+
 void __init scif_init_debugfs(void);
 void scif_exit_debugfs(void);
 int scif_setup_intr_wq(struct scif_dev *scifdev);
diff --git a/drivers/misc/mic/scif/scif_nodeqp.h b/drivers/misc/mic/scif/scif_nodeqp.h
index 4d8f53c..9540233 100644
--- a/drivers/misc/mic/scif/scif_nodeqp.h
+++ b/drivers/misc/mic/scif/scif_nodeqp.h
@@ -64,7 +64,17 @@
 #define SCIF_NODE_ADD_NACK 6 /* SCIF_NODE_ADD failed */
 #define SCIF_NODE_REMOVE 7 /* Request to deactivate a SCIF node */
 #define SCIF_NODE_REMOVE_ACK 8 /* Response to a SCIF_NODE_REMOVE message */
-#define SCIF_MAX_MSG SCIF_NODE_REMOVE_ACK
+#define SCIF_CNCT_REQ 9  /* Phys addr of Request connection to a port */
+#define SCIF_CNCT_GNT 10  /* Phys addr of new Grant connection request */
+#define SCIF_CNCT_GNTACK 11  /* Error type Reject a connection request */
+#define SCIF_CNCT_GNTNACK 12  /* Error type Reject a connection request */
+#define SCIF_CNCT_REJ 13  /* Error type Reject a connection request */
+#define SCIF_DISCNCT 14 /* Notify peer that connection is being terminated */
+#define SCIF_DISCNT_ACK 15 /* Notify peer that connection is being terminated */
+#define SCIF_CLIENT_SENT 16 /* Notify the peer that data has been written */
+#define SCIF_CLIENT_RCVD 17 /* Notify the peer that data has been read */
+#define SCIF_GET_NODE_INFO 18 /* Get current node mask from the mgmt node*/
+#define SCIF_MAX_MSG SCIF_GET_NODE_INFO
 
 /*
  * struct scifmsg - Node QP message format
diff --git a/drivers/misc/mic/scif/scif_api.c b/drivers/misc/mic/scif/scif_api.c
new file mode 100644
index 0000000..d5f10f3
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_api.c
@@ -0,0 +1,417 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ *
+ */
+#include <linux/scif.h>
+#include "scif_main.h"
+#include "scif_map.h"
+
+static const char * const scif_ep_states[] = {
+	"Unbound",
+	"Bound",
+	"Listening",
+	"Connected",
+	"Connecting",
+	"Mapping",
+	"Closing",
+	"Close Listening",
+	"Disconnected",
+	"Zombie"};
+
+enum conn_async_state {
+	ASYNC_CONN_IDLE = 1,	/* ep setup for async connect */
+	ASYNC_CONN_INPROGRESS,	/* async connect in progress */
+	ASYNC_CONN_FLUSH_WORK	/* async work flush in progress  */
+};
+
+scif_epd_t scif_open(void)
+{
+	struct scif_endpt *ep;
+
+	might_sleep();
+	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	if (!ep)
+		goto err_ep_alloc;
+
+	ep->qp_info.qp = kzalloc(sizeof(*ep->qp_info.qp), GFP_KERNEL);
+	if (!ep->qp_info.qp)
+		goto err_qp_alloc;
+
+	spin_lock_init(&ep->lock);
+	mutex_init(&ep->sendlock);
+	mutex_init(&ep->recvlock);
+
+	ep->state = SCIFEP_UNBOUND;
+	pr_debug("SCIFAPI open: ep %p success\n", ep);
+	return ep;
+
+err_qp_alloc:
+	kfree(ep);
+err_ep_alloc:
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(scif_open);
+
+/*
+ * scif_disconnect_ep - Disconnects the endpoint if found
+ * @epd: The end point returned from scif_open()
+ */
+static struct scif_endpt *scif_disconnect_ep(struct scif_endpt *ep)
+{
+	struct scifmsg msg;
+	struct scif_endpt *fep = NULL;
+	struct scif_endpt *tmpep;
+	struct list_head *pos, *tmpq;
+	int err;
+
+	/*
+	 * Wake up any threads blocked in send()/recv() before closing
+	 * out the connection. Grabbing and releasing the send/recv lock
+	 * will ensure that any blocked senders/receivers have exited for
+	 * Ring 0 endpoints. It is a Ring 0 bug to call send/recv after
+	 * close. Ring 3 endpoints are not affected since close will not
+	 * be called while there are IOCTLs executing.
+	 */
+	wake_up_interruptible(&ep->sendwq);
+	wake_up_interruptible(&ep->recvwq);
+	mutex_lock(&ep->sendlock);
+	mutex_unlock(&ep->sendlock);
+	mutex_lock(&ep->recvlock);
+	mutex_unlock(&ep->recvlock);
+
+	/* Remove from the connected list */
+	mutex_lock(&scif_info.connlock);
+	list_for_each_safe(pos, tmpq, &scif_info.connected) {
+		tmpep = list_entry(pos, struct scif_endpt, list);
+		if (tmpep == ep) {
+			list_del(pos);
+			fep = tmpep;
+			spin_lock(&ep->lock);
+			break;
+		}
+	}
+
+	if (!fep) {
+		/*
+		 * The other side has completed the disconnect before
+		 * the end point can be removed from the list. Therefore
+		 * the ep lock is not locked, traverse the disconnected
+		 * list to find the endpoint and release the conn lock.
+		 */
+		list_for_each_safe(pos, tmpq, &scif_info.disconnected) {
+			tmpep = list_entry(pos, struct scif_endpt, list);
+			if (tmpep == ep) {
+				list_del(pos);
+				break;
+			}
+		}
+		mutex_unlock(&scif_info.connlock);
+		return NULL;
+	}
+
+	init_completion(&ep->discon);
+	msg.uop = SCIF_DISCNCT;
+	msg.src = ep->port;
+	msg.dst = ep->peer;
+	msg.payload[0] = (u64)ep;
+	msg.payload[1] = ep->remote_ep;
+
+	err = scif_nodeqp_send(ep->remote_dev, &msg);
+	spin_unlock(&ep->lock);
+	mutex_unlock(&scif_info.connlock);
+
+	if (!err)
+		/* Wait for the remote node to respond with SCIF_DISCNT_ACK */
+		wait_for_completion_timeout(&ep->discon,
+					    SCIF_NODE_ALIVE_TIMEOUT);
+	return ep;
+}
+
+int scif_close(scif_epd_t epd)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	struct scif_endpt *tmpep;
+	struct list_head *pos, *tmpq;
+	enum scif_epd_state oldstate;
+	bool flush_conn;
+
+	pr_debug("SCIFAPI close: ep %p %s\n", ep, scif_ep_states[ep->state]);
+
+	might_sleep();
+
+	spin_lock(&ep->lock);
+	flush_conn = (ep->conn_async_state == ASYNC_CONN_INPROGRESS);
+	spin_unlock(&ep->lock);
+
+	if (flush_conn)
+		flush_work(&scif_info.conn_work);
+
+	spin_lock(&ep->lock);
+	oldstate = ep->state;
+
+	ep->state = SCIFEP_CLOSING;
+
+	switch (oldstate) {
+	case SCIFEP_ZOMBIE:
+	case SCIFEP_DISCONNECTED:
+		spin_unlock(&ep->lock);
+		/* Remove from the disconnected list */
+		mutex_lock(&scif_info.connlock);
+		list_for_each_safe(pos, tmpq, &scif_info.disconnected) {
+			tmpep = list_entry(pos, struct scif_endpt, list);
+			if (tmpep == ep) {
+				list_del(pos);
+				break;
+			}
+		}
+		mutex_unlock(&scif_info.connlock);
+		break;
+	case SCIFEP_UNBOUND:
+	case SCIFEP_BOUND:
+	case SCIFEP_CONNECTING:
+		spin_unlock(&ep->lock);
+		break;
+	case SCIFEP_MAPPING:
+	case SCIFEP_CONNECTED:
+	case SCIFEP_CLOSING:
+	{
+		spin_unlock(&ep->lock);
+		scif_disconnect_ep(ep);
+		break;
+	}
+	case SCIFEP_LISTENING:
+	case SCIFEP_CLLISTEN:
+	{
+		struct scif_conreq *conreq;
+		struct scifmsg msg;
+		struct scif_endpt *aep;
+
+		spin_unlock(&ep->lock);
+		spin_lock(&scif_info.eplock);
+
+		/* remove from listen list */
+		list_for_each_safe(pos, tmpq, &scif_info.listen) {
+			tmpep = list_entry(pos, struct scif_endpt, list);
+			if (tmpep == ep)
+				list_del(pos);
+		}
+		/* Remove any dangling accepts */
+		while (ep->acceptcnt) {
+			aep = list_first_entry(&ep->li_accept,
+					       struct scif_endpt, liacceptlist);
+			list_del(&aep->liacceptlist);
+			scif_put_port(aep->port.port);
+			list_for_each_safe(pos, tmpq, &scif_info.uaccept) {
+				tmpep = list_entry(pos, struct scif_endpt,
+						   miacceptlist);
+				if (tmpep == aep) {
+					list_del(pos);
+					break;
+				}
+			}
+			spin_unlock(&scif_info.eplock);
+			mutex_lock(&scif_info.connlock);
+			list_for_each_safe(pos, tmpq, &scif_info.connected) {
+				tmpep = list_entry(pos,
+						   struct scif_endpt, list);
+				if (tmpep == aep) {
+					list_del(pos);
+					break;
+				}
+			}
+			list_for_each_safe(pos, tmpq, &scif_info.disconnected) {
+				tmpep = list_entry(pos,
+						   struct scif_endpt, list);
+				if (tmpep == aep) {
+					list_del(pos);
+					break;
+				}
+			}
+			mutex_unlock(&scif_info.connlock);
+			scif_teardown_ep(aep);
+			spin_lock(&scif_info.eplock);
+			scif_add_epd_to_zombie_list(aep, SCIF_EPLOCK_HELD);
+			ep->acceptcnt--;
+		}
+
+		spin_lock(&ep->lock);
+		spin_unlock(&scif_info.eplock);
+
+		/* Remove and reject any pending connection requests. */
+		while (ep->conreqcnt) {
+			conreq = list_first_entry(&ep->conlist,
+						  struct scif_conreq, list);
+			list_del(&conreq->list);
+
+			msg.uop = SCIF_CNCT_REJ;
+			msg.dst.node = conreq->msg.src.node;
+			msg.dst.port = conreq->msg.src.port;
+			msg.payload[0] = conreq->msg.payload[0];
+			msg.payload[1] = conreq->msg.payload[1];
+			/*
+			 * No Error Handling on purpose for scif_nodeqp_send().
+			 * If the remote node is lost we still want free the
+			 * connection requests on the self node.
+			 */
+			scif_nodeqp_send(&scif_dev[conreq->msg.src.node],
+					 &msg);
+			ep->conreqcnt--;
+			kfree(conreq);
+		}
+
+		spin_unlock(&ep->lock);
+		/* If a kSCIF accept is waiting wake it up */
+		wake_up_interruptible(&ep->conwq);
+		break;
+	}
+	}
+	scif_put_port(ep->port.port);
+	scif_teardown_ep(ep);
+	scif_add_epd_to_zombie_list(ep, !SCIF_EPLOCK_HELD);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scif_close);
+
+/**
+ * scif_flush() - Wakes up any blocking accepts. The endpoint will no longer
+ *			accept new connections.
+ * @epd: The end point returned from scif_open()
+ */
+int __scif_flush(scif_epd_t epd)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+
+	switch (ep->state) {
+	case SCIFEP_LISTENING:
+	{
+		ep->state = SCIFEP_CLLISTEN;
+
+		/* If an accept is waiting wake it up */
+		wake_up_interruptible(&ep->conwq);
+		break;
+	}
+	default:
+		break;
+	}
+	return 0;
+}
+
+int scif_bind(scif_epd_t epd, u16 pn)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+	int ret = 0;
+	int tmp;
+
+	pr_debug("SCIFAPI bind: ep %p %s requested port number %d\n",
+		 ep, scif_ep_states[ep->state], pn);
+
+	if (pn) {
+		/*
+		 * Similar to IETF RFC 1700, SCIF ports below
+		 * SCIF_ADMIN_PORT_END can only be bound by system (or root)
+		 * processes or by processes executed by privileged users.
+		 */
+		if (pn < SCIF_ADMIN_PORT_END && !capable(CAP_SYS_ADMIN)) {
+			ret = -EACCES;
+			goto scif_bind_admin_exit;
+		}
+	}
+
+	spin_lock(&ep->lock);
+	if (ep->state == SCIFEP_BOUND) {
+		ret = -EINVAL;
+		goto scif_bind_exit;
+	} else if (ep->state != SCIFEP_UNBOUND) {
+		ret = -EISCONN;
+		goto scif_bind_exit;
+	}
+
+	if (pn) {
+		tmp = scif_rsrv_port(pn);
+		if (tmp != pn) {
+			ret = -EINVAL;
+			goto scif_bind_exit;
+		}
+	} else {
+		pn = scif_get_new_port();
+		if (!pn) {
+			ret = -ENOSPC;
+			goto scif_bind_exit;
+		}
+	}
+
+	ep->state = SCIFEP_BOUND;
+	ep->port.node = scif_info.nodeid;
+	ep->port.port = pn;
+	ep->conn_async_state = ASYNC_CONN_IDLE;
+	ret = pn;
+	pr_debug("SCIFAPI bind: bound to port number %d\n", pn);
+
+scif_bind_exit:
+	spin_unlock(&ep->lock);
+scif_bind_admin_exit:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(scif_bind);
+
+int scif_listen(scif_epd_t epd, int backlog)
+{
+	struct scif_endpt *ep = (struct scif_endpt *)epd;
+
+	pr_debug("SCIFAPI listen: ep %p %s\n", ep, scif_ep_states[ep->state]);
+
+	spin_lock(&ep->lock);
+	switch (ep->state) {
+	case SCIFEP_ZOMBIE:
+	case SCIFEP_CLOSING:
+	case SCIFEP_CLLISTEN:
+	case SCIFEP_UNBOUND:
+	case SCIFEP_DISCONNECTED:
+		spin_unlock(&ep->lock);
+		return -EINVAL;
+	case SCIFEP_LISTENING:
+	case SCIFEP_CONNECTED:
+	case SCIFEP_CONNECTING:
+	case SCIFEP_MAPPING:
+		spin_unlock(&ep->lock);
+		return -EISCONN;
+	case SCIFEP_BOUND:
+		break;
+	}
+
+	ep->state = SCIFEP_LISTENING;
+	ep->backlog = backlog;
+
+	ep->conreqcnt = 0;
+	ep->acceptcnt = 0;
+	INIT_LIST_HEAD(&ep->conlist);
+	init_waitqueue_head(&ep->conwq);
+	INIT_LIST_HEAD(&ep->li_accept);
+	spin_unlock(&ep->lock);
+
+	/*
+	 * Listen status is complete so delete the qp information not needed
+	 * on a listen before placing on the list of listening ep's
+	 */
+	scif_teardown_ep(ep);
+	ep->qp_info.qp = NULL;
+
+	spin_lock(&scif_info.eplock);
+	list_add_tail(&ep->list, &scif_info.listen);
+	spin_unlock(&scif_info.eplock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scif_listen);
diff --git a/drivers/misc/mic/scif/scif_epd.c b/drivers/misc/mic/scif/scif_epd.c
new file mode 100644
index 0000000..a2b728a
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_epd.c
@@ -0,0 +1,92 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ *
+ */
+#include "scif_main.h"
+#include "scif_map.h"
+
+void scif_cleanup_ep_qp(struct scif_endpt *ep)
+{
+	struct scif_qp *qp = ep->qp_info.qp;
+
+	if (qp->outbound_q.rb_base) {
+		scif_iounmap((void *)qp->outbound_q.rb_base,
+			     qp->outbound_q.size, ep->remote_dev);
+		qp->outbound_q.rb_base = NULL;
+	}
+	if (qp->remote_qp) {
+		scif_iounmap((void *)qp->remote_qp,
+			     sizeof(struct scif_qp), ep->remote_dev);
+		qp->remote_qp = NULL;
+	}
+	if (qp->local_qp) {
+		scif_unmap_single(qp->local_qp, ep->remote_dev,
+				  sizeof(struct scif_qp));
+		qp->local_qp = 0x0;
+	}
+	if (qp->local_buf) {
+		scif_unmap_single(qp->local_buf, ep->remote_dev,
+				  SCIF_ENDPT_QP_SIZE);
+		qp->local_buf = 0;
+	}
+}
+
+void scif_teardown_ep(void *endpt)
+{
+	struct scif_endpt *ep = endpt;
+	struct scif_qp *qp = ep->qp_info.qp;
+
+	if (qp) {
+		spin_lock(&ep->lock);
+		scif_cleanup_ep_qp(ep);
+		spin_unlock(&ep->lock);
+		kfree(qp->inbound_q.rb_base);
+		kfree(qp);
+	}
+}
+
+/*
+ * Enqueue the endpoint to the zombie list for cleanup.
+ * The endpoint should not be accessed once this API returns.
+ */
+void scif_add_epd_to_zombie_list(struct scif_endpt *ep, bool eplock_held)
+{
+	if (!eplock_held)
+		spin_lock(&scif_info.eplock);
+	spin_lock(&ep->lock);
+	ep->state = SCIFEP_ZOMBIE;
+	spin_unlock(&ep->lock);
+	list_add_tail(&ep->list, &scif_info.zombie);
+	scif_info.nr_zombies++;
+	if (!eplock_held)
+		spin_unlock(&scif_info.eplock);
+	schedule_work(&scif_info.misc_work);
+}
+
+void scif_cleanup_zombie_epd(void)
+{
+	struct list_head *pos, *tmpq;
+	struct scif_endpt *ep;
+
+	spin_lock(&scif_info.eplock);
+	list_for_each_safe(pos, tmpq, &scif_info.zombie) {
+		ep = list_entry(pos, struct scif_endpt, list);
+		list_del(pos);
+		scif_info.nr_zombies--;
+		kfree(ep);
+	}
+	spin_unlock(&scif_info.eplock);
+}
diff --git a/drivers/misc/mic/scif/scif_fd.c b/drivers/misc/mic/scif/scif_fd.c
new file mode 100644
index 0000000..d81ab7c
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_fd.c
@@ -0,0 +1,104 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ *
+ */
+#include "scif_main.h"
+
+static int scif_fdopen(struct inode *inode, struct file *f)
+{
+	struct scif_endpt *priv = scif_open();
+
+	if (!priv)
+		return -ENOMEM;
+	f->private_data = priv;
+	return 0;
+}
+
+static int scif_fdclose(struct inode *inode, struct file *f)
+{
+	struct scif_endpt *priv = f->private_data;
+
+	return scif_close(priv);
+}
+
+static int scif_fdflush(struct file *f, fl_owner_t id)
+{
+	struct scif_endpt *ep = f->private_data;
+
+	spin_lock(&ep->lock);
+	/*
+	 * The listening endpoint stashes the open file information before
+	 * waiting for incoming connections. The release callback would never be
+	 * called if the application closed the endpoint, while waiting for
+	 * incoming connections from a separate thread since the file descriptor
+	 * reference count is bumped up in the accept IOCTL. Call the flush
+	 * routine if the id matches the endpoint open file information so that
+	 * the listening endpoint can be woken up and the fd released.
+	 */
+	if (ep->files == id)
+		__scif_flush(ep);
+	spin_unlock(&ep->lock);
+	return 0;
+}
+
+static __always_inline void scif_err_debug(int err, const char *str)
+{
+	/*
+	 * ENOTCONN is a common uninteresting error which is
+	 * flooding debug messages to the console unnecessarily.
+	 */
+	if (err < 0 && err != -ENOTCONN)
+		pr_debug("%s err %d\n", str, err);
+}
+
+static long scif_fdioctl(struct file *f, unsigned int cmd, unsigned long arg)
+{
+	struct scif_endpt *priv = f->private_data;
+	void __user *argp = (void __user *)arg;
+	bool non_block = false;
+
+	non_block = !!(f->f_flags & O_NONBLOCK);
+
+	switch (cmd) {
+	case SCIF_BIND:
+	{
+		int pn;
+
+		if (copy_from_user(&pn, argp, sizeof(pn)))
+			return -EFAULT;
+
+		pn = scif_bind(priv, pn);
+		if (pn < 0)
+			return pn;
+
+		if (copy_to_user(argp, &pn, sizeof(pn)))
+			return -EFAULT;
+
+		return 0;
+	}
+	case SCIF_LISTEN:
+		return scif_listen(priv, arg);
+	}
+	return -EINVAL;
+}
+
+const struct file_operations scif_fops = {
+	.open = scif_fdopen,
+	.release = scif_fdclose,
+	.unlocked_ioctl = scif_fdioctl,
+	.flush = scif_fdflush,
+	.owner = THIS_MODULE,
+};
diff --git a/drivers/misc/mic/scif/scif_ports.c b/drivers/misc/mic/scif/scif_ports.c
new file mode 100644
index 0000000..594e18d
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_ports.c
@@ -0,0 +1,124 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * Intel SCIF driver.
+ *
+ */
+#include <linux/idr.h>
+
+#include "scif_main.h"
+
+#define SCIF_PORT_COUNT	0x10000	/* Ports available */
+
+struct idr scif_ports;
+
+/*
+ * struct scif_port - SCIF port information
+ *
+ * @ref_cnt - Reference count since there can be multiple endpoints
+ *		created via scif_accept(..) simultaneously using a port.
+ */
+struct scif_port {
+	int ref_cnt;
+};
+
+/**
+ * __scif_get_port - Reserve a specified port # for SCIF and add it
+ * to the global list.
+ * @port : port # to be reserved.
+ *
+ * @return : Allocated SCIF port #, or -ENOSPC if port unavailable.
+ *		On memory allocation failure, returns -ENOMEM.
+ */
+static int __scif_get_port(int start, int end)
+{
+	int id;
+	struct scif_port *port = kzalloc(sizeof(*port), GFP_ATOMIC);
+
+	if (!port)
+		return -ENOMEM;
+	spin_lock(&scif_info.port_lock);
+	id = idr_alloc(&scif_ports, port, start, end, GFP_ATOMIC);
+	if (id >= 0)
+		port->ref_cnt++;
+	spin_unlock(&scif_info.port_lock);
+	return id;
+}
+
+/**
+ * scif_rsrv_port - Reserve a specified port # for SCIF.
+ * @port : port # to be reserved.
+ *
+ * @return : Allocated SCIF port #, or -ENOSPC if port unavailable.
+ *		On memory allocation failure, returns -ENOMEM.
+ */
+int scif_rsrv_port(u16 port)
+{
+	return __scif_get_port(port, port + 1);
+}
+
+/**
+ * scif_get_new_port - Get and reserve any port # for SCIF in the range
+ *			SCIF_PORT_RSVD + 1 to SCIF_PORT_COUNT - 1.
+ *
+ * @return : Allocated SCIF port #, or -ENOSPC if no ports available.
+ *		On memory allocation failure, returns -ENOMEM.
+ */
+int scif_get_new_port(void)
+{
+	return __scif_get_port(SCIF_PORT_RSVD + 1, SCIF_PORT_COUNT);
+}
+
+/**
+ * scif_get_port - Increment the reference count for a SCIF port
+ * @id : SCIF port
+ *
+ * @return : None
+ */
+void scif_get_port(u16 id)
+{
+	struct scif_port *port;
+
+	if (!id)
+		return;
+	spin_lock(&scif_info.port_lock);
+	port = idr_find(&scif_ports, id);
+	if (port)
+		port->ref_cnt++;
+	spin_unlock(&scif_info.port_lock);
+}
+
+/**
+ * scif_put_port - Release a reserved SCIF port
+ * @id : SCIF port to be released.
+ *
+ * @return : None
+ */
+void scif_put_port(u16 id)
+{
+	struct scif_port *port;
+
+	if (!id)
+		return;
+	spin_lock(&scif_info.port_lock);
+	port = idr_find(&scif_ports, id);
+	if (port) {
+		port->ref_cnt--;
+		if (!port->ref_cnt) {
+			idr_remove(&scif_ports, id);
+			kfree(port);
+		}
+	}
+	spin_unlock(&scif_info.port_lock);
+}
-- 
1.8.2.1

