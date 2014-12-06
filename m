Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaLFPYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:24:16 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:47700 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752066AbaLFPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:08:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>,
        Markus Blank-Burian <burian@muenster.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 64/66] locks: eliminate BUG() call when there's an unexpected lock on file close
Date: Sat,  6 Dec 2014 16:07:56 +0100
Message-Id: <cac69a82453f8cf8097d0550d53942c5333f07de.1417878427.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
References: <d278ba6471641f99eda3b3c76f8414339c9dbed0.1417878427.git.jslaby@suse.cz>
In-Reply-To: <cover.1417878427.git.jslaby@suse.cz>
References: <cover.1417878427.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Layton <jlayton@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8c3cac5e6a85f03602ffe09c44f14418699e31ec upstream.

A leftover lock on the list is surely a sign of a problem of some sort,
but it's not necessarily a reason to panic the box. Instead, just log a
warning with some info about the lock, and then delete it like we would
any other lock.

In the event that the filesystem declares a ->lock f_op, we may end up
leaking something, but that's generally preferable to an immediate
panic.

Acked-by: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Markus Blank-Burian <burian@muenster.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/locks.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index ad95fbd20f8a..0d2b5febc627 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2199,16 +2199,28 @@ void locks_remove_flock(struct file *filp)
 
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
2.1.3

