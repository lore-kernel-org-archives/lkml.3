Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaLCL3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:29:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbaLCL1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:48 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        stable@kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 099/101] ext4: atomically set inode->i_flags in ext4_set_inode_flags()
Date: Wed,  3 Dec 2014 12:27:01 +0100
Message-Id: <ec81c28104fd2198f076203be3d1bae5546e863f.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5f16f3225b06242a9ee876f07c1c9b6ed36a22b6 upstream.

Use cmpxchg() to atomically set i_flags instead of clearing out the
S_IMMUTABLE, S_APPEND, etc. flags and then setting them from the
EXT4_IMMUTABLE_FL, EXT4_APPEND_FL flags, since this opens up a race
where an immutable file has the immutable flag cleared for a brief
window of time.

js: there is no change for ext4. This patch defines merely
    inode_set_flags for jffs in the next patch. I wonder why do we
    have both inode_set_flags and set_mask_bits? Looks like an
    improperly resolved merge conflict.

Reported-by: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/ext4/inode.c    |  4 ++--
 fs/inode.c         | 31 +++++++++++++++++++++++++++++++
 include/linux/fs.h |  3 +++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a58a796bb92b..ba68d211d748 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3970,8 +3970,8 @@ void ext4_set_inode_flags(struct inode *inode)
 		new_fl |= S_NOATIME;
 	if (flags & EXT4_DIRSYNC_FL)
 		new_fl |= S_DIRSYNC;
-	set_mask_bits(&inode->i_flags,
-		      S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC, new_fl);
+	inode_set_flags(inode, new_fl,
+			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
diff --git a/fs/inode.c b/fs/inode.c
index 1e6e8468f2d8..d9134a0f5dd9 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1871,3 +1871,34 @@ void inode_dio_done(struct inode *inode)
 		wake_up_bit(&inode->i_state, __I_DIO_WAKEUP);
 }
 EXPORT_SYMBOL(inode_dio_done);
+
+/*
+ * inode_set_flags - atomically set some inode flags
+ *
+ * Note: the caller should be holding i_mutex, or else be sure that
+ * they have exclusive access to the inode structure (i.e., while the
+ * inode is being instantiated).  The reason for the cmpxchg() loop
+ * --- which wouldn't be necessary if all code paths which modify
+ * i_flags actually followed this rule, is that there is at least one
+ * code path which doesn't today --- for example,
+ * __generic_file_aio_write() calls file_remove_suid() without holding
+ * i_mutex --- so we use cmpxchg() out of an abundance of caution.
+ *
+ * In the long run, i_mutex is overkill, and we should probably look
+ * at using the i_lock spinlock to protect i_flags, and then make sure
+ * it is so documented in include/linux/fs.h and that all code follows
+ * the locking convention!!
+ */
+void inode_set_flags(struct inode *inode, unsigned int flags,
+		     unsigned int mask)
+{
+	unsigned int old_flags, new_flags;
+
+	WARN_ON_ONCE(flags & ~mask);
+	do {
+		old_flags = ACCESS_ONCE(inode->i_flags);
+		new_flags = (old_flags & ~mask) | flags;
+	} while (unlikely(cmpxchg(&inode->i_flags, old_flags,
+				  new_flags) != old_flags));
+}
+EXPORT_SYMBOL(inode_set_flags);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6535d5af027e..9cb726aa09fc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2496,6 +2496,9 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 void inode_dio_wait(struct inode *inode);
 void inode_dio_done(struct inode *inode);
 
+extern void inode_set_flags(struct inode *inode, unsigned int flags,
+			    unsigned int mask);
+
 extern const struct file_operations generic_ro_fops;
 
 #define special_file(m) (S_ISCHR(m)||S_ISBLK(m)||S_ISFIFO(m)||S_ISSOCK(m))
-- 
2.1.3

