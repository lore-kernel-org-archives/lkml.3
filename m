Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab3CYUI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:08:57 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56808 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313Ab3CYUIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:35 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 7/8] timekeeping: Simplify tai updating from do_adjtimex
Date: Mon, 25 Mar 2013 13:08:17 -0700
Message-Id: <1364242098-5977-8-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we are taking the timekeeping locks, just go ahead
and update any tai change directly, rather then dropping
the lock and calling a function that will just take it again.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d10bd73..f93f60c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1618,9 +1618,10 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
+	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	struct timespec ts;
-	s32 tai, orig_tai;
+	s32 tai;
 	int ret;
 
 	/* Validate the data before disabling interrupts */
@@ -1640,19 +1641,17 @@ int do_adjtimex(struct timex *txc)
 	}
 
 	getnstimeofday(&ts);
-	orig_tai = tai = timekeeping_get_tai_offset();
 
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
+	tai = tk->tai_offset;
 	ret = __do_adjtimex(txc, &ts, &tai);
 
+	__timekeeping_set_tai_offset(tk, tai);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	if (tai != orig_tai)
-		timekeeping_set_tai_offset(tai);
-
 	return ret;
 }
 
-- 
1.7.10.4

