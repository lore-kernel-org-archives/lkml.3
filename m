Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaKQSAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 13:00:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:46009 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaKQSAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 13:00:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417687750"
From: "Luck, Tony" <tony.luck@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Doug Thompson <dougthompson@xmission.com>, Borislav Petkov <bp@alien8.de>,
        Aristeu Rozanski <aris@redhat.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sb_edac: Add support for Broadwell-DE processor
Date: Mon, 17 Nov 2014 10:00:11 -0800
Message-Id: <546a37ab3156619eb3@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Broadwell-DE is the microserver version of next generation Xeon
processors.  A whole bunch of new PCIe device ids, but otherwise
pretty much the same as Haswell.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

Mauro: Naming of routines and #defines follows the existing
convention of only making new functions where changes are
needed, and using older functions with names from previous
generations where no changes are needed.  Can you take this
as-is for the next merge window and we can have a discussion
about whether to have a massive re-naming to some "better"
nomenclature in the coming months.  More changes will be
needed for Broadwell-EP and Broadwell-EX

Also needs that Haswell TOLM fix I posted in October:
  http://www.spinics.net/lists/linux-edac/msg04109.html#.VGo3FHW9_CI

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index e9bb1af67c8d..5a140adb5191 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -261,6 +261,7 @@ enum type {
 	SANDY_BRIDGE,
 	IVY_BRIDGE,
 	HASWELL,
+	BROADWELL,
 };
 
 struct sbridge_pvt;
@@ -445,7 +446,7 @@ static const struct pci_id_table pci_dev_descr_ibridge_table[] = {
  *	- each SMI channel interfaces with a scalable memory buffer
  *	- each scalable memory buffer supports 4 DDR3/DDR4 channels, 3 DPC
  */
-#define HASWELL_DDRCRCLKCONTROLS 0xa10
+#define HASWELL_DDRCRCLKCONTROLS 0xa10 /* Ditto on Broadwell */
 #define HASWELL_HASYSDEFEATURE2 0x84
 #define PCI_DEVICE_ID_INTEL_HASWELL_IMC_VTD_MISC 0x2f28
 #define PCI_DEVICE_ID_INTEL_HASWELL_IMC_HA0	0x2fa0
@@ -496,6 +497,44 @@ static const struct pci_id_table pci_dev_descr_haswell_table[] = {
 	{0,}			/* 0 terminated list. */
 };
 
+/* Broadwell support */
+/* DE processor:
+ *	- 1 IMC
+ *	- 2 DDR3 channels, 2 DPC per channel
+ */
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_VTD_MISC 0x6f28
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0	0x6fa0
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TA	0x6fa8
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_THERMAL 0x6f71
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD0 0x6ffc
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD1 0x6ffd
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD0 0x6faa
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD1 0x6fab
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD2 0x6fac
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD3 0x6fad
+#define PCI_DEVICE_ID_INTEL_BROADWELL_IMC_DDRIO0 0x6faf
+
+static const struct pci_id_descr pci_dev_descr_broadwell[] = {
+	/* first item must be the HA */
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0, 0)		},
+
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD0, 0)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD1, 0)	},
+
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TA, 0)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_THERMAL, 0)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD0, 0)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD1, 0)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD2, 1)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD3, 1)	},
+	{ PCI_DESCR(PCI_DEVICE_ID_INTEL_BROADWELL_IMC_DDRIO0, 1)	},
+};
+
+static const struct pci_id_table pci_dev_descr_broadwell_table[] = {
+	PCI_ID_TABLE_ENTRY(pci_dev_descr_broadwell),
+	{0,}			/* 0 terminated list. */
+};
+
 /*
  *	pci_device_id	table for which devices we are looking for
  */
@@ -503,6 +542,7 @@ static const struct pci_device_id sbridge_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IBRIDGE_IMC_HA0_TA)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_HASWELL_IMC_HA0)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0)},
 	{0,}			/* 0 terminated list. */
 };
 
@@ -767,12 +807,22 @@ static int check_if_ecc_is_active(const u8 bus, enum type type)
 	struct pci_dev *pdev = NULL;
 	u32 mcmtr, id;
 
-	if (type == IVY_BRIDGE)
+	switch (type) {
+	case IVY_BRIDGE:
 		id = PCI_DEVICE_ID_INTEL_IBRIDGE_IMC_HA0_TA;
-	else if (type == HASWELL)
+		break;
+	case HASWELL:
 		id = PCI_DEVICE_ID_INTEL_HASWELL_IMC_HA0_TA;
-	else
+		break;
+	case SANDY_BRIDGE:
 		id = PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA;
+		break;
+	case BROADWELL:
+		id = PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TA;
+		break;
+	default:
+		return -ENODEV;
+	}
 
 	pdev = get_pdev_same_bus(bus, id);
 	if (!pdev) {
@@ -800,7 +850,7 @@ static int get_dimm_config(struct mem_ctl_info *mci)
 	enum edac_type mode;
 	enum mem_type mtype;
 
-	if (pvt->info.type == HASWELL)
+	if (pvt->info.type == HASWELL || pvt->info.type == BROADWELL)
 		pci_read_config_dword(pvt->pci_sad1, SAD_TARGET, &reg);
 	else
 		pci_read_config_dword(pvt->pci_br0, SAD_TARGET, &reg);
@@ -1179,7 +1229,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		*socket = sad_interleave[idx];
 		edac_dbg(0, "SAD interleave index: %d (wayness %d) = CPU socket %d\n",
 			 idx, sad_way, *socket);
-	} else if (pvt->info.type == HASWELL) {
+	} else if (pvt->info.type == HASWELL || pvt->info.type == BROADWELL) {
 		int bits, a7mode = A7MODE(dram_rule);
 
 		if (a7mode) {
@@ -1828,6 +1878,82 @@ enodev:
 	return -ENODEV;
 }
 
+static int broadwell_mci_bind_devs(struct mem_ctl_info *mci,
+				 struct sbridge_dev *sbridge_dev)
+{
+	struct sbridge_pvt *pvt = mci->pvt_info;
+	struct pci_dev *pdev;
+	int i;
+
+	/* there's only one device per system; not tied to any bus */
+	if (pvt->info.pci_vtd == NULL)
+		/* result will be checked later */
+		pvt->info.pci_vtd = pci_get_device(PCI_VENDOR_ID_INTEL,
+						   PCI_DEVICE_ID_INTEL_BROADWELL_IMC_VTD_MISC,
+						   NULL);
+
+	for (i = 0; i < sbridge_dev->n_devs; i++) {
+		pdev = sbridge_dev->pdev[i];
+		if (!pdev)
+			continue;
+
+		switch (pdev->device) {
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD0:
+			pvt->pci_sad0 = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_CBO_SAD1:
+			pvt->pci_sad1 = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0:
+			pvt->pci_ha0 = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TA:
+			pvt->pci_ta = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_THERMAL:
+			pvt->pci_ras = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD0:
+			pvt->pci_tad[0] = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD1:
+			pvt->pci_tad[1] = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD2:
+			pvt->pci_tad[2] = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0_TAD3:
+			pvt->pci_tad[3] = pdev;
+			break;
+		case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_DDRIO0:
+			pvt->pci_ddrio = pdev;
+			break;
+		default:
+			break;
+		}
+
+		edac_dbg(0, "Associated PCI %02x.%02d.%d with dev = %p\n",
+			 sbridge_dev->bus,
+			 PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn),
+			 pdev);
+	}
+
+	/* Check if everything were registered */
+	if (!pvt->pci_sad0 || !pvt->pci_ha0 || !pvt->pci_sad1 ||
+	    !pvt->pci_ras  || !pvt->pci_ta || !pvt->info.pci_vtd)
+		goto enodev;
+
+	for (i = 0; i < NUM_CHANNELS; i++) {
+		if (!pvt->pci_tad[i])
+			goto enodev;
+	}
+	return 0;
+
+enodev:
+	sbridge_printk(KERN_ERR, "Some needed devices are missing\n");
+	return -ENODEV;
+}
+
 /****************************************************************************
 			Error check routines
  ****************************************************************************/
@@ -2240,6 +2366,25 @@ static int sbridge_register_mci(struct sbridge_dev *sbridge_dev, enum type type)
 		if (unlikely(rc < 0))
 			goto fail0;
 		break;
+	case BROADWELL:
+		/* rankcfgr isn't used */
+		pvt->info.get_tolm = haswell_get_tolm;
+		pvt->info.get_tohm = haswell_get_tohm;
+		pvt->info.dram_rule = ibridge_dram_rule;
+		pvt->info.get_memory_type = haswell_get_memory_type;
+		pvt->info.get_node_id = haswell_get_node_id;
+		pvt->info.rir_limit = haswell_rir_limit;
+		pvt->info.max_sad = ARRAY_SIZE(ibridge_dram_rule);
+		pvt->info.interleave_list = ibridge_interleave_list;
+		pvt->info.max_interleave = ARRAY_SIZE(ibridge_interleave_list);
+		pvt->info.interleave_pkg = ibridge_interleave_pkg;
+		mci->ctl_name = kasprintf(GFP_KERNEL, "Broadwell Socket#%d", mci->mc_idx);
+
+		/* Store pci devices at mci for faster access */
+		rc = broadwell_mci_bind_devs(mci, sbridge_dev);
+		if (unlikely(rc < 0))
+			goto fail0;
+		break;
 	}
 
 	/* Get dimm basic config and the memory layout */
@@ -2305,6 +2450,10 @@ static int sbridge_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		rc = sbridge_get_all_devices(&num_mc, pci_dev_descr_haswell_table);
 		type = HASWELL;
 		break;
+	case PCI_DEVICE_ID_INTEL_BROADWELL_IMC_HA0:
+		rc = sbridge_get_all_devices(&num_mc, pci_dev_descr_broadwell_table);
+		type = BROADWELL;
+		break;
 	}
 	if (unlikely(rc < 0))
 		goto fail0;
