Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287AbaFZRGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:06:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:58678 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757392AbaFZQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 12:58:50 -0400
Message-Id: <20140626165848.128028586@goodmis.org>
User-Agent: quilt/0.63-1
Date: Thu, 26 Jun 2014 12:52:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: [RFA][PATCH 02/27] PM / Sleep: Remove ftrace_stop/start() from suspend and hibernate
References: <20140626165221.736847419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-PM-Sleep-Remove-ftrace_stop-start-from-suspend-and-h.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

ftrace_stop() and ftrace_start() were added to the suspend and hibernate
process because there was some function within the work flow that caused
the system to reboot if it was traced. This function has recently been
found (restore_processor_state()). Now there's no reason to disable
function tracing while we are going into suspend or hibernate, which means
that being able to trace this will help tremendously in debugging any
issues with suspend or hibernate.

This also means that the ftrace_stop/start() functions can be removed
and simplify the function tracing code a bit.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/power/hibernate.c | 6 ------
 kernel/power/suspend.c   | 2 --
 2 files changed, 8 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 49e0a20fd010..ca7b1906c6c8 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -365,7 +365,6 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	suspend_console();
-	ftrace_stop();
 	pm_restrict_gfp_mask();
 
 	error = dpm_suspend(PMSG_FREEZE);
@@ -391,7 +390,6 @@ int hibernation_snapshot(int platform_mode)
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
-	ftrace_start();
 	resume_console();
 	dpm_complete(msg);
 
@@ -494,7 +492,6 @@ int hibernation_restore(int platform_mode)
 
 	pm_prepare_console();
 	suspend_console();
-	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
@@ -502,7 +499,6 @@ int hibernation_restore(int platform_mode)
 		dpm_resume_end(PMSG_RECOVER);
 	}
 	pm_restore_gfp_mask();
-	ftrace_start();
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -529,7 +525,6 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
-	ftrace_stop();
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -573,7 +568,6 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
-	ftrace_start();
 	resume_console();
 
  Close:
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4dd8822f732a..f6623da034d8 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -248,7 +248,6 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 		goto Platform_wake;
 	}
 
-	ftrace_stop();
 	error = disable_nonboot_cpus();
 	if (error || suspend_test(TEST_CPUS))
 		goto Enable_cpus;
@@ -275,7 +274,6 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 
  Enable_cpus:
 	enable_nonboot_cpus();
-	ftrace_start();
 
  Platform_wake:
 	if (need_suspend_ops(state) && suspend_ops->wake)
-- 
2.0.0


