Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3BUPki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:40:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab3BUPjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:39:35 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDACv2 09/12] ghes_edac: Improve driver's printk messages
Date: Thu, 21 Feb 2013 12:39:07 -0300
Message-Id: <250ab71387cb8d02b1de89962ff7558c3d3421c9.1361459782.git.mchehab@redhat.com>
In-Reply-To: <cover.1361459782.git.mchehab@redhat.com>
References: <cover.1361459782.git.mchehab@redhat.com>
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
 drivers/edac/ghes_edac.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index ed57058..802d52a 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -9,12 +9,13 @@
  * Red Hat Inc. http://www.redhat.com
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <acpi/ghes.h>
 #include <linux/edac.h>
 #include <linux/dmi.h>
 #include "edac_core.h"
 
-#define GHES_PFX   "ghes_edac: "
 #define GHES_EDAC_REVISION " Ver: 1.0.0"
 
 struct ghes_edac_pvt {
@@ -27,6 +28,7 @@ static LIST_HEAD(ghes_reglist);
 static DEFINE_MUTEX(ghes_edac_lock);
 static int ghes_edac_mc_num;
 
+
 /* Memory Device - Type 17 of SMBIOS spec */
 struct memdev_dmi_entry {
 	u8 type;
@@ -98,7 +100,8 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 						       dimm_fill->count, 0, 0);
 
 		if (entry->size == 0xffff) {
-			pr_info(GHES_PFX "Can't get dimm size\n");
+			pr_info("Can't get DIMM%i size\n",
+				dimm_fill->count);
 			dimm->nr_pages = MiB_TO_PAGES(32);/* Unknown */
 		} else if (entry->size == 0x7fff) {
 			dimm->nr_pages = MiB_TO_PAGES(entry->extended_size);
@@ -163,11 +166,11 @@ static void ghes_edac_dmidecode(const struct dmi_header *dh, void *arg)
 		 */
 
 		if (dimm->nr_pages) {
-			pr_info(GHES_PFX "DIMM%i: %s size = %d MB%s\n",
+			edac_dbg(1, "DIMM%i: %s size = %d MB%s\n",
 				dimm_fill->count, memory_type[dimm->mtype],
 				PAGES_TO_MiB(dimm->nr_pages),
 				(dimm->edac_mode != EDAC_NONE) ? "(ECC)" : "");
-			pr_info(GHES_PFX "\ttype %d, detail 0x%02x, width %d(total %d)\n",
+			edac_dbg(2, "\ttype %d, detail 0x%02x, width %d(total %d)\n",
 				entry->memory_type, entry->type_detail,
 				entry->total_width, entry->data_width);
 		}
@@ -221,6 +224,7 @@ void ghes_edac_report_mem_error(struct ghes *ghes, int sev,
 		mem_err->node, mem_err->card, mem_err->module,
 		mem_err->bank, mem_err->device, mem_err->row, mem_err->column,
 		mem_err->bit_pos);
+	edac_dbg(3, "error at location %s\n", location);
 
 	edac_raw_mc_handle_error(type, mci, grain, 1, 0, 0, 0,
 				 page, offset, 0,
@@ -255,12 +259,10 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	 * to avoid duplicated memory controller numbers
 	 */
 	mutex_lock(&ghes_edac_lock);
-	pr_info("ghes_edac#%d: allocating space for %d dimms\n",
-		ghes_edac_mc_num, num_dimm);
 	mci = edac_mc_alloc(ghes_edac_mc_num, ARRAY_SIZE(layers), layers,
 			    sizeof(*pvt));
 	if (!mci) {
-		pr_info(GHES_PFX "Can't allocate memory for EDAC data\n");
+		pr_info("Can't allocate memory for EDAC data\n");
 		mutex_unlock(&ghes_edac_lock);
 		return -ENOMEM;
 	}
@@ -280,6 +282,22 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 	mci->ctl_name = "ghes_edac";
 	mci->dev_name = "ghes";
 
+	if (!ghes_edac_mc_num) {
+		if (!fake) {
+			pr_info("This EDAC driver relies on BIOS to enumerate memory and get error reports.\n");
+			pr_info("Unfortunately, not all BIOSes reflect the memory layout correctly.\n");
+			pr_info("So, the end result of using this driver varies from vendor to vendor.\n");
+			pr_info("If you find incorrect reports, please contact your hardware vendor\n");
+			pr_info("to correct its BIOS.\n");
+			pr_info("This system has %d DIMM sockets.\n",
+				num_dimm);
+		} else {
+			pr_info("This system has a very crappy BIOS: It doesn't even list the DIMMS.\n");
+			pr_info("Its SMBIOS info is wrong. It is doubtful that the error report would\n");
+			pr_info("work on such system. Use this driver with caution\n");
+		}
+	}
+
 	if (!fake) {
 		/*
 		 * Fill DIMM info from DMI for the memory controller #0
@@ -298,8 +316,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 		struct dimm_info *dimm = EDAC_DIMM_PTR(mci->layers, mci->dimms,
 						       mci->n_layers, 0, 0, 0);
 
-		pr_info(GHES_PFX "Crappy BIOS detected. Faking DIMM EDAC data\n");
-		dimm->nr_pages = 1000;
+		dimm->nr_pages = 1;
 		dimm->grain = 128;
 		dimm->mtype = MEM_UNKNOWN;
 		dimm->dtype = DEV_UNKNOWN;
@@ -308,7 +325,7 @@ int ghes_edac_register(struct ghes *ghes, struct device *dev)
 
 	rc = edac_mc_add_mc(mci);
 	if (rc < 0) {
-		pr_info(GHES_PFX "Can't register at EDAC core\n");
+		pr_info("Can't register at EDAC core\n");
 		edac_mc_free(mci);
 		mutex_unlock(&ghes_edac_lock);
 		return -ENODEV;
-- 
1.8.1.2

