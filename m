Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3EQSYk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 14:24:40 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45073 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3EQSYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 14:24:37 -0400
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: zoran.markovic@linaro.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Feng Tang <feng.tang@intel.com>,
        stable@vger.kernel.org
Subject: [RFC PATCH] timekeeping: Correct run-time detection of real-time clock.
Date: Fri, 17 May 2013 11:24:05 -0700
Message-Id: <1368815045-21209-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit <31ade30692dc9680bfc95700d794818fa3f754ac>, timekeeping_init()
checks for presence of persistent clock by attempting to read a non-zero
time value from real-time clock. This is an issue on platforms where
persistent_clock (instead of a RTC) is implemented as a free-running counter
starting from zero on each boot and running during suspend. Examples are some
ARM platforms (e.g. PandaBoard). An attempt to read such a clock during
timekeeping_init() may return zero value and falsely declare persistent clock
as missing. Additionally, in the above case suspend times may be accounted
twice (once from timekeeping_resume() and once from rtc_resume()), resulting
in a gradual drift of system time.

This patch does a run-time correction of the issue by doing the same check
during timekeeping_suspend().

A better long-term solution would have to return error when trying to read
non-existing clock and zero when trying to read an uninitialized clock, but
that would require changing all persistent_clock implementations.

This patch addresses the immediate breakage, for now.

Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 kernel/time/timekeeping.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 98cd470..baeeb5c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -975,6 +975,14 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
+	/*
+	 * On some systems the persistent_clock can not be detected at
+	 * timekeeping_init by its return value, so if we see a valid
+	 * value returned, update the persistent_clock_exists flag.
+	 */
+	if (timekeeping_suspend_time.tv_sec || timekeeping_suspend_time.tv_nsec)
+		persistent_clock_exist = true;
+
 	raw_spin_lock_irqsave(&timekeeper_lock, flags);
 	write_seqcount_begin(&timekeeper_seq);
 	timekeeping_forward_now(tk);
-- 
1.7.9.5

