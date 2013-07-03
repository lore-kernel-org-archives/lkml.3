Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965472Ab3GCUVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:21:23 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19216 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3GCUVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:21:19 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 10/25] cifs: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:21:05 -0400
Message-Id: <1372882865-22845-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/cifs/dir.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 5699b50..51d9f7e 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -115,10 +115,10 @@ cifs_bp_rename_retry:
 	full_path[namelen] = 0;	/* trailing null */
 	rcu_read_lock();
 	for (temp = direntry; !IS_ROOT(temp);) {
-		spin_lock(&temp->d_lock);
+		d_lock(temp);
 		namelen -= 1 + temp->d_name.len;
 		if (namelen < 0) {
-			spin_unlock(&temp->d_lock);
+			d_unlock(temp);
 			break;
 		} else {
 			full_path[namelen] = dirsep;
@@ -126,7 +126,7 @@ cifs_bp_rename_retry:
 				temp->d_name.len);
 			cifs_dbg(FYI, "name: %s\n", full_path + namelen);
 		}
-		spin_unlock(&temp->d_lock);
+		d_unlock(temp);
 		temp = temp->d_parent;
 		if (temp == NULL) {
 			cifs_dbg(VFS, "corrupt dentry\n");
@@ -777,9 +777,9 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 			 */
 			if (IS_AUTOMOUNT(direntry->d_inode) &&
 			   !(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
-				spin_lock(&direntry->d_lock);
+				d_lock(direntry);
 				direntry->d_flags |= DCACHE_NEED_AUTOMOUNT;
-				spin_unlock(&direntry->d_lock);
+				d_unlock(direntry);
 			}
 
 			return 1;
-- 
1.7.1

