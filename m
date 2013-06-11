Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab3FKUEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3FKUEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Zoran Markovic <zoran.markovic@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Feng Tang <feng.tang@intel.com>
Subject: [ 78/79] timekeeping: Correct run-time detection of persistent_clock.
Date: Tue, 11 Jun 2013 13:03:44 -0700
Message-Id: <20130611195326.268819398@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zoran Markovic <zoran.markovic@linaro.org>

commit 0d6bd9953f739dad96d9a0de65383e479ab4e10d upstream.

Since commit 31ade30692dc9680bfc95700d794818fa3f754ac, timekeeping_init()
checks for presence of persistent clock by attempting to read a non-zero
time value. This is an issue on platforms where persistent_clock (instead
is implemented as a free-running counter (instead of an RTC) starting
from zero on each boot and running during suspend. Examples are some ARM
platforms (e.g. PandaBoard).

An attempt to read such a clock during timekeeping_init() may return zero
value and falsely declare persistent clock as missing. Additionally, in
the above case suspend times may be accounted twice (once from
timekeeping_resume() and once from rtc_resume()), resulting in a gradual
drift of system time.

This patch does a run-time correction of the issue by doing the same check
during timekeeping_suspend().

A better long-term solution would have to return error when trying to read
non-existing clock and zero when trying to read an uninitialized clock, but
that would require changing all persistent_clock implementations.

This patch addresses the immediate breakage, for now.

Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Feng Tang <feng.tang@intel.com>
[jstultz: Tweaked commit message and subject]
Signed-off-by: John Stultz <john.stultz@linaro.org>
[zoran.markovic@linaro.org: reworked patch to fit 3.9-stable.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -826,6 +826,14 @@ static int timekeeping_suspend(void)
 
 	read_persistent_clock(&timekeeping_suspend_time);
 
+	/*
+	 * On some systems the persistent_clock can not be detected at
+	 * timekeeping_init by its return value, so if we see a valid
+	 * value returned, update the persistent_clock_exists flag.
+	 */
+	if (timekeeping_suspend_time.tv_sec || timekeeping_suspend_time.tv_nsec)
+		persistent_clock_exist = true;
+
 	write_seqlock_irqsave(&tk->lock, flags);
 	timekeeping_forward_now(tk);
 	timekeeping_suspended = 1;


