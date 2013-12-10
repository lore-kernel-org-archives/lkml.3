Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab3LJTSE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:18:04 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:64365 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab3LJTR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:17:56 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nfs-ganesha-devel@lists.sourceforge.net,
        samba-technical@lists.samba.org
Subject: [PATCH v3 1/6] locks: consolidate common code in the flock_to_posix_lock routines
Date: Tue, 10 Dec 2013 14:17:30 -0500
Message-Id: <1386703055-22308-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
References: <1386703055-22308-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there's a lot of copy and paste between the two.  Add some
functions to do the initialization of the file_lock from values
passed in, and turn the flock/flock64 variants of those functions into
wrappers around them.

Unfortunately it's harder to consolidate the fl_start/fl_end
calculations due to the differently sized types involved so I've left
them separate for now.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 6084f5a..a5848ed 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -344,6 +344,19 @@ static int assign_type(struct file_lock *fl, long type)
 	return 0;
 }
 
+static int
+flock_to_posix_lock_common(struct file_lock *fl, struct file *filp, short type)
+{
+	fl->fl_owner = current->files;
+	fl->fl_pid = current->tgid;
+	fl->fl_file = filp;
+	fl->fl_flags = FL_POSIX;
+	fl->fl_ops = NULL;
+	fl->fl_lmops = NULL;
+
+	return assign_type(fl, type);
+}
+
 /* Verify a "struct flock" and copy it to a "struct file_lock" as a POSIX
  * style lock.
  */
@@ -386,14 +399,7 @@ static int flock_to_posix_lock(struct file *filp, struct file_lock *fl,
 	if (fl->fl_end < fl->fl_start)
 		return -EOVERFLOW;
 	
-	fl->fl_owner = current->files;
-	fl->fl_pid = current->tgid;
-	fl->fl_file = filp;
-	fl->fl_flags = FL_POSIX;
-	fl->fl_ops = NULL;
-	fl->fl_lmops = NULL;
-
-	return assign_type(fl, l->l_type);
+	return flock_to_posix_lock_common(fl, filp, l->l_type);
 }
 
 #if BITS_PER_LONG == 32
@@ -431,15 +437,8 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
 	fl->fl_start = start;	/* we record the absolute position */
 	if (fl->fl_end < fl->fl_start)
 		return -EOVERFLOW;
-	
-	fl->fl_owner = current->files;
-	fl->fl_pid = current->tgid;
-	fl->fl_file = filp;
-	fl->fl_flags = FL_POSIX;
-	fl->fl_ops = NULL;
-	fl->fl_lmops = NULL;
 
-	return assign_type(fl, l->l_type);
+	return flock_to_posix_lock_common(fl, filp, l->l_type);
 }
 #endif
 
-- 
1.8.4.2

