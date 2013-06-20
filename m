Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3FTTRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 15:17:03 -0400
Received: from smtp.citrix.com ([66.165.176.89]:24144 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758243Ab3FTTQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 15:16:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,906,1363132800"; 
   d="scan'208";a="32470384"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/4] x86/xen: sync the wallclock when the system time is stepped
Date: Thu, 20 Jun 2013 20:16:31 +0100
Message-ID: <1371755792-25962-4-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

The Xen wallclock is a software only clock within the Xen hypervisor
that is used by: a) PV guests as the equivalent of a hardware RTC; and
b) the hypervisor as the clock source for the emulated RTC provided to
HVM guests.

Currently the Xen wallclock is only updated every 11 minutes if NTP is
synchronized to its clock source.  If a guest is started before NTP is
synchronized it may see an incorrect wallclock time.

Use the clock_was_set notifier chain to receive a notification when
the system time is stepped and update the wallclock to match the
current system time.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/time.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index a1947ac..ad077ca 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -211,6 +211,25 @@ static int xen_set_wallclock(const struct timespec *now)
 
 	return HYPERVISOR_dom0_op(&op);
 }
+ 
+static int xen_clock_was_set_notify(struct notifier_block *nb, unsigned long unused,
+				    void *priv)
+{
+       struct timespec now;
+
+       /*
+        * Set the Xen wallclock from Linux system time.
+        */
+       now = current_kernel_time();
+       xen_set_wallclock(&now);
+
+       return NOTIFY_OK;
+}
+
+static struct notifier_block xen_clock_was_set_notifier = {
+	.notifier_call = xen_clock_was_set_notify,
+};
+
 
 static struct clocksource xen_clocksource __read_mostly = {
 	.name = "xen",
@@ -473,6 +492,9 @@ static void __init xen_time_init(void)
 	xen_setup_runstate_info(cpu);
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
+
+	if (xen_initial_domain())
+		register_clock_was_set_notifier(&xen_clock_was_set_notifier);
 }
 
 void __init xen_init_time_ops(void)
-- 
1.7.2.5

