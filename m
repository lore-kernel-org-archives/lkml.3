Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab3IPWUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:20:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50412 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab3IPWUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:20:47 -0400
From: zwu.kernel@gmail.com
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v5 06/10] VFS hot tracking: Add a /proc interface to make the interval tunable
Date: Tue, 17 Sep 2013 06:17:51 +0800
Message-Id: <1379369875-5123-7-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
References: <1379369875-5123-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091622-7182-0000-0000-0000086CD540
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add a proc interface hot-update-interval under the dir
/proc/sys/fs/ in order to turn HOT_UPDATE_INTERVAL into
a tunable parameter.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 7 +++++--
 fs/hot_tracking.h            | 2 --
 include/linux/hot_tracking.h | 3 +++
 kernel/sysctl.c              | 7 +++++++
 4 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 953dbc9..8c7e403 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,6 +15,9 @@
 #include <linux/sched.h>
 #include "hot_tracking.h"
 
+int sysctl_hot_update_interval __read_mostly = 150;
+EXPORT_SYMBOL_GPL(sysctl_hot_update_interval);
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -549,7 +552,7 @@ static void hot_update_worker(struct work_struct *work)
 
 	/* Instert next delayed work */
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_interval * MSEC_PER_SEC));
 }
 
 /*
@@ -690,7 +693,7 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	/* Initialize hot tracking wq and arm one delayed work */
 	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_interval * MSEC_PER_SEC));
 
 	/* Register a shrinker callback */
 	root->hot_shrink.count_objects = hot_track_shrink_count;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 0be7621..23b1339 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -15,8 +15,6 @@
 #include <linux/workqueue.h>
 #include <linux/hot_tracking.h>
 
-#define HOT_UPDATE_INTERVAL 150
-
 /* size of sub-file ranges */
 #define RANGE_BITS 20
 #define FREQ_POWER 4
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 4f80e72..6923771 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -101,6 +101,9 @@ struct hot_info {
 	struct shrinker hot_shrink;
 };
 
+/* set how often to update temperatures (seconds) */
+extern int sysctl_hot_update_interval;
+
 /*
  * Hot data tracking ioctls:
  *
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b2f06f3..e0b062a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1631,6 +1631,13 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "hot-update-interval",
+		.data		= &sysctl_hot_update_interval,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.7.11.7

