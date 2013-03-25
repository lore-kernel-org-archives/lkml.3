Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab3CYUIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:08:36 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36163 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CYUId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:33 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 6/8] timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
Date: Mon, 25 Mar 2013 13:08:16 -0700
Message-Id: <1364242098-5977-7-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In moving the NTP state to be protected by the timekeeping locks,
be sure to acquire the timekeeping locks prior to calling
ntp functions.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index e44915c..d10bd73 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -787,10 +787,10 @@ void __init timekeeping_init(void)
 		boot.tv_nsec = 0;
 	}
 
-	ntp_init();
-
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
+	ntp_init();
+
 	clock = clocksource_default_clock();
 	if (clock->enable)
 		clock->enable(clock);
@@ -1618,6 +1618,7 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
+	unsigned long flags;
 	struct timespec ts;
 	s32 tai, orig_tai;
 	int ret;
@@ -1641,8 +1642,14 @@ int do_adjtimex(struct timex *txc)
 	getnstimeofday(&ts);
 	orig_tai = tai = timekeeping_get_tai_offset();
 
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+
 	ret = __do_adjtimex(txc, &ts, &tai);
 
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
+
 	if (tai != orig_tai)
 		timekeeping_set_tai_offset(tai);
 
@@ -1655,7 +1662,15 @@ int do_adjtimex(struct timex *txc)
  */
 void hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&timekeeper_lock, flags);
+	write_seqcount_begin(&timekeeper_seq);
+
 	__hardpps(phase_ts, raw_ts);
+
+	write_seqcount_end(&timekeeper_seq);
+	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 }
 EXPORT_SYMBOL(hardpps);
 #endif
-- 
1.7.10.4

