Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346AbaGSNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:16:27 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:39169 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754422AbaGSNQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:16:11 -0400
Message-Id: <20140719131609.766623414@goodmis.org>
User-Agent: quilt/0.63-1
Date: Sat, 19 Jul 2014 09:15:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [for-next][PATCH 04/32] PM / Sleep: Remove ftrace_stop/start() from suspend and hibernate
References: <20140719131524.009152325@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-PM-Sleep-Remove-ftrace_stop-start-from-suspend-and-h.patch
X-RR-Connecting-IP: 107.14.168.142:25
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

Link: http://lkml.kernel.org/r/1518201.VD9cU33jRU@vostro.rjw.lan

Acked-by: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/power/hibernate.c | 6 ------
 kernel/power/suspend.c   | 2 --
 2 files changed, 8 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index fcc2611d3f14..a9dfa79b6bab 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -371,7 +371,6 @@ int hibernation_snapshot(int platform_mode)
 	}
 
 	suspend_console();
-	ftrace_stop();
 	pm_restrict_gfp_mask();
 
 	error = dpm_suspend(PMSG_FREEZE);
@@ -397,7 +396,6 @@ int hibernation_snapshot(int platform_mode)
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
-	ftrace_start();
 	resume_console();
 	dpm_complete(msg);
 
@@ -500,7 +498,6 @@ int hibernation_restore(int platform_mode)
 
 	pm_prepare_console();
 	suspend_console();
-	ftrace_stop();
 	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
@@ -508,7 +505,6 @@ int hibernation_restore(int platform_mode)
 		dpm_resume_end(PMSG_RECOVER);
 	}
 	pm_restore_gfp_mask();
-	ftrace_start();
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -535,7 +531,6 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
-	ftrace_stop();
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -579,7 +574,6 @@ int hibernation_platform_enter(void)
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
2.0.1


