Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3JKM0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:26:01 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:38227 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab3JKMZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:25:31 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH 4/5] locks: handle merging of locks when FL_FILP_PRIVATE is set
Date: Fri, 11 Oct 2013 08:25:21 -0400
Message-Id: <1381494322-2426-5-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since FL_FILP_PRIVATE locks have different semantics on close, we can't
merge them with "normal" locks or with other FL_FILP_PRIVATE locks that
were acquired on different file descriptors. Consolidate the logic that
determines this into its own function.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 38 +++++++++++++++++++++++++++++++++++---
 1 file changed, 35 insertions(+), 3 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 7186b9a..3bde157 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -934,6 +934,39 @@ out:
 	return error;
 }
 
+/**
+ * posix_locks_mergeable - are two posix locks able to be merged?
+ * @fl1: first posix lock
+ * @fl2: second posix lock
+ *
+ * Determine whether two posix locks are potentially able to be merged. If
+ * they are of different types or have different settings of FL_FILP_PRIVATE
+ * then they cannot be. Ditto if they are FL_FILP_PRIVATE locks and are
+ * associated with different file descriptors.
+ */
+static bool
+posix_locks_mergeable(struct file_lock *fl1, struct file_lock *fl2)
+{
+	unsigned int p1, p2;
+
+	/* Different types are not mergeable */
+	if (fl1->fl_type != fl2->fl_type)
+		return false;
+
+	p1 = IS_PRIVATE(fl1);
+	p2 = IS_PRIVATE(fl2);
+
+	/* Different settings of FL_FILP_PRIVATE aren't mergeable */
+	if (p1 != p2)
+		return false;
+
+	/* When FL_FILP_PRIVATE is set, fl_file must be same */
+	if (p1 && fl1->fl_file != fl2->fl_file)
+		return false;
+
+	return true;
+}
+
 static int __posix_lock_file(struct inode *inode, struct file_lock *request, struct file_lock *conflock)
 {
 	struct file_lock *fl;
@@ -1018,9 +1051,8 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 		     request->fl_file != fl->fl_file)
 			goto next_lock;
 
-		/* Detect adjacent or overlapping regions (if same lock type)
-		 */
-		if (request->fl_type == fl->fl_type) {
+		/* Detect adjacent or overlapping regions (if same lock type) */
+		if (posix_locks_mergeable(fl, request)) {
 			/* In all comparisons of start vs end, use
 			 * "start - 1" rather than "end + 1". If end
 			 * is OFFSET_MAX, end + 1 will become negative.
-- 
1.8.3.1

