Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549Ab3EGN7E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:59:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42451 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932830Ab3EGNlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:41:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Engraf <david.engraf@sysgo.com>,
        John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 080/118] hrtimer: Fix ktime_add_ns() overflow on 32bit architectures
Date: Tue,  7 May 2013 14:38:46 +0100
Message-Id: <1367933964-1564-81-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/hrtimer.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 97d3742..60f7e32 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -298,6 +298,10 @@ ktime_t ktime_sub_ns(const ktime_t kt, u64 nsec)
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 
-- 
1.8.1.2

