Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaALSrS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:47:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46238 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaALSne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:43:34 -0500
Date: Sun, 12 Jan 2014 10:42:26 -0800
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-0c3351d451ae2fa438d5d1ed719fc43354fbffbb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, john.stultz@linaro.org, w@1wt.eu,
        khalasa@piap.pl, u.kleine-koenig@pengutronix.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, john.stultz@linaro.org, w@1wt.eu,
        khalasa@piap.pl, tglx@linutronix.de, u.kleine-koenig@pengutronix.de
In-Reply-To: <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
References: <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] seqlock: Use raw_ prefix instead of _no_lockdep
Git-Commit-ID: 0c3351d451ae2fa438d5d1ed719fc43354fbffbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:42:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c3351d451ae2fa438d5d1ed719fc43354fbffbb
Gitweb:     http://git.kernel.org/tip/0c3351d451ae2fa438d5d1ed719fc43354fbffbb
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Thu, 2 Jan 2014 15:11:13 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:13:59 +0100

seqlock: Use raw_ prefix instead of _no_lockdep

Linus disliked the _no_lockdep() naming, so instead
use the more-consistent raw_* prefix to the non-lockdep
enabled seqcount methods.

This also adds raw_ methods for the write operations
as well, which will be utilized in a following patch.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Krzysztof Hałasa <khalasa@piap.pl>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Willy Tarreau <w@1wt.eu>
Link: http://lkml.kernel.org/r/1388704274-5278-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
