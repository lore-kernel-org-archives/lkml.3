Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930Ab3F1VTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:19:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab3F1VTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:19:37 -0400
Date: Fri, 28 Jun 2013 14:19:21 -0700
From: tip-bot for David Vrabel <tipbot@zytor.com>
Message-ID: <tip-47433b8c9d7480a3eebd99df38e857ce85a37cee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1372329348-20841-6-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-6-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86: xen:
  Sync the CMOS RTC as well as the Xen wallclock
Git-Commit-ID: 47433b8c9d7480a3eebd99df38e857ce85a37cee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 14:19:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47433b8c9d7480a3eebd99df38e857ce85a37cee
Gitweb:     http://git.kernel.org/tip/47433b8c9d7480a3eebd99df38e857ce85a37cee
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Thu, 27 Jun 2013 11:35:48 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 23:15:07 +0200

x86: xen: Sync the CMOS RTC as well as the Xen wallclock

Adjustments to Xen's persistent clock via update_persistent_clock()
don't actually persist, as the Xen wallclock is a software only clock
and modifications to it do not modify the underlying CMOS RTC.

The x86_platform.set_wallclock hook is there to keep the hardware RTC
synchronized. On a guest this is pointless.

On Dom0 we can use the native implementaion which actually updates the
hardware RTC, but we still need to keep the software emulation of RTC
for the guests up to date. The subscription to the pvclock_notifier
allows us to emulate this easily. The notifier is called at every tick
and when the clock was set.

Right now we only use that notifier when the clock was set, but due to
the fact that it is called periodically from the timekeeping update
code, we can utilize it to emulate the NTP driven drift compensation
of update_persistant_clock() for the Xen wall (software) clock.

Add a 11 minutes periodic update to the pvclock_gtod notifier callback
to achieve that. The static variable 'next' which maintains that 11
minutes update cycle is protected by the core code serialization so
there is no need to add a Xen specific serialization mechanism.

[ tglx: Massaged changelog and added a few comments ]

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>
Link: http://lkml.kernel.org/r/1372329348-20841-6-git-send-email-david.vrabel@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/xen/time.c | 45 ++++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 3364850..7a5671b 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -199,37 +199,42 @@ static void xen_get_wallclock(struct timespec *now)
 
 static int xen_set_wallclock(const struct timespec *now)
 {
-	struct xen_platform_op op;
-
-	/* do nothing for domU */
-	if (!xen_initial_domain())
-		return -1;
-
-	op.cmd = XENPF_settime;
-	op.u.settime.secs = now->tv_sec;
-	op.u.settime.nsecs = now->tv_nsec;
-	op.u.settime.system_time = xen_clocksource_read();
-
-	return HYPERVISOR_dom0_op(&op);
+	return -1;
 }
 
-static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long was_set,
-				   void *priv)
+static int xen_pvclock_gtod_notify(struct notifier_block *nb,
+				   unsigned long was_set, void *priv)
 {
-	struct timespec now;
-	struct xen_platform_op op;
+	/* Protected by the calling core code serialization */
+	static struct timespec next_sync;
 
-	if (!was_set)
-		return NOTIFY_OK;
+	struct xen_platform_op op;
+	struct timespec now;
 
 	now = __current_kernel_time();
 
+	/*
+	 * We only take the expensive HV call when the clock was set
+	 * or when the 11 minutes RTC synchronization time elapsed.
+	 */
+	if (!was_set && timespec_compare(&now, &next_sync) < 0)
+		return NOTIFY_OK;
+
 	op.cmd = XENPF_settime;
 	op.u.settime.secs = now.tv_sec;
 	op.u.settime.nsecs = now.tv_nsec;
 	op.u.settime.system_time = xen_clocksource_read();
 
 	(void)HYPERVISOR_dom0_op(&op);
+
+	/*
+	 * Move the next drift compensation time 11 minutes
+	 * ahead. That's emulating the sync_cmos_clock() update for
+	 * the hardware RTC.
+	 */
+	next_sync = now;
+	next_sync.tv_sec += 11 * 60;
+
 	return NOTIFY_OK;
 }
 
@@ -513,7 +518,9 @@ void __init xen_init_time_ops(void)
 
 	x86_platform.calibrate_tsc = xen_tsc_khz;
 	x86_platform.get_wallclock = xen_get_wallclock;
-	x86_platform.set_wallclock = xen_set_wallclock;
+	/* Dom0 uses the native method to set the hardware RTC. */
+	if (!xen_initial_domain())
+		x86_platform.set_wallclock = xen_set_wallclock;
 }
 
 #ifdef CONFIG_XEN_PVHVM
