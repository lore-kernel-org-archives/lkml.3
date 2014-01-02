Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaABVzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:55:00 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56706 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaABVy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:54:57 -0500
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
Subject: [PATCH] sched_clock: Disable seqlock lockdep usage in sched_clock
Date: Thu,  2 Jan 2014 13:54:46 -0800
Message-Id: <1388699686-4834-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <52C5DB5B.9050604@linaro.org>
References: <52C5DB5B.9050604@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unforunately the seqlock lockdep enablmenet can't be used
in sched_clock, since the lockdep infrastructure eventually
calls into sched_clock, which causes a deadlock.

Thus, this patch adds _no_lockdep() seqlock methods for the
writer side, and changes all generic sched_clock usage to use
the _no_lockdep methods.

This solves the issue I was able to reproduce, but it would
be good to get Krzysztof to confirm it solves his problem.

Cc: Krzysztof Hałasa <khalasa@piap.pl>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@kernel.org>,
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org
Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/seqlock.h   | 19 +++++++++++++++----
 kernel/time/sched_clock.c |  6 +++---
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index cf87a24..7664f68 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -206,14 +206,26 @@ static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 }
 
 
+
+static inline void write_seqcount_begin_no_lockdep(seqcount_t *s)
+{
+	s->sequence++;
+	smp_wmb();
+}
+
+static inline void write_seqcount_end_no_lockdep(seqcount_t *s)
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
+	write_seqcount_begin_no_lockdep(s);
 	seqcount_acquire(&s->dep_map, subclass, 0, _RET_IP_);
 }
 
@@ -225,8 +237,7 @@ static inline void write_seqcount_begin(seqcount_t *s)
 static inline void write_seqcount_end(seqcount_t *s)
 {
 	seqcount_release(&s->dep_map, 1, _RET_IP_);
-	smp_wmb();
-	s->sequence++;
+	write_seqcount_end_no_lockdep(s);
 }
 
 /**
diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
index 68b7993..13561a0 100644
--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -74,7 +74,7 @@ unsigned long long notrace sched_clock(void)
 		return cd.epoch_ns;
 
 	do {
-		seq = read_seqcount_begin(&cd.seq);
+		seq = read_seqcount_begin_no_lockdep(&cd.seq);
 		epoch_cyc = cd.epoch_cyc;
 		epoch_ns = cd.epoch_ns;
 	} while (read_seqcount_retry(&cd.seq, seq));
@@ -99,10 +99,10 @@ static void notrace update_sched_clock(void)
 			  cd.mult, cd.shift);
 
 	raw_local_irq_save(flags);
-	write_seqcount_begin(&cd.seq);
+	write_seqcount_begin_no_lockdep(&cd.seq);
 	cd.epoch_ns = ns;
 	cd.epoch_cyc = cyc;
-	write_seqcount_end(&cd.seq);
+	write_seqcount_end_no_lockdep(&cd.seq);
 	raw_local_irq_restore(flags);
 }
 
-- 
1.8.3.2

