Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab3FDOMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:12:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756413Ab3FDOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:08:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 60/70] reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry
Date: Tue,  4 Jun 2013 15:07:16 +0100
Message-Id: <1370354846-14213-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
References: <1370354846-14213-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@jeffreymahoney.com>

commit 0bdc7acba56a7ca4232f15f37b16f7ec079385ab upstream.

After sleeping for filldir(), we check to see if the file system has
changed and research. The next_pos pointer is updated but its value
isn't pushed into the key used for the search itself. As a result,
the search returns the same item that the last cycle of the loop did
and filldir() is called multiple times with the same data.

The end result is that the buffer can contain the same name multiple
times. This can be returned to userspace or used internally in the
xattr code where it can manifest with the following warning:

jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-2)

reiserfs_for_each_xattr uses reiserfs_readdir_dentry to iterate over
the xattr names and ends up trying to unlink the same name twice. The
second attempt fails with -ENOENT and the error is returned. At some
point I'll need to add support into reiserfsck to remove the orphaned
directories left behind when this occurs.

The fix is to push the value into the key before researching.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/reiserfs/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index 66c53b6..6c2d136 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -204,6 +204,8 @@ int reiserfs_readdir_dentry(struct dentry *dentry, void *dirent,
 				next_pos = deh_offset(deh) + 1;
 
 				if (item_moved(&tmp_ih, &path_to_entry)) {
+					set_cpu_key_k_offset(&pos_key,
+							     next_pos);
 					goto research;
 				}
 			}	/* for */
-- 
1.8.1.2

