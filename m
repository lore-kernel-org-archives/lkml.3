Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3F0Kf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:35:59 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22463 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3F0Kf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:35:57 -0400
X-IronPort-AV: E=Sophos;i="4.87,951,1363132800"; 
   d="scan'208";a="32154651"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] x86/xen: sync the CMOS RTC as well as the Xen wallclock
Date: Thu, 27 Jun 2013 11:35:48 +0100
Message-ID: <1372329348-20841-6-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
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
kept synchronized by pvclock_gtod notifier, xen_set_wallclock() need
not do this and dom0 can simply use the native implementation.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 3364850..20e395a 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -199,37 +199,35 @@ static void xen_get_wallclock(struct timespec *now)
 
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
 
 static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long was_set,
 				   void *priv)
 {
+	static struct timespec next;
 	struct timespec now;
 	struct xen_platform_op op;
 
-	if (!was_set)
-		return NOTIFY_OK;
-
 	now = __current_kernel_time();
 
+	if (!was_set && timespec_compare(&now, &next) < 0)
+		return NOTIFY_OK;
+
 	op.cmd = XENPF_settime;
 	op.u.settime.secs = now.tv_sec;
 	op.u.settime.nsecs = now.tv_nsec;
 	op.u.settime.system_time = xen_clocksource_read();
 
 	(void)HYPERVISOR_dom0_op(&op);
+
+	/*
+	 * Don't update the wallclock for another 11 minutes. This is
+	 * the same period as the sync_cmos_clock() work.
+	 */
+	next = now;
+	next.tv_sec += 11*60;
+
 	return NOTIFY_OK;
 }
 
@@ -513,7 +511,9 @@ void __init xen_init_time_ops(void)
 
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

