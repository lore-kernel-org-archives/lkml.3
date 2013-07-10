Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3GJRMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 13:12:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:47490 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3GJRMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 13:12:41 -0400
Date: Wed, 10 Jul 2013 13:12:13 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH RT 6/6] vtime: Convert vtime_seqlock into
 raw_spinlock_t and seqcount combo
Message-ID: <20130710171212.GA13553@windriver.com>
References: <20130626192806.107564905@goodmis.org>
 <20130626193050.529670718@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130626193050.529670718@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[RFC][PATCH RT 6/6] vtime: Convert vtime_seqlock into raw_spinlock_t and seqcount combo] On 26/06/2013 (Wed 15:28) Steven Rostedt wrote:

> The vtime seqlock needs to be taken in true interrupt context on -rt.
> The normal seqlocks are converted to mutexes when PREEMPT_RT_FULL is
> enabled, which will break the vtime code as the calls are done from
> interrupt context.
> 
> Convert the vtime seqlock into the raw_spinlock_t and seqcount combo
> that can be done in interrupt context.

Alternatively, we could revive the raw seqlock patch from Thomas?

https://lkml.org/lkml/2010/2/17/238

Below is a version updating it to 3.8.x-RT.  One downside is that
current mainline kernels have raw_seqcount_begin() function, which has
nothing to do with preempt-rt, so the seqcount function namespace can
get confusing unless we rename raw_seqcount_begin to something that
doesn't sound RT-ish.

Paul.
--

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 939ea1a..5a3f6fd 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -185,6 +185,11 @@ static inline void write_seqcount_barrier(seqcount_t *s)
 
 typedef struct {
 	struct seqcount seqcount;
+	raw_spinlock_t lock;
+} raw_seqlock_t;
+
+typedef struct {
+	struct seqcount seqcount;
 	spinlock_t lock;
 } seqlock_t;
 
@@ -192,6 +197,21 @@ typedef struct {
  * These macros triggered gcc-3.x compile-time problems.  We think these are
  * OK now.  Be cautious.
  */
+#define __RAW_SEQLOCK_UNLOCKED(lockname)			\
+	{							\
+		.seqcount = SEQCNT_ZERO,			\
+		.lock =	__RAW_SPIN_LOCK_UNLOCKED(lockname)	\
+	}
+
+#define raw_seqlock_init(x)					\
+	do {							\
+		seqcount_init(&(x)->seqcount);			\
+		raw_spin_lock_init(&(x)->lock);			\
+	} while (0)
+
+#define DEFINE_RAW_SEQLOCK(x) \
+		raw_seqlock_t x = __RAW_SEQLOCK_UNLOCKED(x)
+
 #define __SEQLOCK_UNLOCKED(lockname)			\
 	{						\
 		.seqcount = SEQCNT_ZERO,		\
@@ -210,6 +230,11 @@ typedef struct {
 /*
  * Read side functions for starting and finalizing a read side section.
  */
+static inline unsigned read_raw_seqbegin(const raw_seqlock_t *sl)
+{
+	return read_seqcount_begin(&sl->seqcount);
+}
+
 #ifndef CONFIG_PREEMPT_RT_FULL
 static inline unsigned read_seqbegin(const seqlock_t *sl)
 {
@@ -238,6 +263,11 @@ repeat:
 }
 #endif
 
+static inline unsigned read_raw_seqretry(const raw_seqlock_t *sl, unsigned start)
+{
+	return read_seqcount_retry(&sl->seqcount, start);
+}
+
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	return read_seqcount_retry(&sl->seqcount, start);
@@ -248,6 +278,64 @@ static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
  */
+static inline void write_raw_seqlock(raw_seqlock_t *sl)
+{
+	raw_spin_lock(&sl->lock);
+	__write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_raw_sequnlock(raw_seqlock_t *sl)
+{
+	__write_seqcount_end(&sl->seqcount);
+	raw_spin_unlock(&sl->lock);
+}
+
+static inline void write_raw_seqlock_bh(raw_seqlock_t *sl)
+{
+	raw_spin_lock_bh(&sl->lock);
+	__write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_raw_sequnlock_bh(raw_seqlock_t *sl)
+{
+	__write_seqcount_end(&sl->seqcount);
+	raw_spin_unlock_bh(&sl->lock);
+}
+
+static inline void write_raw_seqlock_irq(raw_seqlock_t *sl)
+{
+	raw_spin_lock_irq(&sl->lock);
+	__write_seqcount_begin(&sl->seqcount);
+}
+
+static inline void write_raw_sequnlock_irq(raw_seqlock_t *sl)
+{
+	__write_seqcount_end(&sl->seqcount);
+	raw_spin_unlock_irq(&sl->lock);
+}
+
+static inline unsigned long __write_raw_seqlock_irqsave(raw_seqlock_t *sl)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&sl->lock, flags);
+	__write_seqcount_begin(&sl->seqcount);
+	return flags;
+}
+
+#define write_raw_seqlock_irqsave(lock, flags)				\
+	do { flags = __write_raw_seqlock_irqsave(lock); } while (0)
+
+static inline void
+write_raw_sequnlock_irqrestore(raw_seqlock_t *sl, unsigned long flags)
+{
+	__write_seqcount_end(&sl->seqcount);
+	raw_spin_unlock_irqrestore(&sl->lock, flags);
+}
+
+/*
+ * non raw versions
+ */
 static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
