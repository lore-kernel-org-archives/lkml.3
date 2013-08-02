Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab3HBRg7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:36:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:4521 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754952Ab3HBRg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="276900348"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] NTB: Xeon Errata Workaround
Date: Fri,  2 Aug 2013 10:35:34 -0700
Message-Id: <1375464944-27914-6-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a Xeon hardware errata related to writes to SDOORBELL or
B2BDOORBELL in conjunction with inbound access to NTB MMIO Space, which
may hang the system.  To workaround this issue, use one of the memory
windows to access the interrupt and scratch pad registers on the remote
system.  This bypasses the issue, but removes one of the memory windows
from use by the transport.  This reduction of MWs necessitates adding
some logic to determine the number of available MWs.

Since some NTB usage methodologies may have unidirectional traffic, the
ability to disable the workaround via modparm has been added.

See BF113 in
http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-c5500-c3500-spec-update.pdf
See BT119 in
http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e5-family-spec-update.pdf

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c        |  101 +++++++++++++++++++++++++++++++++++++------
 drivers/ntb/ntb_hw.h        |   39 ++++++++++++++---
 drivers/ntb/ntb_regs.h      |   22 ++++++----
 drivers/ntb/ntb_transport.c |   78 ++++++++++++++++++++-------------
 4 files changed, 182 insertions(+), 58 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 97d6704..674bc09 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -62,6 +62,10 @@ MODULE_VERSION(NTB_VER);
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Intel Corporation");
 
+static bool xeon_errata_workaround = true;
+module_param(xeon_errata_workaround, bool, 0644);
+MODULE_PARM_DESC(xeon_errata_workaround, "Workaround for the Xeon Errata");
+
 enum {
 	NTB_CONN_CLASSIC = 0,
 	NTB_CONN_B2B,
@@ -81,7 +85,7 @@ enum {
 struct dentry *debugfs_dir;
 
 /* Translate memory window 0,1 to BAR 2,4 */
-#define MW_TO_BAR(mw)	(mw * 2 + 2)
+#define MW_TO_BAR(mw)	(mw * NTB_MAX_NUM_MW + 2)
 
 static DEFINE_PCI_DEVICE_TABLE(ntb_pci_tbl) = {
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_BWD)},
@@ -347,8 +351,8 @@ int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val)
  */
 void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw >= NTB_NUM_MW)
-		return NULL;
+	if (mw >= ntb_max_mw(ndev))
+		return 0;
 
 	return ndev->mw[mw].vbase;
 }
@@ -364,7 +368,7 @@ void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
  */
 resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw >= NTB_NUM_MW)
+	if (mw >= ntb_max_mw(ndev))
 		return 0;
 
 	return ndev->mw[mw].bar_sz;
@@ -382,7 +386,7 @@ resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
  */
 void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 {
-	if (mw >= NTB_NUM_MW)
+	if (mw >= ntb_max_mw(ndev))
 		return;
 
 	dev_dbg(&ndev->pdev->dev, "Writing addr %Lx to BAR %d\n", addr,
@@ -546,16 +550,84 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 	ndev->reg_ofs.spad_read = ndev->reg_base + SNB_SPAD_OFFSET;
 	ndev->reg_ofs.spci_cmd = ndev->reg_base + SNB_PCICMD_OFFSET;
 
-	if (ndev->conn_type == NTB_CONN_B2B) {
-		ndev->reg_ofs.sdb = ndev->reg_base + SNB_B2B_DOORBELL_OFFSET;
-		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_B2B_SPAD_OFFSET;
-		ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
+	/* There is a Xeon hardware errata related to writes to
+	 * SDOORBELL or B2BDOORBELL in conjunction with inbound access
+	 * to NTB MMIO Space, which may hang the system.  To workaround
+	 * this use the second memory window to access the interrupt and
+	 * scratch pad registers on the remote system.
+	 */
+	if (xeon_errata_workaround) {
+		if (!ndev->mw[1].bar_sz)
+			return -EINVAL;
+
+		ndev->limits.max_mw = SNB_ERRATA_MAX_MW;
+		ndev->reg_ofs.spad_write = ndev->mw[1].vbase +
+					   SNB_SPAD_OFFSET;
+		ndev->reg_ofs.sdb = ndev->mw[1].vbase +
+				    SNB_PDOORBELL_OFFSET;
+
+		/* Set the Limit register to 4k, the minimum size, to
+		 * prevent an illegal access
+		 */
+		writeq(ndev->mw[1].bar_sz + 0x1000, ndev->reg_base +
+		       SNB_PBAR4LMT_OFFSET);
+	} else {
+		ndev->limits.max_mw = SNB_MAX_MW;
+		ndev->reg_ofs.spad_write = ndev->reg_base +
+					   SNB_B2B_SPAD_OFFSET;
+		ndev->reg_ofs.sdb = ndev->reg_base +
+				    SNB_B2B_DOORBELL_OFFSET;
+
+		/* Disable the Limit register, just incase it is set to
+		 * something silly
+		 */
+		writeq(0, ndev->reg_base + SNB_PBAR4LMT_OFFSET);
+	}
+
+	/* The Xeon errata workaround requires setting SBAR Base
+	 * addresses to known values, so that the PBAR XLAT can be
+	 * pointed at SBAR0 of the remote system.
+	 */
+	if (ndev->dev_type == NTB_DEV_USD) {
+		writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
+		       SNB_PBAR2XLAT_OFFSET);
+		if (xeon_errata_workaround)
+			writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
+			       SNB_PBAR4XLAT_OFFSET);
+		else {
+			writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
+			       SNB_PBAR4XLAT_OFFSET);
+			writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
+			       SNB_B2B_XLAT_OFFSET);
+		}
+
+		writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
+		       SNB_SBAR0BASE_OFFSET);
+		writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
+		       SNB_SBAR2BASE_OFFSET);
+		writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
+		       SNB_SBAR4BASE_OFFSET);
 	} else {
-		ndev->reg_ofs.sdb = ndev->reg_base + SNB_SDOORBELL_OFFSET;
-		ndev->reg_ofs.spad_write = ndev->reg_base + SNB_SPAD_OFFSET;
-		ndev->limits.max_spads = SNB_MAX_COMPAT_SPADS;
+		writeq(SNB_MBAR23_USD_ADDR, ndev->reg_base +
+		       SNB_PBAR2XLAT_OFFSET);
+		if (xeon_errata_workaround)
+			writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
+			       SNB_PBAR4XLAT_OFFSET);
+		else {
+			writeq(SNB_MBAR45_USD_ADDR, ndev->reg_base +
+			       SNB_PBAR4XLAT_OFFSET);
+			writeq(SNB_MBAR01_USD_ADDR, ndev->reg_base +
+			       SNB_B2B_XLAT_OFFSET);
+		}
+		writeq(SNB_MBAR01_DSD_ADDR, ndev->reg_base +
+		       SNB_SBAR0BASE_OFFSET);
+		writeq(SNB_MBAR23_DSD_ADDR, ndev->reg_base +
+		       SNB_SBAR2BASE_OFFSET);
+		writeq(SNB_MBAR45_DSD_ADDR, ndev->reg_base +
+		       SNB_SBAR4BASE_OFFSET);
 	}
 
+	ndev->limits.max_spads = SNB_MAX_B2B_SPADS;
 	ndev->limits.max_db_bits = SNB_MAX_DB_BITS;
 	ndev->limits.msix_cnt = SNB_MSIX_CNT;
 	ndev->bits_per_vector = SNB_DB_BITS_PER_VEC;
@@ -614,6 +686,7 @@ static int ntb_bwd_setup(struct ntb_device *ndev)
 		ndev->limits.max_spads = BWD_MAX_COMPAT_SPADS;
 	}
 
+	ndev->limits.max_mw = BWD_MAX_MW;
 	ndev->limits.max_db_bits = BWD_MAX_DB_BITS;
 	ndev->limits.msix_cnt = BWD_MSIX_CNT;
 	ndev->bits_per_vector = BWD_DB_BITS_PER_VEC;
@@ -1053,7 +1126,7 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err2;
 	}
 
-	for (i = 0; i < NTB_NUM_MW; i++) {
+	for (i = 0; i < NTB_MAX_NUM_MW; i++) {
 		ndev->mw[i].bar_sz = pci_resource_len(pdev, MW_TO_BAR(i));
 		ndev->mw[i].vbase =
 		    ioremap_wc(pci_resource_start(pdev, MW_TO_BAR(i)),
@@ -1155,7 +1228,7 @@ static void ntb_pci_remove(struct pci_dev *pdev)
 	ntb_free_callbacks(ndev);
 	ntb_device_free(ndev);
 
-	for (i = 0; i < NTB_NUM_MW; i++)
+	for (i = 0; i < NTB_MAX_NUM_MW; i++)
 		iounmap(ndev->mw[i].vbase);
 
 	iounmap(ndev->reg_base);
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 6a4f56f..72fcb22 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -68,7 +68,7 @@
 
 #define NTB_HB_TIMEOUT		msecs_to_jiffies(1000)
 
-#define NTB_NUM_MW		2
+#define NTB_MAX_NUM_MW		2
 
 enum ntb_hw_event {
 	NTB_EVENT_SW_EVENT0 = 0,
@@ -96,11 +96,12 @@ struct ntb_device {
 	struct pci_dev *pdev;
 	struct msix_entry *msix_entries;
 	void __iomem *reg_base;
-	struct ntb_mw mw[NTB_NUM_MW];
+	struct ntb_mw mw[NTB_MAX_NUM_MW];
 	struct {
-		unsigned int max_spads;
-		unsigned int max_db_bits;
-		unsigned int msix_cnt;
+		unsigned char max_mw;
+		unsigned char max_spads;
+		unsigned char max_db_bits;
+		unsigned char msix_cnt;
 	} limits;
 	struct {
 		void __iomem *pdb;
@@ -132,6 +133,32 @@ struct ntb_device {
 };
 
 /**
+ * ntb_max_cbs() - return the max callbacks
+ * @ndev: pointer to ntb_device instance
+ *
+ * Given the ntb pointer, return the maximum number of callbacks
+ *
+ * RETURNS: the maximum number of callbacks
+ */
+static inline unsigned char ntb_max_cbs(struct ntb_device *ndev)
+{
+	return ndev->max_cbs;
+}
+
+/**
+ * ntb_max_mw() - return the max number of memory windows
+ * @ndev: pointer to ntb_device instance
+ *
+ * Given the ntb pointer, return the maximum number of memory windows
+ *
+ * RETURNS: the maximum number of memory windows
+ */
+static inline unsigned char ntb_max_mw(struct ntb_device *ndev)
+{
+	return ndev->limits.max_mw;
+}
+
+/**
  * ntb_hw_link_status() - return the hardware link status
  * @ndev: pointer to ntb_device instance
  *
@@ -148,7 +175,7 @@ static inline bool ntb_hw_link_status(struct ntb_device *ndev)
  * ntb_query_pdev() - return the pci_dev pointer
  * @ndev: pointer to ntb_device instance
  *
- * Given the ntb pointer return the pci_dev pointerfor the NTB hardware device
+ * Given the ntb pointer, return the pci_dev pointer for the NTB hardware device
  *
  * RETURNS: a pointer to the ntb pci_dev
  */
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index 96209b4..4fe135a 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -58,6 +58,8 @@
 /* Reserve the uppermost bit for link interrupt */
 #define SNB_MAX_DB_BITS		15
 #define SNB_DB_BITS_PER_VEC	5
+#define SNB_MAX_MW		2
+#define SNB_ERRATA_MAX_MW	1
 
 #define SNB_DB_HW_LINK		0x8000
 
@@ -74,6 +76,9 @@
 #define SNB_SBAR2XLAT_OFFSET	0x0030
 #define SNB_SBAR4XLAT_OFFSET	0x0038
 #define SNB_SBAR0BASE_OFFSET	0x0040
+#define SNB_SBAR0BASE_OFFSET	0x0040
+#define SNB_SBAR2BASE_OFFSET	0x0048
+#define SNB_SBAR4BASE_OFFSET	0x0050
 #define SNB_SBAR2BASE_OFFSET	0x0048
 #define SNB_SBAR4BASE_OFFSET	0x0050
 #define SNB_NTBCNTL_OFFSET	0x0058
@@ -90,11 +95,19 @@
 #define SNB_B2B_DOORBELL_OFFSET	0x0140
 #define SNB_B2B_XLAT_OFFSET	0x0144
 
+#define SNB_MBAR01_USD_ADDR	0x000000000000000CULL
+#define SNB_MBAR23_USD_ADDR	0x000000410000000CULL
+#define SNB_MBAR45_USD_ADDR	0x000000810000000CULL
+#define SNB_MBAR01_DSD_ADDR	0x000000000000000CULL
+#define SNB_MBAR23_DSD_ADDR	0x000000400000000CULL
+#define SNB_MBAR45_DSD_ADDR	0x000000800000000CULL
+
 #define BWD_MSIX_CNT		34
 #define BWD_MAX_SPADS		16
 #define BWD_MAX_COMPAT_SPADS	16
 #define BWD_MAX_DB_BITS		34
 #define BWD_DB_BITS_PER_VEC	1
+#define BWD_MAX_MW		2
 
 #define BWD_PCICMD_OFFSET	0xb004
 #define BWD_MBAR23_OFFSET	0xb018
@@ -128,12 +141,3 @@
 #define BWD_PPD_INIT_LINK	0x0008
 #define BWD_PPD_CONN_TYPE	0x0300
 #define BWD_PPD_DEV_TYPE	0x1000
-
-#define BWD_PBAR2XLAT_USD_ADDR	0x0000004000000000
-#define BWD_PBAR4XLAT_USD_ADDR	0x0000008000000000
-#define BWD_MBAR23_USD_ADDR	0x000000410000000C
-#define BWD_MBAR45_USD_ADDR	0x000000810000000C
-#define BWD_PBAR2XLAT_DSD_ADDR	0x0000004100000000
-#define BWD_PBAR4XLAT_DSD_ADDR	0x0000008100000000
-#define BWD_MBAR23_DSD_ADDR	0x000000400000000C
-#define BWD_MBAR45_DSD_ADDR	0x000000800000000C
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index c308915..f7380e9 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -64,7 +64,7 @@ static unsigned int transport_mtu = 0x401E;
 module_param(transport_mtu, uint, 0644);
 MODULE_PARM_DESC(transport_mtu, "Maximum size of NTB transport packets");
 
-static unsigned char max_num_clients = 2;
+static unsigned char max_num_clients;
 module_param(max_num_clients, byte, 0644);
 MODULE_PARM_DESC(max_num_clients, "Maximum number of NTB transport clients");
 
@@ -150,7 +150,7 @@ struct ntb_transport {
 	struct list_head client_devs;
 
 	struct ntb_device *ndev;
-	struct ntb_transport_mw mw[NTB_NUM_MW];
+	struct ntb_transport_mw *mw;
 	struct ntb_transport_qp *qps;
 	unsigned int max_qps;
 	unsigned long qp_bitmap;
@@ -182,7 +182,7 @@ enum {
 	MAX_SPAD,
 };
 
-#define QP_TO_MW(qp)		((qp) % NTB_NUM_MW)
+#define QP_TO_MW(ndev, qp)	((qp) % ntb_max_mw(ndev))
 #define NTB_QP_DEF_NUM_ENTRIES	100
 #define NTB_LINK_DOWN_TIMEOUT	10
 
@@ -474,19 +474,22 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
 {
 	struct ntb_transport_qp *qp = &nt->qps[qp_num];
 	unsigned int rx_size, num_qps_mw;
-	u8 mw_num = QP_TO_MW(qp_num);
+	u8 mw_num, mw_max;
 	unsigned int i;
 
+	mw_max = ntb_max_mw(nt->ndev);
+	mw_num = QP_TO_MW(nt->ndev, qp_num);
+
 	WARN_ON(nt->mw[mw_num].virt_addr == NULL);
 
-	if (nt->max_qps % NTB_NUM_MW && mw_num < nt->max_qps % NTB_NUM_MW)
-		num_qps_mw = nt->max_qps / NTB_NUM_MW + 1;
+	if (nt->max_qps % mw_max && mw_num < nt->max_qps % mw_max)
+		num_qps_mw = nt->max_qps / mw_max + 1;
 	else
-		num_qps_mw = nt->max_qps / NTB_NUM_MW;
+		num_qps_mw = nt->max_qps / mw_max;
 
 	rx_size = (unsigned int) nt->mw[mw_num].size / num_qps_mw;
 	qp->remote_rx_info = nt->mw[mw_num].virt_addr +
-			     (qp_num / NTB_NUM_MW * rx_size);
+			     (qp_num / mw_max * rx_size);
 	rx_size -= sizeof(struct ntb_rx_info);
 
 	qp->rx_buff = qp->remote_rx_info + 1;
@@ -630,7 +633,7 @@ static void ntb_transport_link_work(struct work_struct *work)
 	int rc, i;
 
 	/* send the local info, in the opposite order of the way we read it */
-	for (i = 0; i < NTB_NUM_MW; i++) {
+	for (i = 0; i < ntb_max_mw(ndev); i++) {
 		rc = ntb_write_remote_spad(ndev, MW0_SZ_HIGH + (i * 2),
 					   ntb_get_mw_size(ndev, i) >> 32);
 		if (rc) {
@@ -650,10 +653,10 @@ static void ntb_transport_link_work(struct work_struct *work)
 		}
 	}
 
-	rc = ntb_write_remote_spad(ndev, NUM_MWS, NTB_NUM_MW);
+	rc = ntb_write_remote_spad(ndev, NUM_MWS, ntb_max_mw(ndev));
 	if (rc) {
 		dev_err(&pdev->dev, "Error writing %x to remote spad %d\n",
-			NTB_NUM_MW, NUM_MWS);
+			ntb_max_mw(ndev), NUM_MWS);
 		goto out;
 	}
 
@@ -698,11 +701,11 @@ static void ntb_transport_link_work(struct work_struct *work)
 		goto out;
 	}
 
-	if (val != NTB_NUM_MW)
+	if (val != ntb_max_mw(ndev))
 		goto out;
 	dev_dbg(&pdev->dev, "Remote number of mws = %d\n", val);
 
-	for (i = 0; i < NTB_NUM_MW; i++) {
+	for (i = 0; i < ntb_max_mw(ndev); i++) {
 		u64 val64;
 
 		rc = ntb_read_remote_spad(ndev, MW0_SZ_HIGH + (i * 2), &val);
@@ -744,7 +747,7 @@ static void ntb_transport_link_work(struct work_struct *work)
 	return;
 
 out1:
-	for (i = 0; i < NTB_NUM_MW; i++)
+	for (i = 0; i < ntb_max_mw(ndev); i++)
 		ntb_free_mw(nt, i);
 out:
 	if (ntb_hw_link_status(ndev))
@@ -798,7 +801,10 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 {
 	struct ntb_transport_qp *qp;
 	unsigned int num_qps_mw, tx_size;
-	u8 mw_num = QP_TO_MW(qp_num);
+	u8 mw_num, mw_max;
+
+	mw_max = ntb_max_mw(nt->ndev);
+	mw_num = QP_TO_MW(nt->ndev, qp_num);
 
 	qp = &nt->qps[qp_num];
 	qp->qp_num = qp_num;
@@ -808,14 +814,14 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 	qp->client_ready = NTB_LINK_DOWN;
 	qp->event_handler = NULL;
 
-	if (nt->max_qps % NTB_NUM_MW && mw_num < nt->max_qps % NTB_NUM_MW)
-		num_qps_mw = nt->max_qps / NTB_NUM_MW + 1;
+	if (nt->max_qps % mw_max && mw_num < nt->max_qps % mw_max)
+		num_qps_mw = nt->max_qps / mw_max + 1;
 	else
-		num_qps_mw = nt->max_qps / NTB_NUM_MW;
+		num_qps_mw = nt->max_qps / mw_max;
 
 	tx_size = (unsigned int) ntb_get_mw_size(qp->ndev, mw_num) / num_qps_mw;
 	qp->rx_info = ntb_get_mw_vbase(nt->ndev, mw_num) +
-		      (qp_num / NTB_NUM_MW * tx_size);
+		      (qp_num / mw_max * tx_size);
 	tx_size -= sizeof(struct ntb_rx_info);
 
 	qp->tx_mw = qp->rx_info + 1;
@@ -862,13 +868,23 @@ int ntb_transport_init(struct pci_dev *pdev)
 		goto err;
 	}
 
-	nt->max_qps = min(nt->ndev->max_cbs, max_num_clients);
+	nt->mw = kcalloc(ntb_max_mw(nt->ndev), sizeof(struct ntb_transport_mw),
+			 GFP_KERNEL);
+	if (!nt->mw) {
+		rc = -ENOMEM;
+		goto err1;
+	}
+
+	if (max_num_clients)
+		nt->max_qps = min(ntb_max_cbs(nt->ndev), max_num_clients);
+	else
+		nt->max_qps = min(ntb_max_cbs(nt->ndev), ntb_max_mw(nt->ndev));
 
 	nt->qps = kcalloc(nt->max_qps, sizeof(struct ntb_transport_qp),
 			  GFP_KERNEL);
 	if (!nt->qps) {
 		rc = -ENOMEM;
-		goto err1;
+		goto err2;
 	}
 
 	nt->qp_bitmap = ((u64) 1 << nt->max_qps) - 1;
@@ -882,22 +898,24 @@ int ntb_transport_init(struct pci_dev *pdev)
 	rc = ntb_register_event_callback(nt->ndev,
 					 ntb_transport_event_callback);
 	if (rc)
-		goto err2;
+		goto err3;
 
 	INIT_LIST_HEAD(&nt->client_devs);
 	rc = ntb_bus_init(nt);
 	if (rc)
-		goto err3;
+		goto err4;
 
 	if (ntb_hw_link_status(nt->ndev))
 		schedule_delayed_work(&nt->link_work, 0);
 
 	return 0;
 
-err3:
+err4:
 	ntb_unregister_event_callback(nt->ndev);
-err2:
+err3:
 	kfree(nt->qps);
+err2:
+	kfree(nt->mw);
 err1:
 	ntb_unregister_transport(nt->ndev);
 err:
@@ -908,6 +926,7 @@ err:
 void ntb_transport_free(void *transport)
 {
 	struct ntb_transport *nt = transport;
+	struct ntb_device *ndev = nt->ndev;
 	struct pci_dev *pdev;
 	int i;
 
@@ -924,15 +943,16 @@ void ntb_transport_free(void *transport)
 
 	cancel_delayed_work_sync(&nt->link_work);
 
-	ntb_unregister_event_callback(nt->ndev);
+	ntb_unregister_event_callback(ndev);
 
-	pdev = ntb_query_pdev(nt->ndev);
+	pdev = ntb_query_pdev(ndev);
 
-	for (i = 0; i < NTB_NUM_MW; i++)
+	for (i = 0; i < ntb_max_mw(ndev); i++)
 		ntb_free_mw(nt, i);
 
 	kfree(nt->qps);
-	ntb_unregister_transport(nt->ndev);
+	kfree(nt->mw);
+	ntb_unregister_transport(ndev);
 	kfree(nt);
 }
 
-- 
1.7.9.5

