Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaABM2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:28:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaABM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:28:39 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/6] GFS2: don't hold s_umount over blkdev_put
Date: Thu,  2 Jan 2014 12:28:09 +0000
Message-Id: <1388665694-1639-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
References: <1388665694-1639-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a GFS2 version of Tejun's patch:
4f331f01b9c43bf001d3ffee578a97a1e0633eac
vfs: don't hold s_umount over close_bdev_exclusive() call

In this case its blkdev_put itself that is the issue and this
patch uses the same solution of dropping and retaking s_umount.

Reported-by: Tejun Heo <tj@kernel.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 82303b4..52fa883 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1366,8 +1366,18 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 	if (IS_ERR(s))
 		goto error_bdev;
 
-	if (s->s_root)
+	if (s->s_root) {
+		/*
+		 * s_umount nests inside bd_mutex during
+		 * __invalidate_device().  blkdev_put() acquires
+		 * bd_mutex and can't be called under s_umount.  Drop
+		 * s_umount temporarily.  This is safe as we're
+		 * holding an active reference.
+		 */
+		up_write(&s->s_umount);
 		blkdev_put(bdev, mode);
+		down_write(&s->s_umount);
+	}
 
 	memset(&args, 0, sizeof(args));
 	args.ar_quota = GFS2_QUOTA_DEFAULT;
-- 
1.8.3.1

