Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaGUIbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 04:31:05 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:19336 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaGUIbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 04:31:02 -0400
Message-ID: <53CCCF9F.6090301@parallels.com>
Date: Mon, 21 Jul 2014 12:30:23 +0400
From: Vasily Averin <vvs@parallels.com>
Organization: Parallels
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: [PATCH  v4] fs: umount on symlink leaks mnt count
References: <CAFLxGvxf_bsLNKRtt05zgkdHy+7ALWMz29QUG=f9UwTcqXetfg@mail.gmail.com> <cover.1405859651.git.vvs@openvz.org>
In-Reply-To: <cover.1405859651.git.vvs@openvz.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v4: description corrected
v3: patch inline

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
---
 fs/namei.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 985c6f3..9eb787e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2256,9 +2256,10 @@ done:
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
1.7.5.4

