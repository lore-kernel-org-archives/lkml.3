Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaBGQsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 11:48:45 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47592 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBGQsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 11:48:42 -0500
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk, torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bfields@fieldses.org, hch@infradead.org, akpm@linux-foundation.org,
        dhowells@redhat.com, zab@redhat.com, jack@suse.cz, luto@amacapital.net,
        mszeredi@suse.cz
Subject: [PATCH 07/13] vfs: lock_two_nondirectories: allow directory args
Date: Fri,  7 Feb 2014 17:49:05 +0100
Message-Id: <1391791751-2533-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
References: <1391791751-2533-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

lock_two_nondirectories warned if either of its args was a directory.
Instead just ignore the directory args.  This is needed for locking in
cross rename.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/inode.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4bcdad3c9361..763010771cf4 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -944,18 +944,21 @@ EXPORT_SYMBOL(unlock_new_inode);
 
 /**
  * lock_two_nondirectories - take two i_mutexes on non-directory objects
+ *
+ * If either or both arguments are directories, then ignore those.
+ * Therefore zero, one or two objects may be locked by this function.
+ *
  * @inode1: first inode to lock
  * @inode2: second inode to lock
  */
 void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 {
-	WARN_ON_ONCE(S_ISDIR(inode1->i_mode));
-	if (inode1 == inode2 || !inode2) {
+	if (S_ISDIR(inode1->i_mode)) {
+		if (inode2 && !S_ISDIR(inode2->i_mode))
+			mutex_lock(&inode2->i_mutex);
+	} else if (inode1 == inode2 || !inode2 || S_ISDIR(inode2->i_mode)) {
 		mutex_lock(&inode1->i_mutex);
-		return;
-	}
-	WARN_ON_ONCE(S_ISDIR(inode2->i_mode));
-	if (inode1 < inode2) {
+	} else if (inode1 < inode2) {
 		mutex_lock(&inode1->i_mutex);
 		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_NONDIR2);
 	} else {
@@ -972,8 +975,9 @@ EXPORT_SYMBOL(lock_two_nondirectories);
  */
 void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 {
-	mutex_unlock(&inode1->i_mutex);
-	if (inode2 && inode2 != inode1)
+	if (!S_ISDIR(inode1->i_mode))
+		mutex_unlock(&inode1->i_mutex);
+	if (inode2 && inode2 != inode1 && !S_ISDIR(inode2->i_mode))
 		mutex_unlock(&inode2->i_mutex);
 }
 EXPORT_SYMBOL(unlock_two_nondirectories);
-- 
1.8.1.4

