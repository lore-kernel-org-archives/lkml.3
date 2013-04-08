Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935997Ab3DHJxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:53:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935990Ab3DHJxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:53:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 101/102] reiserfs: Fix warning and inode leak when deleting inode with xattrs
Date: Mon,  8 Apr 2013 10:50:56 +0100
Message-Id: <1365414657-29191-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/reiserfs/xattr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 46fc1c2..048d990 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -187,8 +187,8 @@ fill_with_dentries(void *buf, const char *name, int namelen, loff_t offset,
 	if (dbuf->count == ARRAY_SIZE(dbuf->dentries))
 		return -ENOSPC;
 
-	if (name[0] == '.' && (name[1] == '\0' ||
-			       (name[1] == '.' && name[2] == '\0')))
+	if (name[0] == '.' && (namelen < 2 ||
+			       (namelen == 2 && name[1] == '.')))
 		return 0;
 
 	dentry = lookup_one_len(name, dbuf->xadir, namelen);
-- 
1.8.1.2

