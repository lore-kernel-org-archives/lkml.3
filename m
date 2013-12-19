Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982Ab3LSTvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 14:51:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35425 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab3LSTvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 14:51:36 -0500
Date: Thu, 19 Dec 2013 11:51:23 -0800
From: tip-bot for Len Brown <tipbot@zytor.com>
Message-ID: <tip-40e2d7f9b5dae048789c64672bf3027fbb663ffa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com
In-Reply-To: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
References: <CAJvTdK=+aNN66mYpCGgbHGCHhYQAKx-vB0kJSWjVpsNb_hOAtQ@mail.gmail.com>
	<baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86 idle:
  Repair large-server 50-watt idle-power regression
Git-Commit-ID: 40e2d7f9b5dae048789c64672bf3027fbb663ffa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 19 Dec 2013 11:51:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40e2d7f9b5dae048789c64672bf3027fbb663ffa
Gitweb:     http://git.kernel.org/tip/40e2d7f9b5dae048789c64672bf3027fbb663ffa
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Wed, 18 Dec 2013 16:44:57 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 19 Dec 2013 11:47:39 -0800

x86 idle: Repair large-server 50-watt idle-power regression

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
Cc: <stable@vger.kernel.org> # 3.12.x, 3.11.x, 3.10.x
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c | 3 ++-
 drivers/idle/intel_idle.c   | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index dc1ec0d..ea04b34 100644
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
index 92d1206..f80b700 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -377,6 +377,9 @@ static int intel_idle(struct cpuidle_device *dev,
 
 	if (!current_set_polling_and_test()) {
 
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
