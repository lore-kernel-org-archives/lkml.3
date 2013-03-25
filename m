Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab3CYBme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:42:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33752 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755118Ab3CYBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:14:57 -0400
Message-Id: <20130325010524.599870322@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 003/104] perf,x86: fix wrmsr_on_cpu() warning on suspend/resume
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -739,8 +739,10 @@ void intel_ds_init(void)
 
 void perf_restore_debug_store(void)
 {
+	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
+
 	if (!x86_pmu.bts && !x86_pmu.pebs)
 		return;
 
-	init_debug_store_on_cpu(smp_processor_id());
+	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }


