Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3E1SWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:22:55 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51454 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab3E1SWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:22:54 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="26485991"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86/xen: sync the wallclock when the system time changes
Date: Tue, 28 May 2013 19:22:48 +0100
Message-ID: <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Currently the Xen wallclock is only updated every 11 minutes if NTP is
synchronized to its clock source.  If a guest is started before NTP is
synchronized it may see an incorrect wallclock time.

Use the pvclock_gtod notifier chain to receive a notification when the
system time has changed and update the wallclock to match.

This chain is called on every timer tick and we want to avoid an extra
(expensive) hypercall on every tick.  Because dom0 has historically
never provided a very accurate wallclock and guests do not expect one,
we can do this simply.  The wallclock is only updated if the
difference between now and the last update is more than 0.5 s.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |   54 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 4656165..81027b5 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -15,6 +15,8 @@
 #include <linux/math64.h>
 #include <linux/gfp.h>
 #include <linux/mc146818rtc.h>
+#include <linux/timekeeper_internal.h>
+#include <linux/pvclock_gtod.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
@@ -199,28 +201,59 @@ static void xen_get_wallclock(struct timespec *now)
 
 static int xen_set_wallclock(const struct timespec *now)
 {
-	struct xen_platform_op op;
-	int ret;
-
 	/* do nothing for domU */
 	if (!xen_initial_domain())
 		return -1;
 
-	/* Set the Xen wallclock. */
+	/* Set the hardware RTC. */
+	return mach_set_rtc_mmss(now);
+
+}
+
+static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
+				   void *priv)
+{
+	static struct timespec last, next;
+	struct timespec now;
+	struct timekeeper *tk = priv;
+	struct xen_platform_op op;
+	int ret;
+
+	/*
+	 * Set the Xen wallclock from Linux system time.
+	 *
+	 * dom0 hasn't historically maintained a very accurate
+	 * wallclock so guests don't expect it. We can therefore
+	 * reduce the number of expensive hypercalls by only updating
+	 * the wallclock every 0.5 s.
+	 */
+
+	now.tv_sec = tk->xtime_sec;
+	now.tv_nsec = tk->xtime_nsec >> tk->shift;
+
+	if (timespec_compare(&now, &last) > 0
+	    && timespec_compare(&now, &next) < 0)
+		return 0;
+
 	op.cmd = XENPF_settime;
-	op.u.settime.secs = now->tv_sec;
-	op.u.settime.nsecs = now->tv_nsec;
+	op.u.settime.secs = now.tv_sec;
+	op.u.settime.nsecs = now.tv_nsec;
 	op.u.settime.system_time = xen_clocksource_read();
 
 	ret = HYPERVISOR_dom0_op(&op);
 	if (ret)
-		return ret;
+		return 0;
 
-	/* Set the hardware RTC. */
-	return mach_set_rtc_mmss(now);
+	last = now;
+	next = timespec_add(now, ns_to_timespec(NSEC_PER_SEC / 2));
 
+	return 0;
 }
 
+static struct notifier_block xen_pvclock_gtod_notifier = {
+	.notifier_call = xen_pvclock_gtod_notify,
+};
+
 static struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
 	.rating = 400,
@@ -482,6 +515,9 @@ static void __init xen_time_init(void)
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
+
+	if (xen_initial_domain())
+		pvclock_gtod_register_notifier(&xen_pvclock_gtod_notifier);
 }
 
 void __init xen_init_time_ops(void)
-- 
1.7.2.5

