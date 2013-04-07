Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559Ab3DGXZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 19:25:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46555 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934527Ab3DGXZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 19:25:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Pawel Zawora" <pzawora@gmail.com>,
        "Jan Kara" <jack@suse.cz>
Date: Sun, 07 Apr 2013 23:45:42 +0100
Message-ID: <lsq.1365374742.847542495@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [39/74] reiserfs: Fix warning and inode leak when deleting inode
 with xattrs
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/reiserfs/xattr.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index c196369..4cce1d9 100644
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

