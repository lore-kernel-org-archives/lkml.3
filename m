Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889Ab3JKMZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:25:34 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:63750 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605Ab3JKMZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:25:30 -0400
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [RFC PATCH 3/5] locks: skip FL_FILP_PRIVATE locks on close unless we're closing the correct filp
Date: Fri, 11 Oct 2013 08:25:20 -0400
Message-Id: <1381494322-2426-4-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
References: <1381494322-2426-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the request has FL_CLOSE set, then we know we're releasing locks in
response to a fd being closed. When iterating over locks, skip any
locks that have FL_FILP_PRIVATE set and that don't have the same fl_file
pointer.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/locks.c b/fs/locks.c
index 086c3b4..7186b9a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -135,6 +135,7 @@
 #define IS_POSIX(fl)	(fl->fl_flags & FL_POSIX)
 #define IS_FLOCK(fl)	(fl->fl_flags & FL_FLOCK)
 #define IS_LEASE(fl)	(fl->fl_flags & FL_LEASE)
+#define IS_PRIVATE(fl)	(fl->fl_flags & FL_FILP_PRIVATE)
 
 static bool lease_breaking(struct file_lock *fl)
 {
@@ -1009,6 +1010,14 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 
 	/* Process locks with this owner. */
 	while ((fl = *before) && posix_same_owner(request, fl)) {
+		/*
+		 * For fd-private locks, only release locks that are associated
+		 * with this filp.
+		 */
+		if ((request->fl_flags & FL_CLOSE) && IS_PRIVATE(fl) &&
+		     request->fl_file != fl->fl_file)
+			goto next_lock;
+
 		/* Detect adjacent or overlapping regions (if same lock type)
 		 */
 		if (request->fl_type == fl->fl_type) {
-- 
1.8.3.1

