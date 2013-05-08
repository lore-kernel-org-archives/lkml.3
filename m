Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3EHO0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:26:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755408Ab3EHOZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:25:59 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] audit: add child record before the create to handle case where create fails
Date: Wed,  8 May 2013 10:25:58 -0400
Message-Id: <1368023158-21569-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 85e40d1..e2a32e1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2263,6 +2263,7 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
  */
 static inline int may_create(struct inode *dir, struct dentry *child)
 {
+	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
-- 
1.7.1

