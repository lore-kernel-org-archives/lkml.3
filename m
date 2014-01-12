Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaALSnl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:43:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46245 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbaALSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:43:38 -0500
Date: Sun, 12 Jan 2014 10:42:38 -0800
From: tip-bot for John Stultz <tipbot@zytor.com>
Message-ID: <tip-7a06c41cbec33c6dbe7eec575c61986122617408@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, john.stultz@linaro.org, w@1wt.eu,
        khalasa@piap.pl, tglx@linutronix.de, u.kleine-koenig@pengutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        sboyd@codeaurora.org, john.stultz@linaro.org, w@1wt.eu,
        khalasa@piap.pl, u.kleine-koenig@pengutronix.de, tglx@linutronix.de
In-Reply-To: <1388704274-5278-2-git-send-email-john.stultz@linaro.org>
References: <1388704274-5278-2-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/urgent] sched_clock:
  Disable seqlock lockdep usage in sched_clock()
Git-Commit-ID: 7a06c41cbec33c6dbe7eec575c61986122617408
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:42:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a06c41cbec33c6dbe7eec575c61986122617408
Gitweb:     http://git.kernel.org/tip/7a06c41cbec33c6dbe7eec575c61986122617408
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Thu, 2 Jan 2014 15:11:14 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 12 Jan 2014 10:14:00 +0100

sched_clock: Disable seqlock lockdep usage in sched_clock()

Unfortunately the seqlock lockdep enablement can't be used
in sched_clock(), since the lockdep infrastructure eventually
calls into sched_clock(), which causes a deadlock.

Thus, this patch changes all generic sched_clock() usage
to use the raw_* methods.

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Krzysztof Hałasa <khalasa@piap.pl>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1388704274-5278-2-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
