Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaHRJgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:36:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43075 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaHRJgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:36:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vasily Averin <vvs@openvz.org>, Christoph Hellwig <hch@lst.de>,
        Neil Brown <neilb@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 115/137] fs: umount on symlink leaks mnt count
Date: Mon, 18 Aug 2014 10:32:56 +0100
Message-Id: <1408354398-10226-116-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@parallels.com>

commit 295dc39d941dc2ae53d5c170365af4c9d5c16212 upstream.

Currently umount on symlink blocks following umount:

/vz is separate mount

drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir
umount: /vz/testlink: not mounted (expected)

umount: /vz: device is busy. (unexpected)

In this case mountpoint_last() gets an extra refcount on path->mnt

Signed-off-by: Vasily Averin <vvs@openvz.org>
Acked-by: Ian Kent <raven@themaw.net>
Acked-by: Jeff Layton <jlayton@primarydata.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Neil Brown <neilb@suse.de>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index a10bd2f8b66b..2d36c4651627 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2260,10 +2260,11 @@ error_check:
 			dput(dentry);
 		} else {
 			path->dentry = dentry;
-			path->mnt = mntget(nd->path.mnt);
+			path->mnt = nd->path.mnt;
 			if (should_follow_link(dentry->d_inode,
 						nd->flags & LOOKUP_FOLLOW))
 				return 1;
+			mntget(path->mnt);
 			follow_mount(path);
 		}
 	}
-- 
1.9.1

