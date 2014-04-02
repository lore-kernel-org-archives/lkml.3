Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713AbaDBRrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:47:45 -0400
Received: from imap.thunk.org ([74.207.234.97]:49200 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932541AbaDBRro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:47:44 -0400
Date: Wed, 2 Apr 2014 13:47:07 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>, jfs-discussion@lists.sourceforge.net
Subject: Re: [PATCH 1/1] fs/jfs/jfs_inode.c: atomically set inode->i_flags
Message-ID: <20140402174707.GK6901@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fabian Frederick <fabf@skynet.be>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>,
	jfs-discussion@lists.sourceforge.net
References: <20140402192950.82812a331cb154bbc0a4183c@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402192950.82812a331cb154bbc0a4183c@skynet.be>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 07:29:50PM +0200, Fabian Frederick wrote:
> +	set_mask_bits(&inode->i_flags, S_IMMUTABLE | S_APPEND | S_NOATIME |
> +				       S_DIRSYNC | S_SYNC, new_fl);

Warning --- per discussion with Linus over the weekend, he decided he
really didn't like the set_mask_bits() interface, because it was too
prone to abuse.  Unfortuantely, Linus had already included an earlier
version of my patch that used set_mask_bits() in 3.14 without letting
me know.  This is what I have in my ext4 tree for the merge window,
which is undergoing final testing at the moment.  This will cause a
patch conflict, and it's likely (given Linus's dislike of the
set_mask_bits interface) that set_mask_bits() will end up getting
removed from the tree, if not when he fixes up the merge conflict, but
subsequent to -rc1.

							- Ted


ext4: atomically set inode->i_flags in ext4_set_inode_flags()

Use cmpxchg() to atomically set i_flags instead of clearing out the
S_IMMUTABLE, S_APPEND, etc. flags and then setting them from the
EXT4_IMMUTABLE_FL, EXT4_APPEND_FL flags, since this opens up a race
where an immutable file has the immutable flag cleared for a brief
window of time.

Reported-by: John Sullivan <jsrhbz@kanargh.force9.co.uk>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/ext4/inode.c    | 14 ++++++++------
 fs/inode.c         | 31 +++++++++++++++++++++++++++++++
 include/linux/fs.h |  3 +++
 3 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b5e182a..df067c3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3938,18 +3938,20 @@ int ext4_get_inode_loc(struct inode *inode, struct ext4_iloc *iloc)
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
+	inode_set_flags(inode, new_fl,
+			S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
 }
 
 /* Propagate flags from i_flags to EXT4_I(inode)->i_flags */
diff --git a/fs/inode.c b/fs/inode.c
index 4bcdad3..26f95ce 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1899,3 +1899,34 @@ void inode_dio_done(struct inode *inode)
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
index 6082956..5d1f6fa 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2556,6 +2556,9 @@ static inline ssize_t blockdev_direct_IO(int rw, struct kiocb *iocb,
 void inode_dio_wait(struct inode *inode);
 void inode_dio_done(struct inode *inode);
 
+extern void inode_set_flags(struct inode *inode, unsigned int flags,
+			    unsigned int mask);
+
 extern const struct file_operations generic_ro_fops;
 
 #define special_file(m) (S_ISCHR(m)||S_ISBLK(m)||S_ISFIFO(m)||S_ISSOCK(m))
