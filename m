Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853Ab3AOSx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:53:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:34345 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab3AOSxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:53:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Norbert Warmuth <nwarmuth@t-online.de>,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 027/221] watchdog: Fix disable/enable regression
Date: Tue, 15 Jan 2013 10:49:14 -0800
Message-Id: <20130115184959.997832980@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 3935e89505a1c3ab3f3b0c7ef0eae54124f48905 upstream.

Commit 8d4516904b39 ("watchdog: Fix CPU hotplug regression") causes an
oops or hard lockup when doing

 echo 0 > /proc/sys/kernel/nmi_watchdog
 echo 1 > /proc/sys/kernel/nmi_watchdog

and the kernel is booted with nmi_watchdog=1 (default)

Running laptop-mode-tools and disconnecting/connecting AC power will
cause this to trigger, making it a common failure scenario on laptops.

Instead of bailing out of watchdog_disable() when !watchdog_enabled we
can initialize the hrtimer regardless of watchdog_enabled status.  This
makes it safe to call watchdog_disable() in the nmi_watchdog=0 case,
without the negative effect on the enabled => disabled => enabled case.

All these tests pass with this patch:
- nmi_watchdog=1
  echo 0 > /proc/sys/kernel/nmi_watchdog
  echo 1 > /proc/sys/kernel/nmi_watchdog

- nmi_watchdog=0
  echo 0 > /sys/devices/system/cpu/cpu1/online

- nmi_watchdog=0
  echo mem > /sys/power/state

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=51661

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Norbert Warmuth <nwarmuth@t-online.de>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/watchdog.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -343,6 +343,10 @@ static void watchdog_enable(unsigned int
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
+	/* kick off the timer for the hardlockup detector */
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer->function = watchdog_timer_fn;
+
 	if (!watchdog_enabled) {
 		kthread_park(current);
 		return;
@@ -351,10 +355,6 @@ static void watchdog_enable(unsigned int
 	/* Enable the perf event */
 	watchdog_nmi_enable(cpu);
 
-	/* kick off the timer for the hardlockup detector */
-	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer->function = watchdog_timer_fn;
-
 	/* done here because hrtimer_start can only pin to smp_processor_id() */
 	hrtimer_start(hrtimer, ns_to_ktime(get_sample_period()),
 		      HRTIMER_MODE_REL_PINNED);
@@ -368,9 +368,6 @@ static void watchdog_disable(unsigned in
 {
 	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
 
-	if (!watchdog_enabled)
-		return;
-
 	watchdog_set_prio(SCHED_NORMAL, 0);
 	hrtimer_cancel(hrtimer);
 	/* disable the perf event */


