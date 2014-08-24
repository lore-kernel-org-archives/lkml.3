Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945AbaHXWoD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 18:44:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60035 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768AbaHXWoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 18:44:00 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 25 Aug 2014 08:42:36 +1000
Subject: [PATCH 5/6] autofs4: d_manage() should return -EISDIR when
 appropriate in rcu-walk mode.
Cc: autofs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>
Message-ID: <20140824224236.16196.45803.stgit@notabene.brown>
In-Reply-To: <20140824223628.16196.5795.stgit@notabene.brown>
References: <20140824223628.16196.5795.stgit@notabene.brown>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If rcu-walk mode we don't *have* to return -EISDIR for non-mount-traps
as we will simply drop into REF-walk and handling DCACHE_NEED_AUTOMOUNT
dentrys the slow way.  But it is better if we do when possible.

In 'oz_mode', use the same condition as ref-walk: if not a mountpoint,
then it must be -EISDIR.

In regular mode there are most tests needed.  Most of them can be
performed without taking any spinlocks.
If we find a directory that isn't obviously empty, and isn't mounted
on, we need to call 'simple_empty()' which does take a spinlock.
If this turned out to hurt performance, some other approach could
be found to signal when a directory is known to be empty.

Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/autofs4/root.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 2296c8301b66..71e4413d65c8 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -433,8 +433,6 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
-		if (rcu_walk)
-			return 0;
 		if (!d_mountpoint(dentry))
 			return -EISDIR;
 		return 0;
@@ -452,12 +450,28 @@ static int autofs4_d_manage(struct dentry *dentry, bool rcu_walk)
 	if (status)
 		return status;
 
-	if (rcu_walk)
-		/* it is always safe to return 0 as the worst that
-		 * will happen is we retry in REF-walk mode.
-		 * Better than always taking a lock.
+	if (rcu_walk) {
+		/* We don't need fs_lock in rcu_walk mode,
+		 * just testing 'AUTOFS_INFO_NO_RCU' is enough.
+		 * simple_empty() takes a spinlock, so leave it
+		 * to last.
+		 * We only return -EISDIR when certain this isn't
+		 * a mount-trap.
 		 */
+		struct inode *inode;
+		if (ino->flags & (AUTOFS_INF_EXPIRING | AUTOFS_INF_NO_RCU))
+			return 0;
+		if (d_mountpoint(dentry))
+			return 0;
+		inode = rcu_dereference(dentry->d_inode);
+		if (inode && S_ISLNK(inode->i_mode))
+			return -EISDIR;
+		if (list_empty(&dentry->d_subdirs))
+			return 0;
+		if (!simple_empty(dentry))
+			return -EISDIR;
 		return 0;
+	}
 
 	spin_lock(&sbi->fs_lock);
 	/*


