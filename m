Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaAMO2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:28:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaAMO03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 62/96] GFS2: don't hold s_umount over blkdev_put
Date: Mon, 13 Jan 2014 14:24:25 +0000
Message-Id: <1389623099-18783-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Whitehouse <swhiteho@redhat.com>

commit dfe5b9ad83a63180f358b27d1018649a27b394a9 upstream.

This is a GFS2 version of Tejun's patch:
4f331f01b9c43bf001d3ffee578a97a1e0633eac
vfs: don't hold s_umount over close_bdev_exclusive() call

In this case its blkdev_put itself that is the issue and this
patch uses the same solution of dropping and retaking s_umount.

Reported-by: Tejun Heo <tj@kernel.org>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/gfs2/ops_fstype.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index b8c250f..0e690dc 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1292,8 +1292,18 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
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
1.8.3.2

