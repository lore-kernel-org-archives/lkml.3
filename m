Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab3BSKeX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932600Ab3BSKeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:15 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/10] GFS2: Reinstate withdraw ack system
Date: Tue, 19 Feb 2013 10:07:40 +0000
Message-Id: <1361268460-3092-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reinstates the ack system which withdraw should be using. It
appears to have been accidentally forgotten when the lock module was
merged into GFS2, due to two different sysfs files having the same name.

Reported-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 1533cf8..e2601ba 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -642,6 +642,7 @@ struct gfs2_sbd {
 	wait_queue_head_t sd_glock_wait;
 	atomic_t sd_glock_disposal;
 	struct completion sd_locking_init;
+	struct completion sd_wdack;
 	struct delayed_work sd_control_work;
 
 	/* Inode Stuff */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e063f22..1b612be 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -81,6 +81,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	init_waitqueue_head(&sdp->sd_glock_wait);
 	atomic_set(&sdp->sd_glock_disposal, 0);
 	init_completion(&sdp->sd_locking_init);
+	init_completion(&sdp->sd_wdack);
 	spin_lock_init(&sdp->sd_statfs_spin);
 
 	spin_lock_init(&sdp->sd_rindex_spin);
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 462e841..4fb9ad8 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -330,6 +330,28 @@ static ssize_t block_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
 	return ret;
 }
 
+static ssize_t wdack_show(struct gfs2_sbd *sdp, char *buf)
+{
+	int val = completion_done(&sdp->sd_wdack) ? 1 : 0;
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t wdack_store(struct gfs2_sbd *sdp, const char *buf, size_t len)
+{
+	ssize_t ret = len;
+	int val;
+
+	val = simple_strtol(buf, NULL, 0);
+
+	if ((val == 1) &&
+	    !strcmp(sdp->sd_lockstruct.ls_ops->lm_proto_name, "lock_dlm"))
+		complete(&sdp->sd_wdack);
+	else
+		ret = -EINVAL;
+	return ret;
+}
+
 static ssize_t lkfirst_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
@@ -461,7 +483,7 @@ static struct gfs2_attr gdlm_attr_##_name = __ATTR(_name,_mode,_show,_store)
 
 GDLM_ATTR(proto_name,		0444, proto_name_show,		NULL);
 GDLM_ATTR(block,		0644, block_show,		block_store);
-GDLM_ATTR(withdraw,		0644, withdraw_show,		withdraw_store);
+GDLM_ATTR(withdraw,		0644, wdack_show,		wdack_store);
 GDLM_ATTR(jid,			0644, jid_show,			jid_store);
 GDLM_ATTR(first,		0644, lkfirst_show,		lkfirst_store);
 GDLM_ATTR(first_done,		0444, first_done_show,		NULL);
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index f00d7c5..6402fb6 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -54,6 +54,9 @@ int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
 
 		kobject_uevent(&sdp->sd_kobj, KOBJ_OFFLINE);
 
+		if (!strcmp(sdp->sd_lockstruct.ls_ops->lm_proto_name, "lock_dlm"))
+			wait_for_completion(&sdp->sd_wdack);
+
 		if (lm->lm_unmount) {
 			fs_err(sdp, "telling LM to unmount\n");
 			lm->lm_unmount(sdp);
-- 
1.7.4

