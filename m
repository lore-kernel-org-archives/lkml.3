Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3KFNse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 08:48:34 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38377 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734Ab3KFNs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 08:48:29 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>,
        Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v6 06/11] VFS hot tracking: Add a /proc interface to make the interval tunable
Date: Wed,  6 Nov 2013 21:45:39 +0800
Message-Id: <1383745544-391-7-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
References: <1383745544-391-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110613-7182-0000-0000-00000904FC79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Add a /proc interface hot-update-interval under the dir
/proc/sys/fs/ in order to turn HOT_UPDATE_INTERVAL into
a tunable parameter.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            | 6 ++++--
 fs/hot_tracking.h            | 2 --
 include/linux/hot_tracking.h | 3 +++
 kernel/sysctl.c              | 7 +++++++
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index ac0cdda..7a9bd4f 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,6 +15,8 @@
 #include <linux/sched.h>
 #include "hot_tracking.h"
 
+int sysctl_hot_update_interval __read_mostly = 150;
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -556,7 +558,7 @@ static void hot_update_worker(struct work_struct *work)
 
 	/* Instert next delayed work */
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_interval * MSEC_PER_SEC));
 }
 
 /*
@@ -696,7 +698,7 @@ static struct hot_info *hot_tree_init(struct super_block *sb)
 	/* Initialize hot tracking wq and arm one delayed work */
 	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HOT_UPDATE_INTERVAL * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_interval * MSEC_PER_SEC));
 
 	/* Register a shrinker callback */
 	root->hot_shrink.count_objects = hot_track_shrink_count;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 4a89fdb..6a6971e 100644
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
index 0ee9ca2..43df1b9 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -85,6 +85,9 @@ struct hot_info {
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

