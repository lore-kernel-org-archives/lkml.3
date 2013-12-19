Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3LSNio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 08:38:44 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:37994 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab3LSNe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 08:34:57 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 07/13] locks: simplify overflow checking
Date: Thu, 19 Dec 2013 08:34:19 -0500
Message-Id: <1387460065-28269-8-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
References: <1387460065-28269-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. Bruce Fields" <bfields@fieldses.org>

Or maybe we don't actually care about indicating overflow in the 32-bit
case: sure we could fail if e.g. f_pos+start or f_pos+start+len would
exceed 32-bits, but do we really need to?

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
---
 fs/locks.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 863f4df..1555b05 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -344,8 +344,8 @@ static int assign_type(struct file_lock *fl, long type)
 	return 0;
 }
 
-static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
-					struct flock64 *l, loff_t offset_max)
+static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
+				 struct flock64 *l)
 {
 	switch (l->l_whence) {
 	case SEEK_SET:
@@ -360,12 +360,12 @@ static int flock_to_posix_lock_common(struct file *filp, struct file_lock *fl,
 	default:
 		return -EINVAL;
 	}
-	if (l->l_start > offset_max - fl->fl_start)
+	if (l->l_start > OFFSET_MAX - fl->fl_start)
 		return -EOVERFLOW;
 	fl->fl_start += l->l_start;
 	if (fl->fl_start < 0)
 		return -EINVAL;
-	if (l->l_len > offset_max - fl->fl_start)
+	if (l->l_len > OFFSET_MAX - fl->fl_start)
 		return -EOVERFLOW;
 	if (fl->fl_start + l->l_len < 0)
 		return -EINVAL;
@@ -403,22 +403,9 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 		.l_len = l->l_len,
 	};
 
-	/*
-	 * The use of OFFT_OFFSET_MAX here ensures we return -EOVERFLOW
-	 * if the start or end of the lock could not be represented as
-	 * an off_t, following SUSv3.
-	 */
-	return flock_to_posix_lock_common(filp, fl, &ll, OFFT_OFFSET_MAX);
+	return flock64_to_posix_lock(filp, fl, &ll);
 }
 
-#if BITS_PER_LONG == 32
-static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
-				 struct flock64 *l)
-{
-	return flock_to_posix_lock_common(filp, fl, l, OFFSET_MAX);
-}
-#endif
-
 /* default lease lock manager operations */
 static void lease_break_callback(struct file_lock *fl)
 {
-- 
1.8.4.2

