Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaDAJRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaDAJQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:55 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 29/29] GFS2: Fix address space from page function
Date: Tue,  1 Apr 2014 10:15:41 +0100
Message-Id: <1396343741-1524-30-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that rgrps use the address space which is part of the super
block, we need to update gfs2_mapping2sbd() to take account of
that. The only way to do that easily is to use a different set
of address_space_operations for rgrps.

Reported-by: Abhi Das <adas@redhat.com>
Tested-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 005e468..2cf09b6 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -97,6 +97,11 @@ const struct address_space_operations gfs2_meta_aops = {
 	.releasepage = gfs2_releasepage,
 };
 
+const struct address_space_operations gfs2_rgrp_aops = {
+	.writepage = gfs2_aspace_writepage,
+	.releasepage = gfs2_releasepage,
+};
+
 /**
  * gfs2_getbuf - Get a buffer with a given address space
  * @gl: the glock
diff --git a/fs/gfs2/meta_io.h b/fs/gfs2/meta_io.h
index 4823b93..ac5d802 100644
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -38,12 +38,15 @@ static inline void gfs2_buffer_copy_tail(struct buffer_head *to_bh,
 }
 
 extern const struct address_space_operations gfs2_meta_aops;
+extern const struct address_space_operations gfs2_rgrp_aops;
 
 static inline struct gfs2_sbd *gfs2_mapping2sbd(struct address_space *mapping)
 {
 	struct inode *inode = mapping->host;
 	if (mapping->a_ops == &gfs2_meta_aops)
 		return (((struct gfs2_glock *)mapping) - 1)->gl_sbd;
+	else if (mapping->a_ops == &gfs2_rgrp_aops)
+		return container_of(mapping, struct gfs2_sbd, sd_aspace);
 	else
 		return inode->i_sb->s_fs_info;
 }
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index fba74a2..22f9540 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -106,7 +106,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 	mapping = &sdp->sd_aspace;
 
 	address_space_init_once(mapping);
-	mapping->a_ops = &gfs2_meta_aops;
+	mapping->a_ops = &gfs2_rgrp_aops;
 	mapping->host = sb->s_bdev->bd_inode;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
-- 
1.8.3.1

