Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3H0Vj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:39:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43668 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3H0Vj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:39:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>
Date: Tue, 27 Aug 2013 14:39:19 -0700
Message-ID: <87haeahkzc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18qAVz61Xq+MnNr0h1DfTcO45ZQ/OW5C1I=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3589]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [REVIEW][PATCH] vfs: Don't copy mount bind mounts of /proc/<pid>/ns/mnt between namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Don't copy bind mounts of /proc/<pid>/ns/mnt between namespaces.
These files hold references to a mount namespace and copying them
between namespaces could result in a reference counting loop.

The current mnt_ns_loop test prevents loops on the assumption that
mounts don't cross between namespaces.  Unfortunately unsharing a
mount namespace and shared substrees can both cause mounts to
propogate between mount namespaces.

Add two flags CL_COPY_UNBINDABLE and CL_COPY_MNT_NS_FILE are added to
control this behavior, and CL_COPY_ALL is redefined as both of them.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/namespace.c |   46 ++++++++++++++++++++++++++++++++++------------
 fs/pnode.h     |    5 ++++-
 2 files changed, 38 insertions(+), 13 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 7e16a73..64627f8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1355,14 +1355,11 @@ SYSCALL_DEFINE1(oldumount, char __user *, name)
 
 #endif
 
-static bool mnt_ns_loop(struct path *path)
+static bool is_mnt_ns_file(struct dentry *dentry)
 {
-	/* Could bind mounting the mount namespace inode cause a
-	 * mount namespace loop?
-	 */
-	struct inode *inode = path->dentry->d_inode;
+	/* Is this a proxy for a mount namespace? */
+	struct inode *inode = dentry->d_inode;
 	struct proc_ns *ei;
-	struct mnt_namespace *mnt_ns;
 
 	if (!proc_ns_inode(inode))
 		return false;
@@ -1371,7 +1368,19 @@ static bool mnt_ns_loop(struct path *path)
 	if (ei->ns_ops != &mntns_operations)
 		return false;
 
-	mnt_ns = ei->ns;
+	return true;
+}
+
+static bool mnt_ns_loop(struct dentry *dentry)
+{
+	/* Could bind mounting the mount namespace inode cause a
+	 * mount namespace loop?
+	 */
+	struct mnt_namespace *mnt_ns;
+	if (!is_mnt_ns_file(dentry))
+		return false;
+
+	mnt_ns = get_proc_ns(dentry->d_inode)->ns;
 	return current->nsproxy->mnt_ns->seq >= mnt_ns->seq;
 }
 
@@ -1380,7 +1389,10 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 {
 	struct mount *res, *p, *q, *r, *parent;
 
-	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
+	if (!(flag & CL_COPY_UNBINDABLE) && IS_MNT_UNBINDABLE(mnt))
+		return ERR_PTR(-EINVAL);
+
+	if (!(flag & CL_COPY_MNT_NS_FILE) && is_mnt_ns_file(dentry))
 		return ERR_PTR(-EINVAL);
 
 	res = q = clone_mnt(mnt, dentry, flag);
@@ -1397,7 +1409,13 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
 			continue;
 
 		for (s = r; s; s = next_mnt(s, r)) {
-			if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(s)) {
+			if (!(flag & CL_COPY_UNBINDABLE) &&
+			    IS_MNT_UNBINDABLE(s)) {
+				s = skip_mnt_tree(s);
+				continue;
+			}
+			if (!(flag & CL_COPY_MNT_NS_FILE) &&
+			    is_mnt_ns_file(s->mnt.mnt_root)) {
 				s = skip_mnt_tree(s);
 				continue;
 			}
@@ -1733,7 +1751,7 @@ static int do_loopback(struct path *path, const char *old_name,
 		return err;
 
 	err = -EINVAL;
-	if (mnt_ns_loop(&old_path))
+	if (mnt_ns_loop(old_path.dentry))
 		goto out; 
 
 	mp = lock_mount(path);
@@ -1755,7 +1773,7 @@ static int do_loopback(struct path *path, const char *old_name,
 		goto out2;
 
 	if (recurse)
-		mnt = copy_tree(old, old_path.dentry, 0);
+		mnt = copy_tree(old, old_path.dentry, CL_COPY_MNT_NS_FILE);
 	else
 		mnt = clone_mnt(old, old_path.dentry, 0);
 
@@ -2417,7 +2435,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 
 	namespace_lock();
 	/* First pass: copy the tree topology */
-	copy_flags = CL_COPY_ALL | CL_EXPIRE;
+	copy_flags = CL_COPY_UNBINDABLE | CL_EXPIRE;
 	if (user_ns != mnt_ns->user_ns)
 		copy_flags |= CL_SHARED_TO_SLAVE | CL_UNPRIVILEGED;
 	new = copy_tree(old, old->mnt.mnt_root, copy_flags);
@@ -2452,6 +2470,10 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 		}
 		p = next_mnt(p, old);
 		q = next_mnt(q, new);
+		if (!q)
+			break;
+		while (p->mnt.mnt_root != q->mnt.mnt_root)
+			p = next_mnt(p, old);
 	}
 	namespace_unlock();
 
diff --git a/fs/pnode.h b/fs/pnode.h
index b091445..59e7eda 100644
--- a/fs/pnode.h
+++ b/fs/pnode.h
@@ -19,11 +19,14 @@
 
 #define CL_EXPIRE    		0x01
 #define CL_SLAVE     		0x02
-#define CL_COPY_ALL 		0x04
+#define CL_COPY_UNBINDABLE	0x04
 #define CL_MAKE_SHARED 		0x08
 #define CL_PRIVATE 		0x10
 #define CL_SHARED_TO_SLAVE	0x20
 #define CL_UNPRIVILEGED		0x40
+#define CL_COPY_MNT_NS_FILE	0x80
+
+#define CL_COPY_ALL		(CL_COPY_UNBINDABLE | CL_COPY_MNT_NS_FILE)
 
 static inline void set_mnt_shared(struct mount *mnt)
 {
-- 
1.7.5.4

