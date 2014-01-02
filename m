Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbaABWYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:24:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61735 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaABWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:23:39 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH 5/9] timekeeping: Fix CLOCK_TAI timer/nanosleep delays
Date: Thu,  2 Jan 2014 14:23:23 -0800
Message-Id: <1388701407-5029-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
References: <52C5E6A0.7010507@linaro.org>
 <1388701407-5029-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A think-o in the calculation of the monotonic -> tai time offset
results in CLOCK_TAI timers and nanosleeps to expire late (the
latency is ~2x the tai offset).

Fix this by adding the tai offset from the realtime offset instead
of subtracting.

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: stable <stable@vger.kernel.org> #3.10+
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 44b7e6b..3f6a827 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -77,7 +77,7 @@ static void tk_set_wall_to_mono(struct timekeeper *tk, struct timespec wtm)
 	tk->wall_to_monotonic = wtm;
 	set_normalized_timespec(&tmp, -wtm.tv_sec, -wtm.tv_nsec);
 	tk->offs_real = timespec_to_ktime(tmp);
-	tk->offs_tai = ktime_sub(tk->offs_real, ktime_set(tk->tai_offset, 0));
+	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tk->tai_offset, 0));
 }
 
 static void tk_set_sleep_time(struct timekeeper *tk, struct timespec t)
@@ -595,7 +595,7 @@ s32 timekeeping_get_tai_offset(void)
 static void __timekeeping_set_tai_offset(struct timekeeper *tk, s32 tai_offset)
 {
 	tk->tai_offset = tai_offset;
-	tk->offs_tai = ktime_sub(tk->offs_real, ktime_set(tai_offset, 0));
+	tk->offs_tai = ktime_add(tk->offs_real, ktime_set(tai_offset, 0));
 }
 
 /**
-- 
1.8.3.2

