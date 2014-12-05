Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaLEW42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:56:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54545 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaLEW4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Jeff Layton <jlayton@redhat.com>,
        Markus Blank-Burian <burian@muenster.de>
Subject: [PATCH 3.14 69/73] locks: eliminate BUG() call when theres an unexpected lock on file close
Date: Fri,  5 Dec 2014 14:45:15 -0800
Message-Id: <20141205224436.004931827@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/locks.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2235,16 +2235,28 @@ void locks_remove_flock(struct file *fil
 
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


