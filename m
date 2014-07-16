Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaGPVEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:04:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:59663 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaGPVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:15 -0400
Message-Id: <20140716205053.588740065@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:13 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 17/64] timekeeping: Provide ktime_get_with_offset()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=timekeeping-provide-__ktime_get.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a helper function which lets us implement ktime_t based
interfaces for real, boot and tai clocks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |    9 +++++++++
 kernel/time/timekeeping.c   |   27 +++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -98,7 +98,16 @@ extern void getboottime(struct timespec
 /*
  * ktime_t based interfaces
  */
+
+enum tk_offsets {
+	TK_OFFS_REAL,
+	TK_OFFS_BOOT,
+	TK_OFFS_TAI,
+	TK_OFFS_MAX,
+};
+
 extern ktime_t ktime_get(void);
+extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -423,6 +423,33 @@ ktime_t ktime_get(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get);
 
+static ktime_t *offsets[TK_OFFS_MAX] = {
+	[TK_OFFS_REAL]	= &tk_core.timekeeper.offs_real,
+	[TK_OFFS_BOOT]	= &tk_core.timekeeper.offs_boot,
+	[TK_OFFS_TAI]	= &tk_core.timekeeper.offs_tai,
+};
+
+ktime_t ktime_get_with_offset(enum tk_offsets offs)
+{
+	struct timekeeper *tk = &tk_core.timekeeper;
+	unsigned int seq;
+	ktime_t base, *offset = offsets[offs];
+	s64 nsecs;
+
+	WARN_ON(timekeeping_suspended);
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		base = ktime_add(tk->base_mono, *offset);
+		nsecs = timekeeping_get_ns(tk);
+
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return ktime_add_ns(base, nsecs);
+
+}
+EXPORT_SYMBOL_GPL(ktime_get_with_offset);
+
 /**
  * ktime_get_ts64 - get the monotonic clock in timespec64 format
  * @ts:		pointer to timespec variable


