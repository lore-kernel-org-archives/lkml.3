Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaHLPwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:52:47 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:37069 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbaHLPwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:52:46 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] timekeeping: Another fix to the VSYSCALL_OLD update_vsyscall
Date: Tue, 12 Aug 2014 08:52:29 -0700
Message-Id: <1407858749-15422-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt pointed out that I firuther missed
modifying update_vsyscall after the wall_to_mono value was
changed to a timespec64. This causes issues on powerpc32,
which expects a 32bit timespec.

This patch fixes the problem my properly converting from
a timespec64 to a timespec before passing the value on to
the arch-specific vsyscall logic.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f36b028..fb4a9c2 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -338,10 +338,11 @@ EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
 
 static inline void update_vsyscall(struct timekeeper *tk)
 {
-	struct timespec xt;
+	struct timespec xt, wm;
 
 	xt = timespec64_to_timespec(tk_xtime(tk));
-	update_vsyscall_old(&xt, &tk->wall_to_monotonic, tk->tkr.clock, tk->tkr.mult,
+	wm = timespec64_to_timespec(tk->wall_to_monotonic);
+	update_vsyscall_old(&xt, &wm, tk->tkr.clock, tk->tkr.mult,
 			    tk->tkr.cycle_last);
 }
 
-- 
1.9.1

