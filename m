Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199Ab3AXUUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:20:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab3AXUUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:20:39 -0500
Date: Thu, 24 Jan 2013 12:20:21 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-03d8c5dc53d2e883bd3badb6436a33fc64e2f638@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, rostedt@goodmis.org,
        tglx@linutronix.de, dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org, dzickus@redhat.com
In-Reply-To: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
References: <1356576585-28782-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] watchdog: Use local_clock for get_timestamp()
Git-Commit-ID: 03d8c5dc53d2e883bd3badb6436a33fc64e2f638
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 12:20:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03d8c5dc53d2e883bd3badb6436a33fc64e2f638
Gitweb:     http://git.kernel.org/tip/03d8c5dc53d2e883bd3badb6436a33fc64e2f638
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 27 Dec 2012 11:49:44 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 24 Jan 2013 15:13:36 +0100

watchdog: Use local_clock for get_timestamp()

The get_timestamp() function is always called with current cpu,
thus using local_clock() would be more appropriate and it makes
the code shorter and cleaner IMHO.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1356576585-28782-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/watchdog.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 75a2ab3..082ca68 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -112,9 +112,9 @@ static int get_softlockup_thresh(void)
  * resolution, and we don't need to waste time with a big divide when
  * 2^30ns == 1.074s.
  */
-static unsigned long get_timestamp(int this_cpu)
+static unsigned long get_timestamp(void)
 {
-	return cpu_clock(this_cpu) >> 30LL;  /* 2^30 ~= 10^9 */
+	return local_clock() >> 30LL;  /* 2^30 ~= 10^9 */
 }
 
 static void set_sample_period(void)
@@ -132,9 +132,7 @@ static void set_sample_period(void)
 /* Commands for resetting the watchdog */
 static void __touch_watchdog(void)
 {
-	int this_cpu = smp_processor_id();
-
-	__this_cpu_write(watchdog_touch_ts, get_timestamp(this_cpu));
+	__this_cpu_write(watchdog_touch_ts, get_timestamp());
 }
 
 void touch_softlockup_watchdog(void)
@@ -195,7 +193,7 @@ static int is_hardlockup(void)
 
 static int is_softlockup(unsigned long touch_ts)
 {
-	unsigned long now = get_timestamp(smp_processor_id());
+	unsigned long now = get_timestamp();
 
 	/* Warn about unreasonable delays: */
 	if (time_after(now, touch_ts + get_softlockup_thresh()))
