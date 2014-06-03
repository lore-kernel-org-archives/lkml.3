Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaFCLDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbaFCLDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:03:00 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 6/6] GFS2: Prevent recovery before the local journal is set
Date: Tue,  3 Jun 2014 12:02:33 +0100
Message-Id: <1401793353-1469-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
References: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch uses a completion to prevent dlm's recovery process from
referencing and trying to recover a journal before a journal has been
opened.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 2434a96..67d310c 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -728,6 +728,8 @@ struct gfs2_sbd {
 	struct gfs2_holder sd_sc_gh;
 	struct gfs2_holder sd_qc_gh;
 
+	struct completion sd_journal_ready;
+
 	/* Daemon stuff */
 
 	struct task_struct *sd_logd_process;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index be45c79..bc564c0 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -94,6 +94,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	INIT_LIST_HEAD(&sdp->sd_jindex_list);
 	spin_lock_init(&sdp->sd_jindex_spin);
 	mutex_init(&sdp->sd_jindex_mutex);
+	init_completion(&sdp->sd_journal_ready);
 
 	INIT_LIST_HEAD(&sdp->sd_quota_list);
 	mutex_init(&sdp->sd_quota_mutex);
@@ -796,6 +797,7 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 		goto fail_qinode;
 
 	error = init_journal(sdp, undo);
+	complete_all(&sdp->sd_journal_ready);
 	if (error)
 		goto fail;
 
@@ -1212,6 +1214,7 @@ fail_sb:
 fail_locking:
 	init_locking(sdp, &mount_gh, UNDO);
 fail_lm:
+	complete_all(&sdp->sd_journal_ready);
 	gfs2_gl_hash_clear(sdp);
 	gfs2_lm_unmount(sdp);
 fail_debug:
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7bc17ed..0e049f9 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -407,6 +407,9 @@ int gfs2_recover_set(struct gfs2_sbd *sdp, unsigned jid)
 	struct gfs2_jdesc *jd;
 	int rv;
 
+	/* Wait for our primary journal to be initialized */
+	wait_for_completion(&sdp->sd_journal_ready);
+
 	spin_lock(&sdp->sd_jindex_spin);
 	rv = -EBUSY;
 	if (sdp->sd_jdesc->jd_jid == jid)
-- 
1.8.3.1

