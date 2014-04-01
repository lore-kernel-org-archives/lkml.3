Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbaDAQP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:15:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44641 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbaDAQPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:15:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 85/86] ext4: atomically set inode->i_flags in ext4_set_inode_flags()
Date: Tue,  1 Apr 2014 09:08:38 -0700
Message-Id: <1396368519-12728-86-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396368519-12728-1-git-send-email-kamal@canonical.com>
References: <1396368519-12728-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.21 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/inode.c        | 15 +++++++++------
 include/linux/bitops.h | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 46c10b5..8aed7eb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -37,6 +37,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/bitops.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -3770,18 +3771,20 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
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
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..c1dde8e 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -185,6 +185,21 @@ static inline unsigned long __ffs64(u64 word)
 
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
-- 
1.8.3.2

