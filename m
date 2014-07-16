Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160AbaGPVRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:17:53 -0400
Received: from www.linutronix.de ([62.245.132.108]:59695 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaGPVEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:04:23 -0400
Message-Id: <20140716205054.109538036@linutronix.de>
User-Agent: quilt/0.63-1
Date: Wed, 16 Jul 2014 21:04:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [patch V2 23/64] timekeeping: Provide ktime_mono_to_any()
References: <20140716205018.175419210@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=timekeeping-provide-ktime-mono_to-wall.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ktime based conversion function to map a monotonic time stamp to a
different CLOCK.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/timekeeping.h |    9 +++++++++
 kernel/time/timekeeping.c   |   20 ++++++++++++++++++++
 2 files changed, 29 insertions(+)

Index: tip/include/linux/timekeeping.h
===================================================================
--- tip.orig/include/linux/timekeeping.h
+++ tip/include/linux/timekeeping.h
@@ -109,6 +109,7 @@ enum tk_offsets {
 extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_with_offset(enum tk_offsets offs);
 extern ktime_t ktime_get_monotonic_offset(void);
+extern ktime_t ktime_mono_to_any(ktime_t tmono, enum tk_offsets offs);
 
 /**
  * ktime_get_real - get the real (wall-) time in ktime_t format
@@ -137,6 +138,14 @@ static inline ktime_t ktime_get_clocktai
 	return ktime_get_with_offset(TK_OFFS_TAI);
 }
 
+/**
+ * ktime_mono_to_real - Convert monotonic time to clock realtime
+ */
+static inline ktime_t ktime_mono_to_real(ktime_t mono)
+{
+	return ktime_mono_to_any(mono, TK_OFFS_REAL);
+}
+
 /*
  * RTC specific
  */
Index: tip/kernel/time/timekeeping.c
===================================================================
--- tip.orig/kernel/time/timekeeping.c
+++ tip/kernel/time/timekeeping.c
@@ -451,6 +451,26 @@ ktime_t ktime_get_with_offset(enum tk_of
 EXPORT_SYMBOL_GPL(ktime_get_with_offset);
 
 /**
+ * ktime_mono_to_any() - convert mononotic time to any other time
+ * @tmono:	time to convert.
+ * @offs:	which offset to use
+ */
+ktime_t ktime_mono_to_any(ktime_t tmono, enum tk_offsets offs)
+{
+	ktime_t *offset = offsets[offs];
+	unsigned long seq;
+	ktime_t tconv;
+
+	do {
+		seq = read_seqcount_begin(&tk_core.seq);
+		tconv = ktime_add(tmono, *offset);
+	} while (read_seqcount_retry(&tk_core.seq, seq));
+
+	return tconv;
+}
+EXPORT_SYMBOL_GPL(ktime_mono_to_any);
+
+/**
  * ktime_get_ts64 - get the monotonic clock in timespec64 format
  * @ts:		pointer to timespec variable
  *


