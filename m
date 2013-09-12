Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3ILO4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:56:06 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3167 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab3ILO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:56:01 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 2/2 v2] dcache: get/release read lock in read_seqbegin_or_lock() & friend
Date: Thu, 12 Sep 2013 10:55:35 -0400
Message-Id: <1378997735-22844-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies read_seqbegin_or_lock() and need_seqretry() to
use newly introduced read_seqexcl_lock() and read_seqexcl_unlock()
primitives so that they won't change the sequence number even if
they fall back to take the lock.  This is OK as no change to the
protected data structure is being made. It will prevent one fallback
to lock taking from cascading into a series of lock taking reducing
performance because of the sequence number change. It will also allow
other sequence readers to go forward while an exclusive reader lock
is taken.

This patch also updates some of the inaccurate comments in the code.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 fs/dcache.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 4d9df3c..9e88367 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -90,8 +90,8 @@ static struct kmem_cache *dentry_cache __read_mostly;
 
 /**
  * read_seqbegin_or_lock - begin a sequence number check or locking block
- * lock: sequence lock
- * seq : sequence number to be checked
+ * @lock: sequence lock
+ * @seq : sequence number to be checked
  *
  * First try it once optimistically without taking the lock. If that fails,
  * take the lock. The sequence number is also used as a marker for deciding
@@ -103,7 +103,7 @@ static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
 	if (!(*seq & 1))	/* Even */
 		*seq = read_seqbegin(lock);
 	else			/* Odd */
-		write_seqlock(lock);
+		read_seqexcl_lock(lock);
 }
 
 static inline int need_seqretry(seqlock_t *lock, int seq)
@@ -114,7 +114,7 @@ static inline int need_seqretry(seqlock_t *lock, int seq)
 static inline void done_seqretry(seqlock_t *lock, int seq)
 {
 	if (seq & 1)
-		write_sequnlock(lock);
+		read_seqexcl_unlock(lock);
 }
 
 /*
@@ -2673,9 +2673,9 @@ static int prepend(char **buffer, int *buflen, const char *str, int namelen)
 
 /**
  * prepend_name - prepend a pathname in front of current buffer pointer
- * buffer: buffer pointer
- * buflen: allocated length of the buffer
- * name:   name string and length qstr structure
+ * @buffer: buffer pointer
+ * @buflen: allocated length of the buffer
+ * @name:   name string and length qstr structure
  *
  * With RCU path tracing, it may race with d_move(). Use ACCESS_ONCE() to
  * make sure that either the old or the new name pointer and length are
@@ -2713,14 +2713,15 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * @buffer: pointer to the end of the buffer
  * @buflen: pointer to buffer length
  *
- * The function tries to write out the pathname without taking any lock other
- * than the RCU read lock to make sure that dentries won't go away. It only
- * checks the sequence number of the global rename_lock as any change in the
- * dentry's d_seq will be preceded by changes in the rename_lock sequence
- * number. If the sequence number had been change, it will restart the whole
- * pathname back-tracing sequence again. It performs a total of 3 trials of
- * lockless back-tracing sequences before falling back to take the
- * rename_lock.
+ * The function will first try to write out the pathname without taking any
+ * lock other than the RCU read lock to make sure that dentries won't go away.
+ * It only checks the sequence number of the global rename_lock as any change
+ * in the dentry's d_seq will be preceded by changes in the rename_lock
+ * sequence number. If the sequence number had been changed, it will restart
+ * the whole pathname back-tracing sequence again by taking the rename_lock.
+ * In this case, there is no need to take the RCU read lock as the recursive
+ * parent pointer references will keep the dentry chain alive as long as no
+ * rename operation is performed.
  */
 static int prepend_path(const struct path *path,
 			const struct path *root,
-- 
1.7.1

