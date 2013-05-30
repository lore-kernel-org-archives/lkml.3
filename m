Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab3E3OZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:25:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26070 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab3E3OZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:25:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,770,1363132800"; 
   d="scan'208";a="26908088"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86/xen: sync the CMOS RTC as well as the Xen wallclock
Date: Thu, 30 May 2013 15:25:19 +0100
Message-ID: <1369923919-26981-3-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com>
References: <1369923919-26981-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Adjustments to Xen's persistent_clock via update_persistent_clock()
don't actually persist, as the Xen wallclock is just used by domU
guests, and modifications to it do not modify the underlying CMOS RTC.

The x86_platform.set_wallclock hook can be used to keep the hardware
RTC synchronized (as on bare metal).  Because the Xen wallclock is now
kept synchronized by xen_pvclock_gtod_notify() on any system time
change, xen_set_wallclock() need not do this and dom0 can simply use
the native implementation.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 60b7d1f..0e69994 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -199,18 +199,7 @@ static void xen_get_wallclock(struct timespec *now)
 
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
 
 static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
@@ -531,7 +520,9 @@ void __init xen_init_time_ops(void)
 
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

