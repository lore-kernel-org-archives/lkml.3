Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933854AbaJ2OTN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:19:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60617 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933771AbaJ2OTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:19:08 -0400
Date: Wed, 29 Oct 2014 07:18:46 -0700
From: tip-bot for Heena Sirwani <tipbot@zytor.com>
Message-ID: <tip-dbe7aa622db96b5cd601f59d09c4f00b98b76079@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, heenasirwani@gmail.com, tglx@linutronix.de,
        arnd@arndb.de
Reply-To: hpa@zytor.com, linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        arnd@arndb.de, heenasirwani@gmail.com, tglx@linutronix.de,
        mingo@kernel.org
In-Reply-To: <7adcfaa8962b8ad58785d9a2456c3f77d93c0ffb.1414578445.git.heenasirwani@gmail.com>
References: <7adcfaa8962b8ad58785d9a2456c3f77d93c0ffb.1414578445.git.heenasirwani@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/2038] timekeeping:
  Provide y2038 safe accessor to the seconds portion of CLOCK_REALTIME
Git-Commit-ID: dbe7aa622db96b5cd601f59d09c4f00b98b76079
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbe7aa622db96b5cd601f59d09c4f00b98b76079
Gitweb:     http://git.kernel.org/tip/dbe7aa622db96b5cd601f59d09c4f00b98b76079
Author:     Heena Sirwani <heenasirwani@gmail.com>
AuthorDate: Wed, 29 Oct 2014 16:01:50 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 29 Oct 2014 15:15:40 +0100

timekeeping: Provide y2038 safe accessor to the seconds portion of CLOCK_REALTIME

ktime_get_real_seconds() is the replacement function for get_seconds()
returning the seconds portion of CLOCK_REALTIME in a time64_t. For
64bit the function is equivivalent to get_seconds(), but for 32bit it
protects the readout with the timekeeper sequence count. This is
required because 32-bit machines cannot access 64-bit tk->xtime_sec
variable atomically.

[tglx: Massaged changelog and added docbook comment ]

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
Reviewed-by: Arnd Bergman <arnd@arndb.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: opw-kernel@googlegroups.com
Link: http://lkml.kernel.org/r/7adcfaa8962b8ad58785d9a2456c3f77d93c0ffb.1414578445.git.heenasirwani@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |  1 +
 kernel/time/timekeeping.c   | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

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
index a693270..0aef92a 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -676,6 +676,36 @@ time64_t ktime_get_seconds(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_seconds);
 
+/**
+ * ktime_get_real_seconds - Get the seconds portion of CLOCK_REALTIME
+ *
+ * Returns the wall clock seconds since 1970. This replaces the
+ * get_seconds() interface which is not y2038 safe on 32bit systems.
+ *
+ * For 64bit systems the fast access to tk->xtime_sec is preserved. On
+ * 32bit systems the access must be protected with the sequence
+ * counter to provide "atomic" access to the 64bit tk->xtime_sec
+ * value.
+ */
+time64_t ktime_get_real_seconds(void)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+	time64_t seconds;
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
