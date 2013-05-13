Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3EMR5D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:57:03 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12675 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3EMR40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:56:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,663,1363132800"; 
   d="scan'208";a="23728918"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        John Stultz <john.stultz@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] x86/xen: sync the CMOS RTC as well as the Xen wallclock
Date: Mon, 13 May 2013 18:56:08 +0100
Message-ID: <1368467768-2316-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

If NTP is used in dom0 and it is synchronized to its clock source,
then the kernel will periodically synchronize the Xen wallclock with
the system time.  Updates to the Xen wallclock do not persist across
reboots, so also synchronize the CMOS RTC (as on bare metal).

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
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

