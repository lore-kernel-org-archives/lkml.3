Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935229Ab3DJTl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 15:41:59 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51015 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934822Ab3DJTl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 15:41:56 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] timekeeping: Make sure to notify hrtimers when TAI offset changes
Date: Wed, 10 Apr 2013 12:41:49 -0700
Message-Id: <1365622909-953-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, here's a bugfix I just caught with my 3.10 queue. Mind
adding this to tip/timers/core?

thanks
-john


Now that we have CLOCK_TAI timers, make sure we notify hrtimer
code when TAI offset is changed.

Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index c4d2a87..675f720 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -607,6 +607,7 @@ void timekeeping_set_tai_offset(s32 tai_offset)
 	__timekeeping_set_tai_offset(tk, tai_offset);
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+	clock_was_set();
 }
 
 /**
@@ -1639,7 +1640,7 @@ int do_adjtimex(struct timex *txc)
 	struct timekeeper *tk = &timekeeper;
 	unsigned long flags;
 	struct timespec ts;
-	s32 tai;
+	s32 orig_tai, tai;
 	int ret;
 
 	/* Validate the data before disabling interrupts */
@@ -1663,10 +1664,13 @@ int do_adjtimex(struct timex *txc)
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 
-	tai = tk->tai_offset;
+	orig_tai = tai = tk->tai_offset;
 	ret = __do_adjtimex(txc, &ts, &tai);
 
-	__timekeeping_set_tai_offset(tk, tai);
+	if (tai != orig_tai) {
+		__timekeeping_set_tai_offset(tk, tai);
+		clock_was_set_delayed();
+	}
 	write_seqcount_end(&timekeeper_seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-- 
1.7.10.4

