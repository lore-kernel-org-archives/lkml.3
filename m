Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaATMYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbaATMYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:36 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 07/24] GFS2: Use range based functions for rgrp sync/invalidation
Date: Mon, 20 Jan 2014 12:23:30 +0000
Message-Id: <1390220627-1571-8-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each rgrp header is represented as a single extent on disk, so we
can calculate the position within the address space, since we are
using address spaces mapped 1:1 to the disk. This means that it
is possible to use the range based versions of filemap_fdatawrite/wait
and for invalidating the page cache.

Our eventual intent is to then be able to merge the address spaces
used for rgrps into a single address space, rather than to have
one for each glock, saving memory and reducing complexity.

Since during umount, the rgrp structures are disposed of before
the glocks, we need to store the extent information in the glock
so that is is available for a final invalidation. This patch uses
a field which is otherwise unused in rgrp glocks to do that, so
that we do not have to expand the size of a glock.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index f88dcd9..1b192c8d 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -142,8 +142,8 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
 	gfs2_log_flush(gl->gl_sbd, gl);
-	filemap_fdatawrite(metamapping);
-	error = filemap_fdatawait(metamapping);
+	filemap_fdatawrite_range(metamapping, gl->gl_vm.start, gl->gl_vm.end);
+	error = filemap_fdatawait_range(metamapping, gl->gl_vm.start, gl->gl_vm.end);
         mapping_set_error(metamapping, error);
 	gfs2_ail_empty_gl(gl);
 
@@ -170,7 +170,7 @@ static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 
 	WARN_ON_ONCE(!(flags & DIO_METADATA));
 	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
-	truncate_inode_pages(mapping, 0);
+	truncate_inode_pages_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
 
 	if (gl->gl_object) {
 		struct gfs2_rgrpd *rgd = (struct gfs2_rgrpd *)gl->gl_object;
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 0132816..e6544ee 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -351,7 +351,15 @@ struct gfs2_glock {
 	atomic_t gl_ail_count;
 	atomic_t gl_revokes;
 	struct delayed_work gl_work;
-	struct work_struct gl_delete;
+	union {
+		/* For inode and iopen glocks only */
+		struct work_struct gl_delete;
+		/* For rgrp glocks only */
+		struct {
+			loff_t start;
+			loff_t end;
+		} gl_vm;
+	};
 	struct rcu_head gl_rcu;
 };
 
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 2584710..183cf0f 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -886,6 +886,7 @@ static int rgd_insert(struct gfs2_rgrpd *rgd)
 static int read_rindex_entry(struct gfs2_inode *ip)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	const unsigned bsize = sdp->sd_sb.sb_bsize;
 	loff_t pos = sdp->sd_rgrps * sizeof(struct gfs2_rindex);
 	struct gfs2_rindex buf;
 	int error;
@@ -923,6 +924,8 @@ static int read_rindex_entry(struct gfs2_inode *ip)
 		goto fail;
 
 	rgd->rd_gl->gl_object = rgd;
+	rgd->rd_gl->gl_vm.start = rgd->rd_addr * bsize;
+	rgd->rd_gl->gl_vm.end = rgd->rd_gl->gl_vm.start + (rgd->rd_length * bsize) - 1;
 	rgd->rd_rgl = (struct gfs2_rgrp_lvb *)rgd->rd_gl->gl_lksb.sb_lvbptr;
 	rgd->rd_flags &= ~GFS2_RDF_UPTODATE;
 	if (rgd->rd_data > sdp->sd_max_rg_data)
-- 
1.8.3.1

