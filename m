Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964948Ab3CZQP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:15:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53632 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934768Ab3CZPWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 036/150] perf,x86: fix wrmsr_on_cpu() warning on suspend/resume
Date: Tue, 26 Mar 2013 15:18:55 +0000
Message-Id: <1364311249-14454-37-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2a6e06b2aed6995af401dcd4feb5e79a0c7ea554 upstream.

Commit 1d9d8639c063 ("perf,x86: fix kernel crash with PEBS/BTS after
suspend/resume") fixed a crash when doing PEBS performance profiling
after resuming, but in using init_debug_store_on_cpu() to restore the
DS_AREA mtrr it also resulted in a new WARN_ON() triggering.

init_debug_store_on_cpu() uses "wrmsr_on_cpu()", which in turn uses CPU
cross-calls to do the MSR update.  Which is not really valid at the
early resume stage, and the warning is quite reasonable.  Now, it all
happens to _work_, for the simple reason that smp_call_function_single()
ends up just doing the call directly on the CPU when the CPU number
matches, but we really should just do the wrmsr() directly instead.

This duplicates the wrmsr() logic, but hopefully we can just remove the
wrmsr_on_cpu() version eventually.

Reported-and-tested-by: Parag Warudkar <parag.lkml@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 9a9be1e..57a2d80 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -717,8 +717,10 @@ void intel_ds_init(void)
 
 void perf_restore_debug_store(void)
 {
+	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
+
 	if (!x86_pmu.bts && !x86_pmu.pebs)
 		return;
 
-	init_debug_store_on_cpu(smp_processor_id());
+	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }
-- 
1.8.1.2

