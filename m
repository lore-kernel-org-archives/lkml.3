Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab3KDLgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:36:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab3KDLgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:36:37 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, Abhijith Das <adas@redhat.com>
Subject: [PATCH 12/19] GFS2: Remove obsolete quota tunable
Date: Mon,  4 Nov 2013 11:09:35 +0000
Message-Id: <1383563382-8535-13-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
References: <1383563382-8535-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for a paramater which relates to the internals
of quota to be exposed to users. The only possible use would be
to turn it up so large that the memory allocation fails. So lets
remove it and set it to a sensible value which ensures that we
don't ask for multipage allocations.

Currently the size of struct gfs2_holder means that the caluclated
value is identical to the previous default value, so there should
be no functional change.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Abhijith Das <adas@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 082c8fa..37b3cd7 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -537,7 +537,6 @@ struct gfs2_tune {
 
 	unsigned int gt_logd_secs;
 
-	unsigned int gt_quota_simul_sync; /* Max quotavals to sync at once */
 	unsigned int gt_quota_warn_period; /* Secs between quota warn msgs */
 	unsigned int gt_quota_scale_num; /* Numerator */
 	unsigned int gt_quota_scale_den; /* Denominator */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 19ff5e8..8e40fda 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -51,7 +51,6 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 {
 	spin_lock_init(&gt->gt_spin);
 
-	gt->gt_quota_simul_sync = 64;
 	gt->gt_quota_warn_period = 10;
 	gt->gt_quota_scale_num = 1;
 	gt->gt_quota_scale_den = 1;
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index fd1ec52..658abe2 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1140,7 +1140,7 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	struct gfs2_quota_data **qda;
-	unsigned int max_qd = gfs2_tune_get(sdp, gt_quota_simul_sync);
+	unsigned int max_qd = PAGE_SIZE/sizeof(struct gfs2_holder);
 	unsigned int num_qd;
 	unsigned int x;
 	int error = 0;
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index aa5c480..d09f6ed 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -587,7 +587,6 @@ TUNE_ATTR(max_readahead, 0);
 TUNE_ATTR(complain_secs, 0);
 TUNE_ATTR(statfs_slow, 0);
 TUNE_ATTR(new_files_jdata, 0);
-TUNE_ATTR(quota_simul_sync, 1);
 TUNE_ATTR(statfs_quantum, 1);
 TUNE_ATTR_3(quota_scale, quota_scale_show, quota_scale_store);
 
@@ -597,7 +596,6 @@ static struct attribute *tune_attrs[] = {
 	&tune_attr_max_readahead.attr,
 	&tune_attr_complain_secs.attr,
 	&tune_attr_statfs_slow.attr,
-	&tune_attr_quota_simul_sync.attr,
 	&tune_attr_statfs_quantum.attr,
 	&tune_attr_quota_scale.attr,
 	&tune_attr_new_files_jdata.attr,
-- 
1.7.4.4

