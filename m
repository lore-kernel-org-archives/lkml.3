Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaAIPTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:19:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:29515 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751705AbaAIPTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:19:41 -0500
Date: Thu, 9 Jan 2014 10:19:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        James Morris <james.l.morris@oracle.com>,
        Paul Moore <paul@paul-moore.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] SELinux: Fix possible NULL pointer dereference in
 selinux_inode_permission()
Message-ID: <20140109101932.0508dec7@gandalf.local.home>
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
not protect freeing of the inode_security_struct. What needs to happen
is the inode->i_security needs to be checked for NULL, and the
inode_security_struct needs to be freed after a synchronize_rcu(). A
simple check is added to handle the first case, and a call_rcu() was
added to handle the second.

Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 419491d..f2b2d41 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -234,6 +234,14 @@ static int inode_alloc_security(struct inode *inode)
 	return 0;
 }
 
+static void inode_free_rcu(struct rcu_head *head)
+{
+	struct inode_security_struct *isec;
+
+	isec = container_of(head, struct inode_security_struct, rcu);
+	kmem_cache_free(sel_inode_cache, isec);
+}
+
 static void inode_free_security(struct inode *inode)
 {
 	struct inode_security_struct *isec = inode->i_security;
@@ -245,7 +253,7 @@ static void inode_free_security(struct inode *inode)
 	spin_unlock(&sbsec->isec_lock);
 
 	inode->i_security = NULL;
-	kmem_cache_free(sel_inode_cache, isec);
+	call_rcu(&isec->rcu, inode_free_rcu);
 }
 
 static int file_alloc_security(struct file *file)
@@ -2781,6 +2789,10 @@ static int selinux_inode_permission(struct inode *inode, int mask)
 	sid = cred_sid(cred);
 	isec = inode->i_security;
 
+	/* inode is being destroyed */
+	if (!isec)
+		return 0;
+
 	rc = avc_has_perm_noaudit(sid, isec->sid, isec->sclass, perms, 0, &avd);
 	audited = avc_audit_required(perms, &avd, rc,
 				     from_access ? FILE__AUDIT_ACCESS : 0,
diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
index b1dfe10..078e553 100644
--- a/security/selinux/include/objsec.h
+++ b/security/selinux/include/objsec.h
@@ -38,7 +38,10 @@ struct task_security_struct {
 
 struct inode_security_struct {
 	struct inode *inode;	/* back pointer to inode object */
-	struct list_head list;	/* list of inode_security_struct */
+	union {
+		struct list_head list;	/* list of inode_security_struct */
+		struct rcu_head rcu;	/* for freeing the inode_security_struct */
+	};
 	u32 task_sid;		/* SID of creating task */
 	u32 sid;		/* SID of this object */
 	u16 sclass;		/* security class of this object */

