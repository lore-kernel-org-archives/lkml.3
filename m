Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaAOSP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 13:15:28 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52148 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaAOSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 13:15:23 -0500
Date: Wed, 15 Jan 2014 19:15:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] locking fixes
Message-ID: <20140115181519.GA21063@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   # HEAD: 7a06c41cbec33c6dbe7eec575c61986122617408 sched_clock: Disable seqlock lockdep usage in sched_clock()

Two fixes from lockdep coverage of seqlocks, which fix deadlocks on 
lockdep-enabled ARM systems.

 Thanks,

	Ingo

------------------>
John Stultz (2):
      seqlock: Use raw_ prefix instead of _no_lockdep
      sched_clock: Disable seqlock lockdep usage in sched_clock()


 arch/x86/vdso/vclock_gettime.c |  8 ++++----
 include/linux/seqlock.h        | 27 +++++++++++++++++++--------
 kernel/time/sched_clock.c      |  6 +++---
 3 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index 2ada505..eb5d7a5 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -178,7 +178,7 @@ notrace static int __always_inline do_realtime(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	do {
-		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->wall_time_sec;
 		ns = gtod->wall_time_snsec;
@@ -198,7 +198,7 @@ notrace static int do_monotonic(struct timespec *ts)
 
 	ts->tv_nsec = 0;
 	do {
-		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		mode = gtod->clock.vclock_mode;
 		ts->tv_sec = gtod->monotonic_time_sec;
 		ns = gtod->monotonic_time_snsec;
@@ -214,7 +214,7 @@ notrace static int do_realtime_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
@@ -225,7 +225,7 @@ notrace static int do_monotonic_coarse(struct timespec *ts)
 {
 	unsigned long seq;
 	do {
-		seq = read_seqcount_begin_no_lockdep(&gtod->seq);
+		seq = raw_read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->monotonic_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->monotonic_time_coarse.tv_nsec;
 	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index cf87a24..535f158 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -117,15 +117,15 @@ repeat:
 }
 
 /**
- * read_seqcount_begin_no_lockdep - start seq-read critical section w/o lockdep
+ * raw_read_seqcount_begin - start seq-read critical section w/o lockdep
  * @s: pointer to seqcount_t
  * Returns: count to be passed to read_seqcount_retry
  *
- * read_seqcount_begin_no_lockdep opens a read critical section of the given
+ * raw_read_seqcount_begin opens a read critical section of the given
  * seqcount, but without any lockdep checking. Validity of the critical
  * section is tested by checking read_seqcount_retry function.
  */
-static inline unsigned read_seqcount_begin_no_lockdep(const seqcount_t *s)
+static inline unsigned raw_read_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = __read_seqcount_begin(s);
 	smp_rmb();
@@ -144,7 +144,7 @@ static inline unsigned read_seqcount_begin_no_lockdep(const seqcount_t *s)
 static inline unsigned read_seqcount_begin(const seqcount_t *s)
 {
 	seqcount_lockdep_reader_access(s);
-	return read_seqcount_begin_no_lockdep(s);
+	return raw_read_seqcount_begin(s);
 }
 
 /**
@@ -206,14 +206,26 @@ static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 }
 
 
+
+static inline void raw_write_seqcount_begin(seqcount_t *s)
+{
+	s->sequence++;
+	smp_wmb();
+}
+
+static inline void raw_write_seqcount_end(seqcount_t *s)
+{
+	smp_wmb();
+	s->sequence++;
+}
+
 /*
  * Sequence counter only version assumes that callers are using their
  * own mutexing.
  */
 static inline void write_seqcount_begin_nested(seqcount_t *s, int subclass)
 {
-	s->sequence++;
-	smp_wmb();
+	raw_write_seqcount_begin(s);
 	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
 }
 
@@ -225,8 +237,7 @@ static inline void write_seqcount_begin(seqcount_t *s)
 static inline void write_seqcount_end(seqcount_t *s)
 {
 	seqcount_release(&s->dep_map, 1, _RET_IP_);
-	smp_wmb();
-	s->sequence++;
+	raw_write_seqcount_end(s);
 }
 
 /**
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 68b7993..0abb364 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -74,7 +74,7 @@ unsigned long long notrace sched_clock(void)
 		return cd.epoch_ns;
 
 	do {
-		seq = read_seqcount_begin(&cd.seq);
+		seq = raw_read_seqcount_begin(&cd.seq);
 		epoch_cyc = cd.epoch_cyc;
 		epoch_ns = cd.epoch_ns;
 	} while (read_seqcount_retry(&cd.seq, seq));
@@ -99,10 +99,10 @@ static void notrace update_sched_clock(void)
 			  cd.mult, cd.shift);
 
 	raw_local_irq_save(flags);
-	write_seqcount_begin(&cd.seq);
+	raw_write_seqcount_begin(&cd.seq);
 	cd.epoch_ns = ns;
 	cd.epoch_cyc = cyc;
-	write_seqcount_end(&cd.seq);
+	raw_write_seqcount_end(&cd.seq);
 	raw_local_irq_restore(flags);
 }
 
