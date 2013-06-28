Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab3F1VTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:19:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3F1VT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:19:28 -0400
Date: Fri, 28 Jun 2013 14:19:12 -0700
From: tip-bot for David Vrabel <tipbot@zytor.com>
Message-ID: <tip-5584880e44e49c587059801faa2a9f7d22619c48@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, john.stultz@linaro.org,
        xen-devel@lists.xen.org, tglx@linutronix.de, david.vrabel@citrix.com
In-Reply-To: <1372329348-20841-5-git-send-email-david.vrabel@citrix.com>
References: <1372329348-20841-5-git-send-email-david.vrabel@citrix.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] x86: xen:
  Sync the wallclock when the system time is set
Git-Commit-ID: 5584880e44e49c587059801faa2a9f7d22619c48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 28 Jun 2013 14:19:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5584880e44e49c587059801faa2a9f7d22619c48
Gitweb:     http://git.kernel.org/tip/5584880e44e49c587059801faa2a9f7d22619c48
Author:     David Vrabel <david.vrabel@citrix.com>
AuthorDate: Thu, 27 Jun 2013 11:35:47 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2013 23:15:06 +0200

x86: xen: Sync the wallclock when the system time is set

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
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: <xen-devel@lists.xen.org>
Link: http://lkml.kernel.org/r/1372329348-20841-5-git-send-email-david.vrabel@citrix.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/xen/time.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

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
