Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbaAIV1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 16:27:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:13698 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757315AbaAIV1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 16:27:34 -0500
Date: Thu, 9 Jan 2014 16:27:31 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@parisplace.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] vfs: Fix possible NULL pointer dereference in
 inode_permission()
Message-ID: <20140109162731.12500986@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While running stress tests on adding and deleting ftrace instances I
hit this bug:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffff812d8bc5>] selinux_inode_permission+0x85/0x160
PGD 63681067 PUD 7ddbe067 PMD 0 
Oops: 0000 [#1] PREEMPT 
CPU: 0 PID: 5634 Comm: ftrace-test-mki Not tainted 3.13.0-rc4-test-00033-gd2a6dde-dirty #20
Hardware name:                  /DG965MQ, BIOS MQ96510J.86A.0372.2006.0605.1717 06/05/2006
task: ffff880078375800 ti: ffff88007ddb0000 task.ti: ffff88007ddb0000
RIP: 0010:[<ffffffff812d8bc5>]  [<ffffffff812d8bc5>] selinux_inode_permission+0x85/0x160
RSP: 0018:ffff88007ddb1c48  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000800000 RCX: ffff88006dd43840
RDX: 0000000000000001 RSI: 0000000000000081 RDI: ffff88006ee46000
RBP: ffff88007ddb1c88 R08: 0000000000000000 R09: ffff88007ddb1c54
R10: 6e6576652f6f6f66 R11: 0000000000000003 R12: 0000000000000000
R13: 0000000000000081 R14: ffff88006ee46000 R15: 0000000000000000
FS:  00007f217b5b6700(0000) GS:ffffffff81e21000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033^M
CR2: 0000000000000020 CR3: 000000006a0fe000 CR4: 00000000000007f0
Stack:
 0000000000000081 ffff88006ee46000 0000000000000081 ffffffff812d8b45
 ffff88006ee46000 0000000000000081 ffff880078375800 ffff880078375800
 ffff88007ddb1c98 ffffffff812d358c ffff88007ddb1cb8 ffffffff811364f1
Call Trace:^M
 [<ffffffff812d8b45>] ? selinux_inode_permission+0x5/0x160
 [<ffffffff812d358c>] security_inode_permission+0x1c/0x30
 [<ffffffff811364f1>] __inode_permission+0x41/0xa0
 [<ffffffff81136568>] inode_permission+0x18/0x50
 [<ffffffff811378b6>] link_path_walk+0x66/0x920
 [<ffffffff810875a5>] ? __rcu_read_lock+0x5/0x20
 [<ffffffff8113a9e6>] path_openat+0xa6/0x6c0
 [<ffffffff8113b000>] ? path_openat+0x6c0/0x6c0
 [<ffffffff810c4e69>] ? __trace_graph_entry+0x49/0xc0
 [<ffffffff8112b196>] ? do_sys_open+0x146/0x240
 [<ffffffff8113b043>] do_filp_open+0x43/0xa0
 [<ffffffff8113b005>] ? do_filp_open+0x5/0xa0
 [<ffffffff8112b196>] do_sys_open+0x146/0x240
 [<ffffffff8112b2ae>] SyS_open+0x1e/0x20
 [<ffffffff81948cd0>] system_call_fastpath+0x16/0x1b
Code: 84 a1 00 00 00 81 e3 00 20 00 00 89 d8 83 c8 02 40 f6 c6 04 0f 45 d8 40 f6 c6 08 74 71 80 cf 02 49 8b 46 38 4c 8d 4d cc 45 31 c0 <0f> b7 50 20 8b 70 1c 48 8b 41 70 89 d9 8b 78 04 e8 36 cf ff ff 
RIP  [<ffffffff812d8bc5>] selinux_inode_permission+0x85/0x160
 RSP <ffff88007ddb1c48>
CR2: 0000000000000020
---[ end trace 9d800e5ac5059462 ]---


Investigating, I found that the inode->i_security was NULL, and the
dereference of it caused the oops.

in selinux_inode_permission():
----
	isec = inode->i_security;

	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
----

Note, the crash came from stressing the deletion and reading of debugfs
files. I was not able to recreate this via normal files. But I'm not
sure they are safe. It may just be that the race window is much harder
to hit.

What seems to have happened (and what I have traced), is the file is
being opened at the same time the file or directory is being deleted.
As the dentry and inode locks are not held during the path walk, nor is
the inodes ref counts being incremented, there is nothing saving these
structures from being discarded except for an rcu_read_lock().

The rcu_read_lock() protects against freeing of the inode, but it does
not protect freeing of the inode_security_struct. Talking with Eric
Paris about this, it seems to be a generic issue with the
destroy_inode() calling security_inode_free() when the inode may still
be in use (protected by rcu). It seems that the true destruction of the
inode (done by __destroy_inode()) should also be protect by rcu.

Cc: stable@vger.kernel.org
Cc: Eric Paris <eparis@parisplace.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---

This is based off of this thread:

  https://lkml.org/lkml/2014/1/9/349

And perhaps is the true fix for:

  http://oss.sgi.com/archives/xfs/2013-11/msg00709.html

diff --git a/fs/inode.c b/fs/inode.c
index 4bcdad3..a8f3b88 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -252,16 +252,17 @@ EXPORT_SYMBOL(__destroy_inode);
 static void i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
+	__destroy_inode(inode);
 	kmem_cache_free(inode_cachep, inode);
 }
 
 static void destroy_inode(struct inode *inode)
 {
 	BUG_ON(!list_empty(&inode->i_lru));
-	__destroy_inode(inode);
-	if (inode->i_sb->s_op->destroy_inode)
+	if (inode->i_sb->s_op->destroy_inode) {
+		__destroy_inode(inode);
 		inode->i_sb->s_op->destroy_inode(inode);
-	else
+	} else
 		call_rcu(&inode->i_rcu, i_callback);
 }
 
