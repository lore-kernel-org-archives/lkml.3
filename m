Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab3E1Vnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:43:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756794Ab3E1VVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Eric Paris <eparis@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 19/78] audit: vfs: fix audit_inode call in O_CREAT case of do_last
Date: Tue, 28 May 2013 14:19:28 -0700
Message-Id: <1369776027-17859-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index ec97aef..77dc200 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2749,7 +2749,7 @@ static int do_last(struct nameidata *nd, struct path *path,
 		if (error)
 			return error;
 
-		audit_inode(name, dir, 0);
+		audit_inode(name, dir, LOOKUP_PARENT);
 		error = -EISDIR;
 		/* trailing slashes? */
 		if (nd->last.name[nd->last.len])
-- 
1.8.1.2

