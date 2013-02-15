Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161797Ab3BONIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 08:08:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161285Ab3BOMpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:43 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDAC 13/13] ghes_edac: Improve driver's printk messages
Date: Fri, 15 Feb 2013 10:45:01 -0200
Message-Id: <30bb26a76d98f876648020517cd38a4884626f44.1360931635.git.mchehab@redhat.com>
In-Reply-To: <cover.1360931635.git.mchehab@redhat.com>
References: <cover.1360931635.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a better infrastructure for printk's inside the driver:
	- use edac_dbg() for debug messages;
	- standardize the usage of pr_info();
	- provide warning about the risk of relying on this
	  driver.

While here, changes the size of a fake memory to 1 page. This is
as good or as bad as 1000 pages, but it is easier for userspace to
detect, as I don't expect that any machine implementing GHES would
provide just 1 page available ;)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/ghes_edac.c | 28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index 97a0d53..48d6cd9 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -80,7 +80,8 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 						       dimm_fill->count, 0, 0);
 
 		if (entry->size == 0xffff) {
-			pr_info(GHES_PFX "Can't get dimm size\n");
+			pr_info(GHES_PFX "Can't get DIMM%i size\n",
+				dimm_fill->count);
 			dimm->nr_pages = MiB_TO_PAGES(32);/* Unknown */
 		} else if (entry->size == 0x7fff) {
 			dimm->nr_pages = MiB_TO_PAGES(entry->extended_size);
@@ -145,11 +146,11 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 		 */
 
 		if (dimm->nr_pages) {
-			pr_info(GHES_PFX "DIMM%i: %s size = %d MB%s\n",
+			edac_dbg(1, "DIMM%i: %s size = %d MB%s\n",
 				dimm_fill->count, memory_type[dimm->mtype],
 				PAGES_TO_MiB(dimm->nr_pages),
 				(dimm->edac_mode != EDAC_NONE)? "(ECC)" : "");
-			pr_info (GHES_PFX "\ttype %d, detail 0x%02x, width %d(total %d)\n",
+			edac_dbg(2, "\ttype %d, detail 0x%02x, width %d(total %d)\n",
 				entry->memory_type, entry->type_detail,
 				entry->total_width, entry->data_width);
 		}
@@ -191,6 +192,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		mem_err->node, mem_err->card, mem_err->module,
 		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
 		mem_err->bit_pos);
+	edac_dbg(3, "error at location %s\n", location);
 
 	edac_raw_mc_handle_error(type, ghes->mci, grain, 1, 0, 0, 0,
 				 page, offset, 0,
@@ -224,8 +226,6 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	 * to avoid duplicated memory controller numbers
 	 */
 	mutex_lock(&ghes_edac_lock);
-	pr_info("ghes_edac#%d: allocating space for %d dimms\n",
-		ghes_edac_mc_num, num_dimm);
 	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers, 0);
 	if (!mci) {
 		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
@@ -244,6 +244,21 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mci->ctl_name = "ghes_edac";
 	mci->dev_name = "ghes";
 
+	if (!ghes_edac_mc_num) {
+		if (!fake) {
+			pr_info(GHES_PFX "This EDAC driver relies on BIOS to enumerate memory and get error reports.\n");
+			pr_info(GHES_PFX "Unfortunately, not all BIOSes reflect the memory layout correctly.\n");
+			pr_info(GHES_PFX "So, the end result of using this driver varies from vendor to vendor.\n");
+			pr_info(GHES_PFX "If you find incorrect reports, please ask your vendor to fix its BIOS.\n");
+			pr_info(GHES_PFX "This system has %d DIMM sockets.\n",
+				num_dimm);
+		} else {
+			pr_info(GHES_PFX "This system has a very crappy BIOS: It doesn't even list the DIMMS.\n");
+			pr_info(GHES_PFX "Its SMBIOS info is wrong. It is doubtful that the error report would\n");
+			pr_info(GHES_PFX "work on such system. Use this driver with caution\n");
+		}
+	}
+
 	if (!fake) {
 		/*
 		 * Fill DIMM info from DMI for the memory controller #0
@@ -262,8 +277,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 		struct dimm_info *dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
 						       mci->n_layers, 0, 0, 0);
 
-		pr_info(GHES_PFX "Crappy BIOS detected. Faking DIMM EDAC data\n");
-		dimm->nr_pages = 1000;
+		dimm->nr_pages = 1;
 		dimm->grain = 128;
 		dimm->mtype = MEM_UNKNOWN;
 		dimm->dtype = DEV_UNKNOWN;
-- 
1.8.1.2

