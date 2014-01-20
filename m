Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaATMYl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbaATMYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:36 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/24] GFS2: Use only a single address space for rgrps
Date: Mon, 20 Jan 2014 12:23:31 +0000
Message-Id: <1390220627-1571-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to this patch, GFS2 had one address space for each rgrp,
stored in the glock. This patch changes them to use a single
address space in the super block. This therefore saves
(sizeof(struct address_space) * nr_of_rgrps) bytes of memory
and for large filesystems, that can be significant.

It would be nice to be able to do something similar and merge
the inode metadata address space into the same global
address space. However, that is rather more complicated as the
on-disk location doesn't have a 1:1 mapping with the inodes in
general. So while it could be done, it will be a more complicated
operation as it requires changing a lot more code paths.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 1b192c8d..b792dbc 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -133,7 +133,8 @@ void gfs2_ail_flush(struct gfs2_glock *gl, bool fsync)
 
 static void rgrp_go_sync(struct gfs2_glock *gl)
 {
-	struct address_space *metamapping = gfs2_glock2aspace(gl);
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct address_space *mapping = &sdp->sd_aspace;
 	struct gfs2_rgrpd *rgd;
 	int error;
 
@@ -141,10 +142,10 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 		return;
 	GLOCK_BUG_ON(gl, gl->gl_state != LM_ST_EXCLUSIVE);
 
-	gfs2_log_flush(gl->gl_sbd, gl);
-	filemap_fdatawrite_range(metamapping, gl->gl_vm.start, gl->gl_vm.end);
-	error = filemap_fdatawait_range(metamapping, gl->gl_vm.start, gl->gl_vm.end);
-        mapping_set_error(metamapping, error);
+	gfs2_log_flush(sdp, gl);
+	filemap_fdatawrite_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
+	error = filemap_fdatawait_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
+	mapping_set_error(mapping, error);
 	gfs2_ail_empty_gl(gl);
 
 	spin_lock(&gl->gl_spin);
@@ -166,10 +167,11 @@ static void rgrp_go_sync(struct gfs2_glock *gl)
 
 static void rgrp_go_inval(struct gfs2_glock *gl, int flags)
 {
-	struct address_space *mapping = gfs2_glock2aspace(gl);
+	struct gfs2_sbd *sdp = gl->gl_sbd;
+	struct address_space *mapping = &sdp->sd_aspace;
 
 	WARN_ON_ONCE(!(flags & DIO_METADATA));
-	gfs2_assert_withdraw(gl->gl_sbd, !atomic_read(&gl->gl_ail_count));
+	gfs2_assert_withdraw(sdp, !atomic_read(&gl->gl_ail_count));
 	truncate_inode_pages_range(mapping, gl->gl_vm.start, gl->gl_vm.end);
 
 	if (gl->gl_object) {
@@ -558,7 +560,7 @@ const struct gfs2_glock_operations gfs2_rgrp_glops = {
 	.go_unlock = gfs2_rgrp_go_unlock,
 	.go_dump = gfs2_rgrp_dump,
 	.go_type = LM_TYPE_RGRP,
-	.go_flags = GLOF_ASPACE | GLOF_LVB,
+	.go_flags = GLOF_LVB,
 };
 
 const struct gfs2_glock_operations gfs2_trans_glops = {
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index e6544ee..a99f60c 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -736,6 +736,8 @@ struct gfs2_sbd {
 
 	/* Log stuff */
 
+	struct address_space sd_aspace;
+
 	spinlock_t sd_log_lock;
 
 	struct gfs2_trans *sd_log_tr;
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index cdadb92..58f0640 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -589,8 +589,12 @@ static int buf_lo_scan_elements(struct gfs2_jdesc *jd, unsigned int start,
 static void gfs2_meta_sync(struct gfs2_glock *gl)
 {
 	struct address_space *mapping = gfs2_glock2aspace(gl);
+	struct gfs2_sbd *sdp = gl->gl_sbd;
 	int error;
 
+	if (mapping == NULL)
+		mapping = &sdp->sd_aspace;
+
 	filemap_fdatawrite(mapping);
 	error = filemap_fdatawait(mapping);
 
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 52f177b..c7f2469 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -116,6 +116,9 @@ struct buffer_head *gfs2_getbuf(struct gfs2_glock *gl, u64 blkno, int create)
 	unsigned long index;
 	unsigned int bufnum;
 
+	if (mapping == NULL)
+		mapping = &sdp->sd_aspace;
+
 	shift = PAGE_CACHE_SHIFT - sdp->sd_sb.sb_bsize_shift;
 	index = blkno >> shift;             /* convert block to page */
 	bufnum = blkno - (index << shift);  /* block buf index within page */
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 52fa883..94aab31 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -36,6 +36,7 @@
 #include "log.h"
 #include "quota.h"
 #include "dir.h"
+#include "meta_io.h"
 #include "trace_gfs2.h"
 
 #define DO 0
@@ -62,6 +63,7 @@ static void gfs2_tune_init(struct gfs2_tune *gt)
 static struct gfs2_sbd *init_sbd(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp;
+	struct address_space *mapping;
 
 	sdp = kzalloc(sizeof(struct gfs2_sbd), GFP_KERNEL);
 	if (!sdp)
@@ -98,6 +100,16 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	INIT_LIST_HEAD(&sdp->sd_trunc_list);
 	spin_lock_init(&sdp->sd_trunc_lock);
 
+	mapping = &sdp->sd_aspace;
+
+	mapping->a_ops = &gfs2_meta_aops;
+	mapping->host = sb->s_bdev->bd_inode;
+	mapping->flags = 0;
+	mapping_set_gfp_mask(mapping, GFP_NOFS);
+	mapping->private_data = NULL;
+	mapping->backing_dev_info = sb->s_bdi;
+	mapping->writeback_index = 0;
+
 	spin_lock_init(&sdp->sd_log_lock);
 	atomic_set(&sdp->sd_log_pinned, 0);
 	INIT_LIST_HEAD(&sdp->sd_log_le_buf);
-- 
1.8.3.1

