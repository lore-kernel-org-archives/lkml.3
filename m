Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbaFUUhh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:37:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35029 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbaFUUhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:37:34 -0400
Date: Sat, 21 Jun 2014 13:36:47 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b5d7682533941edb121f7495bdb2a17abac03ff3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140611234606.931409215@linutronix.de>
References: <20140611234606.931409215@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] delayacct: Use ktime_get_ts()
Git-Commit-ID: b5d7682533941edb121f7495bdb2a17abac03ff3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5d7682533941edb121f7495bdb2a17abac03ff3
Gitweb:     http://git.kernel.org/tip/b5d7682533941edb121f7495bdb2a17abac03ff3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 23:59:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Jun 2014 16:18:45 +0200

delayacct: Use ktime_get_ts()

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts(). Remove the
silly wrapper while at it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140611234606.931409215@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/delayacct.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 54996b7..de699f4 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -46,16 +46,6 @@ void __delayacct_tsk_init(struct task_struct *tsk)
 }
 
 /*
- * Start accounting for a delay statistic using
- * its starting timestamp (@start)
- */
-
-static inline void delayacct_start(struct timespec *start)
-{
-	do_posix_clock_monotonic_gettime(start);
-}
-
-/*
  * Finish delay accounting for a statistic using
  * its timestamps (@start, @end), accumalator (@total) and @count
  */
@@ -67,7 +57,7 @@ static void delayacct_end(struct timespec *start, struct timespec *end,
 	s64 ns;
 	unsigned long flags;
 
-	do_posix_clock_monotonic_gettime(end);
+	ktime_get_ts(end);
 	ts = timespec_sub(*end, *start);
 	ns = timespec_to_ns(&ts);
 	if (ns < 0)
@@ -81,7 +71,7 @@ static void delayacct_end(struct timespec *start, struct timespec *end,
 
 void __delayacct_blkio_start(void)
 {
-	delayacct_start(&current->delays->blkio_start);
+	ktime_get_ts(&current->delays->blkio_start);
 }
 
 void __delayacct_blkio_end(void)
@@ -169,7 +159,7 @@ __u64 __delayacct_blkio_ticks(struct task_struct *tsk)
 
 void __delayacct_freepages_start(void)
 {
-	delayacct_start(&current->delays->freepages_start);
+	ktime_get_ts(&current->delays->freepages_start);
 }
 
 void __delayacct_freepages_end(void)
