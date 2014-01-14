Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaANTLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:11:30 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44042 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaANTHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:07:13 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 05/14] locks: eliminate BUG() call when there's an unexpected lock on file close
Date: Tue, 14 Jan 2014 14:06:45 -0500
Message-Id: <1389726414-30990-6-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
References: <1389726414-30990-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A leftover lock on the list is surely a sign of a problem of some sort,
but it's not necessarily a reason to panic the box. Instead, just log a
warning with some info about the lock, and then delete it like we would
any other lock.

In the event that the filesystem declares a ->lock f_op, we may end up
leaking something, but that's generally preferable to an immediate
panic.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 6084f5a..dd30933 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2281,16 +2281,28 @@ void locks_remove_flock(struct file *filp)
 
 	while ((fl = *before) != NULL) {
 		if (fl->fl_file == filp) {
-			if (IS_FLOCK(fl)) {
-				locks_delete_lock(before);
-				continue;
-			}
 			if (IS_LEASE(fl)) {
 				lease_modify(before, F_UNLCK);
 				continue;
 			}
-			/* What? */
-			BUG();
+
+			/*
+			 * There's a leftover lock on the list of a type that
+			 * we didn't expect to see. Most likely a classic
+			 * POSIX lock that ended up not getting released
+			 * properly, or that raced onto the list somehow. Log
+			 * some info about it and then just remove it from
+			 * the list.
+			 */
+			WARN(!IS_FLOCK(fl),
+				"leftover lock: dev=%u:%u ino=%lu type=%hhd flags=0x%x start=%lld end=%lld\n",
+				MAJOR(inode->i_sb->s_dev),
+				MINOR(inode->i_sb->s_dev), inode->i_ino,
+				fl->fl_type, fl->fl_flags,
+				fl->fl_start, fl->fl_end);
+
+			locks_delete_lock(before);
+			continue;
  		}
 		before = &fl->fl_next;
 	}
-- 
1.8.4.2

