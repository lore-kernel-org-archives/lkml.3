Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab3EQWRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:17:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3EQVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jiri Jaburek <jjaburek@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: [ 032/102] audit: vfs: fix audit_inode call in O_CREAT case of do_last
Date: Fri, 17 May 2013 14:35:47 -0700
Message-Id: <20130517213247.697597159@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 33e2208acfc15ce00d3dd13e839bf6434faa2b04 upstream.

Jiri reported a regression in auditing of open(..., O_CREAT) syscalls.
In older kernels, creating a file with open(..., O_CREAT) created
audit_name records that looked like this:

type=PATH msg=audit(1360255720.628:64): item=1 name="/abc/foo" inode=138810 dev=fd:00 mode=0100640 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
type=PATH msg=audit(1360255720.628:64): item=0 name="/abc/" inode=138635 dev=fd:00 mode=040750 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0

...in recent kernels though, they look like this:

type=PATH msg=audit(1360255402.886:12574): item=2 name=(null) inode=264599 dev=fd:00 mode=0100640 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
type=PATH msg=audit(1360255402.886:12574): item=1 name=(null) inode=264598 dev=fd:00 mode=040750 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
type=PATH msg=audit(1360255402.886:12574): item=0 name="/abc/foo" inode=264598 dev=fd:00 mode=040750 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0

Richard bisected to determine that the problems started with commit
bfcec708, but the log messages have changed with some later
audit-related patches.

The problem is that this audit_inode call is passing in the parent of
the dentry being opened, but audit_inode is being called with the parent
flag false. This causes later audit_inode and audit_inode_child calls to
match the wrong entry in the audit_names list.

This patch simply sets the flag to properly indicate that this inode
represents the parent. With this, the audit_names entries are back to
looking like they did before.

Reported-by: Jiri Jaburek <jjaburek@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Test By: Richard Guy Briggs <rbriggs@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2740,7 +2740,7 @@ static int do_last(struct nameidata *nd,
 		if (error)
 			return error;
 
-		audit_inode(name, dir, 0);
+		audit_inode(name, dir, LOOKUP_PARENT);
 		error = -EISDIR;
 		/* trailing slashes? */
 		if (nd->last.name[nd->last.len])


