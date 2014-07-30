Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbaG3MSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:18:06 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36822 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbaG3MPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vasily Averin <vvs@parallels.com>,
        Vasily Averin <vvs@openvz.org>, Christoph Hellwig <hch@lst.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 90/94] fs: umount on symlink leaks mnt count
Date: Wed, 30 Jul 2014 14:15:19 +0200
Message-Id: <704a98917dfc367aad4238f69d1853942255ed5d.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Averin <vvs@parallels.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 338d08b7eae2..e3249d565c95 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2281,9 +2281,10 @@ done:
 		goto out;
 	}
 	path->dentry = dentry;
-	path->mnt = mntget(nd->path.mnt);
+	path->mnt = nd->path.mnt;
 	if (should_follow_link(dentry->d_inode, nd->flags & LOOKUP_FOLLOW))
 		return 1;
+	mntget(path->mnt);
 	follow_mount(path);
 	error = 0;
 out:
-- 
2.0.1

