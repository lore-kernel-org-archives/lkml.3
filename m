Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab3FEVpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:45:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab3FEVgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, Jan Kara <jack@suse.cz>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 097/127] reiserfs: fix spurious multiple-fill in reiserfs_readdir_dentry
Date: Wed,  5 Jun 2013 14:34:24 -0700
Message-Id: <20130605213229.010043462@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/dir.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -204,6 +204,8 @@ int reiserfs_readdir_dentry(struct dentr
 				next_pos = deh_offset(deh) + 1;
 
 				if (item_moved(&tmp_ih, &path_to_entry)) {
+					set_cpu_key_k_offset(&pos_key,
+							     next_pos);
 					goto research;
 				}
 			}	/* for */


