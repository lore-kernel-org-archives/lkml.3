Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3KDLiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:38:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab3KDLgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:42 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 15/19] GFS2: Protect quota sync generation
Date: Mon,  4 Nov 2013 11:09:38 +0000
Message-Id: <1383563382-8535-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that gfs2_quota_sync can be potentially called from multiple
threads, we should protect this bit of code, and the sync generation
number in particular in order to ensure that there are no races
when syncing quotas.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 37b3cd7..2ab4f8d 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -714,6 +714,7 @@ struct gfs2_sbd {
 	struct list_head sd_quota_list;
 	atomic_t sd_quota_count;
 	struct mutex sd_quota_mutex;
+	struct mutex sd_quota_sync_mutex;
 	wait_queue_head_t sd_quota_wait;
 	struct list_head sd_trunc_list;
 	spinlock_t sd_trunc_lock;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 8e40fda..82303b4 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -93,6 +93,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	INIT_LIST_HEAD(&sdp->sd_quota_list);
 	mutex_init(&sdp->sd_quota_mutex);
+	mutex_init(&sdp->sd_quota_sync_mutex);
 	init_waitqueue_head(&sdp->sd_quota_wait);
 	INIT_LIST_HEAD(&sdp->sd_trunc_list);
 	spin_lock_init(&sdp->sd_trunc_lock);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index cfb4cde..4a9726a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1132,12 +1132,13 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 	unsigned int x;
 	int error = 0;
 
-	sdp->sd_quota_sync_gen++;
-
 	qda = kcalloc(max_qd, sizeof(struct gfs2_quota_data *), GFP_KERNEL);
 	if (!qda)
 		return -ENOMEM;
 
+	mutex_lock(&sdp->sd_quota_sync_mutex);
+	sdp->sd_quota_sync_gen++;
+
 	do {
 		num_qd = 0;
 
@@ -1162,6 +1163,7 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 		}
 	} while (!error && num_qd == max_qd);
 
+	mutex_unlock(&sdp->sd_quota_sync_mutex);
 	kfree(qda);
 
 	return error;
-- 
1.7.4.4

