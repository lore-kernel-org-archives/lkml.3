Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3CLOX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648Ab3CLOX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:23:56 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH EDACv2] edac: merge mci.mem_is_per_rank with mci.csbased
Date: Tue, 12 Mar 2013 11:00:20 -0300
Message-Id: <56ba4c93d909ef9dfab4f1101a8c3bf75bc4cdab.1363096778.git.mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both mci.mem_is_per_rank and mci.csbased have the same meaning:
the memory controller is csrows based. Merge both fields into one.

There's no need for the driver to actually fill it, as the core
detectsi it by checking if one of the layes has the csrows type
as part of the memory hierarchy:

	if (layers[i].type == EDAC_MC_LAYER_CHIP_SELECT)
			per_rank = true;
...
	mci->csbased = per_rank;

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
v2: Also removed the unused __resv field.


 drivers/edac/amd64_edac.c    | 1 -
 drivers/edac/edac_mc.c       | 6 +++---
 drivers/edac/edac_mc_sysfs.c | 2 +-
 include/linux/edac.h         | 6 ++----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4830f8b..10ed0c7 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2523,7 +2523,6 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 
 	mci->pvt_info = pvt;
 	mci->pdev = &pvt->F2->dev;
-	mci->csbased = 1;
 
 	setup_mci_misc_attrs(mci, fam_type);
 
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index cdb81aa..27e86d9 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -86,7 +86,7 @@ static void edac_mc_dump_dimm(struct dimm_info *dimm, int number)
 	edac_dimm_info_location(dimm, location, sizeof(location));
 
 	edac_dbg(4, "%s%i: %smapped as virtual row %d, chan %d\n",
-		 dimm->mci->mem_is_per_rank ? "rank" : "dimm",
+		 dimm->mci->csbased ? "rank" : "dimm",
 		 number, location, dimm->csrow, dimm->cschannel);
 	edac_dbg(4, "  dimm = %p\n", dimm);
 	edac_dbg(4, "  dimm->label = '%s'\n", dimm->label);
@@ -341,7 +341,7 @@ struct mem_ctl_info *edac_mc_alloc(unsigned mc_num,
 	memcpy(mci->layers, layers, sizeof(*layer) * n_layers);
 	mci->nr_csrows = tot_csrows;
 	mci->num_cschannel = tot_channels;
-	mci->mem_is_per_rank = per_rank;
+	mci->csbased = per_rank;
 
 	/*
 	 * Alocate and fill the csrow/channels structs
@@ -1235,7 +1235,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * incrementing the compat API counters
 			 */
 			edac_dbg(4, "%s csrows map: (%d,%d)\n",
-				 mci->mem_is_per_rank ? "rank" : "dimm",
+				 mci->csbased ? "rank" : "dimm",
 				 dimm->csrow, dimm->cschannel);
 			if (row == -1)
 				row = dimm->csrow;
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 5463ed3..6ab4a50 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -609,7 +609,7 @@ static int edac_create_dimm_object(struct mem_ctl_info *mci,
 	device_initialize(&dimm->dev);
 
 	dimm->dev.parent = &mci->dev;
-	if (mci->mem_is_per_rank)
+	if (mci->csbased)
 		dev_set_name(&dimm->dev, "rank%d", index);
 	else
 		dev_set_name(&dimm->dev, "dimm%d", index);
diff --git a/include/linux/edac.h b/include/linux/edac.h
index ab1ea98..0b76327 100644
--- a/include/linux/edac.h
+++ b/include/linux/edac.h
@@ -675,11 +675,11 @@ struct mem_ctl_info {
 	 * sees memory sticks ("dimms"), and the ones that sees memory ranks.
 	 * All old memory controllers enumerate memories per rank, but most
 	 * of the recent drivers enumerate memories per DIMM, instead.
-	 * When the memory controller is per rank, mem_is_per_rank is true.
+	 * When the memory controller is per rank, csbased is true.
 	 */
 	unsigned n_layers;
 	struct edac_mc_layer *layers;
-	bool mem_is_per_rank;
+	bool csbased;
 
 	/*
 	 * DIMM info. Will eventually remove the entire csrows_info some day
@@ -740,8 +740,6 @@ struct mem_ctl_info {
 	u32 fake_inject_ue;
 	u16 fake_inject_count;
 #endif
-	__u8 csbased : 1,	/* csrow-based memory controller */
-	     __resv  : 7;
 };
 
 #endif
-- 
1.8.1.4

