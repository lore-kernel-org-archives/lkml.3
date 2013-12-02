Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3LBVBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:01:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab3LBTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>, Jiri Jaburek <jjaburek@redhat.com>,
        Steve Grubb <sgrubb@redhat.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 084/173] audit: fix mq_open and mq_unlink to add the MQ root as a hidden parent audit_names record
Date: Mon,  2 Dec 2013 11:11:07 -0800
Message-Id: <20131202191153.168884194@linuxfoundation.org>
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

commit 79f6530cb59e2a0af6953742a33cc29e98ca631c upstream.

The old audit PATH records for mq_open looked like this:

  type=PATH msg=audit(1366282323.982:869): item=1 name=(null) inode=6777
  dev=00:0c mode=041777 ouid=0 ogid=0 rdev=00:00
  obj=system_u:object_r:tmpfs_t:s15:c0.c1023
  type=PATH msg=audit(1366282323.982:869): item=0 name="test_mq" inode=26732
  dev=00:0c mode=0100700 ouid=0 ogid=0 rdev=00:00
  obj=staff_u:object_r:user_tmpfs_t:s15:c0.c1023

...with the audit related changes that went into 3.7, they now look like this:

  type=PATH msg=audit(1366282236.776:3606): item=2 name=(null) inode=66655
  dev=00:0c mode=0100700 ouid=0 ogid=0 rdev=00:00
  obj=staff_u:object_r:user_tmpfs_t:s15:c0.c1023
  type=PATH msg=audit(1366282236.776:3606): item=1 name=(null) inode=6926
  dev=00:0c mode=041777 ouid=0 ogid=0 rdev=00:00
  obj=system_u:object_r:tmpfs_t:s15:c0.c1023
  type=PATH msg=audit(1366282236.776:3606): item=0 name="test_mq"

Both of these look wrong to me.  As Steve Grubb pointed out:

 "What we need is 1 PATH record that identifies the MQ.  The other PATH
  records probably should not be there."

Fix it to record the mq root as a parent, and flag it such that it
should be hidden from view when the names are logged, since the root of
the mq filesystem isn't terribly interesting.  With this change, we get
a single PATH record that looks more like this:

  type=PATH msg=audit(1368021604.836:484): item=0 name="test_mq" inode=16914
  dev=00:0c mode=0100644 ouid=0 ogid=0 rdev=00:00
  obj=unconfined_u:object_r:user_tmpfs_t:s0

In order to do this, a new audit_inode_parent_hidden() function is
added.  If we do it this way, then we avoid having the existing callers
of audit_inode needing to do any sort of flag conversion if auditing is
inactive.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reported-by: Jiri Jaburek <jjaburek@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/audit.h |   26 ++++++++++++++++++++++----
 ipc/mqueue.c          |    2 ++
 kernel/audit.h        |    1 +
 kernel/auditsc.c      |   12 +++++++++---
 4 files changed, 34 insertions(+), 7 deletions(-)

--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -103,8 +103,11 @@ extern void __audit_syscall_exit(int ret
 extern struct filename *__audit_reusename(const __user char *uptr);
 extern void __audit_getname(struct filename *name);
 extern void audit_putname(struct filename *name);
+
+#define AUDIT_INODE_PARENT	1	/* dentry represents the parent */
+#define AUDIT_INODE_HIDDEN	2	/* audit record should be hidden */
 extern void __audit_inode(struct filename *name, const struct dentry *dentry,
-				unsigned int parent);
+				unsigned int flags);
 extern void __audit_inode_child(const struct inode *parent,
 				const struct dentry *dentry,
 				const unsigned char type);
@@ -148,10 +151,22 @@ static inline void audit_getname(struct
 	if (unlikely(!audit_dummy_context()))
 		__audit_getname(name);
 }
-static inline void audit_inode(struct filename *name, const struct dentry *dentry,
+static inline void audit_inode(struct filename *name,
+				const struct dentry *dentry,
 				unsigned int parent) {
+	if (unlikely(!audit_dummy_context())) {
+		unsigned int flags = 0;
+		if (parent)
+			flags |= AUDIT_INODE_PARENT;
+		__audit_inode(name, dentry, flags);
+	}
+}
+static inline void audit_inode_parent_hidden(struct filename *name,
+						const struct dentry *dentry)
+{
 	if (unlikely(!audit_dummy_context()))
-		__audit_inode(name, dentry, parent);
+		__audit_inode(name, dentry,
+				AUDIT_INODE_PARENT | AUDIT_INODE_HIDDEN);
 }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry,
@@ -311,7 +326,7 @@ static inline void audit_putname(struct
 { }
 static inline void __audit_inode(struct filename *name,
 					const struct dentry *dentry,
-					unsigned int parent)
+					unsigned int flags)
 { }
 static inline void __audit_inode_child(const struct inode *parent,
 					const struct dentry *dentry,
@@ -321,6 +336,9 @@ static inline void audit_inode(struct fi
 				const struct dentry *dentry,
 				unsigned int parent)
 { }
+static inline void audit_inode_parent_hidden(struct filename *name,
+				const struct dentry *dentry)
+{ }
 static inline void audit_inode_child(const struct inode *parent,
 				     const struct dentry *dentry,
 				     const unsigned char type)
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -823,6 +823,7 @@ SYSCALL_DEFINE4(mq_open, const char __us
 				error = ro;
 				goto out;
 			}
+			audit_inode_parent_hidden(name, root);
 			filp = do_create(ipc_ns, root->d_inode,
 						&path, oflag, mode,
 						u_attr ? &attr : NULL);
@@ -868,6 +869,7 @@ SYSCALL_DEFINE1(mq_unlink, const char __
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
+	audit_inode_parent_hidden(name, mnt->mnt_root);
 	err = mnt_want_write(mnt);
 	if (err)
 		goto out_name;
--- a/kernel/audit.h
+++ b/kernel/audit.h
@@ -85,6 +85,7 @@ struct audit_names {
 
 	struct filename		*name;
 	int			name_len;	/* number of chars to log */
+	bool			hidden;		/* don't log this record */
 	bool			name_put;	/* call __putname()? */
 
 	unsigned long		ino;
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1399,8 +1399,11 @@ static void audit_log_exit(struct audit_
 	}
 
 	i = 0;
-	list_for_each_entry(n, &context->names_list, list)
+	list_for_each_entry(n, &context->names_list, list) {
+		if (n->hidden)
+			continue;
 		audit_log_name(context, n, NULL, i++, &call_panic);
+	}
 
 	/* Send end of event record to help user space know we are finished */
 	ab = audit_log_start(context, GFP_KERNEL, AUDIT_EOE);
@@ -1769,14 +1772,15 @@ void audit_putname(struct filename *name
  * __audit_inode - store the inode and device from a lookup
  * @name: name being audited
  * @dentry: dentry being audited
- * @parent: does this dentry represent the parent?
+ * @flags: attributes for this particular entry
  */
 void __audit_inode(struct filename *name, const struct dentry *dentry,
-		   unsigned int parent)
+		   unsigned int flags)
 {
 	struct audit_context *context = current->audit_context;
 	const struct inode *inode = dentry->d_inode;
 	struct audit_names *n;
+	bool parent = flags & AUDIT_INODE_PARENT;
 
 	if (!context->in_syscall)
 		return;
@@ -1831,6 +1835,8 @@ out:
 	if (parent) {
 		n->name_len = n->name ? parent_len(n->name->name) : AUDIT_NAME_FULL;
 		n->type = AUDIT_TYPE_PARENT;
+		if (flags & AUDIT_INODE_HIDDEN)
+			n->hidden = true;
 	} else {
 		n->name_len = AUDIT_NAME_FULL;
 		n->type = AUDIT_TYPE_NORMAL;


