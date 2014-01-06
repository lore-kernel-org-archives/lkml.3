Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbaAGAE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:04:56 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47486 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaAFWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:39 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Len Brown <len.brown@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.12 048/144] x86 idle: Repair large-server 50-watt idle-power regression
Date: Mon,  6 Jan 2014 14:36:49 -0800
Message-Id: <20140106223746.722812865@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/intel.c |    3 ++-
 drivers/idle/intel_idle.c   |    3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -387,7 +387,8 @@ static void init_intel(struct cpuinfo_x8
 			set_cpu_cap(c, X86_FEATURE_PEBS);
 	}
 
-	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
+	if (c->x86 == 6 && cpu_has_clflush &&
+	    (c->x86_model == 29 || c->x86_model == 46 || c->x86_model == 47))
 		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
 
 #ifdef CONFIG_X86_64
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -361,6 +361,9 @@ static int intel_idle(struct cpuidle_dev
 
 	if (!current_set_polling_and_test()) {
 
+		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
+			clflush((void *)&current_thread_info()->flags);
+
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())


