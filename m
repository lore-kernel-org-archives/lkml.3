Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab3FTTQj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:16:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:43320 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758234Ab3FTTQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:16:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,906,1363132800"; 
   d="scan'208";a="32470382"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/4] x86/xen: sync the CMOS RTC as well as the Xen wallclock
Date: Thu, 20 Jun 2013 20:16:32 +0100
Message-ID: <1371755792-25962-5-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Adjustments to Xen's persistent clock via update_persistent_clock()
don't actually persist, as the Xen wallclock is a software only clock
and modifications to it do not modify the underlying CMOS RTC.

The x86_platform.set_wallclock hook can be used to keep the hardware
RTC synchronized (as on bare metal).  Because the Xen wallclock is now
kept synchronized by the clock_was_set notifier and a new timer,
xen_set_wallclock() need not do this and dom0 can simply use the
native implementation.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |   48 +++++++++++++++++++++++++++++++-----------------
 1 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index ad077ca..f3d09eb 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -198,38 +198,50 @@ static void xen_get_wallclock(struct timespec *now)
 
 static int xen_set_wallclock(const struct timespec *now)
 {
+	return -1;
+}
+
+static void xen_wallclock_timer_func(unsigned long d);
+static DEFINE_TIMER(xen_wallclock_timer, xen_wallclock_timer_func, 0, 0);
+
+static void xen_sync_wallclock(void)
+{
+	struct timespec now;
 	struct xen_platform_op op;
 
-	/* do nothing for domU */
-	if (!xen_initial_domain())
-		return -1;
+	now = current_kernel_time();
 
 	op.cmd = XENPF_settime;
-	op.u.settime.secs = now->tv_sec;
-	op.u.settime.nsecs = now->tv_nsec;
+	op.u.settime.secs = now.tv_sec;
+	op.u.settime.nsecs = now.tv_nsec;
 	op.u.settime.system_time = xen_clocksource_read();
 
-	return HYPERVISOR_dom0_op(&op);
+	(void)HYPERVISOR_dom0_op(&op);
+
+	/*
+	 * Use a timer to correct for any drift in the Xen
+	 * wallclock.
+	 *
+	 * 11 minutes is the same period as sync_cmos_clock().
+	 */
+	mod_timer(&xen_wallclock_timer, round_jiffies(jiffies + 11*60*HZ));
 }
- 
+
 static int xen_clock_was_set_notify(struct notifier_block *nb, unsigned long unused,
 				    void *priv)
 {
-       struct timespec now;
-
-       /*
-        * Set the Xen wallclock from Linux system time.
-        */
-       now = current_kernel_time();
-       xen_set_wallclock(&now);
-
-       return NOTIFY_OK;
+	xen_sync_wallclock();
+	return NOTIFY_OK;
 }
 
 static struct notifier_block xen_clock_was_set_notifier = {
 	.notifier_call = xen_clock_was_set_notify,
 };
 
+static void xen_wallclock_timer_func(unsigned long d)
+{
+	xen_sync_wallclock();
+}
 
 static struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
@@ -507,7 +519,9 @@ void __init xen_init_time_ops(void)
 
 	x86_platform.calibrate_tsc = xen_tsc_khz;
 	x86_platform.get_wallclock = xen_get_wallclock;
-	x86_platform.set_wallclock = xen_set_wallclock;
+	/* Dom0 uses the native method to set the hardware RTC. */
+	if (!xen_initial_domain())
+		x86_platform.set_wallclock = xen_set_wallclock;
 }
 
 #ifdef CONFIG_XEN_PVHVM
-- 
1.7.2.5

