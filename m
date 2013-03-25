Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab3CYUIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:08:32 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59454 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CYUI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:08:29 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH 3/8] ntp: Move timex validation to timekeeping do_adjtimex call.
Date: Mon, 25 Mar 2013 13:08:13 -0700
Message-Id: <1364242098-5977-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
References: <1364242098-5977-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move logic that does not need the ntp state to be done
in the timekeeping do_adjtimex() call.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/ntp.c          |    5 -----
 kernel/time/ntp_internal.h |    1 +
 kernel/time/timekeeping.c  |    7 +++++++
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 8b10706..2dc60c6 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -668,11 +668,6 @@ int __do_adjtimex(struct timex *txc)
 	u32 time_tai, orig_tai;
 	int result;
 
-	/* Validate the data before disabling interrupts */
-	result = ntp_validate_timex(txc);
-	if (result)
-		return result;
-
 	if (txc->modes & ADJ_SETOFFSET) {
 		struct timespec delta;
 		delta.tv_sec  = txc->time.tv_sec;
diff --git a/kernel/time/ntp_internal.h b/kernel/time/ntp_internal.h
index fdee80c..a2a3976 100644
--- a/kernel/time/ntp_internal.h
+++ b/kernel/time/ntp_internal.h
@@ -6,6 +6,7 @@ extern void ntp_clear(void);
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
 extern u64 ntp_tick_length(void);
 extern int second_overflow(unsigned long secs);
+extern int ntp_validate_timex(struct timex *);
 extern int __do_adjtimex(struct timex *);
 extern void __hardpps(const struct timespec *, const struct timespec *);
 #endif /* _LINUX_NTP_INTERNAL_H */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index a138ec2..f6c8a72 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1618,6 +1618,13 @@ EXPORT_SYMBOL_GPL(ktime_get_monotonic_offset);
  */
 int do_adjtimex(struct timex *txc)
 {
+	int ret;
+
+	/* Validate the data before disabling interrupts */
+	ret = ntp_validate_timex(txc);
+	if (ret)
+		return ret;
+
 	return __do_adjtimex(txc);
 }
 
-- 
1.7.10.4

