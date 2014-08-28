Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaH1Ux5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:53:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:37273 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbaH1Uxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,420,1406617200"; 
   d="scan'208";a="473593751"
Subject: [PATCH 6/6] ntb: workaround for high traffic hardware hang
From: Dave Jiang <dave.jiang@intel.com>
To: jdmason@kudzu.us
Cc: linux-kernel@vger.kernel.org
Date: Thu, 28 Aug 2014 13:53:29 -0700
Message-ID: <20140828205329.165750.97374.stgit@djiang5-desk2.amr.corp.intel.com>
In-Reply-To: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
References: <20140828204947.165750.64364.stgit@djiang5-desk2.amr.corp.intel.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A hardware errata causes the NTB to hang when heavy bi-directional traffic
in addition to the usage of BAR0/1 (where the registers reside, including
the doorbell registers to trigger interrupts).

This workaround is only available on Haswell platform.
The workaround is to enable split BAR in the BIOS to allow the 64bit BAR4 to
be split into two 32bit BAR4 and BAR5. The BAR4 shall be pointed to LAPIC
region of the remote host. We will bypass the doorbell mechanism and directly
trigger the MSIX interrupts. The offsets and vectors are exchanged during
transport scratch pad negotiation. The scratch pads are now overloaded
in order to allow the exchange of the information. This gets around using
the doorbell and prevents the lockup with additional pcode changes in BIOS.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/ntb/ntb_hw.c        |  177 +++++++++++++++++++++++++++++++++++++------
 drivers/ntb/ntb_hw.h        |    9 ++
 drivers/ntb/ntb_regs.h      |    1 
 drivers/ntb/ntb_transport.c |  126 ++++++++++++++++++-------------
 4 files changed, 237 insertions(+), 76 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index cef9d8a..97e18c3 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -53,6 +53,8 @@
 #include <linux/pci.h>
 #include <linux/random.h>
 #include <linux/slab.h>
+#include <linux/msi.h>
+#include <linux/interrupt.h>
 #include "ntb_hw.h"
 #include "ntb_regs.h"
 
@@ -150,17 +152,19 @@ static void ntb_set_errata_flags(struct ntb_device *ndev)
 	case PCI_DEVICE_ID_INTEL_NTB_SS_JSF:
 	case PCI_DEVICE_ID_INTEL_NTB_SS_SNB:
 	case PCI_DEVICE_ID_INTEL_NTB_SS_IVT:
-	case PCI_DEVICE_ID_INTEL_NTB_SS_HSX:
 	case PCI_DEVICE_ID_INTEL_NTB_PS_JSF:
 	case PCI_DEVICE_ID_INTEL_NTB_PS_SNB:
 	case PCI_DEVICE_ID_INTEL_NTB_PS_IVT:
-	case PCI_DEVICE_ID_INTEL_NTB_PS_HSX:
 	case PCI_DEVICE_ID_INTEL_NTB_B2B_JSF:
 	case PCI_DEVICE_ID_INTEL_NTB_B2B_SNB:
 	case PCI_DEVICE_ID_INTEL_NTB_B2B_IVT:
-	case PCI_DEVICE_ID_INTEL_NTB_B2B_HSX:
 		ndev->wa_flags |= WA_SNB_ERR;
 		break;
+	case PCI_DEVICE_ID_INTEL_NTB_SS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_PS_HSX:
+	case PCI_DEVICE_ID_INTEL_NTB_B2B_HSX:
+		ndev->wa_flags |= WA_HSX_ERR;
+		break;
 	}
 }
 
@@ -209,9 +213,13 @@ static void ntb_irq_work(unsigned long data)
 		struct ntb_device *ndev = db_cb->ndev;
 		unsigned long mask;
 
-		mask = readw(ndev->reg_ofs.ldb_mask);
-		clear_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
-		writew(mask, ndev->reg_ofs.ldb_mask);
+		if (ndev->wa_flags & WA_HSX_ERR)
+			enable_irq(db_cb->irq);
+		else {
+			mask = readw(ndev->reg_ofs.ldb_mask);
+			clear_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
+			writew(mask, ndev->reg_ofs.ldb_mask);
+		}
 	}
 }
 
@@ -246,9 +254,12 @@ int ntb_register_db_callback(struct ntb_device *ndev, unsigned int idx,
 		     (unsigned long) &ndev->db_cb[idx]);
 
 	/* unmask interrupt */
-	mask = readw(ndev->reg_ofs.ldb_mask);
-	clear_bit(idx * ndev->bits_per_vector, &mask);
-	writew(mask, ndev->reg_ofs.ldb_mask);
+	if (!(ndev->wa_flags & WA_HSX_ERR)) {
+		/* unmask interrupt */
+		mask = readw(ndev->reg_ofs.ldb_mask);
+		clear_bit(idx * ndev->bits_per_vector, &mask);
+		writew(mask, ndev->reg_ofs.ldb_mask);
+	}
 
 	return 0;
 }
@@ -268,9 +279,11 @@ void ntb_unregister_db_callback(struct ntb_device *ndev, unsigned int idx)
 	if (idx >= ndev->max_cbs || !ndev->db_cb[idx].callback)
 		return;
 
-	mask = readw(ndev->reg_ofs.ldb_mask);
-	set_bit(idx * ndev->bits_per_vector, &mask);
-	writew(mask, ndev->reg_ofs.ldb_mask);
+	if (!(ndev->wa_flags & WA_HSX_ERR)) {
+		mask = readw(ndev->reg_ofs.ldb_mask);
+		set_bit(idx * ndev->bits_per_vector, &mask);
+		writew(mask, ndev->reg_ofs.ldb_mask);
+	}
 
 	tasklet_disable(&ndev->db_cb[idx].irq_work);
 
@@ -518,6 +531,17 @@ void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 	}
 }
 
+static void ntb_generate_rirq(struct ntb_device *ndev, int vec)
+{
+	if (vec > 2) {
+		dev_err(&ndev->pdev->dev, "%s: vec %d out of bounds\n",
+			__func__, vec);
+		return;
+	}
+
+	writel(ndev->rirq[vec].data, ndev->mw[1].vbase + ndev->rirq[vec].ofs);
+}
+
 /**
  * ntb_ring_doorbell() - Set the doorbell on the secondary/external side
  * @ndev: pointer to ntb_device instance
@@ -532,7 +556,9 @@ void ntb_ring_doorbell(struct ntb_device *ndev, unsigned int db)
 {
 	dev_dbg(&ndev->pdev->dev, "%s: ringing doorbell %d\n", __func__, db);
 
-	if (ndev->hw_type == BWD_HW)
+	if (ndev->wa_flags & WA_HSX_ERR)
+		ntb_generate_rirq(ndev, db);
+	else if (ndev->hw_type == BWD_HW)
 		writeq((u64) 1 << db, ndev->reg_ofs.rdb);
 	else
 		writew(((1 << ndev->bits_per_vector) - 1) <<
@@ -794,7 +820,26 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 			 * the driver defaults, but write the Limit registers
 			 * first just in case.
 			 */
-			if (ndev->split_bar)
+			if (ndev->wa_flags & WA_HSX_ERR) {
+				/* using BAR4, must be set to 1M */
+				if (ndev->mw[1].bar_sz != 0x100000) {
+					dev_err(&ndev->pdev->dev,
+						"BAR4 must be 1M\n");
+					return -EINVAL;
+				}
+
+				/* set limit to 1M according to spec */
+				writel(pci_resource_start(ndev->pdev, 1) + 0x100000,
+				       ndev->reg_base + SNB_PBAR4LMT_OFFSET);
+				/*
+				 * need to point SBAR4XLAT to remote
+				 * interrupt region
+				 */
+				writel(0xfee00000,
+				       ndev->reg_base + SNB_SBAR4XLAT_OFFSET);
+
+				ndev->limits.max_mw = HSX_ERRATA_MAX_MW;
+			} else if (ndev->split_bar)
 				ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
 			else
 				ndev->limits.max_mw = SNB_MAX_MW;
@@ -911,7 +956,22 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		if (ndev->split_bar) {
 			ndev->reg_ofs.bar5_xlat =
 				ndev->reg_base + SNB_SBAR5XLAT_OFFSET;
-			ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
+
+			if (ndev->wa_flags & WA_HSX_ERR) {
+				/* using BAR4, must be set to 1M */
+				if (ndev->mw[1].bar_sz != 0x100000) {
+					dev_err(&ndev->pdev->dev,
+						"BAR4 must be 1M\n");
+					return -EINVAL;
+				}
+
+				/* set limit to 1M according to spec */
+				writel(pci_resource_start(ndev->pdev, 1) + 0x100000,
+				       ndev->reg_base + SNB_PBAR4LMT_OFFSET);
+				writel(0xfee00000, ndev->reg_ofs.bar4_xlat);
+				ndev->limits.max_mw = HSX_ERRATA_MAX_MW;
+			} else
+				ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
 		} else
 			ndev->limits.max_mw = SNB_MAX_MW;
 		break;
@@ -943,7 +1003,22 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 		if (ndev->split_bar) {
 			ndev->reg_ofs.bar5_xlat =
 				ndev->reg_base + SNB_PBAR5XLAT_OFFSET;
-			ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
+
+			if (ndev->wa_flags & WA_HSX_ERR) {
+				/* using BAR4, must be set to 1M */
+				if (ndev->mw[1].bar_sz != 0x100000) {
+					dev_err(&ndev->pdev->dev,
+						"BAR4 must be 1M\n");
+					return -EINVAL;
+				}
+
+				/* set limit to 1M according to spec */
+				writel(pci_resource_start(ndev->pdev, 1) + 0x100000,
+				       ndev->reg_base + SNB_PBAR4LMT_OFFSET);
+				writel(0xfee00000, ndev->reg_ofs.bar4_xlat);
+				ndev->limits.max_mw = HSX_ERRATA_MAX_MW;
+			} else
+				ndev->limits.max_mw = HSX_SPLITBAR_MAX_MW;
 		} else
 			ndev->limits.max_mw = SNB_MAX_MW;
 		break;
@@ -1085,9 +1160,14 @@ static irqreturn_t xeon_callback_msix_irq(int irq, void *data)
 	dev_dbg(&ndev->pdev->dev, "MSI-X irq %d received for DB %d\n", irq,
 		db_cb->db_num);
 
-	mask = readw(ndev->reg_ofs.ldb_mask);
-	set_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
-	writew(mask, ndev->reg_ofs.ldb_mask);
+	if (ndev->wa_flags & WA_HSX_ERR) {
+		disable_irq_nosync(irq);
+		db_cb->irq = irq;
+	} else {
+		mask = readw(ndev->reg_ofs.ldb_mask);
+		set_bit(db_cb->db_num * ndev->bits_per_vector, &mask);
+		writew(mask, ndev->reg_ofs.ldb_mask);
+	}
 
 	tasklet_schedule(&db_cb->irq_work);
 
@@ -1096,8 +1176,11 @@ static irqreturn_t xeon_callback_msix_irq(int irq, void *data)
 	 * vectors, with the 4th having a single bit for link
 	 * interrupts.
 	 */
-	writew(((1 << ndev->bits_per_vector) - 1) <<
-	       (db_cb->db_num * ndev->bits_per_vector), ndev->reg_ofs.ldb);
+	if (!(ndev->wa_flags & WA_HSX_ERR)) {
+		writew(((1 << ndev->bits_per_vector) - 1) <<
+			(db_cb->db_num * ndev->bits_per_vector),
+			ndev->reg_ofs.ldb);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -1160,6 +1243,9 @@ static int ntb_setup_snb_msix(struct ntb_device *ndev, int msix_entries)
 	struct pci_dev *pdev = ndev->pdev;
 	struct msix_entry *msix;
 	int rc, i;
+	struct msi_desc *entry;
+	u32 laddr = 0;
+	u32 data = 0;
 
 	if (msix_entries < ndev->limits.msix_cnt)
 		return -ENOSPC;
@@ -1191,6 +1277,31 @@ static int ntb_setup_snb_msix(struct ntb_device *ndev, int msix_entries)
 	ndev->num_msix = msix_entries;
 	ndev->max_cbs = msix_entries - 1;
 
+	if (ndev->wa_flags & WA_HSX_ERR) {
+		i = 0;
+
+		/*
+		 * acquire the interrupt region in the LAPIC for the
+		 * MSIX vectors
+		 */
+		list_for_each_entry(entry, &pdev->msi_list, list) {
+			unsigned int offset = ndev->msix_entries[i].entry *
+				PCI_MSIX_ENTRY_SIZE;
+
+			laddr = readl(entry->mask_base + offset +
+					PCI_MSIX_ENTRY_LOWER_ADDR);
+			dev_dbg(&pdev->dev, "local lower MSIX addr(%d): %#x\n",
+				i, laddr);
+			ndev->lirq[i].ofs = 0x1fffff & laddr;
+			data = readl(entry->mask_base + offset +
+					PCI_MSIX_ENTRY_DATA);
+			dev_dbg(&pdev->dev, "local MSIX data(%d): %#x\n",
+				i, data);
+			ndev->lirq[i].data = data;
+			i++;
+		}
+	}
+
 	return 0;
 
 err:
@@ -1288,6 +1399,11 @@ static int ntb_setup_msi(struct ntb_device *ndev)
 	struct pci_dev *pdev = ndev->pdev;
 	int rc;
 
+	if (ndev->wa_flags & WA_HSX_ERR) {
+		dev_err(&pdev->dev, "Platform errata does not support MSI\n");
+		return -EINVAL;
+	}
+
 	rc = pci_enable_msi(pdev);
 	if (rc)
 		return rc;
@@ -1307,6 +1423,11 @@ static int ntb_setup_intx(struct ntb_device *ndev)
 	struct pci_dev *pdev = ndev->pdev;
 	int rc;
 
+	if (ndev->wa_flags & WA_HSX_ERR) {
+		dev_err(&pdev->dev, "Platform errata does not support INTX\n");
+		return -EINVAL;
+	}
+
 	pci_msi_off(pdev);
 
 	/* Verify intx is enabled */
@@ -1720,6 +1841,17 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (rc)
 		goto err;
 
+	if (!ndev->split_bar && (ndev->wa_flags & WA_HSX_ERR)) {
+		dev_warn(&pdev->dev,
+			 "Please config NTB split BAR for errata workaround\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * From this point on we will assume that split BAR is set when
+	 * WA_HSX_ERR is set
+	 */
+
 	ndev->mw = kcalloc(sizeof(struct ntb_mw), ndev->limits.max_mw,
 			   GFP_KERNEL);
 	if (!ndev->mw) {
@@ -1751,8 +1883,7 @@ static int ntb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 * with the errata we need to steal last of the memory
 		 * windows for workarounds and they point to MMIO registers.
 		 */
-		if ((ndev->wa_flags & WA_SNB_ERR) &&
-		    (i == (ndev->limits.max_mw - 1))) {
+		if ((ndev->wa_flags & (WA_SNB_ERR | WA_HSX_ERR)) && (i > 0)) {
 			ndev->mw[i].vbase =
 				ioremap_nocache(pci_resource_start(pdev,
 							MW_TO_BAR(i)),
diff --git a/drivers/ntb/ntb_hw.h b/drivers/ntb/ntb_hw.h
index 96de5fc..d59650e 100644
--- a/drivers/ntb/ntb_hw.h
+++ b/drivers/ntb/ntb_hw.h
@@ -109,9 +109,16 @@ struct ntb_db_cb {
 	void *data;
 	struct ntb_device *ndev;
 	struct tasklet_struct irq_work;
+	unsigned int irq;
+};
+
+struct msix_info {
+	u32 ofs;
+	u32 data;
 };
 
 #define WA_SNB_ERR	0x00000001
+#define WA_HSX_ERR	0x00000002
 
 struct ntb_device {
 	struct pci_dev *pdev;
@@ -161,6 +168,8 @@ struct ntb_device {
 	struct dentry *debugfs_info;
 
 	unsigned int wa_flags;
+	struct msix_info lirq[4];
+	struct msix_info rirq[4];
 };
 
 /**
diff --git a/drivers/ntb/ntb_regs.h b/drivers/ntb/ntb_regs.h
index f028ff8..7eb1440 100644
--- a/drivers/ntb/ntb_regs.h
+++ b/drivers/ntb/ntb_regs.h
@@ -60,6 +60,7 @@
 #define HSX_SPLITBAR_MAX_MW	3
 #define SNB_MAX_MW		2
 #define SNB_ERRATA_MAX_MW	1
+#define HSX_ERRATA_MAX_MW	1
 
 #define SNB_DB_HW_LINK		0x8000
 
diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 24f0ac1..7ab4d63 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -56,6 +56,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/types.h>
+#include <linux/sched.h>
 #include "ntb_hw.h"
 
 #define NTB_TRANSPORT_VERSION	3
@@ -188,15 +189,24 @@ struct ntb_payload_header {
 	unsigned int flags;
 };
 
+/*
+ * Using 7 scratch pads, 1 left
+ * VERSION
+ * QP_LINKS
+ * NUM_QPS NUM_MWS
+ * MW0_SZ MW1_SZ MW2_SZ MW3_SZ
+ * DATA0 MSIX_OFS0
+ * DATA1 MSIX_OFS1
+ * DATA2 MSIX_OFS2
+ */
 enum {
 	VERSION = 0,
 	QP_LINKS,
-	NUM_QPS,
 	NUM_MWS,
-	MW0_SZ_HIGH,
-	MW0_SZ_LOW,
-	MW1_SZ_HIGH,
-	MW1_SZ_LOW,
+	MW_SZ,
+	MSIX_OFS0,
+	MSIX_OFS1,
+	MSIX_OFS2,
 	MAX_SPAD,
 };
 
@@ -687,37 +697,45 @@ static void ntb_transport_link_work(struct work_struct *work)
 	int rc, i;
 
 	/* send the local info, in the opposite order of the way we read it */
-	for (i = 0; i < ntb_max_mw(ndev); i++) {
-		rc = ntb_write_remote_spad(ndev, MW0_SZ_HIGH + (i * 2),
-					   ntb_get_mw_size(ndev, i) >> 32);
-		if (rc) {
-			dev_err(&pdev->dev, "Error writing %u to remote spad %d\n",
-				(u32)(ntb_get_mw_size(ndev, i) >> 32),
-				MW0_SZ_HIGH + (i * 2));
-			goto out;
-		}
 
-		rc = ntb_write_remote_spad(ndev, MW0_SZ_LOW + (i * 2),
-					   (u32) ntb_get_mw_size(ndev, i));
+	for (i = 0; i < 3; i++) {
+		val = (ndev->lirq[i].ofs & 0x1fffff) |
+		      (ndev->lirq[i].data & 0xff) << 24;
+
+		rc = ntb_write_remote_spad(ndev, MSIX_OFS0 + i, val);
 		if (rc) {
-			dev_err(&pdev->dev, "Error writing %u to remote spad %d\n",
-				(u32) ntb_get_mw_size(ndev, i),
-				MW0_SZ_LOW + (i * 2));
+			dev_err(&pdev->dev, "Error writing %x to remote spad %d\n",
+				val, MSIX_OFS0 + i);
 			goto out;
 		}
 	}
 
-	rc = ntb_write_remote_spad(ndev, NUM_MWS, ntb_max_mw(ndev));
+	if (ntb_max_mw(ndev) > 4) {
+		dev_err(&pdev->dev,
+			"Greater than 4 memory window unsupported!\n");
+		goto out;
+	}
+
+	val = 0;
+	for (i = 0; i < ntb_max_mw(ndev); i++) {
+		u32 size;
+
+		size = ilog2(rounddown_pow_of_two(ntb_get_mw_size(ndev, i)));
+		val |= (size & 0xff) << (8 * i);
+	}
+
+	rc = ntb_write_remote_spad(ndev, MW_SZ, val);
 	if (rc) {
-		dev_err(&pdev->dev, "Error writing %x to remote spad %d\n",
-			ntb_max_mw(ndev), NUM_MWS);
+		dev_err(&pdev->dev, "Error writing %#x to remote spad %d\n",
+			val, MW_SZ);
 		goto out;
 	}
 
-	rc = ntb_write_remote_spad(ndev, NUM_QPS, nt->max_qps);
+	val = (ntb_max_mw(ndev) & 0xffff) | (nt->max_qps & 0xffff) << 16;
+	rc = ntb_write_remote_spad(ndev, NUM_MWS, val);
 	if (rc) {
-		dev_err(&pdev->dev, "Error writing %x to remote spad %d\n",
-			nt->max_qps, NUM_QPS);
+		dev_err(&pdev->dev, "Error writing %#x to remote spad %d\n",
+			val, NUM_MWS);
 		goto out;
 	}
 
@@ -739,46 +757,31 @@ static void ntb_transport_link_work(struct work_struct *work)
 		goto out;
 	dev_dbg(&pdev->dev, "Remote version = %d\n", val);
 
-	rc = ntb_read_remote_spad(ndev, NUM_QPS, &val);
-	if (rc) {
-		dev_err(&pdev->dev, "Error reading remote spad %d\n", NUM_QPS);
-		goto out;
-	}
-
-	if (val != nt->max_qps)
-		goto out;
-	dev_dbg(&pdev->dev, "Remote max number of qps = %d\n", val);
-
 	rc = ntb_read_remote_spad(ndev, NUM_MWS, &val);
 	if (rc) {
 		dev_err(&pdev->dev, "Error reading remote spad %d\n", NUM_MWS);
 		goto out;
 	}
 
-	if (val != ntb_max_mw(ndev))
+	if (((val >> 16) & 0xffff) != nt->max_qps)
 		goto out;
-	dev_dbg(&pdev->dev, "Remote number of mws = %d\n", val);
 
-	for (i = 0; i < ntb_max_mw(ndev); i++) {
-		u64 val64;
+	dev_dbg(&pdev->dev, "Remote max number of qps = %d\n",
+		(val >> 16) & 0xffff);
 
-		rc = ntb_read_remote_spad(ndev, MW0_SZ_HIGH + (i * 2), &val);
-		if (rc) {
-			dev_err(&pdev->dev, "Error reading remote spad %d\n",
-				MW0_SZ_HIGH + (i * 2));
-			goto out1;
-		}
+	if ((val & 0xffff) != ntb_max_mw(ndev))
+		goto out;
 
-		val64 = (u64) val << 32;
+	dev_dbg(&pdev->dev, "Remote number of mws = %d\n", val & 0xffff);
 
-		rc = ntb_read_remote_spad(ndev, MW0_SZ_LOW + (i * 2), &val);
-		if (rc) {
-			dev_err(&pdev->dev, "Error reading remote spad %d\n",
-				MW0_SZ_LOW + (i * 2));
-			goto out1;
-		}
+	rc = ntb_read_remote_spad(ndev, MW_SZ, &val);
+	if (rc) {
+		dev_err(&pdev->dev, "Error reading remote spad %d\n", MW_SZ);
+		goto out1;
+	}
 
-		val64 |= val;
+	for (i = 0; i < ntb_max_mw(ndev); i++) {
+		u64 val64 = 1 << ((val >> (i * 8)) & 0xff);
 
 		dev_dbg(&pdev->dev, "Remote MW%d size = %llu\n", i, val64);
 
@@ -787,6 +790,23 @@ static void ntb_transport_link_work(struct work_struct *work)
 			goto out1;
 	}
 
+	for (i = 0; i < 3; i++) {
+		rc = ntb_read_remote_spad(ndev, MSIX_OFS0 + i, &val);
+		if (rc) {
+			dev_err(&pdev->dev,
+				"Error reading remote spad %d\n",
+				MSIX_OFS0 + i);
+			goto out;
+		}
+
+		ndev->rirq[i].ofs = 0x1ffff & val;
+		ndev->rirq[i].data = (val >> 24) & 0xff;
+		dev_dbg(&pdev->dev, "received MSIX_OFS%d: %#x\n",
+			i, ndev->rirq[i].ofs);
+		dev_dbg(&pdev->dev, "received MSIX_DATA%d: %#x\n",
+			i, ndev->rirq[i].data);
+	}
+
 	nt->transport_link = NTB_LINK_UP;
 
 	for (i = 0; i < nt->max_qps; i++) {

