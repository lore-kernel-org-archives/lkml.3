Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbaBKTww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:52:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40223 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbaBKTHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.12 103/107] timekeeping: Fix CLOCK_TAI timer/nanosleep delays
Date: Tue, 11 Feb 2014 11:06:09 -0800
Message-Id: <20140211184751.134673978@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/timekeeping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -77,7 +77,7 @@ static void tk_set_wall_to_mono(struct t
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


