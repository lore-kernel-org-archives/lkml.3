Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161711Ab3BONKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:10:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936004Ab3BOMpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 09/13] ghes_edac: do a better job of filling EDAC DIMM info
Date: Fri, 15 Feb 2013 10:44:57 -0200
Message-Id: <c471acafbc7362b9a9ffbdad25785916e8ea8873.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of just faking a random value for the DIMM data, get
the information that it is available via DMI table.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 192 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 180 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 52625b5..7bd7161 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -1,5 +1,6 @@
 #include <acpi/ghes.h>
 #include <linux/edac.h>
+#include <linux/dmi.h>
 #include "edac_core.h"
 
 #define GHES_PFX   "ghes_edac: "
@@ -8,6 +9,155 @@
 static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
+/* Memory Device - Type 17 of SMBIOS spec */
+struct memdev_dmi_entry {
+	u8 type;
+	u8 length;
+	u16 handle;
+	u16 phys_mem_array_handle;
+	u16 mem_err_info_handle;
+	u16 total_width;
+	u16 data_width;
+	u16 size;
+	u8 form_factor;
+	u8 device_set;
+	u8 device_locator;
+	u8 bank_locator;
+	u8 memory_type;
+	u16 type_detail;
+	u16 speed;
+	u8 manufacturer;
+	u8 serial_number;
+	u8 asset_tag;
+	u8 part_number;
+	u8 attributes;
+	u32 extended_size;
+	u16 conf_mem_clk_speed;
+} __attribute__((__packed__));
+
+struct ghes_edac_dimm_fill {
+	struct mem_ctl_info *mci;
+	unsigned count;
+};
+
+char *memory_type[] = {
+	[MEM_EMPTY] = "EMPTY",
+	[MEM_RESERVED] = "RESERVED",
+	[MEM_UNKNOWN] = "UNKNOWN",
+	[MEM_FPM] = "FPM",
+	[MEM_EDO] = "EDO",
+	[MEM_BEDO] = "BEDO",
+	[MEM_SDR] = "SDR",
+	[MEM_RDR] = "RDR",
+	[MEM_DDR] = "DDR",
+	[MEM_RDDR] = "RDDR",
+	[MEM_RMBS] = "RMBS",
+	[MEM_DDR2] = "DDR2",
+	[MEM_FB_DDR2] = "FB_DDR2",
+	[MEM_RDDR2] = "RDDR2",
+	[MEM_XDR] = "XDR",
+	[MEM_DDR3] = "DDR3",
+	[MEM_RDDR3] = "RDDR3",
+};
+
+static void ghes_edac_count_dimms(const struct dmi_header *dh, void *arg)
+{
+	int *num_dimm = arg;
+
+	if (dh->type == DMI_ENTRY_MEM_DEVICE)
+		(*num_dimm)++;
+}
+
+static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
+{
+	struct ghes_edac_dimm_fill *dimm_fill = arg;
+	struct mem_ctl_info *mci = dimm_fill->mci;
+
+	if (dh->type == DMI_ENTRY_MEM_DEVICE) {
+		struct memdev_dmi_entry *entry = (struct memdev_dmi_entry *)dh;
+		struct dimm_info *dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
+						       mci->n_layers,
+						       dimm_fill->count, 0, 0);
+
+		if (entry->size == 0xffff) {
+			pr_info(GHES_PFX "Can't get dimm size\n");
+			dimm->nr_pages = MiB_TO_PAGES(32);/* Unknown */
+		} else if (entry->size == 0x7fff) {
+			dimm->nr_pages = MiB_TO_PAGES(entry->extended_size);
+		} else {
+			if (entry->size & 1 << 15)
+				dimm->nr_pages = MiB_TO_PAGES((entry->size &
+							       0x7fff) << 10);
+			else
+				dimm->nr_pages = MiB_TO_PAGES(entry->size);
+		}
+
+		switch(entry->memory_type) {
+		case 0x12:
+			if (entry->type_detail & 1 << 13)
+				dimm->mtype = MEM_RDDR;
+			else
+				dimm->mtype = MEM_DDR;
+			break;
+		case 0x13:
+			if (entry->type_detail & 1 << 13)
+				dimm->mtype = MEM_RDDR2;
+			else
+				dimm->mtype = MEM_DDR2;
+			break;
+		case 0x14:
+			dimm->mtype = MEM_FB_DDR2;
+			break;
+		case 0x18:
+			if (entry->type_detail & 1 << 13)
+				dimm->mtype = MEM_RDDR3;
+			else
+				dimm->mtype = MEM_DDR3;
+			break;
+		default:
+			if (entry->type_detail & 1 << 6)
+				dimm->mtype = MEM_RMBS;
+			else if ((entry->type_detail & ((1 << 7) | (1 << 13)))
+				 == ((1 << 7) | (1 << 13)))
+				dimm->mtype = MEM_RDR;
+			else if (entry->type_detail & 1 << 7)
+				dimm->mtype = MEM_SDR;
+			else if (entry->type_detail & 1 << 9)
+				dimm->mtype = MEM_EDO;
+			else
+				dimm->mtype = MEM_UNKNOWN;
+		}
+
+		/*
+		 * Actually, we can only detect if the memory has bits for
+		 * checksum or not
+		 */
+		if (entry->total_width == entry->data_width)
+			dimm->edac_mode = EDAC_NONE;
+		else
+			dimm->edac_mode = EDAC_SECDED;
+
+		dimm->dtype = DEV_UNKNOWN;
+		dimm->grain = 128;		/* Likely, worse case */
+
+		/*
+		 * FIXME: It shouldn't be hard to also fill the DIMM labels
+		 */
+
+		if (dimm->nr_pages) {
+			pr_info(GHES_PFX "DIMM%i: %s size = %d MB%s\n",
+				dimm_fill->count, memory_type[dimm->mtype],
+				PAGES_TO_MiB(dimm->nr_pages),
+				(dimm->edac_mode != EDAC_NONE)? "(ECC)" : "");
+			pr_info (GHES_PFX "\ttype %d, detail 0x%02x, width %d(total %d)\n",
+				entry->memory_type, entry->type_detail,
+				entry->total_width, entry->data_width);
+		}
+
+		dimm_fill->count++;
+	}
+}
+
 void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 			        struct cper_sec_mem_err *mem_err)
 {
@@ -50,14 +200,23 @@ EXPORT_SYMBOL_GPL(ghes_edac_report_mem_error);
 
 int ghes_edac_register(struct ghes *ghes, struct device *dev)
 {
-	int rc;
+	bool fake = false;
+	int rc, num_dimm = 0;
 	struct mem_ctl_info *mci;
 	struct edac_mc_layer layers[1];
-	struct csrow_info *csrow;
-	struct dimm_info *dimm;
+	struct ghes_edac_dimm_fill dimm_fill;
+
+	/* Get the number of DIMMs */
+	dmi_walk(ghes_edac_count_dimms, &num_dimm);
+
+	/* Check if we've got a bogus BIOS */
+	if (num_dimm == 0) {
+		fake = true;
+		num_dimm = 1;
+	}
 
 	layers[0].type = EDAC_MC_LAYER_ALL_MEM;
-	layers[0].size = 1;
+	layers[0].size = num_dimm;
 	layers[0].is_virt_csrow = true;
 
 	/*
@@ -65,6 +224,8 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	 * to avoid duplicated memory controller numbers
 	 */
 	mutex_lock(&ghes_edac_lock);
+	pr_info("ghes_edac#%d: allocating space for %d dimms\n",
+		ghes_edac_mc_num, num_dimm);
 	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers, 0);
 	if (!mci) {
 		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
@@ -83,15 +244,22 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mci->ctl_name = "ghes_edac";
 	mci->dev_name = "ghes";
 
-	csrow = mci->csrows[0];
-	dimm = csrow->channels[0]->dimm;
+	if (!fake) {
+		/* Fill DIMM info from DMI */
+		dimm_fill.count = 0;
+		dimm_fill.mci = mci;
+		dmi_walk (ghes_edac_dmidecode, &dimm_fill);
+	} else {
+		struct dimm_info *dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
+						       mci->n_layers, 0, 0, 0);
 
-	/* FIXME: FAKE DATA */
-	dimm->nr_pages = 1000;
-	dimm->grain = 128;
-	dimm->mtype = MEM_UNKNOWN;
-	dimm->dtype = DEV_UNKNOWN;
-	dimm->edac_mode = EDAC_SECDED;
+		pr_info(GHES_PFX "Crappy BIOS detected. Faking DIMM EDAC data\n");
+		dimm->nr_pages = 1000;
+		dimm->grain = 128;
+		dimm->mtype = MEM_UNKNOWN;
+		dimm->dtype = DEV_UNKNOWN;
+		dimm->edac_mode = EDAC_SECDED;
+	}
 
 	rc = edac_mc_add_mc(mci);
 	if (rc < 0) {
-- 
1.8.1.2

