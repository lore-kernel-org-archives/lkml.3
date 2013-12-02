Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3LBUyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:54:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab3LBTNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Eric Paris <eparis@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.10 085/173] audit: add child record before the create to handle case where create fails
Date: Mon,  2 Dec 2013 11:11:08 -0800
Message-Id: <20131202191153.293634915@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2263,6 +2263,7 @@ static int may_delete(struct inode *dir,
  */
 static inline int may_create(struct inode *dir, struct dentry *child)
 {
+	audit_inode_child(dir, child, AUDIT_TYPE_CHILD_CREATE);
 	if (child->d_inode)
 		return -EEXIST;
 	if (IS_DEADDIR(dir))


