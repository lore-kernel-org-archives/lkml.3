Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaJZNut (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 09:50:49 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:54235 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaJZNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 09:50:46 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com, richard@nod.at
Cc: linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Tanya Brokhman <tlinder@codeaurora.org>,
        Pratibhasagar V <pratibha@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH/RESEND 5/5 v2] mtd: ubi: Add sysfs entry to force all pebs' scan
Date: Sun, 26 Oct 2014 15:50:36 +0200
Message-Id: <1414331436-28888-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A given eraseblock can be read many times or not at all.
We do not have the account of such eraseblocks that have
not been accessed since a pre-defined threshold interval.
By means of scanning the entire flash device it is possible to identify
all such eraseblocks.

Add a sysfs entry to force scan on all the PEBs on demand basis.

The sysfs entry would be available under /sys/class/ubi/ubiX/peb_scan
 - echo 1 to this entry would trigger the scan, ignored if in progress
 - On reading returns the scan status (1 = Scan executing, 0 = Scan not
   executing)

Signed-off-by: Pratibhasagar V <pratibha@codeaurora.org>
Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
---
 drivers/mtd/ubi/build.c |  32 +++++++++--
 drivers/mtd/ubi/ubi.h   |   3 +
 drivers/mtd/ubi/wl.c    | 143 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 171 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 34fe23a..a7464f8 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -154,6 +154,9 @@ static struct device_attribute dev_dt_threshold =
 static struct device_attribute dev_rd_threshold =
 	__ATTR(rd_threshold, (S_IWUSR | S_IRUGO), dev_attribute_show,
 		   dev_attribute_store);
+static struct device_attribute dev_mtd_trigger_scan =
+	__ATTR(peb_scan, (S_IWUSR | S_IRUGO),
+		dev_attribute_show, dev_attribute_store);
 
 /**
  * ubi_volume_notify - send a volume change notification.
@@ -395,6 +398,8 @@ static ssize_t dev_attribute_show(struct device *dev,
 		ret = sprintf(buf, "%d\n", ubi->dt_threshold);
 	else if (attr == &dev_rd_threshold)
 		ret = sprintf(buf, "%d\n", ubi->rd_threshold);
+	else if (attr == &dev_mtd_trigger_scan)
+		ret = sprintf(buf, "%d\n", ubi->scan_in_progress);
 	else
 		ret = -EINVAL;
 
@@ -406,7 +411,7 @@ static ssize_t dev_attribute_store(struct device *dev,
 			   struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-	int value;
+	int value, ret;
 	struct ubi_device *ubi;
 
 	ubi = container_of(dev, struct ubi_device, dev);
@@ -414,8 +419,11 @@ static ssize_t dev_attribute_store(struct device *dev,
 	if (!ubi)
 		return -ENODEV;
 
-	if (kstrtos32(buf, 10, &value))
-		return -EINVAL;
+	ret = count;
+	if (kstrtos32(buf, 10, &value)) {
+		ret = -EINVAL;
+		goto out;
+	}
 	/* Consider triggering full scan if threshods change */
 	else if (attr == &dev_dt_threshold) {
 		if (value < UBI_MAX_DT_THRESHOLD)
@@ -429,9 +437,21 @@ static ssize_t dev_attribute_store(struct device *dev,
 		else
 			pr_err("Max supported threshold value is %d",
 				   UBI_MAX_READCOUNTER);
+	} else if (attr == &dev_mtd_trigger_scan) {
+		if (value != 1) {
+			pr_err("Invalid input. Echo 1 to start trigger");
+			goto out;
+		}
+		if (!ubi->lookuptbl) {
+			pr_err("lookuptbl is null");
+			goto out;
+		}
+		ret = ubi_wl_scan_all(ubi);
 	}
 
-	return count;
+out:
+	ubi_put_device(ubi);
+	return ret;
 }
 
 static void dev_release(struct device *dev)
@@ -500,6 +520,9 @@ static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
 	if (err)
 		return err;
 	err = device_create_file(&ubi->dev, &dev_rd_threshold);
+	if (err)
+		return err;
+	err = device_create_file(&ubi->dev, &dev_mtd_trigger_scan);
 	return err;
 }
 
@@ -509,6 +532,7 @@ static int ubi_sysfs_init(struct ubi_device *ubi, int *ref)
  */
 static void ubi_sysfs_close(struct ubi_device *ubi)
 {
+	device_remove_file(&ubi->dev, &dev_mtd_trigger_scan);
 	device_remove_file(&ubi->dev, &dev_mtd_num);
 	device_remove_file(&ubi->dev, &dev_dt_threshold);
 	device_remove_file(&ubi->dev, &dev_rd_threshold);
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index ed04de2..1079517 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -491,6 +491,7 @@ struct ubi_debug_info {
  *				for more info
  * @dt_threshold: data retention threshold. See UBI_DT_THRESHOLD
  *				for more info
+ * @scan_in_progress: true if scanning of device PEBs is in progress
  *
  * @flash_size: underlying MTD device size (in bytes)
  * @peb_count: count of physical eraseblocks on the MTD device
@@ -595,6 +596,7 @@ struct ubi_device {
 	char bgt_name[sizeof(UBI_BGT_NAME_PATTERN)+2];
 	int rd_threshold;
 	int dt_threshold;
+	bool scan_in_progress;
 
 
 	/* I/O sub-system's stuff */
@@ -873,6 +875,7 @@ int ubi_is_erase_work(struct ubi_work *wrk);
 void ubi_refill_pools(struct ubi_device *ubi);
 int ubi_ensure_anchor_pebs(struct ubi_device *ubi);
 int ubi_in_wl_tree(struct ubi_wl_entry *e, struct rb_root *root);
+int ubi_wl_scan_all(struct ubi_device *ubi);
 
 /* io.c */
 int ubi_io_read(const struct ubi_device *ubi, void *buf, int pnum, int offset,
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index a5d754f..4edbb4c 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -143,6 +143,8 @@ static int self_check_in_wl_tree(const struct ubi_device *ubi,
 				 struct ubi_wl_entry *e, struct rb_root *root);
 static int self_check_in_pq(const struct ubi_device *ubi,
 			    struct ubi_wl_entry *e);
+static int schedule_erase(struct ubi_device *ubi, struct ubi_wl_entry *e,
+			  int vol_id, int lnum, int torture);
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
 /**
@@ -555,8 +557,11 @@ retry:
 static void return_unused_pool_pebs(struct ubi_device *ubi,
 				    struct ubi_fm_pool *pool)
 {
-	int i;
+	int i, err;
 	struct ubi_wl_entry *e;
+	struct timeval tv;
+
+	do_gettimeofday(&tv);
 
 	for (i = pool->used; i < pool->size; i++) {
 		e = ubi->lookuptbl[pool->pebs[i]];
@@ -566,8 +571,22 @@ static void return_unused_pool_pebs(struct ubi_device *ubi,
 			self_check_in_wl_tree(ubi, e, &ubi->scrub);
 			rb_erase(&e->u.rb, &ubi->scrub);
 		}
-		wl_tree_add(e, &ubi->free);
-		ubi->free_count++;
+		if (e->last_erase_time + UBI_DT_THRESHOLD <
+			 (tv.tv_sec / NUM_SEC_IN_DAY)) {
+			spin_unlock(&ubi->wl_lock);
+			err = schedule_erase(ubi, e, UBI_UNKNOWN,
+					 UBI_UNKNOWN, 0);
+			spin_lock(&ubi->wl_lock);
+			if (err) {
+				ubi_err(
+				"Failed to schedule erase for PEB %d (err=%d)",
+					e->pnum, err);
+				ubi_ro_mode(ubi);
+			}
+		} else {
+			wl_tree_add(e, &ubi->free);
+			ubi->free_count++;
+		}
 	}
 }
 
@@ -711,6 +730,124 @@ int ubi_wl_get_peb(struct ubi_device *ubi)
 #endif
 
 /**
+ * ubi_wl_scan_all - Scan all PEB's
+ * @ubi: UBI device description object
+ *
+ * This function scans all device PEBs in order to locate once
+ * need scrubbing; due to read disturb threashold or last erase
+ * timestamp.
+ *
+ * Return 0 in case of sucsess, (negative) error code otherwise
+ *
+ */
+int ubi_wl_scan_all(struct ubi_device *ubi)
+{
+	struct timeval tv;
+	struct rb_node *node;
+	struct ubi_wl_entry *wl_e, *tmp;
+	int used_cnt, free_cnt;
+	int err;
+
+	do_gettimeofday(&tv);
+	if (!ubi->lookuptbl) {
+		ubi_err("lookuptbl is null");
+		return -ENOENT;
+	}
+
+	spin_lock(&ubi->wl_lock);
+	if (ubi->scan_in_progress) {
+		ubi_err("Scan already in progress, ignoring the trigger");
+		err = -EPERM;
+		goto out;
+	}
+	ubi->scan_in_progress = true;
+
+	ubi_msg("Scanning all PEBs for read-disturb/erasures");
+	/* For PEBs in free list rc=0 */
+	free_cnt = 0;
+	node = rb_first(&ubi->free);
+	while (node) {
+		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+		node = rb_next(node);
+		if (wl_e->last_erase_time + UBI_DT_THRESHOLD <
+			 (tv.tv_sec / NUM_SEC_IN_DAY)) {
+			if (self_check_in_wl_tree(ubi, wl_e, &ubi->free)) {
+				ubi_err("PEB %d moved from free tree",
+					wl_e->pnum);
+				err = -EAGAIN;
+				goto out;
+			}
+			rb_erase(&wl_e->u.rb, &ubi->free);
+			ubi->free_count--;
+			spin_unlock(&ubi->wl_lock);
+			err = schedule_erase(ubi, wl_e, UBI_UNKNOWN,
+					 UBI_UNKNOWN, 0);
+			spin_lock(&ubi->wl_lock);
+			if (err) {
+				ubi_err(
+				"Failed to schedule erase for PEB %d (err=%d)",
+					wl_e->pnum, err);
+				ubi_ro_mode(ubi);
+				goto out;
+			}
+			free_cnt++;
+		}
+	}
+
+	used_cnt = 0;
+	node = rb_first(&ubi->used);
+	while (node) {
+		wl_e = rb_entry(node, struct ubi_wl_entry, u.rb);
+		node = rb_next(node);
+		if ((wl_e->rc >= UBI_RD_THRESHOLD) ||
+			(wl_e->last_erase_time +
+			 UBI_DT_THRESHOLD < (tv.tv_sec / NUM_SEC_IN_DAY))) {
+			spin_unlock(&ubi->wl_lock);
+			err = ubi_wl_scrub_peb(ubi, wl_e->pnum);
+			if (err)
+				ubi_err(
+				"Failed to schedule scrub for PEB %d (err=%d)",
+					wl_e->pnum, err);
+			else
+				used_cnt++;
+			spin_lock(&ubi->wl_lock);
+		}
+	}
+
+	/* Go over protection queue */
+	list_for_each_entry_safe(wl_e, tmp, &ubi->pq[ubi->pq_head], u.list) {
+		if ((wl_e->rc >= UBI_RD_THRESHOLD) ||
+			(wl_e->last_erase_time +
+			 UBI_DT_THRESHOLD < (tv.tv_sec / NUM_SEC_IN_DAY))) {
+			spin_unlock(&ubi->wl_lock);
+			err = ubi_wl_scrub_peb(ubi, wl_e->pnum);
+			if (err)
+				ubi_err(
+				"Failed to schedule scrub for PEB %d (err=%d)",
+					wl_e->pnum, err);
+			else
+				used_cnt++;
+			spin_lock(&ubi->wl_lock);
+		}
+	}
+	spin_unlock(&ubi->wl_lock);
+	ubi_msg("Scheduled %d for erasure", free_cnt);
+	ubi_msg("Scehduled %d for scrubbing", used_cnt);
+	err = ubi_wl_flush(ubi, UBI_ALL, UBI_ALL);
+	if (err)
+		ubi_err("Failed to flush ubi wq. err = %d", err);
+	else
+		ubi_msg("Flashed ubi wq");
+
+	spin_lock(&ubi->wl_lock);
+out:
+	ubi->scan_in_progress = false;
+	spin_unlock(&ubi->wl_lock);
+	ubi_msg("Scanning all PEBs completed. err = %d", err);
+	return err;
+}
+
+/**
  * prot_queue_del - remove a physical eraseblock from the protection queue.
  * @ubi: UBI device description object
  * @pnum: the physical eraseblock to remove
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project

