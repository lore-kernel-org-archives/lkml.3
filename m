Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaBEUXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:23:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:55436 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbaBEUH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:28 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Tyler Hicks <tyhicks@canonical.com>,
        John Johansen <john.johansen@canonical.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 168/213] eCryptfs: Copy up lower inode attrs after setting lower xattr
Date: Wed, 5 Feb 2014 15:02:03 -0500
Message-ID: <1391630568-49251-169-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hicks <tyhicks@canonical.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 545d680938be1e86a6c5250701ce9abaf360c495 upstream.

After passing through a ->setxattr() call, eCryptfs needs to copy the
inode attributes from the lower inode to the eCryptfs inode, as they
may have changed in the lower filesystem's ->setxattr() path.

One example is if an extended attribute containing a POSIX Access
Control List is being set. The new ACL may cause the lower filesystem to
modify the mode of the lower inode and the eCryptfs inode would need to
be updated to reflect the new mode.

https://launchpad.net/bugs/926292

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Sebastien Bacher <seb128@ubuntu.com>
Cc: John Johansen <john.johansen@canonical.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ecryptfs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 168706e90e3f..532b97bb1f15 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1057,6 +1057,8 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	}
 
 	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
+	if (!rc)
+		fsstack_copy_attr_all(dentry->d_inode, lower_dentry->d_inode);
 out:
 	return rc;
 }
-- 
1.8.5.2

