Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab3GDBxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 21:53:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:26756 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407Ab3GDBwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 21:52:53 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH 3/4] seqlock: Allow the use of rwlock in seqlock
Date: Wed,  3 Jul 2013 21:52:17 -0400
Message-Id: <1372902738-30693-4-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
References: <1372902738-30693-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the use cases where there are much more blocking readers than
writers, it will be beneficial performance-wise to use read/write lock
instead of a spinlock. However, read/write lock is non-deterministic
and can be problematic in some situations. So a complete conversion
of the underlying lock in seqlock to read/write lock will not be
appropriate.

This patch allows a seqlock user to decide to use either spinlock or
read/write lock as the underlying lock at initialization time. Once
the decision is made, it cannot be changed at a later time. To use an
underlying read/write lock, either the seqrwlock_init() function or
the DEFINE_SEQRWLOCK() macro have to be used at initialization time.
There is a slight overhead of an additional conditional branch with
that change, but it should be insignificant when compared with the
overhead of the actual locking and unlocking operations.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 include/linux/seqlock.h |  118 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 92 insertions(+), 26 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 26be0d9..a1fd45c 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -20,7 +20,6 @@
  * 	...
  *      } while (read_seqretry(&foo, seq));
  *
- *
  * On non-SMP the spin locks disappear but the writer still needs
  * to increment the sequence variables because an interrupt routine could
  * change the state of the data.
@@ -176,28 +175,51 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 
 typedef struct {
 	struct seqcount seqcount;
-	spinlock_t lock;
+	const bool use_rwlock;
+	union {
+		spinlock_t slock;
+		rwlock_t rwlock;
+	};
 } seqlock_t;
 
 /*
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
  */
-#define __SEQLOCK_UNLOCKED(lockname)			\
-	{						\
-		.seqcount = SEQCNT_ZERO,		\
-		.lock =	__SPIN_LOCK_UNLOCKED(lockname)	\
+#define __SEQLOCK_UNLOCKED(lockname)				\
+	{							\
+		.seqcount = SEQCNT_ZERO,			\
+		.use_rwlock = false,				\
+		{ .slock = __SPIN_LOCK_UNLOCKED(lockname) }	\
+	}
+
+#define __SEQRWLOCK_UNLOCKED(lockname)				\
+	{							\
+		.seqcount = SEQCNT_ZERO,			\
+		.use_rwlock = true,				\
+		{ .rwlock = __RW_LOCK_UNLOCKED(lockname) }	\
 	}
 
-#define seqlock_init(x)					\
-	do {						\
-		seqcount_init(&(x)->seqcount);		\
-		spin_lock_init(&(x)->lock);		\
+#define seqlock_init(x)						\
+	do {							\
+		seqcount_init(&(x)->seqcount);			\
+		spin_lock_init(&(x)->slock);			\
+		*(bool *)(&(x)->use_rwlock) = false;		\
+	} while (0)
+
+#define seqrwlock_init(x)					\
+	do {							\
+		seqcount_init(&(x)->seqcount);			\
+		rwlock_init(&(x)->rwlock);			\
+		*(bool *)(&(x)->use_rwlock) = true;		\
 	} while (0)
 
 #define DEFINE_SEQLOCK(x) \
 		seqlock_t x = __SEQLOCK_UNLOCKED(x)
 
+#define DEFINE_SEQRWLOCK(x) \
+		seqlock_t x = __SEQRWLOCK_UNLOCKED(x)
+
 /*
  * Read side functions for starting and finalizing a read side section.
  */
@@ -212,51 +234,86 @@ static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 }
 
 /*
+ * Locking and unlocking macros
+ */
+#define	__SEQRLOCK(sl, suffix)					\
+	do {							\
+		if ((sl)->use_rwlock)				\
+			read_lock ## suffix(&(sl)->rwlock);	\
+		else						\
+			spin_lock ## suffix(&(sl)->slock);	\
+	} while (0)
+#define	__SEQWLOCK(sl, suffix)					\
+	do {							\
+		if ((sl)->use_rwlock)				\
+			write_lock ## suffix(&(sl)->rwlock);	\
+		else						\
+			spin_lock ## suffix(&(sl)->slock);	\
+	} while (0)
+#define	__SEQRUNLOCK(sl, suffix)				\
+	do {							\
+		if ((sl)->use_rwlock)				\
+			read_unlock ## suffix(&(sl)->rwlock);	\
+		else						\
+			spin_unlock ## suffix(&(sl)->slock);	\
+	} while (0)
+#define	__SEQWUNLOCK(sl, suffix)				\
+	do {							\
+		if ((sl)->use_rwlock)				\
+			write_unlock ## suffix(&(sl)->rwlock);	\
+		else						\
+			spin_unlock ## suffix(&(sl)->slock);	\
+	} while (0)
+
+/*
  * Lock out other writers and update the count.
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
  */
 static inline void write_seqlock(seqlock_t *sl)
 {
-	spin_lock(&sl->lock);
+	__SEQWLOCK(sl, /**/);
 	write_seqcount_begin(&sl->seqcount);
 }
 
 static inline void write_sequnlock(seqlock_t *sl)
 {
 	write_seqcount_end(&sl->seqcount);
-	spin_unlock(&sl->lock);
+	__SEQWUNLOCK(sl, /**/);
 }
 
 static inline void write_seqlock_bh(seqlock_t *sl)
 {
-	spin_lock_bh(&sl->lock);
+	__SEQWLOCK(sl, _bh);
 	write_seqcount_begin(&sl->seqcount);
 }
 
 static inline void write_sequnlock_bh(seqlock_t *sl)
 {
 	write_seqcount_end(&sl->seqcount);
-	spin_unlock_bh(&sl->lock);
+	__SEQWUNLOCK(sl, _bh);
 }
 
 static inline void write_seqlock_irq(seqlock_t *sl)
 {
-	spin_lock_irq(&sl->lock);
+	__SEQWLOCK(sl, _irq);
 	write_seqcount_begin(&sl->seqcount);
 }
 
 static inline void write_sequnlock_irq(seqlock_t *sl)
 {
 	write_seqcount_end(&sl->seqcount);
-	spin_unlock_irq(&sl->lock);
+	__SEQWUNLOCK(sl, _irq);
 }
 
 static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sl->lock, flags);
+	if (sl->use_rwlock)
+		write_lock_irqsave(&sl->rwlock, flags);
+	else
+		spin_lock_irqsave(&sl->slock, flags);
 	write_seqcount_begin(&sl->seqcount);
 	return flags;
 }
@@ -268,7 +325,10 @@ static inline void
 write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
 {
 	write_seqcount_end(&sl->seqcount);
-	spin_unlock_irqrestore(&sl->lock, flags);
+	if (sl->use_rwlock)
+		write_unlock_irqrestore(&sl->rwlock, flags);
+	else
+		spin_unlock_irqrestore(&sl->slock, flags);
 }
 
 /*
@@ -278,39 +338,42 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
  */
 static inline void read_seqlock(seqlock_t *sl)
 {
-	spin_lock(&sl->lock);
+	__SEQRLOCK(sl, /**/);
 }
 
 static inline void read_sequnlock(seqlock_t *sl)
 {
-	spin_unlock(&sl->lock);
+	__SEQRUNLOCK(sl, /**/);
 }
 
 static inline void read_seqlock_bh(seqlock_t *sl)
 {
-	spin_lock_bh(&sl->lock);
+	__SEQRLOCK(sl, _bh);
 }
 
 static inline void read_sequnlock_bh(seqlock_t *sl)
 {
-	spin_unlock_bh(&sl->lock);
+	__SEQRUNLOCK(sl, _bh);
 }
 
 static inline void read_seqlock_irq(seqlock_t *sl)
 {
-	spin_lock_irq(&sl->lock);
+	__SEQRLOCK(sl, _irq);
 }
 
 static inline void read_sequnlock_irq(seqlock_t *sl)
 {
-	spin_unlock_irq(&sl->lock);
+	__SEQRUNLOCK(sl, _irq);
 }
 
 static inline unsigned long __read_seqlock_irqsave(seqlock_t *sl)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&sl->lock, flags);
+	if (sl->use_rwlock)
+		read_lock_irqsave(&sl->rwlock, flags);
+	else
+		spin_lock_irqsave(&sl->slock, flags);
 	return flags;
 }
 
@@ -320,7 +383,10 @@ static inline unsigned long __read_seqlock_irqsave(seqlock_t *sl)
 static inline void
 read_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
 {
-	spin_unlock_irqrestore(&sl->lock, flags);
+	if (sl->use_rwlock)
+		read_unlock_irqrestore(&sl->rwlock, flags);
+	else
+		spin_unlock_irqrestore(&sl->slock, flags);
 }
 
 #endif /* __LINUX_SEQLOCK_H */
-- 
1.7.1

