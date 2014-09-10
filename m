Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbaIJOa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:30:27 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:34481 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459AbaIJO3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:29:12 -0400
From: Jeff Layton <jlayton@primarydata.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, bfields@fieldses.org
Subject: [RFC PATCH 09/12] cifs: convert it to use file_lock_context
Date: Wed, 10 Sep 2014 10:28:47 -0400
Message-Id: <1410359330-27564-10-git-send-email-jlayton@primarydata.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
References: <1410359330-27564-1-git-send-email-jlayton@primarydata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@primarydata.com>
---
 fs/cifs/file.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d5fec92e0360..dadfbc9fb5a5 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1101,11 +1101,6 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
 	return rc;
 }
 
-/* copied from fs/locks.c with a name change */
-#define cifs_for_each_lock(inode, lockp) \
-	for (lockp = &inode->i_flock; *lockp != NULL; \
-	     lockp = &(*lockp)->fl_next)
-
 struct lock_to_push {
 	struct list_head llist;
 	__u64 offset;
@@ -1120,8 +1115,9 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 {
 	struct inode *inode = cfile->dentry->d_inode;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-	struct file_lock *flock, **before;
-	unsigned int count = 0, i = 0;
+	struct file_lock *flock;
+	struct file_lock_context *flctx = inode->i_flctx;
+	unsigned int count = 0, i;
 	int rc = 0, xid, type;
 	struct list_head locks_to_send, *el;
 	struct lock_to_push *lck, *tmp;
@@ -1129,12 +1125,14 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 
 	xid = get_xid();
 
-	spin_lock(&inode->i_lock);
-	cifs_for_each_lock(inode, before) {
-		if ((*before)->fl_flags & FL_POSIX)
-			count++;
+	if (!flctx)
+		goto out;
+
+	spin_lock(&flctx->flc_lock);
+	list_for_each(el, &flctx->flc_posix) {
+		count++;
 	}
-	spin_unlock(&inode->i_lock);
+	spin_unlock(&flctx->flc_lock);
 
 	INIT_LIST_HEAD(&locks_to_send);
 
@@ -1143,7 +1141,7 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 	 * added to the list while we are holding cinode->lock_sem that
 	 * protects locking operations of this inode.
 	 */
-	for (; i < count; i++) {
+	for (i = 0; i < count; i++) {
 		lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
 		if (!lck) {
 			rc = -ENOMEM;
@@ -1153,11 +1151,8 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 	}
 
 	el = locks_to_send.next;
-	spin_lock(&inode->i_lock);
-	cifs_for_each_lock(inode, before) {
-		flock = *before;
-		if ((flock->fl_flags & FL_POSIX) == 0)
-			continue;
+	spin_lock(&flctx->flc_lock);
+	list_for_each_entry(flock, &flctx->flc_posix, fl_list) {
 		if (el == &locks_to_send) {
 			/*
 			 * The list ended. We don't have enough allocated
@@ -1177,9 +1172,8 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
 		lck->length = length;
 		lck->type = type;
 		lck->offset = flock->fl_start;
-		el = el->next;
 	}
-	spin_unlock(&inode->i_lock);
+	spin_unlock(&flctx->flc_lock);
 
 	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
 		int stored_rc;
-- 
1.9.3

