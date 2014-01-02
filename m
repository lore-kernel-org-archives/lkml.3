Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaABXL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 18:11:26 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60798 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABXLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 18:11:20 -0500
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
Subject: [PATCH 2/2] sched_clock: Disable seqlock lockdep usage in sched_clock
Date: Thu,  2 Jan 2014 15:11:14 -0800
Message-Id: <1388704274-5278-2-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
References: <52C5E675.80701@linaro.org>
 <1388704274-5278-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unforunately the seqlock lockdep enablmenet can't be used
in sched_clock, since the lockdep infrastructure eventually
calls into sched_clock, which causes a deadlock.

Thus, this patch changes all generic sched_clock usage
to use the raw_* methods.

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
 kernel/time/sched_clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 
-- 
1.8.3.2

