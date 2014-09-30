Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaI3AJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:09:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63781 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752538AbaI3AJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:09:15 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH 2/5] PM / sleep: Rename platform suspend/resume functions in suspend.c
Date: Tue, 30 Sep 2014 02:22:24 +0200
Message-ID: <10872199.YM2QPZzpET@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1622293.rpSt5UtDk3@vostro.rjw.lan>
References: <1622293.rpSt5UtDk3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rename several local functions related to platform handling during
system suspend resume in suspend.c so that their names better
reflect their roles.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/suspend.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -144,19 +144,19 @@ static int platform_suspend_prepare(susp
 		suspend_ops->prepare() : 0;
 }
 
-static int platform_suspend_prepare_late(suspend_state_t state)
+static int platform_suspend_prepare_noirq(suspend_state_t state)
 {
 	return state != PM_SUSPEND_FREEZE && suspend_ops->prepare_late ?
 		suspend_ops->prepare_late() : 0;
 }
 
-static void platform_suspend_wake(suspend_state_t state)
+static void platform_resume_noirq(suspend_state_t state)
 {
 	if (state != PM_SUSPEND_FREEZE && suspend_ops->wake)
 		suspend_ops->wake();
 }
 
-static void platform_suspend_finish(suspend_state_t state)
+static void platform_resume_finish(suspend_state_t state)
 {
 	if (state != PM_SUSPEND_FREEZE && suspend_ops->finish)
 		suspend_ops->finish();
@@ -172,7 +172,7 @@ static int platform_suspend_begin(suspen
 		return 0;
 }
 
-static void platform_suspend_end(suspend_state_t state)
+static void platform_resume_end(suspend_state_t state)
 {
 	if (state == PM_SUSPEND_FREEZE && freeze_ops && freeze_ops->end)
 		freeze_ops->end();
@@ -180,7 +180,7 @@ static void platform_suspend_end(suspend
 		suspend_ops->end();
 }
 
-static void platform_suspend_recover(suspend_state_t state)
+static void platform_recover(suspend_state_t state)
 {
 	if (state != PM_SUSPEND_FREEZE && suspend_ops->recover)
 		suspend_ops->recover();
@@ -275,7 +275,7 @@ static int suspend_enter(suspend_state_t
 		printk(KERN_ERR "PM: noirq suspend of devices failed\n");
 		goto Devices_early_resume;
 	}
-	error = platform_suspend_prepare_late(state);
+	error = platform_suspend_prepare_noirq(state);
 	if (error)
 		goto Platform_wake;
 
@@ -323,14 +323,14 @@ static int suspend_enter(suspend_state_t
 	enable_nonboot_cpus();
 
  Platform_wake:
-	platform_suspend_wake(state);
+	platform_resume_noirq(state);
 	dpm_resume_noirq(PMSG_RESUME);
 
  Devices_early_resume:
 	dpm_resume_early(PMSG_RESUME);
 
  Platform_finish:
-	platform_suspend_finish(state);
+	platform_resume_finish(state);
 	return error;
 }
 
@@ -374,11 +374,11 @@ int suspend_devices_and_enter(suspend_st
 	trace_suspend_resume(TPS("resume_console"), state, false);
 
  Close:
-	platform_suspend_end(state);
+	platform_resume_end(state);
 	return error;
 
  Recover_platform:
-	platform_suspend_recover(state);
+	platform_recover(state);
 	goto Resume_devices;
 }
 

