Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaJTQ5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 12:57:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60685 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaJTQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 12:57:17 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com, ezequiel.garcia@free-electrons.com
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH V5] mtd: ubi: Extend UBI layer debug/messaging capabilities
Date: Mon, 20 Oct 2014 19:57:00 +0300
Message-Id: <1413824221-31235-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is more then one UBI device mounted, there is no way to
distinguish between messages from different UBI devices.
Add device number to all ubi layer message types.

The R/O block driver messages were replaced by pr_* since
ubi_device structure is not used by it.

Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
---
Changes from V1:
	- Compilation error fixed
	- macros were updated to receive the ubi structure as
	  parameter and not just ubi_number
	- Places in code, where ubi-messaging macros were used, but
	  ubi struct is not present yet (init phase), were updated
	  to just use pr_err or similar
Changes from V2:
	- multi line messages layout, as requested by Artem
	 note that due to these changes checkpatch fails
Changes from V3:
	- Compilation fix of block.c
	- All ubi_* messages in block.c were replaced with pr_*
Changes from V4:
	- Addressed comments on block.c

Note for reviewers:
The updated macros are all in ubi.h. All other file changes are just
technical changes for compilation (usage of the defined macros)

 drivers/mtd/ubi/attach.c  | 126 +++++++++++++++++++-------------------
 drivers/mtd/ubi/block.c   |  33 +++++-----
 drivers/mtd/ubi/build.c   | 122 ++++++++++++++++++++-----------------
 drivers/mtd/ubi/cdev.c    |  36 +++++------
 drivers/mtd/ubi/debug.c   |   8 +--
 drivers/mtd/ubi/eba.c     |  54 +++++++++--------
 drivers/mtd/ubi/fastmap.c |  96 ++++++++++++++---------------
 drivers/mtd/ubi/io.c      | 150 ++++++++++++++++++++++++----------------------
 drivers/mtd/ubi/kapi.c    |   6 +-
 drivers/mtd/ubi/misc.c    |   4 +-
 drivers/mtd/ubi/ubi.h     |  13 ++--
 drivers/mtd/ubi/vmt.c     |  69 +++++++++++----------
 drivers/mtd/ubi/vtbl.c    |  49 ++++++++-------
 drivers/mtd/ubi/wl.c      |  70 ++++++++++++----------
 14 files changed, 437 insertions(+), 399 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 6f27d9a..3da5df1 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -176,6 +176,7 @@ static int add_corrupted(struct ubi_attach_info *ai, int pnum, int ec)
 
 /**
  * validate_vid_hdr - check volume identifier header.
+ * @ubi: UBI device description object
  * @vid_hdr: the volume identifier header to check
  * @av: information about the volume this logical eraseblock belongs to
  * @pnum: physical eraseblock number the VID header came from
@@ -188,7 +189,8 @@ static int add_corrupted(struct ubi_attach_info *ai, int pnum, int ec)
  * information in the VID header is consistent to the information in other VID
  * headers of the same volume.
  */
-static int validate_vid_hdr(const struct ubi_vid_hdr *vid_hdr,
+static int validate_vid_hdr(const struct ubi_device *ubi,
+			    const struct ubi_vid_hdr *vid_hdr,
 			    const struct ubi_ainf_volume *av, int pnum)
 {
 	int vol_type = vid_hdr->vol_type;
@@ -206,7 +208,7 @@ static int validate_vid_hdr(const struct ubi_vid_hdr *vid_hdr,
 		 */
 
 		if (vol_id != av->vol_id) {
-			ubi_err("inconsistent vol_id");
+			ubi_err(ubi, "inconsistent vol_id");
 			goto bad;
 		}
 
@@ -216,17 +218,17 @@ static int validate_vid_hdr(const struct ubi_vid_hdr *vid_hdr,
 			av_vol_type = UBI_VID_DYNAMIC;
 
 		if (vol_type != av_vol_type) {
-			ubi_err("inconsistent vol_type");
+			ubi_err(ubi, "inconsistent vol_type");
 			goto bad;
 		}
 
 		if (used_ebs != av->used_ebs) {
-			ubi_err("inconsistent used_ebs");
+			ubi_err(ubi, "inconsistent used_ebs");
 			goto bad;
 		}
 
 		if (data_pad != av->data_pad) {
-			ubi_err("inconsistent data_pad");
+			ubi_err(ubi, "inconsistent data_pad");
 			goto bad;
 		}
 	}
@@ -234,7 +236,7 @@ static int validate_vid_hdr(const struct ubi_vid_hdr *vid_hdr,
 	return 0;
 
 bad:
-	ubi_err("inconsistent VID header at PEB %d", pnum);
+	ubi_err(ubi, "inconsistent VID header at PEB %d", pnum);
 	ubi_dump_vid_hdr(vid_hdr);
 	ubi_dump_av(av);
 	return -EINVAL;
@@ -336,7 +338,7 @@ int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 		 * support these images anymore. Well, those images still work,
 		 * but only if no unclean reboots happened.
 		 */
-		ubi_err("unsupported on-flash UBI format");
+		ubi_err(ubi, "unsupported on-flash UBI format");
 		return -EINVAL;
 	}
 
@@ -377,7 +379,7 @@ int ubi_compare_lebs(struct ubi_device *ubi, const struct ubi_ainf_peb *aeb,
 			if (err == UBI_IO_BITFLIPS)
 				bitflips = 1;
 			else {
-				ubi_err("VID of PEB %d header is bad, but it was OK earlier, err %d",
+				ubi_err(ubi, "VID of PEB %d header is bad, but it was OK earlier, err %d",
 					pnum, err);
 				if (err > 0)
 					err = -EIO;
@@ -507,7 +509,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 		 * logical eraseblocks because there was an unclean reboot.
 		 */
 		if (aeb->sqnum == sqnum && sqnum != 0) {
-			ubi_err("two LEBs with same sequence number %llu",
+			ubi_err(ubi, "two LEBs with same sequence number %llu",
 				sqnum);
 			ubi_dump_aeb(aeb, 0);
 			ubi_dump_vid_hdr(vid_hdr);
@@ -527,7 +529,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 			 * This logical eraseblock is newer than the one
 			 * found earlier.
 			 */
-			err = validate_vid_hdr(vid_hdr, av, pnum);
+			err = validate_vid_hdr(ubi, vid_hdr, av, pnum);
 			if (err)
 				return err;
 
@@ -565,7 +567,7 @@ int ubi_add_to_av(struct ubi_device *ubi, struct ubi_attach_info *ai, int pnum,
 	 * attaching information.
 	 */
 
-	err = validate_vid_hdr(vid_hdr, av, pnum);
+	err = validate_vid_hdr(ubi, vid_hdr, av, pnum);
 	if (err)
 		return err;
 
@@ -668,7 +670,8 @@ static int early_erase_peb(struct ubi_device *ubi,
 		 * Erase counter overflow. Upgrade UBI and use 64-bit
 		 * erase counters internally.
 		 */
-		ubi_err("erase counter overflow at PEB %d, EC %d", pnum, ec);
+		ubi_err(ubi, "erase counter overflow at PEB %d, EC %d",
+				pnum, ec);
 		return -EINVAL;
 	}
 
@@ -736,7 +739,7 @@ struct ubi_ainf_peb *ubi_early_get_peb(struct ubi_device *ubi,
 		return aeb;
 	}
 
-	ubi_err("no free eraseblocks");
+	ubi_err(ubi, "no free eraseblocks");
 	return ERR_PTR(-ENOSPC);
 }
 
@@ -785,9 +788,9 @@ static int check_corruption(struct ubi_device *ubi, struct ubi_vid_hdr *vid_hdr,
 	if (ubi_check_pattern(ubi->peb_buf, 0xFF, ubi->leb_size))
 		goto out_unlock;
 
-	ubi_err("PEB %d contains corrupted VID header, and the data does not contain all 0xFF",
+	ubi_err(ubi, "PEB %d contains corrupted VID header, and the data does not contain all 0xFF",
 		pnum);
-	ubi_err("this may be a non-UBI PEB or a severe VID header corruption which requires manual inspection");
+	ubi_err(ubi, "this may be a non-UBI PEB or a severe VID header corruption which requires manual inspection");
 	ubi_dump_vid_hdr(vid_hdr);
 	pr_err("hexdump of PEB %d offset %d, length %d",
 	       pnum, ubi->leb_start, ubi->leb_size);
@@ -859,7 +862,8 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		bitflips = 1;
 		break;
 	default:
-		ubi_err("'ubi_io_read_ec_hdr()' returned unknown code %d", err);
+		ubi_err(ubi, "'ubi_io_read_ec_hdr()' returned unknown code %d",
+			err);
 		return -EINVAL;
 	}
 
@@ -868,7 +872,7 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 		/* Make sure UBI version is OK */
 		if (ech->version != UBI_VERSION) {
-			ubi_err("this UBI version is %d, image version is %d",
+			ubi_err(ubi, "this UBI version is %d, image version is %d",
 				UBI_VERSION, (int)ech->version);
 			return -EINVAL;
 		}
@@ -882,7 +886,7 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			 * flash. Upgrade UBI and use 64-bit erase counters
 			 * internally.
 			 */
-			ubi_err("erase counter overflow, max is %d",
+			ubi_err(ubi, "erase counter overflow, max is %d",
 				UBI_MAX_ERASECOUNTER);
 			ubi_dump_ec_hdr(ech);
 			return -EINVAL;
@@ -903,7 +907,7 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		if (!ubi->image_seq)
 			ubi->image_seq = image_seq;
 		if (image_seq && ubi->image_seq != image_seq) {
-			ubi_err("bad image sequence number %d in PEB %d, expected %d",
+			ubi_err(ubi, "bad image sequence number %d in PEB %d, expected %d",
 				image_seq, pnum, ubi->image_seq);
 			ubi_dump_ec_hdr(ech);
 			return -EINVAL;
@@ -981,7 +985,7 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			return err;
 		goto adjust_mean_ec;
 	default:
-		ubi_err("'ubi_io_read_vid_hdr()' returned unknown code %d",
+		ubi_err(ubi, "'ubi_io_read_vid_hdr()' returned unknown code %d",
 			err);
 		return -EINVAL;
 	}
@@ -999,7 +1003,7 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		case UBI_COMPAT_DELETE:
 			if (vol_id != UBI_FM_SB_VOLUME_ID
 			    && vol_id != UBI_FM_DATA_VOLUME_ID) {
-				ubi_msg("\"delete\" compatible internal volume %d:%d found, will remove it",
+				ubi_msg(ubi, "\"delete\" compatible internal volume %d:%d found, will remove it",
 					vol_id, lnum);
 			}
 			err = add_to_list(ai, pnum, vol_id, lnum,
@@ -1009,13 +1013,13 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			return 0;
 
 		case UBI_COMPAT_RO:
-			ubi_msg("read-only compatible internal volume %d:%d found, switch to read-only mode",
+			ubi_msg(ubi, "read-only compatible internal volume %d:%d found, switch to read-only mode",
 				vol_id, lnum);
 			ubi->ro_mode = 1;
 			break;
 
 		case UBI_COMPAT_PRESERVE:
-			ubi_msg("\"preserve\" compatible internal volume %d:%d found",
+			ubi_msg(ubi, "\"preserve\" compatible internal volume %d:%d found",
 				vol_id, lnum);
 			err = add_to_list(ai, pnum, vol_id, lnum,
 					  ec, 0, &ai->alien);
@@ -1024,14 +1028,14 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			return 0;
 
 		case UBI_COMPAT_REJECT:
-			ubi_err("incompatible internal volume %d:%d found",
+			ubi_err(ubi, "incompatible internal volume %d:%d found",
 				vol_id, lnum);
 			return -EINVAL;
 		}
 	}
 
 	if (ec_err)
-		ubi_warn("valid VID header but corrupted EC header at PEB %d",
+		ubi_warn(ubi, "valid VID header but corrupted EC header at PEB %d",
 			 pnum);
 	err = ubi_add_to_av(ubi, ai, pnum, ec, vidh, bitflips);
 	if (err)
@@ -1075,7 +1079,7 @@ static int late_analysis(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	 * with the flash HW or driver.
 	 */
 	if (ai->corr_peb_count) {
-		ubi_err("%d PEBs are corrupted and preserved",
+		ubi_err(ubi, "%d PEBs are corrupted and preserved",
 			ai->corr_peb_count);
 		pr_err("Corrupted PEBs are:");
 		list_for_each_entry(aeb, &ai->corr, u.list)
@@ -1087,7 +1091,7 @@ static int late_analysis(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		 * otherwise, only print a warning.
 		 */
 		if (ai->corr_peb_count >= max_corr) {
-			ubi_err("too many corrupted PEBs, refusing");
+			ubi_err(ubi, "too many corrupted PEBs, refusing");
 			return -EINVAL;
 		}
 	}
@@ -1110,11 +1114,11 @@ static int late_analysis(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		 */
 		if (ai->maybe_bad_peb_count <= 2) {
 			ai->is_empty = 1;
-			ubi_msg("empty MTD device detected");
+			ubi_msg(ubi, "empty MTD device detected");
 			get_random_bytes(&ubi->image_seq,
 					 sizeof(ubi->image_seq));
 		} else {
-			ubi_err("MTD device is not UBI-formatted and possibly contains non-UBI data - refusing it");
+			ubi_err(ubi, "MTD device is not UBI-formatted and possibly contains non-UBI data - refusing it");
 			return -EINVAL;
 		}
 
@@ -1248,7 +1252,7 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			goto out_vidh;
 	}
 
-	ubi_msg("scanning is finished");
+	ubi_msg(ubi, "scanning is finished");
 
 	/* Calculate mean erase counter */
 	if (ai->ec_count)
@@ -1515,37 +1519,37 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		vols_found += 1;
 
 		if (ai->is_empty) {
-			ubi_err("bad is_empty flag");
+			ubi_err(ubi, "bad is_empty flag");
 			goto bad_av;
 		}
 
 		if (av->vol_id < 0 || av->highest_lnum < 0 ||
 		    av->leb_count < 0 || av->vol_type < 0 || av->used_ebs < 0 ||
 		    av->data_pad < 0 || av->last_data_size < 0) {
-			ubi_err("negative values");
+			ubi_err(ubi, "negative values");
 			goto bad_av;
 		}
 
 		if (av->vol_id >= UBI_MAX_VOLUMES &&
 		    av->vol_id < UBI_INTERNAL_VOL_START) {
-			ubi_err("bad vol_id");
+			ubi_err(ubi, "bad vol_id");
 			goto bad_av;
 		}
 
 		if (av->vol_id > ai->highest_vol_id) {
-			ubi_err("highest_vol_id is %d, but vol_id %d is there",
+			ubi_err(ubi, "highest_vol_id is %d, but vol_id %d is there",
 				ai->highest_vol_id, av->vol_id);
 			goto out;
 		}
 
 		if (av->vol_type != UBI_DYNAMIC_VOLUME &&
 		    av->vol_type != UBI_STATIC_VOLUME) {
-			ubi_err("bad vol_type");
+			ubi_err(ubi, "bad vol_type");
 			goto bad_av;
 		}
 
 		if (av->data_pad > ubi->leb_size / 2) {
-			ubi_err("bad data_pad");
+			ubi_err(ubi, "bad data_pad");
 			goto bad_av;
 		}
 
@@ -1557,48 +1561,48 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			leb_count += 1;
 
 			if (aeb->pnum < 0 || aeb->ec < 0) {
-				ubi_err("negative values");
+				ubi_err(ubi, "negative values");
 				goto bad_aeb;
 			}
 
 			if (aeb->ec < ai->min_ec) {
-				ubi_err("bad ai->min_ec (%d), %d found",
+				ubi_err(ubi, "bad ai->min_ec (%d), %d found",
 					ai->min_ec, aeb->ec);
 				goto bad_aeb;
 			}
 
 			if (aeb->ec > ai->max_ec) {
-				ubi_err("bad ai->max_ec (%d), %d found",
+				ubi_err(ubi, "bad ai->max_ec (%d), %d found",
 					ai->max_ec, aeb->ec);
 				goto bad_aeb;
 			}
 
 			if (aeb->pnum >= ubi->peb_count) {
-				ubi_err("too high PEB number %d, total PEBs %d",
+				ubi_err(ubi, "too high PEB number %d, total PEBs %d",
 					aeb->pnum, ubi->peb_count);
 				goto bad_aeb;
 			}
 
 			if (av->vol_type == UBI_STATIC_VOLUME) {
 				if (aeb->lnum >= av->used_ebs) {
-					ubi_err("bad lnum or used_ebs");
+					ubi_err(ubi, "bad lnum or used_ebs");
 					goto bad_aeb;
 				}
 			} else {
 				if (av->used_ebs != 0) {
-					ubi_err("non-zero used_ebs");
+					ubi_err(ubi, "non-zero used_ebs");
 					goto bad_aeb;
 				}
 			}
 
 			if (aeb->lnum > av->highest_lnum) {
-				ubi_err("incorrect highest_lnum or lnum");
+				ubi_err(ubi, "incorrect highest_lnum or lnum");
 				goto bad_aeb;
 			}
 		}
 
 		if (av->leb_count != leb_count) {
-			ubi_err("bad leb_count, %d objects in the tree",
+			ubi_err(ubi, "bad leb_count, %d objects in the tree",
 				leb_count);
 			goto bad_av;
 		}
@@ -1609,13 +1613,13 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 		aeb = last_aeb;
 
 		if (aeb->lnum != av->highest_lnum) {
-			ubi_err("bad highest_lnum");
+			ubi_err(ubi, "bad highest_lnum");
 			goto bad_aeb;
 		}
 	}
 
 	if (vols_found != ai->vols_found) {
-		ubi_err("bad ai->vols_found %d, should be %d",
+		ubi_err(ubi, "bad ai->vols_found %d, should be %d",
 			ai->vols_found, vols_found);
 		goto out;
 	}
@@ -1632,7 +1636,8 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 
 			err = ubi_io_read_vid_hdr(ubi, aeb->pnum, vidh, 1);
 			if (err && err != UBI_IO_BITFLIPS) {
-				ubi_err("VID header is not OK (%d)", err);
+				ubi_err(ubi, "VID header is not OK (%d)",
+						err);
 				if (err > 0)
 					err = -EIO;
 				return err;
@@ -1641,37 +1646,37 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			vol_type = vidh->vol_type == UBI_VID_DYNAMIC ?
 				   UBI_DYNAMIC_VOLUME : UBI_STATIC_VOLUME;
 			if (av->vol_type != vol_type) {
-				ubi_err("bad vol_type");
+				ubi_err(ubi, "bad vol_type");
 				goto bad_vid_hdr;
 			}
 
 			if (aeb->sqnum != be64_to_cpu(vidh->sqnum)) {
-				ubi_err("bad sqnum %llu", aeb->sqnum);
+				ubi_err(ubi, "bad sqnum %llu", aeb->sqnum);
 				goto bad_vid_hdr;
 			}
 
 			if (av->vol_id != be32_to_cpu(vidh->vol_id)) {
-				ubi_err("bad vol_id %d", av->vol_id);
+				ubi_err(ubi, "bad vol_id %d", av->vol_id);
 				goto bad_vid_hdr;
 			}
 
 			if (av->compat != vidh->compat) {
-				ubi_err("bad compat %d", vidh->compat);
+				ubi_err(ubi, "bad compat %d", vidh->compat);
 				goto bad_vid_hdr;
 			}
 
 			if (aeb->lnum != be32_to_cpu(vidh->lnum)) {
-				ubi_err("bad lnum %d", aeb->lnum);
+				ubi_err(ubi, "bad lnum %d", aeb->lnum);
 				goto bad_vid_hdr;
 			}
 
 			if (av->used_ebs != be32_to_cpu(vidh->used_ebs)) {
-				ubi_err("bad used_ebs %d", av->used_ebs);
+				ubi_err(ubi, "bad used_ebs %d", av->used_ebs);
 				goto bad_vid_hdr;
 			}
 
 			if (av->data_pad != be32_to_cpu(vidh->data_pad)) {
-				ubi_err("bad data_pad %d", av->data_pad);
+				ubi_err(ubi, "bad data_pad %d", av->data_pad);
 				goto bad_vid_hdr;
 			}
 		}
@@ -1680,12 +1685,13 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			continue;
 
 		if (av->highest_lnum != be32_to_cpu(vidh->lnum)) {
-			ubi_err("bad highest_lnum %d", av->highest_lnum);
+			ubi_err(ubi, "bad highest_lnum %d", av->highest_lnum);
 			goto bad_vid_hdr;
 		}
 
 		if (av->last_data_size != be32_to_cpu(vidh->data_size)) {
-			ubi_err("bad last_data_size %d", av->last_data_size);
+			ubi_err(ubi, "bad last_data_size %d",
+					av->last_data_size);
 			goto bad_vid_hdr;
 		}
 	}
@@ -1726,7 +1732,7 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	err = 0;
 	for (pnum = 0; pnum < ubi->peb_count; pnum++)
 		if (!buf[pnum]) {
-			ubi_err("PEB %d is not referred", pnum);
+			ubi_err(ubi, "PEB %d is not referred", pnum);
 			err = 1;
 		}
 
@@ -1736,18 +1742,18 @@ static int self_check_ai(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	return 0;
 
 bad_aeb:
-	ubi_err("bad attaching information about LEB %d", aeb->lnum);
+	ubi_err(ubi, "bad attaching information about LEB %d", aeb->lnum);
 	ubi_dump_aeb(aeb, 0);
 	ubi_dump_av(av);
 	goto out;
 
 bad_av:
-	ubi_err("bad attaching information about volume %d", av->vol_id);
+	ubi_err(ubi, "bad attaching information about volume %d", av->vol_id);
 	ubi_dump_av(av);
 	goto out;
 
 bad_vid_hdr:
-	ubi_err("bad attaching information about volume %d", av->vol_id);
+	ubi_err(ubi, "bad attaching information about volume %d", av->vol_id);
 	ubi_dump_av(av);
 	ubi_dump_vid_hdr(vidh);
 
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 8876c7d..657ff08 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -111,12 +111,12 @@ static int __init ubiblock_set_param(const char *val,
 
 	len = strnlen(val, UBIBLOCK_PARAM_LEN);
 	if (len == 0) {
-		ubi_warn("block: empty 'block=' parameter - ignored\n");
+		pr_warn("UBI: block: empty 'block=' parameter - ignored\n");
 		return 0;
 	}
 
 	if (len == UBIBLOCK_PARAM_LEN) {
-		ubi_err("block: parameter \"%s\" is too long, max. is %d\n",
+		pr_err("UBI: block: parameter \"%s\" is too long, max. is %d\n",
 			val, UBIBLOCK_PARAM_LEN);
 		return -EINVAL;
 	}
@@ -188,9 +188,8 @@ static int ubiblock_read_to_buf(struct ubiblock *dev, char *buffer,
 
 	ret = ubi_read(dev->desc, leb, buffer, offset, len);
 	if (ret) {
-		ubi_err("%s: error %d while reading from LEB %d (offset %d, "
-		        "length %d)", dev->gd->disk_name, ret, leb, offset,
-			len);
+		dev_err(disk_to_dev(dev->gd), "%d while reading from LEB %d (offset %d, length %d)",
+			ret, leb, offset, len);
 		return ret;
 	}
 	return 0;
@@ -328,8 +327,8 @@ static int ubiblock_open(struct block_device *bdev, fmode_t mode)
 
 	dev->desc = ubi_open_volume(dev->ubi_num, dev->vol_id, UBI_READONLY);
 	if (IS_ERR(dev->desc)) {
-		ubi_err("%s failed to open ubi volume %d_%d",
-			dev->gd->disk_name, dev->ubi_num, dev->vol_id);
+		dev_err(disk_to_dev(dev->gd), "failed to open ubi volume %d_%d",
+			dev->ubi_num, dev->vol_id);
 		ret = PTR_ERR(dev->desc);
 		dev->desc = NULL;
 		goto out_unlock;
@@ -405,7 +404,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	/* Initialize the gendisk of this ubiblock device */
 	gd = alloc_disk(1);
 	if (!gd) {
-		ubi_err("block: alloc_disk failed");
+		pr_err("UBI: block: alloc_disk failed");
 		ret = -ENODEV;
 		goto out_free_dev;
 	}
@@ -421,7 +420,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 	spin_lock_init(&dev->queue_lock);
 	dev->rq = blk_init_queue(ubiblock_request, &dev->queue_lock);
 	if (!dev->rq) {
-		ubi_err("block: blk_init_queue failed");
+		dev_err(disk_to_dev(gd), "blk_init_queue failed");
 		ret = -ENODEV;
 		goto out_put_disk;
 	}
@@ -446,8 +445,8 @@ int ubiblock_create(struct ubi_volume_info *vi)
 
 	/* Must be the last step: anyone can call file ops from now on */
 	add_disk(dev->gd);
-	ubi_msg("%s created from ubi%d:%d(%s)",
-		dev->gd->disk_name, dev->ubi_num, dev->vol_id, vi->name);
+	dev_info(disk_to_dev(dev->gd), "created from ubi%d:%d(%s)",
+		dev->ubi_num, dev->vol_id, vi->name);
 	return 0;
 
 out_free_queue:
@@ -464,7 +463,7 @@ static void ubiblock_cleanup(struct ubiblock *dev)
 {
 	del_gendisk(dev->gd);
 	blk_cleanup_queue(dev->rq);
-	ubi_msg("%s released", dev->gd->disk_name);
+	dev_info(disk_to_dev(dev->gd), "released");
 	put_disk(dev->gd);
 }
 
@@ -518,8 +517,8 @@ static int ubiblock_resize(struct ubi_volume_info *vi)
 	}
 	if ((sector_t)disk_capacity != disk_capacity) {
 		mutex_unlock(&devices_mutex);
-		ubi_warn("%s: the volume is too big (%d LEBs), cannot resize",
-			 dev->gd->disk_name, vi->size);
+		dev_warn(disk_to_dev(dev->gd), "the volume is too big (%d LEBs), cannot resize",
+			vi->size);
 		return -EFBIG;
 	}
 
@@ -527,7 +526,7 @@ static int ubiblock_resize(struct ubi_volume_info *vi)
 
 	if (get_capacity(dev->gd) != disk_capacity) {
 		set_capacity(dev->gd, disk_capacity);
-		ubi_msg("%s resized to %lld bytes", dev->gd->disk_name,
+		dev_info(disk_to_dev(dev->gd), "resized to %lld bytes",
 			vi->used_bytes);
 	}
 	mutex_unlock(&dev->dev_mutex);
@@ -596,7 +595,7 @@ static int __init ubiblock_create_from_param(void)
 
 		desc = open_volume_desc(p->name, p->ubi_num, p->vol_id);
 		if (IS_ERR(desc)) {
-			ubi_err("block: can't open volume, err=%ld\n",
+			pr_err("UBI: block: can't open volume, err=%ld\n",
 				PTR_ERR(desc));
 			ret = PTR_ERR(desc);
 			break;
@@ -607,7 +606,7 @@ static int __init ubiblock_create_from_param(void)
 
 		ret = ubiblock_create(&vi);
 		if (ret) {
-			ubi_err("block: can't add '%s' volume, err=%d\n",
+			pr_err("UBI: block: can't add '%s' volume, err=%d\n",
 				vi.name, ret);
 			break;
 		}
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 6e30a3c..802f29e 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -166,7 +166,7 @@ int ubi_volume_notify(struct ubi_device *ubi, struct ubi_volume *vol, int ntype)
 	case UBI_VOLUME_RESIZED:
 	case UBI_VOLUME_RENAMED:
 		if (ubi_update_fastmap(ubi)) {
-			ubi_err("Unable to update fastmap!");
+			ubi_err(ubi, "Unable to update fastmap!");
 			ubi_ro_mode(ubi);
 		}
 	}
@@ -517,7 +517,7 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 	 */
 	err = alloc_chrdev_region(&dev, 0, ubi->vtbl_slots + 1, ubi->ubi_name);
 	if (err) {
-		ubi_err("cannot register UBI character devices");
+		ubi_err(ubi, "cannot register UBI character devices");
 		return err;
 	}
 
@@ -528,7 +528,7 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 
 	err = cdev_add(&ubi->cdev, dev, 1);
 	if (err) {
-		ubi_err("cannot add character device");
+		ubi_err(ubi, "cannot add character device");
 		goto out_unreg;
 	}
 
@@ -540,7 +540,7 @@ static int uif_init(struct ubi_device *ubi, int *ref)
 		if (ubi->volumes[i]) {
 			err = ubi_add_volume(ubi, ubi->volumes[i]);
 			if (err) {
-				ubi_err("cannot add volume %d", i);
+				ubi_err(ubi, "cannot add volume %d", i);
 				goto out_volumes;
 			}
 		}
@@ -556,7 +556,8 @@ out_sysfs:
 	cdev_del(&ubi->cdev);
 out_unreg:
 	unregister_chrdev_region(ubi->cdev.dev, ubi->vtbl_slots + 1);
-	ubi_err("cannot initialize UBI %s, error %d", ubi->ubi_name, err);
+	ubi_err(ubi, "cannot initialize UBI %s, error %d",
+		ubi->ubi_name, err);
 	return err;
 }
 
@@ -650,7 +651,7 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 		 * guess we should just pick the largest region. But this is
 		 * not implemented.
 		 */
-		ubi_err("multiple regions, not implemented");
+		ubi_err(ubi, "multiple regions, not implemented");
 		return -EINVAL;
 	}
 
@@ -685,7 +686,7 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	 * which allows us to avoid costly division operations.
 	 */
 	if (!is_power_of_2(ubi->min_io_size)) {
-		ubi_err("min. I/O unit (%d) is not power of 2",
+		ubi_err(ubi, "min. I/O unit (%d) is not power of 2",
 			ubi->min_io_size);
 		return -EINVAL;
 	}
@@ -702,7 +703,7 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	if (ubi->max_write_size < ubi->min_io_size ||
 	    ubi->max_write_size % ubi->min_io_size ||
 	    !is_power_of_2(ubi->max_write_size)) {
-		ubi_err("bad write buffer size %d for %d min. I/O unit",
+		ubi_err(ubi, "bad write buffer size %d for %d min. I/O unit",
 			ubi->max_write_size, ubi->min_io_size);
 		return -EINVAL;
 	}
@@ -739,7 +740,7 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 
 	/* The shift must be aligned to 32-bit boundary */
 	if (ubi->vid_hdr_shift % 4) {
-		ubi_err("unaligned VID header shift %d",
+		ubi_err(ubi, "unaligned VID header shift %d",
 			ubi->vid_hdr_shift);
 		return -EINVAL;
 	}
@@ -749,7 +750,7 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	    ubi->leb_start < ubi->vid_hdr_offset + UBI_VID_HDR_SIZE ||
 	    ubi->leb_start > ubi->peb_size - UBI_VID_HDR_SIZE ||
 	    ubi->leb_start & (ubi->min_io_size - 1)) {
-		ubi_err("bad VID header (%d) or data offsets (%d)",
+		ubi_err(ubi, "bad VID header (%d) or data offsets (%d)",
 			ubi->vid_hdr_offset, ubi->leb_start);
 		return -EINVAL;
 	}
@@ -769,14 +770,14 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	 * read-only mode.
 	 */
 	if (ubi->vid_hdr_offset + UBI_VID_HDR_SIZE <= ubi->hdrs_min_io_size) {
-		ubi_warn("EC and VID headers are in the same minimal I/O unit, switch to read-only mode");
+		ubi_warn(ubi, "EC and VID headers are in the same minimal I/O unit, switch to read-only mode");
 		ubi->ro_mode = 1;
 	}
 
 	ubi->leb_size = ubi->peb_size - ubi->leb_start;
 
 	if (!(ubi->mtd->flags & MTD_WRITEABLE)) {
-		ubi_msg("MTD device %d is write-protected, attach in read-only mode",
+		ubi_msg(ubi, "MTD device %d is write-protected, attach in read-only mode",
 			ubi->mtd->index);
 		ubi->ro_mode = 1;
 	}
@@ -809,7 +810,7 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 	int err, old_reserved_pebs = vol->reserved_pebs;
 
 	if (ubi->ro_mode) {
-		ubi_warn("skip auto-resize because of R/O mode");
+		ubi_warn(ubi, "skip auto-resize because of R/O mode");
 		return 0;
 	}
 
@@ -830,21 +831,22 @@ static int autoresize(struct ubi_device *ubi, int vol_id)
 		vtbl_rec = ubi->vtbl[vol_id];
 		err = ubi_change_vtbl_record(ubi, vol_id, &vtbl_rec);
 		if (err)
-			ubi_err("cannot clean auto-resize flag for volume %d",
+			ubi_err(ubi, "cannot clean auto-resize flag for volume %d",
 				vol_id);
 	} else {
 		desc.vol = vol;
 		err = ubi_resize_volume(&desc,
 					old_reserved_pebs + ubi->avail_pebs);
 		if (err)
-			ubi_err("cannot auto-resize volume %d", vol_id);
+			ubi_err(ubi, "cannot auto-resize volume %d",
+				vol_id);
 	}
 
 	if (err)
 		return err;
 
-	ubi_msg("volume %d (\"%s\") re-sized from %d to %d LEBs", vol_id,
-		vol->name, old_reserved_pebs, vol->reserved_pebs);
+	ubi_msg(ubi, "volume %d (\"%s\") re-sized from %d to %d LEBs",
+		vol_id, vol->name, old_reserved_pebs, vol->reserved_pebs);
 	return 0;
 }
 
@@ -885,7 +887,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	for (i = 0; i < UBI_MAX_DEVICES; i++) {
 		ubi = ubi_devices[i];
 		if (ubi && mtd->index == ubi->mtd->index) {
-			ubi_err("mtd%d is already attached to ubi%d",
+			ubi_err(ubi, "mtd%d is already attached to ubi%d",
 				mtd->index, i);
 			return -EEXIST;
 		}
@@ -900,7 +902,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	 * no sense to attach emulated MTD devices, so we prohibit this.
 	 */
 	if (mtd->type == MTD_UBIVOLUME) {
-		ubi_err("refuse attaching mtd%d - it is already emulated on top of UBI",
+		ubi_err(ubi, "refuse attaching mtd%d - it is already emulated on top of UBI",
 			mtd->index);
 		return -EINVAL;
 	}
@@ -911,7 +913,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 			if (!ubi_devices[ubi_num])
 				break;
 		if (ubi_num == UBI_MAX_DEVICES) {
-			ubi_err("only %d UBI devices may be created",
+			ubi_err(ubi, "only %d UBI devices may be created",
 				UBI_MAX_DEVICES);
 			return -ENFILE;
 		}
@@ -921,7 +923,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 
 		/* Make sure ubi_num is not busy */
 		if (ubi_devices[ubi_num]) {
-			ubi_err("ubi%d already exists", ubi_num);
+			ubi_err(ubi, "ubi%d already exists", ubi_num);
 			return -EEXIST;
 		}
 	}
@@ -953,13 +955,15 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 
 	if (!ubi->fm_disabled && (int)mtd_div_by_eb(ubi->mtd->size, ubi->mtd)
 	    <= UBI_FM_MAX_START) {
-		ubi_err("More than %i PEBs are needed for fastmap, sorry.",
+		ubi_err(ubi, "More than %i PEBs are needed for fastmap, sorry.",
 			UBI_FM_MAX_START);
 		ubi->fm_disabled = 1;
 	}
 
-	ubi_msg("default fastmap pool size: %d", ubi->fm_pool.max_size);
-	ubi_msg("default fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
+	ubi_msg(ubi, "default fastmap pool size: %d",
+		ubi->fm_pool.max_size);
+	ubi_msg(ubi, "default fastmap WL pool size: %d",
+		ubi->fm_wl_pool.max_size);
 #else
 	ubi->fm_disabled = 1;
 #endif
@@ -970,7 +974,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	mutex_init(&ubi->fm_mutex);
 	init_rwsem(&ubi->fm_sem);
 
-	ubi_msg("attaching mtd%d to ubi%d", mtd->index, ubi_num);
+	ubi_msg(ubi, "attaching mtd%d to ubi%d", mtd->index, ubi_num);
 
 	err = io_init(ubi, max_beb_per1024);
 	if (err)
@@ -989,7 +993,8 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 #endif
 	err = ubi_attach(ubi, 0);
 	if (err) {
-		ubi_err("failed to attach mtd%d, error %d", mtd->index, err);
+		ubi_err(ubi, "failed to attach mtd%d, error %d",
+			mtd->index, err);
 		goto out_free;
 	}
 
@@ -1010,28 +1015,28 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	ubi->bgt_thread = kthread_create(ubi_thread, ubi, "%s", ubi->bgt_name);
 	if (IS_ERR(ubi->bgt_thread)) {
 		err = PTR_ERR(ubi->bgt_thread);
-		ubi_err("cannot spawn \"%s\", error %d", ubi->bgt_name,
-			err);
+		ubi_err(ubi, "cannot spawn \"%s\", error %d",
+			ubi->bgt_name, err);
 		goto out_debugfs;
 	}
 
-	ubi_msg("attached mtd%d (name \"%s\", size %llu MiB) to ubi%d",
-		mtd->index, mtd->name, ubi->flash_size >> 20, ubi_num);
-	ubi_msg("PEB size: %d bytes (%d KiB), LEB size: %d bytes",
+	ubi_msg(ubi, "attached mtd%d (name \"%s\", size %llu MiB)",
+		mtd->index, mtd->name, ubi->flash_size >> 20);
+	ubi_msg(ubi, "PEB size: %d bytes (%d KiB), LEB size: %d bytes",
 		ubi->peb_size, ubi->peb_size >> 10, ubi->leb_size);
-	ubi_msg("min./max. I/O unit sizes: %d/%d, sub-page size %d",
+	ubi_msg(ubi, "min./max. I/O unit sizes: %d/%d, sub-page size %d",
 		ubi->min_io_size, ubi->max_write_size, ubi->hdrs_min_io_size);
-	ubi_msg("VID header offset: %d (aligned %d), data offset: %d",
+	ubi_msg(ubi, "VID header offset: %d (aligned %d), data offset: %d",
 		ubi->vid_hdr_offset, ubi->vid_hdr_aloffset, ubi->leb_start);
-	ubi_msg("good PEBs: %d, bad PEBs: %d, corrupted PEBs: %d",
+	ubi_msg(ubi, "good PEBs: %d, bad PEBs: %d, corrupted PEBs: %d",
 		ubi->good_peb_count, ubi->bad_peb_count, ubi->corr_peb_count);
-	ubi_msg("user volume: %d, internal volumes: %d, max. volumes count: %d",
+	ubi_msg(ubi, "user volume: %d, internal volumes: %d, max. volumes count: %d",
 		ubi->vol_count - UBI_INT_VOL_COUNT, UBI_INT_VOL_COUNT,
 		ubi->vtbl_slots);
-	ubi_msg("max/mean erase counter: %d/%d, WL threshold: %d, image sequence number: %u",
+	ubi_msg(ubi, "max/mean erase counter: %d/%d, WL threshold: %d, image sequence number: %u",
 		ubi->max_ec, ubi->mean_ec, CONFIG_MTD_UBI_WL_THRESHOLD,
 		ubi->image_seq);
-	ubi_msg("available PEBs: %d, total reserved PEBs: %d, PEBs reserved for bad PEB handling: %d",
+	ubi_msg(ubi, "available PEBs: %d, total reserved PEBs: %d, PEBs reserved for bad PEB handling: %d",
 		ubi->avail_pebs, ubi->rsvd_pebs, ubi->beb_rsvd_pebs);
 
 	/*
@@ -1100,7 +1105,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 			return -EBUSY;
 		}
 		/* This may only happen if there is a bug */
-		ubi_err("%s reference count %d, destroy anyway",
+		ubi_err(ubi, "%s reference count %d, destroy anyway",
 			ubi->ubi_name, ubi->ref_count);
 	}
 	ubi_devices[ubi_num] = NULL;
@@ -1108,7 +1113,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 
 	ubi_assert(ubi_num == ubi->ubi_num);
 	ubi_notify_all(ubi, UBI_VOLUME_REMOVED, NULL);
-	ubi_msg("detaching mtd%d from ubi%d", ubi->mtd->index, ubi_num);
+	ubi_msg(ubi, "detaching mtd%d", ubi->mtd->index);
 #ifdef CONFIG_MTD_UBI_FASTMAP
 	/* If we don't write a new fastmap at detach time we lose all
 	 * EC updates that have been made since the last written fastmap. */
@@ -1136,7 +1141,7 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	put_mtd_device(ubi->mtd);
 	vfree(ubi->peb_buf);
 	vfree(ubi->fm_buf);
-	ubi_msg("mtd%d is detached from ubi%d", ubi->mtd->index, ubi->ubi_num);
+	ubi_msg(ubi, "mtd%d is detached", ubi->mtd->index);
 	put_device(&ubi->dev);
 	return 0;
 }
@@ -1218,7 +1223,8 @@ static int __init ubi_init(void)
 	BUILD_BUG_ON(sizeof(struct ubi_vid_hdr) != 64);
 
 	if (mtd_devs > UBI_MAX_DEVICES) {
-		ubi_err("too many MTD devices, maximum is %d", UBI_MAX_DEVICES);
+		pr_err("UBI error: too many MTD devices, maximum is %d",
+			UBI_MAX_DEVICES);
 		return -EINVAL;
 	}
 
@@ -1226,19 +1232,19 @@ static int __init ubi_init(void)
 	ubi_class = class_create(THIS_MODULE, UBI_NAME_STR);
 	if (IS_ERR(ubi_class)) {
 		err = PTR_ERR(ubi_class);
-		ubi_err("cannot create UBI class");
+		pr_err("UBI error: cannot create UBI class");
 		goto out;
 	}
 
 	err = class_create_file(ubi_class, &ubi_version);
 	if (err) {
-		ubi_err("cannot create sysfs file");
+		pr_err("UBI error: cannot create sysfs file");
 		goto out_class;
 	}
 
 	err = misc_register(&ubi_ctrl_cdev);
 	if (err) {
-		ubi_err("cannot register device");
+		pr_err("UBI error: cannot register device");
 		goto out_version;
 	}
 
@@ -1265,7 +1271,8 @@ static int __init ubi_init(void)
 		mtd = open_mtd_device(p->name);
 		if (IS_ERR(mtd)) {
 			err = PTR_ERR(mtd);
-			ubi_err("cannot open mtd %s, error %d", p->name, err);
+			pr_err("UBI error: cannot open mtd %s, error %d",
+				 p->name, err);
 			/* See comment below re-ubi_is_module(). */
 			if (ubi_is_module())
 				goto out_detach;
@@ -1277,7 +1284,8 @@ static int __init ubi_init(void)
 					 p->vid_hdr_offs, p->max_beb_per1024);
 		mutex_unlock(&ubi_devices_mutex);
 		if (err < 0) {
-			ubi_err("cannot attach mtd%d", mtd->index);
+			pr_err("UBI error: cannot attach mtd%d",
+				mtd->index);
 			put_mtd_device(mtd);
 
 			/*
@@ -1300,7 +1308,7 @@ static int __init ubi_init(void)
 
 	err = ubiblock_init();
 	if (err) {
-		ubi_err("block: cannot initialize, error %d", err);
+		pr_err("UBI error: block: cannot initialize, error %d", err);
 
 		/* See comment above re-ubi_is_module(). */
 		if (ubi_is_module())
@@ -1326,7 +1334,7 @@ out_version:
 out_class:
 	class_destroy(ubi_class);
 out:
-	ubi_err("cannot initialize UBI, error %d", err);
+	pr_err("UBI error: cannot initialize UBI, error %d", err);
 	return err;
 }
 late_initcall(ubi_init);
@@ -1365,7 +1373,7 @@ static int __init bytes_str_to_int(const char *str)
 
 	result = simple_strtoul(str, &endp, 0);
 	if (str == endp || result >= INT_MAX) {
-		ubi_err("incorrect bytes count: \"%s\"\n", str);
+		pr_err("UBI error: incorrect bytes count: \"%s\"\n", str);
 		return -EINVAL;
 	}
 
@@ -1381,7 +1389,7 @@ static int __init bytes_str_to_int(const char *str)
 	case '\0':
 		break;
 	default:
-		ubi_err("incorrect bytes count: \"%s\"\n", str);
+		pr_err("UBI error: incorrect bytes count: \"%s\"\n", str);
 		return -EINVAL;
 	}
 
@@ -1408,20 +1416,20 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 		return -EINVAL;
 
 	if (mtd_devs == UBI_MAX_DEVICES) {
-		ubi_err("too many parameters, max. is %d\n",
+		pr_err("UBI error: too many parameters, max. is %d\n",
 			UBI_MAX_DEVICES);
 		return -EINVAL;
 	}
 
 	len = strnlen(val, MTD_PARAM_LEN_MAX);
 	if (len == MTD_PARAM_LEN_MAX) {
-		ubi_err("parameter \"%s\" is too long, max. is %d\n",
+		pr_err("UBI error: parameter \"%s\" is too long, max. is %d\n",
 			val, MTD_PARAM_LEN_MAX);
 		return -EINVAL;
 	}
 
 	if (len == 0) {
-		pr_warn("UBI warning: empty 'mtd=' parameter - ignored\n");
+		pr_err("UBI warning: empty 'mtd=' parameter - ignored\n");
 		return 0;
 	}
 
@@ -1435,7 +1443,8 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 		tokens[i] = strsep(&pbuf, ",");
 
 	if (pbuf) {
-		ubi_err("too many arguments at \"%s\"\n", val);
+		pr_err("UBI error: too many arguments at \"%s\"\n",
+			val);
 		return -EINVAL;
 	}
 
@@ -1455,7 +1464,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 		int err = kstrtoint(token, 10, &p->max_beb_per1024);
 
 		if (err) {
-			ubi_err("bad value for max_beb_per1024 parameter: %s",
+			pr_err("UBI error: bad value for max_beb_per1024 parameter: %s",
 				token);
 			return -EINVAL;
 		}
@@ -1466,7 +1475,8 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 		int err = kstrtoint(token, 10, &p->ubi_num);
 
 		if (err) {
-			ubi_err("bad value for ubi_num parameter: %s", token);
+			pr_err("UBI error: bad value for ubi_num parameter: %s",
+				token);
 			return -EINVAL;
 		}
 	} else
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 59de69a..722d57c 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -48,13 +48,14 @@
 
 /**
  * get_exclusive - get exclusive access to an UBI volume.
+ * @ubi: UBI device description object
  * @desc: volume descriptor
  *
  * This function changes UBI volume open mode to "exclusive". Returns previous
  * mode value (positive integer) in case of success and a negative error code
  * in case of failure.
  */
-static int get_exclusive(struct ubi_volume_desc *desc)
+static int get_exclusive(struct ubi_device *ubi, struct ubi_volume_desc *desc)
 {
 	int users, err;
 	struct ubi_volume *vol = desc->vol;
@@ -63,7 +64,7 @@ static int get_exclusive(struct ubi_volume_desc *desc)
 	users = vol->readers + vol->writers + vol->exclusive;
 	ubi_assert(users > 0);
 	if (users > 1) {
-		ubi_err("%d users for volume %d", users, vol->vol_id);
+		ubi_err(ubi, "%d users for volume %d", users, vol->vol_id);
 		err = -EBUSY;
 	} else {
 		vol->readers = vol->writers = 0;
@@ -134,7 +135,7 @@ static int vol_cdev_release(struct inode *inode, struct file *file)
 		vol->ubi->ubi_num, vol->vol_id, desc->mode);
 
 	if (vol->updating) {
-		ubi_warn("update of volume %d not finished, volume is damaged",
+		ubi_warn(vol->ubi, "update of volume %d not finished, volume is damaged",
 			 vol->vol_id);
 		ubi_assert(!vol->changing_leb);
 		vol->updating = 0;
@@ -158,7 +159,7 @@ static loff_t vol_cdev_llseek(struct file *file, loff_t offset, int origin)
 
 	if (vol->updating) {
 		/* Update is in progress, seeking is prohibited */
-		ubi_err("updating");
+		ubi_err(vol->ubi, "updating");
 		return -EBUSY;
 	}
 
@@ -193,11 +194,11 @@ static ssize_t vol_cdev_read(struct file *file, __user char *buf, size_t count,
 		count, *offp, vol->vol_id);
 
 	if (vol->updating) {
-		ubi_err("updating");
+		ubi_err(vol->ubi, "updating");
 		return -EBUSY;
 	}
 	if (vol->upd_marker) {
-		ubi_err("damaged volume, update marker is set");
+		ubi_err(vol->ubi, "damaged volume, update marker is set");
 		return -EBADF;
 	}
 	if (*offp == vol->used_bytes || count == 0)
@@ -277,7 +278,7 @@ static ssize_t vol_cdev_direct_write(struct file *file, const char __user *buf,
 
 	lnum = div_u64_rem(*offp, vol->usable_leb_size, &off);
 	if (off & (ubi->min_io_size - 1)) {
-		ubi_err("unaligned position");
+		ubi_err(ubi, "unaligned position");
 		return -EINVAL;
 	}
 
@@ -286,7 +287,7 @@ static ssize_t vol_cdev_direct_write(struct file *file, const char __user *buf,
 
 	/* We can write only in fractions of the minimum I/O unit */
 	if (count & (ubi->min_io_size - 1)) {
-		ubi_err("unaligned write length");
+		ubi_err(ubi, "unaligned write length");
 		return -EINVAL;
 	}
 
@@ -348,7 +349,7 @@ static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
 		err = ubi_more_leb_change_data(ubi, vol, buf, count);
 
 	if (err < 0) {
-		ubi_err("cannot accept more %zd bytes of data, error %d",
+		ubi_err(ubi, "cannot accept more %zd bytes of data, error %d",
 			count, err);
 		return err;
 	}
@@ -370,7 +371,7 @@ static ssize_t vol_cdev_write(struct file *file, const char __user *buf,
 			return err;
 
 		if (err) {
-			ubi_warn("volume %d on UBI device %d is corrupted",
+			ubi_warn(ubi, "volume %d on UBI device %d is corrupted",
 				 vol->vol_id, ubi->ubi_num);
 			vol->corrupted = 1;
 		}
@@ -420,7 +421,7 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 
-		err = get_exclusive(desc);
+		err = get_exclusive(ubi, desc);
 		if (err < 0)
 			break;
 
@@ -456,7 +457,7 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 		    req.bytes < 0 || req.lnum >= vol->usable_leb_size)
 			break;
 
-		err = get_exclusive(desc);
+		err = get_exclusive(ubi, desc);
 		if (err < 0)
 			break;
 
@@ -642,7 +643,7 @@ static int verify_mkvol_req(const struct ubi_device *ubi,
 	return 0;
 
 bad:
-	ubi_err("bad volume creation request");
+	ubi_err(ubi, "bad volume creation request");
 	ubi_dump_mkvol_req(req);
 	return err;
 }
@@ -708,12 +709,12 @@ static int rename_volumes(struct ubi_device *ubi,
 	for (i = 0; i < req->count - 1; i++) {
 		for (n = i + 1; n < req->count; n++) {
 			if (req->ents[i].vol_id == req->ents[n].vol_id) {
-				ubi_err("duplicated volume id %d",
+				ubi_err(ubi, "duplicated volume id %d",
 					req->ents[i].vol_id);
 				return -EINVAL;
 			}
 			if (!strcmp(req->ents[i].name, req->ents[n].name)) {
-				ubi_err("duplicated volume name \"%s\"",
+				ubi_err(ubi, "duplicated volume name \"%s\"",
 					req->ents[i].name);
 				return -EINVAL;
 			}
@@ -736,7 +737,8 @@ static int rename_volumes(struct ubi_device *ubi,
 		re->desc = ubi_open_volume(ubi->ubi_num, vol_id, UBI_READWRITE);
 		if (IS_ERR(re->desc)) {
 			err = PTR_ERR(re->desc);
-			ubi_err("cannot open volume %d, error %d", vol_id, err);
+			ubi_err(ubi, "cannot open volume %d, error %d",
+					vol_id, err);
 			kfree(re);
 			goto out_free;
 		}
@@ -795,7 +797,7 @@ static int rename_volumes(struct ubi_device *ubi,
 				continue;
 
 			/* The volume exists but busy, or an error occurred */
-			ubi_err("cannot open volume \"%s\", error %d",
+			ubi_err(ubi, "cannot open volume \"%s\", error %d",
 				re->new_name, err);
 			goto out_free;
 		}
diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 63cb1d7..737ae0f 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -43,12 +43,12 @@ void ubi_dump_flash(struct ubi_device *ubi, int pnum, int offset, int len)
 		return;
 	err = mtd_read(ubi->mtd, addr, len, &read, buf);
 	if (err && err != -EUCLEAN) {
-		ubi_err("error %d while reading %d bytes from PEB %d:%d, read %zd bytes",
+		ubi_err(ubi, "err %d while reading %d bytes from PEB %d:%d, read %zd bytes",
 			err, len, pnum, offset, read);
 		goto out;
 	}
 
-	ubi_msg("dumping %d bytes of data from PEB %d, offset %d",
+	ubi_msg(ubi, "dumping %d bytes of data from PEB %d, offset %d",
 		len, pnum, offset);
 	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
 out:
@@ -238,7 +238,7 @@ int ubi_debugfs_init(void)
 	if (IS_ERR_OR_NULL(dfs_rootdir)) {
 		int err = dfs_rootdir ? -ENODEV : PTR_ERR(dfs_rootdir);
 
-		ubi_err("cannot create \"ubi\" debugfs directory, error %d\n",
+		pr_err("UBI error: cannot create \"ubi\" debugfs directory, error %d\n",
 			err);
 		return err;
 	}
@@ -433,7 +433,7 @@ out_remove:
 	debugfs_remove_recursive(d->dfs_dir);
 out:
 	err = dent ? PTR_ERR(dent) : -ENODEV;
-	ubi_err("cannot create \"%s\" debugfs file or directory, error %d\n",
+	ubi_err(ubi, "cannot create \"%s\" debugfs file or directory, error %d\n",
 		fname, err);
 	return err;
 }
diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 2402d3b..97b3dc2 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -422,7 +422,7 @@ retry:
 				 */
 				if (err == UBI_IO_BAD_HDR_EBADMSG ||
 				    err == UBI_IO_BAD_HDR) {
-					ubi_warn("corrupted VID header at PEB %d, LEB %d:%d",
+					ubi_warn(ubi, "corrupted VID header at PEB %d, LEB %d:%d",
 						 pnum, vol_id, lnum);
 					err = -EBADMSG;
 				} else
@@ -448,7 +448,7 @@ retry:
 				goto out_unlock;
 			scrub = 1;
 			if (!check) {
-				ubi_msg("force data checking");
+				ubi_msg(ubi, "force data checking");
 				check = 1;
 				goto retry;
 			}
@@ -459,7 +459,7 @@ retry:
 	if (check) {
 		uint32_t crc1 = crc32(UBI_CRC32_INIT, buf, len);
 		if (crc1 != crc) {
-			ubi_warn("CRC error: calculated %#08x, must be %#08x",
+			ubi_warn(ubi, "CRC error: calculated %#08x, must be %#08x",
 				 crc1, crc);
 			err = -EBADMSG;
 			goto out_unlock;
@@ -513,7 +513,8 @@ retry:
 		return new_pnum;
 	}
 
-	ubi_msg("recover PEB %d, move data to PEB %d", pnum, new_pnum);
+	ubi_msg(ubi, "recover PEB %d, move data to PEB %d",
+		pnum, new_pnum);
 
 	err = ubi_io_read_vid_hdr(ubi, pnum, vid_hdr, 1);
 	if (err && err != UBI_IO_BITFLIPS) {
@@ -554,7 +555,7 @@ retry:
 	up_read(&ubi->fm_sem);
 	ubi_wl_put_peb(ubi, vol_id, lnum, pnum, 1);
 
-	ubi_msg("data was successfully recovered");
+	ubi_msg(ubi, "data was successfully recovered");
 	return 0;
 
 out_unlock:
@@ -569,13 +570,13 @@ write_error:
 	 * Bad luck? This physical eraseblock is bad too? Crud. Let's try to
 	 * get another one.
 	 */
-	ubi_warn("failed to write to PEB %d", new_pnum);
+	ubi_warn(ubi, "failed to write to PEB %d", new_pnum);
 	ubi_wl_put_peb(ubi, vol_id, lnum, new_pnum, 1);
 	if (++tries > UBI_IO_RETRIES) {
 		ubi_free_vid_hdr(ubi, vid_hdr);
 		return err;
 	}
-	ubi_msg("try again");
+	ubi_msg(ubi, "try again");
 	goto retry;
 }
 
@@ -613,7 +614,8 @@ int ubi_eba_write_leb(struct ubi_device *ubi, struct ubi_volume *vol, int lnum,
 
 		err = ubi_io_write_data(ubi, buf, pnum, offset, len);
 		if (err) {
-			ubi_warn("failed to write data to PEB %d", pnum);
+			ubi_warn(ubi, "failed to write data to PEB %d",
+					pnum);
 			if (err == -EIO && ubi->bad_allowed)
 				err = recover_peb(ubi, pnum, vol_id, lnum, buf,
 						  offset, len);
@@ -654,7 +656,7 @@ retry:
 
 	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
 	if (err) {
-		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
+		ubi_warn(ubi, "failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
 		goto write_error;
 	}
@@ -662,7 +664,7 @@ retry:
 	if (len) {
 		err = ubi_io_write_data(ubi, buf, pnum, offset, len);
 		if (err) {
-			ubi_warn("failed to write %d bytes at offset %d of LEB %d:%d, PEB %d",
+			ubi_warn(ubi, "failed to write %d bytes at offset %d of LEB %d:%d, PEB %d",
 				 len, offset, vol_id, lnum, pnum);
 			goto write_error;
 		}
@@ -698,7 +700,7 @@ write_error:
 	}
 
 	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
-	ubi_msg("try another PEB");
+	ubi_msg(ubi, "try another PEB");
 	goto retry;
 }
 
@@ -775,14 +777,14 @@ retry:
 
 	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
 	if (err) {
-		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
+		ubi_warn(ubi, "failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
 		goto write_error;
 	}
 
 	err = ubi_io_write_data(ubi, buf, pnum, 0, len);
 	if (err) {
-		ubi_warn("failed to write %d bytes of data to PEB %d",
+		ubi_warn(ubi, "failed to write %d bytes of data to PEB %d",
 			 len, pnum);
 		goto write_error;
 	}
@@ -818,7 +820,7 @@ write_error:
 	}
 
 	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
-	ubi_msg("try another PEB");
+	ubi_msg(ubi, "try another PEB");
 	goto retry;
 }
 
@@ -893,14 +895,14 @@ retry:
 
 	err = ubi_io_write_vid_hdr(ubi, pnum, vid_hdr);
 	if (err) {
-		ubi_warn("failed to write VID header to LEB %d:%d, PEB %d",
+		ubi_warn(ubi, "failed to write VID header to LEB %d:%d, PEB %d",
 			 vol_id, lnum, pnum);
 		goto write_error;
 	}
 
 	err = ubi_io_write_data(ubi, buf, pnum, 0, len);
 	if (err) {
-		ubi_warn("failed to write %d bytes of data to PEB %d",
+		ubi_warn(ubi, "failed to write %d bytes of data to PEB %d",
 			 len, pnum);
 		goto write_error;
 	}
@@ -940,7 +942,7 @@ write_error:
 	}
 
 	vid_hdr->sqnum = cpu_to_be64(ubi_next_sqnum(ubi));
-	ubi_msg("try another PEB");
+	ubi_msg(ubi, "try another PEB");
 	goto retry;
 }
 
@@ -1063,7 +1065,7 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 	dbg_wl("read %d bytes of data", aldata_size);
 	err = ubi_io_read_data(ubi, ubi->peb_buf, from, 0, aldata_size);
 	if (err && err != UBI_IO_BITFLIPS) {
-		ubi_warn("error %d while reading data from PEB %d",
+		ubi_warn(ubi, "error %d while reading data from PEB %d",
 			 err, from);
 		err = MOVE_SOURCE_RD_ERR;
 		goto out_unlock_buf;
@@ -1113,7 +1115,7 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 	err = ubi_io_read_vid_hdr(ubi, to, vid_hdr, 1);
 	if (err) {
 		if (err != UBI_IO_BITFLIPS) {
-			ubi_warn("error %d while reading VID header back from PEB %d",
+			ubi_warn(ubi, "error %d while reading VID header back from PEB %d",
 				 err, to);
 			if (is_error_sane(err))
 				err = MOVE_TARGET_RD_ERR;
@@ -1140,7 +1142,7 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		err = ubi_io_read_data(ubi, ubi->peb_buf, to, 0, aldata_size);
 		if (err) {
 			if (err != UBI_IO_BITFLIPS) {
-				ubi_warn("error %d while reading data back from PEB %d",
+				ubi_warn(ubi, "error %d while reading data back from PEB %d",
 					 err, to);
 				if (is_error_sane(err))
 					err = MOVE_TARGET_RD_ERR;
@@ -1152,7 +1154,7 @@ int ubi_eba_copy_leb(struct ubi_device *ubi, int from, int to,
 		cond_resched();
 
 		if (crc != crc32(UBI_CRC32_INIT, ubi->peb_buf, data_size)) {
-			ubi_warn("read data back from PEB %d and it is different",
+			ubi_warn(ubi, "read data back from PEB %d and it is different",
 				 to);
 			err = -EINVAL;
 			goto out_unlock_buf;
@@ -1205,10 +1207,10 @@ static void print_rsvd_warning(struct ubi_device *ubi,
 			return;
 	}
 
-	ubi_warn("cannot reserve enough PEBs for bad PEB handling, reserved %d, need %d",
+	ubi_warn(ubi, "cannot reserve enough PEBs for bad PEB handling, reserved %d, need %d",
 		 ubi->beb_rsvd_pebs, ubi->beb_rsvd_level);
 	if (ubi->corr_peb_count)
-		ubi_warn("%d PEBs are corrupted and not used",
+		ubi_warn(ubi, "%d PEBs are corrupted and not used",
 			 ubi->corr_peb_count);
 }
 
@@ -1286,7 +1288,7 @@ int self_check_eba(struct ubi_device *ubi, struct ubi_attach_info *ai_fastmap,
 					fm_eba[i][j] == UBI_LEB_UNMAPPED)
 					continue;
 
-				ubi_err("LEB:%i:%i is PEB:%i instead of %i!",
+				ubi_err(ubi, "LEB:%i:%i is PEB:%i instead of %i!",
 					vol->vol_id, i, fm_eba[i][j],
 					scan_eba[i][j]);
 				ubi_assert(0);
@@ -1366,10 +1368,10 @@ int ubi_eba_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 	}
 
 	if (ubi->avail_pebs < EBA_RESERVED_PEBS) {
-		ubi_err("no enough physical eraseblocks (%d, need %d)",
+		ubi_err(ubi, "no enough physical eraseblocks (%d, need %d)",
 			ubi->avail_pebs, EBA_RESERVED_PEBS);
 		if (ubi->corr_peb_count)
-			ubi_err("%d PEBs are corrupted and not used",
+			ubi_err(ubi, "%d PEBs are corrupted and not used",
 				ubi->corr_peb_count);
 		err = -ENOSPC;
 		goto out_free;
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index cfd5b5e..b56672b 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -330,7 +330,7 @@ static int process_pool_aeb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	if (found)
 		av = tmp_av;
 	else {
-		ubi_err("orphaned volume in fastmap pool!");
+		ubi_err(ubi, "orphaned volume in fastmap pool!");
 		kmem_cache_free(ai->aeb_slab_cache, new_aeb);
 		return UBI_BAD_FASTMAP;
 	}
@@ -414,14 +414,14 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		pnum = be32_to_cpu(pebs[i]);
 
 		if (ubi_io_is_bad(ubi, pnum)) {
-			ubi_err("bad PEB in fastmap pool!");
+			ubi_err(ubi, "bad PEB in fastmap pool!");
 			ret = UBI_BAD_FASTMAP;
 			goto out;
 		}
 
 		err = ubi_io_read_ec_hdr(ubi, pnum, ech, 0);
 		if (err && err != UBI_IO_BITFLIPS) {
-			ubi_err("unable to read EC header! PEB:%i err:%i",
+			ubi_err(ubi, "unable to read EC header! PEB:%i err:%i",
 				pnum, err);
 			ret = err > 0 ? UBI_BAD_FASTMAP : err;
 			goto out;
@@ -435,7 +435,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		image_seq = be32_to_cpu(ech->image_seq);
 
 		if (image_seq && (image_seq != ubi->image_seq)) {
-			ubi_err("bad image seq: 0x%x, expected: 0x%x",
+			ubi_err(ubi, "bad image seq: 0x%x, expected: 0x%x",
 				be32_to_cpu(ech->image_seq), ubi->image_seq);
 			ret = UBI_BAD_FASTMAP;
 			goto out;
@@ -493,7 +493,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			}
 		} else {
 			/* We are paranoid and fall back to scanning mode */
-			ubi_err("fastmap pool PEBs contains damaged PEBs!");
+			ubi_err(ubi, "fastmap pool PEBs contains damaged PEBs!");
 			ret = err > 0 ? UBI_BAD_FASTMAP : err;
 			goto out;
 		}
@@ -588,7 +588,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 		goto fail_bad;
 
 	if (be32_to_cpu(fmhdr->magic) != UBI_FM_HDR_MAGIC) {
-		ubi_err("bad fastmap header magic: 0x%x, expected: 0x%x",
+		ubi_err(ubi, "bad fastmap header magic: 0x%x, expected: 0x%x",
 			be32_to_cpu(fmhdr->magic), UBI_FM_HDR_MAGIC);
 		goto fail_bad;
 	}
@@ -598,7 +598,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	if (fm_pos >= fm_size)
 		goto fail_bad;
 	if (be32_to_cpu(fmpl1->magic) != UBI_FM_POOL_MAGIC) {
-		ubi_err("bad fastmap pool magic: 0x%x, expected: 0x%x",
+		ubi_err(ubi, "bad fastmap pool magic: 0x%x, expected: 0x%x",
 			be32_to_cpu(fmpl1->magic), UBI_FM_POOL_MAGIC);
 		goto fail_bad;
 	}
@@ -608,7 +608,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	if (fm_pos >= fm_size)
 		goto fail_bad;
 	if (be32_to_cpu(fmpl2->magic) != UBI_FM_POOL_MAGIC) {
-		ubi_err("bad fastmap pool magic: 0x%x, expected: 0x%x",
+		ubi_err(ubi, "bad fastmap pool magic: 0x%x, expected: 0x%x",
 			be32_to_cpu(fmpl2->magic), UBI_FM_POOL_MAGIC);
 		goto fail_bad;
 	}
@@ -619,25 +619,26 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 	fm->max_wl_pool_size = be16_to_cpu(fmpl2->max_size);
 
 	if (pool_size > UBI_FM_MAX_POOL_SIZE || pool_size < 0) {
-		ubi_err("bad pool size: %i", pool_size);
+		ubi_err(ubi, "bad pool size: %i", pool_size);
 		goto fail_bad;
 	}
 
 	if (wl_pool_size > UBI_FM_MAX_POOL_SIZE || wl_pool_size < 0) {
-		ubi_err("bad WL pool size: %i", wl_pool_size);
+		ubi_err(ubi, "bad WL pool size: %i", wl_pool_size);
 		goto fail_bad;
 	}
 
 
 	if (fm->max_pool_size > UBI_FM_MAX_POOL_SIZE ||
 	    fm->max_pool_size < 0) {
-		ubi_err("bad maximal pool size: %i", fm->max_pool_size);
+		ubi_err(ubi, "bad maximal pool size: %i", fm->max_pool_size);
 		goto fail_bad;
 	}
 
 	if (fm->max_wl_pool_size > UBI_FM_MAX_POOL_SIZE ||
 	    fm->max_wl_pool_size < 0) {
-		ubi_err("bad maximal WL pool size: %i", fm->max_wl_pool_size);
+		ubi_err(ubi, "bad maximal WL pool size: %i",
+			fm->max_wl_pool_size);
 		goto fail_bad;
 	}
 
@@ -696,8 +697,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		if (be32_to_cpu(fmvhdr->magic) != UBI_FM_VHDR_MAGIC) {
-			ubi_err("bad fastmap vol header magic: 0x%x, " \
-				"expected: 0x%x",
+			ubi_err(ubi, "bad fastmap vol header magic: 0x%x, expected: 0x%x",
 				be32_to_cpu(fmvhdr->magic), UBI_FM_VHDR_MAGIC);
 			goto fail_bad;
 		}
@@ -722,8 +722,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			goto fail_bad;
 
 		if (be32_to_cpu(fm_eba->magic) != UBI_FM_EBA_MAGIC) {
-			ubi_err("bad fastmap EBA header magic: 0x%x, " \
-				"expected: 0x%x",
+			ubi_err(ubi, "bad fastmap EBA header magic: 0x%x, expected: 0x%x",
 				be32_to_cpu(fm_eba->magic), UBI_FM_EBA_MAGIC);
 			goto fail_bad;
 		}
@@ -788,7 +787,7 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 			int err;
 
 			if (ubi_io_is_bad(ubi, tmp_aeb->pnum)) {
-				ubi_err("bad PEB in fastmap EBA orphan list");
+				ubi_err(ubi, "bad PEB in fastmap EBA orphan list");
 				ret = UBI_BAD_FASTMAP;
 				kfree(ech);
 				goto fail;
@@ -796,8 +795,8 @@ static int ubi_attach_fastmap(struct ubi_device *ubi,
 
 			err = ubi_io_read_ec_hdr(ubi, tmp_aeb->pnum, ech, 0);
 			if (err && err != UBI_IO_BITFLIPS) {
-				ubi_err("unable to read EC header! PEB:%i " \
-					"err:%i", tmp_aeb->pnum, err);
+				ubi_err(ubi, "unable to read EC header! PEB:%i err:%i",
+					tmp_aeb->pnum, err);
 				ret = err > 0 ? UBI_BAD_FASTMAP : err;
 				kfree(ech);
 
@@ -908,14 +907,14 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		fm->to_be_tortured[0] = 1;
 
 	if (be32_to_cpu(fmsb->magic) != UBI_FM_SB_MAGIC) {
-		ubi_err("bad super block magic: 0x%x, expected: 0x%x",
+		ubi_err(ubi, "bad super block magic: 0x%x, expected: 0x%x",
 			be32_to_cpu(fmsb->magic), UBI_FM_SB_MAGIC);
 		ret = UBI_BAD_FASTMAP;
 		goto free_fm_sb;
 	}
 
 	if (fmsb->version != UBI_FM_FMT_VERSION) {
-		ubi_err("bad fastmap version: %i, expected: %i",
+		ubi_err(ubi, "bad fastmap version: %i, expected: %i",
 			fmsb->version, UBI_FM_FMT_VERSION);
 		ret = UBI_BAD_FASTMAP;
 		goto free_fm_sb;
@@ -923,15 +922,16 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 	used_blocks = be32_to_cpu(fmsb->used_blocks);
 	if (used_blocks > UBI_FM_MAX_BLOCKS || used_blocks < 1) {
-		ubi_err("number of fastmap blocks is invalid: %i", used_blocks);
+		ubi_err(ubi, "number of fastmap blocks is invalid: %i",
+			used_blocks);
 		ret = UBI_BAD_FASTMAP;
 		goto free_fm_sb;
 	}
 
 	fm_size = ubi->leb_size * used_blocks;
 	if (fm_size != ubi->fm_size) {
-		ubi_err("bad fastmap size: %zi, expected: %zi", fm_size,
-			ubi->fm_size);
+		ubi_err(ubi, "bad fastmap size: %zi, expected: %zi",
+			fm_size, ubi->fm_size);
 		ret = UBI_BAD_FASTMAP;
 		goto free_fm_sb;
 	}
@@ -960,7 +960,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 		ret = ubi_io_read_ec_hdr(ubi, pnum, ech, 0);
 		if (ret && ret != UBI_IO_BITFLIPS) {
-			ubi_err("unable to read fastmap block# %i EC (PEB: %i)",
+			ubi_err(ubi, "unable to read fastmap block# %i EC (PEB: %i)",
 				i, pnum);
 			if (ret > 0)
 				ret = UBI_BAD_FASTMAP;
@@ -977,7 +977,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		 * we shouldn't fail if image_seq == 0.
 		 */
 		if (image_seq && (image_seq != ubi->image_seq)) {
-			ubi_err("wrong image seq:%d instead of %d",
+			ubi_err(ubi, "wrong image seq:%d instead of %d",
 				be32_to_cpu(ech->image_seq), ubi->image_seq);
 			ret = UBI_BAD_FASTMAP;
 			goto free_hdr;
@@ -985,15 +985,14 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 
 		ret = ubi_io_read_vid_hdr(ubi, pnum, vh, 0);
 		if (ret && ret != UBI_IO_BITFLIPS) {
-			ubi_err("unable to read fastmap block# %i (PEB: %i)",
+			ubi_err(ubi, "unable to read fastmap block# %i (PEB: %i)",
 				i, pnum);
 			goto free_hdr;
 		}
 
 		if (i == 0) {
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_SB_VOLUME_ID) {
-				ubi_err("bad fastmap anchor vol_id: 0x%x," \
-					" expected: 0x%x",
+				ubi_err(ubi, "bad fastmap anchor vol_id: 0x%x, expected: 0x%x",
 					be32_to_cpu(vh->vol_id),
 					UBI_FM_SB_VOLUME_ID);
 				ret = UBI_BAD_FASTMAP;
@@ -1001,8 +1000,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 			}
 		} else {
 			if (be32_to_cpu(vh->vol_id) != UBI_FM_DATA_VOLUME_ID) {
-				ubi_err("bad fastmap data vol_id: 0x%x," \
-					" expected: 0x%x",
+				ubi_err(ubi, "bad fastmap data vol_id: 0x%x, expected: 0x%x",
 					be32_to_cpu(vh->vol_id),
 					UBI_FM_DATA_VOLUME_ID);
 				ret = UBI_BAD_FASTMAP;
@@ -1016,7 +1014,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		ret = ubi_io_read(ubi, ubi->fm_buf + (ubi->leb_size * i), pnum,
 				  ubi->leb_start, ubi->leb_size);
 		if (ret && ret != UBI_IO_BITFLIPS) {
-			ubi_err("unable to read fastmap block# %i (PEB: %i, " \
+			ubi_err(ubi, "unable to read fastmap block# %i (PEB: %i, "
 				"err: %i)", i, pnum, ret);
 			goto free_hdr;
 		}
@@ -1030,8 +1028,9 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	fmsb2->data_crc = 0;
 	crc = crc32(UBI_CRC32_INIT, ubi->fm_buf, fm_size);
 	if (crc != tmp_crc) {
-		ubi_err("fastmap data CRC is invalid");
-		ubi_err("CRC should be: 0x%x, calc: 0x%x", tmp_crc, crc);
+		ubi_err(ubi, "fastmap data CRC is invalid");
+		ubi_err(ubi, "CRC should be: 0x%x, calc: 0x%x",
+			tmp_crc, crc);
 		ret = UBI_BAD_FASTMAP;
 		goto free_hdr;
 	}
@@ -1067,9 +1066,10 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 	ubi->fm = fm;
 	ubi->fm_pool.max_size = ubi->fm->max_pool_size;
 	ubi->fm_wl_pool.max_size = ubi->fm->max_wl_pool_size;
-	ubi_msg("attached by fastmap");
-	ubi_msg("fastmap pool size: %d", ubi->fm_pool.max_size);
-	ubi_msg("fastmap WL pool size: %d", ubi->fm_wl_pool.max_size);
+	ubi_msg(ubi, "attached by fastmap");
+	ubi_msg(ubi, "fastmap pool size: %d", ubi->fm_pool.max_size);
+	ubi_msg(ubi, "fastmap WL pool size: %d",
+		ubi->fm_wl_pool.max_size);
 	ubi->fm_disabled = 0;
 
 	ubi_free_vid_hdr(ubi, vh);
@@ -1077,7 +1077,7 @@ int ubi_scan_fastmap(struct ubi_device *ubi, struct ubi_attach_info *ai,
 out:
 	mutex_unlock(&ubi->fm_mutex);
 	if (ret == UBI_BAD_FASTMAP)
-		ubi_err("Attach by fastmap failed, doing a full scan!");
+		ubi_err(ubi, "Attach by fastmap failed, doing a full scan!");
 	return ret;
 
 free_hdr:
@@ -1273,7 +1273,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 	dbg_bld("writing fastmap SB to PEB %i", new_fm->e[0]->pnum);
 	ret = ubi_io_write_vid_hdr(ubi, new_fm->e[0]->pnum, avhdr);
 	if (ret) {
-		ubi_err("unable to write vid_hdr to fastmap SB!");
+		ubi_err(ubi, "unable to write vid_hdr to fastmap SB!");
 		goto out_kfree;
 	}
 
@@ -1293,7 +1293,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 			new_fm->e[i]->pnum, be64_to_cpu(dvhdr->sqnum));
 		ret = ubi_io_write_vid_hdr(ubi, new_fm->e[i]->pnum, dvhdr);
 		if (ret) {
-			ubi_err("unable to write vid_hdr to PEB %i!",
+			ubi_err(ubi, "unable to write vid_hdr to PEB %i!",
 				new_fm->e[i]->pnum);
 			goto out_kfree;
 		}
@@ -1303,7 +1303,7 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		ret = ubi_io_write(ubi, fm_raw + (i * ubi->leb_size),
 			new_fm->e[i]->pnum, ubi->leb_start, ubi->leb_size);
 		if (ret) {
-			ubi_err("unable to write fastmap to PEB %i!",
+			ubi_err(ubi, "unable to write fastmap to PEB %i!",
 				new_fm->e[i]->pnum);
 			goto out_kfree;
 		}
@@ -1450,7 +1450,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	ubi->fm = NULL;
 
 	if (new_fm->used_blocks > UBI_FM_MAX_BLOCKS) {
-		ubi_err("fastmap too large");
+		ubi_err(ubi, "fastmap too large");
 		ret = -ENOSPC;
 		goto err;
 	}
@@ -1462,7 +1462,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 
 		if (!tmp_e && !old_fm) {
 			int j;
-			ubi_err("could not get any free erase block");
+			ubi_err(ubi, "could not get any free erase block");
 
 			for (j = 1; j < i; j++)
 				ubi_wl_put_fm_peb(ubi, new_fm->e[j], j, 0);
@@ -1478,7 +1478,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 					ubi_wl_put_fm_peb(ubi, new_fm->e[j],
 							  j, 0);
 
-				ubi_err("could not erase old fastmap PEB");
+				ubi_err(ubi, "could not erase old fastmap PEB");
 				goto err;
 			}
 
@@ -1504,7 +1504,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 			ret = erase_block(ubi, old_fm->e[0]->pnum);
 			if (ret < 0) {
 				int i;
-				ubi_err("could not erase old anchor PEB");
+				ubi_err(ubi, "could not erase old anchor PEB");
 
 				for (i = 1; i < new_fm->used_blocks; i++)
 					ubi_wl_put_fm_peb(ubi, new_fm->e[i],
@@ -1525,7 +1525,7 @@ int ubi_update_fastmap(struct ubi_device *ubi)
 	} else {
 		if (!tmp_e) {
 			int i;
-			ubi_err("could not find any anchor PEB");
+			ubi_err(ubi, "could not find any anchor PEB");
 
 			for (i = 1; i < new_fm->used_blocks; i++)
 				ubi_wl_put_fm_peb(ubi, new_fm->e[i], i, 0);
@@ -1555,13 +1555,13 @@ out_unlock:
 err:
 	kfree(new_fm);
 
-	ubi_warn("Unable to write new fastmap, err=%i", ret);
+	ubi_warn(ubi, "Unable to write new fastmap, err=%i", ret);
 
 	ret = 0;
 	if (old_fm) {
 		ret = invalidate_fastmap(ubi, old_fm);
 		if (ret < 0)
-			ubi_err("Unable to invalidiate current fastmap!");
+			ubi_err(ubi, "Unable to invalidiate current fastmap!");
 		else if (ret)
 			ret = 0;
 	}
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index d361349..4d972d3 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -177,19 +177,20 @@ retry:
 			 * enabled. A corresponding message will be printed
 			 * later, when it is has been scrubbed.
 			 */
-			ubi_msg("fixable bit-flip detected at PEB %d", pnum);
+			ubi_msg(ubi, "fixable bit-flip detected at PEB %d",
+				pnum);
 			ubi_assert(len == read);
 			return UBI_IO_BITFLIPS;
 		}
 
 		if (retries++ < UBI_IO_RETRIES) {
-			ubi_warn("error %d%s while reading %d bytes from PEB %d:%d, read only %zd bytes, retry",
+			ubi_warn(ubi, "error %d%s while reading %d bytes from PEB %d:%d, read only %zd bytes, retry",
 				 err, errstr, len, pnum, offset, read);
 			yield();
 			goto retry;
 		}
 
-		ubi_err("error %d%s while reading %d bytes from PEB %d:%d, read %zd bytes",
+		ubi_err(ubi, "error %d%s while reading %d bytes from PEB %d:%d, read %zd bytes",
 			err, errstr, len, pnum, offset, read);
 		dump_stack();
 
@@ -246,7 +247,7 @@ int ubi_io_write(struct ubi_device *ubi, const void *buf, int pnum, int offset,
 	ubi_assert(len > 0 && len % ubi->hdrs_min_io_size == 0);
 
 	if (ubi->ro_mode) {
-		ubi_err("read-only mode");
+		ubi_err(ubi, "read-only mode");
 		return -EROFS;
 	}
 
@@ -273,7 +274,7 @@ int ubi_io_write(struct ubi_device *ubi, const void *buf, int pnum, int offset,
 	}
 
 	if (ubi_dbg_is_write_failure(ubi)) {
-		ubi_err("cannot write %d bytes to PEB %d:%d (emulated)",
+		ubi_err(ubi, "cannot write %d bytes to PEB %d:%d (emulated)",
 			len, pnum, offset);
 		dump_stack();
 		return -EIO;
@@ -282,7 +283,7 @@ int ubi_io_write(struct ubi_device *ubi, const void *buf, int pnum, int offset,
 	addr = (loff_t)pnum * ubi->peb_size + offset;
 	err = mtd_write(ubi->mtd, addr, len, &written, buf);
 	if (err) {
-		ubi_err("error %d while writing %d bytes to PEB %d:%d, written %zd bytes",
+		ubi_err(ubi, "error %d while writing %d bytes to PEB %d:%d, written %zd bytes",
 			err, len, pnum, offset, written);
 		dump_stack();
 		ubi_dump_flash(ubi, pnum, offset, len);
@@ -338,7 +339,7 @@ static int do_sync_erase(struct ubi_device *ubi, int pnum)
 	ubi_assert(pnum >= 0 && pnum < ubi->peb_count);
 
 	if (ubi->ro_mode) {
-		ubi_err("read-only mode");
+		ubi_err(ubi, "read-only mode");
 		return -EROFS;
 	}
 
@@ -355,12 +356,12 @@ retry:
 	err = mtd_erase(ubi->mtd, &ei);
 	if (err) {
 		if (retries++ < UBI_IO_RETRIES) {
-			ubi_warn("error %d while erasing PEB %d, retry",
+			ubi_warn(ubi, "error %d while erasing PEB %d, retry",
 				 err, pnum);
 			yield();
 			goto retry;
 		}
-		ubi_err("cannot erase PEB %d, error %d", pnum, err);
+		ubi_err(ubi, "cannot erase PEB %d, error %d", pnum, err);
 		dump_stack();
 		return err;
 	}
@@ -368,17 +369,18 @@ retry:
 	err = wait_event_interruptible(wq, ei.state == MTD_ERASE_DONE ||
 					   ei.state == MTD_ERASE_FAILED);
 	if (err) {
-		ubi_err("interrupted PEB %d erasure", pnum);
+		ubi_err(ubi, "interrupted PEB %d erasure", pnum);
 		return -EINTR;
 	}
 
 	if (ei.state == MTD_ERASE_FAILED) {
 		if (retries++ < UBI_IO_RETRIES) {
-			ubi_warn("error while erasing PEB %d, retry", pnum);
+			ubi_warn(ubi, "error while erasing PEB %d, retry",
+				pnum);
 			yield();
 			goto retry;
 		}
-		ubi_err("cannot erase PEB %d", pnum);
+		ubi_err(ubi, "cannot erase PEB %d", pnum);
 		dump_stack();
 		return -EIO;
 	}
@@ -388,7 +390,7 @@ retry:
 		return err;
 
 	if (ubi_dbg_is_erase_failure(ubi)) {
-		ubi_err("cannot erase PEB %d (emulated)", pnum);
+		ubi_err(ubi, "cannot erase PEB %d (emulated)", pnum);
 		return -EIO;
 	}
 
@@ -411,7 +413,7 @@ static int torture_peb(struct ubi_device *ubi, int pnum)
 {
 	int err, i, patt_count;
 
-	ubi_msg("run torture test for PEB %d", pnum);
+	ubi_msg(ubi, "run torture test for PEB %d", pnum);
 	patt_count = ARRAY_SIZE(patterns);
 	ubi_assert(patt_count > 0);
 
@@ -428,7 +430,7 @@ static int torture_peb(struct ubi_device *ubi, int pnum)
 
 		err = ubi_check_pattern(ubi->peb_buf, 0xFF, ubi->peb_size);
 		if (err == 0) {
-			ubi_err("erased PEB %d, but a non-0xFF byte found",
+			ubi_err(ubi, "erased PEB %d, but a non-0xFF byte found",
 				pnum);
 			err = -EIO;
 			goto out;
@@ -448,7 +450,7 @@ static int torture_peb(struct ubi_device *ubi, int pnum)
 		err = ubi_check_pattern(ubi->peb_buf, patterns[i],
 					ubi->peb_size);
 		if (err == 0) {
-			ubi_err("pattern %x checking failed for PEB %d",
+			ubi_err(ubi, "pattern %x checking failed for PEB %d",
 				patterns[i], pnum);
 			err = -EIO;
 			goto out;
@@ -456,7 +458,7 @@ static int torture_peb(struct ubi_device *ubi, int pnum)
 	}
 
 	err = patt_count;
-	ubi_msg("PEB %d passed torture test, do not mark it as bad", pnum);
+	ubi_msg(ubi, "PEB %d passed torture test, do not mark it as bad", pnum);
 
 out:
 	mutex_unlock(&ubi->buf_mutex);
@@ -466,7 +468,7 @@ out:
 		 * has not passed because it happened on a freshly erased
 		 * physical eraseblock which means something is wrong with it.
 		 */
-		ubi_err("read problems on freshly erased PEB %d, must be bad",
+		ubi_err(ubi, "read problems on freshly erased PEB %d, must be bad",
 			pnum);
 		err = -EIO;
 	}
@@ -542,7 +544,7 @@ error:
 	 * it. Supposedly the flash media or the driver is screwed up, so
 	 * return an error.
 	 */
-	ubi_err("cannot invalidate PEB %d, write returned %d", pnum, err);
+	ubi_err(ubi, "cannot invalidate PEB %d, write returned %d", pnum, err);
 	ubi_dump_flash(ubi, pnum, 0, ubi->peb_size);
 	return -EIO;
 }
@@ -574,7 +576,7 @@ int ubi_io_sync_erase(struct ubi_device *ubi, int pnum, int torture)
 		return err;
 
 	if (ubi->ro_mode) {
-		ubi_err("read-only mode");
+		ubi_err(ubi, "read-only mode");
 		return -EROFS;
 	}
 
@@ -616,7 +618,7 @@ int ubi_io_is_bad(const struct ubi_device *ubi, int pnum)
 
 		ret = mtd_block_isbad(mtd, (loff_t)pnum * ubi->peb_size);
 		if (ret < 0)
-			ubi_err("error %d while checking if PEB %d is bad",
+			ubi_err(ubi, "error %d while checking if PEB %d is bad",
 				ret, pnum);
 		else if (ret)
 			dbg_io("PEB %d is bad", pnum);
@@ -642,7 +644,7 @@ int ubi_io_mark_bad(const struct ubi_device *ubi, int pnum)
 	ubi_assert(pnum >= 0 && pnum < ubi->peb_count);
 
 	if (ubi->ro_mode) {
-		ubi_err("read-only mode");
+		ubi_err(ubi, "read-only mode");
 		return -EROFS;
 	}
 
@@ -651,7 +653,7 @@ int ubi_io_mark_bad(const struct ubi_device *ubi, int pnum)
 
 	err = mtd_block_markbad(mtd, (loff_t)pnum * ubi->peb_size);
 	if (err)
-		ubi_err("cannot mark PEB %d bad, error %d", pnum, err);
+		ubi_err(ubi, "cannot mark PEB %d bad, error %d", pnum, err);
 	return err;
 }
 
@@ -674,32 +676,32 @@ static int validate_ec_hdr(const struct ubi_device *ubi,
 	leb_start = be32_to_cpu(ec_hdr->data_offset);
 
 	if (ec_hdr->version != UBI_VERSION) {
-		ubi_err("node with incompatible UBI version found: this UBI version is %d, image version is %d",
+		ubi_err(ubi, "node with incompatible UBI version found: this UBI version is %d, image version is %d",
 			UBI_VERSION, (int)ec_hdr->version);
 		goto bad;
 	}
 
 	if (vid_hdr_offset != ubi->vid_hdr_offset) {
-		ubi_err("bad VID header offset %d, expected %d",
+		ubi_err(ubi, "bad VID header offset %d, expected %d",
 			vid_hdr_offset, ubi->vid_hdr_offset);
 		goto bad;
 	}
 
 	if (leb_start != ubi->leb_start) {
-		ubi_err("bad data offset %d, expected %d",
+		ubi_err(ubi, "bad data offset %d, expected %d",
 			leb_start, ubi->leb_start);
 		goto bad;
 	}
 
 	if (ec < 0 || ec > UBI_MAX_ERASECOUNTER) {
-		ubi_err("bad erase counter %lld", ec);
+		ubi_err(ubi, "bad erase counter %lld", ec);
 		goto bad;
 	}
 
 	return 0;
 
 bad:
-	ubi_err("bad EC header");
+	ubi_err(ubi, "bad EC header");
 	ubi_dump_ec_hdr(ec_hdr);
 	dump_stack();
 	return 1;
@@ -765,7 +767,7 @@ int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
 		if (ubi_check_pattern(ec_hdr, 0xFF, UBI_EC_HDR_SIZE)) {
 			/* The physical eraseblock is supposedly empty */
 			if (verbose)
-				ubi_warn("no EC header found at PEB %d, only 0xFF bytes",
+				ubi_warn(ubi, "no EC header found at PEB %d, only 0xFF bytes",
 					 pnum);
 			dbg_bld("no EC header found at PEB %d, only 0xFF bytes",
 				pnum);
@@ -780,7 +782,7 @@ int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
 		 * 0xFF bytes. Report that the header is corrupted.
 		 */
 		if (verbose) {
-			ubi_warn("bad magic number at PEB %d: %08x instead of %08x",
+			ubi_warn(ubi, "bad magic number at PEB %d: %08x instead of %08x",
 				 pnum, magic, UBI_EC_HDR_MAGIC);
 			ubi_dump_ec_hdr(ec_hdr);
 		}
@@ -794,7 +796,7 @@ int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
 
 	if (hdr_crc != crc) {
 		if (verbose) {
-			ubi_warn("bad EC header CRC at PEB %d, calculated %#08x, read %#08x",
+			ubi_warn(ubi, "bad EC header CRC at PEB %d, calculated %#08x, read %#08x",
 				 pnum, crc, hdr_crc);
 			ubi_dump_ec_hdr(ec_hdr);
 		}
@@ -810,7 +812,7 @@ int ubi_io_read_ec_hdr(struct ubi_device *ubi, int pnum,
 	/* And of course validate what has just been read from the media */
 	err = validate_ec_hdr(ubi, ec_hdr);
 	if (err) {
-		ubi_err("validation failed for PEB %d", pnum);
+		ubi_err(ubi, "validation failed for PEB %d", pnum);
 		return -EINVAL;
 	}
 
@@ -884,40 +886,40 @@ static int validate_vid_hdr(const struct ubi_device *ubi,
 	int usable_leb_size = ubi->leb_size - data_pad;
 
 	if (copy_flag != 0 && copy_flag != 1) {
-		ubi_err("bad copy_flag");
+		ubi_err(ubi, "bad copy_flag");
 		goto bad;
 	}
 
 	if (vol_id < 0 || lnum < 0 || data_size < 0 || used_ebs < 0 ||
 	    data_pad < 0) {
-		ubi_err("negative values");
+		ubi_err(ubi, "negative values");
 		goto bad;
 	}
 
 	if (vol_id >= UBI_MAX_VOLUMES && vol_id < UBI_INTERNAL_VOL_START) {
-		ubi_err("bad vol_id");
+		ubi_err(ubi, "bad vol_id");
 		goto bad;
 	}
 
 	if (vol_id < UBI_INTERNAL_VOL_START && compat != 0) {
-		ubi_err("bad compat");
+		ubi_err(ubi, "bad compat");
 		goto bad;
 	}
 
 	if (vol_id >= UBI_INTERNAL_VOL_START && compat != UBI_COMPAT_DELETE &&
 	    compat != UBI_COMPAT_RO && compat != UBI_COMPAT_PRESERVE &&
 	    compat != UBI_COMPAT_REJECT) {
-		ubi_err("bad compat");
+		ubi_err(ubi, "bad compat");
 		goto bad;
 	}
 
 	if (vol_type != UBI_VID_DYNAMIC && vol_type != UBI_VID_STATIC) {
-		ubi_err("bad vol_type");
+		ubi_err(ubi, "bad vol_type");
 		goto bad;
 	}
 
 	if (data_pad >= ubi->leb_size / 2) {
-		ubi_err("bad data_pad");
+		ubi_err(ubi, "bad data_pad");
 		goto bad;
 	}
 
@@ -929,45 +931,45 @@ static int validate_vid_hdr(const struct ubi_device *ubi,
 		 * mapped logical eraseblocks.
 		 */
 		if (used_ebs == 0) {
-			ubi_err("zero used_ebs");
+			ubi_err(ubi, "zero used_ebs");
 			goto bad;
 		}
 		if (data_size == 0) {
-			ubi_err("zero data_size");
+			ubi_err(ubi, "zero data_size");
 			goto bad;
 		}
 		if (lnum < used_ebs - 1) {
 			if (data_size != usable_leb_size) {
-				ubi_err("bad data_size");
+				ubi_err(ubi, "bad data_size");
 				goto bad;
 			}
 		} else if (lnum == used_ebs - 1) {
 			if (data_size == 0) {
-				ubi_err("bad data_size at last LEB");
+				ubi_err(ubi, "bad data_size at last LEB");
 				goto bad;
 			}
 		} else {
-			ubi_err("too high lnum");
+			ubi_err(ubi, "too high lnum");
 			goto bad;
 		}
 	} else {
 		if (copy_flag == 0) {
 			if (data_crc != 0) {
-				ubi_err("non-zero data CRC");
+				ubi_err(ubi, "non-zero data CRC");
 				goto bad;
 			}
 			if (data_size != 0) {
-				ubi_err("non-zero data_size");
+				ubi_err(ubi, "non-zero data_size");
 				goto bad;
 			}
 		} else {
 			if (data_size == 0) {
-				ubi_err("zero data_size of copy");
+				ubi_err(ubi, "zero data_size of copy");
 				goto bad;
 			}
 		}
 		if (used_ebs != 0) {
-			ubi_err("bad used_ebs");
+			ubi_err(ubi, "bad used_ebs");
 			goto bad;
 		}
 	}
@@ -975,7 +977,7 @@ static int validate_vid_hdr(const struct ubi_device *ubi,
 	return 0;
 
 bad:
-	ubi_err("bad VID header");
+	ubi_err(ubi, "bad VID header");
 	ubi_dump_vid_hdr(vid_hdr);
 	dump_stack();
 	return 1;
@@ -1020,7 +1022,7 @@ int ubi_io_read_vid_hdr(struct ubi_device *ubi, int pnum,
 
 		if (ubi_check_pattern(vid_hdr, 0xFF, UBI_VID_HDR_SIZE)) {
 			if (verbose)
-				ubi_warn("no VID header found at PEB %d, only 0xFF bytes",
+				ubi_warn(ubi, "no VID header found at PEB %d, only 0xFF bytes",
 					 pnum);
 			dbg_bld("no VID header found at PEB %d, only 0xFF bytes",
 				pnum);
@@ -1031,7 +1033,7 @@ int ubi_io_read_vid_hdr(struct ubi_device *ubi, int pnum,
 		}
 
 		if (verbose) {
-			ubi_warn("bad magic number at PEB %d: %08x instead of %08x",
+			ubi_warn(ubi, "bad magic number at PEB %d: %08x instead of %08x",
 				 pnum, magic, UBI_VID_HDR_MAGIC);
 			ubi_dump_vid_hdr(vid_hdr);
 		}
@@ -1045,7 +1047,7 @@ int ubi_io_read_vid_hdr(struct ubi_device *ubi, int pnum,
 
 	if (hdr_crc != crc) {
 		if (verbose) {
-			ubi_warn("bad CRC at PEB %d, calculated %#08x, read %#08x",
+			ubi_warn(ubi, "bad CRC at PEB %d, calculated %#08x, read %#08x",
 				 pnum, crc, hdr_crc);
 			ubi_dump_vid_hdr(vid_hdr);
 		}
@@ -1059,7 +1061,7 @@ int ubi_io_read_vid_hdr(struct ubi_device *ubi, int pnum,
 
 	err = validate_vid_hdr(ubi, vid_hdr);
 	if (err) {
-		ubi_err("validation failed for PEB %d", pnum);
+		ubi_err(ubi, "validation failed for PEB %d", pnum);
 		return -EINVAL;
 	}
 
@@ -1129,7 +1131,7 @@ static int self_check_not_bad(const struct ubi_device *ubi, int pnum)
 	if (!err)
 		return err;
 
-	ubi_err("self-check failed for PEB %d", pnum);
+	ubi_err(ubi, "self-check failed for PEB %d", pnum);
 	dump_stack();
 	return err > 0 ? -EINVAL : err;
 }
@@ -1154,14 +1156,14 @@ static int self_check_ec_hdr(const struct ubi_device *ubi, int pnum,
 
 	magic = be32_to_cpu(ec_hdr->magic);
 	if (magic != UBI_EC_HDR_MAGIC) {
-		ubi_err("bad magic %#08x, must be %#08x",
+		ubi_err(ubi, "bad magic %#08x, must be %#08x",
 			magic, UBI_EC_HDR_MAGIC);
 		goto fail;
 	}
 
 	err = validate_ec_hdr(ubi, ec_hdr);
 	if (err) {
-		ubi_err("self-check failed for PEB %d", pnum);
+		ubi_err(ubi, "self-check failed for PEB %d", pnum);
 		goto fail;
 	}
 
@@ -1201,8 +1203,9 @@ static int self_check_peb_ec_hdr(const struct ubi_device *ubi, int pnum)
 	crc = crc32(UBI_CRC32_INIT, ec_hdr, UBI_EC_HDR_SIZE_CRC);
 	hdr_crc = be32_to_cpu(ec_hdr->hdr_crc);
 	if (hdr_crc != crc) {
-		ubi_err("bad CRC, calculated %#08x, read %#08x", crc, hdr_crc);
-		ubi_err("self-check failed for PEB %d", pnum);
+		ubi_err(ubi, "bad CRC, calculated %#08x, read %#08x",
+			crc, hdr_crc);
+		ubi_err(ubi, "self-check failed for PEB %d", pnum);
 		ubi_dump_ec_hdr(ec_hdr);
 		dump_stack();
 		err = -EINVAL;
@@ -1236,21 +1239,21 @@ static int self_check_vid_hdr(const struct ubi_device *ubi, int pnum,
 
 	magic = be32_to_cpu(vid_hdr->magic);
 	if (magic != UBI_VID_HDR_MAGIC) {
-		ubi_err("bad VID header magic %#08x at PEB %d, must be %#08x",
+		ubi_err(ubi, "bad VID header magic %#08x at PEB %d, must be %#08x",
 			magic, pnum, UBI_VID_HDR_MAGIC);
 		goto fail;
 	}
 
 	err = validate_vid_hdr(ubi, vid_hdr);
 	if (err) {
-		ubi_err("self-check failed for PEB %d", pnum);
+		ubi_err(ubi, "self-check failed for PEB %d", pnum);
 		goto fail;
 	}
 
 	return err;
 
 fail:
-	ubi_err("self-check failed for PEB %d", pnum);
+	ubi_err(ubi, "self-check failed for PEB %d", pnum);
 	ubi_dump_vid_hdr(vid_hdr);
 	dump_stack();
 	return -EINVAL;
@@ -1288,9 +1291,9 @@ static int self_check_peb_vid_hdr(const struct ubi_device *ubi, int pnum)
 	crc = crc32(UBI_CRC32_INIT, vid_hdr, UBI_EC_HDR_SIZE_CRC);
 	hdr_crc = be32_to_cpu(vid_hdr->hdr_crc);
 	if (hdr_crc != crc) {
-		ubi_err("bad VID header CRC at PEB %d, calculated %#08x, read %#08x",
+		ubi_err(ubi, "bad VID header CRC at PEB %d, calculated %#08x, read %#08x",
 			pnum, crc, hdr_crc);
-		ubi_err("self-check failed for PEB %d", pnum);
+		ubi_err(ubi, "self-check failed for PEB %d", pnum);
 		ubi_dump_vid_hdr(vid_hdr);
 		dump_stack();
 		err = -EINVAL;
@@ -1329,7 +1332,7 @@ static int self_check_write(struct ubi_device *ubi, const void *buf, int pnum,
 
 	buf1 = __vmalloc(len, GFP_NOFS, PAGE_KERNEL);
 	if (!buf1) {
-		ubi_err("cannot allocate memory to check writes");
+		ubi_err(ubi, "cannot allocate memory to check writes");
 		return 0;
 	}
 
@@ -1345,15 +1348,15 @@ static int self_check_write(struct ubi_device *ubi, const void *buf, int pnum,
 		if (c == c1)
 			continue;
 
-		ubi_err("self-check failed for PEB %d:%d, len %d",
+		ubi_err(ubi, "self-check failed for PEB %d:%d, len %d",
 			pnum, offset, len);
-		ubi_msg("data differ at position %d", i);
+		ubi_msg(ubi, "data differ at position %d", i);
 		dump_len = max_t(int, 128, len - i);
-		ubi_msg("hex dump of the original buffer from %d to %d",
+		ubi_msg(ubi, "hex dump of the original buffer from %d to %d",
 			i, i + dump_len);
 		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
 			       buf + i, dump_len, 1);
-		ubi_msg("hex dump of the read buffer from %d to %d",
+		ubi_msg(ubi, "hex dump of the read buffer from %d to %d",
 			i, i + dump_len);
 		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
 			       buf1 + i, dump_len, 1);
@@ -1393,20 +1396,20 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
 
 	buf = __vmalloc(len, GFP_NOFS, PAGE_KERNEL);
 	if (!buf) {
-		ubi_err("cannot allocate memory to check for 0xFFs");
+		ubi_err(ubi, "cannot allocate memory to check for 0xFFs");
 		return 0;
 	}
 
 	err = mtd_read(ubi->mtd, addr, len, &read, buf);
 	if (err && !mtd_is_bitflip(err)) {
-		ubi_err("error %d while reading %d bytes from PEB %d:%d, read %zd bytes",
+		ubi_err(ubi, "err %d while reading %d bytes from PEB %d:%d, read %zd bytes",
 			err, len, pnum, offset, read);
 		goto error;
 	}
 
 	err = ubi_check_pattern(buf, 0xFF, len);
 	if (err == 0) {
-		ubi_err("flash region at PEB %d:%d, length %d does not contain all 0xFF bytes",
+		ubi_err(ubi, "flash region at PEB %d:%d, length %d does not contain all 0xFF bytes",
 			pnum, offset, len);
 		goto fail;
 	}
@@ -1415,8 +1418,9 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
 	return 0;
 
 fail:
-	ubi_err("self-check failed for PEB %d", pnum);
-	ubi_msg("hex dump of the %d-%d region", offset, offset + len);
+	ubi_err(ubi, "self-check failed for PEB %d", pnum);
+	ubi_msg(ubi, "hex dump of the %d-%d region",
+		 offset, offset + len);
 	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
 	err = -EINVAL;
 error:
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 3aac1ac..f3bab66 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -204,7 +204,7 @@ struct ubi_volume_desc *ubi_open_volume(int ubi_num, int vol_id, int mode)
 			return ERR_PTR(err);
 		}
 		if (err == 1) {
-			ubi_warn("volume %d on UBI device %d is corrupted",
+			ubi_warn(ubi, "volume %d on UBI device %d is corrupted",
 				 vol_id, ubi->ubi_num);
 			vol->corrupted = 1;
 		}
@@ -221,7 +221,7 @@ out_free:
 	kfree(desc);
 out_put_ubi:
 	ubi_put_device(ubi);
-	ubi_err("cannot open device %d, volume %d, error %d",
+	ubi_err(ubi, "cannot open device %d, volume %d, error %d",
 		ubi_num, vol_id, err);
 	return ERR_PTR(err);
 }
@@ -411,7 +411,7 @@ int ubi_leb_read(struct ubi_volume_desc *desc, int lnum, char *buf, int offset,
 
 	err = ubi_eba_read_leb(ubi, vol, lnum, buf, offset, len, check);
 	if (err && mtd_is_eccerr(err) && vol->vol_type == UBI_STATIC_VOLUME) {
-		ubi_warn("mark volume %d as corrupted", vol_id);
+		ubi_warn(ubi, "mark volume %d as corrupted", vol_id);
 		vol->corrupted = 1;
 	}
 
diff --git a/drivers/mtd/ubi/misc.c b/drivers/mtd/ubi/misc.c
index f913d70..dbda77e 100644
--- a/drivers/mtd/ubi/misc.c
+++ b/drivers/mtd/ubi/misc.c
@@ -111,7 +111,7 @@ void ubi_update_reserved(struct ubi_device *ubi)
 	ubi->avail_pebs -= need;
 	ubi->rsvd_pebs += need;
 	ubi->beb_rsvd_pebs += need;
-	ubi_msg("reserved more %d PEBs for bad PEB handling", need);
+	ubi_msg(ubi, "reserved more %d PEBs for bad PEB handling", need);
 }
 
 /**
@@ -128,7 +128,7 @@ void ubi_calculate_reserved(struct ubi_device *ubi)
 	ubi->beb_rsvd_level = ubi->bad_peb_limit - ubi->bad_peb_count;
 	if (ubi->beb_rsvd_level < 0) {
 		ubi->beb_rsvd_level = 0;
-		ubi_warn("number of bad PEBs (%d) is above the expected limit (%d), not reserving any PEBs for bad PEB handling, will use available PEBs (if any)",
+		ubi_warn(ubi, "number of bad PEBs (%d) is above the expected limit (%d), not reserving any PEBs for bad PEB handling, will use available PEBs (if any)",
 			 ubi->bad_peb_count, ubi->bad_peb_limit);
 	}
 }
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 320fc38..77970b5 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -50,13 +50,14 @@
 #define UBI_NAME_STR "ubi"
 
 /* Normal UBI messages */
-#define ubi_msg(fmt, ...) pr_notice("UBI: " fmt "\n", ##__VA_ARGS__)
+#define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
+				 ubi->ubi_num, __func__, ##__VA_ARGS__)
 /* UBI warning messages */
-#define ubi_warn(fmt, ...) pr_warn("UBI warning: %s: " fmt "\n",  \
-				   __func__, ##__VA_ARGS__)
+#define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n",  \
+				   ubi->ubi_num, __func__, ##__VA_ARGS__)
 /* UBI error messages */
-#define ubi_err(fmt, ...) pr_err("UBI error: %s: " fmt "\n",      \
-				 __func__, ##__VA_ARGS__)
+#define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n",      \
+				 ubi->ubi_num, __func__, ##__VA_ARGS__)
 
 /* Background thread name pattern */
 #define UBI_BGT_NAME_PATTERN "ubi_bgt%dd"
@@ -987,7 +988,7 @@ static inline void ubi_ro_mode(struct ubi_device *ubi)
 {
 	if (!ubi->ro_mode) {
 		ubi->ro_mode = 1;
-		ubi_warn("switch to read-only mode");
+		ubi_warn(ubi, "switch to read-only mode");
 		dump_stack();
 	}
 }
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 8330703..ff4d978 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -223,7 +223,7 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 			}
 
 		if (vol_id == UBI_VOL_NUM_AUTO) {
-			ubi_err("out of volume IDs");
+			ubi_err(ubi, "out of volume IDs");
 			err = -ENFILE;
 			goto out_unlock;
 		}
@@ -237,7 +237,7 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	/* Ensure that this volume does not exist */
 	err = -EEXIST;
 	if (ubi->volumes[vol_id]) {
-		ubi_err("volume %d already exists", vol_id);
+		ubi_err(ubi, "volume %d already exists", vol_id);
 		goto out_unlock;
 	}
 
@@ -246,7 +246,8 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 		if (ubi->volumes[i] &&
 		    ubi->volumes[i]->name_len == req->name_len &&
 		    !strcmp(ubi->volumes[i]->name, req->name)) {
-			ubi_err("volume \"%s\" exists (ID %d)", req->name, i);
+			ubi_err(ubi, "volume \"%s\" exists (ID %d)",
+				req->name, i);
 			goto out_unlock;
 		}
 
@@ -257,9 +258,10 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 
 	/* Reserve physical eraseblocks */
 	if (vol->reserved_pebs > ubi->avail_pebs) {
-		ubi_err("not enough PEBs, only %d available", ubi->avail_pebs);
+		ubi_err(ubi, "not enough PEBs, only %d available",
+			ubi->avail_pebs);
 		if (ubi->corr_peb_count)
-			ubi_err("%d PEBs are corrupted and not used",
+			ubi_err(ubi, "%d PEBs are corrupted and not used",
 				ubi->corr_peb_count);
 		err = -ENOSPC;
 		goto out_unlock;
@@ -314,7 +316,7 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	dev = MKDEV(MAJOR(ubi->cdev.dev), vol_id + 1);
 	err = cdev_add(&vol->cdev, dev, 1);
 	if (err) {
-		ubi_err("cannot add character device");
+		ubi_err(ubi, "cannot add character device");
 		goto out_mapping;
 	}
 
@@ -326,7 +328,7 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
 	if (err) {
-		ubi_err("cannot register device");
+		ubi_err(ubi, "cannot register device");
 		goto out_cdev;
 	}
 
@@ -386,7 +388,7 @@ out_unlock:
 		kfree(vol);
 	else
 		put_device(&vol->dev);
-	ubi_err("cannot create volume %d, error %d", vol_id, err);
+	ubi_err(ubi, "cannot create volume %d, error %d", vol_id, err);
 	return err;
 }
 
@@ -454,7 +456,7 @@ int ubi_remove_volume(struct ubi_volume_desc *desc, int no_vtbl)
 	return err;
 
 out_err:
-	ubi_err("cannot remove volume %d, error %d", vol_id, err);
+	ubi_err(ubi, "cannot remove volume %d, error %d", vol_id, err);
 	spin_lock(&ubi->volumes_lock);
 	ubi->volumes[vol_id] = vol;
 out_unlock:
@@ -487,7 +489,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 
 	if (vol->vol_type == UBI_STATIC_VOLUME &&
 	    reserved_pebs < vol->used_ebs) {
-		ubi_err("too small size %d, %d LEBs contain data",
+		ubi_err(ubi, "too small size %d, %d LEBs contain data",
 			reserved_pebs, vol->used_ebs);
 		return -EINVAL;
 	}
@@ -516,10 +518,10 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 	if (pebs > 0) {
 		spin_lock(&ubi->volumes_lock);
 		if (pebs > ubi->avail_pebs) {
-			ubi_err("not enough PEBs: requested %d, available %d",
+			ubi_err(ubi, "not enough PEBs: requested %d, available %d",
 				pebs, ubi->avail_pebs);
 			if (ubi->corr_peb_count)
-				ubi_err("%d PEBs are corrupted and not used",
+				ubi_err(ubi, "%d PEBs are corrupted and not used",
 					ubi->corr_peb_count);
 			spin_unlock(&ubi->volumes_lock);
 			err = -ENOSPC;
@@ -643,7 +645,7 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	dev = MKDEV(MAJOR(ubi->cdev.dev), vol->vol_id + 1);
 	err = cdev_add(&vol->cdev, dev, 1);
 	if (err) {
-		ubi_err("cannot add character device for volume %d, error %d",
+		ubi_err(ubi, "cannot add character device for volume %d, error %d",
 			vol_id, err);
 		return err;
 	}
@@ -710,7 +712,7 @@ static int self_check_volume(struct ubi_device *ubi, int vol_id)
 
 	if (!vol) {
 		if (reserved_pebs) {
-			ubi_err("no volume info, but volume exists");
+			ubi_err(ubi, "no volume info, but volume exists");
 			goto fail;
 		}
 		spin_unlock(&ubi->volumes_lock);
@@ -719,90 +721,91 @@ static int self_check_volume(struct ubi_device *ubi, int vol_id)
 
 	if (vol->reserved_pebs < 0 || vol->alignment < 0 || vol->data_pad < 0 ||
 	    vol->name_len < 0) {
-		ubi_err("negative values");
+		ubi_err(ubi, "negative values");
 		goto fail;
 	}
 	if (vol->alignment > ubi->leb_size || vol->alignment == 0) {
-		ubi_err("bad alignment");
+		ubi_err(ubi, "bad alignment");
 		goto fail;
 	}
 
 	n = vol->alignment & (ubi->min_io_size - 1);
 	if (vol->alignment != 1 && n) {
-		ubi_err("alignment is not multiple of min I/O unit");
+		ubi_err(ubi, "alignment is not multiple of min I/O unit");
 		goto fail;
 	}
 
 	n = ubi->leb_size % vol->alignment;
 	if (vol->data_pad != n) {
-		ubi_err("bad data_pad, has to be %lld", n);
+		ubi_err(ubi, "bad data_pad, has to be %lld", n);
 		goto fail;
 	}
 
 	if (vol->vol_type != UBI_DYNAMIC_VOLUME &&
 	    vol->vol_type != UBI_STATIC_VOLUME) {
-		ubi_err("bad vol_type");
+		ubi_err(ubi, "bad vol_type");
 		goto fail;
 	}
 
 	if (vol->upd_marker && vol->corrupted) {
-		ubi_err("update marker and corrupted simultaneously");
+		ubi_err(ubi, "update marker and corrupted simultaneously");
 		goto fail;
 	}
 
 	if (vol->reserved_pebs > ubi->good_peb_count) {
-		ubi_err("too large reserved_pebs");
+		ubi_err(ubi, "too large reserved_pebs");
 		goto fail;
 	}
 
 	n = ubi->leb_size - vol->data_pad;
 	if (vol->usable_leb_size != ubi->leb_size - vol->data_pad) {
-		ubi_err("bad usable_leb_size, has to be %lld", n);
+		ubi_err(ubi, "bad usable_leb_size, has to be %lld", n);
 		goto fail;
 	}
 
 	if (vol->name_len > UBI_VOL_NAME_MAX) {
-		ubi_err("too long volume name, max is %d", UBI_VOL_NAME_MAX);
+		ubi_err(ubi, "too long volume name, max is %d",
+			UBI_VOL_NAME_MAX);
 		goto fail;
 	}
 
 	n = strnlen(vol->name, vol->name_len + 1);
 	if (n != vol->name_len) {
-		ubi_err("bad name_len %lld", n);
+		ubi_err(ubi, "bad name_len %lld", n);
 		goto fail;
 	}
 
 	n = (long long)vol->used_ebs * vol->usable_leb_size;
 	if (vol->vol_type == UBI_DYNAMIC_VOLUME) {
 		if (vol->corrupted) {
-			ubi_err("corrupted dynamic volume");
+			ubi_err(ubi, "corrupted dynamic volume");
 			goto fail;
 		}
 		if (vol->used_ebs != vol->reserved_pebs) {
-			ubi_err("bad used_ebs");
+			ubi_err(ubi, "bad used_ebs");
 			goto fail;
 		}
 		if (vol->last_eb_bytes != vol->usable_leb_size) {
-			ubi_err("bad last_eb_bytes");
+			ubi_err(ubi, "bad last_eb_bytes");
 			goto fail;
 		}
 		if (vol->used_bytes != n) {
-			ubi_err("bad used_bytes");
+			ubi_err(ubi, "bad used_bytes");
 			goto fail;
 		}
 	} else {
 		if (vol->used_ebs < 0 || vol->used_ebs > vol->reserved_pebs) {
-			ubi_err("bad used_ebs");
+			ubi_err(ubi, "bad used_ebs");
 			goto fail;
 		}
 		if (vol->last_eb_bytes < 0 ||
 		    vol->last_eb_bytes > vol->usable_leb_size) {
-			ubi_err("bad last_eb_bytes");
+			ubi_err(ubi, "bad last_eb_bytes");
 			goto fail;
 		}
 		if (vol->used_bytes < 0 || vol->used_bytes > n ||
 		    vol->used_bytes < n - vol->usable_leb_size) {
-			ubi_err("bad used_bytes");
+			ubi_err(ubi, "bad used_bytes");
 			goto fail;
 		}
 	}
@@ -820,7 +823,7 @@ static int self_check_volume(struct ubi_device *ubi, int vol_id)
 	if (alignment != vol->alignment || data_pad != vol->data_pad ||
 	    upd_marker != vol->upd_marker || vol_type != vol->vol_type ||
 	    name_len != vol->name_len || strncmp(name, vol->name, name_len)) {
-		ubi_err("volume info is different");
+		ubi_err(ubi, "volume info is different");
 		goto fail;
 	}
 
@@ -828,7 +831,7 @@ static int self_check_volume(struct ubi_device *ubi, int vol_id)
 	return 0;
 
 fail:
-	ubi_err("self-check failed for volume %d", vol_id);
+	ubi_err(ubi, "self-check failed for volume %d", vol_id);
 	if (vol)
 		ubi_dump_vol_info(vol);
 	ubi_dump_vtbl_record(&ubi->vtbl[vol_id], vol_id);
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index 07cac5f..fd43b3b 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -190,7 +190,7 @@ static int vtbl_check(const struct ubi_device *ubi,
 
 		crc = crc32(UBI_CRC32_INIT, &vtbl[i], UBI_VTBL_RECORD_SIZE_CRC);
 		if (be32_to_cpu(vtbl[i].crc) != crc) {
-			ubi_err("bad CRC at record %u: %#08x, not %#08x",
+			ubi_err(ubi, "bad CRC at record %u: %#08x, not %#08x",
 				 i, crc, be32_to_cpu(vtbl[i].crc));
 			ubi_dump_vtbl_record(&vtbl[i], i);
 			return 1;
@@ -224,7 +224,7 @@ static int vtbl_check(const struct ubi_device *ubi,
 
 		n = ubi->leb_size % alignment;
 		if (data_pad != n) {
-			ubi_err("bad data_pad, has to be %d", n);
+			ubi_err(ubi, "bad data_pad, has to be %d", n);
 			err = 6;
 			goto bad;
 		}
@@ -240,7 +240,7 @@ static int vtbl_check(const struct ubi_device *ubi,
 		}
 
 		if (reserved_pebs > ubi->good_peb_count) {
-			ubi_err("too large reserved_pebs %d, good PEBs %d",
+			ubi_err(ubi, "too large reserved_pebs %d, good PEBs %d",
 				reserved_pebs, ubi->good_peb_count);
 			err = 9;
 			goto bad;
@@ -270,7 +270,7 @@ static int vtbl_check(const struct ubi_device *ubi,
 
 			if (len1 > 0 && len1 == len2 &&
 			    !strncmp(vtbl[i].name, vtbl[n].name, len1)) {
-				ubi_err("volumes %d and %d have the same name \"%s\"",
+				ubi_err(ubi, "volumes %d and %d have the same name \"%s\"",
 					i, n, vtbl[i].name);
 				ubi_dump_vtbl_record(&vtbl[i], i);
 				ubi_dump_vtbl_record(&vtbl[n], n);
@@ -282,7 +282,7 @@ static int vtbl_check(const struct ubi_device *ubi,
 	return 0;
 
 bad:
-	ubi_err("volume table check failed: record %d, error %d", i, err);
+	ubi_err(ubi, "volume table check failed: record %d, error %d", i, err);
 	ubi_dump_vtbl_record(&vtbl[i], i);
 	return -EINVAL;
 }
@@ -446,11 +446,11 @@ static struct ubi_vtbl_record *process_lvol(struct ubi_device *ubi,
 			leb_corrupted[1] = memcmp(leb[0], leb[1],
 						  ubi->vtbl_size);
 		if (leb_corrupted[1]) {
-			ubi_warn("volume table copy #2 is corrupted");
+			ubi_warn(ubi, "volume table copy #2 is corrupted");
 			err = create_vtbl(ubi, ai, 1, leb[0]);
 			if (err)
 				goto out_free;
-			ubi_msg("volume table was restored");
+			ubi_msg(ubi, "volume table was restored");
 		}
 
 		/* Both LEB 1 and LEB 2 are OK and consistent */
@@ -465,15 +465,15 @@ static struct ubi_vtbl_record *process_lvol(struct ubi_device *ubi,
 		}
 		if (leb_corrupted[1]) {
 			/* Both LEB 0 and LEB 1 are corrupted */
-			ubi_err("both volume tables are corrupted");
+			ubi_err(ubi, "both volume tables are corrupted");
 			goto out_free;
 		}
 
-		ubi_warn("volume table copy #1 is corrupted");
+		ubi_warn(ubi, "volume table copy #1 is corrupted");
 		err = create_vtbl(ubi, ai, 0, leb[1]);
 		if (err)
 			goto out_free;
-		ubi_msg("volume table was restored");
+		ubi_msg(ubi, "volume table was restored");
 
 		vfree(leb[0]);
 		return leb[1];
@@ -562,7 +562,7 @@ static int init_volumes(struct ubi_device *ubi,
 		if (vtbl[i].flags & UBI_VTBL_AUTORESIZE_FLG) {
 			/* Auto re-size flag may be set only for one volume */
 			if (ubi->autoresize_vol_id != -1) {
-				ubi_err("more than one auto-resize volume (%d and %d)",
+				ubi_err(ubi, "more than one auto-resize volume (%d and %d)",
 					ubi->autoresize_vol_id, i);
 				kfree(vol);
 				return -EINVAL;
@@ -608,7 +608,7 @@ static int init_volumes(struct ubi_device *ubi,
 			 * We found a static volume which misses several
 			 * eraseblocks. Treat it as corrupted.
 			 */
-			ubi_warn("static volume %d misses %d LEBs - corrupted",
+			ubi_warn(ubi, "static volume %d misses %d LEBs - corrupted",
 				 av->vol_id, av->used_ebs - av->leb_count);
 			vol->corrupted = 1;
 			continue;
@@ -646,10 +646,10 @@ static int init_volumes(struct ubi_device *ubi,
 	vol->ubi = ubi;
 
 	if (reserved_pebs > ubi->avail_pebs) {
-		ubi_err("not enough PEBs, required %d, available %d",
+		ubi_err(ubi, "not enough PEBs, required %d, available %d",
 			reserved_pebs, ubi->avail_pebs);
 		if (ubi->corr_peb_count)
-			ubi_err("%d PEBs are corrupted and not used",
+			ubi_err(ubi, "%d PEBs are corrupted and not used",
 				ubi->corr_peb_count);
 	}
 	ubi->rsvd_pebs += reserved_pebs;
@@ -660,13 +660,14 @@ static int init_volumes(struct ubi_device *ubi,
 
 /**
  * check_av - check volume attaching information.
+ * @ubi: UBI device description object
  * @vol: UBI volume description object
  * @av: volume attaching information
  *
  * This function returns zero if the volume attaching information is consistent
  * to the data read from the volume tabla, and %-EINVAL if not.
  */
-static int check_av(const struct ubi_volume *vol,
+static int check_av(const struct ubi_device *ubi, const struct ubi_volume *vol,
 		    const struct ubi_ainf_volume *av)
 {
 	int err;
@@ -694,7 +695,7 @@ static int check_av(const struct ubi_volume *vol,
 	return 0;
 
 bad:
-	ubi_err("bad attaching information, error %d", err);
+	ubi_err(ubi, "bad attaching information, error %d", err);
 	ubi_dump_av(av);
 	ubi_dump_vol_info(vol);
 	return -EINVAL;
@@ -718,14 +719,15 @@ static int check_attaching_info(const struct ubi_device *ubi,
 	struct ubi_volume *vol;
 
 	if (ai->vols_found > UBI_INT_VOL_COUNT + ubi->vtbl_slots) {
-		ubi_err("found %d volumes while attaching, maximum is %d + %d",
+		ubi_err(ubi, "found %d volumes while attaching, maximum is %d + %d",
 			ai->vols_found, UBI_INT_VOL_COUNT, ubi->vtbl_slots);
 		return -EINVAL;
 	}
 
 	if (ai->highest_vol_id >= ubi->vtbl_slots + UBI_INT_VOL_COUNT &&
 	    ai->highest_vol_id < UBI_INTERNAL_VOL_START) {
-		ubi_err("too large volume ID %d found", ai->highest_vol_id);
+		ubi_err(ubi, "too large volume ID %d found",
+			ai->highest_vol_id);
 		return -EINVAL;
 	}
 
@@ -753,10 +755,11 @@ static int check_attaching_info(const struct ubi_device *ubi,
 			 * reboot while the volume was being removed. Discard
 			 * these eraseblocks.
 			 */
-			ubi_msg("finish volume %d removal", av->vol_id);
+			ubi_msg(ubi, "finish volume %d removal",
+				av->vol_id);
 			ubi_remove_av(ai, av);
 		} else if (av) {
-			err = check_av(vol, av);
+			err = check_av(ubi, vol, av);
 			if (err)
 				return err;
 		}
@@ -807,13 +810,13 @@ int ubi_read_volume_table(struct ubi_device *ubi, struct ubi_attach_info *ai)
 			if (IS_ERR(ubi->vtbl))
 				return PTR_ERR(ubi->vtbl);
 		} else {
-			ubi_err("the layout volume was not found");
+			ubi_err(ubi, "the layout volume was not found");
 			return -EINVAL;
 		}
 	} else {
 		if (av->leb_count > UBI_LAYOUT_VOLUME_EBS) {
 			/* This must not happen with proper UBI images */
-			ubi_err("too many LEBs (%d) in layout volume",
+			ubi_err(ubi, "too many LEBs (%d) in layout volume",
 				av->leb_count);
 			return -EINVAL;
 		}
@@ -862,7 +865,7 @@ static void self_vtbl_check(const struct ubi_device *ubi)
 		return;
 
 	if (vtbl_check(ubi, ubi->vtbl)) {
-		ubi_err("self-check failed");
+		ubi_err(ubi, "self-check failed");
 		BUG();
 	}
 }
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 6654f191..7d2a25f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -253,7 +253,7 @@ static int do_work(struct ubi_device *ubi)
 	 */
 	err = wrk->func(ubi, wrk, 0);
 	if (err)
-		ubi_err("work failed with error code %d", err);
+		ubi_err(ubi, "work failed with error code %d", err);
 	up_read(&ubi->work_sem);
 
 	return err;
@@ -470,8 +470,11 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
 {
 	struct ubi_wl_entry *e = NULL;
 
-	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1))
+	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
+		ubi_warn(ubi, "Can't get peb for fastmap:anchor=%d, free_cnt=%d, reserved=%d",
+			 anchor, ubi->free_count, ubi->beb_rsvd_pebs);
 		goto out;
+	}
 
 	if (anchor)
 		e = find_anchor_wl_entry(&ubi->free);
@@ -507,7 +510,7 @@ static int __wl_get_peb(struct ubi_device *ubi)
 retry:
 	if (!ubi->free.rb_node) {
 		if (ubi->works_count == 0) {
-			ubi_err("no free eraseblocks");
+			ubi_err(ubi, "no free eraseblocks");
 			ubi_assert(list_empty(&ubi->works));
 			return -ENOSPC;
 		}
@@ -520,7 +523,7 @@ retry:
 
 	e = find_mean_wl_entry(ubi, &ubi->free);
 	if (!e) {
-		ubi_err("no free eraseblocks");
+		ubi_err(ubi, "no free eraseblocks");
 		return -ENOSPC;
 	}
 
@@ -692,7 +695,8 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 	err = ubi_self_check_all_ff(ubi, peb, ubi->vid_hdr_aloffset,
 				    ubi->peb_size - ubi->vid_hdr_aloffset);
 	if (err) {
-		ubi_err("new PEB %d does not contain all 0xFF bytes", peb);
+		ubi_err(ubi, "new PEB %d does not contain all 0xFF bytes",
+			peb);
 		return err;
 	}
 
@@ -760,7 +764,7 @@ static int sync_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
 		 * Erase counter overflow. Upgrade UBI and use 64-bit
 		 * erase counters internally.
 		 */
-		ubi_err("erase counter overflow at PEB %d, EC %llu",
+		ubi_err(ubi, "erase counter overflow at PEB %d, EC %llu",
 			e->pnum, ec);
 		err = -EINVAL;
 		goto out_free;
@@ -1137,7 +1141,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 			goto out_not_moved;
 		}
 
-		ubi_err("error %d while reading VID header from PEB %d",
+		ubi_err(ubi, "error %d while reading VID header from PEB %d",
 			err, e1->pnum);
 		goto out_error;
 	}
@@ -1181,7 +1185,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 			 * UBI from trying to move it over and over again.
 			 */
 			if (ubi->erroneous_peb_count > ubi->max_erroneous) {
-				ubi_err("too many erroneous eraseblocks (%d)",
+				ubi_err(ubi, "too many erroneous eraseblocks (%d)",
 					ubi->erroneous_peb_count);
 				goto out_error;
 			}
@@ -1197,7 +1201,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	/* The PEB has been successfully moved */
 	if (scrubbing)
-		ubi_msg("scrubbed PEB %d (LEB %d:%d), data moved to PEB %d",
+		ubi_msg(ubi, "scrubbed PEB %d (LEB %d:%d), data moved to PEB %d",
 			e1->pnum, vol_id, lnum, e2->pnum);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 
@@ -1274,10 +1278,10 @@ out_not_moved:
 
 out_error:
 	if (vol_id != -1)
-		ubi_err("error %d while moving PEB %d to PEB %d",
+		ubi_err(ubi, "error %d while moving PEB %d to PEB %d",
 			err, e1->pnum, e2->pnum);
 	else
-		ubi_err("error %d while moving PEB %d (LEB %d:%d) to PEB %d",
+		ubi_err(ubi, "error %d while moving PEB %d (LEB %d:%d) to PEB %d",
 			err, e1->pnum, vol_id, lnum, e2->pnum);
 	spin_lock(&ubi->wl_lock);
 	ubi->move_from = ubi->move_to = NULL;
@@ -1458,7 +1462,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 		return err;
 	}
 
-	ubi_err("failed to erase PEB %d, error %d", pnum, err);
+	ubi_err(ubi, "failed to erase PEB %d, error %d", pnum, err);
 	kfree(wl_wrk);
 
 	if (err == -EINTR || err == -ENOMEM || err == -EAGAIN ||
@@ -1486,7 +1490,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	/* It is %-EIO, the PEB went bad */
 
 	if (!ubi->bad_allowed) {
-		ubi_err("bad physical eraseblock %d detected", pnum);
+		ubi_err(ubi, "bad physical eraseblock %d detected", pnum);
 		goto out_ro;
 	}
 
@@ -1494,7 +1498,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	if (ubi->beb_rsvd_pebs == 0) {
 		if (ubi->avail_pebs == 0) {
 			spin_unlock(&ubi->volumes_lock);
-			ubi_err("no reserved/available physical eraseblocks");
+			ubi_err(ubi, "no reserved/available physical eraseblocks");
 			goto out_ro;
 		}
 		ubi->avail_pebs -= 1;
@@ -1502,7 +1506,7 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	}
 	spin_unlock(&ubi->volumes_lock);
 
-	ubi_msg("mark PEB %d as bad", pnum);
+	ubi_msg(ubi, "mark PEB %d as bad", pnum);
 	err = ubi_io_mark_bad(ubi, pnum);
 	if (err)
 		goto out_ro;
@@ -1523,11 +1527,12 @@ static int erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk,
 	ubi->good_peb_count -= 1;
 	ubi_calculate_reserved(ubi);
 	if (available_consumed)
-		ubi_warn("no PEBs in the reserved pool, used an available PEB");
+		ubi_warn(ubi, "no PEBs in the reserved pool, used an available PEB");
 	else if (ubi->beb_rsvd_pebs)
-		ubi_msg("%d PEBs left in the reserve", ubi->beb_rsvd_pebs);
+		ubi_msg(ubi, "%d PEBs left in the reserve",
+			ubi->beb_rsvd_pebs);
 	else
-		ubi_warn("last PEB from the reserve was used");
+		ubi_warn(ubi, "last PEB from the reserve was used");
 	spin_unlock(&ubi->volumes_lock);
 
 	return err;
@@ -1613,7 +1618,7 @@ retry:
 		} else {
 			err = prot_queue_del(ubi, e->pnum);
 			if (err) {
-				ubi_err("PEB %d not found", pnum);
+				ubi_err(ubi, "PEB %d not found", pnum);
 				ubi_ro_mode(ubi);
 				spin_unlock(&ubi->wl_lock);
 				return err;
@@ -1646,7 +1651,7 @@ int ubi_wl_scrub_peb(struct ubi_device *ubi, int pnum)
 {
 	struct ubi_wl_entry *e;
 
-	ubi_msg("schedule PEB %d for scrubbing", pnum);
+	ubi_msg(ubi, "schedule PEB %d for scrubbing", pnum);
 
 retry:
 	spin_lock(&ubi->wl_lock);
@@ -1678,7 +1683,7 @@ retry:
 
 		err = prot_queue_del(ubi, e->pnum);
 		if (err) {
-			ubi_err("PEB %d not found", pnum);
+			ubi_err(ubi, "PEB %d not found", pnum);
 			ubi_ro_mode(ubi);
 			spin_unlock(&ubi->wl_lock);
 			return err;
@@ -1798,15 +1803,18 @@ int ubi_thread(void *u)
 	int failures = 0;
 	struct ubi_device *ubi = u;
 
-	ubi_msg("background thread \"%s\" started, PID %d",
+	ubi_msg(ubi, "background thread \"%s\" started, PID %d",
 		ubi->bgt_name, task_pid_nr(current));
 
 	set_freezable();
 	for (;;) {
 		int err;
 
-		if (kthread_should_stop())
+		if (kthread_should_stop()) {
+			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
+				ubi->bgt_name, task_pid_nr(current));
 			break;
+		}
 
 		if (try_to_freeze())
 			continue;
@@ -1823,14 +1831,14 @@ int ubi_thread(void *u)
 
 		err = do_work(ubi);
 		if (err) {
-			ubi_err("%s: work failed with error code %d",
+			ubi_err(ubi, "%s: work failed with error code %d",
 				ubi->bgt_name, err);
 			if (failures++ > WL_MAX_FAILURES) {
 				/*
 				 * Too many failures, disable the thread and
 				 * switch to read-only mode.
 				 */
-				ubi_msg("%s: %d consecutive failures",
+				ubi_msg(ubi, "%s: %d consecutive failures",
 					ubi->bgt_name, WL_MAX_FAILURES);
 				ubi_ro_mode(ubi);
 				ubi->thread_enabled = 0;
@@ -1981,10 +1989,10 @@ int ubi_wl_init(struct ubi_device *ubi, struct ubi_attach_info *ai)
 #endif
 
 	if (ubi->avail_pebs < reserved_pebs) {
-		ubi_err("no enough physical eraseblocks (%d, need %d)",
+		ubi_err(ubi, "no enough physical eraseblocks (%d, need %d)",
 			ubi->avail_pebs, reserved_pebs);
 		if (ubi->corr_peb_count)
-			ubi_err("%d PEBs are corrupted and not used",
+			ubi_err(ubi, "%d PEBs are corrupted and not used",
 				ubi->corr_peb_count);
 		goto out_free;
 	}
@@ -2072,8 +2080,8 @@ static int self_check_ec(struct ubi_device *ubi, int pnum, int ec)
 
 	read_ec = be64_to_cpu(ec_hdr->ec);
 	if (ec != read_ec && read_ec - ec > 1) {
-		ubi_err("self-check failed for PEB %d", pnum);
-		ubi_err("read EC is %lld, should be %d", read_ec, ec);
+		ubi_err(ubi, "self-check failed for PEB %d", pnum);
+		ubi_err(ubi, "read EC is %lld, should be %d", read_ec, ec);
 		dump_stack();
 		err = 1;
 	} else
@@ -2102,7 +2110,7 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 	if (in_wl_tree(e, root))
 		return 0;
 
-	ubi_err("self-check failed for PEB %d, EC %d, RB-tree %p ",
+	ubi_err(ubi, "self-check failed for PEB %d, EC %d, RB-tree %p ",
 		e->pnum, e->ec, root);
 	dump_stack();
 	return -EINVAL;
@@ -2130,7 +2138,7 @@ static int self_check_in_pq(const struct ubi_device *ubi,
 			if (p == e)
 				return 0;
 
-	ubi_err("self-check failed for PEB %d, EC %d, Protect queue",
+	ubi_err(ubi, "self-check failed for PEB %d, EC %d, Protect queue",
 		e->pnum, e->ec);
 	dump_stack();
 	return -EINVAL;
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project
