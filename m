Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab3G3FyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 01:54:23 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:35602 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3G3FyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 01:54:21 -0400
Message-Id: <20130730055349.347947501@kernel.org>
User-Agent: quilt/0.50-1
Date: Tue, 30 Jul 2013 13:52:09 +0800
From: shli@kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, djbw@fb.com
Subject: [patch 2/3] raid5: sysfs entry to control worker thread number
References: <20130730055207.698660010@kernel.org>
Content-Disposition: inline; filename=raid5-configure-wq.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a sysfs entry to control running workqueue thread number. If
group_thread_cnt is set to 0, we will disable workqueue offload handling of
stripes.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 drivers/md/raid5.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

Index: linux/drivers/md/raid5.c
===================================================================
--- linux.orig/drivers/md/raid5.c	2013-07-30 09:43:55.859080206 +0800
+++ linux/drivers/md/raid5.c	2013-07-30 09:44:18.666793102 +0800
@@ -5142,10 +5142,70 @@ stripe_cache_active_show(struct mddev *m
 static struct md_sysfs_entry
 raid5_stripecache_active = __ATTR_RO(stripe_cache_active);
 
+static ssize_t
+raid5_show_group_thread_cnt(struct mddev *mddev, char *page)
+{
+	struct r5conf *conf = mddev->private;
+	if (conf)
+		return sprintf(page, "%d\n", conf->worker_cnt_per_group);
+	else
+		return 0;
+}
+
+static int alloc_thread_groups(struct r5conf *conf, int cnt);
+static ssize_t
+raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
+{
+	struct r5conf *conf = mddev->private;
+	unsigned long new;
+	int err;
+	struct r5worker_group *old_groups;
+	int old_group_cnt;
+
+	if (len >= PAGE_SIZE)
+		return -EINVAL;
+	if (!conf)
+		return -ENODEV;
+
+	if (kstrtoul(page, 10, &new))
+		return -EINVAL;
+
+	if (new == conf->worker_cnt_per_group)
+		return len;
+
+	mddev_suspend(mddev);
+
+	old_groups = conf->worker_groups;
+	old_group_cnt = conf->worker_cnt_per_group;
+
+	conf->worker_groups = NULL;
+	err = alloc_thread_groups(conf, new);
+	if (err) {
+		conf->worker_groups = old_groups;
+		conf->worker_cnt_per_group = old_group_cnt;
+	} else {
+		if (old_groups)
+			kfree(old_groups[0].workers);
+		kfree(old_groups);
+	}
+
+	mddev_resume(mddev);
+
+	if (err)
+		return err;
+	return len;
+}
+
+static struct md_sysfs_entry
+raid5_group_thread_cnt = __ATTR(group_thread_cnt, S_IRUGO | S_IWUSR,
+				raid5_show_group_thread_cnt,
+				raid5_store_group_thread_cnt);
+
 static struct attribute *raid5_attrs[] =  {
 	&raid5_stripecache_size.attr,
 	&raid5_stripecache_active.attr,
 	&raid5_preread_bypass_threshold.attr,
+	&raid5_group_thread_cnt.attr,
 	NULL,
 };
 static struct attribute_group raid5_attrs_group = {

