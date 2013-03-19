Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab3CSM36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:29:58 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:37886 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3CSM35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:29:57 -0400
Message-ID: <51485A43.4020600@sysgo.com>
Date: Tue, 19 Mar 2013 13:29:55 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ktime_add_ns() may overflow on 32bit architectures
Content-Type: multipart/mixed;
 boundary="------------010205050204020801020407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010205050204020801020407
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I've triggered an overflow when using ktime_add_ns() on a 32bit 
architecture not supporting CONFIG_KTIME_SCALAR.

When passing a very high value for u64 nsec, e.g. 7881299347898368000 
the do_div() function converts this value to seconds (7881299347) which 
is still to high to pass to the ktime_set() function as long. The result 
in my case is a negative value.

The problem on my system occurs in the tick-sched.c, 
tick_nohz_stop_sched_tick() when time_delta is set to 
timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is 
valid, thus ktime_add_ns() is called with a too large value resulting in 
a negative expire value. This leads to an endless loop in the ticker code:

time_delta: 7881299347898368000
expires = ktime_add_ns(last_update, time_delta)
expires: negative value

This error doesn't occurs on 64bit or architectures supporting 
CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).

Best regards
- David

Signed-off-by: David Engraf <david.engraf@sysgo.com>


--------------010205050204020801020407
Content-Type: text/x-diff;
 name="ktime_add_ns.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ktime_add_ns.patch"

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..320a7aa 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -275,6 +275,10 @@ ktime_t ktime_add_ns(const ktime_t kt, u64 nsec)
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 

--------------010205050204020801020407--
