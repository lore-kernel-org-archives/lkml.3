Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaABXLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:11:24 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49017 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaABXLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:11:19 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        =?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] seqlock: Use raw_ prefix instead of _no_lockdep
Date: Thu,  2 Jan 2014 15:11:13 -0800
Message-Id: <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <52C5E675.80701@linaro.org>
References: <52C5E675.80701@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus disliked the _no_lockdep() naming, so instead
use the more-consistent raw_* prefix to the non-lockdep
enabled seqcount methods.

This also adds raw_ methods for the write operations
as well, which will be utilized in a following patch.

Cc: Krzysztof Hałasa <khalasa@piap.pl>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@kernel.org>,
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/x86/vdso/vclock_gettime.c |  8 ++++----
 include/linux/seqlock.h        | 27 +++++++++++++++++++--------
 2 files changed, 23 insertions(+), 12 deletions(-)

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
-- 
1.8.3.2

