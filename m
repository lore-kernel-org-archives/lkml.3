Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbaKSVLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:11:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756460AbaKSVLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:11:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3.14 087/122] GFS2: Fix address space from page function
Date: Wed, 19 Nov 2014 12:52:17 -0800
Message-Id: <20141119205211.697624757@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit 1b2ad41214c9bf6e8befa000f0522629194bf540 upstream.

Now that rgrps use the address space which is part of the super
block, we need to update gfs2_mapping2sbd() to take account of
that. The only way to do that easily is to use a different set
of address_space_operations for rgrps.

Reported-by: Abhi Das <adas@redhat.com>
Tested-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/meta_io.c    |    5 +++++
 fs/gfs2/meta_io.h    |    3 +++
 fs/gfs2/ops_fstype.c |    2 +-
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -97,6 +97,11 @@ const struct address_space_operations gf
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
--- a/fs/gfs2/meta_io.h
+++ b/fs/gfs2/meta_io.h
@@ -38,12 +38,15 @@ static inline void gfs2_buffer_copy_tail
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
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -104,7 +104,7 @@ static struct gfs2_sbd *init_sbd(struct
 	mapping = &sdp->sd_aspace;
 
 	address_space_init_once(mapping);
-	mapping->a_ops = &gfs2_meta_aops;
+	mapping->a_ops = &gfs2_rgrp_aops;
 	mapping->host = sb->s_bdev->bd_inode;
 	mapping->flags = 0;
 	mapping_set_gfp_mask(mapping, GFP_NOFS);


