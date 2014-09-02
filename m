Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbaIBPqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:46:31 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:37249 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962AbaIBPpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:45:00 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 1/3] vfs: Check for invalid i_uid in may_follow_link()
Date: Tue,  2 Sep 2014 10:44:54 -0500
Message-Id: <1409672696-15847-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
References: <1409672696-15847-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filesystem uids which don't map into a user namespace may result
in inode->i_uid being INVALID_UID. A symlink and its parent
could have different owners in the filesystem can both get
mapped to INVALID_UID, which may result in following a symlink
when this would not have otherwise been permitted. Prevent this
by adding a check that the uid is valid before the comparison.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index a996bb48dfab..193da09e903e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -741,7 +741,7 @@ static inline int may_follow_link(struct path *link, struct nameidata *nd)
 		return 0;
 
 	/* Allowed if parent directory and link owner match. */
-	if (uid_eq(parent->i_uid, inode->i_uid))
+	if (uid_valid(inode->i_uid) && uid_eq(parent->i_uid, inode->i_uid))
 		return 0;
 
 	audit_log_link_denied("follow_link", link);
-- 
1.9.1

