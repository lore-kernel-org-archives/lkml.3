Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3HDSam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 14:30:42 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41271 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab3HDSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 14:30:40 -0400
Date: Sun, 4 Aug 2013 11:30:25 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jie Liu <jeff.liu@oracle.com>, Dave Chinner <david@fromorbit.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] tmpfs: fix SEEK_DATA/SEEK_HOLE regression
Message-ID: <alpine.LNX.2.00.1308041126360.1636@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 46a1c2c7ae53 ("vfs: export lseek_execute() to modules")
broke the tmpfs SEEK_DATA/SEEK_HOLE implementation, because
vfs_setpos() converts the carefully prepared -ENXIO to -EINVAL.
Other filesystems avoid it in error cases: do the same in tmpfs.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 3.11-rc3/mm/shmem.c	2013-07-14 17:10:16.648003652 -0700
+++ linux/mm/shmem.c	2013-08-04 10:49:52.208372436 -0700
@@ -1798,7 +1798,8 @@ static loff_t shmem_file_llseek(struct f
 		}
 	}
 
-	offset = vfs_setpos(file, offset, MAX_LFS_FILESIZE);
+	if (offset >= 0)
+		offset = vfs_setpos(file, offset, MAX_LFS_FILESIZE);
 	mutex_unlock(&inode->i_mutex);
 	return offset;
 }
