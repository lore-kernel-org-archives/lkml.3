Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab3FSPZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:25:52 -0400
Received: from smtp.citrix.com ([66.165.176.89]:4335 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990Ab3FSPZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:25:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,898,1363132800"; 
   d="scan'208";a="32137907"
From: David Vrabel <david.vrabel@citrix.com>
To: <xen-devel@lists.xen.org>
CC: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/4] xen: disable non-boot VCPUs during suspend
Date: Wed, 19 Jun 2013 16:25:20 +0100
Message-ID: <1371655523-15609-2-git-send-email-david.vrabel@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com>
References: <1371655523-15609-1-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Vrabel <david.vrabel@citrix.com>

syscore_suspend() and syscore_resume() expect there to be only one
online CPU.  e.g., hrtimers_resume() only triggers events for the
current CPU.  Xen's suspend path was leaving all VCPUs online and then
attempting to fixup problems afterwards (e.g., with an explicit call
to clock_was_set() to trigger pending high resolution timers).

Instead, disable non-boot CPUs before calling stop_machine() and
reenable them afterwards.

This is then similar to what the kexec code does before and after a
kexec jump (see kernel_kexec() in kernel/kexec.c).

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 drivers/xen/manage.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..596e55a 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -148,8 +148,19 @@ static void do_suspend(void)
 		si.post = &xen_post_suspend;
 	}
 
+	/*
+	 * syscore_suspend() and syscore_resume() called in
+	 * xen_suspend() above, assume that only the boot CPU is
+	 * online.
+	 */
+	err = disable_nonboot_cpus();
+	if (err)
+		goto out_resume;
+
 	err = stop_machine(xen_suspend, &si, cpumask_of(0));
 
+	enable_nonboot_cpus();
+
 	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 	if (err) {
@@ -166,9 +177,6 @@ out_resume:
 
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
-	/* Make sure timer events get retriggered on all CPUs */
-	clock_was_set();
-
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
-- 
1.7.2.5

