Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbaJYUAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:00:38 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34550 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaJYUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:00:37 -0400
Date: Sat, 25 Oct 2014 18:04:06 +0530
From: Heena Sirwani <heenasirwani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, arnd@arndb.de
Subject: [PATCH v5] timekeeping: Added a function to return tv_sec portion of
 ktime_get_ts64()
Message-ID: <20141025123406.GA13128@heena.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds a function to return tv_sec portion of
ktime_get_ts64() function in order to have a function that returns
seconds as 64-bit integers instead of 32-bit integers to address the
y2038 problem.

Since we are interested only in the seconds portion of ktime_get_ts64()
and require this to be as fast as possible, we take the implementation
of ktime_get_ts64() as it is and remove everything pertaining to the
nanoseconds portion. We only add to the seconds calculation if the
calculation of nanoseconds is more than one billion nanoseconds. We
replace timekeeping_get_ns() which returns the exact nanoseconds value
with tk_xtime() that returns nanosecond value of the last timer tick
since we do not require such fine resolution for nanoseconds portion but
want the seconds to be returned as fast as possible.

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
---
Changes in v5:
        - Made the commit message more clear.
	- Changed the type of variable ts from timespec64 to time64_t as
	  we do not use the tv_nsec portion.
	- Changed the type of nsec from s64 to s32.
	- replaced the value 1000000000 with NSEC_PER_SEC.

 include/linux/timekeeping.h |    1 +
 kernel/time/timekeeping.c   |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 1caa6b0..115d55e 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -28,6 +28,7 @@ struct timespec __current_kernel_time(void);
 struct timespec get_monotonic_coarse(void);
 extern void getrawmonotonic(struct timespec *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
+extern time64_t ktime_get_seconds(void);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ec1791f..93fc596 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -648,6 +648,31 @@ void ktime_get_ts64(struct timespec64 *ts)
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts64);
 
+time64_t ktime_get_seconds(void)
+{
+	time64_t ts;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	struct timespec64 tomono;
+	s32 nsec;
+	unsigned int seq;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		ts = tk->xtime_sec;
+		nsec = (long)(tk->tkr.xtime_nsec >> tk->tkr.shift);
+		tomono = tk->wall_to_monotonic;
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	ts += tomono.tv_sec;
+	if (nsec + tomono.tv_nsec >= NSEC_PER_SEC)
+		ts += 1;
+	return ts;
+}
+EXPORT_SYMBOL_GPL(ktime_get_seconds);
+
 #ifdef CONFIG_NTP_PPS
 
 /**
-- 
1.7.9.5

