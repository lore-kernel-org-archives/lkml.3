Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab3ILO4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:56:07 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:3164 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3ILO4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:56:01 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 1/2 v2] seqlock: Add a new locking reader type
Date: Thu, 12 Sep 2013 10:55:34 -0400
Message-Id: <1378997735-22844-2-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sequence lock (seqlock) was originally designed for the cases
where the readers do not need to block the writers by making the
readers retry the read operation when the data change.

Since then, the use cases have been expanded to include situations
where a thread does not need to change the data (effectively a reader)
at all but have to take the writer lock because it can't tolerate
changes to the protected structure. Some examples are the d_path()
function and the getcwd() syscall in fs/dcache.c where the functions
take the writer lock on rename_lock even though they don't need
to change anything in the protected data structure at all. This is
inefficient as a reader is now blocking other sequence number reading
readers from moving forward by pretending to be a writer.

This patch tries to eliminate this inefficiency by introducing a new
type of locking reader to the seqlock locking mechanism. This new
locking reader will try to take an exclusive lock preventing other
writers and locking readers from going forward. However, it won't
affect the progress of the other sequence number reading readers as
the sequence number won't be changed.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/seqlock.h |   68 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1829905..9bd84b5 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -3,15 +3,21 @@
 /*
  * Reader/writer consistent mechanism without starving writers. This type of
  * lock for data where the reader wants a consistent set of information
- * and is willing to retry if the information changes.  Readers never
- * block but they may have to retry if a writer is in
- * progress. Writers do not wait for readers. 
+ * and is willing to retry if the information changes. There are two types
+ * of readers:
+ * 1. Sequence readers which never block a writer but they may have to retry
+ *    if a writer is in progress by detecting change in sequence number.
+ *    Writers do not wait for a sequence reader.
+ * 2. Locking readers which will wait if a writer or another locking reader
+ *    is in progress. A locking reader in progress will also block a writer
+ *    from going forward. Unlike the regular rwlock, the read lock here is
+ *    exclusive so that only one locking reader can get it.
  *
- * This is not as cache friendly as brlock. Also, this will not work
+ * This is not as cache friendly as brlock. Also, this may not work well
  * for data that contains pointers, because any writer could
  * invalidate a pointer that a reader was following.
  *
- * Expected reader usage:
+ * Expected non-blocking reader usage:
  * 	do {
  *	    seq = read_seqbegin(&foo);
  * 	...
@@ -268,4 +274,56 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+/*
+ * A locking reader exclusively locks out other writers and locking readers,
+ * but doesn't update the sequence number. Acts like a normal spin_lock/unlock.
+ * Don't need preempt_disable() because that is in the spin_lock already.
+ */
+static inline void read_seqexcl_lock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+}
+
+static inline void read_seqexcl_unlock(seqlock_t *sl)
+{
+	spin_unlock(&sl->lock);
+}
+
+static inline void read_seqexcl_lock_bh(seqlock_t *sl)
+{
+	spin_lock_bh(&sl->lock);
+}
+
+static inline void read_seqexcl_unlock_bh(seqlock_t *sl)
+{
+	spin_unlock_bh(&sl->lock);
+}
+
+static inline void read_seqexcl_lock_irq(seqlock_t *sl)
+{
+	spin_lock_irq(&sl->lock);
+}
+
+static inline void read_seqexcl_unlock_irq(seqlock_t *sl)
+{
+	spin_unlock_irq(&sl->lock);
+}
+
+static inline unsigned long __read_seqexcl_lock_irqsave(seqlock_t *sl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sl->lock, flags);
+	return flags;
+}
+
+#define read_seqexcl_lock_irqsave(lock, flags)				\
+	do { flags = __read_seqexcl_lock_irqsave(lock); } while (0)
+
+static inline void
+read_seqexcl_unlock_irqrestore(seqlock_t *sl, unsigned long flags)
+{
+	spin_unlock_irqrestore(&sl->lock, flags);
+}
+
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.7.1

