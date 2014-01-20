Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbaATM2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:28:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbaATMYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:44 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 13/24] GFS2: For exhash conversion, only one block is needed
Date: Mon, 20 Jan 2014 12:23:36 +0000
Message-Id: <1390220627-1571-14-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For most cases, only a single new block is needed when we reach
the point of converting from stuffed to exhash directory. The
exception being when the file name is so long that it will not
fit within the new leaf block.

So this patch adds a simple test for that situation so that we
do not need to request the full reservation size in this case.

Potentially we could calculate more accurately the value to use
in other cases too, but that is much more complicated to do and
it is doubtful that the benefit would outweigh the extra cost
in code complexity.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index d5988aa..b2e5ebf 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -2035,7 +2035,9 @@ out:
 int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name,
 			       struct gfs2_diradd *da)
 {
+	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
+	const unsigned int extra = sizeof(struct gfs2_dinode) - sizeof(struct gfs2_leaf);
 	struct gfs2_dirent *dent;
 	struct buffer_head *bh;
 
@@ -2046,6 +2048,9 @@ int gfs2_diradd_alloc_required(struct inode *inode, const struct qstr *name,
 	dent = gfs2_dirent_search(inode, name, gfs2_dirent_find_space, &bh);
 	if (!dent) {
 		da->nr_blocks = sdp->sd_max_dirres;
+		if (!(ip->i_diskflags & GFS2_DIF_EXHASH) &&
+		    (GFS2_DIRENT_SIZE(name->len) < extra))
+			da->nr_blocks = 1;
 		return 0;
 	}
 	if (IS_ERR(dent))
-- 
1.8.3.1

