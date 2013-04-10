Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937167Ab3DJXRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:17:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937100Ab3DJWrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:47:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pawel Zawora <pzawora@gmail.com>, Jan Kara <jack@suse.cz>
Subject: [ 12/64] reiserfs: Fix warning and inode leak when deleting inode with xattrs
Date: Wed, 10 Apr 2013 15:46:09 -0700
Message-Id: <20130410224335.880004898@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224333.114387235@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 35e5cbc0af240778e61113286c019837e06aeec6 upstream.

After commit 21d8a15a (lookup_one_len: don't accept . and ..) reiserfs
started failing to delete xattrs from inode. This was due to a buggy
test for '.' and '..' in fill_with_dentries() which resulted in passing
'.' and '..' entries to lookup_one_len() in some cases. That returned
error and so we failed to iterate over all xattrs of and inode.

Fix the test in fill_with_dentries() along the lines of the one in
lookup_one_len().

Reported-by: Pawel Zawora <pzawora@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/reiserfs/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -187,8 +187,8 @@ fill_with_dentries(void *buf, const char
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
 		return -ENOSPC;
 
-	if (name[0] == '.' && (name[1] == '\0' ||
-			       (name[1] == '.' && name[2] == '\0')))
+	if (name[0] == '.' && (namelen < 2 ||
+			       (namelen == 2 && name[1] == '.')))
 		return 0;
 
 	dentry = lookup_one_len(name, dbuf->xadir, namelen);


