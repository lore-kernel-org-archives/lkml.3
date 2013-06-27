Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3F0Kf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 06:35:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:13420 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab3F0Kfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 06:35:55 -0400
X-IronPort-AV: E=Sophos;i="4.87,951,1363132800"; 
   d="scan'208";a="33766442"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/5] x86/xen: sync the wallclock when the system time is set
Date: Thu, 27 Jun 2013 11:35:47 +0100
Message-ID: <1372329348-20841-5-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

Currently the Xen wallclock is only updated every 11 minutes if NTP is
synchronized to its clock source (using the sync_cmos_clock() work).
If a guest is started before NTP is synchronized it may see an
incorrect wallclock time.

Use the pvclock_gtod notifier chain to receive a notification when the
system time has changed and update the wallclock to match.

This chain is called on every timer tick and we want to avoid an extra
(expensive) hypercall on every tick.  Because dom0 has historically
never provided a very accurate wallclock and guests do not expect one,
we can do this simply: the wallclock is only updated if the clock was
set.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index a1947ac..3364850 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -14,6 +14,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/math64.h>
 #include <linux/gfp.h>
+#include <linux/pvclock_gtod.h>
 
 #include <asm/pvclock.h>
 #include <asm/xen/hypervisor.h>
@@ -212,6 +213,30 @@ static int xen_set_wallclock(const struct timespec *now)
 	return HYPERVISOR_dom0_op(&op);
 }
 
+static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long was_set,
+				   void *priv)
+{
+	struct timespec now;
+	struct xen_platform_op op;
+
+	if (!was_set)
+		return NOTIFY_OK;
+
+	now = __current_kernel_time();
+
+	op.cmd = XENPF_settime;
+	op.u.settime.secs = now.tv_sec;
+	op.u.settime.nsecs = now.tv_nsec;
+	op.u.settime.system_time = xen_clocksource_read();
+
+	(void)HYPERVISOR_dom0_op(&op);
+	return NOTIFY_OK;
+}
+
+static struct notifier_block xen_pvclock_gtod_notifier = {
+	.notifier_call = xen_pvclock_gtod_notify,
+};
+
 static struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
 	.rating = 400,
@@ -473,6 +498,9 @@ static void __init xen_time_init(void)
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

