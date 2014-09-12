Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaILOm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 10:42:28 -0400
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35700 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbaILOmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 10:42:19 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>, fuse-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v3 1/4] vfs: Check for invalid i_uid in may_follow_link()
Date: Fri, 12 Sep 2014 09:41:42 -0500
Message-Id: <1410532905-114262-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
References: <1410532905-114262-1-git-send-email-seth.forshee@canonical.com>
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
Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
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

