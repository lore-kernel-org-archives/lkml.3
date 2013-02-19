Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab3BSKey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:34:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515Ab3BSKeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:34:14 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/10] GFS2: Get a block reservation before resizing a file
Date: Tue, 19 Feb 2013 10:07:39 +0000
Message-Id: <1361268460-3092-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
References: <1361268460-3092-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch allocates a block reservation structure before growing
or shrinking a file. Without this structure, the grow or shink code
can reference the bad pointer.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index d29d779..df686d1 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1288,6 +1288,10 @@ int gfs2_setattr_size(struct inode *inode, u64 newsize)
 
 	inode_dio_wait(inode);
 
+	ret = gfs2_rs_alloc(GFS2_I(inode));
+	if (ret)
+		return ret;
+
 	oldsize = inode->i_size;
 	if (newsize >= oldsize)
 		return do_grow(inode, newsize);
-- 
1.7.4

