Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaGLWWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 18:22:20 -0400
Received: from mail.efficios.com ([78.47.125.74]:37749 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaGLWWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 18:22:19 -0400
X-Greylist: delayed 435 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jul 2014 18:22:18 EDT
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] timekeeping: Fix missing memory barriers in NMI safe CLOCK_MONOTONIC[_RAW]
Date: Sat, 12 Jul 2014 18:14:44 -0400
Message-Id: <1405203284-12159-1-git-send-email-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c7b080e148d9 "timekeeping: Provide fast and NMI safe access to
CLOCK_MONOTONIC[_RAW]" lacks memory barriers.

The following scenario demonstrates a race condition where the reader
can see a corrupted clock value.

Initial conditions:

tkf->seq = 0
tkf->base[0] and tkf->base[1] are initialized.

CPU 0                                      CPU 1
------------                               ----------------
update:
  tkf->seq++
  smb_wmb()
  tkf->seq++ (reordered before update)
                                           reader:
                                             seq = tkf->seq (reads 2)
                                             smp_rmb()
                                             idx = seq & 0x01
                                             now = now(tkf->base[idx]
                                                    # reads base[0]
  update(tkf->base[0], tk)
       # racy concurrent update
                                             smp_rmb()
                                             while (seq != tkf->seq)
                                                    # they are equal
 [ update continues ... ]

In this situation, the reader returns a corrupted value. Adding a
smp_wmb() between update of base[0] and increment of seq, as well as
between update of base[1] and the _following_ increment of seq (next
update call) fixes this.

Introduce raw_write_seqcount_latch() to abstract those barriers rather
than open-coding them in update_fast_timekeeper().

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1407122145580.4357@nanos
Fixes: c7b080e148d9 "timekeeping: Provide fast and NMI safe access to CLOCK_MONOTONIC[_RAW]"
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/seqlock.h   |   11 +++++++++++
 kernel/time/timekeeping.c |    4 ++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index dcc64b9..c18adee 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -236,6 +236,17 @@ static inline void raw_write_seqcount_end(seqcount_t *s)
 }
 
 /*
+ * raw_write_seqcount_latch - redirect readers to even/odd copy
+ * @s: pointer to seqcount_t
+ */
+static inline void raw_write_seqcount_latch(seqcount_t *s)
+{
+	smp_wmb();	/* prior stores before incrementing "sequence" */
+	s->sequence++;
+	smp_wmb();	/* increment "sequence" before following stores */
+}
+
+/*
  * Sequence counter only version assumes that callers are using their
  * own mutexing.
  */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 47d2caf..2bd73b0 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -317,7 +317,7 @@ static void update_fast_timekeeper(struct clocksource *clk, struct tk_fast *tkf,
 	struct tk_fast_base *base = tkf->base;
 
 	/* Force readers off to base[1] */
-	raw_write_seqcount_begin(&tkf->seq);
+	raw_write_seqcount_latch(&tkf->seq);
 
 	/* Update base[0] */
 	base->clock = clk;
@@ -327,7 +327,7 @@ static void update_fast_timekeeper(struct clocksource *clk, struct tk_fast *tkf,
 	base->mult = mult;
 
 	/* Force readers back to base[0] */
-	raw_write_seqcount_end(&tkf->seq);
+	raw_write_seqcount_latch(&tkf->seq);
 
 	/* Update base[1] */
 	base++;
-- 
1.7.10.4

