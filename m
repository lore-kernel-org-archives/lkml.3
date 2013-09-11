Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3IKO3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:29:06 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:29137 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3IKO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:29:04 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 1/2] seqlock: Add a new blocking reader type
Date: Wed, 11 Sep 2013 10:28:26 -0400
Message-Id: <1378909707-3347-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
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
inefficient as a reader is now blocking other non-blocking readers
by pretending to be a writer.

This patch tries to eliminate this inefficiency by introducing a new
type of blocking reader to the seqlock locking mechanism. This new
blocking reader will not block other non-blocking readers, but will
block other blocking readers and writers.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/seqlock.h |   65 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 60 insertions(+), 5 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 1829905..26be0d9 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -3,15 +3,18 @@
 /*
  * Reader/writer consistent mechanism without starving writers. This type of
  * lock for data where the reader wants a consistent set of information
- * and is willing to retry if the information changes.  Readers never
- * block but they may have to retry if a writer is in
- * progress. Writers do not wait for readers. 
+ * and is willing to retry if the information changes. There are two types
+ * of readers:
+ * 1. Non-blocking readers which never block but they may have to retry if
+ *    a writer is in progress. Writers do not wait for non-blocking readers.
+ * 2. Blocking readers which will block if a writer is in progress. A
+ *    blocking reader in progress will also block a writer.
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
@@ -268,4 +271,56 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
 
+/*
+ * The blocking reader lock out other writers, but doesn't update the count.
+ * Acts like a normal spin_lock/unlock.
+ * Don't need preempt_disable() because that is in the spin_lock already.
+ */
+static inline void read_seqlock(seqlock_t *sl)
+{
+	spin_lock(&sl->lock);
+}
+
+static inline void read_sequnlock(seqlock_t *sl)
+{
+	spin_unlock(&sl->lock);
+}
+
+static inline void read_seqlock_bh(seqlock_t *sl)
+{
+	spin_lock_bh(&sl->lock);
+}
+
+static inline void read_sequnlock_bh(seqlock_t *sl)
+{
+	spin_unlock_bh(&sl->lock);
+}
+
+static inline void read_seqlock_irq(seqlock_t *sl)
+{
+	spin_lock_irq(&sl->lock);
+}
+
+static inline void read_sequnlock_irq(seqlock_t *sl)
+{
+	spin_unlock_irq(&sl->lock);
+}
+
+static inline unsigned long __read_seqlock_irqsave(seqlock_t *sl)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sl->lock, flags);
+	return flags;
+}
+
+#define read_seqlock_irqsave(lock, flags)				\
+	do { flags = __read_seqlock_irqsave(lock); } while (0)
+
+static inline void
+read_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
+{
+	spin_unlock_irqrestore(&sl->lock, flags);
+}
+
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.7.1

