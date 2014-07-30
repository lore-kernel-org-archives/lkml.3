Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbaG3CEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:04:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaG3Btq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vasily Averin <vvs@openvz.org>, Ian Kent <raven@themaw.net>,
        Jeff Layton <jlayton@primarydata.com>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 21/29] fs: umount on symlink leaks mnt count
Date: Tue, 29 Jul 2014 18:48:56 -0700
Message-Id: <20140730014810.223382657@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2247,9 +2247,10 @@ done:
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


