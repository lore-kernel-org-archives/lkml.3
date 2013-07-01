Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab3GASgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 14:36:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:3841 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3GASgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 14:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,975,1363158000"; 
   d="scan'208";a="358872521"
From: Jon Mason <jon.mason@intel.com>
To: Dan Williams <djbw@fb.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC] NTB: Use DMA Engine to transmit and receive
Date: Mon,  1 Jul 2013 11:36:17 -0700
Message-Id: <1372703777-12562-1-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate and use a DMA engine channel to transmit and receive data over
NTB.  If none is allocated, fall back to using the CPU to transfer data.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |   19 ++-
 drivers/ntb/ntb_hw.h        |    1 +
 drivers/ntb/ntb_transport.c |  285 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 259 insertions(+), 46 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 15d7517..d032f6d 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -56,7 +56,7 @@
 #include "ntb_regs.h"
 
 #define NTB_NAME	"Intel(R) PCI-E Non-Transparent Bridge Driver"
-#define NTB_VER		"0.25"
+#define NTB_VER		"0.26"
 
 MODULE_DESCRIPTION(NTB_NAME);
 MODULE_VERSION(NTB_VER);
@@ -396,6 +396,23 @@ int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val)
 }
 
 /**
+ * ntb_get_mw_base() - get addr for the NTB memory window
+ * @ndev: pointer to ntb_device instance
+ * @mw: memory window number
+ *
+ * This function provides the base address of the memory window specified.
+ *
+ * RETURNS: address, or NULL on error.
+ */
+resource_size_t ntb_get_mw_base(struct ntb_device *ndev, unsigned int mw)
+{
+	if (mw >= NTB_NUM_MW)
+		return 0;
+
+	return pci_resource_start(ndev->pdev, MW_TO_BAR(mw));
+}
+
+/**
  * ntb_get_mw_vbase() - get virtual addr for the NTB memory window
  * @ndev: pointer to ntb_device instance
  * @mw: memory window number
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index f2b11ef..b631070 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -206,6 +206,7 @@ int ntb_write_local_spad(struct ntb_device *ndev, unsigned int idx, u32 val);
 int ntb_read_local_spad(struct ntb_device *ndev, unsigned int idx, u32 *val);
 int ntb_write_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 val);
 int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val);
+resource_size_t ntb_get_mw_base(struct ntb_device *ndev, unsigned int mw);
 void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw);
 u64 ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw);
 void ntb_ring_sdb(struct ntb_device *ndev, unsigned int idx);
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 9694ed8..e86134b 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -47,6 +47,7 @@
  */
 #include <linux/debugfs.h>
 #include <linux/delay.h>
+#include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/errno.h>
 #include <linux/export.h>
@@ -68,6 +69,10 @@ static unsigned char max_num_clients = 2;
 module_param(max_num_clients, byte, 0644);
 MODULE_PARM_DESC(max_num_clients, "Maximum number of NTB transport clients");
 
+static unsigned int copy_bytes = 1024;
+module_param(copy_bytes, uint, 0644);
+MODULE_PARM_DESC(copy_bytes, "Threshold under which NTB will use the CPU to copy instead of DMA");
+
 struct ntb_queue_entry {
 	/* ntb_queue list reference */
 	struct list_head entry;
@@ -76,6 +81,13 @@ struct ntb_queue_entry {
 	void *buf;
 	unsigned int len;
 	unsigned int flags;
+
+	struct ntb_transport_qp *qp;
+	union {
+		struct ntb_payload_header __iomem *tx_hdr;
+		struct ntb_payload_header *rx_hdr;
+	};
+	unsigned int index;
 };
 
 struct ntb_rx_info {
@@ -86,6 +98,7 @@ struct ntb_transport_qp {
 	struct ntb_transport *transport;
 	struct ntb_device *ndev;
 	void *cb_data;
+	struct dma_chan *dma_chan;
 
 	bool client_ready;
 	bool qp_link;
@@ -99,6 +112,7 @@ struct ntb_transport_qp {
 	struct list_head tx_free_q;
 	spinlock_t ntb_tx_free_q_lock;
 	void __iomem *tx_mw;
+	dma_addr_t tx_mw_raw;
 	unsigned int tx_index;
 	unsigned int tx_max_entry;
 	unsigned int tx_max_frame;
@@ -113,6 +127,7 @@ struct ntb_transport_qp {
 	unsigned int rx_index;
 	unsigned int rx_max_entry;
 	unsigned int rx_max_frame;
+	dma_cookie_t last_cookie;
 
 	void (*event_handler) (void *data, int status);
 	struct delayed_work link_work;
@@ -128,9 +143,14 @@ struct ntb_transport_qp {
 	u64 rx_err_no_buf;
 	u64 rx_err_oflow;
 	u64 rx_err_ver;
+	u64 rx_memcpy;
+	u64 rx_async;
 	u64 tx_bytes;
 	u64 tx_pkts;
 	u64 tx_ring_full;
+	u64 tx_err_no_buf;
+	u64 tx_memcpy;
+	u64 tx_async;
 };
 
 struct ntb_transport_mw {
@@ -381,7 +401,7 @@ static ssize_t debugfs_read(struct file *filp, char __user *ubuf, size_t count,
 	char *buf;
 	ssize_t ret, out_offset, out_count;
 
-	out_count = 600;
+	out_count = 1000;
 
 	buf = kmalloc(out_count, GFP_KERNEL);
 	if (!buf)
@@ -396,6 +416,10 @@ static ssize_t debugfs_read(struct file *filp, char __user *ubuf, size_t count,
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "rx_pkts - \t%llu\n", qp->rx_pkts);
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "rx_memcpy - \t%llu\n", qp->rx_memcpy);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "rx_async - \t%llu\n", qp->rx_async);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "rx_ring_empty - %llu\n", qp->rx_ring_empty);
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "rx_err_no_buf - %llu\n", qp->rx_err_no_buf);
@@ -415,8 +439,14 @@ static ssize_t debugfs_read(struct file *filp, char __user *ubuf, size_t count,
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "tx_pkts - \t%llu\n", qp->tx_pkts);
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "tx_memcpy - \t%llu\n", qp->tx_memcpy);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "tx_async - \t%llu\n", qp->tx_async);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "tx_ring_full - \t%llu\n", qp->tx_ring_full);
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
+			       "tx_err_no_buf - %llu\n", qp->tx_err_no_buf);
+	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "tx_mw - \t%p\n", qp->tx_mw);
 	out_offset += snprintf(buf + out_offset, out_count - out_offset,
 			       "tx_index - \t%u\n", qp->tx_index);
@@ -485,11 +515,11 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
 		num_qps_mw = nt->max_qps / NTB_NUM_MW;
 
 	rx_size = (unsigned int) nt->mw[mw_num].size / num_qps_mw;
-	qp->remote_rx_info = nt->mw[mw_num].virt_addr +
-			     (qp_num / NTB_NUM_MW * rx_size);
+	qp->rx_buff = nt->mw[mw_num].virt_addr + qp_num / NTB_NUM_MW * rx_size;
 	rx_size -= sizeof(struct ntb_rx_info);
 
-	qp->rx_buff = qp->remote_rx_info + 1;
+	qp->remote_rx_info = qp->rx_buff + rx_size;
+
 	/* Due to housekeeping, there must be atleast 2 buffs */
 	qp->rx_max_frame = min(transport_mtu, rx_size / 2);
 	qp->rx_max_entry = rx_size / qp->rx_max_frame;
@@ -799,6 +829,7 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 	struct ntb_transport_qp *qp;
 	unsigned int num_qps_mw, tx_size;
 	u8 mw_num = QP_TO_MW(qp_num);
+	u64 qp_offset;
 
 	qp = &nt->qps[qp_num];
 	qp->qp_num = qp_num;
@@ -814,11 +845,12 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 		num_qps_mw = nt->max_qps / NTB_NUM_MW;
 
 	tx_size = (unsigned int) ntb_get_mw_size(qp->ndev, mw_num) / num_qps_mw;
-	qp->rx_info = ntb_get_mw_vbase(nt->ndev, mw_num) +
-		      (qp_num / NTB_NUM_MW * tx_size);
+	qp_offset = qp_num / NTB_NUM_MW * tx_size;
+	qp->tx_mw = ntb_get_mw_vbase(nt->ndev, mw_num) + qp_offset;
+	qp->tx_mw_raw = ntb_get_mw_base(qp->ndev, mw_num) + qp_offset;
 	tx_size -= sizeof(struct ntb_rx_info);
+	qp->rx_info = qp->tx_mw + tx_size;
 
-	qp->tx_mw = qp->rx_info + 1;
 	/* Due to housekeeping, there must be atleast 2 buffs */
 	qp->tx_max_frame = min(transport_mtu, tx_size / 2);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
@@ -942,13 +974,22 @@ void ntb_transport_free(void *transport)
 	kfree(nt);
 }
 
-static void ntb_rx_copy_task(struct ntb_transport_qp *qp,
-			     struct ntb_queue_entry *entry, void *offset)
+static void ntb_rx_copy_callback(void *data)
 {
+	struct ntb_queue_entry *entry = data;
+	struct ntb_transport_qp *qp = entry->qp;
 	void *cb_data = entry->cb_data;
 	unsigned int len = entry->len;
+	struct ntb_payload_header *hdr = entry->rx_hdr;
+
+	wmb();
+	hdr->flags = 0;
 
-	memcpy(entry->buf, offset, entry->len);
+	/* If the callbacks come out of order, the writing of the index to the
+	 * last completed will be out of order.  This may result in the the
+	 * receive stalling forever.
+	 */
+	iowrite32(entry->index, &qp->rx_info->entry);
 
 	ntb_list_add(&qp->ntb_rx_free_q_lock, &entry->entry, &qp->rx_free_q);
 
@@ -956,6 +997,80 @@ static void ntb_rx_copy_task(struct ntb_transport_qp *qp,
 		qp->rx_handler(qp, qp->cb_data, cb_data, len);
 }
 
+static void ntb_memcpy_rx(struct ntb_queue_entry *entry, void *offset)
+{
+	void *buf = entry->buf;
+	size_t len = entry->len;
+
+	memcpy(buf, offset, len);
+
+	ntb_rx_copy_callback(entry);
+}
+
+static void ntb_async_rx(struct ntb_queue_entry *entry, void *offset,
+			 size_t len)
+{
+	struct dma_async_tx_descriptor *txd;
+	struct ntb_transport_qp *qp = entry->qp;
+	struct dma_chan *chan = qp->dma_chan;
+	struct dma_device *device;
+	dma_addr_t src, dest;
+	dma_cookie_t cookie;
+	void *buf = entry->buf;
+	unsigned long flags;
+
+	entry->len = len;
+
+	if (!chan)
+		goto err;
+
+	device = chan->device;
+
+	if (len < copy_bytes ||
+	    !is_dma_copy_aligned(device, __pa(offset), __pa(buf), len))
+		goto err1;
+
+	dest = dma_map_single(device->dev, buf, len, DMA_FROM_DEVICE);
+	if (dma_mapping_error(device->dev, dest))
+		goto err1;
+
+	src = dma_map_single(device->dev, offset, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(device->dev, src))
+		goto err2;
+
+	flags = DMA_COMPL_DEST_UNMAP_SINGLE | DMA_COMPL_SRC_UNMAP_SINGLE |
+		DMA_PREP_INTERRUPT;
+	txd = device->device_prep_dma_memcpy(chan, dest, src, len, flags);
+	if (!txd)
+		goto err3;
+
+	txd_clear_parent(txd);
+	txd_clear_next(txd);
+	txd->callback = ntb_rx_copy_callback;
+	txd->callback_param = entry;
+
+	cookie = dmaengine_submit(txd);
+	if (dma_submit_error(cookie))
+		goto err3;
+
+	qp->last_cookie = cookie;
+
+	dma_async_issue_pending(chan);
+	qp->rx_async++;
+
+	return;
+
+err3:
+	dma_unmap_single(device->dev, src, len, DMA_TO_DEVICE);
+err2:
+	dma_unmap_single(device->dev, dest, len, DMA_FROM_DEVICE);
+err1:
+	dma_sync_wait(chan, qp->last_cookie);
+err:
+	ntb_memcpy_rx(entry, offset);
+	qp->rx_memcpy++;
+}
+
 static int ntb_process_rxc(struct ntb_transport_qp *qp)
 {
 	struct ntb_payload_header *hdr;
@@ -994,41 +1109,44 @@ static int ntb_process_rxc(struct ntb_transport_qp *qp)
 	if (hdr->flags & LINK_DOWN_FLAG) {
 		ntb_qp_link_down(qp);
 
-		ntb_list_add(&qp->ntb_rx_pend_q_lock, &entry->entry,
-			     &qp->rx_pend_q);
-		goto out;
+		goto err;
 	}
 
 	dev_dbg(&ntb_query_pdev(qp->ndev)->dev,
 		"rx offset %u, ver %u - %d payload received, buf size %d\n",
 		qp->rx_index, hdr->ver, hdr->len, entry->len);
 
-	if (hdr->len <= entry->len) {
-		entry->len = hdr->len;
-		ntb_rx_copy_task(qp, entry, offset);
-	} else {
-		ntb_list_add(&qp->ntb_rx_pend_q_lock, &entry->entry,
-			     &qp->rx_pend_q);
+	qp->rx_bytes += hdr->len;
+	qp->rx_pkts++;
 
+	if (hdr->len > entry->len) {
 		qp->rx_err_oflow++;
 		dev_dbg(&ntb_query_pdev(qp->ndev)->dev,
 			"RX overflow! Wanted %d got %d\n",
 			hdr->len, entry->len);
+
+		goto err;
 	}
 
-	qp->rx_bytes += hdr->len;
-	qp->rx_pkts++;
+	entry->index = qp->rx_index;
+	entry->rx_hdr = hdr;
 
-out:
-	/* Ensure that the data is fully copied out before clearing the flag */
-	wmb();
-	hdr->flags = 0;
-	iowrite32(qp->rx_index, &qp->rx_info->entry);
+	ntb_async_rx(entry, offset, hdr->len);
 
+out:
 	qp->rx_index++;
 	qp->rx_index %= qp->rx_max_entry;
 
 	return 0;
+
+err:
+	ntb_list_add(&qp->ntb_rx_pend_q_lock, &entry->entry,
+		     &qp->rx_pend_q);
+	wmb();
+	hdr->flags = 0;
+	iowrite32(qp->rx_index, &qp->rx_info->entry);
+
+	goto out;
 }
 
 static int ntb_transport_rxc_db(void *data, int db_num)
@@ -1051,19 +1169,12 @@ static int ntb_transport_rxc_db(void *data, int db_num)
 	return i;
 }
 
-static void ntb_tx_copy_task(struct ntb_transport_qp *qp,
-			     struct ntb_queue_entry *entry,
-			     void __iomem *offset)
+static void ntb_tx_copy_callback(void *data)
 {
-	struct ntb_payload_header __iomem *hdr;
-
-	memcpy_toio(offset, entry->buf, entry->len);
-
-	hdr = offset + qp->tx_max_frame - sizeof(struct ntb_payload_header);
-	iowrite32(entry->len, &hdr->len);
-	iowrite32((u32) qp->tx_pkts, &hdr->ver);
+	struct ntb_queue_entry *entry = data;
+	struct ntb_transport_qp *qp = entry->qp;
+	struct ntb_payload_header __iomem *hdr = entry->tx_hdr;
 
-	/* Ensure that the data is fully copied out before setting the flag */
 	wmb();
 	iowrite32(entry->flags | DESC_DONE_FLAG, &hdr->flags);
 
@@ -1084,15 +1195,79 @@ static void ntb_tx_copy_task(struct ntb_transport_qp *qp,
 	ntb_list_add(&qp->ntb_tx_free_q_lock, &entry->entry, &qp->tx_free_q);
 }
 
-static int ntb_process_tx(struct ntb_transport_qp *qp,
-			  struct ntb_queue_entry *entry)
+static void ntb_memcpy_tx(struct ntb_queue_entry *entry, void __iomem *offset)
+{
+	memcpy_toio(offset, entry->buf, entry->len);
+
+	ntb_tx_copy_callback(entry);
+}
+
+static void ntb_async_tx(struct ntb_transport_qp *qp,
+			 struct ntb_queue_entry *entry)
 {
+	struct dma_async_tx_descriptor *txd;
+	struct dma_chan *chan = qp->dma_chan;
+	struct dma_device *device;
+	dma_addr_t src, dest;
+	dma_cookie_t cookie;
+	struct ntb_payload_header __iomem *hdr;
 	void __iomem *offset;
+	size_t len = entry->len;
+	void *buf = entry->buf;
+	unsigned long flags;
 
 	offset = qp->tx_mw + qp->tx_max_frame * qp->tx_index;
+	hdr = offset + qp->tx_max_frame - sizeof(struct ntb_payload_header);
+	entry->tx_hdr = hdr;
+
+	iowrite32(entry->len, &hdr->len);
+	iowrite32((u32) qp->tx_pkts, &hdr->ver);
+
+	if (!chan)
+		goto err;
 
-	dev_dbg(&ntb_query_pdev(qp->ndev)->dev, "%lld - offset %p, tx %u, entry len %d flags %x buff %p\n",
-		qp->tx_pkts, offset, qp->tx_index, entry->len, entry->flags,
+	device = chan->device;
+
+	dest = qp->tx_mw_raw + qp->tx_max_frame * qp->tx_index;
+
+	if (len < copy_bytes ||
+	    !is_dma_copy_aligned(device, __pa(buf), dest, len))
+		goto err;
+
+	src = dma_map_single(device->dev, buf, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(device->dev, src))
+		goto err;
+
+	flags = DMA_COMPL_SRC_UNMAP_SINGLE | DMA_PREP_INTERRUPT;
+	txd = device->device_prep_dma_memcpy(chan, dest, src, len, flags);
+	if (!txd)
+		goto err1;
+
+	txd_clear_parent(txd);
+	txd_clear_next(txd);
+	txd->callback = ntb_tx_copy_callback;
+	txd->callback_param = entry;
+
+	cookie = dmaengine_submit(txd);
+	if (dma_submit_error(cookie))
+		goto err1;
+
+	dma_async_issue_pending(chan);
+	qp->tx_async++;
+
+	return;
+err1:
+	dma_unmap_single(device->dev, src, len, DMA_TO_DEVICE);
+err:
+	ntb_memcpy_tx(entry, offset);
+	qp->tx_memcpy++;
+}
+
+static int ntb_process_tx(struct ntb_transport_qp *qp,
+			  struct ntb_queue_entry *entry)
+{
+	dev_dbg(&ntb_query_pdev(qp->ndev)->dev, "%lld - tx %u, entry len %d flags %x buff %p\n",
+		qp->tx_pkts, qp->tx_index, entry->len, entry->flags,
 		entry->buf);
 	if (qp->tx_index == qp->remote_rx_info->entry) {
 		qp->tx_ring_full++;
@@ -1108,7 +1283,7 @@ static int ntb_process_tx(struct ntb_transport_qp *qp,
 		return 0;
 	}
 
-	ntb_tx_copy_task(qp, entry, offset);
+	ntb_async_tx(qp, entry);
 
 	qp->tx_index++;
 	qp->tx_index %= qp->tx_max_entry;
@@ -1194,11 +1369,16 @@ ntb_transport_create_queue(void *data, struct pci_dev *pdev,
 	qp->tx_handler = handlers->tx_handler;
 	qp->event_handler = handlers->event_handler;
 
+	qp->dma_chan = dma_find_channel(DMA_MEMCPY);
+	if (!qp->dma_chan)
+		dev_info(&pdev->dev, "Unable to allocate private DMA channel, using CPU instead\n");
+
 	for (i = 0; i < NTB_QP_DEF_NUM_ENTRIES; i++) {
 		entry = kzalloc(sizeof(struct ntb_queue_entry), GFP_ATOMIC);
 		if (!entry)
 			goto err1;
 
+		entry->qp = qp;
 		ntb_list_add(&qp->ntb_rx_free_q_lock, &entry->entry,
 			     &qp->rx_free_q);
 	}
@@ -1208,6 +1388,7 @@ ntb_transport_create_queue(void *data, struct pci_dev *pdev,
 		if (!entry)
 			goto err2;
 
+		entry->qp = qp;
 		ntb_list_add(&qp->ntb_tx_free_q_lock, &entry->entry,
 			     &qp->tx_free_q);
 	}
@@ -1249,10 +1430,13 @@ void ntb_transport_free_queue(struct ntb_transport_qp *qp)
 
 	pdev = ntb_query_pdev(qp->ndev);
 
-	cancel_delayed_work_sync(&qp->link_work);
+	if (qp->dma_chan)
+		dmaengine_terminate_all(qp->dma_chan);
 
 	ntb_unregister_db_callback(qp->ndev, qp->qp_num);
 
+	cancel_delayed_work_sync(&qp->link_work);
+
 	while ((entry = ntb_list_rm(&qp->ntb_rx_free_q_lock, &qp->rx_free_q)))
 		kfree(entry);
 
@@ -1358,8 +1542,10 @@ int ntb_transport_tx_enqueue(struct ntb_transport_qp *qp, void *cb, void *data,
 		return -EINVAL;
 
 	entry = ntb_list_rm(&qp->ntb_tx_free_q_lock, &qp->tx_free_q);
-	if (!entry)
+	if (!entry) {
+		qp->tx_err_no_buf++;
 		return -ENOMEM;
+	}
 
 	entry->cb_data = cb;
 	entry->buf = data;
@@ -1475,9 +1661,18 @@ EXPORT_SYMBOL_GPL(ntb_transport_qp_num);
  */
 unsigned int ntb_transport_max_size(struct ntb_transport_qp *qp)
 {
+	unsigned int max;
+
 	if (!qp)
 		return 0;
 
-	return qp->tx_max_frame - sizeof(struct ntb_payload_header);
+	if (!qp->dma_chan)
+		return qp->tx_max_frame - sizeof(struct ntb_payload_header);
+
+	/* If DMA engine usage is possible, try to find the max size for that */
+	max = qp->tx_max_frame - sizeof(struct ntb_payload_header);
+	max -= max % (1 << qp->dma_chan->device->copy_align);
+
+	return max;
 }
 EXPORT_SYMBOL_GPL(ntb_transport_max_size);
-- 
1.7.9.5

