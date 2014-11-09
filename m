Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbaKILGj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 06:06:39 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:35492 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaKILGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 06:06:37 -0500
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com, hujianyang@huawei.com
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] UBI: Extend UBI layer debug/messaging capabilities - cosmetics
Date: Sun,  9 Nov 2014 13:06:25 +0200
Message-Id: <1415531185-2343-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some cosmetic fixes to the patch "UBI: Extend UBI layer debug/messaging
capabilities".

Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
---
Changes from original patch:
	- Added ptr verification @ ubi_err/ubi_msg/ubi_warn
	Removed extra printing of ubi number
	Removed new messages.

 drivers/mtd/ubi/build.c |  6 +++---
 drivers/mtd/ubi/cdev.c  |  9 ++++-----
 drivers/mtd/ubi/io.c    |  3 +--
 drivers/mtd/ubi/ubi.h   |  9 ++++++---
 drivers/mtd/ubi/vtbl.c  |  7 +++----
 drivers/mtd/ubi/wl.c    | 10 ++--------
 6 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 3405be4..ba01a8d 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -923,7 +923,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 
 		/* Make sure ubi_num is not busy */
 		if (ubi_devices[ubi_num]) {
-			ubi_err(ubi, "ubi%d already exists", ubi_num);
+			ubi_err(ubi, "already exists");
 			return -EEXIST;
 		}
 	}
@@ -973,7 +973,7 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 	mutex_init(&ubi->fm_mutex);
 	init_rwsem(&ubi->fm_sem);
 
-	ubi_msg(ubi, "attaching mtd%d to ubi%d", mtd->index, ubi_num);
+	ubi_msg(ubi, "attaching mtd%d", mtd->index);
 
 	err = io_init(ubi, max_beb_per1024);
 	if (err)
@@ -1428,7 +1428,7 @@ static int __init ubi_mtd_param_parse(const char *val, struct kernel_param *kp)
 	}
 
 	if (len == 0) {
-		pr_err("UBI warning: empty 'mtd=' parameter - ignored\n");
+		pr_warn("UBI warning: empty 'mtd=' parameter - ignored\n");
 		return 0;
 	}
 
diff --git a/drivers/mtd/ubi/cdev.c b/drivers/mtd/ubi/cdev.c
index 3410ea81..bbef168 100644
--- a/drivers/mtd/ubi/cdev.c
+++ b/drivers/mtd/ubi/cdev.c
@@ -48,14 +48,13 @@
 
 /**
  * get_exclusive - get exclusive access to an UBI volume.
- * @ubi: UBI device description object
  * @desc: volume descriptor
  *
  * This function changes UBI volume open mode to "exclusive". Returns previous
  * mode value (positive integer) in case of success and a negative error code
  * in case of failure.
  */
-static int get_exclusive(struct ubi_device *ubi, struct ubi_volume_desc *desc)
+static int get_exclusive(struct ubi_volume_desc *desc)
 {
 	int users, err;
 	struct ubi_volume *vol = desc->vol;
@@ -64,7 +63,7 @@ static int get_exclusive(struct ubi_device *ubi, struct ubi_volume_desc *desc)
 	users = vol->readers + vol->writers + vol->exclusive;
 	ubi_assert(users > 0);
 	if (users > 1) {
-		ubi_err(ubi, "%d users for volume %d", users, vol->vol_id);
+		ubi_err(vol->ubi, "%d users for volume %d", users, vol->vol_id);
 		err = -EBUSY;
 	} else {
 		vol->readers = vol->writers = 0;
@@ -421,7 +420,7 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 			break;
 		}
 
-		err = get_exclusive(ubi, desc);
+		err = get_exclusive(desc);
 		if (err < 0)
 			break;
 
@@ -457,7 +456,7 @@ static long vol_cdev_ioctl(struct file *file, unsigned int cmd,
 		    req.bytes < 0 || req.lnum >= vol->usable_leb_size)
 			break;
 
-		err = get_exclusive(ubi, desc);
+		err = get_exclusive(desc);
 		if (err < 0)
 			break;
 
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 396aaa5..ed0bcb3 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -1419,8 +1419,7 @@ int ubi_self_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
 
 fail:
 	ubi_err(ubi, "self-check failed for PEB %d", pnum);
-	ubi_msg(ubi, "hex dump of the %d-%d region",
-		 offset, offset + len);
+	ubi_msg(ubi, "hex dump of the %d-%d region", offset, offset + len);
 	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
 	err = -EINVAL;
 error:
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index f80ffab..88c2e9f 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -51,13 +51,16 @@
 
 /* Normal UBI messages */
 #define ubi_msg(ubi, fmt, ...) pr_notice("UBI-%d: %s:" fmt "\n", \
-					 ubi->ubi_num, __func__, ##__VA_ARGS__)
+				(ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
+				__func__, ##__VA_ARGS__)
 /* UBI warning messages */
 #define ubi_warn(ubi, fmt, ...) pr_warn("UBI-%d warning: %s: " fmt "\n", \
-					ubi->ubi_num, __func__, ##__VA_ARGS__)
+				(ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
+				__func__, ##__VA_ARGS__)
 /* UBI error messages */
 #define ubi_err(ubi, fmt, ...) pr_err("UBI-%d error: %s: " fmt "\n", \
-				      ubi->ubi_num, __func__, ##__VA_ARGS__)
+				(ubi ? ubi->ubi_num : UBI_MAX_DEVICES), \
+				__func__, ##__VA_ARGS__)
 
 /* Background thread name pattern */
 #define UBI_BGT_NAME_PATTERN "ubi_bgt%dd"
diff --git a/drivers/mtd/ubi/vtbl.c b/drivers/mtd/ubi/vtbl.c
index f8fc308..68c9c5ea 100644
--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -655,14 +655,13 @@ static int init_volumes(struct ubi_device *ubi,
 
 /**
  * check_av - check volume attaching information.
- * @ubi: UBI device description object
  * @vol: UBI volume description object
  * @av: volume attaching information
  *
  * This function returns zero if the volume attaching information is consistent
  * to the data read from the volume tabla, and %-EINVAL if not.
  */
-static int check_av(const struct ubi_device *ubi, const struct ubi_volume *vol,
+static int check_av(const struct ubi_volume *vol,
 		    const struct ubi_ainf_volume *av)
 {
 	int err;
@@ -690,7 +689,7 @@ static int check_av(const struct ubi_device *ubi, const struct ubi_volume *vol,
 	return 0;
 
 bad:
-	ubi_err(ubi, "bad attaching information, error %d", err);
+	ubi_err(vol->ubi, "bad attaching information, error %d", err);
 	ubi_dump_av(av);
 	ubi_dump_vol_info(vol);
 	return -EINVAL;
@@ -753,7 +752,7 @@ static int check_attaching_info(const struct ubi_device *ubi,
 			ubi_msg(ubi, "finish volume %d removal", av->vol_id);
 			ubi_remove_av(ai, av);
 		} else if (av) {
-			err = check_av(ubi, vol, av);
+			err = check_av(vol, av);
 			if (err)
 				return err;
 		}
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 834f6fe..8f7bde6 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -470,11 +470,8 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
 {
 	struct ubi_wl_entry *e = NULL;
 
-	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1)) {
-		ubi_warn(ubi, "Can't get peb for fastmap:anchor=%d, free_cnt=%d, reserved=%d",
-			 anchor, ubi->free_count, ubi->beb_rsvd_pebs);
+	if (!ubi->free.rb_node || (ubi->free_count - ubi->beb_rsvd_pebs < 1))
 		goto out;
-	}
 
 	if (anchor)
 		e = find_anchor_wl_entry(&ubi->free);
@@ -1806,11 +1803,8 @@ int ubi_thread(void *u)
 	for (;;) {
 		int err;
 
-		if (kthread_should_stop()) {
-			ubi_msg(ubi, "background thread \"%s\" should stop, PID %d",
-				ubi->bgt_name, task_pid_nr(current));
+		if (kthread_should_stop())
 			break;
-		}
 
 		if (try_to_freeze())
 			continue;
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project

