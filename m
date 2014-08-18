Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaHRGdt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:33:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbaHRGdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:33:47 -0400
From: NeilBrown <neilb@suse.de>
To: Ian Kent <raven@themaw.net>
Date: Mon, 18 Aug 2014 16:33:01 +1000
Subject: [PATCH 3/5] autofs4: avoid taking fs_lock during rcu-walk
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140818063301.9860.11381.stgit@notabene.brown>
In-Reply-To: <20140818062844.9860.43007.stgit@notabene.brown>
References: <20140818062844.9860.43007.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

->fs_lock protects AUTOFS_INF_EXPIRING.  We need to be sure
that once the flag is set, no new references beneath the dentry
are taken.  So rcu-walk currently needs to take fs_lock before
checking the flag.  This hurts performance.

Change the expiry to a two-stage process.
First set AUTOFS_INF_NO_RCU which forces any path walk into
ref-walk mode, then drop the lock and call synchronize_rcu().
Once that returns we can be sure no rcu-walk is active beneath
the dentry and we can check reference counts again.

Now during an RCU-walk we can test AUTOFS_INF_EXPIRING without
taking the lock as along as we test AUTOFS_INF_NO_RCU too.
If either are set, we must abort the RCU-walk
If neither are set, we know that refcounts will be tested again
after we finish the RCU-walk so we are safe to continue.

->fs_lock is still taken in d_manage() to check for a non-trap
directory.  That will be resolved in the next patch.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/autofs_i.h |    4 ++++
 fs/autofs4/expire.c   |   46 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
index 2f1032f12d91..8e98cf954bab 100644
--- a/fs/autofs4/autofs_i.h
+++ b/fs/autofs4/autofs_i.h
@@ -79,6 +79,10 @@ struct autofs_info {
 };
 
 #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
+#define AUTOFS_INF_NO_RCU	(1<<1) /* the dentry is being considered
+					* for expiry, so RCU_walk is
+					* not permitted
+					*/
 #define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
 
 struct autofs_wait_queue {
diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index bee939efca2b..eb4b770a4bf6 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -333,10 +333,19 @@ struct dentry *autofs4_expire_direct(struct super_block *sb,
 	if (ino->flags & AUTOFS_INF_PENDING)
 		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		ino->flags |= AUTOFS_INF_EXPIRING;
-		init_completion(&ino->expire_complete);
+		ino->flags |= AUTOFS_INF_NO_RCU;
 		spin_unlock(&sbi->fs_lock);
-		return root;
+		synchronize_rcu();
+		spin_lock(&sbi->fs_lock);
+		if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
+			ino->flags |= AUTOFS_INF_EXPIRING;
+			smp_mb();
+			ino->flags &= ~AUTOFS_INF_NO_RCU;
+			init_completion(&ino->expire_complete);
+			spin_unlock(&sbi->fs_lock);
+			return root;
+		}
+		ino->flags &= ~AUTOFS_INF_NO_RCU;
 	}
 out:
 	spin_unlock(&sbi->fs_lock);
@@ -454,12 +463,29 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 	dentry = NULL;
 	while ((dentry = get_next_positive_subdir(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
-		expired = should_expire(dentry, mnt, timeout, how);
-		if (expired) {
+		ino = autofs4_dentry_ino(dentry);
+		if (ino->flags & AUTOFS_INF_NO_RCU)
+			expired = NULL;
+		else
+			expired = should_expire(dentry, mnt, timeout, how);
+		if (!expired) {
+			spin_unlock(&sbi->fs_lock);
+			continue;
+		}
+		ino = autofs4_dentry_ino(expired);
+		ino->flags |= AUTOFS_INF_NO_RCU;
+		spin_unlock(&sbi->fs_lock);
+		synchronize_rcu();
+		spin_lock(&sbi->fs_lock);
+		if (should_expire(expired, mnt, timeout, how)) {
 			if (expired != dentry)
 				dput(dentry);
 			goto found;
 		}
+
+		ino->flags &= ~AUTOFS_INF_NO_RCU;
+		if (expired != dentry)
+			dput(expired);
 		spin_unlock(&sbi->fs_lock);
 	}
 	return NULL;
@@ -467,8 +493,9 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 found:
 	DPRINTK("returning %p %.*s",
 		expired, (int)expired->d_name.len, expired->d_name.name);
-	ino = autofs4_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
+	smp_mb();
+	ino->flags &= ~AUTOFS_INF_NO_RCU;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&sbi->lookup_lock);
@@ -488,11 +515,14 @@ int autofs4_expire_wait(struct dentry *dentry, int rcu_walk)
 	int status;
 
 	/* Block on any pending expire */
+	if (!(ino->flags & (AUTOFS_INF_EXPIRING | AUTOFS_INF_NO_RCU)))
+		return 0;
+	if (rcu_walk)
+		return -ECHILD;
+
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
-		if (rcu_walk)
-			return -ECHILD;
 
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);


