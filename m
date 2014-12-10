Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbaLJTwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:52:41 -0500
Received: from mga02.intel.com ([134.134.136.20]:33536 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861AbaLJTtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:49:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,553,1413270000"; 
   d="scan'208";a="621770547"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH char-misc-next 06/13] misc: mic: SCIF module initialization
Date: Wed, 10 Dec 2014 11:47:46 -0800
Message-Id: <ab5c5bcb9183c8b5bc581dd712e94159a433c188.1418237176.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1418237176.git.sudeep.dutt@intel.com>
References: <cover.1418237176.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SCIF module initialization, DMA mapping, ioremap wrapper APIs
and debugfs hooks. SCIF gets probed by the SCIF hardware bus
if SCIF devices were registered by base drivers. A MISC device
is registered to provide the SCIF character device interface.

Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
---
 drivers/misc/mic/scif/scif_main.h    | 248 ++++++++++++++++++++++
 drivers/misc/mic/scif/scif_map.h     | 113 ++++++++++
 drivers/misc/mic/scif/scif_debugfs.c |  82 ++++++++
 drivers/misc/mic/scif/scif_main.c    | 394 +++++++++++++++++++++++++++++++++++
 4 files changed, 837 insertions(+)
 create mode 100644 drivers/misc/mic/scif/scif_main.h
 create mode 100644 drivers/misc/mic/scif/scif_map.h
 create mode 100644 drivers/misc/mic/scif/scif_debugfs.c
 create mode 100644 drivers/misc/mic/scif/scif_main.c

diff --git a/drivers/misc/mic/scif/scif_main.h b/drivers/misc/mic/scif/scif_main.h
new file mode 100644
index 0000000..861439e
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_main.h
@@ -0,0 +1,248 @@
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
+#ifndef SCIF_MAIN_H
+#define SCIF_MAIN_H
+
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/miscdevice.h>
+#include <linux/dmaengine.h>
+#include <linux/file.h>
+#include <linux/scif.h>
+
+#include "../common/mic_dev.h"
+
+#define SCIF_MGMT_NODE 0
+#define SCIF_DEFAULT_WATCHDOG_TO 30
+#define SCIF_NODE_ACCEPT_TIMEOUT (3 * HZ)
+#define SCIF_NODE_ALIVE_TIMEOUT (SCIF_DEFAULT_WATCHDOG_TO * HZ)
+
+/*
+ * Generic state used for certain node QP message exchanges
+ * like Unregister, Alloc etc.
+ */
+enum scif_msg_state {
+	OP_IDLE = 1,
+	OP_IN_PROGRESS,
+	OP_COMPLETED,
+	OP_FAILED
+};
+
+/*
+ * struct scif_info - Global SCIF information
+ *
+ * @nodeid: Node ID this node is to others
+ * @maxid: Max known node ID
+ * @total: Total number of SCIF nodes
+ * @nr_zombies: number of zombie endpoints
+ * @eplock: Lock to synchronize listening, zombie endpoint lists
+ * @connlock: Lock to synchronize connected and disconnected lists
+ * @nb_connect_lock: Synchronize non blocking connect operations
+ * @port_lock: Synchronize access to SCIF ports
+ * @uaccept: List of user acceptreq waiting for acceptreg
+ * @listen: List of listening end points
+ * @zombie: List of zombie end points with pending RMA's
+ * @connected: List of end points in connected state
+ * @disconnected: List of end points in disconnected state
+ * @nb_connect_list: List for non blocking connections
+ * @misc_work: miscellaneous SCIF tasks
+ * @conflock: Lock to synchronize SCIF node configuration changes
+ * @en_msg_log: Enable debug message logging
+ * @p2p_enable: Enable P2P SCIF network
+ * @miscdev: The MISC device
+ * @conn_work: Work for workqueue handling all connections
+ * @exitwq: Wait queue for waiting for an EXIT node QP message response
+ * @loopb_dev: Dummy SCIF device used for loopback
+ * @loopb_wq: Workqueue used for handling loopback messages
+ * @loopb_wqname[16]: Name of loopback workqueue
+ * @loopb_work: Used for submitting work to loopb_wq
+ * @loopb_recv_q: List of messages received on the loopb_wq
+ */
+struct scif_info {
+	u8 nodeid;
+	u8 maxid;
+	u8 total;
+	u32 nr_zombies;
+	spinlock_t eplock;
+	struct mutex connlock;
+	spinlock_t nb_connect_lock;
+	spinlock_t port_lock;
+	struct list_head uaccept;
+	struct list_head listen;
+	struct list_head zombie;
+	struct list_head connected;
+	struct list_head disconnected;
+	struct list_head nb_connect_list;
+	struct work_struct misc_work;
+	struct mutex conflock;
+	u8 en_msg_log;
+	u8 p2p_enable;
+	struct miscdevice miscdev;
+	struct work_struct conn_work;
+	wait_queue_head_t exitwq;
+	struct scif_dev *loopb_dev;
+	struct workqueue_struct *loopb_wq;
+	char loopb_wqname[16];
+	struct work_struct loopb_work;
+	struct list_head loopb_recv_q;
+};
+
+/*
+ * struct scif_p2p_info - SCIF mapping information used for P2P
+ *
+ * @ppi_peer_id - SCIF peer node id
+ * @ppi_sg - Scatter list for bar information (One for mmio and one for aper)
+ * @sg_nentries - Number of entries in the scatterlist
+ * @ppi_da: DMA address for MMIO and APER bars
+ * @ppi_len: Length of MMIO and APER bars
+ * @ppi_list: Link in list of mapping information
+ */
+struct scif_p2p_info {
+	u8 ppi_peer_id;
+	struct scatterlist *ppi_sg[2];
+	u64 sg_nentries[2];
+	dma_addr_t ppi_da[2];
+	u64 ppi_len[2];
+#define SCIF_PPI_MMIO 0
+#define SCIF_PPI_APER 1
+	struct list_head ppi_list;
+};
+
+/*
+ * struct scif_dev - SCIF remote device specific fields
+ *
+ * @node: Node id
+ * @p2p: List of P2P mapping information
+ * @qpairs: The node queue pair for exchanging control messages
+ * @intr_wq: Workqueue for handling Node QP messages
+ * @intr_wqname: Name of node QP workqueue for handling interrupts
+ * @intr_bh: Used for submitting work to intr_wq
+ * @lock: Lock used for synchronizing access to the scif device
+ * @sdev: SCIF hardware device on the SCIF hardware bus
+ * @db: doorbell the peer will trigger to generate an interrupt on self
+ * @rdb: Doorbell to trigger on the peer to generate an interrupt on the peer
+ * @cookie: Cookie received while registering the interrupt handler
+ * @qp_dma_addr: Queue pair DMA address passed to the peer
+ * @p2p_dwork: Delayed work to enable polling for P2P state
+ * @qp_dwork: Delayed work for enabling polling for remote QP information
+ * @p2p_retry: Number of times to retry polling of P2P state
+ * @base_addr: P2P aperture bar base address
+ * @mic_mw mmio: The peer MMIO information used for P2P
+ * @spdev: SCIF peer device on the SCIF peer bus
+ * @node_remove_ack_pending: True if a node_remove_ack is pending
+ * @exit_ack_pending: true if an exit_ack is pending
+ * @disconn_wq: Used while waiting for a node remove response
+ * @disconn_rescnt: Keeps track of number of node remove requests sent
+ * @exit: Status of exit message
+*/
+struct scif_dev {
+	u8 node;
+	struct list_head p2p;
+	struct scif_qp *qpairs;
+	struct workqueue_struct *intr_wq;
+	char intr_wqname[16];
+	struct work_struct intr_bh;
+	struct mutex lock;
+	struct scif_hw_dev *sdev;
+	int db;
+	int rdb;
+	struct mic_irq *cookie;
+	dma_addr_t qp_dma_addr;
+	struct delayed_work p2p_dwork;
+	struct delayed_work qp_dwork;
+	int p2p_retry;
+	dma_addr_t base_addr;
+	struct mic_mw mmio;
+	struct scif_peer_dev __rcu *spdev;
+	bool node_remove_ack_pending;
+	bool exit_ack_pending;
+	wait_queue_head_t disconn_wq;
+	atomic_t disconn_rescnt;
+	enum scif_msg_state exit;
+};
+
+extern struct scif_info scif_info;
+extern struct idr scif_ports;
+extern struct scif_dev *scif_dev;
+extern const struct file_operations scif_fops;
+
+/* Size of the RB for the Node QP */
+#define SCIF_NODE_QP_SIZE 0x10000
+
+#include "scif_nodeqp.h"
+
+/*
+ * scifdev_self:
+ * @dev: The remote SCIF Device
+ *
+ * Returns true if the SCIF Device passed is the self aka Loopback SCIF device.
+ */
+static inline int scifdev_self(struct scif_dev *dev)
+{
+	return dev->node == scif_info.nodeid;
+}
+
+static inline bool scif_is_mgmt_node(void)
+{
+	return !scif_info.nodeid;
+}
+
+/*
+ * scifdev_is_p2p:
+ * @dev: The remote SCIF Device
+ *
+ * Returns true if the SCIF Device is a MIC Peer to Peer SCIF device.
+ */
+static inline bool scifdev_is_p2p(struct scif_dev *dev)
+{
+	if (scif_is_mgmt_node())
+		return false;
+	else
+		return dev != &scif_dev[SCIF_MGMT_NODE] &&
+			!scifdev_self(dev);
+}
+
+/*
+ * scifdev_alive:
+ * @scifdev: The remote SCIF Device
+ *
+ * Returns true if the remote SCIF Device is running or sleeping for
+ * this endpoint.
+ */
+static inline int _scifdev_alive(struct scif_dev *scifdev)
+{
+	struct scif_peer_dev *spdev;
+
+	rcu_read_lock();
+	spdev = rcu_dereference(scifdev->spdev);
+	rcu_read_unlock();
+	return !!spdev;
+}
+
+void __init scif_init_debugfs(void);
+void scif_exit_debugfs(void);
+int scif_setup_intr_wq(struct scif_dev *scifdev);
+void scif_destroy_intr_wq(struct scif_dev *scifdev);
+void scif_cleanup_scifdev(struct scif_dev *dev);
+void scif_handle_remove_node(int node);
+void scif_disconnect_node(u32 node_id, bool mgmt_initiated);
+void scif_free_qp(struct scif_dev *dev);
+void scif_misc_handler(struct work_struct *work);
+void scif_stop(struct scif_dev *scifdev);
+irqreturn_t scif_intr_handler(int irq, void *data);
+#endif /* SCIF_MAIN_H */
diff --git a/drivers/misc/mic/scif/scif_map.h b/drivers/misc/mic/scif/scif_map.h
new file mode 100644
index 0000000..20e50b4
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_map.h
@@ -0,0 +1,113 @@
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
+#ifndef SCIF_MAP_H
+#define SCIF_MAP_H
+
+#include "../bus/scif_bus.h"
+
+static __always_inline void *
+scif_alloc_coherent(dma_addr_t *dma_handle,
+		    struct scif_dev *scifdev, size_t size,
+		    gfp_t gfp)
+{
+	void *va;
+
+	if (scifdev_self(scifdev)) {
+		va = kmalloc(size, gfp);
+		if (va)
+			*dma_handle = virt_to_phys(va);
+	} else {
+		va = dma_alloc_coherent(&scifdev->sdev->dev,
+					size, dma_handle, gfp);
+		if (va && scifdev_is_p2p(scifdev))
+			*dma_handle = *dma_handle + scifdev->base_addr;
+	}
+	return va;
+}
+
+static __always_inline void
+scif_free_coherent(void *va, dma_addr_t local,
+		   struct scif_dev *scifdev, size_t size)
+{
+	if (scifdev_self(scifdev)) {
+		kfree(va);
+	} else {
+		if (scifdev_is_p2p(scifdev) && local > scifdev->base_addr)
+			local = local - scifdev->base_addr;
+		dma_free_coherent(&scifdev->sdev->dev,
+				  size, va, local);
+	}
+}
+
+static __always_inline int
+scif_map_single(dma_addr_t *dma_handle,
+		void *local, struct scif_dev *scifdev, size_t size)
+{
+	int err = 0;
+
+	if (scifdev_self(scifdev)) {
+		*dma_handle = virt_to_phys((local));
+	} else {
+		*dma_handle = dma_map_single(&scifdev->sdev->dev,
+					     local, size, DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(&scifdev->sdev->dev, *dma_handle))
+			err = -ENOMEM;
+		else if (scifdev_is_p2p(scifdev))
+			*dma_handle = *dma_handle + scifdev->base_addr;
+	}
+	if (err)
+		*dma_handle = 0;
+	return err;
+}
+
+static __always_inline void
+scif_unmap_single(dma_addr_t local, struct scif_dev *scifdev,
+		  size_t size)
+{
+	if (!scifdev_self(scifdev)) {
+		if (scifdev_is_p2p(scifdev) && local > scifdev->base_addr)
+			local = local - scifdev->base_addr;
+		dma_unmap_single(&scifdev->sdev->dev, local,
+				 size, DMA_BIDIRECTIONAL);
+	}
+}
+
+static __always_inline void *
+scif_ioremap(dma_addr_t phys, size_t size, struct scif_dev *scifdev)
+{
+	void *out_virt;
+	struct scif_hw_dev *sdev = scifdev->sdev;
+
+	if (scifdev_self(scifdev))
+		out_virt = phys_to_virt(phys);
+	else
+		out_virt = (void __force *)
+			   sdev->hw_ops->ioremap(sdev, phys, size);
+	return out_virt;
+}
+
+static __always_inline void
+scif_iounmap(void *virt, size_t len, struct scif_dev *scifdev)
+{
+	if (!scifdev_self(scifdev)) {
+		struct scif_hw_dev *sdev = scifdev->sdev;
+
+		sdev->hw_ops->iounmap(sdev, (void __force __iomem *)virt);
+	}
+}
+#endif  /* SCIF_MAP_H */
diff --git a/drivers/misc/mic/scif/scif_debugfs.c b/drivers/misc/mic/scif/scif_debugfs.c
new file mode 100644
index 0000000..f837761
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_debugfs.c
@@ -0,0 +1,82 @@
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
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#include "../common/mic_dev.h"
+#include "scif_main.h"
+
+/* Debugfs parent dir */
+static struct dentry *scif_dbg;
+
+static int scif_dev_test(struct seq_file *s, void *unused)
+{
+	int node;
+
+	seq_printf(s, "Total Nodes %d Self Node Id %d Maxid %d\n",
+		   scif_info.total, scif_info.nodeid,
+		   scif_info.maxid);
+
+	if (!scif_dev)
+		return 0;
+
+	seq_printf(s, "%-16s\t%-16s\n", "node_id", "state");
+
+	for (node = 0; node <= scif_info.maxid; node++)
+		seq_printf(s, "%-16d\t%-16s\n", scif_dev[node].node,
+			   _scifdev_alive(&scif_dev[node]) ?
+			   "Running" : "Offline");
+	return 0;
+}
+
+static int scif_dev_test_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, scif_dev_test, inode->i_private);
+}
+
+static int scif_dev_test_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations scif_dev_ops = {
+	.owner   = THIS_MODULE,
+	.open    = scif_dev_test_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = scif_dev_test_release
+};
+
+void __init scif_init_debugfs(void)
+{
+	struct dentry *d;
+
+	scif_dbg = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!scif_dbg)
+		pr_err("can't create debugfs dir scif\n");
+
+	d = debugfs_create_file("scif_dev", 0444, scif_dbg,
+				NULL, &scif_dev_ops);
+	debugfs_create_u8("en_msg_log", 0666, scif_dbg, &scif_info.en_msg_log);
+	debugfs_create_u8("p2p_enable", 0666, scif_dbg, &scif_info.p2p_enable);
+}
+
+void scif_exit_debugfs(void)
+{
+	debugfs_remove_recursive(scif_dbg);
+}
diff --git a/drivers/misc/mic/scif/scif_main.c b/drivers/misc/mic/scif/scif_main.c
new file mode 100644
index 0000000..b81ad4d
--- /dev/null
+++ b/drivers/misc/mic/scif/scif_main.c
@@ -0,0 +1,394 @@
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
+#include <linux/module.h>
+#include <linux/idr.h>
+
+#include <linux/mic_common.h>
+#include "../common/mic_dev.h"
+#include "../bus/scif_bus.h"
+#include "scif_peer_bus.h"
+#include "scif_main.h"
+#include "scif_map.h"
+
+struct scif_info scif_info = {
+	.miscdev = {
+		.minor = MISC_DYNAMIC_MINOR,
+		.name = "scif",
+		.fops = &scif_fops,
+	}
+};
+
+struct scif_dev *scif_dev;
+static atomic_t g_loopb_cnt;
+
+/* Runs in the context of intr_wq */
+static void scif_intr_bh_handler(struct work_struct *work)
+{
+	struct scif_dev *scifdev =
+			container_of(work, struct scif_dev, intr_bh);
+
+	if (scifdev_self(scifdev))
+		scif_loopb_msg_handler(scifdev, scifdev->qpairs);
+	else
+		scif_nodeqp_intrhandler(scifdev, scifdev->qpairs);
+}
+
+int scif_setup_intr_wq(struct scif_dev *scifdev)
+{
+	if (!scifdev->intr_wq) {
+		snprintf(scifdev->intr_wqname, sizeof(scifdev->intr_wqname),
+			 "SCIF INTR %d", scifdev->node);
+		scifdev->intr_wq =
+			alloc_ordered_workqueue(scifdev->intr_wqname, 0);
+		if (!scifdev->intr_wq)
+			return -ENOMEM;
+		INIT_WORK(&scifdev->intr_bh, scif_intr_bh_handler);
+	}
+	return 0;
+}
+
+void scif_destroy_intr_wq(struct scif_dev *scifdev)
+{
+	if (scifdev->intr_wq) {
+		destroy_workqueue(scifdev->intr_wq);
+		scifdev->intr_wq = NULL;
+	}
+}
+
+irqreturn_t scif_intr_handler(int irq, void *data)
+{
+	struct scif_dev *scifdev = data;
+	struct scif_hw_dev *sdev = scifdev->sdev;
+
+	sdev->hw_ops->ack_interrupt(sdev, scifdev->db);
+	queue_work(scifdev->intr_wq, &scifdev->intr_bh);
+	return IRQ_HANDLED;
+}
+
+static int scif_peer_probe(struct scif_peer_dev *spdev)
+{
+	struct scif_dev *scifdev = &scif_dev[spdev->dnode];
+
+	mutex_lock(&scif_info.conflock);
+	scif_info.total++;
+	scif_info.maxid = max_t(u32, spdev->dnode, scif_info.maxid);
+	mutex_unlock(&scif_info.conflock);
+	rcu_assign_pointer(scifdev->spdev, spdev);
+
+	/* In the future SCIF kernel client devices will be added here */
+	dev_info(&spdev->dev, "Peer added dnode %d\n",
+		 spdev->dnode);
+	return 0;
+}
+
+static void scif_peer_remove(struct scif_peer_dev *spdev)
+{
+	struct scif_dev *scifdev = &scif_dev[spdev->dnode];
+
+	/* In the future SCIF kernel client devices will be removed here */
+	spdev = rcu_dereference(scifdev->spdev);
+	if (spdev)
+		RCU_INIT_POINTER(scifdev->spdev, NULL);
+	synchronize_rcu();
+
+	mutex_lock(&scif_info.conflock);
+	scif_info.total--;
+	mutex_unlock(&scif_info.conflock);
+	dev_info(&spdev->dev, "Peer removed dnode %d\n",
+		 spdev->dnode);
+}
+
+static void scif_qp_setup_handler(struct work_struct *work)
+{
+	struct scif_dev *scifdev = container_of(work, struct scif_dev,
+						qp_dwork.work);
+	struct scif_hw_dev *sdev = scifdev->sdev;
+	dma_addr_t da = 0;
+	int err;
+
+	if (scif_is_mgmt_node()) {
+		struct mic_bootparam *bp = sdev->dp;
+
+		da = bp->scif_card_dma_addr;
+		scifdev->rdb = bp->h2c_scif_db;
+	} else {
+		struct mic_bootparam __iomem *bp = sdev->rdp;
+
+		da = readq(&bp->scif_host_dma_addr);
+		scifdev->rdb = ioread8(&bp->c2h_scif_db);
+	}
+	if (da) {
+		err = scif_qp_response(da, scifdev);
+		if (err)
+			dev_err(&scifdev->sdev->dev,
+				"scif_qp_response err %d\n", err);
+	} else {
+		schedule_delayed_work(&scifdev->qp_dwork,
+				      msecs_to_jiffies(1000));
+	}
+}
+
+static int scif_setup_scifdev(struct scif_hw_dev *sdev)
+{
+	int i;
+	u8 num_nodes;
+
+	if (sdev->snode) {
+		struct mic_bootparam __iomem *bp = sdev->rdp;
+
+		num_nodes = ioread8(&bp->tot_nodes);
+	} else {
+		struct mic_bootparam *bp = sdev->dp;
+
+		num_nodes = bp->tot_nodes;
+	}
+	scif_dev = kcalloc(num_nodes, sizeof(*scif_dev), GFP_KERNEL);
+	if (!scif_dev)
+		return -ENOMEM;
+	for (i = 0; i < num_nodes; i++) {
+		struct scif_dev *scifdev = &scif_dev[i];
+
+		scifdev->node = i;
+		scifdev->exit = OP_IDLE;
+		init_waitqueue_head(&scifdev->disconn_wq);
+		mutex_init(&scifdev->lock);
+		INIT_DELAYED_WORK(&scifdev->p2p_dwork,
+				  scif_poll_qp_state);
+		INIT_DELAYED_WORK(&scifdev->qp_dwork,
+				  scif_qp_setup_handler);
+		INIT_LIST_HEAD(&scifdev->p2p);
+		RCU_INIT_POINTER(scifdev->spdev, NULL);
+	}
+	return 0;
+}
+
+static void scif_destroy_scifdev(void)
+{
+	kfree(scif_dev);
+}
+
+static int scif_probe(struct scif_hw_dev *sdev)
+{
+	struct scif_dev *scifdev;
+	int rc;
+
+	dev_set_drvdata(&sdev->dev, sdev);
+	if (1 == atomic_add_return(1, &g_loopb_cnt)) {
+		struct scif_dev *loopb_dev;
+
+		rc = scif_setup_scifdev(sdev);
+		if (rc)
+			goto exit;
+		scifdev = &scif_dev[sdev->dnode];
+		scifdev->sdev = sdev;
+		loopb_dev = &scif_dev[sdev->snode];
+		loopb_dev->sdev = sdev;
+		rc = scif_setup_loopback_qp(loopb_dev);
+		if (rc)
+			goto free_sdev;
+	} else {
+		scifdev = &scif_dev[sdev->dnode];
+		scifdev->sdev = sdev;
+	}
+	rc = scif_setup_intr_wq(scifdev);
+	if (rc)
+		goto destroy_loopb;
+	rc = scif_setup_qp(scifdev);
+	if (rc)
+		goto destroy_intr;
+	scifdev->db = sdev->hw_ops->next_db(sdev);
+	scifdev->cookie = sdev->hw_ops->request_irq(sdev, scif_intr_handler,
+						    "SCIF_INTR", scifdev,
+						    scifdev->db);
+	if (IS_ERR(scifdev->cookie)) {
+		rc = PTR_ERR(scifdev->cookie);
+		goto free_qp;
+	}
+	if (scif_is_mgmt_node()) {
+		struct mic_bootparam *bp = sdev->dp;
+
+		bp->c2h_scif_db = scifdev->db;
+		bp->scif_host_dma_addr = scifdev->qp_dma_addr;
+	} else {
+		struct mic_bootparam __iomem *bp = sdev->rdp;
+
+		iowrite8(scifdev->db, &bp->h2c_scif_db);
+		writeq(scifdev->qp_dma_addr, &bp->scif_card_dma_addr);
+	}
+	schedule_delayed_work(&scifdev->qp_dwork,
+			      msecs_to_jiffies(1000));
+	return rc;
+free_qp:
+	scif_free_qp(scifdev);
+destroy_intr:
+	scif_destroy_intr_wq(scifdev);
+destroy_loopb:
+	if (atomic_dec_and_test(&g_loopb_cnt))
+		scif_destroy_loopback_qp(&scif_dev[sdev->snode]);
+free_sdev:
+	scif_destroy_scifdev();
+exit:
+	return rc;
+}
+
+void scif_stop(struct scif_dev *scifdev)
+{
+	struct scif_dev *dev;
+	int i;
+
+	for (i = scif_info.maxid; i >= 0; i--) {
+		dev = &scif_dev[i];
+		if (scifdev_self(dev))
+			continue;
+		scif_handle_remove_node(i);
+	}
+}
+
+static void scif_remove(struct scif_hw_dev *sdev)
+{
+	struct scif_dev *scifdev = &scif_dev[sdev->dnode];
+
+	if (scif_is_mgmt_node()) {
+		struct mic_bootparam *bp = sdev->dp;
+
+		bp->c2h_scif_db = -1;
+		bp->scif_host_dma_addr = 0x0;
+	} else {
+		struct mic_bootparam __iomem *bp = sdev->rdp;
+
+		iowrite8(-1, &bp->h2c_scif_db);
+		writeq(0x0, &bp->scif_card_dma_addr);
+	}
+	if (scif_is_mgmt_node()) {
+		scif_disconnect_node(scifdev->node, true);
+	} else {
+		/*
+		 * Send an SCIF_EXIT message which is the last message from MIC
+		 * to the Host and wait for a SCIF_EXIT_ACK
+		 */
+		scif_send_exit(scifdev);
+		scif_stop(scifdev);
+	}
+	if (atomic_dec_and_test(&g_loopb_cnt))
+		scif_destroy_loopback_qp(&scif_dev[sdev->snode]);
+	if (scifdev->cookie) {
+		sdev->hw_ops->free_irq(sdev, scifdev->cookie, scifdev);
+		scifdev->cookie = NULL;
+	}
+	scif_destroy_intr_wq(scifdev);
+	cancel_delayed_work(&scifdev->qp_dwork);
+	scif_free_qp(scifdev);
+	scifdev->rdb = -1;
+	scifdev->sdev = NULL;
+}
+
+static struct scif_peer_driver scif_peer_driver = {
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.probe = scif_peer_probe,
+	.remove = scif_peer_remove,
+};
+
+static struct scif_hw_dev_id id_table[] = {
+	{ MIC_SCIF_DEV, SCIF_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct scif_driver scif_driver = {
+	.driver.name =	KBUILD_MODNAME,
+	.driver.owner =	THIS_MODULE,
+	.id_table = id_table,
+	.probe = scif_probe,
+	.remove = scif_remove,
+};
+
+static int _scif_init(void)
+{
+	spin_lock_init(&scif_info.eplock);
+	spin_lock_init(&scif_info.nb_connect_lock);
+	spin_lock_init(&scif_info.port_lock);
+	mutex_init(&scif_info.conflock);
+	mutex_init(&scif_info.connlock);
+	INIT_LIST_HEAD(&scif_info.uaccept);
+	INIT_LIST_HEAD(&scif_info.listen);
+	INIT_LIST_HEAD(&scif_info.zombie);
+	INIT_LIST_HEAD(&scif_info.connected);
+	INIT_LIST_HEAD(&scif_info.disconnected);
+	INIT_LIST_HEAD(&scif_info.nb_connect_list);
+	init_waitqueue_head(&scif_info.exitwq);
+	scif_info.en_msg_log = 0;
+	scif_info.p2p_enable = 1;
+	INIT_WORK(&scif_info.misc_work, scif_misc_handler);
+	idr_init(&scif_ports);
+	return 0;
+}
+
+static void _scif_exit(void)
+{
+	idr_destroy(&scif_ports);
+	scif_destroy_scifdev();
+}
+
+static int __init scif_init(void)
+{
+	struct miscdevice *mdev = &scif_info.miscdev;
+	int rc;
+
+	_scif_init();
+	rc = scif_peer_bus_init();
+	if (rc)
+		goto exit;
+	rc = scif_peer_register_driver(&scif_peer_driver);
+	if (rc)
+		goto peer_bus_exit;
+	rc = scif_register_driver(&scif_driver);
+	if (rc)
+		goto unreg_scif_peer;
+	rc = misc_register(mdev);
+	if (rc)
+		goto unreg_scif;
+	scif_init_debugfs();
+	return 0;
+unreg_scif:
+	scif_unregister_driver(&scif_driver);
+unreg_scif_peer:
+	scif_peer_unregister_driver(&scif_peer_driver);
+peer_bus_exit:
+	scif_peer_bus_exit();
+exit:
+	_scif_exit();
+	return rc;
+}
+
+static void __exit scif_exit(void)
+{
+	scif_exit_debugfs();
+	misc_deregister(&scif_info.miscdev);
+	scif_unregister_driver(&scif_driver);
+	scif_peer_unregister_driver(&scif_peer_driver);
+	scif_peer_bus_exit();
+	_scif_exit();
+}
+
+module_init(scif_init);
+module_exit(scif_exit);
+
+MODULE_DEVICE_TABLE(scif, id_table);
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) SCIF driver");
+MODULE_LICENSE("GPL v2");
-- 
1.8.2.1

