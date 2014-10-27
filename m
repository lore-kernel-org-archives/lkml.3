Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaJ0FIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:08:11 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59212 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbaJ0FIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:08:09 -0400
Date: Mon, 27 Oct 2014 10:38:04 +0530
From: Heena Sirwani <heenasirwani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, arnd@arndb.de
Subject: [PATCH v2] timekeeping: Added a function to return tv_sec portion of
 ktime_get_real_ts64()
Message-ID: <20141027050804.GA8550@heena-HP-Compaq-8200-Elite-MT-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch adds a function to return tv_sec portion of
ktime_get_real_ts64() function in order to have a function that returns
seconds as 64-bit integers instead of 32-bit integers to address the
y2038 problem.

The function is similar to get_seconds() function except that it
includes read_seqcount_retry loop which is required for 32-bit
architectures. This is because 32-bit machines cannot access 64-bit
tk->xtime_sec variable atomically, requiring two 32-bit register loads.

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v2:
        - Removed the local variable nsecs as it was not required.

 include/linux/timekeeping.h |  1 +
 kernel/time/timekeeping.c   | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/timekeeping.h b/include/linux/timekeeping.h
index 115d55e..91454de 100644
--- a/include/linux/timekeeping.h
+++ b/include/linux/timekeeping.h
@@ -29,6 +29,7 @@ struct timespec get_monotonic_coarse(void);
 extern void getrawmonotonic(struct timespec *ts);
 extern void ktime_get_ts64(struct timespec64 *ts);
 extern time64_t ktime_get_seconds(void);
+extern time64_t ktime_get_real_seconds(void);
 
 extern int __getnstimeofday64(struct timespec64 *tv);
 extern void getnstimeofday64(struct timespec64 *tv);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 93fc596..c17c620 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -673,6 +673,25 @@ time64_t ktime_get_seconds(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_seconds);
 
+time64_t ktime_get_real_seconds(void)
+{
+	time64_t seconds;
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned int seq;
+
+	if (IS_ENABLED(CONFIG_64BIT))
+		return tk->xtime_sec;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		seconds = tk->xtime_sec;
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return seconds;
+}
+EXPORT_SYMBOL_GPL(ktime_get_real_seconds);
+
 #ifdef CONFIG_NTP_PPS
 
 /**
-- 
1.9.1

