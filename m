Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab3GCSrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:47:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275Ab3GCSlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:05 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=OpRm-J-eJS8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=uPNTOJb0tDQA:10 a=9lXLzYh-AAAA:8 a=iox4zFpeAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=60HpCSrFpWsA:10 a=n9GBPR9yFnkA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184052.509643091@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>
Subject: [048/141] reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0048-reiserfs-fix-spurious-multiple-fill-in-reiserfs_read.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jeff Mahoney <jeffm@jeffreymahoney.com>

[ Upstream commit 0bdc7acba56a7ca4232f15f37b16f7ec079385ab ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/reiserfs/dir.c |    2 ++
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
1.7.10.4


