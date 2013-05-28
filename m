Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3E1SX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:23:26 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51454 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3E1SWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:22:53 -0400
X-IronPort-AV: E=Sophos;i="4.87,759,1363132800"; 
   d="scan'208";a="26485990"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86/xen: sync the CMOS RTC as well as the Xen wallclock
Date: Tue, 28 May 2013 19:22:47 +0100
Message-ID: <1369765368-10823-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Adjustments to Xen's persistent_clock via update_persistent_clock()
don't actually persist, as the xen_set_walltime() just notifies other
domN guests that it has been updated, and does not modify the
underlying CMOS clock.

Thus, this patch modifies xen_set_wallclock() so it will set the
underlying CMOS clock when called from dom0, ensuring the
persistent_clock will be correct on the next hardware boot.

Dom0 does not support accessing EFI runtime services and Xen does not
run on Moorsetown platforms so the CMOS RTC is the only supported
hardware clock.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/time.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index a1947ac..4656165 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -14,6 +14,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
 #include <linux/gfp.h>
+#include <linux/mc146818rtc.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
@@ -199,17 +200,25 @@ static void xen_get_wallclock(struct timespec *now)
 static int xen_set_wallclock(const struct timespec *now)
 {
 	struct xen_platform_op op;
+	int ret;
 
 	/* do nothing for domU */
 	if (!xen_initial_domain())
 		return -1;
 
+	/* Set the Xen wallclock. */
 	op.cmd = XENPF_settime;
 	op.u.settime.secs = now->tv_sec;
 	op.u.settime.nsecs = now->tv_nsec;
 	op.u.settime.system_time = xen_clocksource_read();
 
-	return HYPERVISOR_dom0_op(&op);
+	ret = HYPERVISOR_dom0_op(&op);
+	if (ret)
+		return ret;
+
+	/* Set the hardware RTC. */
+	return mach_set_rtc_mmss(now);
+
 }
 
 static struct clocksource xen_clocksource __read_mostly = {
-- 
1.7.2.5

