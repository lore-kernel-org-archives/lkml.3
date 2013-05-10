Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3EJOWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:22:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57344 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab3EJOWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:12 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John Stultz" <john.stultz@linaro.org>,
        "David Engraf" <david.engraf@sysgo.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.500721455@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [022/118] hrtimer: Fix ktime_add_ns() overflow on 32bit architectures
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Engraf <david.engraf@sysgo.com>

commit 51fd36f3fad8447c487137ae26b9d0b3ce77bb25 upstream.

One can trigger an overflow when using ktime_add_ns() on a 32bit
architecture not supporting CONFIG_KTIME_SCALAR.

When passing a very high value for u64 nsec, e.g. 7881299347898368000
the do_div() function converts this value to seconds (7881299347) which
is still to high to pass to the ktime_set() function as long. The result
in is a negative value.

The problem on my system occurs in the tick-sched.c,
tick_nohz_stop_sched_tick() when time_delta is set to
timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is
valid, thus ktime_add_ns() is called with a too large value resulting in
a negative expire value. This leads to an endless loop in the ticker code:

time_delta: 7881299347898368000
expires = ktime_add_ns(last_update, time_delta)
expires: negative value

This fix caps the value to KTIME_MAX.

This error doesn't occurs on 64bit or architectures supporting
CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).

Signed-off-by: David Engraf <david.engraf@sysgo.com>
[jstultz: Minor tweaks to commit message & header]
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/hrtimer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -298,6 +298,10 @@ ktime_t ktime_sub_ns(const ktime_t kt, u
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 

