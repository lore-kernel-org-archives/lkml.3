Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaJZNuF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 09:50:05 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54184 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZNuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 09:50:01 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com, richard@nod.at
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        Dolev Raviv <draviv@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND 2/5 v2] mtd: ubi: Fill read disturb statistics
Date: Sun, 26 Oct 2014 15:49:49 +0200
Message-Id: <1414331390-28342-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill in eraseblock statistics needed for read disturb decision making:
1. read counter: incremented at each read operation
		 reset at each erase operation
    Saved only as part of the meta data in RAM
    On attach: if fastmap data is missing a default value is assigned
2. last erase time stamp: updated at each erase operation.
   Saved as part of PEB OOB info on flash
   On attach: if fastmap data is missing retrieved from PEB EC Header
   on NAND.
   If fastmap data is corrupted a default value is assigned.

The above parameters are saved as part of the fastmap data.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
---
 drivers/mtd/ubi/attach.c  | 137 +++++++++++++++++++++++++++++++++++-----------
 drivers/mtd/ubi/debug.c   |  11 ++++
 drivers/mtd/ubi/fastmap.c | 118 ++++++++++++++++++++++++++++++++++-----
 drivers/mtd/ubi/io.c      |  28 ++++++++++
 drivers/mtd/ubi/ubi.h     |  24 +++++++-
 drivers/mtd/ubi/vtbl.c    |   6 +-
 drivers/mtd/ubi/wl.c      |  47 ++++++++++++++++
 7 files changed, 322 insertions(+), 49 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 6f27d9a..e102cac 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1,5 +1,8 @@
 /*
  * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (c) 2014, Linux Foundation. All rights reserved.
+ * Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -87,8 +90,21 @@
 #include <linux/crc32.h>
 #include <linux/math64.h>
 #include <linux/random.h>
+#include <linux/time.h>
 #include "ubi.h"
 
+#define set_aeb_default_values(aeb, ai)		\
+	do {					\
+		if (aeb->ec == UBI_UNKNOWN) {	\
+			aeb->ec = ai->mean_ec;	\
+			if (ai->mean_last_erase_time) \
+				aeb->last_erase_time = \
+					ai->mean_last_erase_time; \
+			else \
+				aeb->last_erase_time = UBI_DT_THRESHOLD / 2; \
+		}		\
+	} while (0)
+
 static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai);
 
 /* Temporary variables used during scanning */
@@ -102,6 +118,9 @@ static struct ubi_vid_hdr *vidh;
  * @vol_id: the last used volume id for the PEB
  * @lnum: the last used LEB number for the PEB
  * @ec: erase counter of the physical eraseblock
+ * @last_erase_time: last erase time stamp (%UBI_UNKNOWN if it
+ *				is unknown)
+ * @rc: read counter (%UBI_UNKNOWN if it is unknown)
  * @to_head: if not zero, add to the head of the list
  * @list: the list to add to
  *
@@ -117,7 +136,8 @@ static struct ubi_vid_hdr *vidh;
  * failure.
  */
 static int add_to_list(struct ubi_attach_info *ai, int pnum, int vol_id,
-		       int lnum, int ec, int to_head, struct list_head *list)
+		       int lnum, int ec, long last_erase_time, long rc,
+		       int to_head, struct list_head *list)
 {
 	struct ubi_ainf_peb *aeb;
 
@@ -139,6 +159,9 @@ static int add_to_list(struct ubi_attach_info *ai, int pnum, int vol_id,
 	aeb->vol_id = vol_id;
 	aeb->lnum = lnum;
 	aeb->ec = ec;
+	aeb->rc = rc;
+	aeb->last_erase_time = last_erase_time;
+
 	if (to_head)
 		list_add(&aeb->u.list, list);
 	else
@@ -151,13 +174,17 @@ static int add_to_list(struct ubi_attach_info *ai, int pnum, int vol_id,
  * @ai: attaching information
  * @pnum: physical eraseblock number to add
  * @ec: erase counter of the physical eraseblock
+ * @last_erase_time: last erase time stamp (%UBI_UNKNOWN if it
+ *			   is unknown)
+ * @rc: read counter (%UBI_UNKNOWN if it is unknown)
  *
  * This function allocates a 'struct ubi_ainf_peb' object for a corrupted
  * physical eraseblock @pnum and adds it to the 'corr' list.  The corruption
  * was presumably not caused by a power cut. Returns zero in case of success
  * and a negative error code in case of failure.
  */
-static int add_corrupted(struct ubi_attach_info *ai, int pnum, int ec)
+static int add_corrupted(struct ubi_attach_info *ai, int pnum,
+			 int ec, long rc, long last_erase_time)
 {
 	struct ubi_ainf_peb *aeb;
 
@@ -170,6 +197,8 @@ static int add_corrupted(struct ubi_attach_info *ai, int pnum, int ec)
 	ai->corr_peb_count += 1;
 	aeb->pnum = pnum;
 	aeb->ec = ec;
+	aeb->rc = rc;
+	aeb->last_erase_time = last_erase_time;
 	list_add(&aeb->u.list, &ai->corr);
 	return 0;
 }
@@ -434,6 +463,9 @@ out_free_vidh:
  * @ai: attaching information
  * @pnum: the physical eraseblock number
  * @ec: erase counter
+ * @last_erase_time: last erase time stamp (%UBI_UNKNOWN if it
+ *			   is unknown)
+ * @rc: read counter (%UBI_UNKNOWN if it is unknown)
  * @vid_hdr: the volume identifier header
  * @bitflips: if bit-flips were detected when this physical eraseblock was read
  *
@@ -445,7 +477,8 @@ out_free_vidh:
  * zero in case of success and a negative error code in case of failure.
  */
 int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
-		  int ec, const struct ubi_vid_hdr *vid_hdr, int bitflips)
+		  int ec, long last_erase_time, long rc,
+		  const struct ubi_vid_hdr *vid_hdr, int bitflips)
 {
 	int err, vol_id, lnum;
 	unsigned long long sqnum;
@@ -532,12 +565,16 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 				return err;
 
 			err = add_to_list(ai, aeb->pnum, aeb->vol_id,
-					  aeb->lnum, aeb->ec, cmp_res & 4,
+					  aeb->lnum, aeb->ec,
+					  aeb->last_erase_time,
+					  aeb->rc, cmp_res & 4,
 					  &ai->erase);
 			if (err)
 				return err;
 
 			aeb->ec = ec;
+			aeb->last_erase_time = last_erase_time;
+			aeb->rc = rc;
 			aeb->pnum = pnum;
 			aeb->vol_id = vol_id;
 			aeb->lnum = lnum;
@@ -556,7 +593,8 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 			 * previously.
 			 */
 			return add_to_list(ai, pnum, vol_id, lnum, ec,
-					   cmp_res & 4, &ai->erase);
+					   last_erase_time, rc, cmp_res & 4,
+					   &ai->erase);
 		}
 	}
 
@@ -574,6 +612,8 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		return -ENOMEM;
 
 	aeb->ec = ec;
+	aeb->last_erase_time = last_erase_time;
+	aeb->rc = rc;
 	aeb->pnum = pnum;
 	aeb->vol_id = vol_id;
 	aeb->lnum = lnum;
@@ -650,6 +690,8 @@ void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
  * @ai: attaching information
  * @pnum: physical eraseblock number to erase;
  * @ec: erase counter value to write (%UBI_UNKNOWN if it is unknown)
+ * @last_erase_time: last erase time stamp (%UBI_UNKNOWN if it
+ *			   is unknown)
  *
  * This function erases physical eraseblock 'pnum', and writes the erase
  * counter header to it. This function should only be used on UBI device
@@ -658,7 +700,8 @@ void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av)
  * case of failure.
  */
 static int early_erase_peb(struct ubi_device *ubi,
-			   const struct ubi_attach_info *ai, int pnum, int ec)
+			   const struct ubi_attach_info *ai,
+			   int pnum, int ec, long last_erase_time)
 {
 	int err;
 	struct ubi_ec_hdr *ec_hdr;
@@ -677,7 +720,7 @@ static int early_erase_peb(struct ubi_device *ubi,
 		return -ENOMEM;
 
 	ec_hdr->ec = cpu_to_be64(ec);
-
+	ec_hdr->last_erase_time = cpu_to_be64(last_erase_time);
 	err = ubi_io_sync_erase(ubi, pnum, 0);
 	if (err < 0)
 		goto out_free;
@@ -708,6 +751,7 @@ struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 {
 	int err = 0;
 	struct ubi_ainf_peb *aeb, *tmp_aeb;
+	struct timeval tv;
 
 	if (!list_empty(&ai->free)) {
 		aeb = list_entry(ai->free.next, struct ubi_ainf_peb, u.list);
@@ -722,15 +766,20 @@ struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 	 * so forth. We don't want to take care about bad eraseblocks here -
 	 * they'll be handled later.
 	 */
+	do_gettimeofday(&tv);
 	list_for_each_entry_safe(aeb, tmp_aeb, &ai->erase, u.list) {
 		if (aeb->ec == UBI_UNKNOWN)
 			aeb->ec = ai->mean_ec;
 
-		err = early_erase_peb(ubi, ai, aeb->pnum, aeb->ec+1);
+		/* The last erase time resolution is in days */
+		err = early_erase_peb(ubi, ai, aeb->pnum,
+				  aeb->ec+1, tv.tv_sec / NUM_SEC_IN_DAY);
 		if (err)
 			continue;
 
 		aeb->ec += 1;
+		aeb->last_erase_time = tv.tv_sec / NUM_SEC_IN_DAY;
+		aeb->rc = 0;
 		list_del(&aeb->u.list);
 		dbg_bld("return PEB %d, EC %d", aeb->pnum, aeb->ec);
 		return aeb;
@@ -817,6 +866,8 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		    int pnum, int *vid, unsigned long long *sqnum)
 {
 	long long uninitialized_var(ec);
+	long long uninitialized_var(rc);
+	long long uninitialized_var(last_erase_time);
 	int err, bitflips = 0, vol_id = -1, ec_err = 0;
 
 	dbg_bld("scan PEB %d", pnum);
@@ -842,11 +893,13 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	case UBI_IO_FF:
 		ai->empty_peb_count += 1;
 		return add_to_list(ai, pnum, UBI_UNKNOWN, UBI_UNKNOWN,
-				   UBI_UNKNOWN, 0, &ai->erase);
+				   UBI_UNKNOWN, UBI_UNKNOWN, UBI_UNKNOWN,
+				   0, &ai->erase);
 	case UBI_IO_FF_BITFLIPS:
 		ai->empty_peb_count += 1;
 		return add_to_list(ai, pnum, UBI_UNKNOWN, UBI_UNKNOWN,
-				   UBI_UNKNOWN, 1, &ai->erase);
+				   UBI_UNKNOWN, UBI_UNKNOWN, UBI_UNKNOWN,
+				   1, &ai->erase);
 	case UBI_IO_BAD_HDR_EBADMSG:
 	case UBI_IO_BAD_HDR:
 		/*
@@ -856,6 +909,8 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		 */
 		ec_err = err;
 		ec = UBI_UNKNOWN;
+		last_erase_time = UBI_UNKNOWN;
+		rc = UBI_UNKNOWN;
 		bitflips = 1;
 		break;
 	default:
@@ -874,6 +929,16 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		}
 
 		ec = be64_to_cpu(ech->ec);
+		last_erase_time = be64_to_cpu(ech->last_erase_time);
+		/*
+		 * Default value for read counter should be 0. If this is a
+		 * free or erased peb, the counter has no meaning.
+		 * If this peb is used, later code will schedule the peb for
+		 * scrubbing. We can afford erasing all used blocks in this
+		 * case as this is a rear case, and not doing so might have
+		 * destructive implication on the system.
+		 */
+		rc = 0;
 		if (ec > UBI_MAX_ERASECOUNTER) {
 			/*
 			 * Erase counter overflow. The EC headers have 64 bits
@@ -957,29 +1022,32 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		else if (!err)
 			/* This corruption is caused by a power cut */
 			err = add_to_list(ai, pnum, UBI_UNKNOWN,
-					  UBI_UNKNOWN, ec, 1, &ai->erase);
+					  UBI_UNKNOWN, ec, last_erase_time, rc,
+					  1, &ai->erase);
 		else
 			/* This is an unexpected corruption */
-			err = add_corrupted(ai, pnum, ec);
+			err = add_corrupted(ai, pnum, ec, rc, last_erase_time);
 		if (err)
 			return err;
-		goto adjust_mean_ec;
+		goto adjust_mean_av_stat;
 	case UBI_IO_FF_BITFLIPS:
 		err = add_to_list(ai, pnum, UBI_UNKNOWN, UBI_UNKNOWN,
-				  ec, 1, &ai->erase);
+				  ec, last_erase_time, rc, 1, &ai->erase);
 		if (err)
 			return err;
-		goto adjust_mean_ec;
+		goto adjust_mean_av_stat;
 	case UBI_IO_FF:
 		if (ec_err || bitflips)
 			err = add_to_list(ai, pnum, UBI_UNKNOWN,
-					  UBI_UNKNOWN, ec, 1, &ai->erase);
+					  UBI_UNKNOWN, ec, last_erase_time, rc,
+					  1, &ai->erase);
 		else
 			err = add_to_list(ai, pnum, UBI_UNKNOWN,
-					  UBI_UNKNOWN, ec, 0, &ai->free);
+					  UBI_UNKNOWN, ec, last_erase_time, 0,
+					  0, &ai->free);
 		if (err)
 			return err;
-		goto adjust_mean_ec;
+		goto adjust_mean_av_stat;
 	default:
 		ubi_err("'ubi_io_read_vid_hdr()' returned unknown code %d",
 			err);
@@ -1003,7 +1071,8 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 					vol_id, lnum);
 			}
 			err = add_to_list(ai, pnum, vol_id, lnum,
-					  ec, 1, &ai->erase);
+					  ec, last_erase_time,
+					  rc, 1, &ai->erase);
 			if (err)
 				return err;
 			return 0;
@@ -1018,7 +1087,8 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			ubi_msg("\"preserve\" compatible internal volume %d:%d found",
 				vol_id, lnum);
 			err = add_to_list(ai, pnum, vol_id, lnum,
-					  ec, 0, &ai->alien);
+					  ec, last_erase_time,
+					  rc, 0, &ai->alien);
 			if (err)
 				return err;
 			return 0;
@@ -1033,11 +1103,13 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	if (ec_err)
 		ubi_warn("valid VID header but corrupted EC header at PEB %d",
 			 pnum);
-	err = ubi_add_to_av(ubi, ai, pnum, ec, vidh, bitflips);
+
+	err = ubi_add_to_av(ubi, ai, pnum, ec, last_erase_time,
+				UBI_DEF_RD_THRESHOLD, vidh, bitflips);
 	if (err)
 		return err;
 
-adjust_mean_ec:
+adjust_mean_av_stat:
 	if (!ec_err) {
 		ai->ec_sum += ec;
 		ai->ec_count += 1;
@@ -1045,6 +1117,8 @@ adjust_mean_ec:
 			ai->max_ec = ec;
 		if (ec < ai->min_ec)
 			ai->min_ec = ec;
+		ai->last_erase_time_sum += last_erase_time;
+		ai->last_erase_time_count++;
 	}
 
 	return 0;
@@ -1254,6 +1328,10 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	if (ai->ec_count)
 		ai->mean_ec = div_u64(ai->ec_sum, ai->ec_count);
 
+	if (ai->last_erase_time_count)
+		ai->mean_last_erase_time = div_u64(ai->last_erase_time_sum,
+						   ai->last_erase_time_count);
+
 	err = late_analysis(ubi, ai);
 	if (err)
 		goto out_vidh;
@@ -1264,22 +1342,17 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	 */
 	ubi_rb_for_each_entry(rb1, av, &ai->volumes, rb) {
 		ubi_rb_for_each_entry(rb2, aeb, &av->root, u.rb)
-			if (aeb->ec == UBI_UNKNOWN)
-				aeb->ec = ai->mean_ec;
+			set_aeb_default_values(aeb, ai);
 	}
 
-	list_for_each_entry(aeb, &ai->free, u.list) {
-		if (aeb->ec == UBI_UNKNOWN)
-			aeb->ec = ai->mean_ec;
-	}
+	list_for_each_entry(aeb, &ai->free, u.list)
+		set_aeb_default_values(aeb, ai);
 
 	list_for_each_entry(aeb, &ai->corr, u.list)
-		if (aeb->ec == UBI_UNKNOWN)
-			aeb->ec = ai->mean_ec;
+		set_aeb_default_values(aeb, ai);
 
 	list_for_each_entry(aeb, &ai->erase, u.list)
-		if (aeb->ec == UBI_UNKNOWN)
-			aeb->ec = ai->mean_ec;
+		set_aeb_default_values(aeb, ai);
 
 	err = self_check_ai(ubi, ai);
 	if (err)
diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 63cb1d7..d172c7c 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -1,5 +1,8 @@
 /*
  * Copyright (c) International Business Machines Corp., 2006
+ * Copyright (c) 2014, Linux Foundation. All rights reserved.
+ * Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -47,6 +50,14 @@ void ubi_dump_flash(struct ubi_device *ubi, int pnum, int offset, int len)
 			err, len, pnum, offset, read);
 		goto out;
 	}
+	if (ubi->lookuptbl) {
+		if (ubi->lookuptbl[pnum]->rc < UBI_MAX_READCOUNTER)
+			ubi->lookuptbl[pnum]->rc++;
+		else
+			ubi_err("read counter overflow at PEB %d, RC %d",
+					pnum, ubi->lookuptbl[pnum]->rc);
+	} else
+		ubi_err("Can't update RC. No lookuptbl");
 
 	ubi_msg("dumping %d bytes of data from PEB %d, offset %d",
 		len, pnum, offset);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 5399aa2..f72980b 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -31,6 +31,7 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
 		sizeof(struct ubi_fm_scan_pool) + \
 		(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
 		(sizeof(struct ubi_fm_eba) + \
+		(ubi->peb_count * sizeof(__be32)) + \
 		(ubi->peb_count * sizeof(__be32))) + \
 		sizeof(struct ubi_fm_volhdr) * UBI_MAX_VOLUMES;
 	return roundup(size, ubi->leb_size);
@@ -71,12 +72,16 @@ out:
  * @list: the target list
  * @pnum: PEB number of the new attach erase block
  * @ec: erease counter of the new LEB
+ * @last_erase_time: last erase time stamp (%UBI_UNKNOWN if it
+ *			   is unknown)
+ * @rc: read counter (%UBI_UNKNOWN if it is unknown)
  * @scrub: scrub this PEB after attaching
  *
  * Returns 0 on success, < 0 indicates an internal error.
  */
 static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
-		   int pnum, int ec, int scrub)
+		   int pnum, int ec, unsigned long last_erase_time,
+		   int rc,  int scrub)
 {
 	struct ubi_ainf_peb *aeb;
 
@@ -86,6 +91,8 @@ static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
 
 	aeb->pnum = pnum;
 	aeb->ec = ec;
+	aeb->rc = rc;
+	aeb->last_erase_time = last_erase_time;
 	aeb->lnum = -1;
 	aeb->scrub = scrub;
 	aeb->copy_flag = aeb->sqnum = 0;
@@ -99,6 +106,9 @@ static int add_aeb(struct ubi_attach_info *ai, struct list_head *list,
 	if (ai->min_ec > aeb->ec)
 		ai->min_ec = aeb->ec;
 
+	ai->last_erase_time_sum += aeb->last_erase_time;
+	ai->last_erase_time_count++;
+
 	list_add_tail(&aeb->u.list, list);
 
 	return 0;
@@ -246,6 +256,8 @@ static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
 				return -ENOMEM;
 
 			victim->ec = aeb->ec;
+			victim->last_erase_time = aeb->last_erase_time;
+			victim->rc = aeb->rc;
 			victim->pnum = aeb->pnum;
 			list_add_tail(&victim->u.list, &ai->erase);
 
@@ -257,6 +269,8 @@ static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
 				av->vol_id, aeb->lnum, new_aeb->pnum);
 
 			aeb->ec = new_aeb->ec;
+			aeb->last_erase_time = new_aeb->last_erase_time;
+			aeb->rc = new_aeb->rc;
 			aeb->pnum = new_aeb->pnum;
 			aeb->copy_flag = new_vh->copy_flag;
 			aeb->scrub = new_aeb->scrub;
@@ -271,7 +285,7 @@ static int update_vol(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 		return 0;
 	}
-	/* This LEB is new, let's add it to the volume */
+	/* This LEB is new, last_erase_time's add it to the volume */
 
 	if (av->highest_lnum <= be32_to_cpu(new_vh->lnum)) {
 		av->highest_lnum = be32_to_cpu(new_vh->lnum);
@@ -444,12 +458,16 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		err = ubi_io_read_vid_hdr(ubi, pnum, vh, 0);
 		if (err == UBI_IO_FF || err == UBI_IO_FF_BITFLIPS) {
 			unsigned long long ec = be64_to_cpu(ech->ec);
+			unsigned long long last_erase_time =
+					be64_to_cpu(ech->last_erase_time);
 			unmap_peb(ai, pnum);
 			dbg_bld("Adding PEB to free: %i", pnum);
 			if (err == UBI_IO_FF_BITFLIPS)
-				add_aeb(ai, free, pnum, ec, 1);
+				add_aeb(ai, free, pnum, ec, last_erase_time,
+						0, 1);
 			else
-				add_aeb(ai, free, pnum, ec, 0);
+				add_aeb(ai, free, pnum, ec, last_erase_time,
+						0, 0);
 			continue;
 		} else if (err == 0 || err == UBI_IO_BITFLIPS) {
 			dbg_bld("Found non empty PEB:%i in pool", pnum);
@@ -477,6 +495,9 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			}
 
 			new_aeb->ec = be64_to_cpu(ech->ec);
+			new_aeb->last_erase_time =
+				be64_to_cpu(ech->last_erase_time);
+			new_aeb->rc = UBI_DEF_RD_THRESHOLD;
 			new_aeb->pnum = pnum;
 			new_aeb->lnum = be32_to_cpu(vh->lnum);
 			new_aeb->sqnum = be64_to_cpu(vh->sqnum);
@@ -649,7 +670,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		add_aeb(ai, &ai->free, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 0);
+			be32_to_cpu(fmec->ec),
+			be64_to_cpu(fmec->last_erase_time),
+			be32_to_cpu(fmec->rc), 0);
 	}
 
 	/* read EC values from used list */
@@ -660,7 +683,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 0);
+			be32_to_cpu(fmec->ec),
+			be64_to_cpu(fmec->last_erase_time),
+			be32_to_cpu(fmec->rc), 0);
 	}
 
 	/* read EC values from scrub list */
@@ -671,7 +696,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		add_aeb(ai, &used, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 1);
+			be32_to_cpu(fmec->ec),
+			be64_to_cpu(fmec->last_erase_time),
+			be32_to_cpu(fmec->rc), 1);
 	}
 
 	/* read EC values from erase list */
@@ -682,10 +709,14 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		add_aeb(ai, &ai->erase, be32_to_cpu(fmec->pnum),
-			be32_to_cpu(fmec->ec), 1);
+			be32_to_cpu(fmec->ec),
+			be64_to_cpu(fmec->last_erase_time),
+			be32_to_cpu(fmec->rc), 1);
 	}
 
 	ai->mean_ec = div_u64(ai->ec_sum, ai->ec_count);
+	ai->mean_last_erase_time = div_u64(ai->last_erase_time_sum,
+					   ai->last_erase_time_count);
 	ai->bad_peb_count = be32_to_cpu(fmhdr->bad_peb_count);
 
 	/* Iterate over all volumes and read their EBA table */
@@ -717,7 +748,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 
 		fm_eba = (struct ubi_fm_eba *)(fm_raw + fm_pos);
 		fm_pos += sizeof(*fm_eba);
-		fm_pos += (sizeof(__be32) * be32_to_cpu(fm_eba->reserved_pebs));
+		fm_pos += 2 * (sizeof(__be32) *
+					   be32_to_cpu(fm_eba->reserved_pebs));
 		if (fm_pos >= fm_size)
 			goto fail_bad;
 
@@ -761,7 +793,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 				aeb->lnum = j;
 				aeb->pnum =
 					be32_to_cpu(fm_eba->peb_data[j].pnum);
-				aeb->ec = -1;
+				aeb->ec = UBI_UNKNOWN;
+				aeb->rc = be32_to_cpu(fm_eba->peb_data[j].rc);
+				aeb->last_erase_time = UBI_UNKNOWN;
 				aeb->scrub = aeb->copy_flag = aeb->sqnum = 0;
 				list_add_tail(&aeb->u.list, &eba_orphans);
 				continue;
@@ -807,6 +841,9 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 				tmp_aeb->scrub = 1;
 
 			tmp_aeb->ec = be64_to_cpu(ech->ec);
+			tmp_aeb->last_erase_time =
+				be64_to_cpu(ech->last_erase_time);
+			tmp_aeb->rc = UBI_DEF_RD_THRESHOLD;
 			assign_aeb_to_av(ai, tmp_aeb, av);
 		}
 
@@ -1062,6 +1099,8 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 		e->pnum = be32_to_cpu(fmsb2->block_loc[i]);
 		e->ec = be32_to_cpu(fmsb2->block_ec[i]);
+		e->last_erase_time = be64_to_cpu(fmsb2->block_let[i]);
+		e->rc = be32_to_cpu(fmsb2->block_rc[i]);
 		fm->e[i] = e;
 	}
 
@@ -1179,7 +1218,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
 		fec->ec = cpu_to_be32(wl_e->ec);
-
+		fec->last_erase_time = cpu_to_be64(wl_e->last_erase_time);
+		fec->rc = cpu_to_be32(wl_e->rc);
 		free_peb_count++;
 		fm_pos += sizeof(*fec);
 		ubi_assert(fm_pos <= ubi->fm_size);
@@ -1192,7 +1232,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
 		fec->ec = cpu_to_be32(wl_e->ec);
-
+		fec->last_erase_time = cpu_to_be64(wl_e->last_erase_time);
+		fec->rc = cpu_to_be32(wl_e->rc);
 		used_peb_count++;
 		fm_pos += sizeof(*fec);
 		ubi_assert(fm_pos <= ubi->fm_size);
@@ -1205,6 +1246,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 		fec->pnum = cpu_to_be32(wl_e->pnum);
 		fec->ec = cpu_to_be32(wl_e->ec);
+		fec->last_erase_time = cpu_to_be64(wl_e->last_erase_time);
+		fec->rc = cpu_to_be32(wl_e->rc);
 
 		scrub_peb_count++;
 		fm_pos += sizeof(*fec);
@@ -1222,6 +1265,9 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 
 			fec->pnum = cpu_to_be32(wl_e->pnum);
 			fec->ec = cpu_to_be32(wl_e->ec);
+			fec->last_erase_time =
+				cpu_to_be64(wl_e->last_erase_time);
+			fec->rc = cpu_to_be32(wl_e->rc);
 
 			erase_peb_count++;
 			fm_pos += sizeof(*fec);
@@ -1257,8 +1303,15 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 			2 * (sizeof(__be32) * vol->reserved_pebs);
 		ubi_assert(fm_pos <= ubi->fm_size);
 
-		for (j = 0; j < vol->reserved_pebs; j++)
+		for (j = 0; j < vol->reserved_pebs; j++) {
 			feba->peb_data[j].pnum = cpu_to_be32(vol->eba_tbl[j]);
+			feba->peb_data[j].rc = cpu_to_be32(UBI_UNKNOWN);
+			if (vol->eba_tbl[j] >= 0 &&
+				ubi->lookuptbl[vol->eba_tbl[j]])
+				feba->peb_data[j].rc =
+					cpu_to_be32(
+					ubi->lookuptbl[vol->eba_tbl[j]]->rc);
+		}
 
 		feba->reserved_pebs = cpu_to_be32(j);
 		feba->magic = cpu_to_be32(UBI_FM_EBA_MAGIC);
@@ -1282,6 +1335,8 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	for (i = 0; i < new_fm->used_blocks; i++) {
 		fmsb->block_loc[i] = cpu_to_be32(new_fm->e[i]->pnum);
 		fmsb->block_ec[i] = cpu_to_be32(new_fm->e[i]->ec);
+		fmsb->block_let[i] = cpu_to_be64(new_fm->e[i]->last_erase_time);
+		fmsb->block_rc[i] = cpu_to_be32(new_fm->e[i]->rc);
 	}
 
 	fmsb->data_crc = 0;
@@ -1335,6 +1390,7 @@ static int erase_block(struct ubi_device *ubi, int pnum)
 	int ret;
 	struct ubi_ec_hdr *ec_hdr;
 	long long ec;
+	struct timeval tv;
 
 	ec_hdr = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ec_hdr)
@@ -1360,6 +1416,9 @@ static int erase_block(struct ubi_device *ubi, int pnum)
 	}
 
 	ec_hdr->ec = cpu_to_be64(ec);
+	do_gettimeofday(&tv);
+	/* The last erase time resolution is in days */
+	ec_hdr->last_erase_time = cpu_to_be64(tv.tv_sec / NUM_SEC_IN_DAY);
 	ret = ubi_io_write_ec_hdr(ubi, pnum, ec_hdr);
 	if (ret < 0)
 		goto out;
@@ -1382,10 +1441,17 @@ static int invalidate_fastmap(struct ubi_device *ubi,
 {
 	int ret;
 	struct ubi_vid_hdr *vh;
+	struct timeval tv;
 
 	ret = erase_block(ubi, fm->e[0]->pnum);
 	if (ret < 0)
 		return ret;
+	fm->e[0]->ec = ret;
+
+	do_gettimeofday(&tv);
+	/* The last erase time resolution is in days */
+	fm->e[0]->last_erase_time = tv.tv_sec / NUM_SEC_IN_DAY;
+	fm->e[0]->rc = 0;
 
 	vh = new_fm_vhdr(ubi, UBI_FM_SB_VOLUME_ID);
 	if (!vh)
@@ -1412,6 +1478,9 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	int ret, i;
 	struct ubi_fastmap_layout *new_fm, *old_fm;
 	struct ubi_wl_entry *tmp_e;
+	struct timeval tv;
+
+	do_gettimeofday(&tv);
 
 	mutex_lock(&ubi->fm_mutex);
 
@@ -1485,10 +1554,19 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			}
 
 			new_fm->e[i]->pnum = old_fm->e[i]->pnum;
-			new_fm->e[i]->ec = old_fm->e[i]->ec;
+			new_fm->e[i]->ec = old_fm->e[i]->ec = ret;
+
+			/* The last erase time resolution is in days */
+			new_fm->e[i]->last_erase_time =
+					tv.tv_sec / NUM_SEC_IN_DAY;
+			old_fm->e[i]->last_erase_time =
+					tv.tv_sec / NUM_SEC_IN_DAY;
+			new_fm->e[i]->rc = old_fm->e[i]->rc = 0;
 		} else {
 			new_fm->e[i]->pnum = tmp_e->pnum;
 			new_fm->e[i]->ec = tmp_e->ec;
+			new_fm->e[i]->rc = tmp_e->rc;
+			new_fm->e[i]->last_erase_time = tmp_e->last_erase_time;
 
 			if (old_fm)
 				ubi_wl_put_fm_peb(ubi, old_fm->e[i], i,
@@ -1515,7 +1593,13 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			}
 
 			new_fm->e[0]->pnum = old_fm->e[0]->pnum;
-			new_fm->e[0]->ec = ret;
+			new_fm->e[0]->ec = old_fm->e[0]->ec = ret;
+			/* The last erase time resolution is in days */
+			new_fm->e[0]->last_erase_time =
+					tv.tv_sec / NUM_SEC_IN_DAY;
+			old_fm->e[0]->last_erase_time =
+					tv.tv_sec / NUM_SEC_IN_DAY;
+			new_fm->e[0]->rc = old_fm->e[0]->rc = 0;
 		} else {
 			/* we've got a new anchor PEB, return the old one */
 			ubi_wl_put_fm_peb(ubi, old_fm->e[0], 0,
@@ -1523,6 +1607,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 			new_fm->e[0]->pnum = tmp_e->pnum;
 			new_fm->e[0]->ec = tmp_e->ec;
+			new_fm->e[0]->last_erase_time = tmp_e->last_erase_time;
+			new_fm->e[0]->rc = tmp_e->rc;
 		}
 	} else {
 		if (!tmp_e) {
@@ -1538,6 +1624,8 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		new_fm->e[0]->pnum = tmp_e->pnum;
 		new_fm->e[0]->ec = tmp_e->ec;
+		new_fm->e[0]->last_erase_time = tmp_e->last_erase_time;
+		new_fm->e[0]->rc = tmp_e->rc;
 	}
 
 	down_write(&ubi->work_sem);
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index d361349..444d552 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -1,6 +1,9 @@
 /*
  * Copyright (c) International Business Machines Corp., 2006
  * Copyright (c) Nokia Corporation, 2006, 2007
+ * Copyright (c) 2014, Linux Foundation. All rights reserved.
+ * Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -204,6 +207,14 @@ retry:
 		}
 	} else {
 		ubi_assert(len == read);
+		if (ubi->lookuptbl && ubi->lookuptbl[pnum]) {
+			if (ubi->lookuptbl[pnum]->rc <
+				UBI_MAX_READCOUNTER)
+				ubi->lookuptbl[pnum]->rc++;
+			else
+				ubi_err("read counter overflow at PEB %d, RC %d",
+					pnum, ubi->lookuptbl[pnum]->rc);
+		}
 
 		if (ubi_dbg_is_bitflip(ubi)) {
 			dbg_gen("bit-flip (emulated)");
@@ -1337,6 +1348,15 @@ static int self_check_write(struct ubi_device *ubi, const void *buf, int pnum,
 	if (err && !mtd_is_bitflip(err))
 		goto out_free;
 
+	if (ubi->lookuptbl && ubi->lookuptbl[pnum]) {
+		if (ubi->lookuptbl[pnum]->rc < UBI_MAX_READCOUNTER)
+			ubi->lookuptbl[pnum]->rc++;
+		else
+			ubi_err("read counter overflow at PEB %d, RC %d",
+					pnum, ubi->lookuptbl[pnum]->rc);
+	} else
+		ubi_err("Can't update RC. No lookuptbl");
+
 	for (i = 0; i < len; i++) {
 		uint8_t c = ((uint8_t *)buf)[i];
 		uint8_t c1 = ((uint8_t *)buf1)[i];
@@ -1403,6 +1423,14 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
 			err, len, pnum, offset, read);
 		goto error;
 	}
+	if (ubi->lookuptbl && ubi->lookuptbl[pnum]) {
+		if (ubi->lookuptbl[pnum]->rc < UBI_MAX_READCOUNTER)
+			ubi->lookuptbl[pnum]->rc++;
+		else
+			ubi_err("read counter overflow at PEB %d, RC %d",
+					pnum, ubi->lookuptbl[pnum]->rc);
+	} else
+		ubi_err("Can't update RC. No lookuptbl");
 
 	err = ubi_check_pattern(buf, 0xFF, len);
 	if (err == 0) {
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 6c7e53e..e4c97ad 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -95,6 +95,16 @@
 #define UBI_RD_THRESHOLD 100000
 
 /*
+ * This is the default read counter to be assigned to blocks lacking
+ * read counter value on attach. The value was choosen as mean between
+ * just_erased_block (rc = 0) and needs_scrubbibg_block
+ * (rc = UBI_RD_THRESHOLD). On the one hand we don't want to miss
+ * blocks that needs scrubbing but on the other, we dont want to
+ * abuse scrubbing.
+ */
+#define UBI_DEF_RD_THRESHOLD (UBI_RD_THRESHOLD / 2)
+
+/*
  * This parameter defines the maximun interval (in days) between two
  * erasures of an eraseblock. When this interval is reached, UBI starts
  * performing wear leveling by means of moving data from eraseblock with
@@ -102,6 +112,9 @@
  */
 #define UBI_DT_THRESHOLD 120
 
+/* Used when calculaing the lats erase timestamp of a PEB */
+#define NUM_SEC_IN_DAY (60*60*24)
+
 /*
  * The UBI debugfs directory name pattern and maximum name length (3 for "ubi"
  * + 2 for the number plus 1 for the trailing zero byte.
@@ -709,6 +722,11 @@ struct ubi_ainf_volume {
  * @ec_sum: a temporary variable used when calculating @mean_ec
  * @ec_count: a temporary variable used when calculating @mean_ec
  * @aeb_slab_cache: slab cache for &struct ubi_ainf_peb objects
+ * @mean_last_erase_time: mean late erase timestamp value
+ * @last_erase_time_sum: temporary variable, used to calculate
+ *				@mean_last_erase_time
+ * @last_erase_time_count: temporary variable, used to calculate
+ *				@mean_last_erase_time
  *
  * This data structure contains the result of attaching an MTD device and may
  * be used by other UBI sub-systems to build final UBI data structures, further
@@ -735,6 +753,9 @@ struct ubi_attach_info {
 	uint64_t ec_sum;
 	int ec_count;
 	struct kmem_cache *aeb_slab_cache;
+	long long  mean_last_erase_time;
+	long long last_erase_time_sum;
+	int last_erase_time_count;
 };
 
 /**
@@ -775,7 +796,8 @@ extern struct blocking_notifier_head ubi_notifiers;
 
 /* attach.c */
 int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
-		  int ec, const struct ubi_vid_hdr *vid_hdr, int bitflips);
+		  int ec, long last_erase_time, long rc,
+		  const struct ubi_vid_hdr *vid_hdr, int bitflips);
 struct ubi_ainf_volume *ubi_find_av(const struct ubi_attach_info *ai,
 				    int vol_id);
 void ubi_remove_av(struct ubi_attach_info *ai, struct ubi_ainf_volume *av);
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 07cac5f..625a9b4 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -1,6 +1,9 @@
 /*
  * Copyright (c) International Business Machines Corp., 2006
  * Copyright (c) Nokia Corporation, 2006, 2007
+ * Copyright (c) 2014, Linux Foundation. All rights reserved.
+ * Linux Foundation chooses to take subject only to the GPLv2
+ * license terms, and distributes only under these terms.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -339,7 +342,8 @@ retry:
 	 * And add it to the attaching information. Don't delete the old version
 	 * of this LEB as it will be deleted and freed in 'ubi_add_to_av()'.
 	 */
-	err = ubi_add_to_av(ubi, ai, new_aeb->pnum, new_aeb->ec, vid_hdr, 0);
+	err = ubi_add_to_av(ubi, ai, new_aeb->pnum, new_aeb->ec,
+			new_aeb->last_erase_time, new_aeb->rc, vid_hdr, 0);
 	kmem_cache_free(ai->aeb_slab_cache, new_aeb);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 33d33e43..2b4e6fe 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -105,6 +105,7 @@
 #include <linux/crc32.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/time.h>
 #include "ubi.h"
 
 /* Number of physical eraseblocks reserved for wear-leveling purposes */
@@ -742,6 +743,7 @@ static int sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 	int err;
 	struct ubi_ec_hdr *ec_hdr;
 	unsigned long long ec = e->ec;
+	struct timeval tv;
 
 	dbg_wl("erase PEB %d, old EC %llu", e->pnum, ec);
 
@@ -773,11 +775,16 @@ static int sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 
 	ec_hdr->ec = cpu_to_be64(ec);
 
+	do_gettimeofday(&tv);
+	/* The last erase time resolution is in days */
+	ec_hdr->last_erase_time = cpu_to_be64(tv.tv_sec / NUM_SEC_IN_DAY);
 	err = ubi_io_write_ec_hdr(ubi, e->pnum, ec_hdr);
 	if (err)
 		goto out_free;
 
 	e->ec = ec;
+	e->last_erase_time = tv.tv_sec / NUM_SEC_IN_DAY;
+	e->rc = 0;
 	spin_lock(&ubi->wl_lock);
 	if (e->ec > ubi->max_ec)
 		ubi->max_ec = e->ec;
@@ -979,6 +986,8 @@ int ubi_wl_put_fm_peb(struct ubi_device *ubi, struct ubi_wl_entry *fm_e,
 		ubi->lookuptbl[pnum] = e;
 	} else {
 		e->ec = fm_e->ec;
+		e->rc = fm_e->rc;
+		e->last_erase_time = fm_e->last_erase_time;
 		kfree(fm_e);
 	}
 
@@ -1913,6 +1922,19 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
+		e->last_erase_time = aeb->last_erase_time;
+		e->rc = aeb->rc;
+		if (!ubi->fm) {
+			if (e->rc < UBI_MAX_READCOUNTER) {
+				e->rc++;
+			} else {
+				ubi_err("read counter overflow at PEB %d, RC %d",
+					e->pnum, e->rc);
+				kmem_cache_free(ubi_wl_entry_slab, e);
+				goto out_free;
+			}
+
+		}
 		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 		ubi->lookuptbl[e->pnum] = e;
 		if (schedule_erase(ubi, e, aeb->vol_id, aeb->lnum, 0)) {
@@ -1933,6 +1955,19 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 		e->pnum = aeb->pnum;
 		e->ec = aeb->ec;
+		e->rc = aeb->rc;
+		if (!ubi->fm) {
+			if (e->rc < UBI_MAX_READCOUNTER) {
+				e->rc++;
+			} else {
+				ubi_err("rc overflow at PEB %d, RC %d",
+						e->pnum, e->rc);
+				kmem_cache_free(ubi_wl_entry_slab, e);
+				goto out_free;
+			}
+
+		}
+		e->last_erase_time = aeb->last_erase_time;
 		ubi_assert(e->ec >= 0);
 		ubi_assert(!ubi_is_fm_block(ubi, e->pnum));
 
@@ -1954,6 +1989,18 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 			e->pnum = aeb->pnum;
 			e->ec = aeb->ec;
+			e->rc = aeb->rc;
+			if (!ubi->fm) {
+				if (e->rc < UBI_MAX_READCOUNTER) {
+					e->rc++;
+				} else {
+					ubi_err("rc overflow at PEB %d, RC %d",
+							e->pnum, e->rc);
+					kmem_cache_free(ubi_wl_entry_slab, e);
+					goto out_free;
+				}
+			}
+			e->last_erase_time = aeb->last_erase_time;
 			ubi->lookuptbl[e->pnum] = e;
 
 			if (!aeb->scrub) {
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project

