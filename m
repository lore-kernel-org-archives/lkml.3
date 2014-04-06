Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaDFXjK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:39:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59432 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754497AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "John Sullivan" <jsrhbz@kanargh.force9.co.uk>,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.322557574@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 04/18] ext4: atomically set inode->i_flags in
 ext4_set_inode_flags()
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 00a1a053ebe5febcfc2ec498bd894f035ad2aa06 upstream.

Use cmpxchg() to atomically set i_flags instead of clearing out the
S_IMMUTABLE, S_APPEND, etc. flags and then setting them from the
EXT4_IMMUTABLE_FL, EXT4_APPEND_FL flags, since this opens up a race
where an immutable file has the immutable flag cleared for a brief
window of time.

Reported-by: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c        | 15 +++++++++------
 include/linux/bitops.h | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -38,6 +38,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/bitops.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -3694,18 +3695,20 @@ int ext4_get_inode_loc(struct inode *ino
 void ext4_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = EXT4_I(inode)->i_flags;
+	unsigned int new_fl = 0;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
 	if (flags & EXT4_SYNC_FL)
-		inode->i_flags |= S_SYNC;
+		new_fl |= S_SYNC;
 	if (flags & EXT4_APPEND_FL)
-		inode->i_flags |= S_APPEND;
+		new_fl |= S_APPEND;
 	if (flags & EXT4_IMMUTABLE_FL)
-		inode->i_flags |= S_IMMUTABLE;
+		new_fl |= S_IMMUTABLE;
 	if (flags & EXT4_NOATIME_FL)
-		inode->i_flags |= S_NOATIME;
+		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
-		inode->i_flags |= S_DIRSYNC;
+		new_fl |= S_DIRSYNC;
+	set_mask_bits(&inode->i_flags,
+		      S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC, new_fl);
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -168,6 +168,21 @@ static inline unsigned long __ffs64(u64
 
 #ifdef __KERNEL__
 
+#ifndef set_mask_bits
+#define set_mask_bits(ptr, _mask, _bits)	\
+({								\
+	const typeof(*ptr) mask = (_mask), bits = (_bits);	\
+	typeof(*ptr) old, new;					\
+								\
+	do {							\
+		old = ACCESS_ONCE(*ptr);			\
+		new = (old & ~mask) | bits;			\
+	} while (cmpxchg(ptr, old, new) != old);		\
+								\
+	new;							\
+})
+#endif
+
 #ifndef find_last_bit
 /**
  * find_last_bit - find the last set bit in a memory region

