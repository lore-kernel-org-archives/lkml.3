Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab3EFU6c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 16:58:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3EFUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 16:46:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Engraf <david.engraf@sysgo.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [ 069/115] hrtimer: Fix ktime_add_ns() overflow on 32bit architectures
Date: Mon,  6 May 2013 13:45:05 -0700
Message-Id: <20130506203102.622003727@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506203055.537199268@linuxfoundation.org>
References: <20130506203055.537199268@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/hrtimer.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -276,6 +276,10 @@ ktime_t ktime_add_ns(const ktime_t kt, u
 	} else {
 		unsigned long rem = do_div(nsec, NSEC_PER_SEC);
 
+		/* Make sure nsec fits into long */
+		if (unlikely(nsec > KTIME_SEC_MAX))
+			return (ktime_t){ .tv64 = KTIME_MAX };
+
 		tmp = ktime_set((long)nsec, rem);
 	}
 


