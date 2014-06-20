Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966198AbaFTTb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:31:56 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:37461 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966047AbaFTTbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:31:51 -0400
Message-Id: <20140620193126.037585841@linux.com>
Date: Fri, 20 Jun 2014 14:31:25 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 10/31] watchdog: Replace __raw_get_cpu_var uses
References: <20140620193115.547427118@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_watchdog
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these are the uses of &__raw_get_cpu_var for address calculation.

touch_softlockup_watchdog_sync() uses __raw_get_cpu_var to write to
per cpu variables. Use __this_cpu_write instead.

Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-watchdog@vger.kernel.org
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/kernel/watchdog.c
===================================================================
--- linux.orig/kernel/watchdog.c	2014-06-16 15:39:29.772852391 -0500
+++ linux/kernel/watchdog.c	2014-06-16 15:39:34.296768126 -0500
@@ -169,7 +169,7 @@
 	 * case we shouldn't have to worry about the watchdog
 	 * going off.
 	 */
-	__raw_get_cpu_var(watchdog_nmi_touch) = true;
+	raw_cpu_write(watchdog_nmi_touch, true);
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
@@ -178,8 +178,8 @@
 
 void touch_softlockup_watchdog_sync(void)
 {
-	__raw_get_cpu_var(softlockup_touch_sync) = true;
-	__raw_get_cpu_var(watchdog_touch_ts) = 0;
+	__this_cpu_write(softlockup_touch_sync, true);
+	__this_cpu_write(watchdog_touch_ts, 0);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -345,7 +345,7 @@
 
 static void watchdog_enable(unsigned int cpu)
 {
-	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+	struct hrtimer *hrtimer = raw_cpu_ptr(&watchdog_hrtimer);
 
 	/* kick off the timer for the hardlockup detector */
 	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
@@ -365,7 +365,7 @@
 
 static void watchdog_disable(unsigned int cpu)
 {
-	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+	struct hrtimer *hrtimer = raw_cpu_ptr(&watchdog_hrtimer);
 
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
@@ -492,7 +492,7 @@
 
 static void restart_watchdog_hrtimer(void *info)
 {
-	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
+	struct hrtimer *hrtimer = raw_cpu_ptr(&watchdog_hrtimer);
 	int ret;
 
 	/*

