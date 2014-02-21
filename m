Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaBUNsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:48:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125AbaBUMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <sasha.levin@oracle.com>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/121] timekeeping: Fix CLOCK_TAI timer/nanosleep delays
Date: Fri, 21 Feb 2014 12:47:46 +0000
Message-Id: <1392986945-9693-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

commit 04005f6011e3b504cd4d791d9769f7cb9a3b2eae upstream.

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
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/timekeeping.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index f223826..cd0c384 100644
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
1.9.0

