Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161576Ab3LFNCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:02:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab3LFNC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:02:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Eric Paris <eparis@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 132/272] audit: add child record before the create to handle case where create fails
Date: Fri,  6 Dec 2013 12:57:01 +0000
Message-Id: <1386334761-25517-133-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 14e972b4517128ac8e30e3de2ee4fbd995084223 upstream.

Historically, when a syscall that creates a dentry fails, you get an audit
record that looks something like this (when trying to create a file named
"new" in "/tmp/tmp.SxiLnCcv63"):

    type=PATH msg=audit(1366128956.279:965): item=0 name="/tmp/tmp.SxiLnCcv63/new" inode=2138308 dev=fd:02 mode=040700 ouid=0 ogid=0 rdev=00:00 obj=staff_u:object_r:user_tmp_t:s15:c0.c1023

This record makes no sense since it's associating the inode information for
"/tmp/tmp.SxiLnCcv63" with the path "/tmp/tmp.SxiLnCcv63/new". The recent
patch I posted to fix the audit_inode call in do_last fixes this, by making it
look more like this:

    type=PATH msg=audit(1366128765.989:13875): item=0 name="/tmp/tmp.DJ1O8V3e4f/" inode=141 dev=fd:02 mode=040700 ouid=0 ogid=0 rdev=00:00 obj=staff_u:object_r:user_tmp_t:s15:c0.c1023

While this is more correct, if the creation of the file fails, then we
have no record of the filename that the user tried to create.

This patch adds a call to audit_inode_child to may_create. This creates
an AUDIT_TYPE_CHILD_CREATE record that will sit in place until the
create succeeds. When and if the create does succeed, then this record
will be updated with the correct inode info from the create.

This fixes what was broken in commit bfcec708.
Commit 79f6530c should also be backported to stable v3.7+.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/namei.c b/fs/namei.c
index 7720fbd..df9946e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2262,6 +2262,7 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
  */
 static inline int may_create(struct inode *dir, struct dentry *child)
 {
+	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
-- 
1.8.3.2

