Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaAMQDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:03:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53303 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbaAMQDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:03:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Len Brown <len.brown@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 103/208] x86 idle: Repair large-server 50-watt idle-power regression
Date: Mon, 13 Jan 2014 15:59:04 +0000
Message-Id: <1389628849-1614-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

commit 40e2d7f9b5dae048789c64672bf3027fbb663ffa upstream.

Linux 3.10 changed the timing of how thread_info->flags is touched:

	x86: Use generic idle loop
	(7d1a941731fabf27e5fb6edbebb79fe856edb4e5)

This caused Intel NHM-EX and WSM-EX servers to experience a large number
of immediate MONITOR/MWAIT break wakeups, which caused cpuidle to demote
from deep C-states to shallow C-states, which caused these platforms
to experience a significant increase in idle power.

Note that this issue was already present before the commit above,
however, it wasn't seen often enough to be noticed in power measurements.

Here we extend an errata workaround from the Core2 EX "Dunnington"
to extend to NHM-EX and WSM-EX, to prevent these immediate
returns from MWAIT, reducing idle power on these platforms.

While only acpi_idle ran on Dunnington, intel_idle
may also run on these two newer systems.
As of today, there are no other models that are known
to need this tweak.

Link: http://lkml.kernel.org/r/CAJvTdK=%2BaNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com
Signed-off-by: Len Brown <len.brown@intel.com>
Link: http://lkml.kernel.org/r/baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/intel.c | 3 ++-
 drivers/idle/intel_idle.c   | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index ec72995..a51efc9 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -387,7 +387,8 @@ static void init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
-	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
+	if (c->x86 == 6 && cpu_has_clflush &&
+	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
 		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
 
 #ifdef CONFIG_X86_64
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index f116d66..d47bb0f 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -361,6 +361,9 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	if (!current_set_polling_and_test()) {
 
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
-- 
1.8.3.2

