Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751246AbaDTV0r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 17:26:47 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50739 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751046AbaDTV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 17:26:44 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Aubrey Li <aubrey.li@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH] PM / suspend: Make cpuidle work in the "freeze" state
Date: Sun, 20 Apr 2014 23:43:01 +0200
Message-ID: <4271849.XeOTooWnSN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The "freeze" system sleep state introduced by commit 7e73c5ae6e79
(PM: Introduce suspend state PM_SUSPEND_FREEZE) requires cpuidle
to be functional when freeze_enter() is executed to work correctly
(that is, to be able to save any more energy than runtime idle),
but that is impossible after commit 8651f97bd951d (PM / cpuidle:
System resume hang fix with cpuidle) which caused cpuidle to be
paused in dpm_suspend_noirq() and resumed in dpm_resume_noirq().

To avoid that problem, add cpuidle_resume() and cpuidle_pause()
to the beginning and the end of freeze_enter(), respectively.

Reported-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 kernel/power/suspend.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
+#include <linux/cpuidle.h>
 #include <linux/syscalls.h>
 #include <linux/gfp.h>
 #include <linux/io.h>
@@ -53,7 +54,9 @@ static void freeze_begin(void)
 
 static void freeze_enter(void)
 {
+	cpuidle_resume();
 	wait_event(suspend_freeze_wait_head, suspend_freeze_wake);
+	cpuidle_pause();
 }
 
 void freeze_wake(void)

