Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbaHHUom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:44:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40287 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbaHHUof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:44:35 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vasily Averin <vvs@openvz.org>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 172/259] fs: umount on symlink leaks mnt count
Date: Fri,  8 Aug 2014 13:39:55 -0700
Message-Id: <1407530482-4483-173-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit 295dc39d941dc2ae53d5c170365af4c9d5c16212 upstream.

Currently umount on symlink blocks following umount:

/vz is separate mount

# ls /vz/ -al | grep test
drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir
# umount -l /vz/testlink
umount: /vz/testlink: not mounted (expected)

# lsof /vz
# umount /vz
umount: /vz: device is busy. (unexpected)

In this case mountpoint_last() gets an extra refcount on path->mnt

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Ian Kent <raven@themaw.net>
Acked-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 01aca74..31673f4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2236,9 +2236,10 @@ done:
 		goto out;
 	}
 	path->dentry = dentry;
-	path->mnt = mntget(nd->path.mnt);
+	path->mnt = nd->path.mnt;
 	if (should_follow_link(dentry, nd->flags & LOOKUP_FOLLOW))
 		return 1;
+	mntget(path->mnt);
 	follow_mount(path);
 	error = 0;
 out:
-- 
1.9.1

