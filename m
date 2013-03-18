Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3CRVHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:07:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3CRVHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 43/75] perf,x86: fix wrmsr_on_cpu() warning on suspend/resume
Date: Mon, 18 Mar 2013 14:07:06 -0700
Message-Id: <20130318210513.351864601@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -732,8 +732,10 @@ void intel_ds_init(void)
 
 void perf_restore_debug_store(void)
 {
+	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
+
 	if (!x86_pmu.bts && !x86_pmu.pebs)
 		return;
 
-	init_debug_store_on_cpu(smp_processor_id());
+	wrmsrl(MSR_IA32_DS_AREA, (unsigned long)ds);
 }


