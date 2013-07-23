Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab3GWVMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:12:08 -0400
Received: from dupo.coraid.com ([208.71.232.133]:41686 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933652Ab3GWVMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:12:03 -0400
Message-Id: <35cf0a7d2b168c9c671d3dc8d476f01b3589fb88.1374610591.git.ecashin@coraid.com>
In-Reply-To: <cover.1374610591.git.ecashin@coraid.com>
References: <cover.1374610591.git.ecashin@coraid.com>
Subject: [PATCH 2/6] aoe: add AoE-target files to debugfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 23 Jul 2013 17:11:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h    |    2 ++
 drivers/block/aoe/aoeblk.c |   35 +++++++++++++++++++++++++++++++++++
 drivers/block/aoe/aoedev.c |    1 +
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 025c41d..b1f24c5 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -169,6 +169,7 @@ struct aoedev {
 	ulong ref;
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
+	struct dentry *debugfs;
 	struct request_queue *blkq;
 	struct hd_geometry geo;
 	sector_t ssize;
@@ -206,6 +207,7 @@ struct ktstate {
 int aoeblk_init(void);
 void aoeblk_exit(void);
 void aoeblk_gdalloc(void *);
+void aoedisk_rm_debugfs(struct aoedev *d);
 void aoedisk_rm_sysfs(struct aoedev *d);
 
 int aoechr_init(void);
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index cb508b7..d76c5cb 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -132,6 +132,40 @@ static const struct attribute_group attr_group = {
 	.attrs = aoe_attrs,
 };
 
+static const struct file_operations aoe_debugfs_fops;
+
+static void
+aoedisk_add_debugfs(struct aoedev *d)
+{
+	struct dentry *entry;
+	char *p;
+
+	if (aoe_debugfs_dir == NULL)
+		return;
+	p = strchr(d->gd->disk_name, '/');
+	if (p == NULL)
+		p = d->gd->disk_name;
+	else
+		p++;
+	BUG_ON(*p == '\0');
+	entry = debugfs_create_file(p, 0444, aoe_debugfs_dir, d,
+				    &aoe_debugfs_fops);
+	if (IS_ERR_OR_NULL(entry)) {
+		pr_info("aoe: cannot create debugfs file for %s\n",
+			d->gd->disk_name);
+		return;
+	}
+	BUG_ON(d->debugfs);
+	d->debugfs = entry;
+}
+void
+aoedisk_rm_debugfs(struct aoedev *d)
+{
+	BUG_ON(d->debugfs == NULL);
+	debugfs_remove(d->debugfs);
+	d->debugfs = NULL;
+}
+
 static int
 aoedisk_add_sysfs(struct aoedev *d)
 {
@@ -332,6 +366,7 @@ aoeblk_gdalloc(void *vp)
 
 	add_disk(gd);
 	aoedisk_add_sysfs(d);
+	aoedisk_add_debugfs(d);
 
 	spin_lock_irqsave(&d->lock, flags);
 	WARN_ON(!(d->flags & DEVFL_GD_NOW));
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index 784c92e..c904767 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -278,6 +278,7 @@ freedev(struct aoedev *d)
 
 	del_timer_sync(&d->timer);
 	if (d->gd) {
+		aoedisk_rm_debugfs(d);
 		aoedisk_rm_sysfs(d);
 		del_gendisk(d->gd);
 		put_disk(d->gd);
-- 
1.7.1

