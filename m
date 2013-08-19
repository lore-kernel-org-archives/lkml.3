Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab3HSJPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:15:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3HSJOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:14:42 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/5] GFS2: don't overrun reserved revokes
Date: Mon, 19 Aug 2013 09:48:05 +0100
Message-Id: <1376902087-7783-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
References: <1376902087-7783-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

When run during fsync, a gfs2_log_flush could happen between the
time when gfs2_ail_flush checked the number of blocks to revoke,
and when it actually started the transaction to do those revokes.
This occassionally caused it to need more revokes than it reserved,
causing gfs2 to crash.

Instead of just reserving enough revokes to handle the blocks that
currently need them, this patch makes gfs2_ail_flush reserve the
maximum number of revokes it can, without increasing the total number
of reserved log blocks. This patch also passes the number of reserved
revokes to __gfs2_ail_flush() so that it doesn't go over its limit
and cause a crash like we're seeing. Non-fsync calls to __gfs2_ail_flush
will still cause a BUG() necessary revokes are skipped.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 5f2e522..e2e0a90 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -47,7 +47,8 @@ static void gfs2_ail_error(struct gfs2_glock *gl, const struct buffer_head *bh)
  * None of the buffers should be dirty, locked, or pinned.
  */
 
-static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
+static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync,
+			     unsigned int nr_revokes)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	struct list_head *head = &gl->gl_ail_list;
@@ -57,7 +58,9 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 
 	gfs2_log_lock(sdp);
 	spin_lock(&sdp->sd_ail_lock);
-	list_for_each_entry_safe(bd, tmp, head, bd_ail_gl_list) {
+	list_for_each_entry_safe_reverse(bd, tmp, head, bd_ail_gl_list) {
+		if (nr_revokes == 0)
+			break;
 		bh = bd->bd_bh;
 		if (bh->b_state & b_state) {
 			if (fsync)
@@ -65,6 +68,7 @@ static void __gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 			gfs2_ail_error(gl, bh);
 		}
 		gfs2_trans_add_revoke(sdp, bd);
+		nr_revokes--;
 	}
 	GLOCK_BUG_ON(gl, !fsync && atomic_read(&gl->gl_ail_count));
 	spin_unlock(&sdp->sd_ail_lock);
@@ -91,7 +95,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
 	WARN_ON_ONCE(current->journal_info);
 	current->journal_info = &tr;
 
-	__gfs2_ail_flush(gl, 0);
+	__gfs2_ail_flush(gl, 0, tr.tr_revokes);
 
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
@@ -101,15 +105,19 @@ void gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 {
 	struct gfs2_sbd *sdp = gl->gl_sbd;
 	unsigned int revokes = atomic_read(&gl->gl_ail_count);
+	unsigned int max_revokes = (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_log_descriptor)) / sizeof(u64);
 	int ret;
 
 	if (!revokes)
 		return;
 
-	ret = gfs2_trans_begin(sdp, 0, revokes);
+	while (revokes > max_revokes)
+		max_revokes += (sdp->sd_sb.sb_bsize - sizeof(struct gfs2_meta_header)) / sizeof(u64);
+
+	ret = gfs2_trans_begin(sdp, 0, max_revokes);
 	if (ret)
 		return;
-	__gfs2_ail_flush(gl, fsync);
+	__gfs2_ail_flush(gl, fsync, max_revokes);
 	gfs2_trans_end(sdp);
 	gfs2_log_flush(sdp, NULL);
 }
-- 
1.7.4

